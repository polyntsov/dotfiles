{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.font;
in
{
  options.my.font = {
    enable = lib.mkEnableOption "system font configuration with theme support";

    package = lib.mkOption {
      type = lib.types.str;
      description = "Font package attribute name in nixpkgs";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.${cfg.package}
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Symbols Nerd Font" ];
      };
    };
  };
}
