---
description: Hunt down what's missing — stubs, TODOs, untested paths, unfinished work
argument-hint: "[path or area — defaults to the whole project]"
allowed-tools: Bash(git:*), Bash(rg:*), Bash(grep:*), Read, Grep, Glob, Skill
---

WHERE'S THE LAMB SAUCE? Something's missing from this kitchen. Find it.

Scope: **$ARGUMENTS** (empty means the whole project, weighted toward whatever
has changed recently).

Hunt for the things that were started and never finished:

- `TODO`, `FIXME`, `HACK`, `XXX` — and check `git log` for how long they've been
  sitting there. A two-year-old TODO is not a plan, it's a smell.
- Functions that return a stub, a hardcoded value, `null`, or `pass`
- Public behaviour with no test covering it — especially error paths
- `catch {}` / bare `except:` — errors dropped on the floor
- Config, env vars or secrets referenced but never documented
- Docs, READMEs or type signatures that describe something the code stopped doing

Report the worst offenders only — the ones that will actually bite someone —
each with a `path:line` and what it costs when it goes wrong. Rank them. Then
tell the user which one to fix first, and why that one.

Don't pad the list to look thorough. If the kitchen is genuinely clean, say so
and act mildly suspicious about it.
