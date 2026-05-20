{ pkgs, ... }:

{
  nix = {
    enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.rafael = {
    home = "/Users/rafael";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
    brews = [
      "git"
      "zsh"
    ];
    casks = [
      "font-fira-code-nerd-font"
      "kitty"
    ];
  };

  system = {
    primaryUser = "rafael";
    stateVersion = 6;
  };
}
