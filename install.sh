#!/bin/bash

if [ "$EUID" = 0 ]; then
        echo "please run it as regular user"
        exit 1
fi

echo "Install JetbrainsNL fonts? y or n: "
read INSTALL_FONTS
if [ "$INSTALL_FONTS" = "y" ]; then
        mkdir -p ~/.local/share/fonts
        tar xf font.tgz
        mv font/* ~/.local/share/fonts/
        rm -rf font
        fc-cache -fv
fi

sudo apt install -y git make libfuse-dev python3-pip python3-dev python-is-python3 cargo ripgrep exuberant-ctags
sudo snap install node --classic

wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
chmod +x nvim.appimage
mkdir -p ~/bin
mv nvim.appimage ~/bin/nvim

LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

cp configs/* ~/.config/lvim/

echo "--------------------------------------------------------------------------------------------------"
if [ "$INSTALL_FONTS" = "y" ]; then
        echo "Make sure you set the terminal font to JetBrainsMonoNL"
        echo ""
fi
echo "Start lvim first to install my own plugins and modify background color (bg) to #181818 in"
echo "~/.local/share/lunarvim/site/pack/lazy/opt/dracula.nvim/lua/dracula/palette.lua"
echo ""
echo "--------------------------------------------------------------------------------------------------"
