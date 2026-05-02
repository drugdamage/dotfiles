# dotfiles

![demo](demo.gif)

---

## System

| | |
|---|---|
| **OS** | CachyOS (Arch-based) |
| **WM / DE** | GNOME |
| **Terminal** | Kitty |
| **Shell** | Fish |
| **AUR helper** | paru |

---

## Contents

```
dotfiles/
├── backup.sh          collect configs from the running system
├── restore.sh         rebuild the system on a fresh install
├── gnome/
│   ├── dconf-gnome.ini   dconf dump /org/gnome/
│   └── dconf-gtk.ini     dconf dump /org/gtk/
├── kitty/             ~/.config/kitty/
├── shell/
│   ├── fish/          ~/.config/fish/
│   ├── .bashrc
│   ├── .zshrc
│   └── starship.toml
├── wallpapers/        active desktop wallpaper(s)
└── packages/
    ├── pkglist.txt       explicit pacman packages
    ├── pkglist-aur.txt   AUR packages
    └── flatpak.txt       Flatpak app IDs
```

---

## Backup

Run on any existing install to snapshot the current state:

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./backup.sh
git add -A && git commit -m "snapshot $(date +%Y-%m-%d)"
git push
```

---

## Restore (fresh CachyOS install)

```sh
# 1. clone
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# 2. run — installs paru, packages, and restores all configs
./restore.sh

# 3. reboot
sudo reboot
```

`restore.sh` will:
1. Install **paru** from the AUR if missing
2. Restore all pacman + AUR packages from `packages/pkglist.txt`
3. Install Flatpak apps listed in `packages/flatpak.txt`
4. Place fish, bash, and zsh configs in the correct locations
5. Copy kitty config to `~/.config/kitty/`
6. Copy the wallpaper and set it via dconf
7. Load GNOME and GTK settings from the dconf dumps
