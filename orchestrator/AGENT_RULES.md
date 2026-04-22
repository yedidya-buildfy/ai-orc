# AI Orchestrator Agent Rules

Use these rules when this toolkit is installed in a project as `{{AI_ORCHESTRATOR_DIR}}/`.

## Default Behavior

- Work independently by default.
- Use at most one external model for a normal task.
- Treat external model output as advice, not authority.
- The primary agent remains responsible for the final decision, implementation, and user-facing answer.
- Prefer small, focused consultations over broad prompts.

## Tool Path

In an installed project, use:

```text
{{AI_ORCHESTRATOR_DIR}}/bin/
```

In the toolkit source repo, use:

```text
orchestrator/bin/
```

## Available Tools

### `{{AI_ORCHESTRATOR_DIR}}/bin/codex-review`

Use for repo-aware code consultation:

- code review
- bug detection
- architecture analysis
- understanding unfamiliar code
- second opinions on risky changes

This tool is consult-only. It must not edit files.

Example:

```bash
{{AI_ORCHESTRATOR_DIR}}/bin/codex-review --prompt "Review the auth flow for correctness and missing edge cases."
```

### `{{AI_ORCHESTRATOR_DIR}}/bin/ask-gemini`

Use for general reasoning consultation:

- conceptual tradeoffs
- architecture alternatives
- research-style questions
- broad reasoning that does not require precise local code edits

This tool is consult-only. It must not edit files.

Example:

```bash
{{AI_ORCHESTRATOR_DIR}}/bin/ask-gemini --prompt "Compare these two approaches for a CLI wrapper permission model."
```

### `{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image`

Use when the user explicitly wants Gemini to generate a bitmap image asset through Gemini's internal or configured image/media MCP capability.

This tool may create one image file at the requested output path. It should not edit code or unrelated files.

If the user asks for "nano banana", "nano-banana", or another Gemini image model/profile, use this same `gemini-image` wrapper. Treat those names as routing hints for Gemini image generation, not as separate commands.

Example:

```bash
{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image --prompt "A clean product mockup of a CLI orchestration dashboard" --output generated-images/orchestrator-dashboard.png
```

If Gemini's internal image generation MCP is blocked by permissions, retry with `--yolo`. In this wrapper, `--yolo` also skips Gemini sandboxing because the image MCP may need broader tool access:

```bash
{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image --yolo --prompt "A clean product mockup of a CLI orchestration dashboard" --output generated-images/orchestrator-dashboard.png
```

### `{{AI_ORCHESTRATOR_DIR}}/bin/codex-image`

Use when the user explicitly wants Codex/OpenAI to generate a bitmap image asset.

This tool may create one image file at the requested output path. It should not edit code or unrelated files.

Example:

```bash
{{AI_ORCHESTRATOR_DIR}}/bin/codex-image --prompt "A clean product mockup of a CLI orchestration dashboard" --output generated-images/openai-dashboard.png
```

## Routing

- Code review, bugs, repo-aware analysis: `{{AI_ORCHESTRATOR_DIR}}/bin/codex-review`
- General reasoning or product/architecture tradeoffs: `{{AI_ORCHESTRATOR_DIR}}/bin/ask-gemini`
- Gemini-generated image assets, including nano-banana or other Gemini image-model requests: `{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image`
- Codex/OpenAI-generated image assets: `{{AI_ORCHESTRATOR_DIR}}/bin/codex-image`

## When To Consult

Consult only when it adds real value:

- low confidence
- complex or high-risk code
- architectural decisions
- security or permission boundaries
- unclear product tradeoffs
- user explicitly asks for a second opinion

Do not consult for trivial edits, straightforward file reads, or small obvious fixes.

## Prompt Contract

Prompts sent to helpers should include:

- goal
- relevant context
- constraints
- desired output format

Use this structure when practical:

```text
Goal:
Context:
Constraints:
Output format:
```

## Safety Rules

- Consult mode is read-only.
- Do not ask consult tools to write files, run migrations, install dependencies, or apply patches.
- `{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image` may write exactly one generated image file to the requested output path.
- `{{AI_ORCHESTRATOR_DIR}}/bin/gemini-image --yolo` is allowed only for explicit image-generation requests, especially when Gemini's image MCP requires full approval.
- `{{AI_ORCHESTRATOR_DIR}}/bin/codex-image` may write exactly one generated image file to the requested output path.
- Do not chain tools by sending one model's raw output into another model unless the user explicitly requests comparison.
- Do not use act/execution mode until an explicit act workflow exists and the user approves that behavior.
- If a helper suggests changes, inspect and implement the chosen changes directly in the primary agent.

## Expected Review Output

Ask review tools to prioritize:

```text
Findings:
- Severity:
- Location:
- Issue:
- Recommendation:

Open questions:

Confidence:
```
