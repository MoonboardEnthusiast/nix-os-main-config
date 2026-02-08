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
    claude-code
    opencode
    nodejs_20
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "MoonboardEnthusiast";
    userEmail = "striedlful@gmail.com";
  };

  # OpenSpec wrapper
  home.file.".local/bin/openspec" = {
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.nodejs_20}/bin/npx @fission-ai/openspec@latest "$@"
    '';
    executable = true;
  };
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
