#!/usr/bin/env bash

# install zsh
sudo apt-get -y -qq update 2> /dev/null
echo -e "\033[94mupdate finished"
sudo apt-get -y -qq install zsh
echo -e "\033[94mzsh installed"
sudo usermod -s /usr/bin/zsh $(whoami)

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
