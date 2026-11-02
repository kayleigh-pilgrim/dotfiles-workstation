#!/usr/bin/env bash

###########################
# VARIABLES AND FUNCTIONS #
###########################

#
# Colors
#
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

#
# Show a message
#
function msg() {
    echo -e "${YELLOW}"
    echo ">> $1"
    echo -e "${NC}"
}

#
# Show an error
#
function error() {
    echo -e "${RED}"
    echo ">> $1"
    echo -e "${NC}"
}

#
# Dotfiles directory
#
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"




################
# SCRIPT START #
################

#
# 1Password GPG key
#
onepassword_key_fingerprint="3FEF9748469ADBE15DA7CA80AC2D62742012EA22"
if ! gpg --list-keys "$onepassword_key_fingerprint" >/dev/null 2>&1; then
    msg "Adding 1Password GPG key"
    curl -fsS https://downloads.1password.com/linux/keys/1password.asc |
        gpg --import
fi

#
# Install not-yet-installed packages using paru
#
msg "Installing packages"
sudo pacman -S --needed paru
paru -S --needed \
    mc \
    yay \
    rclone \
    zsh \
    tor \
    git \
    git-delta \
    github-cli \
    php \
    php-sqlite \
    php-fpm \
    php-gd \
    php-imagick \
    php-pgsql \
    php-redis \
    valkey \
    composer \
    nodejs \
    npm \
    neovim \
    bat \
    fzf \
    ripgrep \
    tmux \
    htop \
    btop \
    lm_sensors \
    rsync \
    gnupg \
    zoxide \
    tailscale \
    dbeaver \
    lolcat \
    deno \
    rustup \
    cargo-update \
    stylua \
    lua \
    luarocks \
    luacheck \
    docker-compose \
    docker \
    docker-buildx \
    containerd \
    httpie \
    ruby \
    python \
    python-pipx \
    go \
    mtr \
    tree \
    bc \
    lsb-release \
    pinentry \
    direnv \
    fd \
    jq \
    yq \
    bottom \
    astyle \
    shellcheck \
    base-devel \
    clang \
    kitty \
    ruff \
    clamav \
    rkhunter \
    syncthing \
    cherrytree \
    wireshark-qt \
    wireshark-cli \
    nmap \
    zenmap \
    radare2 \
    r2ghidra \
    hydra \
    gobuster \
    john \
    hashcat \
    hashcat-utils \
    metasploit \
    postgresql \
    nasm \
    gdb \
    strace \
    binutils \
    remmina \
    v4l-utils \
    v4l2loopback-dkms \
    v4l2loopback-utils \
    linux-lts-headers \
    icu \
    libxml2 \
    libxml2-legacy \
    flite \
    qemu-desktop \
    libvirt \
    virt-manager \
    dnsmasq \
    edk2-ovmf \
    1password \
    google-chrome \
    slack-desktop-wayland-jetm \
    postman-bin \
    insomnia \
    proselint \
    multitail \
    mailpit \
    gitlint \
    prettierd \
    tailwindcss-language-server \
    vue-language-server \
    bash-language-server \
    eslint-language-server \
    emmet-language-server \
    eslint_d \
    nodejs-intelephense \
    npm-check-updates \
    tree-sitter-cli \
    typescript \
    stylelint \
    eza \
    icu74 \
    playwright-webkit-flite-deps \
    asm-lsp \
    bless \
    squawker-vpn-bin \
    responder \
    evil-winrm-py \
    notion \
    xsel \
    terminator \
    openvpn \
    subfinder \
    testssl.sh \
    azure-cli \
    aws-cli \
    bloodyad \
    valgrind \
    tailscale \
    nodejs \
    npm \
    dnsproxy \
    bind \
    faugus-launcher \
    goverlay \
    heroic-games-launcher \
    lutris \
    steam \
    winboat \
    protontricks \
    winetricks \
    brave-bin \
    torbrowser-launcher \
    vivaldi \
    chromium \
    signal-desktop \
    discord \
    telegram-desktop \
    code \
    aisleriot \
    darktable \
    digikam \
    gimp \
    coolercontrol \
    openrgb \
    thunderbird \
    thunderbird-dark-reader \
    shortwave \
    libreoffice-fresh \
    obs-studio \
    kdenlive \
    shotcut \
    vlc \
    virt-manager

