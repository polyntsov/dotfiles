{ config, pkgs, lib, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    pixel-code
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Symbols Nerd Font" ];
    };
  };
}
