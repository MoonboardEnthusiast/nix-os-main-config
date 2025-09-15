{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # shared clipboard
    go
  ];
}
