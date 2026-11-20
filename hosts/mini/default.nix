{ lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";

  hardware.bluetooth = {
    enable = true;
    input.General.ClassicBondedOnly = false;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  systemd.services.restore-on-ac-power = {
    description = "Power on when AC power returns";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.pciutils}/bin/setpci -s 00:1f.0 0xa4.b=0:1";
    };
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      5353   # mDNS (Crucial for phone/accessory discovery)
      19788  # OpenThread Link port (For multi-Border Router sync)
    ];
    allowedTCPPorts = [
      8123 # HAOS App
    ];
  };

  # Ensure multicast routing is allowed on the kernel level
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.wlp2s0b1.accept_ra" = 2;
    "net.ipv6.conf.wlp2s0b1.accept_ra_rt_info_max_plen" = 64;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "b43-firmware";
  networking.enableB43Firmware = true;
  boot.blacklistedKernelModules = [ "wl" "brcmsmac" "brcmfmac" ];

  environment.systemPackages = [ pkgs.restic ];
}
