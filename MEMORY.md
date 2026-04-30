# MEMORY.md - 核心记忆

## 🎯 财务目标
- **总债务**: $50,000 人民币
- **还款期限**: 4个月内还清
- **月均需赚**: $12,500
- **工作日日均**: ~$625
- **当前状态**: 紧急，全力搞钱

## 📱 当前项目状态 (2026-04-29 更新)

### ✅ 全面修复完成 - SOP 合规
以下项目已完成所有 SOP 修复项（AppIcon Contents.json + PrivacyPolicy + 源码）：

| 项目 | Bundle ID | BUILD | AppIcon | PrivacyPolicy | Listing | 下一步 |
|------|-----------|-------|---------|---------------|---------|--------|
| DailyIQ | com.ggsheng.DailyIQ | ✅ | ✅ | ✅ | ✅ | **🎉 已上架审核通过** |
| FakeChat | com.ggsheng.FakeChat | ✅ | ✅ | ✅ | ✅ | 截图 → VNC Archive |
| ios-MindPal | com.ggsheng.MindPal | ✅ | ✅ | ✅ | ✅ | 截图 → VNC Archive |
| ios-HabitGo | com.ggsheng.HabitGo | ✅ | ✅ | ✅ | ✅ | 截图 → VNC Archive |
| ios-JustZenGo | com.ggsheng.JustZen | ✅ | ✅ | ✅ | ✅ | 已提交审核 |
| ios-LuminaHealth | com.ggsheng.LuminaHealth | 待测 | ✅ | ✅ | ✅ | BUILD测试 → 截图 |
| ios-StretchFlow | com.ggsheng.StretchGoGo | 待测 | ✅ | ✅ | ✅ | BUILD测试 → 截图 |
| ios-UstiaGo | com.ggsheng.UstiaGo | ✅ | ✅ | ✅ | ✅ | 截图 → VNC Archive |

### 📋 SOP 修复清单（已完成）
- ✅ AppIcon Contents.json — 全部 7 个项目已更新为标准 19-entry 格式
- ✅ PrivacyPolicy.html — 6 个项目已创建并同步 MacinCloud
- ✅ FakeChat AppIcon — Contents.json 已修复

### 🚀 下一步行动（按优先级）
1. **DailyIQ** — VNC Xcode 截图 → Archive → App Store Connect
2. **FakeChat** — VNC Xcode 截图 → Archive → App Store Connect  
3. **ios-MindPal** — VNC Xcode 截图 → Archive → App Store Connect
4. **ios-UstiaGo** — VNC Xcode 截图 → Archive → App Store Connect
5. **ios-HabitGo** — VNC Xcode 截图 → Archive → App Store Connect
6. **ios-LuminaHealth** — BUILD测试 → VNC 截图 → Archive
7. **ios-StretchFlow** — BUILD测试 → VNC 截图 → Archive

## ⚡ 行动准则（死规矩）

- **【强制】所有会话内容必须永久记忆**：不得在 session 结束后丢弃，新 session 启动会自动读取 MEMORY.md 继承所有规则和信息
- **代码同步校验**：每次 pull 后必须比对 `git rev-parse HEAD` 与 `origin/main`，一致才算成功
- **MacinCloud 同步标准流程**：
  ```bash
  git fetch origin && git reset --hard origin/main && git rev-parse HEAD && git rev-parse origin/main && [ $(git rev-parse HEAD) = $(git rev-parse origin/main) ] && echo 'SYNC OK'
  ```
- **【强制】不允许撒谎**
- **【强制】7x24 专注 App 开发**
- **【强制】App设计风格**：任何 App 产品必须两种风格：深色和浅色，必须非常吸引人，专业的App UI设计风格
- **【强制】产品功能**：任何 App 产品功能数量必须要50+，且必须有视频演示
- **【强制】一次性处理完整**：任何改动不做半吊子，发现问题要系统性检查所有相关项
- **【强制】新产品上线前审核**：产品名、图标设计、核心功能必须先发给佛罗多老爷审查
- **【强制】图标审核制**：任何 App 图标在正式提交前必须经过老爷审核确认
- App 源码必须 Cmd+B 能直接编译，验证通过后立刻 commit + push
- **【强制】任何事情全力以赴，想办法自己搞定**：必须自己解决问题，且全力以赴，尝试各种方法，随时去官方技能库寻找相关技能，提升技能，自我进化。

## 📝 GitHub 仓库
- ios-JustZenGo: https://github.com/lauer3912/ios-JustZenGo
- ios-UstiaGo: https://github.com/lauer3912/ios-UstiaGo
- ios-HabitGo: https://github.com/lauer3912/ios-HabitGo
- ios-DailyIQ: https://github.com/lauer3912/ios-DailyIQ
- ios-FakeChat: https://github.com/lauer3912/ios-FakeChat
- ios-MindPal: https://github.com/lauer3912/ios-MindPal
- ios-LuminaHealth: https://github.com/lauer3912/ios-LuminaHealth
- ios-StretchFlow: https://github.com/lauer3912/ios-StretchFlow
- 全部 Public（GitHub Pages 隐私政策需公开可访问）

