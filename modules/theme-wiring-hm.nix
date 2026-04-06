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
    my.alacritty = {
      enable = true;
      theme = cfg.alacritty.theme;
      fontFamily = cfg.font.family;
      fontSize = cfg.font.size;
    };

    my.tmux = {
      enable = true;
      inherit (cfg.tmux)
        bg
        fg
        accent
        accentAlt
        inactive
        ;
    };

    my.neovim = {
      enable = true;
      colorscheme = cfg.neovim.colorscheme;
      background = cfg.neovim.background;
    };
  };
}
