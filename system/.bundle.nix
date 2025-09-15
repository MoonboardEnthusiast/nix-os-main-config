{ ... }:
{
  imports = [
    ./cuda/cuda.nix
    ./style/stylix.nix
    ./xserver/xserver.nix
    ./security/gpg.nix
  ];
}