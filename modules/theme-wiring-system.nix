{ config, lib, ... }:

let
  cfg = config.my.theme;
in
{
  options.my.theme = lib.mkOption {
    type = lib.types.attrs;
    description = "Theme configuration";
  };

  config = {
    my.gnome = {
      enable = true;
      wallpaper = cfg.wallpaper;
      colorScheme = cfg.gnome.colorScheme;
      accentColor = cfg.gnome.accentColor;
      borderColor = cfg.gnome.borderColor;
    };
  };
}
