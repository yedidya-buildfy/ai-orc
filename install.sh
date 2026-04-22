#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  ./install.sh [target-project] [options]

Options:
  --target-dir NAME       Install toolkit into NAME. Default: .ai-orchestrator
  --skill-dir NAME        Install the Claude skill into NAME. Default: .claude/skills
  --no-skill              Do not install the Claude skill.
  --repo OWNER/REPO       GitHub repo to download when running install.sh without local source files.
  --ref REF               Git ref to download for remote installs. Default: main
  --help, -h              Show this help.

Examples:
  ./install.sh /path/to/project
  ./install.sh /path/to/project --target-dir .tools/ai-orchestrator
  ./install.sh /path/to/project --skill-dir .claude/skills
  curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- . --repo OWNER/REPO
USAGE
}

target_project="."
target_dir=".ai-orchestrator"
skill_dir=".claude/skills"
install_skill=1
remote_repo="${AI_ORCHESTRATOR_REPO:-}"
remote_ref="${AI_ORCHESTRATOR_REF:-main}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target-dir)
      if [[ $# -lt 2 ]]; then
        echo "install.sh: --target-dir requires a value" >&2
        exit 2
      fi
      target_dir="$2"
      shift 2
      ;;
    --skill-dir)
      if [[ $# -lt 2 ]]; then
        echo "install.sh: --skill-dir requires a value" >&2
        exit 2
      fi
      skill_dir="$2"
      shift 2
      ;;
    --no-skill)
      install_skill=0
      shift
      ;;
    --repo)
      if [[ $# -lt 2 ]]; then
        echo "install.sh: --repo requires a value" >&2
        exit 2
      fi
      remote_repo="$2"
      shift 2
      ;;
    --ref)
      if [[ $# -lt 2 ]]; then
        echo "install.sh: --ref requires a value" >&2
        exit 2
      fi
      remote_ref="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    -*)
      echo "install.sh: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      target_project="$1"
      shift
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P || pwd)"
source_dir="$script_dir/orchestrator"
skill_source_dir="$script_dir/skills/multi-model-orchestrator"
tmp_source_dir=""

cleanup() {
  if [[ -n "$tmp_source_dir" && -d "$tmp_source_dir" ]]; then
    rm -rf "$tmp_source_dir"
  fi
}
trap cleanup EXIT

download_remote_source() {
  if [[ -z "$remote_repo" ]]; then
    cat >&2 <<'ERROR'
install.sh: local source files were not found, and no --repo was provided.

For remote installs, pass the GitHub repo:
  curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | bash -s -- . --repo OWNER/REPO

Or set:
  AI_ORCHESTRATOR_REPO=OWNER/REPO
ERROR
    exit 1
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "install.sh: curl is required for remote installs" >&2
    exit 127
  fi

  if ! command -v tar >/dev/null 2>&1; then
    echo "install.sh: tar is required for remote installs" >&2
    exit 127
  fi

  tmp_source_dir="$(mktemp -d)"
  local archive="$tmp_source_dir/source.tar.gz"
  local url="https://codeload.github.com/${remote_repo}/tar.gz/${remote_ref}"

  curl -fsSL "$url" -o "$archive"
  tar -xzf "$archive" -C "$tmp_source_dir"

  local extracted
  extracted="$(find "$tmp_source_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"

  if [[ -z "$extracted" || ! -d "$extracted/orchestrator" || ! -d "$extracted/skills/multi-model-orchestrator" ]]; then
    echo "install.sh: downloaded repo does not contain orchestrator/ and skills/multi-model-orchestrator/" >&2
    exit 1
  fi

  source_dir="$extracted/orchestrator"
  skill_source_dir="$extracted/skills/multi-model-orchestrator"
}

render_template() {
  local template_path="$1"
  local content
  content="$(<"$template_path")"
  printf '%s' "${content//\{\{AI_ORCHESTRATOR_DIR\}\}/$target_dir}"
}

if [[ ! -d "$source_dir" || ! -d "$skill_source_dir" ]]; then
  download_remote_source
fi

if [[ ! -d "$target_project" ]]; then
  echo "install.sh: target project is not a directory: $target_project" >&2
  exit 2
fi

target_project="$(cd "$target_project" && pwd -P)"
install_dir="$target_project/$target_dir"

mkdir -p "$install_dir"
cp -R "$source_dir"/. "$install_dir"/
chmod +x "$install_dir"/bin/*

render_template "$source_dir/AGENT_RULES.md" > "$install_dir/AGENT_RULES.md"
render_template "$source_dir/config.example.yml" > "$install_dir/config.example.yml"

if [[ "$install_skill" -eq 1 ]]; then
  skill_install_dir="$target_project/$skill_dir/multi-model-orchestrator"
  mkdir -p "$skill_install_dir"
  cp -R "$skill_source_dir"/. "$skill_install_dir"/
  render_template "$skill_source_dir/SKILL.md" > "$skill_install_dir/SKILL.md"
  echo "Installed Claude skill to ${skill_install_dir#$target_project/}"
fi

echo "Installed AI Orchestrator to ${install_dir#$target_project/}"
echo "Try: ${target_dir}/bin/codex-review --prompt \"Review this project setup.\""
