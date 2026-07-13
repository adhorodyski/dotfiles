{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    dns = [ "1.1.1.1" "9.9.9.9" ];
  };
  environment.systemPackages = [ pkgs.docker-compose ];
  users.users.adhorodyski.extraGroups = [ "docker" ];
}
