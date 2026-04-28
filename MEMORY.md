# MEMORY.md - 核心记忆

## 🎯 财务目标
- **总债务**: $50,000 人民币
- **还款期限**: 4个月内还清
- **月均需赚**: $12,500
- **工作日日均**: ~$625
- **当前状态**: 紧急，全力搞钱

## 📱 当前项目

### JustZenGo — 番茄钟
- 状态: ✅ v3 已提交审核（2026-04-21）
- Bundle ID: `com.ggsheng.JustZen`
- App Store Connect App ID: `6762428992`
- 修复内容: 移除 HealthKit（Guideline 2.5.1 拒绝）

### UstiaGo — 屏幕时间管理
- 状态: ⏳ Archive 成功，待 VNC 上传 + App Store Connect 创建记录
- Bundle ID: `com.ggsheng.UstiaGo`
- Profile: `UstiaGo_App_Store.mobileprovision` (com.ggsheng.UstiaGo) ✅ Bundle ID 正确
- Privacy Policy: `https://lauer3912.github.io/ios-UstiaGo/docs/PrivacyPolicy.html`
- 最新 commit: `ef553de` ✅ 已同步 MacinCloud
- **已修复**: Widget AppIcon Contents.json（缺少 filename 字段和 Icon-60@2x.png）
- **待办**: 通过 VNC Xcode GUI Distribute Upload + 在 App Store Connect 创建 App

### MindPal — AI日记与情绪追踪
- 状态: ✅ **BUILD SUCCEEDED** — 编译成功，待截图+视频
- Bundle ID: `com.ggsheng.MindPal`
- 图标方案: AppStore/Assets/Icon/Icon-1024.png ✅ 已审核通过
- UI设计: AppStore/Assets/UI/UI-Mockup-v1.png ✅ 已审核通过
- 功能清单: Docs/FeatureList.md ✅（66个功能）
- GitHub: `ios-MindPal` ✅ 已提交（本地）
- 编译: ✅ Debug Build SUCCEEDED
- 下一步: MacinCloud VNC 截图 + 视频 → App Store Connect

### DailyIQ — AI智能日程规划
- 状态: ⏳ 图标+UI已审核通过，待开发
- Bundle ID: `com.ggsheng.DailyIQ`
- 图标方案: AppStore/Assets/Icon/Icon-1024.png ✅ 已审核通过
- UI设计: AppStore/Assets/UI/UI-Mockup-v1.png ✅ 已审核通过
- 功能清单: Docs/FeatureList.md ✅（70个功能）
- 下一步: 启动开发

### ChatFaker — 假聊天截图生成器（FakeChat更名）
- 状态: ✅ BUILD SUCCEEDED，App运行正常(PID 19390)
- Bundle ID: `com.ggsheng.FakeChat`（不变）
- App Store显示名: ChatFaker ✅
- 最新commit: `1c9fa4c` ✅ 已同步GitHub
- 图标方案: AppStore/Assets/Icon/Icon-1024.png ✅
- UI设计: AppStore/Assets/UI/UI-Mockup-v1.png ✅
- 功能清单: Docs/FeatureList.md ✅（62个功能）
- 代码实现: 全部ViewControllers + Models + Theme ✅
- 下一步: App Store Connect创建应用 → Archive → 上传

### HabitArcFlow — 习惯追踪
- 状态: ⏳ 需解决视频 + 检查审核状态
- Bundle ID: `com.ggsheng.HabitGo`
- Privacy Policy: `https://lauer3912.github.io/ios-HabitGo/docs/PrivacyPolicy.html`
- 最新 commit: `c3c5ee9` ✅ 已同步 MacinCloud
- **已完成**: 合成视频 `HabitArcFlow_Demo.mp4`（60秒/1290x2796）已上传 MacinCloud
- **待办**: 检查 App Store Connect 审核回复

## 🚀 上线计划
1. JustZenGo → ✅ v3 已提交审核（2026-04-21）
2. UstiaGo →→ 检查并修复 → VNC Archive + Upload → 填元数据 → 提交审核
3. HabitArcFlow → 检查并修复 → VNC Archive + Upload → 填元数据 → 提交审核
4. 继续创建更多 App 快速变现

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
2. AppIcon Contents.json — idioms 正确（ipad 图标用 `"ipad"`，1024 用 `"ios-marketing"`）
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


