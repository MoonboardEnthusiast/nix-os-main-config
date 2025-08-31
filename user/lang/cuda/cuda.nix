{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages.cudnn
    linuxPackages.nvidia_x11
    cudaPackages.libcublas          # Basic linear algebra
    cudaPackages.libcurand          # Random number generation
    cudaPackages.libcufft           # FFT library
    cudaPackages.libcusparse        # Sparse matrix operations
    cudaPackages.cuda_cccl          # CUDA C++ Core Libraries
    cudaPackages.cuda_nvcc          # NVCC compiler
    cudaPackages.cuda_nvprof        # Profiler
 ];
}
