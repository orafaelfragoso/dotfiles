if [[ ! -t 0 ]]; then
  return
fi

bindkey '^I' expand-or-complete
bindkey -M emacs '^I' expand-or-complete
bindkey -M viins '^I' expand-or-complete

if (( ${+widgets[autosuggest-accept]} )); then
  bindkey '^@' autosuggest-accept
  bindkey -M emacs '^@' autosuggest-accept
  bindkey -M viins '^@' autosuggest-accept

  [[ -n "${key[Right]}" ]] && bindkey "${key[Right]}" autosuggest-accept
  [[ -n "${key[Right]}" ]] && bindkey -M emacs "${key[Right]}" autosuggest-accept
  [[ -n "${key[Right]}" ]] && bindkey -M viins "${key[Right]}" autosuggest-accept
  bindkey '^[[C' autosuggest-accept
  bindkey -M emacs '^[[C' autosuggest-accept
  bindkey -M viins '^[[C' autosuggest-accept
fi

if (( ${+widgets[fzf-completion]} )); then
  bindkey '^[[Z' fzf-completion
  bindkey -M emacs '^[[Z' fzf-completion
  bindkey -M viins '^[[Z' fzf-completion
else
  bindkey '^[[Z' expand-or-complete
  bindkey -M emacs '^[[Z' expand-or-complete
  bindkey -M viins '^[[Z' expand-or-complete
fi
