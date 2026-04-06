# PaperColor Dark -- pure data, no lib/mkOption
{
  name = "papercolor";

  wallpaper = ../media/pic/wall/nature.png;

  font = {
    family = "Pixel Code";
    package = "pixel-code";
    size = 10;
  };

  neovim = {
    colorscheme = "PaperColor";
    background = "dark";
  };

  alacritty = {
    theme = "papercolor_dark";
  };

  gnome = {
    colorScheme = "prefer-dark";
    accentColor = "teal";
    borderColor = "rgba(182, 184, 187, 0.8)";
  };

  tmux = {
    bg = "#0c0c0c";
    fg = "#b6b8bb";
    accent = "#78a9ff";
    accentAlt = "#2190A4";
    inactive = "#7b7c7e";
  };
}
