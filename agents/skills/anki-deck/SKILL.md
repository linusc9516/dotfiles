---
name: anki-deck
description: >
  Build a flashcard deck from source PDFs/slides and add it to Anki safely. Covers
  sourcing rules, card design, calculation verification, AnkiConnect write safety, and
  exam-crunch scheduling. Use when asked to create, generate, or populate an Anki deck
  from course material, notes, slides, or a reading list, or to tune deck options for a
  specific test date.
---

# anki-deck

Building a deck means two independent jobs: getting the content right, and not
corrupting the existing Anki collection while adding it. Most failures come from the
second.

Load the `anki-connect` skill for API details. This skill covers process and decisions.

## 1. Scope before writing anything

State in one message, before any Anki write:

- Deck name; if it already exists, stop and ask.
- Note type. Use a built-in ("Basic") unless told otherwise. Never create note types
  unasked.
- Planned note count, and count per topic tag.
- Whether deck *options* will be touched. These need a separate yes: a config group is
  not part of "add a deck".

Verify connectivity first: `requestPermission`, then `deckNames`.

## 2. Sourcing

- Lecture slides are authoritative; notes supplement. Where they disagree, follow the
  slides and list the conflict in the report.
- Use only content present in the sources. If something is unclear, flag it — do not
  fill the gap with plausible general knowledge.
- Every card ends with `Source: <file> p.<page>` or `<file> s.<section>`. Verify the
  page number against the rendered page, not the PDF index.
- Check for slide-internal errors (a traversal that contradicts its own diagram, two
  definitions of one term). Do not build a card on a broken example; note it instead.
- Excluded topics stay excluded. Do not add "just in case" cards.

## 3. Card design

- One idea per card. Front answerable without the source open.
- Merge overlapping material; no near-duplicates. Dedupe by meaning, not by wording.
- Vary the type: definition, compare/contrast, complexity table, formula, trap.
  Calculations at roughly 10-15% of the deck unless asked otherwise.
- Traps and misconceptions earn their place; they are what MCQs test.
- No "write code" cards. Short code-reading cards are fine.

## 4. Verify every calculation

- Recompute each one step by step. Show the intermediate values in the answer.
- Re-read the final answer text for leftover working ("wait, that's wrong", scratch
  arithmetic). Answer fields ship as written.
- Check the answer matches the question asked (which slot vs which key, how many words
  vs which words).

## 5. AnkiConnect write safety

These are the rules that prevent damage. Follow them literally.

**Read config groups by id, never by deck name.**

`getDeckConfig(deck=X)` resolves through the deck's *current* assignment. If the deck
has not yet been pointed at the new group, it returns the inherited group — usually
`Default` — and any `saveDeckConfig` then edits every deck sharing it. Assign the group
to the deck first, or match candidate configs on `cfg["id"]`.

**Never write to a shared options group.** `Default` is used by an unknown number of
decks. Editing it changes all of them. To customise: clone to a new group, assign that
group to the target deck only, then edit. Re-read the deck's config afterwards and
confirm the id changed.

**Check `saveDeckConfig`'s return value.** `false` means the write did not apply. Do not
assume success from absence of an error.

**Avoid modifying a group you did not create** unless the user names that group and
approves the specific fields. Report every field changed.

**Before inserting notes:**

1. `canAddNotesWithErrorDetail` on the full batch.
2. Any `canAdd: false` with "duplicate" — Anki's duplicate check matches substrings of
   the Front field, so a reworded front can still collide. Rename or confirm.
3. Insert in batches of ~25.
4. After insert: `findNotes` for the deck, count vs planned, `notesInfo` to confirm tags
   and that every Back contains `Source:`.

**Deleting or replacing a note.** Only inside the deck just created, only to fix your own
error, and report it. Never touch notes outside the deck.

**Never** create/delete decks, models, media, tags, or settings outside the task scope
without an explicit yes.

## 6. Scheduling for a fixed exam date

Default for a test within a week: **do not tune intervals.** Set `new.perDay` high enough
to unblock the deck (on a per-deck cloned group), then run a manual pass close to the
test.

- Browse → select all → **Preview** for the final pass. Preview does not touch
  scheduling, reset intervals, or create a backlog.
- Anki's spaced repetition is designed for months. Engineering intervals for a 3-day
  horizon costs more than the manual pass it replaces.

If the user insists on scheduler-level tuning:

- Clone the group; assign to one deck; never edit `Default`.
- `desiredRetention` is preset-level and needs a trained or default parameter set to
  matter. With `fsrsWeights: []` the group uses Anki's default parameters.
- `fsrsWeights` empty does **not** prove FSRS is off — the global toggle is not exposed
  in the `getDeckConfig` payload. Ask, or check the UI.
- Where the UI hides fields ("Reset" arrow), the API may still accept them. Ask whether
  the user applied a setting manually before treating an unexpected value as drift.

## 7. Reporting

Report, in this order:

1. Deck name, total notes, per-topic counts, per-type counts.
2. Verification evidence: planned vs inserted, any failures.
3. Source conflicts and how resolved.
4. Out-of-scope material excluded.
5. Genuine gaps — things asked for that the sources do not cover.
6. Anything in Anki state changed outside the deck.

Separate "done and verified" from "believed correct". If a check was not run, say so.
