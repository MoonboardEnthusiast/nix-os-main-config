{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nvchad = {
      url = "github:NvChad/starter";
      flake = false;
    };

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";

    nix-straight.url = "github:librephoenix/nix-straight.el/pgtk-patch";
    nix-straight.flake = false;
    nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";

  };
  
  outputs = inputs@{ self, ... }:
  let
    systemSettings = {
        system = "x86_64-linux"; # system arch
        profile = "wsl"; # select a profile defined in profiles
      };
    userSettings = rec {
          username = "nixos"; # username
          name = "nixos"; # name/identifier
          email = "striedlful@gmail.com"; # email (used for certain configurations)
          dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
          theme = "io"; # selcted theme from my themes directory (./themes/)
          font = "Intel One Mono";
    };
    home-manager = inputs.home-manager-unstable;
    pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
    };
    pkgs-unstable = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
    };
    pkgs-emacs = import inputs.nixpkgs {
        system = systemSettings.system;
    };
    pkgs = pkgs-unstable;
    lib = inputs.nixpkgs.lib;
    nixos-wsl = inputs.nixos-wsl;
   in{
    homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit userSettings;
            inherit pkgs-stable;
            inherit pkgs-emacs;
            inherit inputs;
          };
        };
    };
    nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            nixos-wsl.nixosModules.wsl
            # inputs.lix-module.nixosModules.default
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
};
}
