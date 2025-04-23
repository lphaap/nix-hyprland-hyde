{
  config,
  lib,
  pkgs,
  ...
}:

{
	# In modules/hm/default.nix or a new file
	home.file.".config/hypr/local.conf" = { 
		text = ''
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
	};
	home.activation.ensureHyprlandLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Ensuring local.conf is sourced in Hyprland configuration"
      
      MAIN_CONFIG="$HOME/.config/hypr/hyprland.conf"
      SOURCE_LINE="source = ~/.config/hypr/local.conf"
      
      if [ -f "$MAIN_CONFIG" ]; then
        if ! grep -q "$SOURCE_LINE" "$MAIN_CONFIG"; then
          echo "Adding source line for local.conf to hyprland.conf"
          echo "$SOURCE_LINE" >> "$MAIN_CONFIG"
        else
          echo "local.conf already sourced in hyprland.conf"
        fi
      else
        echo "Warning: hyprland.conf not found, will need to manually source local.conf"
      fi
    '';
}
