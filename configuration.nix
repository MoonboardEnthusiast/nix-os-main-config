# Edit this configuration file to define what should be installed onj
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nix.settings = {
	substituters = ["https://cuda-maintainers.cachix.org"];
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
    bazelisk
    (runCommand "bazel" {} ''
    mkdir -p $out/bin
    ln -s ${bazelisk}/bin/bazelisk $out/bin/bazel
    '')
    gcc
    # or alternatively:
    # clang
  ];
}


