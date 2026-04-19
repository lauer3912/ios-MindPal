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
   - 状态: ✅ 截图完成，⏳ VNC 操作 Archive + Upload
   - Bundle ID: com.ggsheng.HabitGo
   - Privacy Policy: https://lauer3912.github.io/ios-HabitGo/docs/PrivacyPolicy.html
   - GitHub: https://github.com/lauer3912/ios-HabitGo
   - XCUITest: `HabitGoUITests/HabitGoUITests.swift`
   - 截图: 4张 (1290×2796) MD5: Habits=6b288861, History=2e7c5c8a, Stats=2a266715, Settings=e90a4506ts, 04_Settings, 05_AddHabit_Sheet

## 🚀 上线计划
1. JustZenGo → App Store 填写元数据 → 提交审核
2. UstiaGo → App Store Connect 上传 Build → 填写元数据 → 提交审核
3. HabitGo → XcodeGen 生成项目 → Archive → 上传 Build → 填元数据 → 提交审核
4. 继续创建更多 App 快速变现

## ⚡ 行动准则（死规矩）

- 7x24 专注 App 开发
- 收到 App-Specific Password 立即上传
- 持续构建更多 App
- **【强制】一次性处理完整**：任何改动不做半吊子，发现问题要系统性检查所有相关项，不只改表面。每次提交前必过「预检清单」（见下方）
- App 源码必须 Cmd+B 能直接编译，验证通过后立刻 commit + push
- **【强制】新产品上线前审核**：创建全新 App 产品时，必须先将完整方案（产品名、图标设计、核心功能、用途）发给佛罗多老爷审查，确认没问题后才能开始研发
- **【强制】图标审核制**：任何 App 的图标在正式提交前，必须经过老爷审核确认
- **【强制】全流程自检**：所有流程、所有环节必须自己反复审核、审查、修正，确保无误后才能交出
- **【强制】所有变更同步流程（硬性要求）**：本地改动 → 推送 GitHub → MacinCloud pull 最新 → 重新构建（XcodeGen + xcodebuild），每个变更必须走完整流程，不允许本地改了没同步
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

## 🎨 App Icon 设计标准（死规矩 - 最高优先级）

**【强制】所有 App 图标必须严格遵守 Apple HIG：** https://developer.apple.com/design/human-interface-guidelines/app-icons

**Apple HIG 原文关键规则（来自官方 PDF）：**
- iOS 图标是分层设计（Background layer + Foreground layers）
- **透明度是故意的** — specular highlights, frostiness, translucency 响应光照和设备运动
- 小尺寸图标可以有透明区域（iOS 自动裁切圆角）
- 纯色或渐变背景

**App Store Connect 强制要求：**
- **1024x1024 App Store 预览图：不能有 alpha 通道，必须完全不透明**
- 错误：`Invalid large app icon...can't be transparent or contain an alpha channel`
- 原因：App Store Connect 需要 1024x1024 的 flattened opaque 版本

**所有尺寸设计规范：**
- 尺寸系列：20, 29, 40, 60, 76, 83.5, 87, 120, 180, 1024 (pt × scale)
- 小图标（20-180px）：可以有透明角落（HIG 明确允许）
- **1024x1024：必须是完全不透明的 flattened 图像**
- 所有尺寸必须是正方形，不自行绘制圆角

**Apple HIG 设计原则：**
1. 简洁可辨 — 小尺寸时也能一眼认出
2. 单个焦点 — 一个核心元素，不要杂乱
3. 留白/负空间 — 内容不要太挤
4. 不要文字 — 图标不带文字
5. 原创不侵权 — 元素必须原创，禁止抄袭
6. 3D 层次感 — 用透明度创造纵深（老爷子额外要求）

**⚠️ 死规矩：任何 App 产品上线前，图标必须经过佛罗多老爷审核确认后才能继续。**

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

### ⭐ Xcode Archive/Distribute 必读
- **Team 名**: ZhiFeng Sun (9L6N2ZF26B) — 每次 Archive 后 Distribute 时必须选这个！
- 流程：Xcode → Window → Organizer → 选择 Archive → Distribute → App Store Connect → Sign and Upload → 选 ZhiFeng Sun → Upload

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

### 3. Xcode Archive Signing 配置（所有 iOS 项目必须遵循）
**错误**：`Use the Signing & Capabilities editor to assign a team to the targets`

**根本原因**：`project.yml` signing 配置不正确，Archive 时 Xcode 找不到 Team

**解决方案模板（每个 target 必须包含）**：
```yaml
settings:
  base:
    CODE_SIGN_STYLE: Automatic
    DEVELOPMENT_TEAM: 9L6N2ZF26B
    CODE_SIGNING_ALLOWED: NO          # simulator 跳过签名
    CODE_SIGN_ENTITLEMENTS: ...
  configs:
    Debug:
      CODE_SIGNING_ALLOWED: NO        # simulator 构建
    Release:
      CODE_SIGNING_ALLOWED: YES       # archive 构建
```

**关键要点**：
- base level 禁止只有 `CODE_SIGNING_ALLOWED=NO`（会阻止 Release 签名）
- 必须用 `configs: Debug/Release` per-config 覆盖
- Widget 也必须有 Release=YES（否则和主 App 证书不匹配，报 "Not Code Signed"）
- 成功参考项目：JustZenGo（对比发现问题）
- 每次改完 project.yml：push → MacinCloud pull → XcodeGen → 验证

### 4. Xcode Organizer Sign and Upload 是最优解
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
| 习惯追踪 | HabitGo | ios-HabitGo | `4650f9c` App Store截图 | ⏳ VNC Archive |
| 番茄钟 | JustZenGo | ios-JustZenGo | `fae01a8` App Store内容英文化 | 有2个VALID Build，待填元数据 |
| 屏幕时间 | UstiaGo | ios-UstiaGo | `0b5472c` AppIcon尺寸修复 | 待上传 + 填元数据 |
