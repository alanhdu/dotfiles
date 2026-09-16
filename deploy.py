#!/usr/bin/env python3
from pathlib import Path

links = [
    ("agents", "~/.agents"),
    ("agents/skills", "~/.claude/skills"),
    ("claude/CLAUDE.md", "~/.claude/CLAUDE.md"),
    ("claude/agents", "~/.claude/agents"),
    ("jj/config.toml", "~/.config/jj/config.toml"),
    ("gitconfig", "~/.gitconfig"),
    ("gitignore", "~/.gitignore"),
    ("nvim", "~/.config/nvim"),
    ("redshift.conf", "~/.config/redshift.conf"),
    ("irbrc", "~/.irbrc"),
    ("vscode/settings.json", "~/.config/Code/User/settings.json"),
    ("vscode/keybindings.json", "~/.config/Code/User/keybindings.json"),
]

repo = Path(__file__).resolve().parent

for src, dest in links:
    src = repo / src
    dest = Path(dest).expanduser()
    if not src.exists():
        raise FileNotFoundError(f"Cannot deploy missing path: {src}")
    if not dest.exists() and not dest.is_symlink():
        dest.parent.mkdir(parents=True, exist_ok=True)
        print("Symlinking", src, "to", dest)
        dest.symlink_to(src, target_is_directory=src.is_dir())
