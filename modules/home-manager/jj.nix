{ pkgs, userSettings, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = userSettings.name;
        email = userSettings.email;
      };

      ui = {
        editor = "nvim";
        default-command = "status";
        paginate = "auto";
        pager = "less -FRX";
      };

      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "immutable_heads()" = "none()";
      };

      aliases = {
        push = [
          "git"
          "push"
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@-)"
          "--to"
          "@-"
        ];
        my = [
          "log"
          "-r"
          "mine()"
        ];
        ml = [
          "log"
          "-r"
          "visible_heads() & mine()"
        ];
        lf = [
          "log"
          "-r"
          "visible_heads()"
        ];
        blame = [
          "file"
          "annotate"
        ];
        sweep = [
          "abandon"
          "divergent() ~ ancestors(@)"
        ];
      };

      templates = {
        git_push_bookmark = "\"misha/push\" ++ change_id.short()";
      };

      remotes.origin = {
        auto-track-bookmarks = "glob:*";
      };
    };
  };
}
