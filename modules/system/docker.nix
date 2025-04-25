{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable Docker service
  virtualisation.docker = {
    enable = true;
    # Enable nvidia-container-runtime for GPU support
    # Uncomment if you need NVIDIA GPU support in containers
    # enableNvidia = true;
  };

  # Add Docker packages to system
  environment.systemPackages = with pkgs; [
    docker
    docker-client
  ];

  # Create docker named user group for non-root users
  users.groups.docker.members = [ "lphaap" ];
}
