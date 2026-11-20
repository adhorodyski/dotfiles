{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  environment.systemPackages = [ pkgs.docker-compose ];
  users.users.adhorodyski.extraGroups = [ "docker" ];
}