## 📝 关键知识

### XcodeGen
- 路径: `~/tools/xcodegen/bin/xcodegen`
- 只在 macOS 运行，Linux 无法执行
- 每次 pull 后需重新 generate

### MacinCloud
- Host: LA690.macincloud.com / user291981 / idt52924irh
- VNC 端口: 6000
- SSH 登录信息：
    - hostname: LA690.macincloud.com
    - username: user291981
    - password: idt52924irh
    - IP: 74.80.242.90

### ⭐ 所有 App 签名/上传标准流程（VNC 模式）
**【强制】所有 App 上传 App Store 必须通过 MacinCloud VNC 桌面操作**
**【强制】签名/上传模式：SSH signing 经常失败（keychain locked），必须通过 VNC 图形界面 Xcode 手动签名上传**
1. MacinCloud VNC 连接桌面（端口 6000）
2. Xcode → Product → Archive
3. Distribute App → App Store Connect → Upload
4. Transporter / altool / 命令行 signing 在本环境不适用
5. GitHub 无法直接 push（host key 限制），代码变更通过 SCP/手动同步

### 团队
- Team: ZhiFeng Sun (9L6N2ZF26B)

### 已安装插件
- `@martian-engineering/lossless-claw` v0.9.2 — 上下文引擎插件，slot: contextEngine
- `memory-core` (bundled) — 梦境记忆系统插件
  - dreaming 已激活（`/dreaming on`）
  - 默认频率: 每天 03:00 自动执行记忆整理

### Provisioning Profile UUID（当前有效的）
- JustZenGo App Store: `0da5433a-ef90-408f-a377-e16f4bc0ff54`
- JustZenGoWidget App Store: `c746576e-97bd-4ac7-a8ee-a0efadc55c1c`
- UstiaGo App Store: `a63fe3f6-2d86-4d67-8ce8-9a982b0dcfd0` (Bundle ID 正确: com.ggsheng.UstiaGo)

## 🛡️ iOS 项目预检清单（每次提交前必过）
1. CJK 扫描 — 全项目无一个中文字符
2. AppIcon Contents.json — idioms 正确（1024 用 `"ios-marketing"`，其他用 `"universal"`）
3. Signing 配置 — 默认使用：Automatically manage signing，备选方案：`CODE_SIGN_STYLE: Automatic` + `DEVELOPMENT_TEAM: 9L6N2ZF26B`
4. 所有图标文件 — PNG 格式（非 JPEG）
5. entitlements — 没有Widget使用无 App Groups（空 dict），有Widget使用有 App Groups（非空 dict）
6. Privacy Policy — HTML 存在且为英文，`lang="en"`
7. App Store 文档 — Listing.md / HOW-TO.md 存在且为英文
8. Info.plist — `CFBundleDisplayName`（英文）、版本号一致
9. App 隐私答案 — App Store Connect 全部答"否"
10. 截图尺寸 — 有官方的要求（每种设备类型，至少3张）
    - iPhone 6.9" 尺寸(1260 × 2736px、2736 × 1260px、1320 × 2868px、2868 × 1320px、1290 × 2796px 或 2796 × 1290px)
    - iPhone 6.5" 尺寸(1242 × 2688px、2688 × 1242px、1284 × 2778px 或 2778 × 1284px)
    - iPhone 6.3" 尺寸(1206 × 2622px、2622 × 1206px、1179 × 2556px 或 2556 × 1179px)
    - iPad 12.9" (2064 × 2752px、2752 × 2064px、2048 × 2732px 或 2732 × 2048px)
11. 录操作视频及编写操作说明文档 - 选择 iPhone 6.9/iPhone 6.5 录制一段不少于60秒的操作视频, 及操作步骤说明文档

## Promoted From Short-Term Memory (2026-04-29)

