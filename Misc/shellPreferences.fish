# Setup Path and other things for homebrew
# Needed because I install many things with homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Basic aliases
alias pip='pip3'
alias python='python3'
alias vim='nvim'

# Scripts for quick ISO and epoch timestamps at the command-line
alias timestamp_now="python $HOME/macDotfiles/Misc/misc_python/timestamp_now.py"
alias timestamp_convert="python $HOME/macDotfiles/Misc/misc_python/timestamp_convert.py"

# Disable certain fish features
set fish_prompt_pwd_dir_length 0
set -U fish_greeting

# Choosing fish theme and colors
fish_config theme choose ayu-mirage
set fish_color_user "brcyan"
set fish_color_host "0085FB"
set fish_color_cwd "normal"

# Enable showing a bunch of stuff on the fish prompt for git
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showstashstate 1

# Tweak the colors and characters
set __fish_git_prompt_char_cleanstate "✔"
set __fish_git_prompt_color_cleanstate "brblue"

set __fish_git_prompt_char_stagedstate "●"
set __fish_git_prompt_color_stagedstate "green"

# Dirty means un-staged files with changes
set __fish_git_prompt_char_dirtystate "●"
set __fish_git_prompt_color_dirtystate "red"

# Untracked means brand new files
set __fish_git_prompt_char_untrackedfiles "●"
set __fish_git_prompt_color_untrackedfiles "white"

set __fish_git_prompt_color_upstream "green"

set __fish_git_prompt_color_branch "AE00FF"

# Various git aliases that I like, borrowed and modified from Oh-My-Zsh
alias ga='git add'
alias gb='git branch'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
function gdh -a commitCount
  git diff HEAD~$commitCount
end
alias gf='git fetch'
alias gp='git pull'
alias gr='git restore'
alias grs='git restore --staged'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias gs='git status'


# Overwrite git aliases for git log
# Limited to 10 lines, so don't use a pager
alias glo='git --no-pager log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset" --date=local -n 10'
# Longer, with a pager if needed
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset" --date=local'
