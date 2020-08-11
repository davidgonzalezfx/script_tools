#!/usr/bin/env bash


echo -ne "\033[93mDavid mode (y/n): \033[0m"
read mode

if [ $mode == "y" ];
then
	new_prompt="container"
	username="davidgonzalezfx"
	email="dvdramos16@gmail.com"
	colors="y"
	plugins="y"
else
	echo -ne "\033[93mPlease type a new prompt: \033[0m"
	read new_prompt

	if [ -z $new_prompt ]
	then
		new_prompt="container"
	fi

	echo -ne "\033[93mDo you want enable colors (y/n): \033[0m"
	read colors

	echo -ne "\033[93mDo you want enable plugins (y/n): \033[0m"
	read plugins

	echo -ne "\033[93mPlease type your github username: \033[0m"
	read username

	echo -ne "\033[93mPlease type your github email: \033[0m"
	read email
		
fi


if [ $plugins == "y" ]
then
	# install auto-suggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	# modify .zshrc
	sed -i '71s/$/ \nplugins=(zsh-autosuggestions)/' ~/.zshrc
	sed -i '74s/$/ \nsource ~\/.oh-my-zsh\/plugins\/git\/git.plugin.zsh/' ~/.zshrc
	# sed -i -e '$asource /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc
	sed -i -e '$asource ~/.bash_aliases' ~/.zshrc
fi

if [ $colors == "y"]
then
# change prompt
cat > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme << EOF
PROMPT="%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )"
PROMPT+=\$' %{\$fg[green]%}\$new_prompt %{\$fg[yellow]%}%c%{\$reset_color%} \$(git_prompt_info)\n'
PROMPT+='%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ ) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[red]%}(%{\$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[red]%}) %{\$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[red]%})"
EOF
else
# Default Oh-My-Zsh theme
cat > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme << EOF
PROMPT="%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )"
PROMPT+=' %{\$fg[cyan]%}\$new_prompt \$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}git:(\%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
EOF
fi


# set aliases
cat > ~/.bash_aliases << EOF
alias gfpush='git push -f origin "\$(git_current_branch)"'
alias slog='git log --oneline --graph  --decorate'
alias ccommits='git shortlog -s -n --all'
alias lsd='ls -1d */'
alias lsl='ls -1'
EOF


# vim paste mode
echo -e 'set pastetoggle=<F1>\n' > ~/.vimrc

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
service mysql start

echo -e "\n----------\n"
echo -e "\033[93mplease execute source ~/.zshrc"
echo -e "\n----------\n"


