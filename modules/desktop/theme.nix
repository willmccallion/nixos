## ── Theme ─────────────────────────────────────────────────────────────────────
## GTK/Qt theming, icon theme, and fonts.
## Dracula GTK ensures dark mode in GTK/Qt applications.
## Remove this import from desktop/default.nix to disable.
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    inter
  ];

  # xdg-desktop-portal-gtk reads this and reports it as
  # org.freedesktop.appearance color-scheme. Without it the portal answers
  # "no preference" and portal-aware apps (Firefox, libadwaita) render light.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # Pin the pre-26.05 default; the new default is null.
    gtk4.theme = config.gtk.theme;

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
