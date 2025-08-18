alias zshconfig="nvim $HOME/.zshrc"
alias zshrc="nvim $HOME/.zshrc"
alias rc="nvim $HOME/.zshrc"
alias rl=". $HOME/.zshrc"
alias cd="z"
alias zz="search_with_zoxide"
alias fdh="fd -H"
alias vim="nvim"
alias vi="nvim"
alias issue="gh issue create"
alias jqc='jq | pbcopy'
alias fj='pbpaste | jqc'
alias chromekill='ps aux | grep "Google Chrome" | grep "type=renderer" | awk '\''{print $2}'\'' | xargs kill -9'
alias cmds='tldr --list | fzf --preview "tldr {1} --color always -p osx" --preview-window=right,70% | xargs tldr'
alias dots="cd $HOME/dotfiles && nvim"
alias nv="nvim"
alias fucking="sudo"
alias please="sudo"
alias cdg="cd $HOME/Documents/Github"
alias mkdir='mkdir -p'
alias pcr="pre-commit run --all-files"
alias n="nvim"
alias weather="curl wttr.in"
alias fm="fzf-make"

# if trash is not installed, make an alias for it
if ! command -v trash &>/dev/null; then
  alias trash="/bin/rm"
else
  alias rm="trash"
fi

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Open
alias o='open . &'

# Better ls
alias ls="eza --no-filesize --git --no-permissions --long --color=always --icons=always --no-user --all"

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# alias for adding line numbers to a thing
alias catn="cat -n"

# alias for removing failed commands from atuin history
alias atuindelete='sqlite3 $HOME/.local/share/atuin/history.db "DELETE FROM history WHERE exit != 0;"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"
