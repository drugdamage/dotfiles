# dotfiles

Sway rice — Catppuccin Mocha · CachyOS · Katana GF66

## Stack

| Component | Tool |
|---|---|
| WM | Sway |
| Terminal | Kitty |
| Launcher | Vicinae |
| Bar | Waybar |
| Shell | Zsh + Starship |
| Notifications | Mako |
| Fetch | fastfetch |
| Theme | Catppuccin Mocha |

## Install (on Linux)

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

After install, edit `~/.config/sway/config`:

1. Run `swaymsg -t get_outputs` to get your monitor names
2. Replace `eDP-1` and `HDMI-A-1` with your actual output names

Then start Sway:

```bash
exec sway
```

## Structure

```
dotfiles/
├── sway/        → ~/.config/sway/
├── waybar/      → ~/.config/waybar/
├── kitty/       → ~/.config/kitty/
├── zsh/         → ~/   (.zshrc)
├── starship/    → ~/.config/
├── fastfetch/   → ~/.config/fastfetch/
├── mako/        → ~/.config/mako/
├── scripts/     → ~/.config/scripts/
└── install.sh
```

## Keybindings

| Key | Action |
|---|---|
| `Super + Enter` | Terminal (kitty) |
| `Super + Space` | Launcher (vicinae) |
| `Super + Q` | Close window |
| `Super + H/J/K/L` | Focus (vim-style) |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + F` | Fullscreen |
| `Super + Shift + Space` | Toggle floating |
| `Super + 1–8` | Switch workspace |
| `Super + Shift + 1–8` | Move to workspace |
| `Super + Shift + S` | Screenshot (area) |
| `Super + Shift + L` | Lock screen |
| `Super + Shift + C` | Reload Sway config |
| `Super + R` | Resize mode |
