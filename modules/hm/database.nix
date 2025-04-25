{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Database clients and tools
    dbeaver-bin         # Universal database manager
    
    # MySQL tools
    mycli            # MySQL CLI with auto-completion and syntax highlighting
    # PostgreSQL tools
    pgcli            # PostgreSQL CLI with auto-completion and syntax highlighting
    
    # SQLite tools
    sqlite           # Command line interface for SQLite
  ];
}
