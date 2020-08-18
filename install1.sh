#!/usr/bin/env bash

# install zsh
echo -e "\033[95mapt-get update working..."
sudo apt-get -y -qq update 2> /dev/null
echo -e "\033[92mupdate finished"
echo -e "\n----------\n"
echo -e "\033[95mInstalling zsh..."
sudo apt-get -y -qq install zsh
echo -e "\033[92mzsh installed"
sudo usermod -s /usr/bin/zsh $(whoami)
echo -e "\n----------\n"
echo -e "\033[95mInstalling Oh-My-Zsh..."

# install oh-my-zsh
sh -c "$(wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
