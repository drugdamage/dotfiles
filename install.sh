#!/bin/bash
# ============================================================
#  install.sh — run this on Linux after `git clone`
#  Installs all packages and creates symlinks via GNU Stow
# ============================================================

set -e

echo "==> Installing packages..."
sudo pacman -S --needed --noconfirm \
  sway swaybg swaylock swayidle swaynag \
  waybar \
  kitty \
  mako \
  zsh \
  fastfetch \
  ttf-jetbrains-mono-nerd \
  papirus-icon-theme \
  polkit-gnome \
  xdg-desktop-portal-wlr \
  xdg-user-dirs \
  wl-clipboard \
  grim slurp \
  brightnessctl \
  playerctl \
  pavucontrol \
  nm-connection-editor network-manager-applet \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  stow \
  git \
  base-devel

echo "==> Installing AUR packages (requires yay)..."
if command -v yay &>/dev/null; then
  yay -S --needed --noconfirm vicinae-bin
else
  echo "  yay not found — install it first, then run: yay -S vicinae-bin"
fi

echo "==> Creating symlinks with stow..."
cd "$(dirname "$0")"
stow -v sway waybar kitty zsh starship fastfetch mako scripts

echo "==> Setting zsh as default shell..."
chsh -s /bin/zsh

echo "==> Creating XDG dirs..."
xdg-user-dirs-update

echo ""
echo "Done. Log out and start sway."
echo ""
echo "IMPORTANT: Edit ~/.config/sway/config"
echo "  Replace eDP-1 and HDMI-A-1 with your actual monitor names."
echo "  Run: swaymsg -t get_outputs"
