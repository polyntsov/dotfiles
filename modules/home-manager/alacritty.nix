{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.alacritty;
in
{
  options.my.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal with theme support";

    theme = lib.mkOption {
      type = lib.types.str;
      description = "Alacritty color theme name";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      description = "Font family for the terminal";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      description = "Font size for the terminal";
    };

    bg = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Terminal background color override. If null, uses the theme file's background.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;

    programs.alacritty.theme = cfg.theme;

    programs.alacritty.settings = {
      colors = {
        draw_bold_text_with_bright_colors = true;
      }
      // lib.optionalAttrs (cfg.bg != null) {
        primary.background = cfg.bg;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      selection = {
        save_to_clipboard = false;
      };

      window = {
        opacity = 1;
        decorations = "None";

        dimensions = {
          columns = 110;
          lines = 32;
        };

        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };

        padding = {
          x = 5;
          y = 5;
        };
      };

      font = {
        normal = {
          family = cfg.fontFamily;
          style = "Regular";
        };
        size = cfg.fontSize;
      };
    };
  };
}
