#!/usr/bin/env bash

# Colors
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

function msg() {
    echo -e "${YELLOW}"
    echo "🚀 $1"
    echo -e "${NC}"
}

function error() {
    echo -e "${RED}"
    echo "🛑 $1"
    echo -e "${NC}"
}

msg "Starting global system update"

msg "Updating and cleaning system packages"
# rate mirrors if overwritten by update
#sudo cachyos-rate-mirrors
#sudo pacman -Syyu
paru -Syu # Update
#paru -Sc # Clean uninstalled packages cache and old versions
sudo pacman -Rs $(sudo pacman -Qdtq) # Remove dependencies that are no longer needed (list them with pacman -Qdt)

#msg "Updating snap packages"
#sudo snap refresh 


# Python
if command -v pipx &> /dev/null; then
    msg "Updating global python apps with pipx"
    pipx upgrade-all
fi

# LuaRocks
if command -v luarocks &> /dev/null; then
    msg "Updating LuaRocks"
    for rock in $(luarocks list --outdated --porcelain | cut -f1); do
        msg "Upgrading ${}rock}"
        sudo luarocks install "$rock"
    done
fi

# Rust (Cargo)
if command -v cargo &> /dev/null; then
    msg "Updating Cargo binaries"
    cargo install-update -a
fi

# Composer
if command -v composer &> /dev/null; then
    msg "Updating composer and global packages"
    composer self-update
    composer global update
fi

# Npm
#if [ -s "$NVM_DIR/nvm.sh" ]; then
#    msg "Updating NPM and global packages"
#    npm install -g npm@latest
#    npm update -g
#fi

# ZSH
#msg "Updating ZSH + plugins"
#OH_MY_ZSH="${ZSH:-$HOME/.oh-my-zsh}"
#ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH/custom}"
#repositories=(
#    "$OH_MY_ZSH"
#    "$ZSH_CUSTOM/themes/powerlevel10k"
#    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
#    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
#    "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
#)
#updated=0
#unchanged=0
#skipped=0
#failed=0
#update_repository() {
#    local repository="$1"
#    local name
#    name="$(basename "$repository")"
#    printf '\n==> Updating %s\n' "$name"
#    if [[ ! -d "$repository" ]]; then
#        echo "Skipped: directory does not exist: $repository"
#        ((skipped++))
#        return
#    fi
#    if [[ ! -d "$repository/.git" ]]; then
#        echo "Skipped: not a Git repository: $repository"
#        ((skipped++))
#        return
#    fi
#    if ! git -C "$repository" diff --quiet ||
#       ! git -C "$repository" diff --cached --quiet; then
#        echo "Skipped: repository contains uncommitted changes."
#        ((skipped++))
#        return
#    fi
#    local current_branch
#    current_branch="$(git -C "$repository" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
#    if [[ -z "$current_branch" ]]; then
#        echo "Skipped: repository is in detached HEAD state."
#        ((skipped++))
#        return
#    fi
#    local before
#    local after
#    before="$(git -C "$repository" rev-parse HEAD)"
#    if ! git -C "$repository" fetch --prune origin; then
#        echo "Failed: could not fetch updates."
#        ((failed++))
#        return
#    fi
#    if ! git -C "$repository" pull --ff-only origin "$current_branch"; then
#        echo "Failed: repository could not be fast-forwarded."
#        ((failed++))
#        return
#    fi
#    after="$(git -C "$repository" rev-parse HEAD)"
#    if [[ "$before" == "$after" ]]; then
#        echo "Already up to date."
#        ((unchanged++))
#    else
#        echo "Updated successfully."
#        ((updated++))
#    fi
#}
#for repository in "${repositories[@]}"; do
#    update_repository "$repository"
#done
#printf '\nZSH summary\n'
#printf '  Updated:    %d\n' "$updated"
#printf '  Unchanged:  %d\n' "$unchanged"
#printf '  Skipped:    %d\n' "$skipped"
#printf '  Failed:     %d\n' "$failed"


# Neovim
#msg "Updating neovim"
#bob install stable
#bob use stable

# .pacnew Check
PACNEW=$(find /etc -regextype posix-extended -regex ".+\.pac(new|save)" 2>/dev/null)
if [ -n "$PACNEW" ]; then
    error "WARNING: The following configuration updates require your attention:"
    echo "$PACNEW"
    msg "Tip: Use 'pacdiff' or 'meld' to merge these changes."
fi

msg "Global system update complete!"
