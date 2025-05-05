# modules/hm/nvchad.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix4nvchad.homeManagerModules.default
  ];
  
  programs.nvchad = {
    enable = true;
    
    # Essential dependencies for basic functionality
    extraPackages = with pkgs; [
      # Core tools
      ripgrep
      fd
      gcc
      gnumake
      
      # Language servers
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
    ];

    gcc = pkgs.gcc;
    
    # Minimal custom configuration
    extraConfig = ''
      -- Basic editor settings
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 8
    '';
    
    # No extra plugins to start with
    extraPlugins = ''
      return {}
    '';
    
    # Standard backup settings
    hm-activation = true;
    backup = true;
  };
}

