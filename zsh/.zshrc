# ============================================================
#  ~/.zshrc — Zsh configuration
# ============================================================

# ── History ──────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ── Options ──────────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# ── Completion ───────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ── Plugins (installed via pacman / AUR) ─────────────────────
# zsh-autosuggestions
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Aliases ──────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Sway
alias swayr='swaymsg reload'

# System
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# ── Wayland env vars ─────────────────────────────────────────
export MOZ_ENABLE_WAYLAND=1          # Firefox on Wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland  # VS Code, Discord
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# ── XDG ──────────────────────────────────────────────────────
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# ── Starship prompt ──────────────────────────────────────────
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# ── fastfetch on new terminal ────────────────────────────────
# Comment out if you don't want it every time
fastfetch
