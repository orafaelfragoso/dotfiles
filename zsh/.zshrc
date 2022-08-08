export ZSH="$HOME/.oh-my-zsh"

# theme
ZSH_THEME="spaceship"

# plugins
plugins=(git asdf)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Path aliases
export PATH="$HOME/.local/bin:$PATH"

# aliases
alias vim="nvim"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# variables
XDG_CONFIG_HOME="~/.config"

# tmux
if [ -z "$TMUX" ]
then
  tmux -f ~/.config/tmux/tmux.conf attach -t TMUX || tmux -f ~/.config/tmux/tmux.conf new -s TMUX
fi

# spaceship config
SPACESHIP_PROMPT_ORDER=(dir git node)
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_HG_SHOW=false
SPACESHIP_GIT_STATUS_SHOW=false
SPACESHIP_EXEC_TIME_SHOW=false
SPACESHIP_PROMPT_ADD_NEWLINE=false

