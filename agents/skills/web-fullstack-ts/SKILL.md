---
name: web-fullstack-ts
description: Build and review TypeScript + Tailwind web code. Strict types, small components, no boilerplate. Use for React/Next/Vite frontend work.
---

# Web Fullstack TS

## First
- Read `package.json`, `tsconfig.json`, Tailwind config. Note framework and Tailwind version (v3 vs v4).
- Match existing patterns. Grep for similar component before writing new.

## TypeScript
- `strict` on. No `any`. Use `unknown` + narrow.
- Model states as discriminated unions, not boolean flags.
- Props typed explicitly. Derive types from schema (zod) at boundaries.
- No non-null `!` without comment why safe.
- Validate all external input (API, forms, env).

## Components
- One job per component. Split when it passes ~150 lines or two concerns.
- State lives at lowest common parent. No prop drilling past 2 levels: lift or use context.
- Server vs client: default server (if framework supports). `"use client"` only where needed.
- No useEffect for derived state. Compute in render.
- Keys stable. Never index for reorderable lists.
- Accessible: semantic tags, label on inputs, focus visible, alt text.

## Tailwind
- Utilities in markup. No `@apply` except base resets.
- Extract component, not class string.
- Use design tokens from config. Arbitrary values `[...]` only if no token fits.
- Mobile first. Add `sm:` `md:` up.
- No inline styles unless dynamic value.
- v4: CSS-first config (`@import "tailwindcss"`). Do not write v3 `tailwind.config.js` patterns.

## Verify
- `npx tsc --noEmit`
- Lint script from package.json
- Build once before done.

## Ban
- Placeholder lorem, fake testimonials, gradient-blob hero, emoji bullets, wrapper divs with no purpose.
