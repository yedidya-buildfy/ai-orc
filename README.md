# AI Orchestrator

Reusable local CLI orchestration for Claude Code, Codex, Gemini, and image-generation workflows.

The goal is simple: install a small toolkit into any project, then let the primary agent consult or delegate through constrained wrapper scripts instead of raw model CLI calls.

## What It Provides

- Repo-aware Codex review through `codex-review`
- Gemini reasoning consultation through `ask-gemini`
- Gemini image generation through `gemini-image`
- Nano-banana and other Gemini image-model requests routed through `gemini-image`
- Codex/OpenAI image generation through `codex-image`
- Claude Code skill instructions under `.claude/skills/multi-model-orchestrator`

## Layout

```text
orchestrator/
  AGENT_RULES.md
  config.example.yml
  bin/
    codex-review
    ask-gemini
    gemini-image
    codex-image
skills/
  multi-model-orchestrator/
    SKILL.md
install.sh
package.json
```

## Requirements

Install and log in to the local CLIs before use:

```bash
codex login
gemini
claude
```

No project API keys are required for the wrapper flow. The wrappers rely on local CLI authentication and whatever image/tool capabilities those CLIs expose.

## Install Into A Project

From this source repo:

```bash
./install.sh /path/to/project
```

From GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- /path/to/project --repo OWNER/REPO
```

Install the latest tagged release or a branch:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- . --repo OWNER/REPO --ref v0.1.0
```

From npm:

```bash
npx @yedidya-dan/ai-orc install .
```

Equivalent explicit binary form:

```bash
npx --package @yedidya-dan/ai-orc ai-orc install .
```

This installs:

```text
/path/to/project/.ai-orchestrator/
/path/to/project/.claude/skills/multi-model-orchestrator/SKILL.md
```

Install only the wrappers, without the Claude skill:

```bash
./install.sh /path/to/project --no-skill
```

## Usage In An Installed Project

Run a repo-aware Codex review:

```bash
.ai-orchestrator/bin/codex-review --prompt "Review this project setup and identify the highest-risk gaps."
```

Ask Gemini for reasoning:

```bash
.ai-orchestrator/bin/ask-gemini --prompt "What are the tradeoffs in this architecture?"
```

Generate an image through Gemini:

```bash
.ai-orchestrator/bin/gemini-image \
  --prompt "A clean product mockup of a CLI orchestration dashboard" \
  --output generated-images/orchestrator-dashboard.png
```

For nano-banana or any other Gemini image-model request, use Gemini image generation. If Gemini's image MCP needs broader permissions, add `--yolo`:

```bash
.ai-orchestrator/bin/gemini-image --yolo \
  --prompt "An astronaut cat floating in space, cinematic lighting, no text" \
  --output generated-images/astronaut-cat.png
```

If Gemini's image MCP is blocked by permissions:

```bash
.ai-orchestrator/bin/gemini-image --yolo \
  --prompt "A clean product mockup of a CLI orchestration dashboard" \
  --output generated-images/orchestrator-dashboard.png
```

Generate an image through Codex/OpenAI:

```bash
.ai-orchestrator/bin/codex-image \
  --prompt "An astronaut cat floating in space, cinematic lighting, no text" \
  --output generated-images/astronaut-cat.png
```

## Safety Model

- `codex-review` runs Codex in read-only sandbox mode.
- `ask-gemini` does not enable auto-approval.
- `gemini-image` may write one requested image file.
- `gemini-image --yolo` enables Gemini full auto-approval and skips Gemini sandboxing; use it only for explicit image-generation requests.
- `codex-image` runs Codex in workspace-write mode so it can save the requested image file.
- No general act/write workflow exists yet.

## Source Repo Testing

When working in this source repo, use:

```bash
orchestrator/bin/codex-review --prompt "Review the toolkit structure."
orchestrator/bin/ask-gemini --prompt "Review the portability tradeoffs."
orchestrator/bin/gemini-image --prompt "A test image" --output generated-images/gemini-test.png
orchestrator/bin/gemini-image --yolo --prompt "A nano-banana style test image" --output generated-images/nano-banana-test.png
orchestrator/bin/codex-image --prompt "A test image" --output generated-images/codex-test.png
```

The root `bin/` directory is kept as a compatibility alias while the package matures.

## Next Power-Ups

1. Add logging for every consultation.
2. Add reusable prompt presets inside the skill.
3. Add a guarded `codex-act` workflow with explicit user approval.
4. Add a config-aware router command.
5. Add optional skill installers for other agent ecosystems.

## Publishing Checklist

1. Test remote install:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/ai-orchestrator/main/install.sh | bash -s -- /tmp/test-project --repo OWNER/ai-orchestrator
```

2. Publish to npm:

```bash
npm publish
```
