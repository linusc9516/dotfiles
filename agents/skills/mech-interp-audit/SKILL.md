---
name: mech-interp-audit
description: Audit and run mech interp experiments (TransformerLens, SAEs, activation patching). Use for PyTorch interp code, circuit claims, experiment logging.
---

# Mech Interp Audit

## Before code
- State hypothesis in one sentence. State metric. State what result falsifies it.
- Pin: model name, revision, dtype, device, seed, library versions.

## TransformerLens checks
- `HookedTransformer.from_pretrained`: note `fold_ln`, `center_unembed`, `center_writing_weights` defaults. Say if changed.
- Verify tokenization. BOS prepended? Check `model.to_tokens` output, not assumption.
- Verify hook names against `model.hook_dict`. No guessing names.
- Common hooks: `blocks.{l}.hook_resid_pre`, `blocks.{l}.attn.hook_pattern`, `blocks.{l}.hook_mlp_out`.
- Sanity check: patched run with no-op hook must equal clean run (assert allclose).
- Use `torch.no_grad()` unless gradients needed. Free cache: `del cache`.

## Patching / ablation
- Always report both baselines: clean and corrupted.
- Name ablation type: zero, mean, or resample. Never say "ablate" bare.
- Corrupted prompts: same token length. Assert it.
- Metric normalized: (patched - corrupted) / (clean - corrupted).
- Logit diff over raw prob when possible.
- Report n prompts. Report variance or CI. One prompt = anecdote.

## SAE checks
- Record: SAE release/id, layer, hook point, width, L0.
- Report reconstruction loss and spliced-in loss delta. No claim without it.
- Feature label = top activating examples + check negatives. Not name alone.
- Dead/dense feature counts reported.

## Logging (every run)
- Write `runs/<date>-<slug>/config.json`: args, seed, git hash, versions.
- Save raw results (npy/json), not only plots.
- One-line `notes.md`: hypothesis, outcome, next.
- Fixed seed. Note nondeterminism sources (GPU ops, MPS).

## Claims
- Separate: observed / suspected / speculated.
- Circuit claim needs: necessity test + sufficiency test.
- No mechanism story from correlation alone.
