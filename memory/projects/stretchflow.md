# stretchflow — 项目状态

> 最后更新: 2026-05-08
> 状态: 🔨 开发中（内购订阅待配置）

## 基本信息
- Bundle ID: com.ggsheng.StretchGoGo
- App Store Name: StretchGoGo
- 内购产品 ID: `com.ggsheng.StretchGoGo.PremiumMonthly`
- 内购类型: 自动续费订阅 $0.99/月
- 创建时间: 2026-04
- 最后活跃: 2026-05-08

## 当前状态

| 类型 | 状态 | 说明 |
|------|------|------|
| 代码 | ✅ 完成 | PremiumManager + PremiumPaywallView + 恢复购买 |
| App Store 截图 | ✅ 完成 | iPhone 6.9" x5 + iPad 13" x5（真实 XCUITest 捕获）|
| 内购审核截图 | ✅ 完成 | 3张（购买界面 + 订阅按钮 + 恢复购买）|
| 隐私政策 | ✅ 完成 | 包含订阅条款 |
| Listing.md | ✅ 完成 | SOP §1.8 标准格式 |

## 截图文件

```
AppStore/Screenshots/
├── iPhone_69_1320x2868/
│   ├── 01_Home.png
│   ├── 02_Library.png
│   ├── 03_SessionDetail.png
│   ├── 04_Stats.png
│   └── 05_Profile.png
├── iPad_13_2048x2732/
│   ├── 01_Home.png
│   ├── 02_Library.png
│   ├── 03_SessionDetail.png
│   ├── 04_Stats.png
│   └── 05_Profile.png
└── InAppPurchase/
    ├── IAP_com.ggsheng.StretchGoGo.PremiumMonthly_购买界面_iPhone69.png
    ├── IAP_com.ggsheng.StretchGoGo.PremiumMonthly_订阅按钮_iPhone69.png
    └── IAP_com.ggsheng.StretchGoGo.PremiumMonthly_恢复购买_iPhone69.png
```

## 重要文档
- **内购提交指南**: `memory/projects/stretchflow-iap-guide.md`
- SOP 内购章节: `SOP-iOS-AppStore-Launch.md §8.7.1`

## 最后进展
- 2026-05-08: 老爷提示需完善内购提交流程，已创建详细指南
- 2026-04-29: 项目文件创建

## 内购提交前必须完成

| 步骤 | 状态 | 说明 |
|------|------|------|
| 签署付费应用协议 | ⬜ | App Store Connect → 协议、税务和银行 |
| 配置银行信息 | ⬜ | 收款用，验证1-2天 |
| 配置税务信息 | ⬜ | 美国 W-8BEN/W-9 |
| 创建内购产品 | ⬜ | App Store Connect → 内购 → + |
| 实现 StoreKit | ⬜ | PremiumManager.swift + Paywall |
| 恢复购买按钮 | ⬜ | Apple 审核必查 |
| 隐私政策更新 | ⬜ | 包含订阅条款 |
| App 隐私配置 | ⬜ | 购买行为 → 是 |
| 内购审核截图 | ⬜ | 订阅墙界面 |

## 待办
- [ ] 完成内购代码实现（PremiumManager + Paywall）
- [ ] 签署协议 + 配置银行/税务
- [ ] 创建内购产品
- [ ] 更新隐私政策
- [ ] 准备内购审核截图
- [ ] VNC Archive + 上传
- [ ] 提交审核

## 历史记录
| 日期 | 操作 | 详情 |
|------|------|------|
| 2026-05-08 | 创建内购提交指南 | stretchflow-iap-guide.md |
| 2026-04-29 | 创建项目文件 | 企业级记忆升级 |
