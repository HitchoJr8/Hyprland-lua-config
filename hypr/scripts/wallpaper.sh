#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/current-wallpaper"

mkdir -p "$(dirname "$STATE_FILE")"

# Find wallpapers
mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort
)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Get current index
if [ -f "$STATE_FILE" ]; then
    INDEX=$(cat "$STATE_FILE")
else
    INDEX=-1
fi

# Next wallpaper
INDEX=$((INDEX + 1))

if [ "$INDEX" -ge "${#WALLPAPERS[@]}" ]; then
    INDEX=0
fi

WALLPAPER="${WALLPAPERS[$INDEX]}"

echo "$INDEX" > "$STATE_FILE"

# Change wallpaper
awww img --transition-type center "$WALLPAPER"

# Generate colors without asking for confirmation
matugen image "$WALLPAPER" --mode dark --contrast 0.0 --source-color-index 2
