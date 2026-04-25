---
name: ios-app-icon-generator
description: "Generate all 19 required iOS app icon sizes from a single 1024x1024 source PNG. Use when an iOS app icon needs to be regenerated or fixed, when @2x/@3x filename conflicts with Contents.json scale fields cause Spotlight indexing errors (4 unassigned children warnings), or when building an iOS app for App Store submission. Workflow: fetch 1024 source from MacinCloud via scp, generate all 19 sizes via ImageMagick on Linux, upload to MacinCloud, update Contents.json to standard 19-entry format, clean up old-format files, verify build succeeds."
---

# iOS App Icon Generator

Generates all 19 iOS app icon sizes from a single 1024x1024 source PNG, then syncs them to MacinCloud and updates the asset catalog.

## The 19 Sizes

| Filename | Size (px) | Purpose |
|---|---|---|
| `Icon-20@1x.png` | 20×20 | iPhone notification |
| `Icon-20@2x.png` | 40×40 | — |
| `Icon-20@3x.png` | 60×60 | — |
| `Icon-29@1x.png` | 29×29 | Settings |
| `Icon-29@2x.png` | 58×58 | — |
| `Icon-29@3x.png` | 87×87 | — |
| `Icon-40@1x.png` | 40×40 | Spotlight search |
| `Icon-40@2x.png` | 80×80 | — |
| `Icon-40@3x.png` | 120×120 | — |
| `Icon-58@2x.png` | 116×116 | Spotlight (29pt base) |
| `Icon-58@3x.png` | 174×174 | Spotlight (29pt base) |
| `Icon-76@1x.png` | 76×76 | iPad |
| `Icon-76@2x.png` | 152×152 | iPad |
| `Icon-80@2x.png` | 160×160 | Spotlight (40pt base) |
| `Icon-80@3x.png` | 240×240 | Spotlight (40pt base) |
| `Icon-83.5@2x.png` | 167×167 | iPad Pro |
| `Icon-120@2x.png` | 120×120 | iPhone (60pt base) |
| `Icon-120@3x.png` | 180×180 | iPhone (60pt base) |
| `Icon-1024@1x.png` | 1024×1024 | App Store |

## Critical Rule: `@` Suffix for Scale Only

Asset catalogs parse `@2x`/`@3x` in filenames as scale multipliers. If Contents.json also has a `scale` field, this creates double-encoding that causes Spotlight indexing to fail with "4 unassigned children" warnings.

**Correct pattern:** `@1x` / `@2x` / `@3x` in filename = scale marker. Contents.json `scale` field = redundant but consistent. No `@` suffix on iPad icons with idioms.

**Wrong pattern:** `Icon-76@1x.png` (iPad idiom, should just be `Icon-76.png` per old spec) OR `Icon-1024@1x.png` when Contents.json says `idiom: "ios-marketing"` (1024 should NOT have `@` suffix in the old spec).

This skill always uses the **universal/standard 19-entry format** with consistent `@` suffix on all filenames regardless of idiom. This matches the Xcode asset catalog gold standard.

## Workflow

### Step 1 — Identify the Source Icon

On MacinCloud, each app has its 1024×1024 source icon at:
```
~/Desktop/ios-{AppName}/{Module}/Assets.xcassets/AppIcon.appiconset/Icon-1024.png
```
or `Icon-1024@1x.png`.

Fetch it to the local Linux machine:
```bash
sshpass -p '{macincloud_password}' scp user291981@LA690.macincloud.com:{remote_path} /root/.openclaw/media/outbound/{AppName}_Icon-1024.png
```

If multiple 1024 icons exist (AI generated options), send the best candidate to the user for confirmation before proceeding.

### Step 2 — Generate All 19 Sizes on Linux

ImageMagick `convert` is available at `/usr/bin/convert`. Run this script once you have the source:

