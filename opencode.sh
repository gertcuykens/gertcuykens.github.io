#!/bin/zsh
set -eEuxo pipefail

# opencode mcp add
# opencode debug paths
# opencode debug lsp diagnostics label/main.py --print-logs --log-level DEBUG
# opencode debug config
# jq . ~/.config/opencode/opencode.json

# opencode run --print-logs "hello" 2>&1 | grep -i "plugin"
# opencode debug skill
# tail -f ~/.local/share/opencode/log/$(ls -t ~/.local/share/opencode/log/ | head -1)

mkdir -p ~/.config/opencode/skills/uv
mkdir -p ~/.config/opencode/skills/ruff
mkdir -p ~/.config/opencode/skills/ty

curl -fsSLo ~/.config/opencode/skills/uv/SKILL.md https://raw.githubusercontent.com/astral-sh/claude-code-plugins/refs/heads/main/plugins/astral/skills/uv/SKILL.md
curl -fsSLo ~/.config/opencode/skills/ruff/SKILL.md https://raw.githubusercontent.com/astral-sh/claude-code-plugins/refs/heads/main/plugins/astral/skills/ruff/SKILL.md
curl -fsSLo ~/.config/opencode/skills/ty/SKILL.md https://raw.githubusercontent.com/astral-sh/claude-code-plugins/refs/heads/main/plugins/astral/skills/ty/SKILL.md

