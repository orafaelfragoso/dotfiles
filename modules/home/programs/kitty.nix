{
  programs.kitty = {
    enable = true;
    package = null;
  };

  xdg.configFile."kitty/kitty.conf".source = ../files/kitty.conf;
  xdg.configFile."kitty/catppuccin.conf".source = ../files/catppuccin.conf;
  xdg.configFile."kitty/dracula.conf".source = ../files/dracula.conf;
}
