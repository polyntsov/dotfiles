{ config, pkgs, lib, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    tmux
    tree
    silver-searcher
    ripgrep
    python3
    killall
    htop
    fastfetch
    gcc
    clang
    uv
  ];
}
