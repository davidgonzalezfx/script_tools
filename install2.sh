#!/usr/bin/env bash
# install auto-suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# change prompt
cat > ~/.oh-my-zsh/themes/robbyrussell.zsh-theme << EOF
PROMPT="%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )"
PROMPT+=\$' %{\$fg[green]%}container %{\$fg[yellow]%}%c%{\$reset_color%} \$(git_prompt_info)\n'
PROMPT+='%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ ) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[red]%}(%{\$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[red]%}) %{\$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[red]%})"
EOF

# set aliases
cat > ~/.bash_aliases << EOF
alias gfpush='git push -f origin "\$(git_current_branch)"'
alias slog='git log --oneline --graph  --decorate'
alias ccommits='git shortlog -s -n --all'
alias lsd='ls -1d */'
alias lsl='ls -1'
EOF

# modify .zshrc
sed -i '71s/$/ \nplugins=(zsh-autosuggestions)/' ~/.zshrc
sed -i '74s/$/ \nsource ~\/.oh-my-zsh\/plugins\/git\/git.plugin.zsh/' ~/.zshrc
sed -i -e '$asource /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc
sed -i -e '$asource ~/.bash_aliases' ~/.zshrc

# vim paste mode
echo -e 'set pastetoggle=<F1>\n' > ~/.vimrc

# git config
git config --global user.email "dvdramos16@gmail.com"
git config --global user.name "davidgonzalezfx" 
git config --global credential.helper store

echo -e "\033[94mplease execute \$source ~/.zshrc"

# load files
# source ~/.zshrc
