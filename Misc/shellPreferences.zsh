# Setup Path and other things for homebrew
# Needed because I install many things with homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Basic aliases
alias pip='pip3'
alias python='python3'
alias vim='nvim'

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Standard plugins can be found in $ZSH/plugins/
plugins=(git aws tmux)

SHOW_AWS_PROMPT=false

# Runs oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Overwrite git aliases for git log
# Limited to 10 lines, so don't use a pager
alias glo='git --no-pager log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset" --date=local -n 10'
# Longer, with a pager if needed
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset" --date=local'

# Helper functions
function all-windows() {
	current_session=$(tmux display -p "#S")

	# Get all arguments as a normal string, separated by spaces
	command=""
	for arg in "$@"; do
		command="$command $arg"
	done
	command="${command:1}" # Remove leading space

	# Get all window ids, and for each send the command and then hit Enter
	tmux list-windows | \
		cut -d: -f1 | \
		xargs -I{} tmux send-keys -t "$current_session:{}" $command Enter
}


# My Custom Theme, modified colors to mortalscumbag
# All themes can be found under ~/.oh-my-zsh/themes
function my_git_prompt() {
  # Returns early if we are not in a git repo
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  NUM_COMMITS_AHEAD=$(git_commits_ahead)
  if [ -n "${NUM_COMMITS_AHEAD}" ]; then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$NUM_COMMITS_AHEAD"
  fi

  # is branch behind?
  NUM_COMMITS_BEHIND=$(git_commits_behind)
  if [ -n "${NUM_COMMITS_BEHIND}" ]; then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$NUM_COMMITS_BEHIND"
  fi

  # is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$FG[161]%}(ssh) "
  fi
}

function _toolbox_prompt_info() {
  if typeset -f toolbox_prompt_info > /dev/null; then
    toolbox_prompt_info
  fi
}

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%?%{$reset_color%}"
PROMPT=$'\n$(_toolbox_prompt_info)$(ssh_connection)%{$FG[033]%}%n@%m%{$reset_color%}$(my_git_prompt) : %~\n[${ret_status}] %# '

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg[white]‹ %{$FG[129]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[green]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[green]%}↓"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $fg_bold[white]›%{$reset_color%}"
