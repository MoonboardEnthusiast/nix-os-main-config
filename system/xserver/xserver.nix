{ lib, config, pkgs, inputs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xauth
    xorg.xhost
    # D-bus and portal services
    dbus 
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];
  # Enable desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*"; # Fix afterwards there is actually new behavior in place for version >1.18
  };
  environment.sessionVariables = {
      WAYLAND_DISPLAY="";
      DISPLAY="localhost:0.0";
      EDITOR="nvim";
  };
}
