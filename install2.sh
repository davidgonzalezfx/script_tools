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

	# set aliases
	cat bash_aliases > ~/.bash_aliases
	# vimrc 
	cat vim_config > ~/.vimrc
	vim -c 'CocInstall -sync coc-json coc-pairs coc-python coc-sh coc-snippets coc-sql|q'
	cat coc-settings.json > ~/.config/nvim/coc-settings.json
	mkdir -p ~/.config/coc/ultisnips
	cat javascript.snippets > ~/.config/coc/utilsnips/javascript.snippets
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

echo -ne "\033[93mDo you want to config Nginx (y/n): \033[0m"
read nginx

if [ $nginx == "y" ]
then
	# Install NGNINX an start service
	apt-get -y update
	sudo apt-get -y install nginx
	echo "Holberton School" > /var/www/html/index.html
	echo "Ceci n'est pas une page" > /usr/share/nginx/html/not_found.html
	sed -i 's/server_name _;/server_name _;\n\trewrite ^\/redirect_me http:\/\/davidgonzalezfx.xyz permanent;\n\n\terror_page 404 \/not_found.html;\n\tlocation = \/not_found.html {\n\t\troot \/usr\/share\/nginx\/html;\n\t\tinternal;\n\t}/' /etc/nginx/sites-available/default
	sudo service nginx reload
fi

if [ $colors == "y" ]
then
# change prompt
echo "
PROMPT=\"%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )\"
PROMPT+=\$' %{\$fg[green]%}$new_prompt %{\$fg[yellow]%}%c%{\$reset_color%} \$(git_prompt_info)\n'
PROMPT+=\$'%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )%{\$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=\"%{\$fg_bold[red]%}(%{\$fg[red]%}\"
ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{\$reset_color%} \"
ZSH_THEME_GIT_PROMPT_DIRTY=\"%{\$fg[red]%}) %{\$fg[red]%}✗\"
ZSH_THEME_GIT_PROMPT_CLEAN=\"%{\$fg[red]%})\" " > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme
else
# Default Oh-My-Zsh theme
echo "
PROMPT=\"%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )\"
PROMPT+=' %{\$fg[cyan]%}$new_prompt %{\$reset_color%}\$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=\"%{\$fg_bold[blue]%}git:(%{$fg[red]%}\"
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
if [ $sql == "y" ]
then
	sudo service mysql start
fi



echo -e "\n----------"
echo -e "\033[93mplease execute source ~/.zshrc"
echo -e "\n----------\n"

