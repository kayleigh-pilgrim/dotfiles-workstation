# My worstation dotfiles and installer

Currently only works for Cachy OS.

## What the installer does

- Configure 1password GPG key
- Install all packages
- Initialize PostgreSQL
- Enable + start: valkey, libvirt, postgresql and docker
- Add user to groups for docker and kvm
- Install global composer packages
- Set rustup default stable
- Link bin scripts to ~/.local/bin which is in path
- Enable tailscale systray on startup
- Link ~/.ssh/config + set up control dir
- Link global git configuration
- Link GnuPG configuration
- Link Kitty configuration
- Link tmux configuration
- Link zsh and p10k configuration
- Link Neovim configuration
- Set DNS to Adguard quick url only
- Link fonts
- Some sysctl performance tuning
- Link development php.ini
- Reminder of some todo's after the script
