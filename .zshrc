autoload -U colors && colors

# prompt
setopt Prompt_SUBST
PROMPT='
%F{green}%n%f@%F{green}%m%f %~
%F{yellow}%* %w%f %F{cyan}%#%f '
TMOUT=1

TRAPALRM() {
    zle reset-prompt
}

# utility functions

# contains(string, substring)
# ref: https://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-posix-sh
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
function contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

alias lrc="source ~/.zshrc"

# ls color
autoload -U compinit
compinit

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -GF --color"
alias la="ls -a"
alias ll="ls -l"
alias gls="gls --color"
alias history="history 1"

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# history
setopt HIST_IGNORE_DUPS
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# cd alias
alias cd..="cd .."

# git alias
alias glog="git log --graph --pretty=format:'%h %C(cyan)%an %Cgreen(%cr) %C(bold magenta)%d%C(reset) %n %s %n ' --first-parent "
alias glogn="git log --graph --pretty=format:'%h %C(cyan)%an %Cgreen(%cr) %C(bold magenta)%d%C(reset) %n %s %n ' --first-parent --name-status"
alias gch="git checkout "
alias gbr="git branch "
alias gvr="git branch -vvr "
alias gs="git status -s"
alias gc="git commit "
alias gca="git commit -a "
alias gcaa="git commit -a --amend "
alias gst="git stash "
alias gsl="git stash list "
alias gsa="git stash apply "

# ハマりポイント
# - ファイル内で定義したfunctionはcommandでは実行できないのでベタ打ちになる
# - 返り値がreturnな関数は$()でうまくとってこれない というか多分これは標準出力をとってくるのでreturnはとれない
function showUnpushedChanges() {
  command git fetch -q
  local=$(git rev-parse --abbrev-ref HEAD)
  remote="remotes/origin/$local"
  branches=$(git branch -a --column)
  contains $branches $remote
  isContain="$?"
  if [ "$isContain" -eq 0 ]; then
    command git diff -w --stat $remote
    return 0
  fi
  contains $branches master
  isContain="$?"
  if [ "$isContain" -eq 0 ]; then
    command git diff -w --stat master
  fi
  contains $branches main
  isContain="$?"
  if [ "$isContain" -eq 0]; then
    command git diff -w --stat main
  fi
  return 1
}
function git() {
  if [ "$#" -gt 0 ];
    if [ "$#" -eq 1 -a "$1" = "push" ]; then
      current_branch=$(git rev-parse --abbrev-ref HEAD)
      echo -e "Did you try the test before push (or this project has no test)? (y/N)"
      if read -q; then
        echo ""
      else
        echo "push abort."
        return
      fi
      echo -e "push to \e[31;1m${current_branch}\e[m. ok? (y/N)"
      if read -q; then
        echo ""
        command git push
      else
        echo -e "\nabort."
      fi
    fi
    # if [ "$1" = "commit" ]; then
    #   command git "$@"
    #   if [[ "$?" == 0 ]]; then
    #     echo -e "\nthere are some changes pushed or branch point"
    #     showUnpushedChanges
    #   fi
    # fi
    if [ "$1" = "stash" -a "$2" = "delete" ]; then
      command git stash list
      echo -e "\e[31;1mDanger, this is LOSSY OPERATION!\e[m\ninput stash number which you want to delete"
      read indexes
      items=0
      # https://qiita.com/uasi/items/82b7708d5da213ba7c31
      for index in ${=indexes}
      do
        command git stash drop $index --quiet
      done
      echo -e "drop stashes indexed ${indexes}"
  else
    command git "$@"
  fi
}
function gunlook() {
    command git update-index --skip-worktree "$1"
    command touch ~/Documents/.unlooked.lock
    echo "unlooking $1 now"
}
function glook() {
    command git update-index --no-skip-worktree "$1"
    echo "looking $1 now"
    echo "if you wanna completely looking all files now, PLS DELETE ~/Documents/.unlooked.lock"
}

# other alias
alias grep="grep -n "
