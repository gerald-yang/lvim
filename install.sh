#!/bin/bash

if [ "$EUID" = 0 ]; then
        echo "please run it as regular user and make sure you have sudo permission"
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

echo "Install GO? y or n: "
read INSTALL_GO
if [ "$INSTALL_GO" = "y" ] ; then
        echo "Install go packages"
        sudo snap install go --classic
        go install golang.org/x/tools/gopls@latest
        go install github.com/jstemmer/gotags@latest
        go install golang.org/x/tools/cmd/goimports@latest
        go install honnef.co/go/tools/cmd/staticcheck@latest
        go install github.com/fatih/motion@latest
        go install github.com/nsf/gocode@latest
        go install golang.org/x/tools/cmd/guru@latest
        go install golang.org/x/tools/cmd/gorename@latest
        go install github.com/rogpeppe/godef@latest
        go install github.com/kisielk/errcheck@latest
        go install github.com/klauspost/asmfmt/cmd/asmfmt@latest
        go install github.com/josharian/impl@latest
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        go install github.com/fatih/gomodifytags@latest
        go install honnef.co/go/tools/cmd/keyify@latest
        go install golang.org/x/lint/golint@latest

        setup_gopath=$(grep 'export GOPATH' ~/.bashrc)

        if [ -z "$setup_gopath" ]; then
                echo 'export GOPATH=$(go env GOPATH)' >> ~/.bashrc
                echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
        fi
fi

# install libstdc++-12-dev to solve clangd can not find iostream and also make gd work
sudo apt install -y git make libfuse-dev python3-pip python3-dev python-is-python3 cargo ripgrep exuberant-ctags libstdc++-12-dev
sudo snap install node --classic

wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
chmod +x nvim.appimage
mkdir -p ~/bin
mv nvim.appimage ~/bin/nvim

# for stable release
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

# for nightly version
#bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

cp configs/* ~/.config/lvim/
mkdir -p ~/bin
cp bin/get-secret-key ~/bin/

echo "------------------------------------------------------------------------------------------------------"
if [ "$INSTALL_FONTS" = "y" ]; then
        echo "Make sure you set the terminal font to JetBrainsMonoNL"
        echo ""
fi
echo "Start lvim first to install additional plugins and then modify background color (bg) to #181818 in"
echo "~/.local/share/lunarvim/site/pack/lazy/opt/dracula.nvim/lua/dracula/palette.lua"
echo ""
echo "------------------------------------------------------------------------------------------------------"
