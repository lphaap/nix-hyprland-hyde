{
  config,
  lib,
  pkgs,
  ...
}:

{
	# In modules/hm/default.nix or a new file
	home.file.".config/hypr/userprefs.conf".text = ''
	# Your existing system config plus your keyboard settings
	input {
    		kb_layout = fi
    		kb_variant =
    		kb_model =
    		kb_options = caps:escape
    		kb_rules =
    		follow_mouse = 1
    		sensitivity = 0
	}
	'';
	force = true;
	mutable = true;
}
