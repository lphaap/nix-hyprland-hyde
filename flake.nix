{
  description = "@lphaap NixOs master config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hydenix = {
      url = "github:lphaap/nix-flake-hyprland-hyde";
    };
	
    nix4nvchad = {
      url = "github:lphaap/nix-flake-nvimchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      HOSTNAME = "luna";

      hydenixConfig = inputs.hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
        inherit (inputs.hydenix.lib) system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
        ];
      };

    in
    {
      nixosConfigurations.nixos = hydenixConfig;
      nixosConfigurations.${HOSTNAME} = hydenixConfig;
    };
}
