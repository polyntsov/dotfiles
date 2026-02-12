{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls="ls --color=auto";
      la="ls -a";
      ll="ls -l";
      grep="grep --color=auto";
    };

    history.size = 20000;
    history.path = "$HOME/.cache/zsh/.histfile";
  };
}
