{ config, lib, pkgs, inputs, ... }:
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
  home.packages = with pkgs; [
    bazelisk
  ];
}

