{ pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Michael Polyntsov";
        email = "arno9148@gmail.com";
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
