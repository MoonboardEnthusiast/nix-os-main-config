{
  description = "Bazel 8";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "bazel";
          version = "8.3.1"; # or whatever 8.x version you need

          src = pkgs.fetchurl {
            url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-linux-x86_64";
            # You'll need to get the actual hash - use `nix-prefetch-url` or set to an empty string initially
            sha256 = "sha256:17247e8a84245f59d3bc633d0cfe0a840992a7760a11af1a30012d03da31604c"; 
          };

          dontUnpack = true;
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/bazel
            chmod +x $out/bin/bazel
          '';

          meta = with pkgs.lib; {
            description = "Build tool that builds code quickly and reliably";
            homepage = "https://bazel.build/";
            license = licenses.asl20;
            platforms = platforms.linux;
          };
        };
      });
}
