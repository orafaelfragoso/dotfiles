{
  pkgs,
  username ? "rafael",
  homeDirectory ? if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}",
  ...
}:

{
  imports = [
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
