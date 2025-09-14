{ lib, config, pkgs, inputs, userSettings, ... }:
let
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
  nixpkgs.config.cudaSupport = true;
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  environment.systemPackages = with pkgs; [
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
    # Cuda packages
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    linuxPackages.nvidia_x11
    cudaPackages.libcublas          # Basic linear algebra
    # cudaPackages.libcudart          #
    cudaPackages.libcurand          # Random number generation
    cudaPackages.libcufft           # FFT library
    cudaPackages.libcusparse        # Sparse matrix operations
    cudaPackages.cuda_cccl          # CUDA C++ Core Libraries
    cudaPackages.cuda_nvcc          # NVCC compiler
    cudaPackages.cuda_nvprof        # Profiler
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
