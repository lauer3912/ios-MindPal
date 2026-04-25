# SSH Login to MacinCloud

## Overview
Use `sshpass + ssh` via exec tool (PTY mode) to automate operations on MacinCloud's Mac.

## Connection Info
| Item | Value |
|------|-------|
| Hostname | LA690.macincloud.com |
| Port | 22 |
| Username | user291981 |
| Password | idt52924irh |
| IP | 74.80.242.90 |

## Prerequisites
```bash
# Install sshpass if not available
apt-get install -y openssh-client sshpass
```

## Quick Connect Test
```bash
sshpass -p 'idt52924irh' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 -p 22 user291981@LA690.macincloud.com "echo 'SSH OK' && whoami"
```

## Standard Command Pattern
```bash
sshpass -p 'idt52924irh' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 -p 22 user291981@LA690.macincloud.com "cd ~/Desktop/ios-<AppName> && <command>" 2>&1
```

## Git Sync Flow (MacinCloud side)
```bash
# 1. Sync code
cd ~/Desktop/ios-<AppName> && git fetch origin && git reset --hard origin/main

# 2. Verify sync
git rev-parse HEAD && git rev-parse origin/main && [ $(git rev-parse HEAD) = $(git rev-parse origin/main) ] && echo 'SYNC OK'

# 3. XcodeGen
~/tools/xcodegen/bin/xcodegen generate
```

## Archive Build Pattern
```bash
# Single project
xcodebuild archive -project <AppName>.xcodeproj -scheme <SchemeName> -configuration Release CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO DEVELOPMENT_TEAM=9L6N2ZF26B

# Multiple projects - specify explicit -project
xcodebuild archive -project <AppName>.xcodeproj -scheme <SchemeName> -configuration Release CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO DEVELOPMENT_TEAM=9L6N2ZF26B
```

## Common Issues

### "The directory contains 2 projects"
→ Use `-project HabitArcFlow.xcodeproj` explicitly, or remove the old xcodeproj:
```bash
rm -rf ~/Desktop/ios-<AppName>/<OldName>.xcodeproj
```

### "dyld: Library not loaded" or signing errors
→ Clean derived data:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/<AppName>-*
```

## Note
- exec runs on Linux sandbox, PTY mode required for interactive ssh/sshpass
- All MacinCloud operations require manual intervention or this SSH approach
- VNC (port 6000) is alternative for GUI operations
