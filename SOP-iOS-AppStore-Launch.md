# 从零创建 iOS App 项目完整指南

> ⚠️ **【强制】AI Agent 必须永远以最新的 SOP 文档为准**
>
> - 本文档是 iOS App 创建和上架的唯一权威指南
> - AI Agent 在执行任何步骤前，**必须先读取并理解最新版本的 SOP-iOS-AppStore-Launch.md**
> - 如果发现本文档与实际执行有差异，**以本文档为准**，不要自行其是
> - 所有规则和要求一旦更新，AI Agent 必须立即遵循，**禁止用旧经验或记忆中的规则**
> - **禁止胡说八道或歪曲 SOP 规定**：如果 Agent 的说法与 SOP 矛盾，以 SOP 为准。故意曲解或编造规则是违反 SOP 的行为
>
> ⚠️ **【强制】所有 App 上传 App Store 必须通过 MacinCloud VNC 桌面操作**
> - SSH signing 经常失败（keychain locked），**必须通过 VNC 图形界面 Xcode 手动签名上传**
>
> ⚠️ **【强制】必须使用 Claude Code 审查+修复所有源码**，未经 Claude Code 审查+修复的代码禁止提交
>
> ⚠️ **【强制】目标用户**：所有 App 主要面向**欧美客户**，设计必须符合西方审美和文化习惯，**禁止中式审美元素**
>
> ⚠️ **【强制】必须按流程执行**：
> - 图标方案和 App UI 设计方案**必须先审核通过**，才能开始编写代码
> - 禁止跳过设计审核直接开发
>
> ⚠️ **【强制】涉及 AI 技术的 App**：必须使用设备端 ML（推荐）或在隐私政策中明确说明云端 AI 处理，详见 §8.5
>
> ⚠️ **【重要】录屏是可选的，不是必选项**。如果 App 功能无法通过截图展示清楚，再考虑录屏。

## 👤 角色分工总览

> ⚠️ **重要**：本 SOP 由 AI Agent 和人类配合完成。以下明确标注每个步骤的执行主体，**严格遵守**。

### 角色定义

| 角色 | 说明 |
|------|------|
| 🤖 **AI Agent（Claude Code）** | **审查 + 修复**，运行在 AI Agent 服务器（不是 MacinCloud），每次代码变更后必须执行审查和修复 |
| 👨 **Human（人类）** | 真实用户，负责审核、审批、VNC 桌面操作、最终提交等 |

> ⚠️ **【重要】Claude Code 配置 MiniMax API**：
> - 使用 `set-minimax-api.sh` 脚本配置 MiniMax API（推荐方式）
> - 脚本位置：`Apple-App-Manager/set-minimax-api.sh`
> - 用法：`./set-minimax-api.sh <api_key> [base_url]`
> - 示例：`./set-minimax-api.sh "sk-cp-xxxxx" "https://api.minimaxi.com/v1"`
> - 配置完成后重启 Claude Code 或开启新 session 即可生效
>
> **【重要】Root 用户兼容性**：如果 Claude Code 以 root 身份运行，可能出现 API 返回格式不兼容的问题。解决方案是直接使用环境变量：
> ```bash
> export CLAUDE_BASE_URL="https://api.minimaxi.com/v1"
> export CLAUDE_API_KEY="sk-cp-xxxxx"
> claude
> ```
>
> **MiniMax API 配置参数**：
> - Base URL：`https://api.minimaxi.com/v1`
> - API Key：`sk-cp-JrsXMfjYj9mexu5NAr9Eevedk7IBFoCZFi4azaPEColz-bU0LH0NPA-Z-gxMlM505CKP1Cq-zaAP0OF2bQ0k6y44J1TP0XNodYCxY9oiQAmeGb0RPIivl6A`
>
> Claude Code 的职责是"审查 + 修复"，不是"编写"

> ⚠️ **【重要】Claude Code 的职责是"审查 + 修复"，不是"编写"**：
> - **审查**：分析代码发现问题（bug、风格、安全等）
> - **修复**：根据审查结果修复问题
> - **每次代码变更后必须执行**：所有 commit 前都必须经过 Claude Code 审查和修复
> - Claude Code 在 AI Agent 服务器执行，**不在 MacinCloud 上运行**

### 核心原则

| 原则 | 说明 |
|------|------|
| **AI Agent 操作不需要询问人类** | 标注为 🤖 AI Agent 执行的步骤，**直接执行，不需要询问人类**（除非明确标注需要人类审核） |
| **Claude Code 审查 + 修复** | **每次代码变更后必须执行**。所有 commit 前必须先 Claude Code 审查，发现问题立即修复 |
| **必须人类审核的** | AI 输出 → 人类审核 → 通过后继续 |
| **人类肉眼审核时** | Agent 必须发送**真实图片/视频文件**，**禁止发送链接或口述内容** |
| **必须人类操作的** | AI 无法完成（如 VNC 桌面操作、App Store Connect 审核点击）|
| **禁止 AI 擅自提交的** | 未经 Claude Code 审查和修复的代码禁止 commit |

---

### 📋 任务分工表

#### 第零阶段：设计审核

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 0.1.1 | 生成图标方案（1024×1024 PNG） | 🤖 AI Agent | 使用 §4.5 prompt 模板生成 |
| 0.1.2 | **展示图标方案图片给 Human** | 🤖 AI Agent | **直接发送 PNG 图片文件**（不是描述或链接），让 Human 肉眼审核 |
| 0.1.3 | 提交 Git 等待审核 | 🤖 AI Agent | commit 到 `AppStore/Assets/Icon/` |
| 0.1.4 | 审核图标方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |
| 0.1.5 | 生成 19 个尺寸 | 🤖 AI Agent | 审核通过后使用 `ios-app-icon-generator` skill |
| 0.2.1 | **展示 UI 设计稿图片给 Human** | 🤖 AI Agent | **直接发送设计稿图片文件**（不是描述或链接），让 Human 肉眼审核 |
| 0.2.2 | 提交 Git 等待审核 | 🤖 AI Agent | commit 到 `AppStore/Assets/UI/` |
| 0.2.3 | 审核 UI 方案 | 👨 Human | **看图后**给出至少 1 个 approved 意见 |

> ⚠️ **【强制】AI Agent 必须直接展示图片给 Human 审核**：
> - 图标方案：直接展示 PNG 图片文件
> - UI 设计稿：直接展示设计稿截图（不是文件链接或文字描述）
> - 禁止只发送描述性文字或文件路径而不展示实际图片
> - Human 必须用肉眼审核图片后才能给出 approved 意见

#### 第一阶段：概念与命名

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 1.1 | 核查 App Store 名称是否被占用 | 🤖 AI Agent | 执行 curl 命令查询（**Agent 直接执行**）|
| 1.2 | 确定三层命名方案 | 🤖 AI Agent | 根据名称查询结果确定（**Agent 直接执行**）|
| 1.3 | 确认功能清单（≥60 个）| 🤖 AI Agent | 输出 `Docs/FeatureList.md`（**Agent 直接执行**）|
| 1.4 | 审核功能清单 | 👨 Human | 确认功能数量达标 |

#### 第二阶段：创建项目目录结构

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 2.1 | 创建目录结构 | 🤖 AI Agent | 执行 mkdir 命令（**Agent 直接执行**）|
| 2.2 | 初始化 Git，提交初始结构 | 🤖 AI Agent | git init, add, commit（**Agent 直接执行**）|

#### 第三阶段：project.yml 配置

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 3.1 | 编写 project.yml | 🤖 AI Agent | 配置 4 个 targets（**Agent 直接执行**）|
| 3.2 | 审查 project.yml | 🤖 AI Agent | **Claude Code 审查 + 修复**（Agent 直接执行）|

#### 第四阶段：必需的文件

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 4.1 | 编写 Info.plist、Entitlements | 🤖 AI Agent | 按模板生成（**Agent 直接执行**）|
| 4.2 | 审查配置文件 | 🤖 AI Agent | **Claude Code 审查 + 修复**（Agent 直接执行）|
| 4.3 | 编写 Widget Info.plist | 🤖 AI Agent | 按模板生成（**Agent 直接执行**）|
| 4.4 | 编写 Widget Entitlements | 🤖 AI Agent | 按模板生成（**Agent 直接执行**）|
| 4.5 | 编写 AppIcon 图标设计规范 | 🤖 AI Agent | 从 ggsheng-app-icon-design-SKILL.md 同步（**Agent 直接执行**）|

#### 第五阶段：XcodeGen 生成项目

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 5.1 | 执行 XcodeGen 生成项目 | 🤖 AI Agent | **SSH 到 MacinCloud** 执行（**Agent 直接执行，不需要询问人类**）|
| 5.2 | 验证生成结果 | 🤖 AI Agent | 检查文件是否完整（**Agent 直接执行**）|
| 5.3 | Git 提交 + 同步到 MacinCloud | 🤖 AI Agent | git push + SSH 到 MacinCloud 执行（**Agent 直接执行，不需要询问人类**）|

#### 第六阶段：App Store 截图制作

> ⚠️ **【强制】截图 + 视频必须在 Archive + Upload 之前完成**（第七/八阶段之前）

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 6.1 | 截图尺寸要求 | 🤖 AI Agent | 见 §6.0 工作流概述（**Agent 直接执行**）|
| 6.2 | 编写截图代码 | 🤖 AI Agent | 生成 `ScreenshotTests.swift`（**Agent 直接执行，不需要询问人类**）|
| 6.3 | 添加 Tab identifier | 🤖 AI Agent | 修改 App 源码添加 identifier（**Agent 直接执行**）|
| 6.4 | 文件名规范 | 🤖 AI Agent | 格式：`序号_页面名称.png`（**Agent 直接执行**）|
| 6.5 | 下载截图到 AppStore/Screenshots/ | 🤖 AI Agent | scp 下载到对应目录（**Agent 直接执行**）|
| 6.5.1 | MD5 验证每张截图不同 | 🤖 AI Agent | 使用 MD5 哈希验证（**Agent 直接执行，不需要询问人类**）|
| 6.5.2 | XCUITest 截图代码模板 | 🤖 AI Agent | 生成 `ScreenshotTests.swift` 模板（**Agent 直接执行，不需要询问人类**）|
| 6.6 | **展示截图图片给 Human 审核** | 🤖 AI Agent | **直接展示 3 张不同 Tab 页面的真实截图文件**（**必须发图片文件，不是链接或口述**）|

#### 第六阶段附加：测试

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 6.7 | 编写 + 审查 Unit Tests | 🤖 AI Agent | 编写功能测试代码，**Claude Code 审查 + 修复**（Agent 直接执行）|
| 6.8 | 编写 + 审查 E2E 测试 | 🤖 AI Agent | 编写 UI 测试代码，**Claude Code 审查 + 修复**（Agent 直接执行）|
| 6.9 | 录屏制作 | 🤖 AI Agent | 编写 XCUITest 截图代码 + ffmpeg 合成视频（**Agent 直接执行**）|
| 6.10 | 执行测试 | 🤖 AI Agent | SSH 到 MacinCloud 执行 xcodebuild test，然后 scp 下载结果（**Agent 直接执行**）|

#### 第七阶段：Widget 数据共享 / Beta 测试

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 7.1 | 配置 App Groups | 🤖 AI Agent | 修改 entitlements（**Agent 直接执行**）|
| 7.2 | **Archive 上传 TestFlight** | 👨 Human | **必须通过 VNC 桌面操作**（**可选操作**）|
| 7.3 | Beta 测试 | 👨 Human | 人类测试员执行（**可选操作**）|
| 7.4 | 修复 Bug | 🤖 AI Agent | 根据反馈修改代码（**Agent 直接执行**）|

#### 第八阶段：App Store Connect 上传

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 8.1 | **Archive + Sign and Upload** | 👨 Human | **必须通过 VNC 桌面操作** |
| 8.2 | 填写 App Store Connect 信息 | 👨 Human | 人类在网页上填写 |
| 8.3 | 配置 App 隐私 | 👨 Human | 根据 App 实际功能选择"是"或"否"（参考 §8.3 配置表）|
| 8.4 | 创建隐私政策 HTML | 🤖 AI Agent | 生成 `PrivacyPolicy.html`（**Agent 直接执行**）|
| 8.5 | 部署隐私政策到 GitHub Pages | 🤖 AI Agent | git push 后自动部署（**Agent 直接执行**）|
| 8.6 | AI 相关配置 | 🤖 AI Agent + 👨 Human | AI 写隐私政策条款，人类审核 |

#### 第九阶段：提交审核

| 步骤 | 任务 | 执行主体 | 说明 |
|------|------|---------|------|
| 9.1 | 提交前最终检查 + 生成审核回复模板 | 🤖 AI Agent | 输出检查清单 + 生成 Apple 审核回复模板（**Agent 直接执行**）|
| 9.2 | 填写清单核查 | 👨 Human | 人类逐项确认 |
| 9.3 | **创建 App + 选择 Bundle ID** | 👨 Human | 人类在 App Store Connect 点击"新建 App"，**必须手动选择正确的 Bundle ID** |
| 9.4 | **点击提交审核** | 👨 Human | 人类在 App Store Connect 点击 |
| 9.5 | 关注审核状态 | 👨 Human | 提交后状态变为"等待审核"，首次审核通常7-14个工作日 |

---

### 🚫 AI 禁止单独执行的操作

| 禁止操作 | 原因 | 正确做法 |
|---------|------|---------|
| 直接 commit 不经 Claude Code 审查 + 修复 | 代码质量无法保证 | Claude Code **审查 + 修复 → commit** |
| 通过 SSH signing 上传 | keychain locked 导致失败 | **必须走 VNC 桌面操作** |
| 跳过设计审核直接开发 | 会导致返工 | 图标+UI 审核通过后才能开发 |
| 跳过截图图片审核 | 可能所有截图都是首页 | **必须发送真实截图文件给 Human 肉眼确认** |
| 人类才能操作的步骤自称 AI 完成 | AI 无法操作 VNC 和网页 | 如实说明是 Human 操作 |
| 生成 .ipa 文件放到桌面或子文件夹 | .ipa 不应出现在桌面，必须通过 Xcode 直接上传 | Archive 后直接在 Xcode Organizer 上传 |
| 声称 XCUITest 需要 VNC GUI 才能运行 | XCUITest 只需 booted simulator，通过 SSH 即可执行 | 先 `xcrun simctl boot` 启动模拟器，再用 SSH 执行 xcodebuild test |
| 胡说八道或歪曲 SOP 规定 | 故意曲解或编造规则是违反 SOP 的行为 | 以 SOP 文档为准，不确定时查阅 SOP |
| Tab 切换失败时不思考直接问人类 | Agent 必须自己想办法解决 | **必须修改优化截图代码直到成功**，不能询问人类 |

---

### ✅ Claude Code 审查 + 修复（每次必须执行）

