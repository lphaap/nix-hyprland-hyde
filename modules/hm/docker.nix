{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Docker configuration for Home Manager
  home.packages = with pkgs; [
    docker-compose
    lazydocker      # Terminal UI for Docker
  ];
}
