# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
# In your configuration.nix or as an overlay
let
  bazel8 = pkgs.bazel.overrideAttrs (oldAttrs: rec {
    version = "8.3.1"; # or whatever version you need
    src = pkgs.fetchurl {
      url =
        "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
      sha256 =
        "79da863df05fa4de79a82c4f9d4e710766f040bc519fd8b184a4d4d51345d5ba"; # You'll need to get the correct hash
    };
  });
  cudaEnv = pkgs.buildEnv {
    name = "cuda-unified";
    paths = with pkgs.cudaPackages; [
      cudatoolkit
      cuda_cudart.static
      ];
    postBuild = ''
    # Create lib64 symlink to lib if it doesn't exist
    if [ -d "$out/lib" ] && [ ! -d "$out/lib64" ]; then
      ln -s lib "$out/lib64"
    fi
    '';  
    };
in {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Add any libraries bazelisk might need
  stdenv.cc.cc
  glibc
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
    # Shell aliases for all users
  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
    grep = "grep --color=auto";
    ".." = "cd ..";
    bazel = "bazelisk";
    nixrebuild = "sudo nixos-rebuild switch";
  };
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    # C/C++ LSP
    clang-tools # includes clangd
    nixfmt-classic
    # Rust LSP and tools
    rust-analyzer
    rustc
    cargo
    ripgrep
    # Optional but useful
    gcc
    coreutils
    go
    gdb
    cmake
    gnumake
    # or alternatively:
    bazelisk 
    # system libraries that CUDA could need
    libGLU
    libGL
    xorg.libXi
    xorg.libXmu
    freeglut
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    zlib
    ncurses5
    busybox
    # clang
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    linuxPackages.nvidia_x11
    cudaPackages.libcublas          # Basic linear algebra
#    cudaPackages.libcudart          #
    cudaPackages.libcurand          # Random number generation
    cudaPackages.libcufft           # FFT library
    cudaPackages.libcusparse        # Sparse matrix operations
    cudaPackages.cuda_cccl          # CUDA C++ Core Libraries
    
    # Development packages
    cudaPackages.cuda_nvcc          # NVCC compiler
    cudaPackages.cuda_nvprof        # Profiler
    # shared clipboard
    wl-clipboard
    # clang compiler
    clang_21
  ];
  # Ensure NVIDIA kernel modules are loaded (WSL-specific)
  boot.kernelModules = [ "nvidia" "nvidia-uvm" "nvidia-modeset" ];
  # Enable OpenGL and CUDA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  # Load NVIDIA drivers
  # Create a unified cudaEnv for rules_cuda library lookup to work
  environment.sessionVariables = {
      LIBRARY_PATH = "/usr/lib/wsl/lib:${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.cudaPackages.cuda_cudart}/lib";
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib:${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.cudaPackages.cuda_cudart}/lib";
      CUDA_PATH = "${cudaEnv}";
      CUDA_ROOT = "${pkgs.cudaPackages.cudatoolkit}";
      CUDA_CUDART_STATIC = "${pkgs.cudaPackages.cuda_cudart.static}";
      EXTRA_LDFLAGS="-L/lib -L${pkgs.cudaPackages.cudatoolkit}/lib";
      EXTRA_CCFLAGS="-I/usr/include -I${pkgs.cudaPackages.cudatoolkit}/include";
  };
  environment.etc."ld.so.conf.d/wsl-nvidia.conf".text = "/usr/lib/wsl/lib";
  # Use this to safely prepend to PATH
  environment.extraInit = ''
    export PATH="${pkgs.cudaPackages.cudatoolkit}/bin:/usr/lib/wsl/lib:${pkgs.cudaPackages.cuda_cudart}/bin/:$PATH"
  '';
}

