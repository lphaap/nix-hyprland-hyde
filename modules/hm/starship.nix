{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Make sure starship is installed
  home.packages = with pkgs; [
    starship
  ];
  
  # Create the starship configuration file
  home.file.".config/starship.toml" = {
	text = ''
		add_newline = true

		[character]
		success_symbol = '[⤷](green)'
		error_symbol = '[⤷](red)'	
	''
  };
}
