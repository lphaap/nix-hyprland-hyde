{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Node.js - latest stable
    nodejs_latest
    
    # Package managers
    nodePackages.npm
    nodePackages.pnpm
    yarn
    bun  # Bun runtime and package manager
    
    # TypeScript and related tools
    nodePackages.typescript
    nodePackages.ts-node
    nodePackages.typescript-language-server
    
    # JS/TS linting and formatting
    nodePackages.eslint
    nodePackages.prettier
  ];

  # Add Node version management
  programs.nvm = {
    enable = true;
  };
}
