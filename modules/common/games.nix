{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    # Proton GE, don't forget to protonup after rebuild
    protonup-ng
  ];
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/${userSettings.username}/.steam/root/compatibilitytools.d";
  };
}
