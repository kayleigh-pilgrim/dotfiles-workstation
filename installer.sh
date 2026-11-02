#!/usr/bin/env bash

# Colors
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Show a message
function msg() {
    echo -e "${YELLOW}"
    echo ">> $1"
    echo -e "${NC}"
}

# Show an error
function error() {
    echo -e "${RED}"
    echo ">> $1"
    echo -e "${NC}"
}

# Dotfiles direcory
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Installed during cachyOS install
# faugus goverlay heroic lutris steam winboat protontricks winetricks
# brave-bin torbrowser-launcher vivaldi chromium discord signal-desktop telegram-desktop code podman-docker aisleriot darktable
# digikam gimp coolercontrol openrgb thunderbird shortwave libreoffice-fresh obs-studio kdenlive shotcut vlc virt-manager

msg "Adding 1password gpg key"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import

msg "Installing packages"
paru -S --needed \
mc \
paru \
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
rappel-git \
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
npm

msg "Initializing PostgreSQL"
if ! sudo test -d /var/lib/postgres/data; then
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

msg "Enabling services"
sudo systemctl enable --now valkey.service
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now postgresql.service
sudo systemctl enable --now docker.service

msg "Adding user to groups"
sudo usermod -aG docker,libvirt,kvm "$USER"

msg "Installing global composer packages"
composer global require laravel/installer laravel/pint laravel/sail

msg "Installing rustup stable"
rustup default stable

msg "Linking bin scripts"
rm -fr $HOME/.local/bin
ln -s $DOTFILES/bin $HOME/.local/bin


msg "Fish config"
/usr/bin/fish -c "
    fish_config theme choose Dracula
    fish_add_path $HOME/.config/composer/vendor/bin/
    fish_add_path $HOME/.local/bin/
    set -U EDITOR nvim
"

msg "Tailscale systray"
#tailscale configure systray --enable-startup=freedesktop
tailscale configure systray --enable-startup=systemd

msg "SSH config"
rm -rf $HOME/.ssh/config
ln -sf $DOTFILES/ssh/config $HOME/.ssh/config
mkdir /home/kayleigh/.ssh/control

msg "Git config"
rm -fr $HOME/.gitattributes
rm -fr $HOME/.gitconfig
rm -fr $HOME/.gitignore
ln -sf $DOTFILES/git/gitattributes $HOME/.gitattributes
ln -sf $DOTFILES/git/gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/git/gitignore $HOME/.gitignore

msg "Gnupg config"
rm -fr $HOME/.gnupg/common.conf
rm -fr $HOME/.gnupg/dirmngr.conf
rm -fr $HOME/.gnupg/gpa.conf
rm -fr $HOME/.gnupg/gpg-agent.conf
rm -fr $HOME/.gnupg/gpg.conf
ln -sf $DOTFILES/gnupg/common.conf $HOME/.gnupg/common.conf
ln -sf $DOTFILES/gnupg/dirmngr.conf $HOME/.gnupg/dirmngr.conf
ln -sf $DOTFILES/gnupg/gpa.conf $HOME/.gnupg/gpa.conf
ln -sf $DOTFILES/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
ln -sf $DOTFILES/gnupg/gpg.conf $HOME/.gnupg/gpg.conf

msg "Kitty config"
rm -fr $HOME/.config/kitty
ln -s $DOTFILES/kitty $HOME/.config/kitty

msg "Tmux config"
rm -fr $HOME/.tmux.conf
ln -sf $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf

msg "Zsh config"
rm -fr $HOME/.zshrc
rm -fr $HOME/.p10k.zsh
ln -sf $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -sf $DOTFILES/zsh/p10k.zsh $HOME/.p10k.zsh
echo "" > ~/.profile
chsh -s $(which zsh)

msg "Neovim config"
rm -rf $HOME/.config/nvim
ln -s $DOTFILES/nvim $HOME/.config/nvim

# Set up 1password
# Log in to tailscale
# Log in to Chrome
# Log in to code
