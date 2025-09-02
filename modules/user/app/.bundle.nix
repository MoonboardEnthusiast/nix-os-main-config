{ ... }:
{
  imports =
    [
      ./bazel/bazel.nix
      ./doom-emacs/doom.nix
      ./emacsng/default.nix
      ./git/git.nix
      ./nvim/nvim.nix
      ./ranger/ranger.nix
      ./terminal/alacritty.nix
      ./terminal/kitty.nix
      ./tmux/tmux.nix
   ];
}
