#!/usr/local/bin/zsh

alias assume=". assume"
alias awswhoami="aws sts get-caller-identity" 
alias be="bundle exec"
alias cd="z"
alias cx="kubectx"
alias cz="chezmoi"
alias cat="bat --theme Nord "
alias ctags="${HOMEBREW_PREFIX}/bin/ctags"
alias crontab="VIM_CRONTAB=true crontab"
alias diff="${HOMEBREW_PREFIX}/bin/diff"
alias f="flux"
alias find="fd"
alias fw="flux events --watch"
alias gist="gist -c"
alias glow="glow -nlt -w0"
alias grep="pcregrep --color=auto"
alias gup="gfo && ggpull"
alias h="history"
alias kittyreload="kill -SIGUSR1 $KITTY_PID"

# kubecolor colorizes kubectl output, but zsh's `kubectl completion zsh`
# invokes `kubectl __complete ...` internally — an alias here makes that
# call resolve to kubecolor, which colorizes the completion-protocol
# directive line (e.g. ":4") and breaks tab completion (raw escape codes
# show up instead of results). Route completion-protocol calls to the
# real binary; everything else still goes through kubecolor.
kubectl() {
  case "$1" in
    __complete|completion) command kubectl "$@" ;;
    *) kubecolor "$@" ;;
  esac
}
compdef _kubectl kubectl

alias ls="lsd"
alias l="ll"
alias less="less -m -g -i -J --underline-special --SILENT"
alias mkdir="mkdir -p"
alias more="less"
alias ns="kubens"
alias time-eastern="TZ=America/New_York date"
alias time-pacific="TZ=Canada/Pacific date"
alias time-uk="TZ=Europe/London date"
alias vi="nvim"
alias tfaa="terraform apply --auto-approve"
alias tg="terragrunt"
alias tga="terragrunt apply"
alias tgaa="terragrunt apply --auto-approve"
alias tgp="terragrunt plan"
alias v="nvim"
alias vim="nvim"
