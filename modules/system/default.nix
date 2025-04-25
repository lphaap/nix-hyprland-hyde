{ ... }:

{
  imports = [
    ./keyboard.nix
    ./docker.nix
  ];

  environment.systemPackages = [
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
}
