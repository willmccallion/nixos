## ── CMPUT 325 ─────────────────────────────────────────────────────────────────
## Non-Procedural Programming Languages.
## Installs Lisp (SBCL) and Prolog (SWI-Prolog).
## Toggle languages on/off as the course progresses.
{ pkgs, lib, ... }:

let
  enableLisp = false;
  enableProlog = true;
in
{
  home.packages = with pkgs;
    lib.optionals enableProlog [ swi-prolog ]
    ++ lib.optionals enableLisp [ sbcl ];
}
