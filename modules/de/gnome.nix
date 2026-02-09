{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable the X11 windowing system.
  services.xserver.enable = false;

  # Configure keymap in X11 (and for GNOME)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixpkgs.overlays = [
    (final: prev: {
      # 50.alpha of gsd fixes resuspends after wakeups
      gnome-settings-daemon = prev.gnome-settings-daemon.overrideAttrs (old: {
        src = prev.fetchgit {
          url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon.git";
          rev = "50.alpha";
          sha256 = "151b9sdb2f4045f25ddgv896fxzwfmidy9vps03cqx62ciwglrjn";
          fetchSubmodules = true;
        };
        version = "50.alpha";
      });
    })
  ];
}