| 步骤 | 说明 |
|------|------|
| 1. **审查** | 分析代码发现问题（bug、风格、安全、无障碍等） |
| 2. **修复** | 根据审查结果修复所有发现的问题 |
| 3. **再次审查** | 确认修复完成，确保没有问题后才能 commit |
| 4. **执行地点** | 在 AI Agent 服务器执行，**不在 MacinCloud** |

| 审查项 | 说明 |
|------|------|
| 所有源码变更 | `git diff` 后必须 Claude Code 审查 + 修复 |
| project.yml 配置 | 确认 signing、entitlements 配置正确 |
| XCUITest 代码 | 确认 Tab 切换、截图逻辑正确 |
| 功能测试代码 | 确认测试覆盖核心功能 |
| 配置文件 | Info.plist、Entitlements 完整正确 |

> ⚠️ **【强制】每次代码变更后都必须执行 Claude Code 审查 + 修复**：禁止只审查不修复，或修复后不再次审查就提交。

---

### 📍 操作地点明确说明

| 操作 | 执行地点 | 说明 |
|------|---------|------|
| **Claude Code 审查 + 修复** | 🤖 AI Agent 服务器 | 审查代码发现问题并修复 |
| **git add/commit** | 🤖 AI Agent 服务器 | 本地提交 |
| **git push** | 🤖 AI Agent 服务器 | 推送到 GitHub |
| **同步代码到 MacinCloud** | 🤖 AI Agent 服务器 | SSH 到 MacinCloud 执行 `git pull origin main`（**不需要询问人类，直接执行**）|
| **XcodeGen 生成** | MacinCloud | 🤖 AI Agent **SSH 到 MacinCloud** 执行 `~/tools/xcodegen/bin/xcodegen generate`（**Agent 直接执行**）|
| **xcodebuild build/test** | MacinCloud | 🤖 AI Agent **SSH 到 MacinCloud** 执行（**Agent 直接执行，不需要询问人类**）|
| **截图（XCUITest）** | MacinCloud | 🤖 AI Agent **SSH 到 MacinCloud** 执行 xcodebuild test（**Agent 直接执行，不需要询问人类**）|
| **录屏（XCUITest + ffmpeg）** | MacinCloud | 视频帧采集，传输到 AI Agent 合成 |
| **模拟器管理** | MacinCloud | 🤖 AI Agent **SSH 到 MacinCloud** 执行 xcrun simctl（**Agent 直接执行，不需要询问人类**）|
| **Archive + Sign and Upload** | MacinCloud VNC | **必须通过 VNC 桌面手动操作** |
| **App Store Connect 填写** | 👨 Human 浏览器 | 人类在网页上操作 |
| **截图/录屏下载到本地** | 🤖 AI Agent 服务器 | scp 从 MacinCloud 下载 |

> ⚠️ **MacinCloud 的核心作用**：编译（build）、构建（xcodebuild）、打包（Archive）、截图（XCUITest）、录屏（XCUITest + ffmpeg）、模拟器管理（xcrun simctl）
>
> ⚠️ **【强制】XCUITest 截图通过 SSH 执行，不需要 VNC GUI**：
> - XCUITest 不需要真正的显示器，只需要模拟器已启动（booted）
> - 模拟器启动后（`xcrun simctl boot`），即使通过 SSH 执行 `xcodebuild test` 也能正常截图
> - **关键**：先 `xcrun simctl boot` 启动模拟器，再执行 xcodebuild test
> - 如果 SSH 执行 xcodebuild test 失败，先用 VNC 确认模拟器是否正常运行
>
> ⚠️ **【强制】MacinCloud 桌面必须保持整洁**：
> - MacinCloud VNC 桌面上**只存放 App 项目文件夹**（如 `ios-{AppName}`）
> - **禁止**在桌面存放其他文件（截图文件、临时文件、个人文件、.ipa 文件等）
> - **禁止**生成 .ipa 文件放到桌面或任何子文件夹
> - 所有截图/录屏文件必须通过 `scp` 下载到 AI Agent 本地，**不要留在 MacinCloud 桌面**
> - 定期清理 `/tmp/` 目录下的临时文件
>
> **【常见错误】部分 AI Agent 会混淆执行地点：**
> - "在 MacinCloud 上执行 Claude Code 审查" ❌ → Claude Code 在 AI Agent 服务器，不在 MacinCloud
> - "AI Agent 直接操作 VNC 桌面" ❌ → AI Agent 无法操作 VNC，必须人类操作
> - "SSH signing 可以替代 VNC" ❌ → SSH signing 会失败，必须 VNC

---

## 第零阶段：设计审核（必须先完成）

> ⚠️ **必须先完成设计审核，才能进入开发阶段**。未审核的设计直接开发会导致返工。

### 0.1 图标方案审核

1. **生成图标方案**：使用 §4.5 的 prompt 模板生成 1024×1024 PNG 源图
2. **直接展示图片给 Human 审核**：将 PNG 图片**直接展示**（不是文件路径或描述），让 Human 肉眼审核
3. **审核内容**：
   - 设计风格是否符合目标用户（欧美）审美
   - 是否符合 Apple Design Awards 质量标准
   - 是否符合 §4.5 趋势要求
   - 是否符合配色规范
4. **审核通过标准**：至少获得 1 个明确 approved 意见
5. **通过后**：提交 Git + 使用 `ios-app-icon-generator` skill 生成全部 19 个尺寸

### 0.2 App UI 设计方案审核

1. **输出设计方案**：使用 Sketch/Figma/PDF 输出主要页面设计稿（至少包含：首页、详情页、设置页）
2. **直接展示设计稿图片给 Human 审核**：**直接展示截图**（不是文件链接或描述），让 Human 肉眼审核
3. **审核内容**：
   - 界面设计风格是否与图标风格统一
   - 是否符合 §1.3 Apple Design Awards 级别要求
   - 交互流程是否符合 iOS 原生设计模式
   - 是否符合西方用户习惯
4. **审核通过标准**：至少获得 1 个明确 approved 意见
5. **通过后**：才能进入第三阶段开始编写代码

### 0.3 审核流程

```
┌─────────────────────────────────────────────────────┐
│  阶段 1：图标设计 → 提交 Git → 等待审核              │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ 图标审核通过 → 阶段 2                            │
│  ❌ 图标审核拒绝 → 修改后重新提交                    │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  阶段 2：UI 设计 → 提交 Git → 等待审核              │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ UI 审核通过 → 进入第一阶段（开发）              │
│  ❌ UI 审核拒绝 → 修改后重新提交                    │
└─────────────────────────────────────────────────────┘
```

## 第一阶段：概念与命名

### 1.1 提前核查 App Store 名称

```bash
curl -s "https://itunes.apple.com/search?term=你的名字&entity=software&limit=5" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); [print(r['trackName'], r['artistName']) for r in d['results']]"
```

### 1.2 三层命名

| 层级 | 示例占位符 | 位置 | 能否改 |
|------|-----------|------|--------|
| App Store 名称 | `{DesiredAppStoreName}` | App Store Connect | ✅ |
| Bundle ID | `com.ggsheng.{AppName}` | 打包进二进制 | ❌ |
| Display Name | `{AppName}` 或 `{DesiredAppStoreName}` | Info.plist | ✅ |

**规则：Bundle ID 一旦上传不能改，App Store 名称随时可换。**

### 1.3 App 界面设计规范（必读）

**App 界面设计风格必须与图标设计规范一致**，详见 §4.5。设计质量标准参照 **Apple Design Awards** 级别。

> ⚠️ **目标用户明确**：所有 App 主要面向欧美客户。图标和 UI 设计必须符合西方审美，避免中式审美元素（红金配色、生肖、太极等亚洲特有元素）。

#### 设计质量标准参照体系

| 标准/奖项 | 适用场景 | 说明 |
|---------|---------|------|
| **Apple Design Awards** | 所有 iOS App | Apple 官方顶级设计奖项，金标准 |
| **Apple HIG** | 所有 iOS App | Human Interface Guidelines，审核必查 |
| **Dribbble** | 视觉灵感 | 全球设计师作品集，搜索 iOS/App 设计趋势 |
| **Mobbin** | iOS 原生界面模式 | 收录大量知名 App 的真实界面截图 |
| **WWDC Design Sessions** | 设计理念与实践 | Apple 开发者大会设计相关演讲（每年 WWDC） |
| **Red Dot Design Award** | 交互/产品设计 | 国际权威工业设计奖，含 App 品类 |
| **iF Design Award** | 数字产品设计 | 另一国际权威设计奖项，数字产品类别 |

> **推荐实践**：先看 Apple HIG 理解基础规范，再从 Dribbble/Mobbin 获取视觉灵感，最后用 Apple Design Awards 获奖作品作为质量标杆。

#### 设计质量标准（Apple Design Awards 级别）

| 维度 | 要求 | 说明 |
|------|------|------|
| **视觉精致度** | 像素级完美，无锯齿、无模糊 | 所有图标、插图、装饰元素必须是矢量或高清 raster |
| **动效设计** | 流畅、自然、有意义 | 过渡动画 300-500ms，使用 spring/ ease-out 曲线 |
| **颜色系统** | 统一配色板，≤5 个核心色 | 深色背景 + 渐变辅助色，详见 §4.5 配色方案 |
| ** typography** | SF Pro Display/Text 系统字体 | 标题 20-34pt，正文 15-17pt，标注 11-13pt |
| **层次与间距** | 8pt 网格系统 | 边距/间距为 8 的倍数（8/16/24/32/40） |
| **一致性** | 全 App 统一设计语言 | 图标风格 → 按钮 → 卡片 → 页面层级保持一致 |

#### iOS 原生设计模式（必须遵循）

| 场景 | 正确写法 | 错误写法 |
|------|---------|---------|
| 导航 | TabView（底部标签栏）| 自定义侧面抽屉 |
| 列表 | List + ForEach | ScrollView + VStack（性能差）|
| 设置页 | Form + Section | 散落的无分组设置项 |
| 弹窗 | sheet/alert/confirmationDialog | 非原生的自定义弹窗 |
| 加载 | ProgressView/sheet | 自定义 GIF 或粗糙的 loading 动画 |
| 空状态 | ContentView 条件渲染 + 插图 | 空白屏幕或占位图 |
| Tab 切换 | `.tabItem {}` +  SF Symbol | 文字 label 或自定义图标按钮 |

#### 动效与转场规范

```
原则：动效服务于信息传达，不为装饰

转场时长：
  - 微交互（按钮点击）: 100-150ms
  - 页面元素出现: 300-400ms
  - 全屏转场: 350-500ms

曲线：
  - 强调/出现: spring(response: 0.5, dampingFraction: 0.8)
  - 消失/退回: easeOut
  - 共享元素: matchedGeometryEffect

禁止：
  - 过度弹跳（overshoot > 1.1）
  - 长时间旋转/加载动画
  - 与内容无关的随机漂浮元素
```

#### 深色模式优先设计

```
背景层级（深色模式）：
  - Level 1（最底层）: #000000 或 #0F0F14
  - Level 2（卡片）: #1C1C1E（80% 不透明度）
  - Level 3（弹窗）: #2C2C2E（90% 不透明度）
  - 高亮/选中: #48484A

语义色：
  - Primary: #9B8FE8（紫罗兰，用于主要操作）
  - Secondary: #6EE7B7（薄荷绿，用于成功/完成）
  - Accent: #FCD34D（琥珀金，用于强调/徽章）
  - Destructive: #EF4444（红色，用于删除/警告）
```

#### 常见扣分项（App Store 审核重点）

| 扣分项 | 问题描述 | 正确做法 |
|--------|---------|---------|
| 粗糙的自定义 UI | 用 `UIViewRepresentable` 包 UIKit 自定义控件导致风格割裂 | 尽量用 SwiftUI 原生控件 |
| 不一致的圆角 | 有的 12pt，有的 20pt | 统一使用 `.cornerRadius(12)` 或 `.cornerRadius(16)` |
| 文字对比度不足 | 灰色文字在深色背景上对比度 < 4.5:1 | 确保文字与背景对比度 ≥ 7:1（WCAG AA）|
| 点击区域太小 | 按钮高度 < 44pt（Apple HIG 最低标准）| 所有可点击元素 ≥ 44×44pt |
| 奇怪的字体回退 | 系统字体加载失败后显示默认 serif | 不要自定义字体文件，使用 SF Pro |
| 截图与 App 实际 UI 不符 | 截图经过过度美化 | 截图必须是 App 真实运行截图，不可修图 |

#### 无障碍功能要求（欧美市场强制）

> ⚠️ 欧美用户高度重视无障碍功能，Apple 审核也会检查。**所有功能必须支持无障碍**。

| 要求 | 实现方式 |
|------|---------|
| VoiceOver 标签 | 所有可交互元素必须设置 `accessibilityLabel` |
| Dynamic Type | 使用 `.font(.body)` 等相对字号，禁止固定 pt 值 |
| 颜色对比度 | 文字与背景对比度 ≥ 7:1（WCAG AA）|
| 点击区域 | 所有可点击元素 ≥ 44×44pt |
| 图像描述 | 图片需设置 `accessibilityLabel("描述文字")` |
| 无障碍测试 | VoiceOver 下所有功能必须可访问 |

**示例：**
```swift
// ✅ 正确
Button(action: { self.startTimer() }) {
    Image(systemName: "play.fill")
}
.accessibilityLabel("Start focus timer")
.accessibilityHint("Double tap to start the focus session")

// ❌ 错误 - 没有 Label，VoiceOver 无法朗读
Button(action: { self.startTimer() }) {
    Image(systemName: "play.fill")
}
```

```swift
// ✅ 正确 - 支持 Dynamic Type
Text("Focus Session")
    .font(.title2)

// ❌ 错误 - 固定字号，不支持缩放
Text("Focus Session")
    .font(.system(size: 24))
```

> ⚠️ **App 界面风格必须与图标风格统一**。如果图标采用了 Glassmorphism + Rich Gradients 风格，App 内所有页面也应保持一致的设计语言（深色背景、渐变色、模糊效果等）。风格不统一会严重影响 App Store 审核评分和用户留存。

#### 离线功能要求

> ⚠️ 所有 App 必须支持完全离线使用（Offline First），禁止强制要求网络连接。

| 要求 | 实现方式 |
|------|---------|
| 本地数据存储 | 所有数据必须本地持久化（UserDefaults/SQLite） |
| 离线状态 UI | 断网时显示正常功能，不显示网络错误 |
| 启动无网络依赖 | App 启动不检查网络，不弹网络错误 |
| 数据同步（可选）| 如果有云同步，必须支持离线优先 |

**验证方法**：
1. 飞行模式下启动 App，必须正常显示首页
2. 所有核心功能在飞行模式下必须可用

### 1.4 App 基础功能数量要求

**App 起步功能数量不能低于 60 个。**

