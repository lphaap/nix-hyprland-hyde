{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Node.js - latest stable
    nodejs_23
    
    # Package managers
    nodePackages.pnpm
    yarn
    bun  # Bun runtime and package manager
    
    # TypeScript and related tools
    nodePackages.typescript
    nodePackages.ts-node
    nodePackages.typescript-language-server
  ];
}
