alias gfpush='git push -f origin "$(git_current_branch)"'
alias slog='git log --oneline --graph  --decorate'
alias slog1='git log --pretty=format:"%C(red)%h %x09%C(green)%C(bold)%an%Creset"'
alias slog2='git log --pretty=format:"%C(red)%h %x09%C(green)%C(bold)%ad%Creset %C(cyan)%cr%Creset%x09 | %s %C(green)%Creset" --date=short'

alias ccommits='git shortlog -s -n --all'
alias lcommit='slog | head -n 2 | tail -n 1 | cut -d " " -f2'
alias lsd='ls -1d */'
alias lsl='ls -1'
alias load='source ~/.zshrc;echo "loaded succesful"'

alias vim='nvim'
alias vi='nvim'

alias createComponent='~/createComponent.sh'

# tool for rebase 
# git -c user.name="New Author Name" -c user.email=email@address.com commit --amend --reset-author
# GIT_COMMITTER_DATE="Thu 13 Aug 2020 18:00:00 -05" git commit --amend --no-edit --date "Thu 13 Aug 2020 18:00:00 -05"
# git log --pretty=format:"%h%x09%an%x09%ad%x09%s"


# rename branch
# git branch -m <new_name>

# delete branch locally
# git branch -d localBranchName

# delete branch remotely
# git push origin --delete remoteBranchName

