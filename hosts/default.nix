{ lib, config, pkgs, pkgs-stable, ... }:
{
  # services
  timesyncd.enable = true;
  # pkgs
  pkgsCore.enable = true;

  # for nix-index-database
  programs.command-not-found.enable = false;

  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}
