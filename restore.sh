#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo "[restore] $*"; }
warn() { echo "[restore] WARN: $*" >&2; }
die()  { echo "[restore] ERROR: $*" >&2; exit 1; }

# ── sanity ───────────────────────────────────────────────────────────────────
[[ "$(id -u)" -eq 0 ]] && die "Run as your normal user, not root."

# ── paru ─────────────────────────────────────────────────────────────────────
if ! command -v paru &>/dev/null; then
  log "Installing paru..."
  sudo pacman -S --needed --noconfirm base-devel git
  TMPDIR=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$TMPDIR/paru"
  (cd "$TMPDIR/paru" && makepkg -si --noconfirm)
  rm -rf "$TMPDIR"
else
  log "paru already installed, skipping"
fi

# ── packages ─────────────────────────────────────────────────────────────────
PKG_DIR="$DOTFILES_DIR/packages"

if [[ -f "$PKG_DIR/pkglist.txt" ]]; then
  log "Installing official packages..."
  sudo pacman -S --needed --noconfirm - < "$PKG_DIR/pkglist.txt" || warn "Some official packages failed"
fi

if [[ -f "$PKG_DIR/pkglist-aur.txt" ]]; then
  log "Installing AUR packages..."
  paru -S --needed --noconfirm - < "$PKG_DIR/pkglist-aur.txt" || warn "Some AUR packages failed"
fi

if command -v flatpak &>/dev/null && [[ -f "$PKG_DIR/flatpak.txt" ]]; then
  log "Installing Flatpak apps..."
  while IFS= read -r app; do
    [[ -z "$app" ]] && continue
    flatpak install --noninteractive flathub "$app" || warn "Flatpak install failed: $app"
  done < "$PKG_DIR/flatpak.txt"
fi

# ── shell configs ────────────────────────────────────────────────────────────
log "Restoring shell configs..."

SHELL_DIR="$DOTFILES_DIR/shell"

for f in .bashrc .bash_profile .zshrc .zprofile .profile; do
  [[ -f "$SHELL_DIR/$f" ]] && cp "$SHELL_DIR/$f" "$HOME/$f" && log "  → $f"
done

if [[ -f "$SHELL_DIR/starship.toml" ]]; then
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
  cp "$SHELL_DIR/starship.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  log "  → starship.toml"
fi

FISH_BACKUP="$SHELL_DIR/fish"
if [[ -d "$FISH_BACKUP" ]]; then
  FISH_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
  mkdir -p "$FISH_DEST"
  rsync -a "$FISH_BACKUP/" "$FISH_DEST/"
  log "  → fish config"
fi

# ── kitty ───────────────────────────────────────────────────────────────────
KITTY_BACKUP="$DOTFILES_DIR/kitty"
if [[ -d "$KITTY_BACKUP" ]]; then
  log "Restoring kitty config..."
  KITTY_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
  mkdir -p "$KITTY_DEST"
  rsync -a "$KITTY_BACKUP/" "$KITTY_DEST/"
fi

# ── wallpaper ────────────────────────────────────────────────────────────────
WP_DIR="$DOTFILES_DIR/wallpapers"
if [[ -d "$WP_DIR" ]] && command -v dconf &>/dev/null; then
  # pick the first image found
  WP_FILE=$(find "$WP_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | head -n1)
  if [[ -n "$WP_FILE" ]]; then
    DEST="$HOME/Pictures/Wallpapers"
    mkdir -p "$DEST"
    cp "$WP_FILE" "$DEST/"
    WP_TARGET="file://$DEST/$(basename "$WP_FILE")"
    dconf write /org/gnome/desktop/background/picture-uri "'$WP_TARGET'"
    dconf write /org/gnome/desktop/background/picture-uri-dark "'$WP_TARGET'"
    log "Wallpaper set: $WP_TARGET"
  fi
fi

# ── GNOME dconf ─────────────────────────────────────────────────────────────
GNOME_DIR="$DOTFILES_DIR/gnome"
if command -v dconf &>/dev/null; then
  if [[ -f "$GNOME_DIR/dconf-gnome.ini" ]]; then
    log "Loading GNOME dconf settings..."
    dconf load /org/gnome/ < "$GNOME_DIR/dconf-gnome.ini"
  fi
  if [[ -f "$GNOME_DIR/dconf-gtk.ini" ]]; then
    log "Loading GTK dconf settings..."
    dconf load /org/gtk/ < "$GNOME_DIR/dconf-gtk.ini"
  fi
else
  warn "dconf not found, skipping GNOME settings"
fi

# ── done ─────────────────────────────────────────────────────────────────────
log "Restore complete. Log out and back in (or reboot) to apply all changes."
