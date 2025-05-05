{
  description = "@lphaap NixOs master config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Hyprland Hyde
    hydenix = {
      url = "github:richen604/hydenix";
    };
    
    # NvChad
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixIndex
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, hydenix, ... }@inputs:
    let
      hostName = "luna";
      
      nixosConfiguration = inputs.hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
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
      nixosConfigurations.nixos = nixosConfiguration;
      nixosConfigurations.${hostName} = nixosConfiguration;
    };
}
