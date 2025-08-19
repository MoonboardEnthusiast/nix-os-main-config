# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
# In your configuration.nix or as an overlay
let
  bazel8 = pkgs.bazel.overrideAttrs (oldAttrs: rec {
    version = "8.3.1"; # or whatever version you need
    src = pkgs.fetchurl {
      url =
        "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
      sha256 =
        "79da863df05fa4de79a82c4f9d4e710766f040bc519fd8b184a4d4d51345d5ba"; # You'll need to get the correct hash
    };
  });
in {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
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
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
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
    gdb
    cmake
    gcc
    # or alternatively:
    bazelisk 
    # clang
  ];
}

