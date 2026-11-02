---
name: arxiv-cite-integrity
description: Verify papers and citations before use. Blocks fabricated refs, wrong IDs, invented numbers. Use when citing arXiv or summarizing papers.
---

# arXiv Cite Integrity

## Rules
- Never cite from memory. Verify every reference.
- Lookup: `curl -s "https://export.arxiv.org/api/query?id_list=<ID>"`. Or search by title via same API.
- Check: title, authors, year, version match claim.
- Cannot verify? Mark `[UNVERIFIED]`. Do not drop it in silently.
- No invented numbers, benchmarks, or quotes. Number must come from the paper text. Give section/table.
- Quote under 15 words. Else paraphrase.

## Record format
- `arXiv:<id>v<n> | Title | First Author et al. | Year`
- Claim used, location in paper (sec/table/fig).
- Status: verified / unverified / read-abstract-only.

## Summaries
- Say what was read: abstract only, or full text.
- Separate paper's claim from your reading of it.
- Note if later version, errata, or failed replication exists (search).

## BibTeX
- Generate from API metadata, not memory.
- Key: `firstauthorYEARword`.
- Dedupe by arXiv ID.

## Final check
- Count refs in text vs refs in bib. Must match.
- List all `[UNVERIFIED]` at end of output.
