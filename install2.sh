#!/usr/bin/env bash
sudo chsh --shell /bin/zsh $(whoami)

echo -ne "\033[93mDavid mode (y/n): \033[0m"
read mode

if [ $mode == "y" ];
then
	username="davidgonzalezfx"
	email="dvdramos16@gmail.com"
	colors="y"
	plugins="y"

	echo -ne "\033[93mIs it a container (y/n): \033[0m"
	read container

	# container ssh
	if [ $container == "y" ]
	then
		sed -i -e '$assh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM5hW8axyzEYAmk7dDTm8ZpcqtymdHBgpkCj1arh4SO/jSvtgipQphOSrpU2QdQ7f73dPooKJU7T09sq7FDrtKZpnMtvccmqcIayXzUqdll59K/z5PSnk7PpbCFqudL6+omMa0+3jz4eCabdSJV7Krvc6fMuZDN5rjhrBbYcQgN+95/DNNeCyCc/topKoMOtnpxPZn2p9gLypV1FyT067TD7VrbZ5QJ7GxVwXyjkgTAEtyXPPj1/i3yCU+rovAC/lDbhCdw8m3Ejrzo8yMxNqB4TyMvtBdEPtIbJ0hz5pWSfnN9MWqa3Sodi07ytDADEWWcdvS8aLvKE7PXf4HwNZ3 vagrant@ubuntu-bionic' ~/.ssh/authorized_keys
	fi
	# set aliases
cat > ~/.bash_aliases << EOF
alias gfpush='git push -f origin "\$(git_current_branch)"'
alias slog='git log --oneline --graph  --decorate'
alias ccommits='git shortlog -s -n --all'
alias lsd='ls -1d */'
alias lsl='ls -1'
alias load='source ~/.zshrc;echo "loaded succesful"'
EOF

else
	echo -ne "\033[93mDo you want enable prompt colors (y/n): \033[0m"
	read colors

	echo -ne "\033[93mDo you want enable plugins (y/n): \033[0m"
	read plugins

	echo -ne "\033[93mPlease type your github username: \033[0m"
	read username

	echo -ne "\033[93mPlease type your github email: \033[0m"
	read email
		
fi

echo -ne "\033[93mPlease type your new prompt: \033[0m"
read new_prompt

echo -ne "\033[93mDo you want enable MySQL (y/n): \033[0m"
read sql


if [ $colors == "y" ]
then
# change prompt
echo "
PROMPT=\"%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )\"
PROMPT+=\$' %{\$fg[green]%}$new_prompt %{\$fg[yellow]%}%c%{\$reset_color%} \$(git_prompt_info)\n'
PROMPT+='%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ ) '

ZSH_THEME_GIT_PROMPT_PREFIX=\"%{\$fg_bold[red]%}(%{\$fg[red]%}\"
ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{\$reset_color%} \"
ZSH_THEME_GIT_PROMPT_DIRTY=\"%{\$fg[red]%}) %{\$fg[red]%}✗\"
ZSH_THEME_GIT_PROMPT_CLEAN=\"%{\$fg[red]%})\" " > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
else
# Default Oh-My-Zsh theme
echo "
PROMPT=\"%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )\"
PROMPT+=' %{\$fg[cyan]%}$new_prompt \$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=\"%{\$fg_bold[blue]%}git:(\%{$fg[red]%}\"
ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{\$reset_color%} \"
ZSH_THEME_GIT_PROMPT_DIRTY=\"%{\$fg[blue]%}) %{\$fg[yellow]%}✗\"
ZSH_THEME_GIT_PROMPT_CLEAN=\"%{\$fg[blue]%})\" " > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
fi

if [ $plugins == "y" ]
then
	# install auto-suggestions
	git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	
	# modify .zshrc
	sed -i '71s/$/ \nplugins=(zsh-autosuggestions)\n\nZSH_DISABLE_COMPFIX="true"/' ~/.zshrc
	sed -i '74s/$/ \nsource ~\/.oh-my-zsh\/plugins\/git\/git.plugin.zsh/' ~/.zshrc
	sed -i -e '$asource ~/.bash_aliases' ~/.zshrc

	# install syntax highlighting
	echo -ne "\033[93mInstall syntax-highlighting (Ubuntu 16+) (y/n): \033[0m"
	read syntax

	if [ $syntax == "y" ]
	then
		sudo apt-get -y -qq install zsh-syntax-highlighting 2> /dev/null
		sed -i -e '$asource /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc
	fi
fi

# vim paste mode
echo -e 'set pastetoggle=<F2>\n' > ~/.vimrc

# git config
if [ ! -z $email ]
then
	git config --global user.email $email
fi

if [ ! -z $username ]
then
	git config --global user.name $username
fi
git config --global credential.helper store

echo -e '\033[92mYour git configuration:'
git config --global --list

# enable mysql
if [ $plugins == "y" ]
then
	sudo service mysql start
fi

echo -e "\n----------"
echo -e "\033[93mplease execute source ~/.zshrc"
echo -e "\n----------\n"

