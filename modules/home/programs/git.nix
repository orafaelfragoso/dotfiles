{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Rafael Fragoso";
        email = "rafaelfragosom@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  xdg.configFile."git/ignore".text = ''
    **/.claude/settings.local.json
  '';
}
