{ ... }:
{
  imports = [
    ./app/bazel/bazel.nix
    ./app/nvim/nvim.nix
    ./app/ranger/ranger.nix
    ./app/wlclipboard/wlclipboard.nix
    ./lang/cc/cc.nix
    ./lang/go/go.nix
    ./lang/rust/rust.nix
    ./shell/cli-collection.nix
    ./shell/sh.nix
    ./style/stylix.nix
    ./terminal/alacritty.nix
    ./terminal/kitty.nix
  ];
}