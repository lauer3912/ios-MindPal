# MEMORY.md - 核心记忆

## 🎯 财务目标
- **总债务**: $50,000 人民币
- **还款期限**: 4个月内还清
- **月均需赚**: $12,500
- **工作日日均**: ~$625
- **当前状态**: 紧急，全力搞钱

## 📱 当前项目
1. **JustZen** (原 FocusTimer) - 番茄钟 App
   - 状态: ✅ 构建成功，⏳ 待上传
   - Bundle ID: com.ggsheng.JustZen
   - 需要: App-Specific Password 上传

2. **Clarity** - 屏幕时间管理
   - 状态: ✅ 构建成功，⏳ 待上传
   - Bundle ID: com.clarity.app

## 🚀 上线计划
1. JustZen → App Store 上架
2. Clarity → App Store 上架
3. 创建更多 App 快速变现

## ⚡ 行动准则
- 7x24 专注 App 开发
- 收到 App-Specific Password 立即上传
- 持续构建更多 App

## 📝 关键知识
- XcodeGen: ~/tools/xcodegen/bin/xcodegen
- 部署脚本: ~/tools/deploy.sh
- App Store 上传需要 App-Specific Password
- 云 Mac: MacinCloud LA690 (每天最多3小时)

## 📱 App Store 截图
- **JustZenGo**: 8张不同截图 (Screen1_Home, Screen2_Statistics, Screen3_Intelligence, Screen4_Settings, Screen5_Achievements, Screen6_Shop, Screen7_Profile, Screen8_Projects)
- **UstiaGo**: 7张不同截图 (Screen1_Today, Screen2_Focus, Screen3_Insights, Screen4_WindDown, Screen5_Settings + 2个iPhone67截图)
- XCUITest 可以用于截 App Store 图（详见 AGENTS.md）
- JustZenGo 的 sheet 按钮需要加 `accessibilityIdentifier` 才能精确 tap

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

## 📱 当前项目状态
| 项目 | 业务名 | Repo | 状态 |
|------|--------|------|------|
| 番茄钟 | JustZenGo | ios-JustZenGo | ✅ |
| 屏幕时间 | UstiaGo | ios-UstiaGo | ✅ |
