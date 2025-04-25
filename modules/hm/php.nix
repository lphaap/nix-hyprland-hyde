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
  
  # Install Composer separately through a shell script to avoid the LICENSE collision
  home.file.".local/bin/composer-install.sh" = {
    text = ''
      #!/bin/sh
      # Download the latest Composer and install it to ~/.local/bin/composer
      EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
      php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
      ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

      if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
      then
          >&2 echo 'ERROR: Invalid installer checksum'
          rm composer-setup.php
          exit 1
      fi

      php composer-setup.php --quiet --install-dir=$HOME/.local/bin --filename=composer
      RESULT=$?
      rm composer-setup.php
      exit $RESULT
    '';
    executable = true;
  };
  
  # Create directories needed
  home.file.".local/bin/.keep" = {
    text = "";
  };
}
