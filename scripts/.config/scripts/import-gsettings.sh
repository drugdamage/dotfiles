#!/bin/bash
# Imports GTK settings into gsettings so apps look correct under Sway
# Called from sway config via exec_always

schema=org.gnome.desktop.interface

gsettings set "$schema" gtk-theme   'Adwaita-dark'
gsettings set "$schema" icon-theme  'Papirus-Dark'
gsettings set "$schema" cursor-theme 'Adwaita'
gsettings set "$schema" font-name   'JetBrainsMono Nerd Font 11'
gsettings set "$schema" color-scheme 'prefer-dark'
