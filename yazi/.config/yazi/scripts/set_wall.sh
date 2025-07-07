#!/bin/bash

# Make sure the image path is absolute and exists
wall="$1"

if [[ ! -f "$wall" ]]; then
  echo "File not found: $wall"
  exit 1
fi

# Change wallpaper for all spaces
osascript <<EOF
tell application "System Events"
	set picture of every desktop to "$wall"
end tell
EOF
