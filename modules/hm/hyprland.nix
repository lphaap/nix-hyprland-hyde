{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hydenix.hm.hyprland;
in {
home.file = {
  ".config/hypr/userprefs.conf" = {
    source = "${pkgs.hydenix.hyde}/Configs/.config/hypr/userprefs.conf";
    force = true;
    mutable = true;
  };
  
  # Then also create our own override file
  ".config/hypr/local.conf" = { 
    text = ''
      # Finnish keyboard layout configuration
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
  };
};

home.activation.loadLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  USERPREFS="$HOME/.config/hypr/userprefs.conf"
  KEYBOARD_CONF="$HOME/.config/hypr/local.conf"
  MARKER="# --- LOCAL USER CONFIG --- "
  
  # Make sure the directory exists with proper permissions
  mkdir -p "$(dirname "$USERPREFS")"
  
  # If the file exists, ensure we have the right to modify it
  if [ -f "$USERPREFS" ]; then
    # Try to make it writable
    chmod u+w "$USERPREFS" 2>/dev/null || true
    
    # If we still don't have write permission, create a backup and make a new one
    if [ ! -w "$USERPREFS" ]; then
      echo "Cannot write to $USERPREFS, creating a new file..."
      # Save original content if possible
      if [ -r "$USERPREFS" ]; then
        ORIGINAL_CONTENT=$(cat "$USERPREFS" 2>/dev/null || echo "")
        BACKUP_FILE="$USERPREFS.bak.$(date +%s)"
        echo "$ORIGINAL_CONTENT" > "$BACKUP_FILE" 2>/dev/null || true
        # Create new file with original content plus our additions
        echo "$ORIGINAL_CONTENT" > "$USERPREFS.new"
        if ! grep -q "$MARKER" "$USERPREFS.new"; then
          echo "" >> "$USERPREFS.new"
          echo "$MARKER" >> "$USERPREFS.new"
          cat "$KEYBOARD_CONF" >> "$USERPREFS.new"
        fi
        # Try to replace the original file
        mv "$USERPREFS.new" "$USERPREFS" 2>/dev/null
        if [ $? -ne 0 ]; then
          echo "Couldn't replace $USERPREFS. Your custom config is in $USERPREFS.new"
        else
          echo "Successfully replaced $USERPREFS with new content"
        fi
      else
        # Create a completely new file
        echo "$MARKER" > "$USERPREFS.new"
        cat "$KEYBOARD_CONF" >> "$USERPREFS.new"
        mv "$USERPREFS.new" "$USERPREFS" 2>/dev/null || 
        echo "Created new config file at $USERPREFS.new (couldn't replace original)"
      fi
    else
      # We have write permissions, proceed normally
      if ! grep -q "$MARKER" "$USERPREFS"; then
        echo "Adding local configuration to userprefs.conf"
        echo "" >> "$USERPREFS"
        echo "$MARKER" >> "$USERPREFS"
        cat "$KEYBOARD_CONF" >> "$USERPREFS"
      else
        echo "Local configuration already present in userprefs.conf"
      fi
    fi
  else
    # File doesn't exist, create it
    echo "Creating new userprefs.conf with local configuration"
    echo "$MARKER" > "$USERPREFS"
    cat "$KEYBOARD_CONF" >> "$USERPREFS"
  fi
  
  # Ensure proper permissions
  chmod 644 "$USERPREFS" 2>/dev/null || true
  
  # Always return success
  exit 0
'';

}

