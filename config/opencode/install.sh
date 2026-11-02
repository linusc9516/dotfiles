#!/usr/bin/env bash
set -e

TMP_DIR=$(mktemp -d)
REPO_URL="https://github.com/Weizhena/Deep-Research-skills.git"

echo "Cloning Deep-Research-skills..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

GLOBAL_SKILLS="$HOME/.agents/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"
OPENCODE_AGENTS="$HOME/.config/opencode/agents"
CLAUDE_AGENTS="$HOME/.claude/agents"

mkdir -p "$GLOBAL_SKILLS" "$CLAUDE_SKILLS" "$OPENCODE_AGENTS" "$CLAUDE_AGENTS"

# 1. Install the English skills into ~/.agents/skills (OpenCode / Universal)
echo "Installing skills into $GLOBAL_SKILLS..."
cp -R "$TMP_DIR"/skills/research-codex-en/* "$GLOBAL_SKILLS/"

# 2. Symlink into ~/.claude/skills so Claude Code sees them
echo "Linking skills to $CLAUDE_SKILLS..."
for skill in "$TMP_DIR"/skills/research-codex-en/*; do
  skill_name=$(basename "$skill")
  ln -sf "$GLOBAL_SKILLS/$skill_name" "$CLAUDE_SKILLS/$skill_name"
done

# 3. Copy agent definitions & strategies if present
if [ -d "$TMP_DIR/agents" ]; then
  echo "Installing agent templates..."
  cp -R "$TMP_DIR"/agents/* "$OPENCODE_AGENTS/" 2>/dev/null || true
  cp -R "$TMP_DIR"/agents/* "$CLAUDE_AGENTS/" 2>/dev/null || true
fi

# 4. Clean up temp clone
rm -rf "$TMP_DIR"

echo "Deep Research skills successfully installed across OpenCode and Claude Code!"

