{ config, pkgs, ... }:

{
  # niri compositor settings (KDL-as-nix). The niri home module is auto-injected
  # by niri.nixosModules.niri, which exposes `programs.niri.settings` here; niri
  # itself is enabled at the system level (modules/nixos/desktop.nix). Do NOT set
  # `programs.niri.enable` here — that option is not declared on the home side.
  programs.niri.settings = {
    prefer-no-csd = true;
    input.keyboard.xkb.layout = "us";
    layout = {
      gaps = 8;
      focus-ring.enable = true;
    };
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
    binds = with config.lib.niri.actions; {
      "Mod+Return".action = spawn "ghostty";
      "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
      "Mod+Q".action = close-window;
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+Shift+E".action = quit;
    };
  };

  # Noctalia desktop shell (settings left default — first-run wizard handles theming).
  programs.noctalia-shell.enable = true;

  # Ghostty terminal, with the GL version override scoped to Ghostty only.
  # Intel HD 4000 reports GL 4.2; Ghostty requires 4.3. The wrapper makes Mesa
  # report 4.3 for Ghostty alone, leaving other GL apps to see the real 4.2.
  # This module is mini-only today (it is the sole Linux host); if a Linux host
  # without this quirk is added later, guard this override.
  programs.ghostty = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "ghostty-gl43";
      paths = [ pkgs.ghostty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --set MESA_GL_VERSION_OVERRIDE 4.3 \
          --set MESA_GLSL_VERSION_OVERRIDE 430
      '';
    };
  };
}
