{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bun
    chafa
    fd
    fzf
    git
    neovim
    nil
    nixfmt
    ripgrep
    tmux
    tree-sitter
    viu
    zsh
  ];
}
