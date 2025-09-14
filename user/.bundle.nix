{ ... }:
{
  imports = [
    ./app/nvim/nvim.nix
    ./app/bazel/bazel.nix
    ./app/ranger/ranger.nix
    # ./app/doom-emacs/doom.nix
    # ./app/emacsng/default.nix not really useable
    ./style/stylix.nix
    ./terminal/kitty.nix
    ./terminal/alacritty.nix
    ./shell/sh.nix
    ./shell/cli-collection.nix
  ];
}