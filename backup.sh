#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

log()  { echo "[backup] $*"; }
warn() { echo "[backup] WARN: $*" >&2; }

# ── dirs ────────────────────────────────────────────────────────────────────
mkdir -p \
  "$DOTFILES_DIR/gnome" \
  "$DOTFILES_DIR/kitty" \
  "$DOTFILES_DIR/shell" \
  "$DOTFILES_DIR/wallpapers" \
  "$DOTFILES_DIR/packages"

# ── GNOME dconf ─────────────────────────────────────────────────────────────
if command -v dconf &>/dev/null; then
  log "Dumping dconf..."
  dconf dump /org/gnome/ > "$DOTFILES_DIR/gnome/dconf-gnome.ini"
  dconf dump /org/gtk/  > "$DOTFILES_DIR/gnome/dconf-gtk.ini"
else
  warn "dconf not found, skipping GNOME settings"
fi

# ── kitty ───────────────────────────────────────────────────────────────────
KITTY_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
if [[ -d "$KITTY_DIR" ]]; then
  log "Copying kitty config..."
  rsync -a --delete "$KITTY_DIR/" "$DOTFILES_DIR/kitty/"
else
  warn "No kitty config dir found at $KITTY_DIR"
fi

# ── shell configs ────────────────────────────────────────────────────────────
log "Copying shell configs..."

FISH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
if [[ -d "$FISH_DIR" ]]; then
  rsync -a --delete --exclude='fish_history' "$FISH_DIR/" "$DOTFILES_DIR/shell/fish/"
fi

for f in .bashrc .bash_profile .zshrc .zprofile .profile; do
  [[ -f "$HOME/$f" ]] && cp "$HOME/$f" "$DOTFILES_DIR/shell/$f"
done

# starship / zoxide / direnv configs
for cfg in starship.toml; do
  src="${XDG_CONFIG_HOME:-$HOME/.config}/$cfg"
  [[ -f "$src" ]] && cp "$src" "$DOTFILES_DIR/shell/$cfg"
done

# ── wallpaper ────────────────────────────────────────────────────────────────
if command -v dconf &>/dev/null; then
  WP_URI=$(dconf read /org/gnome/desktop/background/picture-uri 2>/dev/null | tr -d "'" | sed 's|file://||')
  WP_DARK=$(dconf read /org/gnome/desktop/background/picture-uri-dark 2>/dev/null | tr -d "'" | sed 's|file://||')

  for wp in "$WP_URI" "$WP_DARK"; do
    [[ -f "$wp" ]] && cp "$wp" "$DOTFILES_DIR/wallpapers/" && log "Copied wallpaper: $wp"
  done
fi

# ── package lists ────────────────────────────────────────────────────────────
log "Generating package lists..."

if command -v pacman &>/dev/null; then
  # explicitly installed, excluding base group
  pacman -Qqen > "$DOTFILES_DIR/packages/pkglist.txt"
  pacman -Qqem > "$DOTFILES_DIR/packages/pkglist-aur.txt"
fi

if command -v flatpak &>/dev/null; then
  flatpak list --app --columns=application > "$DOTFILES_DIR/packages/flatpak.txt"
fi

# ── done ─────────────────────────────────────────────────────────────────────
log "Backup complete (${TIMESTAMP})"
log "  gnome/      → dconf dumps"
log "  kitty/      → kitty config"
log "  shell/      → shell rc files + fish config"
log "  wallpapers/ → current wallpaper(s)"
log "  packages/   → pkglist.txt, pkglist-aur.txt, flatpak.txt"
