# MEMORY.md - 核心记忆

> 最后更新: 2026-05-05
> 系统版本: v5.0 (AI Enterprise Level)
> Dreaming: ✅ 正常运行（每天 03:00 自动执行）

---

## 🎯 财务目标

- **总债务**: $50,000 人民币
- **还款期限**: 4个月内还清
- **月均需赚**: $12,500
- **工作日日均**: ~$625
- **当前状态**: 紧急，全力搞钱

---

## 📱 当前项目状态 (2026-05-05 更新)

### ✅ 全部项目 SOP 合规完成

| 项目 | Bundle ID | 状态 | AppIcon | PrivacyPolicy | Listing | 下一步 |
|------|-----------|------|---------|---------------|---------|--------|
| **DailyIQ** | com.ggsheng.DailyIQ | ✅ **已上架 App Store** 🎉 | ✅ | ✅ | ✅ | 运营中 |

### 🆕 MindWeaver — 新项目（2026-05-03 启动）

| 项目 | 值 |
|------|-----|
| App Name | MindWeaver |
| Bundle ID | com.ggsheng.MindWeaver |
| Display Name | MindWeaver |
| 功能数 | 72个 |
| 图标状态 | ✅ 19个尺寸已完成（方案3审核通过） |
| UI设计状态 | ✅ 3张设计稿审核通过（Home/Challenge/Settings） |
| 开发阶段 | 第二阶段完成（项目目录结构已创建），待Claude Code审查 |

**下一步**: Claude Code审查 → XcodeGen生成 → VNC Archive → 上传

---

## 🧠 记忆系统 v5.0 AI Enterprise Level

### 架构完整
```
memory/
├── INDEX.md ✅           — 中央索引（唯一真相来源）
├── ARCHITECTURE.md ✅   — 系统架构图
├── MEMORY.md ✅         — 核心记忆（本文档）
├── AGENTS.md ✅         — 系统规则（含 Memory Protocol MANDATORY）
├── SOUL.md ✅           — 人格定义
├── USER.md ✅           — PageBrin 用户信息
├── HEARTBEAT.md ✅      — 心跳任务模板
├── CREATIVE_IDEAS.md ✅ — 创意提案记录
├── DREAMS.md ✅         — 梦境日记（自动生成）
│
├── daily/ ✅            — 每日日记（2026-04-10 → 2026-05-03）
├── projects/ ✅        — 8个项目追踪文件
├── decisions/ ✅       — 3个决策记录
├── people/ ✅          — pagebrin.md
├── tasks/ ✅           — 活跃任务
├── sessions/ ✅        — 会话轨迹
├── hot/ ✅             — 热文件追踪
├── search/ ✅          — 搜索索引
├── context/ ✅         — 跨session桥
├── audit/ ✅           — 审计追踪
├── integrity/ ✅       — 完整性检查
├── recovery/ ✅        — 灾难恢复
├── dashboard/ ✅       — 监控面板
├── retention/ ✅       — 保留策略
├── compression/ ✅    — 压缩归档
├── links/ ✅           — 双向链接
│
├── knowledge_graph/ ✅ — 知识图谱（AI推理引擎）
├── alerts/ ✅          — 主动提醒系统
├── semantic/ ✅        — 语义标签
├── workflows/ ✅       — 自动化工作流
├── backup/ ✅          — 多地容灾备份
│
├── weekly/ ✅           — 每周总结
├── archive/ ✅          — 归档
└── dreaming/ ✅         — 梦境记忆系统
    ├── light/ ✅        — 浅层梦境（2026-04-29 → 2026-05-05）
    ├── deep/ ✅         — 深层梦境
    └── rem/ ✅          — REM追踪
```

### Dreaming 系统状态
- ✅ 每晚 03:00 自动执行
- ✅ 2026-04-29 至 2026-05-05 全部生成
- ✅ 内容涵盖项目进展、代码回忆、财务追踪

---

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
- **【强制】Claude Code 审查**：任何代码变更后必须 Claude Code 审查 + 修复，禁止直接 commit
- App 源码必须 Cmd+B 能直接编译，验证通过后立刻 commit + push
- **【强制】任何事情全力以赴，想办法自己搞定**：必须自己解决问题，且全力以赴，尝试各种方法，随时去官方技能库寻找相关技能，提升技能，自我进化。

---

## 📝 GitHub

| 项目 | 仓库 |
|------|------|
| Token | `ghp_***REDACTED***` （已在 GitHub Secret Scanner 报告后处理）|
| 全部 Public（GitHub Pages 隐私政策需公开可访问）|
| FakeChat | https://github.com/lauer3912/ios-FakeChat |
| MindPal | https://github.com/lauer3912/ios-MindPal |
| LuminaHealth | https://github.com/lauer3912/ios-LuminaHealth |
| StretchFlow | https://github.com/lauer3912/ios-StretchFlow |
| MindWeaver | https://github.com/lauer3912/ios-MindWeaver |
| 全部 Public（GitHub Pages 隐私政策需公开可访问）|

