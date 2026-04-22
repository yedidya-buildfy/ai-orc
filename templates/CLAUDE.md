# AI Orchestrator

This project uses the AI Orchestrator toolkit installed at `{{AI_ORCHESTRATOR_DIR}}/`.

Before using external model tools, read:

```text
{{AI_ORCHESTRATOR_DIR}}/AGENT_RULES.md
```

Use the toolkit wrappers instead of raw model CLI calls:

- `{{AI_ORCHESTRATOR_DIR}}/bin/codex-review`
- `{{AI_ORCHESTRATOR_DIR}}/bin/ask-gemini`
- `{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image`
- `{{AI_ORCHESTRATOR_DIR}}/bin/nano-banana-image`
- `{{AI_ORCHESTRATOR_DIR}}/bin/codex-image`

Prefer wrappers over raw `gemini --yolo`, raw `codex exec`, or ad hoc image-generation commands.
