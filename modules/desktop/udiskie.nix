## ── Udiskie ──────────────────────────────────────────────────────────────────
## Auto-mounts removable drives under /run/media and notifies via swaync.
## Remove this import from desktop/default.nix to disable.
{ ... }:

{
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };
}
