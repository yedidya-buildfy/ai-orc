---
name: "multi-model-orchestrator"
description: "Use when a project has the AI Orchestrator toolkit installed and the agent should consult Codex, Gemini, Gemini image generation, or Codex/OpenAI image generation through local wrapper scripts instead of raw CLI commands."
---

# Multi-Model Orchestrator

Use this skill when the current project contains an AI Orchestrator install, usually:

```text
.ai-orchestrator/
```

## Quick Start

1. Check for `.ai-orchestrator/AGENT_RULES.md`.
2. Read it before calling any external model wrapper.
3. Use wrappers instead of raw CLI commands.

Installed wrapper paths:

```text
.ai-orchestrator/bin/codex-review
.ai-orchestrator/bin/ask-gemini
.ai-orchestrator/bin/gemini-image
.ai-orchestrator/bin/nano-banana-image
.ai-orchestrator/bin/codex-image
```

If working in the toolkit source repo, use:

```text
orchestrator/bin/codex-review
orchestrator/bin/ask-gemini
orchestrator/bin/gemini-image
orchestrator/bin/nano-banana-image
orchestrator/bin/codex-image
```

## Routing

- Repo-aware code review: `codex-review`
- Gemini reasoning or product/architecture consultation: `ask-gemini`
- Gemini-generated image asset: `gemini-image`
- Nano-banana image request: `nano-banana-image` (Gemini image alias)
- OpenAI/Codex-generated image asset: `codex-image`

## Safety

- Consult wrappers are read-only.
- Image wrappers may write exactly one requested image file.
- Use `gemini-image --yolo` only for explicit image generation when Gemini's image MCP is blocked by permissions.
- Do not call raw `gemini --yolo`, raw `codex exec`, or ad hoc image tools when an orchestrator wrapper exists.
- Do not start act/write workflows unless the user explicitly approves that behavior.

## Missing Toolkit

If `.ai-orchestrator/` is missing, tell the user the toolkit is not installed in this project and suggest installing it from the source repo with:

```bash
./install.sh /path/to/project
```
