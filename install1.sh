#!/usr/bin/env bash

# install zsh
echo -e "\033[95mapt-get update working...\033[0m"
sudo apt-get -y -qq update 2> /dev/null
sudo apt-get -y -qq upgrade
sudo apt-get -y -qq dist-upgrade
sudo apt-get -y -qq autoremove
echo -e "\033[92mupdate finished\033[0m"
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

echo -e "\033[95mInstalling nvm and node...\033[0m"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.profile
sed -i -e 'export NVM_DIR="$HOME/.nvm' ~/.zshrc
sed -i -e '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' ~/.zshrc
sed -i -e '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'  ~/.zshrc
nvm install --lts
echo -e "\033[92mnvm and node installed\033[0m"
echo -e "\n----------\n"

echo -e "\033[95mInstalling zsh...\033[0m"
sudo apt-get -y -qq install zsh
echo -e "\033[92mzsh installed\033[0m"
sudo usermod -s /usr/bin/zsh $(whoami)
echo -e "\n----------\n"
echo -e "\033[95mInstalling Oh-My-Zsh...\033[0m"

# install oh-my-zsh
sh -c "$(wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
