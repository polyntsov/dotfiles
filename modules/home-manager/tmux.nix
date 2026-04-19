{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.tmux;
in
{
  options.my.tmux = {
    enable = lib.mkEnableOption "tmux with theme support";

    bg = lib.mkOption {
      type = lib.types.str;
      description = "Background color";
    };

    fg = lib.mkOption {
      type = lib.types.str;
      description = "Foreground color";
    };

    accent = lib.mkOption {
      type = lib.types.str;
      description = "Accent color";
    };

    accentAlt = lib.mkOption {
      type = lib.types.str;
      description = "Alternative accent color (hostname bg)";
    };

    inactive = lib.mkOption {
      type = lib.types.str;
      description = "Inactive text color";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      prefix = "C-a";
      escapeTime = 0;
      historyLimit = 50000;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "alacritty";
      extraConfig = ''
        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # reload config file
        bind r source-file ~/.tmux.conf

        # switching panes
        bind -r Tab select-pane -t :.+
        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R

        # resize panes
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # status line - conditional load (won't work perfectly in Nix, but closest)
        if-shell "test -f ~/.config/tmux.statusline" "source ~/.config/tmux.statusline"

        # terminal overrides
        #set -as terminal-features ",*:RGB"
        #set -ag terminal-overrides ",xterm-256color:RGB"

        # copy mode vi bindings for Wayland
        set-option -s set-clipboard off
        bind P paste-buffer
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'

        # Popups
        bind C-p display-popup -d "#{pane_current_path}" -E "python3"
        bind C-t display-popup -d "#{pane_current_path}" -E "zsh"
        bind C-g display-popup -d "#{pane_current_path}" -w 80% -h 80% -E "lazygit"

        # Colors and status line
        set -g mode-style "fg=${cfg.bg},bg=${cfg.fg}"
        set -g message-style "fg=${cfg.bg},bg=${cfg.fg}"
        set -g message-command-style "fg=${cfg.bg},bg=${cfg.fg}"
        set -g pane-border-style "fg=${cfg.fg}"
        set -g pane-active-border-style "fg=${cfg.accent}"
        set -g status "on"
        set -g status-justify "left"
        set -g status-style "fg=${cfg.fg},bg=${cfg.bg}"
        set -g status-left-length "100"
        set -g status-right-length "100"
        set -g status-left-style NONE
        set -g status-right-style NONE
        set -g status-left "#[fg=${cfg.accent},nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=${cfg.bg},bg=${cfg.bg},nobold,nounderscore,noitalics]#[fg=${cfg.accent},bg=${cfg.bg}] #{prefix_highlight} #[fg=${cfg.fg},bg=${cfg.bg},nobold,nounderscore,noitalics] #[fg=${cfg.bg},bg=${cfg.fg}] %Y-%m-%d   %I:%M %p #[fg=${cfg.accent},bg=${cfg.fg},nobold,nounderscore,noitalics] #[fg=${cfg.bg},bg=${cfg.accentAlt},bold] #h "
        setw -g window-status-activity-style "underscore,fg=${cfg.inactive},bg=${cfg.bg}"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=${cfg.inactive},bg=${cfg.bg}"
        setw -g window-status-format "#[fg=${cfg.bg},bg=${cfg.bg},nobold,nounderscore,noitalics]#[default] #I #W #[fg=${cfg.bg},bg=${cfg.bg},nobold,nounderscore,noitalics]"
        setw -g window-status-current-format "#[fg=${cfg.bg},bg=${cfg.fg},nobold,nounderscore,noitalics]#[fg=${cfg.bg},bg=${cfg.fg},bold] #I #W #[fg=${cfg.fg},bg=${cfg.bg},nobold,nounderscore,noitalics]"
      '';
    };
  };
}
