{ pkgs, lib, ... }:
let
  mac = "AA:BB:CC:DD:EE:FF"; # TODO: Magic Trackpad 2 BT address (`bluetoothctl devices`)

  connect-mt = {
    linux = pkgs.writeShellApplication {
      name = "connect-mt";
      runtimeInputs = [ pkgs.bluez ];
      text = ''
        mac="${mac}"
        bluetoothctl power on >/dev/null
        bluetoothctl remove "$mac" >/dev/null 2>&1 || true

        echo ">> Flip the trackpad power switch OFF then ON (green light blinking)."
        read -rp "   Press Enter when ready... "

        echo "Scanning (up to 30s)..."
        bluetoothctl --timeout 30 scan on >/dev/null

        bluetoothctl pair "$mac"
        bluetoothctl trust "$mac"
        bluetoothctl connect "$mac"

        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
          echo "✓ Trackpad connected."
        else
          echo "✗ Not connected — toggle the switch and re-run." >&2
          exit 1
        fi
      '';
    };
    # darwin: stub — add a blueutil-based writeShellApplication here later,
    # then switch the home.packages line below to select per-platform.
  };
in
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ connect-mt.linux ];
}
