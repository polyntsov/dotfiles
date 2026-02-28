{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = {
        name = "Michael Polyntsov";
        email = "Arno9148@gmail.com";
      };

      alias = {
        hist = "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(normal)%s %C(dim cyan){{%an}}%C(reset) %C(magenta)%d%C(reset)' --graph --date=short";
        st = "status";
        ch = "checkout";
        chpr = "!f() { if [ $# -eq 3 ]; then git fetch $1 pull/$2/head:$3; git checkout $3; else echo 'Usage: git chpr <remote> <pull_id> <branch_name>'; fi; }; f";
      };

      core = {
        excludesFile = "/home/arno/.gitignore";
        editor = "nvim";
      };

      pull = {
        ff = "only";
      };
    };
  };

  home.packages = [ pkgs.git-lfs ];
}
