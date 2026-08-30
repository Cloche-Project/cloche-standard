#
# Cloche Zsh configuration
#

# Completion
autoload -U compinit
compinit

# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# Starship
eval "$(starship init zsh)"
