# MEMORY.md - 核心记忆

## 🎯 财务目标
- **总债务**: $50,000 人民币
- **还款期限**: 4个月内还清
- **月均需赚**: $12,500
- **工作日日均**: ~$625
- **当前状态**: 紧急，全力搞钱

## 📱 当前项目
1. **JustZenGo** (原 FocusTimer/JustZen) - 番茄钟 App
   - 状态: ✅ 构建成功，⏳ App Store Connect 有2个VALID Build，待提交审核
   - Bundle ID: com.ggsheng.JustZen
   - App Store Connect App ID: 6762428992

2. **UstiaGo** (原 Clarity) - 屏幕时间管理
   - 状态: ✅ 构建成功，⏳ 待上传 App Store Connect
   - Bundle ID: com.ggsheng.UstiaGo

3. **HabitGo** (新) - 习惯追踪 App
   - 状态: ✅ 源码+截图脚本完成，⏳ MacinCloud 执行 XCUITest 截图 + Archive
   - Bundle ID: com.ggsheng.HabitGo
   - Privacy Policy: https://lauer3912.github.io/ios-HabitGo/docs/PrivacyPolicy.html
   - GitHub: https://github.com/lauer3912/ios-HabitGo
   - XCUITest: `HabitGoUITests/HabitGoUITests.swift`
   - 所需截图: 01_Habits, 02_History, 03_Stats, 04_Settings, 05_AddHabit_Sheet

## 🚀 上线计划
1. JustZenGo → App Store 填写元数据 → 提交审核
2. UstiaGo → App Store Connect 上传 Build → 填写元数据 → 提交审核
3. HabitGo → XcodeGen 生成项目 → Archive → 上传 Build → 填元数据 → 提交审核
4. 继续创建更多 App 快速变现

## ⚡ 行动准则
- 7x24 专注 App 开发
- 收到 App-Specific Password 立即上传
- 持续构建更多 App
- **【强制】一次性处理完整**：任何改动不做半吊子，发现问题要系统性检查所有相关项，不只改表面。每次提交前必过「预检清单」（见下方）
- App 源码必须 Cmd+B 能直接编译，验证通过后立刻 commit + push

## 📝 GitHub 仓库可见性策略
- **全部保持 Public**（App Store 上架的 App 源码迟早公开）
- Private repo 的 GitHub Pages 也是私密的 → 苹果审核员看不到隐私政策 URL → 直接被拒
- 如果必须 private：把隐私政策部署到 Netlify/Vercel/Cloudflare Pages（公开 URL）
- 结论：Public + GitHub Pages 免费托管最有利，代码保护主要靠商标注册

## 📝 关键知识
- XcodeGen: 需要 macOS 运行，Linux 环境无法执行（只有 macOS 二进制）
  - 下载地址: https://github.com/yonaskolb/XcodeGen/releases
  - 或在 MacinCloud VNC 里运行: `~/tools/xcodegen/bin/xcodegen generate`
- 部署脚本: ~/tools/deploy.sh
- App Store 上传需要 App-Specific Password
- 云 Mac: MacinCloud LA690 (每天最多3小时)

## 📱 App Store 截图
- **JustZenGo**: 8张不同截图，UITests MD5验证通过，commit `ca7a209`
- **UstiaGo**: 5张不同截图，UITests MD5验证通过，commit `ee16a4c`
- **HabitGo**: 待XCUITest截图，commit `4ca78a8`
- XCUITest 可用于截 App Store 图（详见 AGENTS.md）

## 🛡️ App Store Connect — App 隐私（必填，被拒重灾区）

所有 App Store Connect 提交前必须在「App 隐私」里如实作答：

| 问题 | JustZenGo 答案 | UstiaGo 答案 |
|------|---------------|---------------|
| 健康/健身 | 否 | 否 |
| 位置 | 否 | 否 |
| 联系信息 | 否 | 否 |
| 标识用户 | 否 | 否 |
| 浏览历史 | 否 | 否 |
| 购买行为 | 否 | 否 |
| 崩溃日志 | 否 | 否 |
| 性能数据 | 否 | 否 |
| 广告 | 否 | 否 |

**隐私政策 URL（GitHub Pages，/docs/ 路径）**：
- JustZenGo: `https://lauer3912.github.io/ios-JustZenGo/docs/PrivacyPolicy.html`
- UstiaGo: `https://lauer3912.github.io/ios-UstiaGo/docs/PrivacyPolicy.html`

**部署方法**：push 到 `gh-pages` 分支的 `docs/` 目录，GitHub Pages source 设为 `/docs` 即可。

## 🎨 App Icon 设计标准（佛罗多老爷要求）

**核心原则：图标必须能够吸引用户有下载 App 的欲望**

1. **有冲击力** — 第一眼就抓住眼球，让人想点进去
2. **有辉光/光晕效果** — 图标要有 glow、halo、高光，增强品质感
3. **3D 质感** — 避免扁平，要有渐变、立体感、 premium feel
4. **暖色/活力** — 生产类 App 用暖色调（红/橙/绿），增加能量感
5. **深色/沉浸** — 保护类/专注类 App 可用深色背景 + 亮色焦点
6. **简洁有力** — 一个核心概念，一眼就能识别
7. **白背景优先** — iOS App Store 图标通常白背景更突出

**生成后的检查清单：**
- [ ] 1024x1024 成品尺寸
- [ ] 所有设备尺寸齐全 (20, 29, 40, 60, 76, 83.5, 1024)
- [ ] 颜色饱满不寡淡
- [ ] 小尺寸时仍然可辨认
- [ ] 让人看了想下载

