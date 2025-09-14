{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    neovim
    neovim-remote
    neovide
    lua-language-server
    vscode-langservers-extracted
    nil
    clang-tools
    marksman
    typescript-language-server
    java-language-server
    dockerfile-language-server
    docker-compose-language-service
    kotlin-language-server
    bash-language-server
    yaml-language-server
    sqls
    nmap
    ripgrep
  ];
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };
  # First, copy the NvChad starter template
  home.file.".config/nvim" = {
    source = inputs.nvchad;
    recursive = true;
  };

  # Then overlay your custom configs on top
  home.file.".config/nvim/lua/configs" = {
    source = ./lua/configs;
    recursive = true;
  };

  home.file.".config/nvim/lua/plugins" = {
    source = ./lua/plugins;
    recursive = true;
  };

  # Copy other custom files individually
  home.file.".config/nvim/lua/chadrc.lua".source = ./lua/chadrc.lua;
  home.file.".config/nvim/lua/options.lua".source = ./lua/options.lua;
  home.file.".config/nvim/lua/mappings.lua".source = ./lua/mappings.lua;
  home.file.".config/nvim/lua/themes/stylix.lua".source = config.lib.stylix.colors {
      template = builtins.readFile ./lua/themes/stylix.lua.mustache;
      extension = ".lua";
  };
}
