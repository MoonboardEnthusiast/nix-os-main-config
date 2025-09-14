# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
{
  imports = [
    ../../system/.bundle.nix
    # ../../system/hardware-configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Add any libraries bazelisk might need
  stdenv.cc.cc
  glibc
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    # C/C++ LSP
    clang-tools # includes clangd
    nixfmt-classic
    # Rust LSP and tools
    rust-analyzer
    rustc
    cargo
    ripgrep
    # Optional but useful
    gcc
    coreutils
    go
    gdb
    cmake
    gnumake
    # shared clipboard
    wl-clipboard
    # clang compiler
    clang_21
  ];
  services.xserver.enable = true;
  services.dbus.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
  };
}

