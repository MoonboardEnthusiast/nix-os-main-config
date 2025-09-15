{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # shared clipboard
    wl-clipboard
  ];
}
