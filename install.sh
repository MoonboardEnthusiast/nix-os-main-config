#!/bin/sh
SCRIPT_DIR=$1

sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

sudo nixos-rebuild switch --flake .#system

nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#user