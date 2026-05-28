{ pkgs, ... }:

{
  home.packages = with pkgs; [
    biome
    lua-language-server
    marksman
    oxfmt
    oxlint
    prettier
    stylua
    typescript-language-server
    vscode-langservers-extracted
  ];

  xdg.configFile."nvim/init.lua".source = ../files/nvim/init.lua;
  xdg.configFile."nvim/lua".source = ../files/nvim/lua;
  xdg.configFile."nvim/nvim-pack-lock.json".source = ../files/nvim/nvim-pack-lock.json;
}