#
# Initialize PostgreSQL if not already initialized
#
if ! sudo test -d /var/lib/postgres/data; then
    msg "Initializing PostgreSQL"
    sudo mkdir -p /var/lib/postgres/data
    sudo chown -R postgres:postgres /var/lib/postgres
    sudo chmod 0700 /var/lib/postgres /var/lib/postgres/data
    sudo chage -E -1 postgres
    sudo -u postgres /usr/bin/initdb \
        --locale=C.UTF-8 \
        --encoding=UTF8 \
        --data-checksums \
        --auth-local=peer \
        --auth-host=scram-sha-256 \
        -D /var/lib/postgres/data
fi

#
# Enable and start services
#
for unit in valkey.service libvirtd.socket postgresql.service docker.service; do
    if ! systemctl is-enabled --quiet "$unit"; then
        msg "Enabling $unit"
        sudo systemctl enable "$unit"
    fi

    if ! systemctl is-active --quiet "$unit"; then
        msg "Starting $unit"
        sudo systemctl start "$unit"
    fi
done

#
# Add user to groups
#
current_groups=$(id -nG "$USER")
missing_groups=()
for group in docker libvirt kvm; do
    if [[ " $current_groups " != *" $group "* ]]; then
        missing_groups+=("$group")
    fi
done
if (( ${#missing_groups[@]} > 0 )); then
    msg "Adding user to groups"
    group_list=$(IFS=,; echo "${missing_groups[*]}")
    sudo usermod -aG "$group_list" "$USER"
fi

#
# Install global composer packages
#
installed=$(composer global show --direct --name-only --no-ansi 2>/dev/null) || {
    error "Could not list global Composer packages"
}
missing_packages=()
for package in laravel/installer laravel/pint laravel/sail; do
    if ! grep -Fxq -- "$package" <<< "$installed"; then
        missing_packages+=("$package")
    fi
done
if (( ${#missing_packages[@]} > 0 )); then
    msg "Installing missing global Composer packages"
    composer global require "${missing_packages[@]}"
fi

#
# Set rustup default to stable if not already set
#
if ! rustup default 2>/dev/null | grep -Eq '^stable(-|[[:space:]]|$)'; then
    msg "Setting rustup default to stable"
    rustup default stable
fi

#
# Link bin scripts
#
link_bin="$HOME/.local/bin"
target_bin="$DOTFILES/bin"
if [[ -L "$link_bin" && "$link_bin" -ef "$target_bin" ]]; then
    : # Already linked correctly; do nothing.
elif [[ -e "$link_bin" || -L "$link_bin" ]]; then
    msg "Linking bin scripts"
    rm -fr "$link_bin"
    ln -s "$target_bin" "$link_bin"
else
    msg "Linking bin scripts"
    mkdir -p "$HOME/.local"
    ln -s "$target_bin" "$link_bin"
fi

#
# Enable Tailscale systray on startup
#
if ! systemctl --user is-enabled --quiet tailscale-systray.service; then
    msg "Enabling Tailscale systray startup"
    tailscale configure systray --enable-startup=systemd
    #tailscale configure systray --enable-startup=freedesktop
fi


#
# Link SSH config and create control directory if needed
#
ssh_link="$HOME/.ssh/config"
ssh_target="$DOTFILES/ssh/config"
ssh_control_dir="$HOME/.ssh/control"
if [[ -L "$ssh_link" && "$ssh_link" -ef "$ssh_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$ssh_link" || -L "$ssh_link" ]]; then
    msg "Linking SSH config"
    rm -fr "$ssh_link"
    ln -s "$ssh_target" "$ssh_link"
else
    msg "Linking SSH config"
    ln -s "$ssh_target" "$ssh_link"
fi
if [[ ! -d "$ssh_control_dir" ]]; then
    msg "Creating SSH control directory"
    mkdir -p -m 700 "$ssh_control_dir"
fi

#
# Link Git config files
#
for name in gitattributes gitconfig gitignore; do
    git_link="$HOME/.$name"
    git_target="$DOTFILES/git/$name"
    if [[ -L "$git_link" && "$git_link" -ef "$git_target" ]]; then
        continue # Already linked correctly.
    elif [[ -e "$git_link" || -L "$git_link" ]]; then
        msg "Linking $git_link"
        rm -fr "$git_link"
        ln -s "$git_target" "$git_link"
    else
        msg "Linking $git_link"
        ln -s "$git_target" "$git_link"
    fi
done

#
# Link GnuPG config files
#
gnupg_dir="$HOME/.gnupg"
for name in common.conf dirmngr.conf gpa.conf gpg-agent.conf gpg.conf; do
    gpg_link="$gnupg_dir/$name"
    gpg_target="$DOTFILES/gnupg/$name"
    if [[ -L "$gpg_link" && "$gpg_link" -ef "$gpg_target" ]]; then
        continue # Already linked correctly.
    elif [[ -e "$gpg_link" || -L "$gpg_link" ]]; then
        msg "Linking $gpg_link"
        rm -fr "$gpg_link"
        ln -s "$gpg_target" "$gpg_link"
    else
        msg "Linking $gpg_link"
        ln -s "$gpg_target" "$gpg_link"
    fi
done

#
# Link Kitty config
#
kitty_link="$HOME/.config/kitty"
kitty_target="$DOTFILES/kitty"
if [[ -L "$kitty_link" && "$kitty_link" -ef "$kitty_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$kitty_link" || -L "$kitty_link" ]]; then
    msg "Linking $kitty_link"
    rm -fr "$kitty_link"
    ln -s "$kitty_target" "$kitty_link"
else
    msg "Linking Kitty config"
    ln -s "$kitty_target" "$kitty_link"
fi

#
# Link Tmux config
#
tmux_link="$HOME/.tmux.conf"
tmux_target="$DOTFILES/tmux/tmux.conf"
if [[ -L "$tmux_link" && "$tmux_link" -ef "$tmux_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$tmux_link" || -L "$tmux_link" ]]; then
    msg "Linking $tmux_link"
    rm -fr "$tmux_link"
    ln -s "$tmux_target" "$tmux_link"
else
    msg "Linking Tmux config"
    ln -s "$tmux_target" "$tmux_link"
fi

#
# Link Zsh config files, empty .profile, and change login shell to Zsh if necessary
#
for name in zshrc p10k.zsh; do
    zsh_link="$HOME/.$name"
    zsh_target="$DOTFILES/zsh/$name"
    if [[ -L "$zsh_link" && "$zsh_link" -ef "$zsh_target" ]]; then
        continue # Already linked correctly.
    elif [[ -e "$zsh_link" || -L "$zsh_link" ]]; then
        msg "Linking $zsh_link"
        rm -fr "$zsh_link"
        ln -s "$zsh_target" "$zsh_link"
    else
        msg "Linking $zsh_link"
        ln -s "$zsh_target" "$zsh_link"
    fi
done
test -f "$HOME/.profile" -a -s "$HOME/.profile" && msg "Clearing $HOME/.profile" && rm -f "$HOME/.profile"
zsh_path=$(command -v zsh) || {
    error "Zsh is not installed or not on PATH"
}
user_entry=$(getent passwd "$USER") || {
    error "Could not look up user: $USER"
}
if [[ "${user_entry##*:}" != "$zsh_path" ]]; then
    msg "Changing login shell to Zsh"
    chsh -s "$zsh_path" "$USER"
fi

#
# Link Neovim config
#
nvim_link="$HOME/.config/nvim"
nvim_target="$DOTFILES/nvim"
if [[ -L "$nvim_link" && "$nvim_link" -ef "$nvim_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$nvim_link" || -L "$nvim_link" ]]; then
    msg "Linking $nvim_link"
    rm -fr "$nvim_link"
    ln -s "$nvim_target" "$nvim_link"
else
    msg "Linking Neovim config"
    mkdir -p "$HOME/.config"
    ln -s "$nvim_target" "$nvim_link"
fi

#
# Set AdGuard DNS
#
prefs=$(tailscale debug prefs)
accept_dns=$(jq -er '
    if .CorpDNS == true then "true"
    elif .CorpDNS == false then "false"
    else error("CorpDNS preference unavailable")
    end
' <<< "$prefs")
if [[ "$accept_dns" == true ]]; then
    msg "Disabling Tailscale DNS"
    sudo tailscale set --accept-dns=false
fi
if [[ ! -e "/etc/systemd/system/adguard-doq.service" ]]; then
    msg "Set Adguard DNS service"
    read -r -p 'Adguard quick dns address: ' ADGUARD_DNS
    echo -e "
[Unit]
Description=AdGuard DNS over QUIC proxy
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/dnsproxy --listen=127.0.0.1 --port=53 --upstream=$ADGUARD_DNS --bootstrap=94.140.14.14:53
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/adguard-doq.service > /dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable --now adguard-doq.service
fi
if [[ ! -e "/etc/NetworkManager/conf.d/90-dns-unmanaged.conf" ]]; then
    msg "Configuring NetworkManager to not manage DNS"
    echo -e "
[main]
dns=none
systemd-resolved=false
" | sudo tee /etc/NetworkManager/conf.d/90-dns-unmanaged.conf > /dev/null
    sudo systemctl reload NetworkManager
    echo -e '
nameserver 127.0.0.1
' | sudo tee /etc/resolv.conf
    echo -e '
# Name Service Switch configuration file.
# See nsswitch.conf(5) for details.

passwd: files systemd
group: files [SUCCESS=merge] systemd
shadow: files systemd
gshadow: files systemd

publickey: files

#hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
hosts: mymachines files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

netgroup: files
' | sudo tee /etc/nsswitch.conf
    sudo systemctl restart systemd-resolved
fi

#
# Link fonts
#
fonts_link="$HOME/.local/share/fonts"
fonts_target="$DOTFILES/fonts"
if [[ -L "$fonts_link" && "$fonts_link" -ef "$fonts_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$fonts_link" || -L "$fonts_link" ]]; then
    msg "Linking fonts"
    rm -rf "$fonts_link"
    ln -s "$fonts_target" "$fonts_link"
    fc-cache
else
    msg "Linking fonts"
    mkdir -p "$HOME/.local/share"
    ln -s "$fonts_target" "$fonts_link"
    fc-cache
fi


#
# Sysctl performance tuning
#
if [[ ! -e "/etc/sysctl.d/99-performance.conf" ]]; then
    msg "Sysctl performance tuning"
    cat <<EOF | sudo tee /etc/sysctl.d/99-performance.conf
# Increase map count for Gaming/Proton compatibility
vm.max_map_count = 16777216

# Keep filesystem cache in RAM longer
vm.vfs_cache_pressure = 50

# Better write-back behavior (prevents stutters on external drives)
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5

# Fast Open (TFO) slightly speeds up web browsing/API calls
net.ipv4.tcp_fastopen = 3

# Higher swappiness for zRAM compression efficiency
vm.swappiness = 100
EOF
    sudo sysctl --system
fi

#
# Link PHP configuration
#
php_link="/etc/php/php.ini"
php_target="$DOTFILES/php/php.ini"
if [[ -L "$php_link" && "$php_link" -ef "$php_target" ]]; then
    : # Already linked correctly.
elif [[ -e "$php_link" || -L "$php_link" ]]; then
    msg "Linking PHP config"
    sudo rm -f "$php_link"
    sudo ln -s "$php_target" "$php_link"
else
    msg "Linking PHP config"
    sudo ln -s "$php_target" "$php_link"
fi

#
# TODO reminders to self
#
msg "Still TODO:
    - Log in to 1password
    - Log in to Tailscale (sudo tailscale up --hostname=<hostname>)
    - Log in to Chrome
    - Log in to vs code
    - Get files if needed, and set up syncthing
"