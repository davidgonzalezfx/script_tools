#!/usr/bin/env bash

# install zsh
echo -e "\033[95mapt-get update working...\033[0m"
sudo apt-get -y -qq update 2> /dev/null
echo -e "\033[92mupdate finished\033[0m"
echo -e "\n----------\n"

echo -e "\033[95mInstalling nodejs...\033[0m"
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y -qq nodejs 2> /dev/null
echo -e "\033[92nodejs installed\033[0m"
echo -e "\n----------\n"

echo -e "\033[95mInstalling neovim...\033[0m"
sudo apt install -y -qq software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable 
sudo apt-get -y -qq update 2> /dev/null
sudo apt-get -y -qq install neovim
mkdir -p ~/.config/nvim
cat init.vim > ~/.config/nvim/init.vim
echo -e "\033[92mnvim installed\033[0m"
echo -e "\n----------\n"

echo -e "\033[95mInstalling zsh...\033[0m"
sudo apt-get -y -qq install zsh
echo -e "\033[92mzsh installed\033[0m"
sudo usermod -s /usr/bin/zsh $(whoami)
echo -e "\n----------\n"
echo -e "\033[95mInstalling Oh-My-Zsh...\033[0m"

# install oh-my-zsh
sh -c "$(wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
