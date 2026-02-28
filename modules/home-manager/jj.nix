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
    };
  };
}
