{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  jj-starship = inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default;
  jj-starship-wrapped = pkgs.writeShellScript "jj-starship-prompt" ''
    output=$(${jj-starship}/bin/jj-starship \
      --no-color \
      --no-git-id --no-git-status --no-git-prefix \
      --no-jj-id --no-jj-status --no-jj-prefix \
      "$@")
    # jj wraps bookmarks in (), git branch is bare — normalize both to ()
    if [ -n "$output" ] && ! echo "$output" | grep -q '^('; then
      echo "($output)"
    else
      echo "$output"
    fi
  '';
in
{
  home.packages = [ jj-starship ];

  programs.starship = {
    enable = true;

    settings = {
      format = "$directory$nix_shell\${custom.jj}$python$character";
      add_newline = false;
      directory.style = "bold blue";

      character = {
        success_symbol = "[❯](bold cyan)";
        error_symbol = "[❯](bold cyan)";
        vimcmd_visual_symbol = "[❯](bold cyan)";
        vimcmd_symbol = "[❮](bold purple)";
        vimcmd_replace_symbol = "[❮](bold purple)";
        vimcmd_replace_one_symbol = "[❮](bold purple)";
      };

      python.format = "[\${pyenv_prefix}(\\($virtualenv\\) )]($style)";

      git_branch.disabled = true;
      git_status.disabled = true;

      custom.jj = {
        when = "${jj-starship}/bin/jj-starship detect";
        command = "${jj-starship-wrapped}";
        format = "[$output](bold white) ";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "🌨 ";
        pure_msg = "❄ ";
        unknown_msg = "⛄ ";
        format = "[<$state $name>](bold blue) ";
      };

      line_break.disabled = true;
      package.disabled = true;
    };
  };
}
