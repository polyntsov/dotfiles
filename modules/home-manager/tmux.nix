{ config, pkgs, ... }:

{
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
      set -g mode-style "fg=#0c0c0c,bg=#b6b8bb"
      set -g message-style "fg=#0c0c0c,bg=#b6b8bb"
      set -g message-command-style "fg=#0c0c0c,bg=#b6b8bb"
      set -g pane-border-style "fg=#b6b8bb"
      set -g pane-active-border-style "fg=#78a9ff"
      set -g status "on"
      set -g status-justify "left"
      set -g status-style "fg=#b6b8bb,bg=#0c0c0c"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-left-style NONE
      set -g status-right-style NONE
      set -g status-left "#[fg=#78a9ff,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]#[fg=#78a9ff,bg=#0c0c0c] #{prefix_highlight} #[fg=#b6b8bb,bg=#0c0c0c,nobold,nounderscore,noitalics] #[fg=#0c0c0c,bg=#b6b8bb] %Y-%m-%d   %I:%M %p #[fg=#78a9ff,bg=#b6b8bb,nobold,nounderscore,noitalics] #[fg=#0c0c0c,bg=#2190A4,bold] #h "
      setw -g window-status-activity-style "underscore,fg=#7b7c7e,bg=#0c0c0c"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#7b7c7e,bg=#0c0c0c"
      setw -g window-status-format "#[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]#[default] #I #W #F #[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#0c0c0c,bg=#b6b8bb,nobold,nounderscore,noitalics]#[fg=#0c0c0c,bg=#b6b8bb,bold] #I #W #F #[fg=#b6b8bb,bg=#0c0c0c,nobold,nounderscore,noitalics]"
    '';
  };
}


