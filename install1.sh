#!/usr/bin/env bash

# install zsh
echo -e "\033[95mapt-get update working..."
sudo apt-get -y -qq update 2> /dev/null
echo -e "\033[92mupdate finished"
echo -e "\n----------\n"

echo -e "\033[95mInstalling neovim..."
sudo apt install -y -qq software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable 
sudo apt-get -y -qq update 2> /dev/null
sudo apt-get -y -qq install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir -p ~/.config/nvim
echo "
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
" > ~/.config/nvim/init.vim
echo -e "\033[92mnvim installed"
echo -e "\n----------\n"

echo -e "\033[95mInstalling zsh..."
sudo apt-get -y -qq install zsh
echo -e "\033[92mzsh installed"
sudo usermod -s /usr/bin/zsh $(whoami)
echo -e "\n----------\n"
echo -e "\033[95mInstalling Oh-My-Zsh..."

# install oh-my-zsh
sh -c "$(wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
