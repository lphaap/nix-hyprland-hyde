{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # PHP 8.4 (latest version)
    php84
    php84Packages.composer
    
    # PHP Extensions
    php84Extensions.pdo
    php84Extensions.pdo_mysql
    php84Extensions.pdo_pgsql
    php84Extensions.mysqli
    php84Extensions.curl
    php84Extensions.mbstring
    php84Extensions.memcached
    php84Extensions.memcache
    php84Extensions.redis
    
    # Encryption/Hashing Extensions
    php84Extensions.openssl
    php84Extensions.sodium
    
    # Development tools
    php84Packages.php-cs-fixer
    php84Packages.phpstan
    php84Packages.psalm
  ];
}
