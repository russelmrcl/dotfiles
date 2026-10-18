# Claude Code

Anthropic's CLI coding agent.

## Install

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

The binary lands in `~/.local/bin`. Make sure it is on the PATH (`export PATH="$HOME/.local/bin:$PATH"` in `~/.zshrc`; already in `dotfiles/.zshrc`).

## Log in

```bash
claude
```

Follow the prompt once.

## Verify

```bash
claude --version
```

## Settings and skills from this repo

Custom skills (slash commands) and settings (permissions, hooks) live in `dotfiles/.claude/`:

```bash
mkdir -p ~/.claude
cp dotfiles/.claude/settings.json ~/.claude/settings.json
bash deploy.sh   # copies the skills flat into ~/.claude/skills/<name>/
```

Overview of the skills: [CLAUDE.md](../../CLAUDE.md#claude-code-skills).
How to write your own: [writing-skills.md](writing-skills.md).
Working habits: [best-practices.md](best-practices.md).

## Useful aliases

```bash
alias cc="claude"
alias ccr="claude --resume"
```