## 📐 iOS 项目命名规范（强制）
Repo 名 = Xcode 项目名 = Target 名 = App 文件夹名
- Bundle ID 用业务名: `com.ggsheng.{AppStore名}`
- Display Name 可以是短名（Info.plist 设置）
- 项目内所有源码路径引用必须与文件夹名一致
- XcodeGen generate 后 scheme 名必须等于 project 名

## 📐 iOS 项目命名规范（最终版）
业务名 = App Store 确认名称 + 'Go' 后缀
Repo 名 = 平台前缀 + 业务名（平台前缀: ios-, macos-, 等）

| 层级 | 规则 |
|------|------|
| 业务名 | {AppStore确认名} + Go |
| Repo 名 | {平台前缀}-{业务名} |
| Xcode 项目名 | = 业务名 |
| Target 名 | = 业务名 |
| App 文件夹 | = 业务名 |
| Bundle ID | com.ggsheng.{业务名} |
| Display Name | 可用短名（Info.plist） |

## 📦 iOS 打包签名经验（血的教训）

### 1. AppIcon Contents.json 必须与实际像素尺寸严格匹配
- **症状**：App Store Connect 报错 "Missing required icon file 120x120" 或 "152x152"
- **原因**：Contents.json 里声明的 `size` 字段（如 `"40x40"`）与实际 PNG 像素尺寸不匹配
- **正确对应**：
  | 文件名 | Point Size | Scale | 实际像素 |
  |--------|-----------|-------|---------|
  | Icon-60@2x.png | 60pt | @2x | 120×120 |
  | Icon-60@3x.png | 60pt | @3x | 180×180 |
  | Icon-76@2x.png (iPad) | 76pt | @2x | 152×152 |
  | Icon-83.5@2x.png (iPad Pro) | 83.5pt | @2x | 167×167 |
- **检查方法**：`file Icon-60@2x.png` 确认实际像素，或用 Python `struct` 解析 PNG 头

### 2. Signing 配置 — Archive 必须用 Automatic
- `CODE_SIGN_STYLE: Manual` + `CODE_SIGNING_REQUIRED: NO` → archive 里没有团队信息 → Organizer 报 "No Team Found"
- **正确配置**：
  ```yaml
  CODE_SIGN_STYLE: Automatic      # Archive 时自动签名并嵌入团队信息
  CODE_SIGNING_REQUIRED: YES
  DEVELOPMENT_TEAM: 9L6N2ZF26B
  ```
- Archive 时加 `-allowProvisioningUpdates` 让 Xcode 自动从 Portal 获取 provisioning profile
- **MacinCloud SSH 限制**：`errSecInternalComponent` → SSH 非交互会话无法访问 keychain 私钥 → 用 VNC 桌面版 Xcode 完成 Sign and Upload

### 🚀 iOS 项目预检清单（每次提交前必过）
1. **CJK 扫描** — 全项目无一个中文字符（Python: `re.compile(r'[\u4e00-\u9fff]')`）
2. **AppIcon Contents.json** — 每个文件的 `size` 字段与实际 PNG 像素尺寸严格匹配
3. **Signing 配置** — `CODE_SIGN_STYLE: Automatic` + `DEVELOPMENT_TEAM: 9L6N2ZF26B`
4. **Swift 源码** — `xcodebuild` 能编译通过
5. **Archive** — `xcodebuild archive` 能生成 .xcarchive
6. **Entitlements** — 文件存在且 App Groups / Push 配置正确
7. **Privacy Policy** — HTML 存在且为英文，`lang="en"`
8. **App Store 文档** — Listing.md / HOW-TO.md 存在且为英文
9. **Info.plist** — `CFBundleDisplayName`（英文）、`CFBundleShortVersionString`、`CFBundleVersion` 与 project.yml 一致
10. **App 隐私答案** — App Store Connect「App 隐私」里数据收集全部答"否"
11. **截图尺寸** — 确认 App Store Connect 要求的尺寸齐全（iPhone 6.7"/6.5"、iPad 12.9"）
12. **隐私政策 URL** — 已 host 到公网可访问的地址

### 3. Xcode Organizer Sign and Upload 是最优解
- 不走命令行 `altool`/`xcrun altool`（JWT 限制多、证书创建 scope 被拒）
- 让用户在 VNC 桌面里手动点：Xcode → Window → Organizer → Distribute → Sign and Upload

## 📸 HabitGo 截图（已完成）
- 4张 App Store 截图：iPhone 6.7" (1290×2796)
- 截图 MD5：`iPhone_6_7_Habits=6b288861`, `History=2e7c5c8a`, `Stats=2a266715`, `Settings=e90a4506`
- XCUITest 成功运行：`testAppStoreScreenshots` passed (48s)
- 截图命令：`xcodebuild test -only-testing:HabitGoUITests/HabitGoUITests/testAppStoreScreenshots`
- 注意事项：XCUITest 运行时会触发 URL scheme 弹窗（habitgo://），需等待 interruption handler 自动处理

## 📱 当前项目状态
| 项目 | 业务名 | Repo | GitHub 最新 commit | App Store |
|------|--------|------|-------------------|----------|
| 番茄钟 | JustZenGo | ios-JustZenGo | `fae01a8` App Store内容英文化 | 有2个VALID Build，待填元数据 |
| 屏幕时间 | UstiaGo | ios-UstiaGo | `0b5472c` AppIcon尺寸修复 | 待上传 + 填元数据 |
| 项目 | 业务名 | Repo | 状态 |
|------|--------|------|------|
| 番茄钟 | JustZenGo | ios-JustZenGo | ✅ |
| 屏幕时间 | UstiaGo | ios-UstiaGo | ✅ |
