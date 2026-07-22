#!/usr/bin/env zsh

source $HOME/.local/bin/env

# Prepended (not appended) so Homebrew's git (and its matching zsh completion
# script in HOMEBREW_PREFIX/share/zsh/site-functions) wins over /usr/bin's
# older Apple-patched git — a version mismatch there breaks `git <TAB>` with
# "unknown option `aliases-for-completion'".
export PATH="$HOME/bin:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
export PATH="$PATH:/bin"

export AWS_PAGER=

export EDITOR=nvim

export FZF_DEFAULT_COMMAND='ag --nocolor --ignore node_modules --ignore venv --ignore .venv -g ""'

export GIT_EDITOR=nvim

LESSPIPE="$(command -v src-hilite-lesspipe.sh)"
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '
source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"

export PIPX_PATH="${HOME}/.local/bin"

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters

if hash gdircolors 2> /dev/null; then
  test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)
fi