| App 类型 | 功能数量要求 | 说明 |
|---------|-------------|------|
| 效率/生产力类 | ≥60 个 | 番茄钟、待办、日程、数据统计等 |
| 健康/健身类 | ≥60 个 | 追踪、记录、提醒、报告等 |
| 金融/财务类 | ≥60 个 | 记账、预算、报表、分析等 |
| 社交/创意类 | ≥60 个 | 互动、内容、分享、反馈等 |

> ⚠️ **功能数量不足会被 App Store 审核拒绝**。Apple 要求 App 必须提供足够的实用价值，"只是一个简单计时器"或"只是一个待办列表"会因为功能单薄被拒。建议在开发前列出功能清单，确保核心功能达到 60 个以上再提交。

**必须输出功能清单文档**：`Docs/FeatureList.md`，格式：

```markdown
# {AppName} 功能清单

## 核心功能（≥60）
| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 1 | Focus Timer | 番茄工作法计时器 | P0 |
| 2 | Session History | 历史记录查看 | P0 |
| ... | ... | ... | ... |

## 辅助功能
| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 51 | Settings | 设置页面 | P1 |
...
```

**规则**：
- 必须在开发前完成并提交 Git
- 标记 P0（核心功能）和 P1（辅助功能）
- 提交前必须审核确认功能数量 ≥60
- 开发过程中新增功能必须同步更新此文档

### 1.5 App 审核准备（需要登录的 App）

**如果 App 需要登录才能使用完整功能，必须准备测试账号和 Demo 数据**：

| 准备项 | 说明 |
|--------|------|
| 测试账号 | 格式：`test@example.com` 或 `testuser` |
| 密码 | 简单密码，不含特殊字符：`Test123456` |
| Demo 数据 | 账号里预置真实数据，方便审核人员快速验证 |

**Demo 数据插入代码示例**：
```swift
// AppDelegate.swift 或 ContentView.swift
func insertDemoDataIfNeeded() {
    // 只有在 UserDefaults 为空时才插入 Demo 数据
    if UserDefaults.standard.object(forKey: "hasInsertedDemo") == nil {
        let demoHabits = [
            Habit(name: "Morning Exercise", icon: "figure.walk", streak: 7),
            Habit(name: "Read 30min", icon: "book", streak: 3),
            Habit(name: "Drink Water", icon: "drop", streak: 14)
        ]
        // ... 保存 demo 数据 ...
        UserDefaults.standard.set(true, forKey: "hasInsertedDemo")
    }
}
```

**Demo 数据要求**：
- 必须真实可信，不能是明显的占位符（如"测试123"）
- 涵盖 App 主要功能，让审核人员快速理解
- 数据量适中（3-10 条记录即可）

---

## 第二阶段：创建项目目录结构

```bash
mkdir -p ios-{AppName}/{AppName,AppNameWidget,AppNameTests,AppNameUITests,AppStore}
mkdir -p ios-{AppName}/AppName/{App,Models,Views,ViewModels}
mkdir -p ios-{AppName}/AppName/Assets.xcassets/{AppIcon.appiconset,AccentColor.colorset}
mkdir -p ios-{AppName}/AppNameWidget/Assets.xcassets
mkdir -p ios-{AppName}/AppStore/{Screenshots,AppPreview,Listing.md}
mkdir -p ios-{AppName}/AppStore/Assets/{Icon,UI}  # 图标源文件、设计文件
mkdir -p ios-{AppName}/Docs
```

**文件夹名** = 项目中文档和代码引用的实际路径，**必须与 project.yml 的 `path:` 一致**。
**AppStore/Assets/Icon** = App 图标源文件（1024×1024 PNG 等）
**AppStore/Assets/UI** = 界面设计稿（Sketch/Figma/PDF）
**Docs** = 项目文档目录，详细记录项目变更、功能等相关信息

> ⚠️ **所有产物必须纳入 Git**：AppStore/Assets/ 下的设计文件、图标源文件、Docs/ 下的文档都必须 commit，**不许本地留存未提交的设计产物**。

---

## 第三阶段：project.yml 完整配置

### 3.1 完整模板

```yaml
# ══════════════════════════════════════════════════════════════
# 项目级别配置
# ══════════════════════════════════════════════════════════════

name: {AppName}                          # ← Xcode 项目名 = xcodeproj 文件名
options:
  bundleIdPrefix: com.ggsheng            # Bundle ID 前缀
  deploymentTarget:
    iOS: "17.0"                          # 最低 iOS 版本（Widget 用 containerBackground 需 17.0+）
  xcodeVersion: "15.0"
  generateEmptyDirectories: true

# ══════════════════════════════════════════════════════════════
# 全局构建设置（所有 target 继承）
# ══════════════════════════════════════════════════════════════

settings:
  base:
    SWIFT_VERSION: "5.9"
    MARKETING_VERSION: "1.0.0"            # App Store 显示的版本号
    CURRENT_PROJECT_VERSION: "1"          # 每次 archive 递增
    CODE_SIGN_STYLE: Automatic            # ← 关键：自动签名
    DEVELOPMENT_TEAM: 9L6N2ZF26B          # ← 关键：团队 ID
    ENABLE_USER_SCRIPT_SANDBOXING: NO     # 禁止，否则有脚本签名问题

# ══════════════════════════════════════════════════════════════
# Target 1: 主 App
# ══════════════════════════════════════════════════════════════

targets:
  {AppName}:                             # ← Target 名称（Xcode 里看到的）
    type: application
    platform: iOS
    sources:
      - path: {AppName}                  # ← 源码文件夹（必须和 target 名一致）
        excludes:
          - "**/.DS_Store"
    settings:
      base:
        # ← Info.plist 路径（相对项目根目录）
        INFOPLIST_FILE: {AppName}/Info.plist
        # ← Bundle ID（com.ggsheng.后面跟 AppStore 确认的名称）
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}
        # ← App Store 显示名（可以不是 target 名）
        PRODUCT_NAME: {AppName}
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
        GENERATE_INFOPLIST_FILE: NO       # ← 必须 NO，用自己写的 Info.plist
        SWIFT_EMIT_LOC_STRINGS: YES
        CODE_SIGN_ENTITLEMENTS: {AppName}/{AppName}.entitlements
        CODE_SIGN_STYLE: Automatic        # 继承全局
        # ← simulator 构建跳过签名（节省时间）
        CODE_SIGNING_ALLOWED: NO
        DEVELOPMENT_TEAM: 9L6N2ZF26B     # 继承全局，但明确写出
      # ════════════════════════════════════════
      # per-config 覆盖（关键！）
      # ════════════════════════════════════════
      configs:
        Debug:                           # Simulator 构建
          CODE_SIGNING_ALLOWED: NO       # ← Debug 跳过签名
        Release:                         # Archive 构建
          CODE_SIGNING_ALLOWED: YES       # ← Release 开启签名（必须！）
    entitlements:
      path: {AppName}/{AppName}.entitlements
    dependencies:
      - target: {AppName}Widget          # ← 可选：如果 App 不需要 Widget，删除此行及 Widget target
        embed: true                       # ← 自动嵌入主 App（无需 Widget 时删除整个 dependency 块）

# ══════════════════════════════════════════════════════════════
# Target 2: Widget Extension（可选，非必需）
# ══════════════════════════════════════════════════════════════
# ⚠️ 注意：Widget 为可选项。如果 App 不需要 Widget（如噪音检测、饮水追踪、抉择器等），删除此 target 及下方 dependency。
# 删除后同步删除 {AppName}Widget/ 源码文件夹，并在主 App 的 entitlements 中移除 App Group（如果不用 Widget）。

  {AppName}Widget:
    type: app-extension
    platform: iOS
    sources:
      - path: {AppName}Widget
        excludes:
          - "**/.DS_Store"
    settings:
      base:
        INFOPLIST_FILE: {AppName}Widget/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}.widget
        PRODUCT_NAME: {AppName}Widget
        GENERATE_INFOPLIST_FILE: NO
        SWIFT_EMIT_LOC_STRINGS: YES
        CODE_SIGN_ENTITLEMENTS: {AppName}Widget/{AppName}Widget.entitlements
        CODE_SIGNING_ALLOWED: NO
        DEVELOPMENT_TEAM: 9L6N2ZF26B
        SKIP_INSTALL: YES                 # ← Widget 必须 YES
        LD_RUNPATH_SEARCH_PATHS:
          - "$(inherited)"
          - "@executable_path/Frameworks"
          - "@executable_path/../../Frameworks"
      configs:
        Debug:
          CODE_SIGNING_ALLOWED: NO
        Release:
          CODE_SIGNING_ALLOWED: YES       # ← Widget Release 也必须 YES！

    entitlements:
      path: {AppName}Widget/{AppName}Widget.entitlements

# ══════════════════════════════════════════════════════════════
# Target 3: Unit Tests
# ══════════════════════════════════════════════════════════════

  {AppName}Tests:
    type: bundle.unit-test
    platform: iOS
    sources:
      - path: {AppName}Tests
        excludes:
          - "**/.DS_Store"
    dependencies:
      - target: {AppName}
    settings:
      base:
        INFOPLIST_FILE: {AppName}Tests/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}Tests
        PRODUCT_NAME: {AppName}Tests
        GENERATE_INFOPLIST_FILE: NO
        TEST_HOST: "$(BUILT_PRODUCTS_DIR)/{AppName}.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/{AppName}"
        BUNDLE_LOADER: "$(TEST_HOST)"
        CODE_SIGN_STYLE: Automatic
        DEVELOPMENT_TEAM: 9L6N2ZF26B

# ══════════════════════════════════════════════════════════════
# Target 4: UI Tests
# ══════════════════════════════════════════════════════════════

  {AppName}UITests:
    type: bundle.ui-testing
    platform: iOS
    sources:
      - path: {AppName}UITests
        excludes:
          - "**/.DS_Store"
    dependencies:
      - target: {AppName}
    settings:
      base:
        INFOPLIST_FILE: {AppName}UITests/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.ggsheng.{AppName}UITests
        PRODUCT_NAME: {AppName}UITests
        GENERATE_INFOPLIST_FILE: NO
        TEST_TARGET: "$(BUILT_PRODUCTS_DIR)/{AppName}.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/{AppName}"
        CODE_SIGN_ENTITLEMENTS: ""        # UI Test target 不需要 entitlements
        CODE_SIGN_STYLE: Automatic
        DEVELOPMENT_TEAM: 9L6N2ZF26B

# ══════════════════════════════════════════════════════════════
# Schemes
# ══════════════════════════════════════════════════════════════

schemes:
  {AppName}:                             # ← Scheme 名（和 target 名一致）
    build:
      targets:
        {AppName}: all                   # 主 App
        {AppName}Widget: all             # ← 可选：如果没有 Widget，删除此行
        {AppName}UITests: [test]         # UI Test
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - {AppName}UITests
    archive:
      config: Release                     # ← Archive 必须用 Release
```

### 3.2 signing 配置逐行解析

**为什么需要 `configs: Debug / Release` 两层？**

因为 Xcode 的 Archive 操作默认使用 **Release 配置**，但本地调试用 **Debug 配置**：

| 场景 | 配置 | CODE_SIGNING_ALLOWED |
|------|------|----------------------|
| 本地 Simulator 调试 | Debug | NO（跳过签名，simulator 不检查）|
| Archive 打包上传 | Release | YES（必须签名）|

**如果 base level 写 `CODE_SIGNING_ALLOWED: NO`** → Release 构建也被禁止 → Archive 失败

**如果只有 Release 写 YES，Debug 写 NO** → Archive 失败，因为 base 的 NO 会覆盖

**正确做法：base 留空或写 YES，per-config Debug 覆盖为 NO，Release 保持 YES**

```yaml
# 错误 ❌
settings:
  base:
    CODE_SIGNING_ALLOWED: NO             # base 这样写 = Release 也被禁止

# 正确 ✅
settings:
  base:
    CODE_SIGNING_ALLOWED: NO             # 只对 Debug 生效
  configs:
    Debug:
      CODE_SIGNING_ALLOWED: NO          # 显式确认
    Release:
      CODE_SIGNING_ALLOWED: YES         # 覆盖 base，Release 允许签名
```

---

## 第四阶段：必需的文件 + Info.plist 预配置

> **⚠️ 所有 Info.plist 字段必须在开发阶段就配好，不能等到提交前才填。**

### 4.1 主 App Info.plist（含预配置）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 出口合规：避免每次提交被问到加密问题 -->
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>AppStoreName</string>         <!-- App Store 显示名 -->
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>appname</string>   <!-- 小写，用于 URL scheme -->
            </array>
        </dict>
    </array>
    <!-- ========== 权限描述（按需启用，必须英文）============ -->
    <!-- ⚠️ 以下权限按 App 实际需要启用，不需要的一律删除 -->
    <!--
    <key>NSHealthShareUsageDescription</key>
    <string>{AppName} needs to read health data to provide fitness tracking features.</string>
    <key>NSHealthUpdateUsageDescription</key>
    <string>{AppName} needs to log your activities to the Health app.</string>
    <key>NSCalendarsUsageDescription</key>
    <string>{AppName} needs access to your calendar to schedule reminders.</string>
    <key>NSUserNotificationsUsageDescription</key>
    <string>{AppName} needs to send you notifications for reminders and updates.</string>
    -->
</dict>
</plist>
```

### 4.2 主 App Entitlements

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.ggsheng.AppName</string>  <!-- Widget 共享数据用 -->
    </array>
</dict>
</plist>
```

### 4.3 Widget Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>AppName Widget</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>
    </dict>
</dict>
</plist>
```

### 4.4 Widget Entitlements

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.ggsheng.AppName</string>  <!-- 必须和主 App 一致 -->
    </array>
</dict>
</plist>
```

### 4.5 AppIcon 图标设计规范（必读）

#### 🚀 当前最惊艳图标设计趋势（2024-2025）