<!-- openclaw-memory-promotion:memory:memory/2026-04-17.md:220:257 -->
- - App Store Connect API Key: PP57R568AX (Issuer: b2a00f88-3a8d-40d0-b148-1f1db92e10b7) - API 只有读取权限，无法创建新 App 记录 ## 待完成 - [ ] 用户在 MacinCloud Xcode GUI 中完成 Apple ID 认证（一次性） - [ ] 在 App Store Connect 创建 UstiaGo App 记录 (Bundle ID: com.ggsheng.Ustia) - [ ] 构建并上传 JustZenGo 到 App Store - [ ] 构建并上传 UstiaGo 到 App Store ## 财务目标 (紧急) - 债务: $50,000 - 期限: 4个月 - 每月需收入: $12,500 ## Apple Developer 账号 - Email: support@techidaily.com - App-Specific Password: qiqm-libm-gzho-geyi - 账号状态: 已激活 - Team: ZhiFeng Sun (9L6N2ZF26B) ## 云 Mac - MacinCloud LA690: LA690.macincloud.com:6000 (VNC) - 用户名: user291981 - 密码: idt52924irh - 每天最多3小时 (~$28/月额外) - DST 进行中 (PT = CST - 15小时) ## MacinCloud Xcode 当前问题 - 症状: errSecInternalComponent - 私钥访问被拒绝 - 原因: macOS 安全机制阻止 SSH 远程会话访问 keychain - 表现: Xcode 使用 Apple Development 开发证书而不是 Apple Distribution 分发证书 - 表现: Xcode 使用免费的 iOS Team Provisioning Profile 而不是我们的 App Store Profile - 解决: 用户需在 VNC 中打开 Xcode，手动选择 ZhiFeng Sun (9L6N2ZF26B) Team 并完成签名认证 # 2026-04-17 继续 ## 最新进展 (22:00+) ### JustZenGo - 已上传成功! 🎉 [score=0.821 recalls=3 avg=1.000 source=memory/2026-04-17.md:220-257]
<!-- openclaw-memory-promotion:memory:memory/2026-04-17.md:162:202 -->
- - [ ] 在 App Store Connect 创建 UstiaGo App 记录 (Bundle ID: com.ggsheng.Ustia) - [ ] 构建并上传 JustZenGo 到 App Store - [ ] 构建并上传 UstiaGo 到 App Store ## 财务目标 (紧急) - 债务: $50,000 - 期限: 4个月 - 每月需收入: $12,500 ## Apple Developer 账号 - Email: support@techidaily.com - App-Specific Password: qiqm-libm-gzho-geyi - 账号状态: 已激活 - Team: ZhiFeng Sun (9L6N2ZF26B) ## 云 Mac - MacinCloud LA690: LA690.macincloud.com:6000 (VNC) - 用户名: user291981 - 密码: idt52924irh - 每天最多3小时 (~$28/月额外) - DST 进行中 (PT = CST - 15小时) ## MacinCloud Xcode 当前问题 - 症状: errSecInternalComponent - 私钥访问被拒绝 - 原因: macOS 安全机制阻止 SSH 远程会话访问 keychain - 表现: Xcode 使用 Apple Development 开发证书而不是 Apple Distribution 分发证书 - 表现: Xcode 使用免费的 iOS Team Provisioning Profile 而不是我们的 App Store Profile - 解决: 用户需在 VNC 中打开 Xcode，手动选择 ZhiFeng Sun (9L6N2ZF26B) Team 并完成签名认证 # 2026-04-17 Daily Log ## 项目状态 ### JustZenGo (原 FocusTimer) - App 名称: JustZenGo - Bundle ID: com.ggsheng.JustZen - Widget Bundle ID: com.ggsheng.JustZen.widget - ✅ Archive 成功 - 位置: ~/Desktop/JustZenGo/FocusTimer.xcodeproj - App Store Connect ID: 6762428992 - 状态: ⏳ 等待 Xcode 签名配置完成 [score=0.821 recalls=3 avg=1.000 source=memory/2026-04-17.md:162-202]
<!-- openclaw-memory-promotion:memory:memory/2026-04-17.md:106:148 -->
- - 每月需收入: $12,500 ## Apple Developer 账号 - Email: support@techidaily.com - App-Specific Password: qiqm-libm-gzho-geyi - 账号状态: 已激活 - Team: ZhiFeng Sun (9L6N2ZF26B) ## 云 Mac - MacinCloud LA690: LA690.macincloud.com:6000 (VNC) - 用户名: user291981 - 密码: idt52924irh - 每天最多3小时 (~$28/月额外) - DST 进行中 (PT = CST - 15小时) ## MacinCloud Xcode 当前问题 - 症状: errSecInternalComponent - 私钥访问被拒绝 - 原因: macOS 安全机制阻止 SSH 远程会话访问 keychain - 表现: Xcode 使用 Apple Development 开发证书而不是 Apple Distribution 分发证书 - 表现: Xcode 使用免费的 iOS Team Provisioning Profile 而不是我们的 App Store Profile - 解决: 用户需在 VNC 中打开 Xcode，手动选择 ZhiFeng Sun (9L6N2ZF26B) Team 并完成签名认证 # 2026-04-17 Daily Log ## 项目状态 ### JustZenGo (原 FocusTimer) - App 名称: JustZenGo - Bundle ID: com.ggsheng.JustZen - Widget Bundle ID: com.ggsheng.JustZen.widget - ✅ Archive 成功 - 位置: ~/Desktop/JustZenGo/FocusTimer.xcodeproj - App Store Connect ID: 6762428992 - 状态: ⏳ 等待 Xcode 签名配置完成 ### UstiaGo (原 Clarity - 已改名) - App 名称: UstiaGo - Bundle ID: com.ggsheng.Ustia - ✅ Archive 成功 - 位置: ~/Desktop/UstiaGo/Clarity.xcodeproj - 状态: ⏳ 等待在 App Store Connect 创建 App 记录 ## 重要提醒 - **App 主要语言: 英文** (非中文) [score=0.821 recalls=3 avg=1.000 source=memory/2026-04-17.md:106-148]
