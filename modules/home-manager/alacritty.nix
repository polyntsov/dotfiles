{ config, pkgs, ... }:

{
  programs.alacritty.enable = true;

  programs.alacritty.settings = {
    colors = {
      draw_bold_text_with_bright_colors = true;
    };

    scrolling = {
      history = 10000;
      multiplier = 3;
    };

    selection = {
      save_to_clipboard = false;
    };

    window = {
      opacity = 0.96;

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
      size = 10;
    };
  };
}