| 趋势 | 描述 | 适用场景 | 参照 |
|------|------|---------|------|
| Glassmorphism | 毛玻璃 + 半透明 + 高斯模糊 | 专注/创意类App | [Dribbble](https://dribbble.com/search/glassmorphism-icon) |
| Rich Gradients | 多色渐变、渐变网格、径向渐变 | 大多数App | [Mobbin](https://mobbin.com/browse/ios/apps) |
| Depth & Layers | 多层叠放 + 柔和阴影创造3D深度 | 生产力/工具类 | [Behance](https://www.behance.net/search/projects?search=3d+icon) |
| Neumorphism | 柔和内外阴影，元素"挤出"表面 | 金融/商务类 | [Dribbble](https://dribbble.com/search/neumorphism-icon) |
| Organic Shapes | 圆润blob形状、流动曲线 | 健康/社交类 | [Behance](https://www.behance.net/search/projects?search=organic+icon) |
| 3D Realism | 微妙的3D效果 + 光源统一 | 游戏/创意类 | [Red Dot](https://www.red-dot.org/en/design/awards) |
| Minimal Geometric | 极简几何、精确对齐、负空间 | 工具类App | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/app-icons) |
| Dark Mode First | 深色优先优化，深色背景突出 | 所有App | [Apple Design Awards](https://developer.apple.com/design/awards/) |

**推荐组合**：Rich Gradients + Depth & Layers 或 Minimal Geometric + Neumorphism

#### 设计质量标准参照

| 标准/奖项 | 说明 |
|---------|------|
| **Apple Design Awards** | Apple 官方顶级设计奖项，质量金标准 |
| **Apple HIG - App Icons** | Human Interface Guidelines 图标章节，审核必查 |
| **Red Dot Design Award** | 国际权威工业设计奖 |
| **iF Design Award** | 国际权威设计奖 |
| **Dribbble / Behance** | 全球设计师作品集，用于视觉灵感 |

#### ❌ 图标设计禁忌（常见错误）

| 错误 | 问题 | 正确做法 |
|------|------|---------|
| 4合1拼接图 | Apple 要求独立图标 | 每个 1024×1024 单个文件 |
| 缩略图当源文件 | 放大后模糊 | 始终使用 1024×1024 源图 |
| 忽略 Apple HIG | 审核被拒 | 遵循 HIG 设计规范 |
| 堆叠太多效果 | 小尺寸杂乱 | 选择2-3个核心效果，克制使用 |
| 过于写实3D | 失去可辨识度 | 保持抽象微妙，审核可能被拒 |

#### ✅ 正确设计规范

| 要求 | 说明 |
|------|------|
| 单一设计 | 每个图标是独立的统一设计，禁止拼接 |
| 无文字 | App Store 图标不允许有文字 |
| 无真实人脸 | 不要用相机拍摄的图片或真实人脸 |
| 清晰可辨 | 在小尺寸（20pt）下也要清晰 |
| 局部深度 | 使用阴影和层次感增加质感 |
| 克制效果 | 选择2-3个趋势组合，不堆叠 |

#### 趋势配色方案推荐

| 方案 | 主色 | 辅助色 | 高光色 |
|------|------|--------|--------|
| 深空宇宙 | #0F0F14 | #6366F1 (靛蓝) | #A78BFA (紫) |
| 极光绿洲 | #0F172A | #10B981 (翠绿) | #34D399 (薄荷) |
| 暖阳琥珀 | #18181B | #F59E0B (琥珀) | #FCD34D (金) |
| 活力珊瑚 | #1F2937 | #F472B6 (珊瑚粉) | #FB923C (橙) |

#### 图标生成 prompt 模板

```
Create a SINGLE, stunning Apple App Store icon for "[AppName]" - [App Description].

Design: [描述具体设计]
- 1024x1024 PNG
- Dark background (#0F0F14)
- Colors: violet (#9B8FE8), mint (#6EE7B7), amber (#FCD34D)
- Apple Design Awards quality
- No text
- Single unified design (NOT grid/composite)
- [具体设计描述]
```

---

### 4.6 AppIcon Contents.json（标准 19 项格式）

> ⚠️ **重要：文件名使用 `@1x`/`@2x`/`@3x` 后缀表示 scale，Contents.json 的 `scale` 字段同步标注。**
> 这不是重复 — `@` 后缀是文件名规范，`scale` 字段是 asset catalog 元数据。两者一致才能被 Spotlight 正确索引。
> 旧格式（idiom=iphone/ipad、无 filename 字段）会导致 "4 unassigned children" 警告。

```json
{
  "images" : [
    { "filename" : "Icon-20@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "20x20" },
    { "filename" : "Icon-20@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "20x20" },
    { "filename" : "Icon-20@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "20x20" },
    { "filename" : "Icon-29@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "29x29" },
    { "filename" : "Icon-29@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "29x29" },
    { "filename" : "Icon-29@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "29x29" },
    { "filename" : "Icon-40@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "40x40" },
    { "filename" : "Icon-40@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "40x40" },
    { "filename" : "Icon-40@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "40x40" },
    { "filename" : "Icon-58@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "29x29" },
    { "filename" : "Icon-58@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "29x29" },
    { "filename" : "Icon-76@1x.png", "idiom" : "universal", "platform" : "ios", "scale" : "1x", "size" : "76x76" },
    { "filename" : "Icon-76@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "76x76" },
    { "filename" : "Icon-80@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "40x40" },
    { "filename" : "Icon-80@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "40x40" },
    { "filename" : "Icon-83.5@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "83.5x83.5" },
    { "filename" : "Icon-120@2x.png", "idiom" : "universal", "platform" : "ios", "scale" : "2x", "size" : "60x60" },
    { "filename" : "Icon-120@3x.png", "idiom" : "universal", "platform" : "ios", "scale" : "3x", "size" : "60x60" },
    { "filename" : "Icon-1024@1x.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```


**尺寸对照表：**

| Filename | Nominal PT | @Scale | Actual Px | Device |
|---|---|---|---|---|
| Icon-20@1x/2x/3x | 20pt | @1x/@2x/@3x | 20/40/60px | iPhone |
| Icon-29@1x/2x/3x | 29pt | @1x/@2x/@3x | 29/58/87px | Settings |
| Icon-40@1x/2x/3x | 40pt | @1x/@2x/@3x | 40/80/120px | Spotlight |
| Icon-58@2x/3x | 29pt | @2x/@3x | 116/174px | Spotlight |
| Icon-76@1x/2x | 76pt | @1x/@2x | 76/152px | iPad |
| Icon-80@2x/3x | 40pt | @2x/@3x | 160/240px | Spotlight |
| Icon-83.5@2x | 83.5pt | @2x | 167px | iPad Pro |
| Icon-120@2x/3x | 60pt | @2x/@3x | 120/180px | iPhone |
| Icon-1024@1x | 1024pt | @1x | 1024px | App Store |


**⚠️ 关键规则：**
- `size` 字段是 **point size**，不是像素！`"20x20"` @2x = 实际 40×40 像素
- 所有文件名必须与 Contents.json 中的 `filename` 字段完全一致（区分大小写）
- 每次新增 App 或修复图标，使用 `ios-app-icon-generator` skill 从 1024×1024 源图生成全部 19 个尺寸
- 图标文件必须为 **PNG 格式**，不能是 JPEG
- 删除旧格式文件（如 `Icon-1024.png`、`Icon-76.png`、`Icon-76-2x.png`），确保恰好 19 个文件


### 4.7 AccentColor Contents.json

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.345",
          "green" : "0.780",
          "red" : "0.204"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

---

## 第五阶段：XcodeGen 生成项目

### 5.1 生成命令

```bash
cd ~/Desktop/ios-{AppName}
~/tools/xcodegen/bin/xcodegen generate
```

**成功输出：**
```
⚙️  Writing project...
Created project at /Volumes/.../ios-{AppName}/{AppName}.xcodeproj
```

**⚠️ 注意：**
- XcodeGen 每次运行会**完全重写** .xcodeproj 文件
- 不要手动编辑 .xcodeproj 里的任何内容，所有改动都改 project.yml 再重新 XcodeGen
- 如果有旧的 .xcodeproj，XcodeGen 会覆盖它

### 5.2 验证生成结果

```bash
# 确认 target 名称
grep -E 'name = [A-Z][A-Za-z]+;' {AppName}.xcodeproj/project.pbxproj \
  | grep -v 'PRODUCT_BUNDLE\|PRODUCT_NAME\|CODE_SIGN' \
  | head -10

# 确认 signing 配置
grep -B2 -A5 'buildConfiguration.*Release' {AppName}.xcodeproj/project.pbxproj \
  | grep CODE_SIGNING_ALLOWED

# 确认 Bundle ID
grep 'PRODUCT_BUNDLE_IDENTIFIER' {AppName}.xcodeproj/project.pbxproj
```

### 5.3 完整变更流程（必须遵守）

```
┌─────────────────────────────────────────────────────┐
│  本地修改 project.yml / 源码 / 资源文件              │
│  同步更新 AppStore/ 目录（截图、设计文档等）         │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  Claude Code **审查 + 修复**：分析源码，修复所有问题  │
│  必须重复执行直到无问题为止                        │
│  检查项：语法错误、逻辑问题、API 误用、内存泄漏   │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  git add -A → git commit → git push origin main    │
│  ⚠️ 必须包含所有变更：源码、设计文件、文档、图标   │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  MacinCloud: git pull origin main                   │
│  ~/tools/xcodegen/bin/xcodegen generate             │
│  rm -rf ~/Library/Developer/Xcode/DerivedData/*    │
│  xcodebuild build -project {AppName}.xcodeproj      │
│    -target {AppName} -configuration Debug           │
│    -destination 'platform=iOS Simulator,id={UDID}'  │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  Claude Code **再次审查** MacinCloud 构建输出         │
│  如有错误：修复后重新 push → pull → build           │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  ✅ BUILD SUCCEEDED                                 │
│  ⚠️ 必须重新截图                                      │
└─────────────────┬───────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────┐
│  打开 Xcode → Archive                              │
└─────────────────────────────────────────────────────┘
```

> ⚠️ **Claude Code 审查要求**：
> - 每次代码变更后，必须使用 Claude Code 对源码进行审查
> - 使用 `/review` 或类似指令进行全面检查
> - 发现问题立即修复，重复审查直到没有问题
> - **禁止跳过审查直接提交**：未审查的代码可能导致构建失败或功能缺陷
> - 审查重点：语法错误、逻辑问题、API 误用、内存泄漏、force unwrap、可选类型处理

---

## 第六阶段：App Store 截图制作

### 6.0 截图工作流概述

> ⚠️ **【强制】截图数量 = App页面数 × 5个设备**
> - **最少数量**：每个上传区域1张（5区域共5张）
> - **建议数量**：每个App页面 × 5个设备（如App有5个Tab，则5×5=25张）
> - **最多**：每个上传区域10张

**截图设备清单：**

| 设备 | 模拟器 | 分辨率 | 上传区域 |
|------|--------|--------|---------|
| iPhone 16 Pro Max | iPhone 16 Pro Max | 1320×2868 | 6.9" |
| iPhone 14 Plus | iPhone 14 Plus | 1284×2778 | 6.5" |
| iPhone 16 Pro | iPhone 16 Pro | 1206×2622 | 6.3" |
| iPad Pro 13" (M4) | iPad Pro 13-inch (M4) | 2048×2732 | 13" |
| iPad Pro 11" (M4) | iPad Pro 11-inch (M4) | 1668×2388 | 11" |

**工作流：**
1. **创建专用 XCUITest 文件**（`ScreenshotTests.swift`），每个设备单独测试函数
2. **启动5个模拟器**（分别 boot 上述5个设备）
3. **运行测试并截图**（保存到 `/tmp/` 目录）
4. **验证截图内容不同**（使用 MD5 哈希确保每张截图内容不同）
5. **复制到 AppStoreScreenshots 目录**（按分辨率子目录分类，如 `iPhone_69_1320x2868/`）
6. **提交到 GitHub**

> ⚠️ **常见问题：所有截图都是首页** — 这是最容易犯的错误。Tab 切换代码写错、UI 定位失败、等待时间不足等原因，都会导致所有截图都是首页。**必须用 MD5 哈希 + 发送真实截图文件给 Human 肉眼确认**，确保每张截图确实不同页面。

### 6.1 App Store 截图尺寸要求（必须符合最新 Apple 规范）

> Apple 随时可能更新要求，提交前以 App Store Connect 页面显示的尺寸为准。

**必需尺寸（5 个上传区域，每个最多 10 张截图）：**

| 上传区域 | 接受分辨率（px）| 方向 | 推荐模拟器 |
|---------|----------------|------|-----------|
| iPhone 6.9"（合并 6.5"/6.7"/6.9"）| 1260×2736, 2736×1260, 1320×2868, 2868×1320, 1290×2796, 2796×1290 | 竖 / 横 | iPhone 16 Pro Max |
| iPhone 6.5" | 1242×2688, 2688×1242, 1284×2778, 2778×1284 | 竖 / 横 | iPhone 14 Plus |
| iPhone 6.3" | 1206×2622, 2622×1206, 1179×2556, 2556×1179 | 竖 / 横 | iPhone 16 Pro |
| iPad 13" | 2064×2752, 2752×2064, 2048×2732, 2732×2048 | 竖 / 横 | iPad Pro 13" (M4) |
| iPad 11" | 1668×2420, 2420×1668, 1668×2388, 2388×1668, 1640×2360, 2360×1640, 2266×1488, 1488×2266 | 竖 / 横 | iPad Pro 11" (M4) |

> ⚠️ **每个上传区域最多 10 张截图。** 同一区域内的不同分辨率截图可混用（如 6.9" 区域可用 iPhone 16 Pro Max 截的 1320×2868）。
>
> ⚠️ **严禁 resize / upscale / 拉伸 截图。** 截图必须从对应尺寸的模拟器或真机实截。
>
> 提交前以 App Store Connect 页面上显示的要求尺寸为准。

### 6.2 XCUITest 截图完整流程

#### Step 1: 查看可用模拟器（找 Booted 的）
```bash
xcrun simctl list devices booted | grep -E 'iPhone|iPad'
```

**注意：** 模拟器必须先 boot 才能正确截图。使用 `xcrun simctl boot 'iPhone 16 Pro Max'` 启动。

#### Step 2: 创建专用截图测试文件

**⚠️ 模板说明**：以下模板假设 App 有 5 个 Tab（Home/History/Stats/Achievements/Settings）。根据实际 App 的 Tab 数量调整测试函数数量和命名。

**关键规则：**
- **必须给每个 Tab 添加 `accessibilityIdentifier`**（App 源码要求），XCUITest 用 `NSPredicate` + `firstMatch` 精确匹配
- **必须等待 App 完全稳定**：`Thread.sleep(forTimeInterval: 2.0)` 在 `setup()` 里
- 每个标签页切换后等待 `usleep(1500000)`（1.5秒）确保页面渲染完成
- 必须使用 `--uitesting` launch argument 启动 App
- **不要用坐标点击**，在 iPad 上无效且会导致所有截图都是首页
- **详细排查方案见 §6.3**

> ⚠️ **警告：Tab 切换失败 = 所有截图都是首页** — 测试运行通过不等于截图正确！必须发送真实截图文件给 Human 肉眼确认。

```swift
import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]  // 关键：启用 UI 测试模式
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)  // ✅ 等待 App 完全稳定再操作
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - 截图辅助函数

    func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    // MARK: - Tab 切换辅助函数（必须使用 accessibilityIdentifier）

    func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
        } else {
            print("WARNING: Could not find tab button: \(identifier)")
        }
    }

    // MARK: - iPhone 截图（6.9" - 1320×2868）
    // 模拟器：iPhone 16 Pro Max

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_History() {
        tapTab(identifier: "tab_history")  // ✅ 使用 accessibilityIdentifier
        capture("iPhone_69_portrait_02_History")
    }

    func testiPhone_69_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_69_portrait_03_Stats")
    }

    func testiPhone_69_04_Achievements() {
        tapTab(identifier: "tab_achievements")
        capture("iPhone_69_portrait_04_Achievements")
    }

    func testiPhone_69_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_69_portrait_05_Settings")
    }

    // MARK: - iPhone 截图（6.5" - 1284×2778）
    // 模拟器：iPhone 14 Plus

    func testiPhone_65_01_Home() {
        capture("iPhone_65_portrait_01_Home")
    }

    func testiPhone_65_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPhone_65_portrait_02_History")
    }

    func testiPhone_65_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_65_portrait_03_Stats")
    }

    func testiPhone_65_04_Achievements() {
        tapTab(identifier: "tab_achievements")
        capture("iPhone_65_portrait_04_Achievements")
    }

    func testiPhone_65_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_65_portrait_05_Settings")
    }

    // MARK: - iPhone 截图（6.3" - 1206×2622）
    // 模拟器：iPhone 16 Pro

    func testiPhone_63_01_Home() {
        capture("iPhone_63_portrait_01_Home")
    }

    func testiPhone_63_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPhone_63_portrait_02_History")
    }

    func testiPhone_63_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_63_portrait_03_Stats")
    }

    func testiPhone_63_04_Achievements() {
        tapTab(identifier: "tab_achievements")
        capture("iPhone_63_portrait_04_Achievements")
    }

    func testiPhone_63_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_63_portrait_05_Settings")
    }

    // MARK: - iPad 截图（13" - 2048×2732）
    // 模拟器：iPad Pro 13-inch (M4)

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPad_13_portrait_02_History")
    }

    func testiPad_13_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPad_13_portrait_03_Stats")
    }

    func testiPad_13_04_Achievements() {
        tapTab(identifier: "tab_achievements")
        capture("iPad_13_portrait_04_Achievements")
    }

    func testiPad_13_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_13_portrait_05_Settings")
    }

    // MARK: - iPad 截图（11" - 1668×2388）
    // 模拟器：iPad Pro 11-inch (M4)

    func testiPad_11_01_Home() {
        capture("iPad_11_portrait_01_Home")
    }

    func testiPad_11_02_History() {
        tapTab(identifier: "tab_history")
        capture("iPad_11_portrait_02_History")
    }

    func testiPad_11_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPad_11_portrait_03_Stats")
    }

    func testiPad_11_04_Achievements() {
        tapTab(identifier: "tab_achievements")
        capture("iPad_11_portrait_04_Achievements")
    }

    func testiPad_11_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_11_portrait_05_Settings")
    }
}
```

#### Step 3: 同步到 MacinCloud 并生成项目

> ⚠️ **【强制】此步骤由 AI Agent 执行，不需要询问人类**，直接通过 SSH 执行。
```bash
# 本地提交
git add -A && git commit -m "Add screenshot tests" && git push origin main

# MacinCloud 同步（AI Agent 直接执行，不需要询问人类）
sshpass -p 'idt52924irh' ssh user291981@LA690.macincloud.com "cd Desktop/ios-{AppName} && git fetch origin && git reset --hard origin/main && ~/tools/xcodegen/bin/xcodegen generate"
```

#### Step 4: 启动模拟器并运行测试

> ⚠️ **【强制】此步骤由 AI Agent 执行，不需要询问人类**。Agent 通过 SSH 到 MacinCloud 执行 xcodebuild test 捕获截图。
>
> ⚠️ **UDID 占位符必须替换**：先用 `xcrun simctl list devices booted` 获取真实 UDID 并替换。
>
> ⚠️ **模拟器名称**：先用 `xcrun simctl list devices available` 确认实际可用的模拟器名称。
>
> ⚠️ **【强制】Tab 切换失败时**：Agent 必须自己想办法解决，**修改优化截图代码直到成功**，禁止询问人类。
```bash
# 先获取 MacinCloud 上的模拟器列表和 UDID
sshpass -p 'idt52924irh' ssh user291981@LA690.macincloud.com "xcrun simctl list devices available | grep -E 'iPhone|iPad'"
```
# ── iPhone 6.9" (iPhone 16 Pro Max) ──────────────────────────
xcrun simctl boot 'iPhone 16 Pro Max' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,id={UDID_iPhone_16_Pro_Max}' \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_69_01_Home \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_69_02_History \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_69_03_Stats \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_69_04_Achievements \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_69_05_Settings

# ── iPhone 6.5" (iPhone 14 Plus) ─────────────────────────────
xcrun simctl boot 'iPhone 14 Plus' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,id={UDID_iPhone_14_Plus}' \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_65_01_Home \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_65_02_History \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_65_03_Stats \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_65_04_Achievements \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_65_05_Settings

# ── iPhone 6.3" (iPhone 16 Pro) ───────────────────────────────
xcrun simctl boot 'iPhone 16 Pro' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,id={UDID_iPhone_16_Pro}' \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_63_01_Home \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_63_02_History \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_63_03_Stats \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_63_04_Achievements \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPhone_63_05_Settings

# ── iPad 13" (iPad Pro 13-inch M4) ────────────────────────────
xcrun simctl boot 'iPad Pro 13-inch (M4)' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,id={UDID_iPad_Pro_13_M4}' \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_13_01_Home \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_13_02_History \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_13_03_Stats \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_13_04_Achievements \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_13_05_Settings

# ── iPad 11" (iPad Pro 11-inch M4) ───────────────────────────
xcrun simctl boot 'iPad Pro 11-inch (M4)' 2>/dev/null || true
sleep 3

xcodebuild test -project {AppName}.xcodeproj -scheme {AppName} \
  -destination 'platform=iOS Simulator,id={UDID_iPad_Pro_11_M4}' \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_11_01_Home \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_11_02_History \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_11_03_Stats \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_11_04_Achievements \
  -only-testing:{AppName}UITests/ScreenshotTests/testiPad_11_05_Settings
```

#### Step 5: 验证截图内容不同（MD5）
```bash
# 查看截图文件
ls -la /tmp/iPhone_69_portrait_*.png
ls -la /tmp/iPhone_65_portrait_*.png
ls -la /tmp/iPhone_63_portrait_*.png
ls -la /tmp/iPad_13_portrait_*.png
ls -la /tmp/iPad_11_portrait_*.png

# MD5 验证 - 每张截图必须有不同哈希
md5 /tmp/iPhone_69_portrait_*.png
md5 /tmp/iPhone_65_portrait_*.png
md5 /tmp/iPhone_63_portrait_*.png
md5 /tmp/iPad_13_portrait_*.png
md5 /tmp/iPad_11_portrait_*.png

# 截图尺寸验证
sips -g pixelHeight -g pixelWidth /tmp/iPhone_69_portrait_01_Home.png
sips -g pixelHeight -g pixelWidth /tmp/iPhone_65_portrait_01_Home.png
sips -g pixelHeight -g pixelWidth /tmp/iPhone_63_portrait_01_Home.png
sips -g pixelHeight -g pixelWidth /tmp/iPad_13_portrait_01_Home.png
sips -g pixelHeight -g pixelWidth /tmp/iPad_11_portrait_01_Home.png
```

> ⚠️ **⚠️ 最重要的一步：MD5 通过 ≠ 截图正确！** MD5 只验证文件大小/压缩不同，**不验证内容是否真的是不同页面**。必须：
> 1. **肉眼检查**：用 `scp` 把截图下载到本地，肉眼确认每张是不同的页面
> 2. **常见错误**：所有截图都是首页 → Tab 切换代码失败（参考 §6.3 排查）
> 3. **不要跳过这一步**，否则提交后 App Store 会因截图不符合要求被拒

### 6.3 Tab 切换失败问题排查（所有截图都是首页）

**问题症状：** 所有截图都是首页，Tab 切换完全无效，测试却显示通过。

**根本原因（常见错误）：**

| 错误原因 | 说明 | 解决 |
|---------|------|------|
| `app.tabBar` 单数 | SwiftUI 用 `app.tabBars`（复数）不是 `app.tabBar`（单数）| 用 `app.tabBars` |
| iPad floating tab bar | iPad 上每个 Tab 创建多个重叠元素（`_UIFloatingTabBarItemCell` + `_UIFloatingTabBarItemView`），匹配到多个元素导致 tap 拒绝执行 | 用 `accessibilityIdentifier` + `NSPredicate` + `firstMatch` |
| App 未完全加载 | App 启动后 viewController 尚未完全加载，tap 事件被内部消费但没有触发 Tab 切换 | `Thread.sleep(2.0)` 等待 App 稳定 |
| accessibilityIdentifier 缺失 | 没有明确的 identifier，定位不稳定 | **App 源码必须给 TabBarItem 添加 `accessibilityIdentifier`** |

#### ❌ 常见错误写法

```swift
// 错误1：tabBar 单数（不存在这个成员）
app.tabBar.buttons.element(boundBy: 1).tap()

// 错误2：直接用按钮名称（iPad floating tab bar 有多个重叠元素）
app.buttons["Insights"].tap()
// 报错：Multiple matching elements found

// 错误3：坐标点击（tap 完全无效，MD5 验证所有截图相同）
xcrun simctl io booted tap 452 2539
```

#### ✅ 正确解决方案（两步：源码修改 + XCUITest 修改）

**第一步：App 源码必须给每个 TabBarItem 添加 `accessibilityIdentifier`**

```swift
// SwiftUI App 的 TabView（或 UIKit 的 UITabBarController）
TabView {
    HomeView()
        .tabItem {
            Label("Home", systemImage: "house")
        }
        .accessibilityIdentifier("tab_home")  // ✅ 必须添加

    HistoryView()
        .tabItem {
            Label("History", systemImage: "clock")
        }
        .accessibilityIdentifier("tab_history")  // ✅ 必须添加

    StatsView()
        .tabItem {
            Label("Stats", systemImage: "chart.bar")
        }
        .accessibilityIdentifier("tab_stats")  // ✅ 必须添加

    SettingsView()
        .tabItem {
            Label("Settings", systemImage: "gearshape")
        }
        .accessibilityIdentifier("tab_settings")  // ✅ 必须添加
}
```

**第二步：XCUITest 使用 NSPredicate + firstMatch 精确匹配**

```swift
override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["--uitesting"]
    app.launch()
    Thread.sleep(forTimeInterval: 2.0)  // ✅ 等待 App 完全稳定再操作
}

// ✅ 用 accessibilityIdentifier + predicate 精确匹配 firstMatch
func tapTab(identifier: String) {
    let predicate = NSPredicate(format: "identifier == %@", identifier)
    let button = app.buttons.matching(predicate).firstMatch

    if button.exists {
        button.tap()
        Thread.sleep(forTimeInterval: 2.0)  // 等待页面渲染
        return
    }
    print("WARNING: Could not find tab button: \(identifier)")
}

func testiPhone_69_02_History() {
    tapTab(identifier: "tab_history")  // ✅ 使用 accessibilityIdentifier
    capture("iPhone_69_portrait_02_History")
}
```

#### Debug Dump 排查代码

如果仍然失败，创建 Debug 测试 Dump 所有 UI 元素层级：

```swift
func testDebug() {
    print("=== UI Hierarchy Dump ===")
    print("Windows: \(app.windows.count)")
    print("TabBars: \(app.tabBars.count)")
    print("All buttons: \(app.buttons.count)")

    for i in 0..<min(app.buttons.count, 20) {
        let btn = app.buttons.element(boundBy: i)
        print("Button[\(i)]: identifier='\(btn.identifier)' label='\(btn.label)' exists=\(btn.exists)")
    }
}
```

#### 关键教训总结

1. **App 源码必须给 TabBarItem 添加 `accessibilityIdentifier`**：`tab_home`、`tab_history`、`tab_stats`、`tab_settings`
2. **XCUITest 必须在 `setup()` 里等 2 秒**：`Thread.sleep(forTimeInterval: 2.0)` 等 App 完全稳定
3. **iPad 有 floating tab bar 重复元素问题**：不能用 `app.tabBars.buttons["identifier"]` 直接访问，必须用 `NSPredicate` + `firstMatch`
4. **`app.tabBars`（复数）不是 `app.tabBar`（单数）**
5. **截图不要用 XCTAttachment**：直接 `screenshot().pngRepresentation` 写文件到 `/tmp/`
6. **每次测试前要 `xcrun simctl install`**：App 更新后必须重新安装
7. **用 UDID 管理多设备 boot 状态**：避免设备名冲突
8. **MD5 + 发送真实截图文件给 Human 肉眼确认**：确保每张截图真的是不同页面，不要跳过这一步

### 6.4 截图文件名规范

**核心要求：每个页面都要有截图，文件名必须包含页面名称。**

> ⚠️ **必须确保每张截图真的是不同页面！** 文件名包含页面名 ≠ 截图是那个页面。常见错误：文件名是 `02_History.png` 但实际截的还是首页，导致 App Store 审核被拒。**必须发送真实截图文件给 Human 肉眼确认**。

```
# 每个页面一张截图，文件名格式：序号_页面名称.png

# iPhone 6.9" (1320×2868) - iPhone 16 Pro Max
iPhone_69_portrait_01_Home.png
iPhone_69_portrait_02_History.png
iPhone_69_portrait_03_Stats.png
iPhone_69_portrait_04_Achievements.png
iPhone_69_portrait_05_Settings.png
...                                 # 有多少页面就放多少张

# iPhone 6.5" (1284×2778) - iPhone 14 Plus
iPhone_65_portrait_01_Home.png
iPhone_65_portrait_02_History.png
iPhone_65_portrait_03_Stats.png
iPhone_65_portrait_04_Achievements.png
iPhone_65_portrait_05_Settings.png
...

# iPhone 6.3" (1206×2622) - iPhone 16 Pro
iPhone_63_portrait_01_Home.png
iPhone_63_portrait_02_History.png
iPhone_63_portrait_03_Stats.png
iPhone_63_portrait_04_Achievements.png
iPhone_63_portrait_05_Settings.png
...

# iPad 13" (2048×2732) - iPad Pro 13-inch (M4)
iPad_13_portrait_01_Home.png
iPad_13_portrait_02_History.png
iPad_13_portrait_03_Stats.png
iPad_13_portrait_04_Achievements.png
iPad_13_portrait_05_Settings.png
...

# iPad 11" (1668×2388) - iPad Pro 11-inch (M4)
iPad_11_portrait_01_Home.png
iPad_11_portrait_02_History.png
iPad_11_portrait_03_Stats.png
iPad_11_portrait_04_Achievements.png
iPad_11_portrait_05_Settings.png
...
```

**文件夹结构：**
```
AppStoreScreenshots/
├── iPhone_69_1320x2868/        # 上传区域1：6.9"（1320×2868 iPhone 16 Pro Max 截）
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   ├── 04_Achievements.png
│   ├── 05_Settings.png
│   └── ...                    # 有多少页面就放多少张
├── iPhone_65_1284x2778/        # 上传区域2：6.5"（1284×2778 iPhone 14 Plus 截）
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   ├── 04_Achievements.png
│   ├── 05_Settings.png
│   └── ...
├── iPhone_63_1206x2622/        # 上传区域3：6.3"（1206×2622 iPhone 16 Pro 截）
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   ├── 04_Achievements.png
│   ├── 05_Settings.png
│   └── ...
├── iPad_13_2048x2732/          # 上传区域4：13"（2048×2732 iPad Pro 13" M4 截）
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   ├── 04_Achievements.png
│   ├── 05_Settings.png
│   └── ...
├── iPad_11_1668x2388/          # 上传区域5：11"（1668×2388 iPad Pro 11" M4 截）
│   ├── 01_Home.png
│   ├── 02_History.png
│   ├── 03_Stats.png
│   ├── 04_Achievements.png
│   ├── 05_Settings.png
│   └── ...
```

**命名规则：**
- 子目录名格式：`{设备类别}_{实际宽度}x{实际高度}`
- 文件名只含序号和页面名：`序号_页面名称.png`
- 同一上传区域的截图必须来自同一模拟器（相同分辨率）
- 有多少个 Tab 就生成多少张截图

> ⚠️ **分辨率必须与模拟器实际输出一致！** 示例中的分辨率（如 `1320x2868`）是 iPhone 16 Pro Max 的分辨率。如果使用其他模拟器，分辨率会不同。**上传 App Store 时必须使用正确的分辨率**，否则会被拒绝。下表是推荐模拟器与对应分辨率对照：

| 模拟器 | 输出分辨率 | 对应上传区域 |
|--------|-----------|-------------|
| iPhone 16 Pro Max | 1320×2868 | iPhone_69_1320x2868 |
| iPhone 14 Plus | 1284×2778 | iPhone_65_1284x2778 |
| iPhone 16 Pro | 1206×2622 | iPhone_63_1206x2622 |
| iPad Pro 13" (M4) | 2048×2732 | iPad_13_2048x2732 |
| iPad Pro 11" (M4) | 1668×2388 | iPad_11_1668x2388 |

### 6.5 下载截图

```bash
# 下载所有截图到本地（⚠️ 只下载本次测试生成的截图，不要下载 /tmp/ 下其他文件）
# 使用通配符限定只下载 App 相关的截图文件
sshpass -p 'idt52924irh' scp user291981@LA690.macincloud.com:/tmp/*.png ./

# 按分辨率创建子目录（根据你使用的模拟器调整分辨率）
mkdir -p Screenshots/iPhone_69_1320x2868
mkdir -p Screenshots/iPhone_65_1284x2778
mkdir -p Screenshots/iPhone_63_1206x2622
mkdir -p Screenshots/iPad_13_2048x2732
mkdir -p Screenshots/iPad_11_1668x2388

# 自动将截图按设备分类移动到对应子目录（并去除设备前缀，只保留序号_页面名）
for f in iPhone_69_portrait_*.png iPhone_65_portrait_*.png iPhone_63_portrait_*.png iPad_13_portrait_*.png iPad_11_portrait_*.png; do
    case "$f" in
        iPhone_69_portrait_*)   mv "$f" "Screenshots/iPhone_69_1320x2868/${f#iPhone_69_portrait_}" ;;
        iPhone_65_portrait_*)   mv "$f" "Screenshots/iPhone_65_1284x2778/${f#iPhone_65_portrait_}" ;;
        iPhone_63_portrait_*)   mv "$f" "Screenshots/iPhone_63_1206x2622/${f#iPhone_63_portrait_}" ;;
        iPad_13_portrait_*)     mv "$f" "Screenshots/iPad_13_2048x2732/${f#iPad_13_portrait_}" ;;
        iPad_11_portrait_*)      mv "$f" "Screenshots/iPad_11_1668x2388/${f#iPad_11_portrait_}" ;;
    esac
done
```

### 6.6 验证截图尺寸（完整脚本）

```python
import struct, os

# 子目录 → 期望分辨率（宽×高）
expected_sizes = {
    'iPhone_69_1320x2868': (1320, 2868),
    'iPhone_65_1284x2778': (1284, 2778),
    'iPhone_63_1206x2622': (1206, 2622),
    'iPad_13_2048x2732':    (2048, 2732),
    'iPad_11_1668x2388':    (1668, 2388),
}

errors = []
for subdir, (expected_w, expected_h) in expected_sizes.items():
    subdir_path = f'./Screenshots/{subdir}'
    if not os.path.isdir(subdir_path):
        errors.append(f'MISSING: {subdir}/ (请创建目录)')
        continue
    print(f'\n=== {subdir} (期望: {expected_w}x{expected_h}) ===')
    files = sorted([f for f in os.listdir(subdir_path) if f.endswith('.png')])
    for fname in files:
        path = f'{subdir_path}/{fname}'
        with open(path, 'rb') as fh:
            data = fh.read()
            if len(data) > 24:
                w = struct.unpack('>I', data[16:20])[0]
                h = struct.unpack('>I', data[20:24])[0]
                status = '✅' if (w, h) == (expected_w, expected_h) else f'❌ 期望{expected_w}x{expected_h}'
                print(f'  {fname}: {w}x{h} {status}')

if errors:
    print('\n=== 错误 ===')
    for e in errors:
        print(e)
```

## 第六阶段附加：功能测试、E2E 测试与录屏制作

### 6.7 功能测试（Unit Tests）

#### 目的
验证 App 核心业务逻辑正确性（数据模型、计算逻辑、状态管理等）。

#### 规则
- **必须覆盖**：所有 Model 的初始化、编解码（Codable）、业务计算
- **存放位置**：`{AppName}Tests/` 目录下
- **执行方式**：`xcodebuild test -project {AppName}.xcodeproj -scheme {AppName}Tests`

#### 示例结构
```swift
final class HabitModelTests: XCTestCase {

    func testHabitCodable() throws {
        let habit = Habit(name: "Reading", icon: "book.fill", target: 30)
        let data = try JSONEncoder().encode(habit)
        let decoded = try JSONDecoder().decode(Habit.self, from: data)
        XCTAssertEqual(habit.name, decoded.name)
        XCTAssertEqual(habit.icon, decoded.icon)
    }

    func testStreakCalculation() {
        let habit = Habit(name: "Running", icon: "figure.run", target: 60)
        // 模拟连续3天完成
        habit.completeToday()
        habit.completeToday()
        habit.completeToday()
        XCTAssertEqual(habit.currentStreak, 3)
    }
}
```

---

### 6.8 E2E 测试（UI Tests）

#### 目的
模拟真实用户操作流程，验证完整功能链路（注册 → 创建习惯 → 完成 → 查看统计）。

#### 存放位置
`{AppName}UITests/` 目录下，与截图测试共用一个文件或分文件存放。

#### 核心 E2E 场景（必须覆盖）

| 场景 | 操作步骤 | 验证点 |
|------|---------|-------|
| 创建习惯 | 首页 → "+" → 输入名称 → 选择图标 → 保存 | 习惯出现在列表 |
| 完成习惯 | 习惯卡片 → 点击完成按钮 | 连续天数增加 |
| 查看统计 | 底部 Tab "Stats" | 显示数据图表 |
| 删除习惯 | 左滑习惯 → 删除 → 确认 | 习惯从列表消失 |
| 通知权限 | 首次启动 → 允许通知 | 通知能够弹出 |

#### E2E 测试模板

> ⚠️ **必须先设置 accessibilityIdentifier**：E2E 测试依赖 UI 元素的可访问性标识符。开发阶段必须给关键 UI 元素设置 `accessibilityIdentifier("button_id")`，否则 UI 测试无法定位元素。

```swift
final class E2ETests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "--reset-state"]  // 可选：重置状态
        app.launch()
    }

    // ============================================================
    // ⚠️ 必须替换为实际 App 的 accessibilityIdentifier
    // 示例中的 "AddHabit"/"Save" 等仅为占位符
    // ============================================================

    func testCoreUserFlow() {
        // 1. 点击首页主要按钮（替换为实际 identifier）
        app.buttons["your_button_id"].firstMatch.tap()

        // 2. 输入文本（替换为实际 identifier）
        let textField = app.textFields["your_textfield_id"]
        textField.tap()
        textField.typeText("Test Input")

        // 3. 点击保存/确认按钮（替换为实际 identifier）
        app.buttons["save_button_id"].firstMatch.tap()

        // 4. 验证结果出现
        XCTAssertTrue(app.staticTexts["expected_text"].waitForExistence(timeout: 5))
    }
}
```

**通用核心 E2E 场景（根据实际 App 功能调整）：**

| 场景 | 操作步骤 | 验证点 |
|------|---------|-------|
| 核心操作流 | App 启动 → 完成主要功能 → 查看结果 | 功能链路完整，无崩溃 |
| 数据持久化 | 创建数据 → 重启 App → 数据仍存在 | 数据正确保存 |
| 状态重置 | 修改状态 → 验证变化 → 重置 → 验证恢复 | 状态管理正确 |
| 通知权限 | 首次提示 → 授权/拒绝 → 验证行为 | 权限处理正确 |

---

### 6.9 录屏制作（🤖 AI Agent 负责）

#### 问题
MacinCloud 的 VNC 桌面**没有录屏权限**，无法直接录制 App 预览视频。

#### 解决方案
通过 XCUITest 将截图拼接为视频（使用 `AVAssetWriter` 或 Python PIL + ffmpeg）。

#### Step 1：在 XCUITest 中连续截图
```swift
func testAppPreviewRecording() {
    let outputDir = "/tmp/preview_frames/"
    FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

    // 场景1：首页 Tab 切换（⚠️ 替换为实际 accessibilityIdentifier）
    let scenes = ["Home", "Settings"]
    for (index, scene) in scenes.enumerated() {
        capture("\(outputDir)scene_\(index)_01.png")
        usleep(300000)  // 300ms 停留
    }

    // 场景2：主要操作流程（⚠️ 替换为实际 accessibilityIdentifier）
    app.buttons["main_action_id"].firstMatch.tap()
    usleep(500000)
    capture("\(outputDir)scene_\(scenes.count)_01.png")
    app.textFields["input_field_id"].typeText("Sample Input")
    usleep(300000)
    capture("\(outputDir)scene_\(scenes.count)_02.png")
    app.buttons["confirm_button_id"].firstMatch.tap()
    usleep(500000)
    capture("\(outputDir)scene_\(scenes.count)_03.png")
}
```

#### Step 2：下载截图到本地
```bash
sshpass -p 'idt52924irh' scp -r user291981@LA690.macincloud.com:/tmp/preview_frames/ ./
```

#### Step 3：用 Python + ffmpeg 拼接为视频
```python
import subprocess
import os
from PIL import Image

# 帧目录
frames_dir = "./preview_frames/"
output_video = "./AppPreview.mp4"

# 获取所有帧文件并排序
frame_files = sorted([f for f in os.listdir(frames_dir) if f.endswith('.png')])

# 使用 ffmpeg 将图片序列转换为视频
# 格式：fps=2，每帧停留 500ms
ffmpeg_cmd = [
    'ffmpeg', '-y',
    '-framerate', '2',  # 2 fps
    '-i', f'{frames_dir}scene_%d_01.png',  # 输入 pattern
    '-c:v', 'libx264',
    '-pix_fmt', 'yuv420p',
    '-crf', '23',  # 质量因子
    '-preset', 'medium',
    output_video
]

result = subprocess.run(ffmpeg_cmd, capture_output=True, text=True)
if result.returncode == 0:
    print(f"✅ 视频已生成: {output_video}")
else:
    print(f"❌ ffmpeg 错误: {result.stderr}")
```

#### Step 4：或在 MacinCloud 本地直接用 AVAssetWriter 生成视频
```swift
import AVFoundation
import CoreImage

func generateVideoFromFrames(framePaths: [String], outputURL: URL, fps: Int = 2) {
    let writer = try! AVAssetWriter(outputURL: outputURL, fileType: .mp4)
    let settings: [String: Any] = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: 1320,
        AVVideoHeightKey: 2868
    ]
    let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
    writer.add(writerInput)

    writer.startWriting()
    writer.startSession(atSourceTime: .zero)

    let frameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))
    for (index, path) in framePaths.enumerated() {
        let image = UIImage(contentsOfFile: path)!
        let buffer = pixelBuffer(from: image)!
        let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(index))

        writerInput.append(buffer, withPresentationTime: presentationTime)
    }

    writer.finishWriting()
}
```

#### 录屏规格要求（App Store Connect）

| 字段 | 要求 |
|------|------|
| 格式 | MP4 / MOV |
| 最大时长 | 30 秒 |
| 最大文件大小 | 100 MB |
| 分辨率 | 必须与截图分辨率一致（1320×2868 等） |
| 编码 | H.264 |
| 音频 | **不需要**（App Preview 默不带音频也可）|

> ⚠️ **重要**：如果 App Store 要求必须带音频，需在 ffmpeg 命令中混入背景音乐：
> ```bash
> ffmpeg -y -framerate 2 -i scene_%d_01.png -i background_music.mp3 -c:v libx264 -shortest output.mp4
> ```

---

### 6.10 测试执行

#### 在 MacinCloud 执行测试
```bash
# SSH 到 MacinCloud 执行
sshpass -p 'idt52924irh' ssh user291981@LA690.macincloud.com "\
  cd Desktop/ios-{AppName} && \
  xcodebuild test -project {AppName}.xcodeproj \
    -scheme {AppName}Tests \
    -destination 'platform=iOS Simulator,id={UDID}'"

# UI Tests（含 E2E）
sshpass -p 'idt52924irh' ssh user291981@LA690.macincloud.com "\
  cd Desktop/ios-{AppName} && \
  xcodebuild test -project {AppName}.xcodeproj \
    -scheme {AppName} \
    -destination 'platform=iOS Simulator,id={UDID}' \
    -only-testing:{AppName}UITests/E2ETests"
```

> ⚠️ **测试在 MacinCloud 上执行**。但测试代码必须先经过 Claude Code **审查 + 修复**（AI Agent 服务器），确保测试逻辑正确、coverage 足够后再推送到 MacinCloud 执行。
>
> ⚠️ **必须验证项**：每次提交前确保 `xcodebuild test` 全部通过，否则 App Store 审核可能因功能缺陷被拒。


## 第七阶段：Widget 数据共享 / Beta 测试

> ⚠️ **Widget 为可选功能**。如果 App 不需要 Widget（如噪音检测、饮水追踪等），跳过此阶段。

### 7.1 App Groups 配置

**主 App 写入：**
```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.ggsheng.AppName")
sharedDefaults?.set(encodedData, forKey: "habits")
sharedDefaults?.synchronize()
```

**Widget 读取：**
```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.ggsheng.AppName")
let data = sharedDefaults?.data(forKey: "habits")
```

**⚠️ entitlements 必须包含 App Group：**
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.ggsheng.AppName</string>
</array>
```

---

### 7.2 Beta 测试（TestFlight）

**提交审核前必须进行 Beta 测试**：
1. Archive 打包后，通过 Xcode Organizer 上传 TestFlight
2. 邀请内部测试员（至少 1 名）进行功能验证
3. 修复 Beta 测试发现的 Bug
4. Beta 测试通过后才能提交 App Store 审核

**TestFlight 要求**：
- 必须有至少 1 名内部测试员
- Beta 测试版本号必须与提交审核版本一致
- 修复 Bug 后重新上传 TestFlight，审核前再提交

---

## 第八阶段：App Store Connect 上传

### 8.1 Archive 操作（VNC 桌面）

1. 通过 VNC 连接 MacinCloud 桌面
2. Xcode 打开 `{AppName}.xcodeproj`
3. 顶部 scheme 选择 `{AppName}`
4. **Product → Archive**（通过菜单操作，Xcode 无默认快捷键）
5. Archive 完成 → **Window → Organizer** 打开
6. 选中 archive → **Distribute → App Store Connect → Sign and Upload**
7. Team 选择 **ZhiFeng Sun (9L6N2ZF26B)**
8. 等待上传完成 → **Validate App** 验证

### 8.2 App Store Connect 填写

| 字段 | 填写内容 |
|------|---------|
| App Name | `{AppStoreName}`（App Store 确认名称）|
| Bundle ID | `com.ggsheng.{AppName}` |
| Category | **见下方类别选择指南** |
| Price | Free |
| Privacy Policy URL | `https://lauer3912.github.io/ios-{AppName}/docs/PrivacyPolicy.html` |

#### App Store 主类别选择指南

根据 App 核心功能选择最符合的主类别：

| App 类型 | 推荐主类别 | 说明 |
|---------|-----------|------|
| 番茄钟/专注计时 | **Productivity** | 效率工具 |
| 习惯追踪/待办事项 | **Productivity** | 效率工具 |
| 睡眠追踪/健康管理 | **Health & Fitness** | 健康与健身 |
| 屏幕时间管理 | **Productivity** 或 **Utilities** | 效率/工具类 |
| 财务记账/预算 | **Finance** | 财务 |
| 膳食/营养追踪 | **Health & Fitness** | 健康与健身 |
| 步数/运动追踪 | **Health & Fitness** | 健康与健身 |
| 瑜伽/拉伸/健身 | **Health & Fitness** | 健康与健身 |
| 音乐播放/白噪音 | **Productivity** 或 **Music** | 效率/音乐 |
| 噪音检测/报警 | **Utilities** | 工具类 |
| 饮水追踪 | **Health & Fitness** | 健康与健身 |
| 抉择器/随机选择 | **Utilities** | 工具类 |
| AI 日记/情绪追踪 | **Health & Fitness** 或 **Lifestyle** | 健康/生活方式 |
| AI 日程/自动驾驶 | **Productivity** | 效率工具 |
| AI 营养/膳食追踪 | **Health & Fitness** | 健康与健身 |
| AI 睡眠追踪/改善 | **Health & Fitness** | 健康与健身 |
| 游戏类 | **Games** | 游戏 |

> ⚠️ **类别选择影响 App Store 搜索曝光率**。选错类别会导致目标用户搜不到你的 App。

### 8.3 App 隐私配置

> ⚠️ **【强制】App 隐私配置必须根据 App 实际功能来配置**，不是全部选"否"，也不是全部选"是"。

#### 配置原则

| 原则 | 说明 |
|------|------|
| **根据实际功能选择** | 如果 App 收集某种数据，该选项必须选"是"；如果不收集，选"否" |
| **健康类 App** | 如果有健康追踪功能，"健康/健身"必须选"是" |
| **位置类 App** | 如果有定位功能，"位置"必须选"是" |
| **广告 SDK** | 如果集成广告 SDK，"广告"必须选"是" |
| **分析 SDK** | 如果集成统计/分析 SDK，"性能数据"必须选"是" |
| **离线 App（无网络）** | 所有网络相关选项选"否" |

#### 常见 App 类型隐私配置表

| App 类型 | 健康/健身 | 位置 | 联系信息 | 标识用户 | 浏览历史 | 购买行为 | 崩溃日志 | 性能数据 | 广告 |
|---------|---------|------|---------|---------|---------|---------|---------|---------|------|
| **番茄钟/专注计时** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **习惯追踪** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **屏幕时间管理** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **睡眠追踪** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **膳食/营养追踪** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **步数/运动追踪** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **地图/导航类** | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **社交类** | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **财务记账（内购）** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **含广告的免费 App** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **含统计 SDK** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |

> ⚠️ **如果 App 隐私配置与实际功能不符**，Apple 审核会拒绝并要求修改。

#### 配置步骤

1. 在 App Store Connect 的 **App 隐私** 页面配置
2. 根据 App 实际功能选择"是"或"否"
3. 如果选"是"，必须在隐私政策中说明该数据的处理方式
4. **配置完成后必须点击"存储"**

### 8.4 隐私政策要求

> ⚠️ 欧美市场对隐私政策极为重视，Apple 审核会检查隐私政策内容。

**隐私政策必须包含**：
1. 数据收集：App 收集哪些数据
2. 数据使用：数据如何被使用
3. 数据存储：数据存储在哪里，是否加密
4. 用户权利：用户如何删除数据
5. 联系方式：开发者联系方式
6. 儿童隐私：是否面向 13 岁以下儿童
7. 第三方服务：如果有广告或分析，说明

### 8.5 AI 技术应用要求

> ⚠️ **涉及 AI/机器学习技术的 App，Apple 有额外的审核要求，必须提前准备**

#### AI 功能分类与解决方案

| AI 功能类型 | 示例场景 | Apple 审核重点 | 解决方案 |
|------------|---------|---------------|---------|
| **设备端 ML（推荐）** | 本地情绪识别、语音转文字、本地推荐 | 只需声明数据类型 | 使用 CoreML/MLCompute，**无需额外审核** |
| **Apple AI Framework** | Apple Intelligence 功能 | 必须使用官方 API | 仅用 Apple 官方框架（如 Image Playground） |
| **第三方 AI API** | OpenAI GPT、Claude 等云端 AI | 隐私政策必须明确说明 | App 隐私选"否"，隐私政策说明云端处理 |
| **AI 生成内容** | AI 生成图片/文字/语音 | 需说明内容来源 | 必须有内容审核机制，禁止生成违规内容 |
| **AI 健康建议** | AI 饮食建议、睡眠建议 | 健康类 App 额外审核 | 不能替代专业医疗建议，需免责声明 |

#### 隐私政策 AI 相关条款模板

如果 App 使用云端 AI（OpenAI/Claude 等），隐私政策必须包含：

```html
<h2>6. AI Services</h2>
<p>We use third-party AI services (OpenAI/Claude API) to power [feature name]. 
These services process your data according to their privacy policies. 
We do not store your data on external AI servers longer than necessary to provide the service.</p>

<h2>6.1 Data Processing</h2>
<p>When you use [AI feature], your [data type] is sent to [AI provider] for processing. 
You can disable this feature in Settings at any time.</p>
```

#### App Store Connect AI 相关选项

在 App Store Connect 填写时，以下选项需要正确配置：

| 选项 | 正确配置 |
|------|---------|
| AI 功能说明 | 在审核备注中说明 AI 功能用途和处理方式 |
| 第三方 AI 服务 | 如使用 OpenAI，需在 App 隐私声明 |
| 健康建议免责声明 | AI 健康类功能必须有 "Not a medical device" 免责声明 |
| 儿童年龄分级 | AI 功能面向儿童需额外审核 |

#### Apple 审核常见 AI 相关拒绝原因

| 拒绝原因 | 解决方案 |
|---------|---------|
| "App uses AI to make medical decisions" | 添加免责声明："This is not a medical device" |
| "AI feature not clearly documented" | 在 App 描述和隐私政策明确说明 AI 处理流程 |
| "Third-party AI API not disclosed" | App 隐私必须声明使用的第三方 AI 服务 |
| "AI-generated content without moderation" | 实现内容审核机制，或限制 AI 生成内容类型 |

#### 最佳实践

1. **优先使用设备端 ML**（CoreML/MLCompute），无需额外审核
2. **隐私政策必须说明 AI 数据处理流程**
3. **健康类 AI 必须有免责声明**
4. **AI 生成内容必须有审核机制**
5. **不要夸大 AI 能力**，Apple 审核会验证功能真实性

**隐私政策模板结构**（`ios-{AppName}/Docs/PrivacyPolicy.html`）：
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Privacy Policy</title>
</head>
<body>
    <h1>Privacy Policy</h1>
    <p>Last updated: [Date]</p>
    
    <h2>1. Information We Collect</h2>
    <p>[Description]</p>
    
    <h2>2. How We Use Your Information</h2>
    <p>[Description]</p>
    
    <h2>3. Data Storage and Security</h2>
    <p>All data is stored locally on your device. We do not transmit your personal data to any third parties.</p>
    
    <h2>4. Your Rights</h2>
    <p>You can delete all your data by uninstalling the app.</p>
    
    <h2>5. Contact Us</h2>
    <p>For any questions, contact: [Email]</p>
</body>
</html>
```

**规则**：
- 必须使用英文
- 必须放在 GitHub Pages：`https://lauer3912.github.io/ios-{AppName}/docs/PrivacyPolicy.html`
- URL 必须与 App Store Connect 填写的隐私政策 URL 完全一致
- 禁止在隐私政策中包含任何第三方追踪或广告

---

## 常见错误速查

| 错误信息 | 原因 | 解决 |
|---------|------|------|
| **不读 SOP 文档就用旧经验操作** | AI Agent 没有遵循最新 SOP | **必须先读取 SOP-iOS-AppStore-Launch.md**，以本文档为准 |
| **MacinCloud 桌面乱放文件** | 截图/临时文件留在桌面 | 所有文件必须 scp 到 AI Agent 本地，桌面只留项目文件夹 |
| `Use the Signing & Capabilities editor` | signing 配置错误 | 确认 Release CODE_SIGNING_ALLOWED=YES |
| `Assign a team to the targets` | base level 没有 TEAM | 加 `DEVELOPMENT_TEAM: 9L6N2ZF26B` |
| `Invalid large app icon...alpha` | 1024 图标有透明通道 | 用 PIL 转为 RGB 模式: `Image.open(f).convert('RGB').save(f)` |
| `Embedded binary not signed` | Widget Release 没开签名 | Widget configs Release 加 YES |
| `SF Symbols 显示为文字/方块` | 用 `Text(icon)` 而非 `Image(systemName:)` 渲染 SF Symbols | 将所有 `Text(icon)` 改为 `Image(systemName: icon)` |
| `App Record Creation failed: name in use` | App Store 名称被占 | 换名称或删旧 Record 重建 |
| `errSecInternalComponent` | keychain 访问被拒 | **用 VNC 桌面操作 Sign and Upload**（SSH signing 会失败）|

---

## 代码质量常见错误（SF Symbols / SwiftUI 图标渲染）

### 问题描述

SF Symbols（如 `flame.fill`、`star.fill`、`checkmark.seal.fill`）必须用 `Image(systemName:)` 渲染，**不能**用 `Text()`。使用 `Text(someIcon)` 会导致图标显示为字面文本（如显示 "flag.fill" 文字）或方块。

**错误示例：**
```swift
Text(habit.icon)     // ❌ 图标不显示，显示 "figure.run" 这样的字符串
Text(category.icon)  // ❌ 同上
Text(achievement.icon) // ❌ 同上
```

**正确写法：**
```swift
Image(systemName: habit.icon)     // ✅ 正确渲染 SF Symbol
Image(systemName: category.icon) // ✅ 正确渲染 SF Symbol
Image(systemName: achievement.icon) // ✅ 正确渲染 SF Symbol
```

### 受影响场景

| 场景 | 错误写法 | 正确写法 |
|------|---------|---------|
| Habit 列表/卡片图标 | `Text(habit.icon)` | `Image(systemName: habit.icon)` |
| Category 图标 | `Text(category.icon)` | `Image(systemName: category.icon)` |
| Achievement 卡片图标 | `Text(achievement.icon)` | `Image(systemName: achievement.icon)` |
| Mood 表情 | `Text(mood.icon)` | `Image(systemName: mood.icon)` |
| Filter chip 文字（拼接场景）| `"\(habit.icon) \(habit.name)"` | `habit.name` 单独显示，避免拼接无法渲染的 SF Symbol |
| 统计页 habit 图标 | `Text(habit.icon)` | `Image(systemName: habit.icon)` |
| 模板图标 | `Text(template.icon)` | `Image(systemName: template.icon)` |

### 验证方法

1. **本地验证：**
   ```bash
   grep -rn "Text(.*\.icon)" ios-{AppName}/ --include="*.swift"
   ```
   如果有任何输出，说明存在错误写法。

2. **真机/模拟器预览：** 预览时图标显示为字面字符串（如 `"flame.fill"`）或方块，证明使用了 `Text()`。

### 修复后必须操作

1. 修复所有 `Text(xxx.icon)` → `Image(systemName: xxx.icon)`
2. `git add -A && git commit -m "Fix: Replace Text(icon) with Image(systemName: icon) for SF Symbols" && git push`
3. MacinCloud `git pull origin main && ~/tools/xcodegen/bin/xcodegen generate`
4. 重新 Archive + Upload

---

## 附录：Display Name 修改步骤

> **⚠️ 占位符说明：**
> - `{AppName}` = 本地项目业务名（如 "FocusTimer"）
> - `{DesiredDisplayName}` = 想在手机上显示的新名称（如 "ZenFocus"）
> - `{RepoFolder}` = 本地仓库文件夹名

### A.1 三层名称体系

| 层级 | 位置 | 能否改 | 说明 |
|------|------|--------|------|
| App Store 名称 | App Store Connect 填写 | ✅ 随时改 | Human 在网页上填写 |
| Bundle ID | **打包进二进制 + Apple Developer Portal** | ❌ 上传后不能改 | 👨 Human 必须先在 Apple Developer Portal 创建 Bundle ID，再在 App Store Connect 选择 |
| Display Name | Info.plist / PRODUCT_NAME | ✅ 可以改 | 只改手机显示名 |

---

### A.2 改名：只改 Display Name

**适用场景**：App Store 名称被占用，或任何只想改手机显示名的场景。

**原理**：只改用户手机上看到的 Display Name，Bundle ID 和 App Store 名称不变。

**需要修改的文件：**

#### 文件 1：`project.yml`

```yaml
targets:
  {AppName}:
    settings:
      base:
        PRODUCT_NAME: {DesiredDisplayName}
```

#### 文件 2：`Info.plist`

```xml
<key>CFBundleDisplayName</key>
<string>{DesiredDisplayName}</string>
```

**执行步骤：**

```bash
# 1. 本地修改
git add -A && git commit -m "Update Display Name to {DesiredDisplayName}" && git push

# 2. MacinCloud
cd ~/Desktop/ios-{AppName}
git pull origin main
~/tools/xcodegen/bin/xcodegen generate
rm -rf ~/Library/Developer/Xcode/DerivedData/*
xcodebuild build -project {AppName}.xcodeproj \
  -target {AppName} -configuration Debug \
  -destination 'platform=iOS Simulator,id={UDID}'
```

---

### A.3 AI 功能名称后缀策略

**适用场景**：App 功能涉及 AI（如 AI 日记、AI 睡眠追踪等），但 App Store 原始名称不带 AI，且名称未被占用。

**策略**：在 Display Name 后加 "AI" 后缀，既能区分名称，又能突出 AI 功能。

**示例**：

| 原始名称 | 名称可用性 | 最终 Display Name |
|---------|-----------|------------------|
| {AppName} | 名称被占用 | {AppName}（不变）|
| {AppName} | 名称未被占用，但功能有 AI | {AppName} AI |

**判断流程**：

```
App 功能涉及 AI？
    ↓ 是
App Store 名称未被占用？
    ↓ 是
在 App Store Connect 填原名，在本地 Display Name 加 "AI" 后缀
```

**执行步骤**：

1. **App Store Connect**：填原始名称（如 `{AppName}`）
2. **本地 Display Name**：设为 `{AppName} AI`
3. **隐私政策**：明确说明使用了 AI 技术（见 §8.5）

**好处**：
- 名称未被占用时，无需换名直接使用
- "AI" 后缀让用户一眼看出 App 支持 AI 功能
- 避免因名称重复导致的审核被拒

---

### A.4 占位符汇总

| 占位符 | 含义 | 举例 |
|--------|------|------|
| `{AppName}` | 本地项目业务名 | FocusTimer |
| `{DesiredDisplayName}` | 想在手机桌面显示的名字 | ZenFocus |
| `{RepoFolder}` | 本地仓库文件夹名 | ios-FocusTimer |
| `{UDID}` | 模拟器 UDID | 59030A31-... |
| `{UDID_iPhone_16_Pro_Max}` | iPhone 16 Pro Max 模拟器 UDID | 需用 `xcrun simctl list devices booted` 查询 |
| `{UDID_iPhone_14_Plus}` | iPhone 14 Plus 模拟器 UDID | 同上 |
| `{UDID_iPhone_16_Pro}` | iPhone 16 Pro 模拟器 UDID | 同上 |
| `{UDID_iPad_Pro_13_M4}` | iPad Pro 13" (M4) 模拟器 UDID | 同上 |
| `{UDID_iPad_Pro_11_M4}` | iPad Pro 11" (M4) 模拟器 UDID | 同上 |

> **获取 UDID 方法**：在 MacinCloud 上运行 `xcrun simctl list devices booted`，找到对应模拟器的 UUID 列。

---

## 第九阶段：App Store Connect 填写与提交审核

### 9.1 提交审核前的准备工作

**所有文本必须英文，包括：**
- App 描述
- 关键词
- 隐私政策
- Info.plist 中的所有 Usage Description（权限描述）
- 截图

**禁用词汇（App Store 自动拒绝）：**
- ❌ `Pomodoro`（番茄工作法注册商标）→ 用 `focus timer` / `focus technique` 代替
- ❌ `heatmap` → 用 `streak calendar` / `monthly calendar` 代替
- ❌ emoji 表情符号（App Store 描述不支持 emoji）

**所有描述用纯 ASCII 字符**，破折号 `--` 代替 emoji bullet

### 9.2 App Store Connect 填写清单

> 以中文版 App Store Connect 为例

#### 第四步：创建 App（或选择已有）

> ⚠️ **【强制】此步骤必须由 👨 Human 人类操作**，AI Agent 无法创建 App

**操作步骤**：

1. 👨 Human 打开浏览器，登录 https://appstoreconnect.apple.com
2. 👨 Human 点击 **"我的 App"** → **"+"** → **"新建 App"**
3. 👨 Human 在下拉列表中**手动选择正确的 Bundle ID**（必须是 `com.ggsheng.{AppName}`）

| 字段 | 填写内容 |
|------|---------|
| 平台 | ✅ **iOS** |
| 名称 | `{AppName}`（App Store 显示名称）|
| 主语言 | **English** |
| Bundle ID | 👨 Human **必须手动选择** `com.ggsheng.{AppName}` |
| SKU | `{AppName}-100`（随便填，唯一即可）|

> ⚠️ **如果 Bundle ID 下拉为空**：说明 Bundle ID 尚未在 Apple Developer Portal 创建。👨 Human 必须先登录 https://developer.apple.com 创建 Bundle ID，再返回 App Store Connect。

**Bundle ID 创建步骤（Apple Developer Portal）**：
1. 👨 Human 登录 https://developer.apple.com
2. 👨 Human 进入 **"Certificates, Identifiers & Profiles"**
3. 👨 Human 点击 **"Identifiers"** → **"+"**
4. 👨 Human 选择 **"App IDs"** → **"App"**
5. 👨 Human 填写 Description 和 Bundle ID（格式：`com.ggsheng.{AppName}`）
6. 👨 Human 选择 App Services（如需要）
7. 👨 Human 点击 **"Continue"** → **"Register"**

#### 第五步：App 隐私（左菜单）

> ⚠️ **根据 App 实际功能配置，不是全部选"否"**

**配置方法**：根据 §8.3 的配置表，选择"是"或"否"

| 问题 | 答案（示例）|
|------|------------|
| 健康与健身 | **根据 App 实际功能**：睡眠追踪/膳食追踪 → **是**，其他 → **否** |
| 位置 | **根据 App 实际功能**：地图类 → **是**，其他 → **否** |
| 联系信息 | **根据 App 实际功能**：社交类 → **是**，其他 → **否** |
| 标识符 | **根据 App 实际功能**：有登录功能 → **是**，其他 → **否** |
| 浏览历史与搜索 | 通常 **否** |
| 购买行为 | **根据 App 实际功能**：有内购 → **是**，其他 → **否** |
| 崩溃日志 | 通常 **否** |
| 性能数据 | **根据 App 实际功能**：有统计 SDK → **是**，其他 → **否** |
| 广告 | **根据 App 实际功能**：有广告 SDK → **是**，其他 → **否** |

滚动到底部：
- **隐私权政策网址**：填入 GitHub Pages URL，例如：
  ```
  https://lauer3912.github.io/ios-{AppName}/docs/PrivacyPolicy.html
  ```

⚠️ **必须点"存储"按钮**

#### 第六步：定价与范围（左菜单）

| 字段 | 内容 |
|------|------|
| 价格 | 选具体金额（如 $9.99）或 Free |
| 可用性 | **全部地区** |

⚠️ **必须点"存储"按钮**

#### 第七步：App Store 信息（左菜单）

逐项填写：

**1. 名称**
```
{AppName}
```

**2. 副标题** (最多30个字符)
```
{Focus Training · Deep Work}
```

**3. 隐私政策网址**（已填，跳过）

**4. 描述**（description，最多）
```
100+ features -- the most complete focus app ever made.

{AppName} takes the classic focus technique to a whole new level. AI-adaptive smarts, immersive ambient sounds, detailed progress tracking, and a design you'll actually love -- all to help you rebuild your focus.

Core Features

- AI-Adaptive Focus -- Smart work/rest duration adjustment that optimizes in real-time.
- 12 Immersive Ambient Sounds -- Rain, forest, ocean waves, coffee shop, white noise -- all synthesized locally.
- 100+ Achievement Badges -- From "First Focus" to "100-Hour Master."
- Focus Streak Calendar -- Monthly calendar showing your daily focus journey.
- Deep Data Insights -- Daily/weekly/monthly focus reports.
- Rolling Focus Mode -- Continuous focus mode with seamless work sessions.
- Daily Challenges -- A unique micro focus challenge every day.

Why {AppName}?

- Beautifully Designed -- Not another dark-themed productivity app.
- Offline First -- No network required. All features run locally.
- Ad-Free -- No annoying ads ever.

${price} one-time purchase -- lifetime access, no subscription

Start rebuilding your focus today.
```

**5. 关键词** (最多100个字符)
```
focus timer, productivity, focus, concentration, study, work
```

**6. 促销文本**（可选，不填也可，最多170个字符）
```
{AppName} -- AI-adaptive focus timer with ambient sounds, streak tracking & insights. ${price} one-time. Try today.
```

**7. 营销网址**（可选，留空）

**8. 年龄分级**
- 点 **"设置年龄分级"** → 选择 **"4+"**

**9. 类别**
- 主类别：**根据 App 类型选择（参考 §8.2 类别选择指南）**
- 次类别：（不选）

⚠️ **必须点"存储"按钮**

#### 第八步：App Store 截图（左菜单）

**必需尺寸（5 个上传区域，每个最多 10 张截图）：**

| 上传区域 | 接受分辨率（px）| 方向 |
|---------|----------------|------|
| iPhone 6.9"（合并 6.5"/6.7"/6.9"）| 1260×2736, 2736×1260, 1320×2868, 2868×1320, 1290×2796, 2796×1290 | 竖 / 横 |
| iPhone 6.5" | 1242×2688, 2688×1242, 1284×2778, 2778×1284 | 竖 / 横 |
| iPhone 6.3" | 1206×2622, 2622×1206, 1179×2556, 2556×1179 | 竖 / 横 |
| iPad 13" | 2064×2752, 2752×2064, 2048×2732, 2732×2048 | 竖 / 横 |
| iPad 11" | 1668×2420, 2420×1668, 1668×2388, 2388×1668, 1640×2360, 2360×1640, 2266×1488, 1488×2266 | 竖 / 横 |

**操作：** 点击每个尺寸下方的 **"+"** 按钮，上传截图文件

#### App Preview（视频，可选）

| 字段 | 要求 |
|------|------|
| 最大时长 | 30 秒 |
| 最大文件大小 | 100 MB |
| 格式 | MP4 / MOV |
| 分辨率 | 必须与截图分辨率一致 |
| 语言 | 视频如果有口播，必须使用英文 |

> ⚠️ App Preview 不是强制要求，但如果提供可以提升转化率。视频必须展示 App 真实操作，不能使用动画演示。

#### 多语言支持

**规则**：
- App UI 必须使用英文（面向欧美市场）
- 所有用户可见文本必须使用英文字符集
- 禁止在 UI 中出现中文、韩文、日文等其他文字
- 隐私政策语言：根据上架地区选择（欧美上架用英文）

**验证方法**：
```bash
# 检查是否有非英文字符
grep -rn "[一-鿿]" ios-{AppName}/ --include="*.swift"  # 中文
grep -rn "[가-힯]" ios-{AppName}/ --include="*.swift"  # 韩文
grep -rn "[぀-ゟ゠-ヿ]" ios-{AppName}/ --include="*.swift"  # 日文
```

#### 第九步：Build（左菜单）

选择最新上传的 Build（通常在最上面）

#### 第十步：审核信息（左菜单）

| 字段 | 填写内容 |
|------|---------|
| 登录信息 | **根据 App 实际情况**： |
| | - 不需要登录的 App：选 **否** |
| | - 需要登录的 App：选 **是**，并提供测试账号和密码 |
| 备注 | 如果需要登录审核，必须填写： |

**需要登录的 App 必须提供：**

| 字段 | 说明 |
|------|------|
| **测试账号** | 用于登录 App Store 审核人员测试 |
| **密码** | 对应测试账号的密码 |
| **Demo 数据说明** | 说明账号里包含哪些演示数据（如：习惯列表、历史记录等） |

> ⚠️ **【强制】如果 App 需要登录才能使用完整功能，必须在审核信息中提供测试账号**，否则 Apple 审核人员无法审核付费功能或会员内容。

**测试账号要求**：
1. 必须是真实可用的账号
2. 密码不能包含特殊字符（避免审核页面输入问题）
3. 建议密码格式：`Test123456`
4. 账号里建议预置 **Demo 数据**，方便审核人员快速验证功能

**Demo 数据准备**：

| App 类型 | Demo 数据内容 |
|---------|--------------|
| 习惯追踪 | 至少 3-5 个习惯，包含已完成的和未完成的 |
| 番茄钟 | 有历史记录，包含今天和过去几天的数据 |
| 财务记账 | 有收入/支出记录，分类完整 |
| 睡眠追踪 | 有最近 7 天的睡眠数据 |
| 会员/订阅 | 包含一个已激活会员的账号 |

**Demo 数据存放位置**：
```swift
// App 首次启动时检测，如果 UserDefaults 为空，自动插入 Demo 数据
if UserDefaults.standard.array(forKey: "habits")?.isEmpty ?? true {
    insertDemoData()  // 插入预设的演示数据
}
```

#### 第十一步：出口合规（左菜单）

> **如果 Info.plist 已配置 `ITSAppUsesNonExemptEncryption = NO`，此步骤会自动跳过。**

如果仍出现，答：
- 问：你的 App 是否使用了加密？
- 答：**否**

### 9.3 提交审核

确认所有必填项后：
1. 点左侧顶部或底部的 **"添加至审核"** / **"提交以供审核"**
2. 确认信息 → 点 **"提交"**

### 9.4 常见报错

| 错误信息 | 原因 | 解决 |
|---------|------|------|
| "必须提供 App 隐私信息" | App 隐私未点"存储" | 👨 Human 返回 App 隐私页面，点击"存储" |
| "必须选择主要类别" | 类别未选 | 👨 Human 在 App Store 信息 → 类别 → 根据 App 类型选择 |
| "名称已被使用" | App Store 名称被占 | 换名称，或用 §A.2 Display Name 策略 |
| "截图尺寸不对" | 尺寸不符合要求 | 用对应尺寸的模拟器重新实截，不得 resize |
| "描述包含禁止词汇" | 用了 Pomodoro 等词 | 移除并替换为替代词 |
| **Bundle ID 下拉为空** | Bundle ID 尚未在 Apple Developer 创建 | 👨 Human 先在 Apple Developer Portal 创建 Bundle ID |

### 9.5 提交后

- 状态变为 **"正在等待审核"** / **"Waiting for Review"**
- 首次审核通常 **7-14 个工作日**
- 期间可在 App Store Connect 查看状态变化
- 审核被拒：邮件通知具体原因，按原因修改后重新提交

> **实际案例参考（JustZenGo）：** App Store 名称 JustZenGo / Bundle ID com.ggsheng.JustZenGo / 定价 $9.99 / 隐私政策 https://lauer3912.github.io/ios-JustZenGo/docs/PrivacyPolicy.html / 类别 Productivity / 年龄分级 4+ / 出口合规已预配置 / 登录信息否 / 审核信息如需登录则提供测试账号+Demo数据 / 禁用 Pomodoro、heatmap、emoji / 版权 Copyright © 2026 JustZenGo ZhiFeng Sun / 界面设计风格 参照 §4.5 / 功能数量 ≥60
| 截图 | iPhone 6.9"(1320×2868)x3 + iPhone 6.5"(1284×2778)x3 + iPhone 6.3"(1206×2622)x3 + iPad 13"(2048×2732)x3 + iPad 11"(1668×2388)x3 |
