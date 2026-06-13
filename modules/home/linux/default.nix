{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
  ];

  # `programs.niri.enable` lives at the system level (modules/nixos/desktop.nix);
  # that nixosModule injects this HM module, which exposes only `settings`.
  programs.niri.settings = {
    prefer-no-csd = true;
    input.keyboard.xkb.layout = "us";
    layout = {
      gaps = 8;
      focus-ring.enable = false;
      border.enable = true;
      border.width = 2;
    };
    window-rules = [ 
      {
        clip-to-geometry = true;
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-right = 12.0;
          bottom-left = 12.0;
        }; 
      }
    ];
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
    binds = with config.lib.niri.actions; {
      "Mod+Return".action = spawn "ghostty";
      "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
      "Mod+Q".action = close-window;
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+J".action = focus-workspace-down;
      "Mod+K".action = focus-workspace-up;
      "Mod+Shift+J".action = move-column-to-workspace-down;
      "Mod+Shift+K".action = move-column-to-workspace-up;
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+Shift+E".action = quit;
    };
  };

  programs.noctalia-shell.enable = true;

  # GL override for Intel HD 4000 (reports 4.2; Ghostty needs 4.3).
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
