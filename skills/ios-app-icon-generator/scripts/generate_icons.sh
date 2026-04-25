#!/bin/bash
# generate_icons.sh — Generate all 19 iOS icon sizes from a 1024x1024 source PNG
# Usage: ./generate_icons.sh <source.png> <output_dir>
# Example: ./generate_icons.sh /tmp/AppIcon-1024.png /tmp/out

set -e

SRC="$1"
DEST="${2:-/tmp/icons}"
APP_NAME="${3:-app}"

if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
    echo "Usage: $0 <source_1024.png> [output_dir] [app_name]"
    exit 1
fi

mkdir -p "$DEST"

# 20pt
convert "$SRC" -resize 20x20 "$DEST/Icon-20@1x.png"
convert "$SRC" -resize 40x40 "$DEST/Icon-20@2x.png"
convert "$SRC" -resize 60x60 "$DEST/Icon-20@3x.png"

# 29pt
convert "$SRC" -resize 29x29 "$DEST/Icon-29@1x.png"
convert "$SRC" -resize 58x58 "$DEST/Icon-29@2x.png"
convert "$SRC" -resize 87x87 "$DEST/Icon-29@3x.png"

# 40pt
convert "$SRC" -resize 40x40 "$DEST/Icon-40@1x.png"
convert "$SRC" -resize 80x80 "$DEST/Icon-40@2x.png"
convert "$SRC" -resize 120x120 "$DEST/Icon-40@3x.png"

# 58pt Spotlight (29pt base)
convert "$SRC" -resize 116x116 "$DEST/Icon-58@2x.png"
convert "$SRC" -resize 174x174 "$DEST/Icon-58@3x.png"

# 76pt iPad
convert "$SRC" -resize 76x76 "$DEST/Icon-76@1x.png"
convert "$SRC" -resize 152x152 "$DEST/Icon-76@2x.png"

# 80pt Spotlight (40pt base)
convert "$SRC" -resize 160x160 "$DEST/Icon-80@2x.png"
convert "$SRC" -resize 240x240 "$DEST/Icon-80@3x.png"

# 83.5pt iPad Pro
convert "$SRC" -resize 167x167 "$DEST/Icon-83.5@2x.png"

# 120pt (60pt base)
convert "$SRC" -resize 120x120 "$DEST/Icon-120@2x.png"
convert "$SRC" -resize 180x180 "$DEST/Icon-120@3x.png"

# App Store 1024
cp "$SRC" "$DEST/Icon-1024@1x.png"

echo "Generated $(ls $DEST/*.png | wc -l) icons in $DEST"
ls -la "$DEST/"
