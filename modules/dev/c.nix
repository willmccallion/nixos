{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (lib.hiPrio gcc)
    clang-tools
    cmake
    valgrind
    pkg-config
  ];
}
