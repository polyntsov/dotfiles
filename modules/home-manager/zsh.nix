{
  config,
  pkgs,
  lib,
  self,
  ...
}:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    history = {
      size = 20000;
      save = 10000;
      path = "${config.home.homeDirectory}/.cache/zsh/.histfile";
    };

    shellAliases = {
      ls = "ls --color=auto";
      la = "ls -a";
      ll = "ls -l";
      grep = "grep --color=auto";
    };

    dotDir = "${config.home.homeDirectory}/.config/zsh";

    # Completion setup
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-suffixes
      zstyle ':completion:*' expand prefix suffix
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)
      zstyle ':completion:*' rehash true
    '';

    initContent = ''
      # Colors
      autoload -U colors && colors

      # Bindings
      bindkey -e
      bindkey '\e' vi-cmd-mode
      export KEYTIMEOUT=1

      # Menu select vim keys
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      # Cursor shape for vi modes
      function zle-keymap-select {
        if [[ ''${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
          echo -ne '\e[2 q'
        elif [[ ''${KEYMAP} == main || ''${KEYMAP} == viins || ''${KEYMAP} = ''' || $1 = 'beam' ]]; then
          echo -ne '\e[6 q'
        fi
      }
      zle -N zle-keymap-select

      zle-line-init() {
        echo -ne "\e[6 q"
      }
      zle -N zle-line-init
      echo -ne '\e[6 q'
      preexec() { echo -ne '\e[6 q' ;}

      # Edit line in vim
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^e' edit-command-line

      # Autocorrection
      setopt CORRECT CORRECT_ALL

      # FZF key-bindings and completion (manual sourcing)
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # FZF defaults matching your old setup
      export IGNORE_DIRS='--ignore-dir .local --ignore-dir .git --ignore-dir .mozilla --ignore-dir .thunderbird --ignore-dir .dotfiles --ignore-dir .cache'
      export FZF_CTRL_T_COMMAND="ag --hidden $IGNORE_DIRS -g """
      export FZF_ALT_C_COMMAND="ag --hidden $IGNORE_DIRS -g """

      # Run animation then fastfetch on terminal open (not in tmux or subshells)
      if [[ -z "$TMUX" && "$SHLVL" -eq 1 ]]; then
        python ${self}/media/animations/flakes.py --transition 1 && fastfetch
      fi
    '';
  };

  # Required packages
  home.packages = with pkgs; [
    fzf
    silver-searcher
    starship
  ];
}
