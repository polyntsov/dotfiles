{ config, pkgs, lib, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

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

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    (stdenv.mkDerivation rec {
      pname = "gnome-shell-extension-p7-borders";
      version = "758e78bac33b5bb3e60366f6de4b337eeffc2f98";

      src = fetchFromGitHub {
        owner = "prasannavl";
        repo = "p7-borders-shell-extension";
        rev = version;
        sha256 = "0k0yjzspvrb333fffblwr66xb7kkqqmvjjzh9znzrzhlivl4br78";
      };

      nativeBuildInputs = [ glib ];

      buildPhase = ''
        glib-compile-schemas schemas
      '';

      installPhase = ''
        mkdir -p $out/share/gnome-shell/extensions/p7-borders@prasannavl.com
        cp -r * $out/share/gnome-shell/extensions/p7-borders@prasannavl.com
      '';
    })
    wl-clipboard
  ];
  environment.gnome.excludePackages = with pkgs; [
    gnome-contacts
    gnome-initial-setup
    gnome-tour
    gnome-user-docs
    epiphany # web browser
    yelp # Help view
  ];

  programs.dconf.enable = true;
  home-manager.sharedModules = [
    {
      dconf.settings = let
        wallpaper = "file://${../../media/pic/wall/nature.png}";
      in {
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 4;
        };

        "org/gnome/shell/keybindings" = {
          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];

          move-to-workspace-1 = [ "<Super><Shift>1" ];
          move-to-workspace-2 = [ "<Super><Shift>2" ];
          move-to-workspace-3 = [ "<Super><Shift>3" ];
          move-to-workspace-4 = [ "<Super><Shift>4" ];

          switch-applications = [ ];
          switch-applications-backward = [ ];
          switch-windows = [ "<Alt>Tab" ];
          close = [ "<Super>q" ];
        };

        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "grp:alt_shift_toggle" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>Return";
          command = "alacritty";
          name = "Alacritty";
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          accent-color = "teal";
        };

        "org/gnome/desktop/background" = {
          picture-uri = wallpaper;
          picture-uri-dark = wallpaper;
          primary-color = "#000000";
          secondary-color = "#000000";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = wallpaper;
          primary-color = "#000000";
          secondary-color = "#000000";
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;

          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "p7-borders@prasannavl.com"
          ];
        };

        "org/gnome/shell/extensions/p7-borders" = {
          default-enabled = true;
          default-active-color = "rgba(33, 144, 164, 0.8)";
        };
      };
    }
  ];
}
