#!/bin/bash

if [ "$EUID" = 0 ]; then
        echo "please run it as regular user and make sure you have sudo permission"
        exit 1
fi

sudo apt update

echo "Install JetbrainsNL fonts (no need in container)? y or n: "
read INSTALL_FONTS
echo "Install GO? y or n: "
read INSTALL_GO
echo "Install CPP? y or n: "
read INSTALL_CPP

if [ "$INSTALL_FONTS" = "y" ]; then
        mkdir -p ~/.local/share/fonts
        tar xf font.tgz
        mv font/* ~/.local/share/fonts/
        rm -rf font
        fc-cache -fv
fi

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

sudo apt install -y git make libfuse-dev python3-pip python3-dev python-is-python3 python3-pynvim cargo ripgrep exuberant-ctags
if [ "$INSTALL_CPP" = "y" ] ; then
        # install libstdc++-12-dev to solve clangd can not find iostream and also make gd work
        sudo apt install -y libstdc++-12-dev
fi
sudo snap install node --classic

wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
chmod +x nvim.appimage
mkdir -p ~/bin
mv nvim.appimage ~/bin/nvim

setup_path=$(grep 'PATH:~/bin' ~/.bashrc)
if [ -z "$setup_path" ]; then
	echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
        source ~/.bashrc
	PATH="$PATH:~/bin"
fi

# for stable release
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

# for nightly version
#bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

cp configs/* ~/.config/lvim/

echo "------------------------------------------------------------------------------------------------------"
if [ "$INSTALL_FONTS" = "y" ]; then
        echo "Make sure you set the terminal font to JetBrainsMonoNL"
        echo ""
fi
echo ""
echo "source ~/.profile to set lvim binary path"
echo "Start lvim first to install additional plugins and then modify background color (bg) to #181818 in"
echo "~/.local/share/lunarvim/site/pack/lazy/opt/dracula.nvim/lua/dracula/palette.lua"
echo ""
if [ "$INSTALL_GO" = "y" ] ; then
        echo "If you hit: xxx/gopls.lua:16: attempt to get length of upvalue 'mod_cache' (a nil value)"
        echo "get gomodecache path by: go env GOMODCACHE"
        echo "modify ~/.local/share/lunarvim/site/pack/lazy/opt/nvim-lspconfig/lua/lspconfig/server_configurations/gopls.lua"
        echo "specify mod_cache path directly in the third line: local mod_cache = 'path to GOMODCACHE'"
fi
echo ""
echo "------------------------------------------------------------------------------------------------------"