```bash
#!/bin/bash
SRC="/root/.openclaw/media/outbound/{AppName}_Icon-1024.png"
DEST="/tmp/{appname}_icons"
mkdir -p $DEST

# 20pt
convert $SRC -resize 20x20 $DEST/Icon-20@1x.png
convert $SRC -resize 40x40 $DEST/Icon-20@2x.png
convert $SRC -resize 60x60 $DEST/Icon-20@3x.png

# 29pt
convert $SRC -resize 29x29 $DEST/Icon-29@1x.png
convert $SRC -resize 58x58 $DEST/Icon-29@2x.png
convert $SRC -resize 87x87 $DEST/Icon-29@3x.png

# 40pt
convert $SRC -resize 40x40 $DEST/Icon-40@1x.png
convert $SRC -resize 80x80 $DEST/Icon-40@2x.png
convert $SRC -resize 120x120 $DEST/Icon-40@3x.png

# 58pt Spotlight (29pt base)
convert $SRC -resize 116x116 $DEST/Icon-58@2x.png
convert $SRC -resize 174x174 $DEST/Icon-58@3x.png

# 76pt iPad
convert $SRC -resize 76x76 $DEST/Icon-76@1x.png
convert $SRC -resize 152x152 $DEST/Icon-76@2x.png

# 80pt Spotlight (40pt base)
convert $SRC -resize 160x160 $DEST/Icon-80@2x.png
convert $SRC -resize 240x240 $DEST/Icon-80@3x.png

# 83.5pt iPad Pro
convert $SRC -resize 167x167 $DEST/Icon-83.5@2x.png

# 120pt (60pt base)
convert $SRC -resize 120x120 $DEST/Icon-120@2x.png
convert $SRC -resize 180x180 $DEST/Icon-120@3x.png

# App Store
cp $SRC $DEST/Icon-1024@1x.png

echo "Done"
ls $DEST/
```

### Step 3 — Upload to MacinCloud

```bash
sshpass -p '{macincloud_password}' scp -o StrictHostKeyChecking=no /tmp/{appname}_icons/*.png user291981@LA690.macincloud.com:{remote_path}/
```

### Step 4 — Update Contents.json

Upload the standard Contents.json (see [references/contents-json.md](references/contents-json.md)) to replace the old one. Then delete old-format files that are no longer needed:

```bash
# On MacinCloud
cd {remote_appiconset_path}
# Remove old non-@ suffix icons (varies by project)
rm -f Icon-1024.png Icon-76.png Icon-76-2x.png Icon-83.5-2x.png Icon-60@2x.png Icon-60@3x.png
# Verify exactly 19 files remain
ls *.png | wc -l  # should output 19
```

### Step 5 — Verify Build

```bash
# On MacinCloud
cd {project_path}
rm -rf ~/Library/Developer/Xcode/DerivedData/{AppName}-*
xcodebuild -project {AppName}.xcodeproj -scheme {AppName} -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.6' build
```

Look for `BUILD SUCCEEDED`. The "4 unassigned children" warning is non-blocking and acceptable.

### Step 6 — Commit and Push

```bash
# On MacinCloud
cd {project_path}
git add ios/{Module}/Assets.xcassets/AppIcon.appiconset/
git commit -m 'Regenerate all AppIcon sizes from 1024x1024 source'
git push origin main
```

## Troubleshooting

**"4 unassigned children" warning persists:**
- Run `ls *.png` on MacinCloud to check for duplicate/extra icons
- Confirm exactly 19 files exist
- If extra files found (e.g. `Icon-1024.png` alongside `Icon-1024@1x.png`), delete the extra ones

**Icon blurry or wrong aspect ratio:**
- Always pass `-resize WxH` to ImageMagick (don't use `-scale`)
- The source must be at least 1024×1024 for quality

**Build fails with missing icon error:**
- Check that the filename in Contents.json exactly matches the actual file on disk (case-sensitive)

## MacinCloud Reference

- Host: `LA690.macincloud.com`
- User: `user291981`
- VNC port: `6000`
- SSH password: `idt52924irh`
- XcodeGen: `~/tools/xcodegen/bin/xcodegen`
