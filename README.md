# AI Orchestrator

Reusable local CLI orchestration for Claude Code, Codex, Gemini, and image-generation workflows.

The goal is simple: install a small toolkit into any project, then let the primary agent consult or delegate through constrained wrapper scripts instead of raw model CLI calls.

## What It Provides

- Repo-aware Codex review through `codex-review`
- Gemini reasoning consultation through `ask-gemini`
- Gemini image generation through `gemini-image`
- Nano-banana image generation through `nano-banana-image` as a Gemini image alias
- Codex/OpenAI image generation through `codex-image`
- Thin `CLAUDE.md` and optional `GEMINI.md` templates
- Optional Codex skill instructions under `skills/multi-model-orchestrator`

## Layout

```text
orchestrator/
  AGENT_RULES.md
  config.example.yml
  bin/
    codex-review
    ask-gemini
    gemini-image
    nano-banana-image
    codex-image
templates/
  CLAUDE.md
  GEMINI.md
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

From GitHub after publishing:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- /path/to/project --repo OWNER/REPO
```

Install the latest tagged release or a branch:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- . --repo OWNER/REPO --ref v0.1.0
```

Future npm flow after publishing:

```bash
npx ai-orchestrator install .
```

This installs:

```text
/path/to/project/.ai-orchestrator/
/path/to/project/CLAUDE.md
```

If the target project already has `CLAUDE.md`, the installer keeps it and writes:

```text
CLAUDE.ai-orchestrator.md
```

Install optional Gemini project instructions:

```bash
./install.sh /path/to/project --with-gemini-md
```

Replace existing agent files only when you mean to:

```bash
./install.sh /path/to/project --force-agent-files
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

Generate an image through the nano-banana alias. This uses Gemini image generation with YOLO enabled:

```bash
.ai-orchestrator/bin/nano-banana-image \
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
- `nano-banana-image` delegates to `gemini-image --yolo`.
- `codex-image` runs Codex in workspace-write mode so it can save the requested image file.
- No general act/write workflow exists yet.

## Source Repo Testing

When working in this source repo, use:

```bash
orchestrator/bin/codex-review --prompt "Review the toolkit structure."
orchestrator/bin/ask-gemini --prompt "Review the portability tradeoffs."
orchestrator/bin/gemini-image --prompt "A test image" --output generated-images/gemini-test.png
orchestrator/bin/nano-banana-image --prompt "A test image" --output generated-images/nano-banana-test.png
orchestrator/bin/codex-image --prompt "A test image" --output generated-images/codex-test.png
```

The root `bin/` directory is kept as a compatibility alias while the package matures.

## Next Power-Ups

1. Add logging for every consultation.
2. Add prompt templates.
3. Add a guarded `codex-act` workflow with explicit user approval.
4. Add a config-aware router command.
5. Publish as a GitHub repo with an install URL.
6. Publish an npm package for `npx ai-orchestrator install .`.

## Publishing Checklist

1. Create a GitHub repository, for example `OWNER/ai-orchestrator`.
2. Push this source repo.
3. Test remote install:

```bash
curl -fsSL https://raw.githubusercontent.com/OWNER/ai-orchestrator/main/install.sh | bash -s -- /tmp/test-project --repo OWNER/ai-orchestrator
```

4. Optionally publish to npm after the GitHub install path is stable:

```bash
npm publish
```