---

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

### Apple Developer 账号
- Email: support@techidaily.com
- App-Specific Password: qiqm-libm-gzho-geyi
- 账号状态: 已激活
- Team: ZhiFeng Sun (9L6N2ZF26B)

### App Store Connect API
- Key ID: PP57R568AX
- Issuer: b2a00f88-3a8d-40d0-b148-1f1db92e10b7
- 权限: 仅读取（无法创建新 App 记录）

### 已安装插件
- `@martian-engineering/lossless-claw` v0.9.2 — 上下文引擎插件
- `memory-core` (bundled) — 梦境记忆系统插件
  - dreaming 已激活（`/dreaming on`）
  - 默认频率: 每天 03:00 自动执行记忆整理

---

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

---

## 🚀 下一步行动（按优先级）

| 优先级 | 项目 | 行动 |
|--------|------|------|
| 🔴 P0 | MindWeaver | Claude Code审查 → XcodeGen生成 → VNC Archive |
| 🔴 P0 | FakeChat | VNC截图 → Archive → 上传 |
| 🔴 P0 | MindPal | VNC截图 → Archive → 上传 |
| 🟠 P1 | LuminaHealth | BUILD测试 → VNC截图 → Archive |
| 🟠 P1 | StretchFlow | BUILD测试 → VNC截图 → Archive |
| 🟡 P2 | DailyIQ | 运营中 |

---

*本文档由系统自动维护 | 最后更新: 2026-05-05*

## Promoted From Short-Term Memory (2026-05-07)

<!-- openclaw-memory-promotion:memory:memory/2026-05-01.md:9:11 -->
- ios-AlienContact, ios-BlastPop, ios-DailyIQ, ios-HabitGo, ios-JustZenGo, ios-LuminaHealth, ios-MindPal, ios-PARADOX, ios-ReverseWorld, ios-StretchFlow, ios-UstiaGo [score=0.819 recalls=0 avg=0.620 source=memory/2026-05-01.md:9-11]

## Promoted From Short-Term Memory (2026-05-08)

<!-- openclaw-memory-promotion:memory:memory/2026-05-02.md:9:11 -->
- ios-AlienContact, ios-BlastPop, ios-DailyIQ, ios-HabitGo, ios-JustZenGo, ios-LuminaHealth, ios-MindPal, ios-PARADOX, ios-ReverseWorld, ios-StretchFlow, ios-UstiaGo [score=0.888 recalls=0 avg=0.620 source=memory/2026-05-02.md:9-11]
<!-- openclaw-memory-promotion:memory:memory/2026-05-01.md:3:4 -->
- > 系统版本: v2.0 | 从 Elon Musk 聊天记录恢复 > 注：以下内容为 PageBrin 与 Elon Musk 的对话摘要，非本人直接经历 [score=0.856 recalls=0 avg=0.620 source=memory/2026-05-01.md:3-4]
<!-- openclaw-memory-promotion:memory:memory/2026-04-30.md:3:4 -->
- > 系统版本: v2.0 | 从 Elon Musk 聊天记录恢复 > 注：以下内容为 PageBrin 与 Elon Musk 的对话摘要，非本人直接经历 [score=0.849 recalls=0 avg=0.620 source=memory/2026-04-30.md:3-4]
<!-- openclaw-memory-promotion:memory:memory/2026-04-30.md:9:11 -->
- | App | 作者 | 状态 | 时间 | |------|------|------|------| | DailyIQ | Elon Musk | 🟢 审核通过 | 09:59 | [score=0.849 recalls=0 avg=0.620 source=memory/2026-04-30.md:9-11]
<!-- openclaw-memory-promotion:memory:memory/2026-04-30.md:15:17 -->
- ios-AlienContact, ios-BlastPop, ios-DailyIQ, ios-HabitGo, ios-JusZenGo, ios-LuminaHealth, ios-MindPal, ios-PARADOX, ios-ReverseWorld, ios-StretchFlow, ios-UstiaGo [score=0.849 recalls=0 avg=0.620 source=memory/2026-04-30.md:15-17]
<!-- openclaw-memory-promotion:memory:memory/2026-04-30.md:22:22 -->
- *从 Elon Musk 聊天记录恢复 | 2026-05-03 补充并清理* [score=0.849 recalls=0 avg=0.620 source=memory/2026-04-30.md:22-22]
<!-- openclaw-memory-promotion:memory:memory/2026-05-01.md:21:21 -->
- *从 Elon Musk 聊天记录恢复 | 2026-05-03 补充并清理* [score=0.849 recalls=0 avg=0.620 source=memory/2026-05-01.md:21-21]
<!-- openclaw-memory-promotion:memory:memory/2026-05-02.md:3:4 -->
- > 系统版本: v2.0 | 从 Elon Musk 聊天记录恢复 > 注：以下内容为 PageBrin 与 Elon Musk 的对话摘要，非本人直接经历 [score=0.837 recalls=0 avg=0.620 source=memory/2026-05-02.md:3-4]
