---
name: "multi-model-orchestrator"
description: "Use when a project has the AI Orchestrator toolkit installed and the agent should consult Codex, Gemini, Gemini image generation, or Codex/OpenAI image generation through local wrapper scripts instead of raw CLI commands."
---

# Multi-Model Orchestrator

Use this skill when the current project contains an AI Orchestrator install, usually:

```text
{{AI_ORCHESTRATOR_DIR}}/
```

## Quick Start

1. Check for `{{AI_ORCHESTRATOR_DIR}}/AGENT_RULES.md`.
2. Read it before calling any external model wrapper.
3. Use wrappers instead of raw CLI commands.

Installed wrapper paths:

```text
{{AI_ORCHESTRATOR_DIR}}/bin/codex-review
{{AI_ORCHESTRATOR_DIR}}/bin/ask-gemini
{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image
{{AI_ORCHESTRATOR_DIR}}/bin/codex-image
```

If working in the toolkit source repo, use:

```text
orchestrator/bin/codex-review
orchestrator/bin/ask-gemini
orchestrator/bin/gemini-image
orchestrator/bin/codex-image
```

## Routing

- Repo-aware code review: `codex-review`
- Gemini reasoning or product/architecture consultation: `ask-gemini`
- Gemini-generated image asset, including nano-banana requests: `gemini-image`
- OpenAI/Codex-generated image asset: `codex-image`

## Safety

- Consult wrappers are read-only.
- Image wrappers may write exactly one requested image file.
- Use `gemini-image --yolo` only for explicit image generation when Gemini's image MCP is blocked by permissions.
- Do not call raw `gemini --yolo`, raw `codex exec`, or ad hoc image tools when an orchestrator wrapper exists.
- Do not start act/write workflows unless the user explicitly approves that behavior.

## Missing Toolkit

If `{{AI_ORCHESTRATOR_DIR}}/` is missing, tell the user the toolkit is not installed in this project and suggest installing it from the source repo with:

```bash
./install.sh /path/to/project
```
