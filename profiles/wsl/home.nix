{ pkgs, inputs, userSettings, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/"+userSettings.username;
  home.stateVersion = "23.11";
  
  imports = [
    ../../user/.bundle.nix
  ];

  # User packages
  home.packages = with pkgs; [
    git
    zsh
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "MoonboardEnthusiast";
    userEmail = "striedlful@gmail.com";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
