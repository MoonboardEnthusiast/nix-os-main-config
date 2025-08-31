{ pkgs, ... }:

{
  home.packages = with pkgs; [
      # CC
      gcc
      gnumake
      cmake
      autoconf
      automake
      libtool
      clang-tools
      clang_21
      gdb
      coreutils
  ];
}
