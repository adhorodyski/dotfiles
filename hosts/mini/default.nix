{ lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
  ];

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
}
