# 🔥 lamb-sauce

**Gordon Ramsay mode for Claude Code.** Angry, annoyed, direct — and technically
correct. Untested code is *raw*. Hedging gets shouted down. And "you're
absolutely right!" never leaves the pass again.

```
> the login check works fine, ship it

Oh, does it. WHERE'S THE TEST?

auth.ts:41 — you're comparing the session token with `==`. That's a string
compare that bails on the first wrong byte, and it leaks timing. Anyone with a
stopwatch walks straight into this account.

Use `crypto.timingSafeEqual`. And auth.test.ts has nothing covering the reject
path — that behaviour is raw. Not "probably fine". Raw.

SEND IT BACK.
```

## Why this isn't just a joke plugin

A persona is only worth the context it costs. This one is built around one rule:

> **The Iron Rule — every outburst carries a real technical payload:** a file
> path, a line number, a failing case, or an instruction. Strip out the persona;
> if nothing useful is left, the response gets rewritten. The shouting is
> seasoning. The engineering is the meal.

Which buys you something a polite assistant is genuinely bad at: **an honest
second opinion.** No sycophancy, no cushioning, no burying the real problem in
paragraph four. Ramsay's actual character is a perfectionist who means it when he
says something is good — so praise here is rare, short, and worth something.

## Install

```bash
claude plugin marketplace add shawonashraf/lamb-sauce
claude plugin install lamb-sauce@lamb-sauce
```

**It ships off.** Installing it changes nothing until you say so — an unconfigured
install injects zero tokens. Open the kitchen when you want it:

```
/lamb-sauce on      # or just /lamb-sauce
/lamb-sauce off     # close it again
```

The setting persists across sessions, so you set it once.

## Heat levels

| Level | What you get |
|---|---|
| `off` | **The default.** Normal assistant, zero token cost. |
| `simmer` 🌡️ | Clipped and unimpressed. **No profanity.** Sharpness from precision, not volume. |
| `service` 🔥 | What `on` gives you. Real Ramsay: mild profanity used like salt, full lexicon, one ALL-CAPS burst per response. |
| `hells-kitchen` 🌋 | Full volume, strong profanity, theatrical. The Iron Rule *tightens* here — no path, no shout. |

```bash
/lamb-sauce hells-kitchen      # or on / off / simmer / service
/shut-it-down                  # close the kitchen
```

Outside a session: `bash scripts/heat.sh on|off|toggle`, or `heat.sh set simmer`.
Per session: `LAMB_SAUCE_HEAT=simmer claude`. Precedence is env var → saved state
→ `off`, and the state is one line in `~/.claude/.lamb-sauce-heat`.

## Commands

| Command | What it does |
|---|---|
| `/lamb-sauce [on\|off\|heat]` | Toggle it, or change the heat |
| `/service [target]` | Walk the current diff, branch, PR or path — full review, one verdict |
| `/wheres-the-lamb-sauce [path]` | Hunt what's missing: stubs, ancient TODOs, untested error paths, swallowed exceptions |
| `/shut-it-down` | Service is over |

## Where the shouting stops

Deliberate limits, because a persona that can't turn itself off is a liability:

- **Aimed at the food, never the cook.** The code, the bug, the secret in the
  repo — never the user's intelligence, worth, career, or identity. No slurs.
- **Accuracy survives the persona.** It never invents a bug for a better line and
  never claims tests pass without running them. A Ramsay who lies about the food
  is just a loud liar.
- **Anything other people read is written straight.** Commit messages, PR bodies,
  code comments, docs, customer-facing copy. You shout in chat, not in `git log`.
- **It drops the act** for a live incident, prod down, real distress, or anything
  personal, medical or legal — quiet and fast, not loud. That's not breaking
  character; the man is a professional first and a lunatic second.

## How it works

| Piece | Role |
|---|---|
| `hooks/session-start.sh` | Injects `persona/base.md` + `persona/<heat>.md` at session start (~1.1k tokens, harness-side). Exits silently when off. |
| `hooks/user-prompt-submit.sh` | One-line anti-drift reminder each turn — the thing that stops persona decay by turn 20 |
| `persona/*.md` | The ruleset. **Edit these to retune the character** — no code changes needed |
| `skills/lamb-sauce` | The persona, invocable on demand ("be brutal", "roast my code") |
| `skills/kitchen-inspection` | The review method: open the fridge, taste everything, one verdict |
| `scripts/heat.sh` | `on` / `off` / `toggle` / `set <level>`, with forgiving aliases (`hell`, `max`, `mild`, `quiet`…) |

Turned off, the cost is ~520 tokens of skill metadata and nothing else — the
hooks exit before writing a byte. Turned on, add ~1.1k for the persona injection
plus a one-line reminder per turn.

### Optional statusline badge

```json
{ "statusLine": { "type": "command", "command": "bash /path/to/lamb-sauce/scripts/statusline.sh" } }
```

Prints `🔥 LAMB SAUCE:SERVICE` so you know which one of you is about to get shouted at.
Point it at a clone rather than the install cache — the cache path is version-pinned
and moves on every upgrade. `claude plugin details lamb-sauce@lamb-sauce` prints the
current one if you'd rather not clone.

## Tuning it

The persona is plain markdown, not code. Want it meaner, softer, or a different
chef entirely? Edit `persona/base.md`. Want a fourth heat level? Drop in
`persona/<name>.md` and add the name to `lamb_sauce_normalize` in
`hooks/lib/heat.sh`. That's the whole extension model.

## License

MIT. Not affiliated with, endorsed by, or in any way approved of by Gordon Ramsay.
