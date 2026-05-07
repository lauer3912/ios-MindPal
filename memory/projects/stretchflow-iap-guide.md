# StretchGoGo 内购项目提交指南 v1.0

> 创建时间: 2026-05-08
> 项目: StretchGoGo (Bundle ID: com.ggsheng.StretchGoGo)
> 内购类型: 订阅 ($0.99/月 Premium)
> 产品 ID: `com.ggsheng.StretchGoGo.PremiumMonthly`

---

## 📋 提交前检查清单

### ✅ 必需条件（必须全部满足才能提交）

| 检查项 | 状态 | 说明 |
|--------|------|------|
| App Store Connect 签约 | ⬜ | 必须签署"付费应用协议" |
| 银行信息配置 | ⬜ | 需配置银行账户收款 |
| 税务信息配置 | ⬜ | 需填写税务表单（W-8BEN/W-9） |
| 内购产品创建 | ⬜ | 在 App Store Connect 创建订阅产品 |
| 内购截图准备 | ⬜ | 需提供内购审核截图 |
| App 隐私配置 | ⬜ | 包含内购需配置"购买行为"为"是" |
| 隐私政策更新 | ⬜ | 需说明内购和订阅条款 |

---

## 🏧 第一步：签署付费应用协议

> ⚠️ **这是提交内购 App 的第一步，必须先完成协议签署才能创建内购产品**

### 1.1 访问 App Store Connect

1. 登录 [App Store Connect](https://appstoreconnect.apple.com)
2. 点击 **"协议、税务和银行"**（Agreements, Tax, and Banking）
3. 或访问: https://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/admin/edit/agreements

### 1.2 签署协议

协议类型 | 用途 | 要求
---------|------|------
**付费应用**（Paid Applications）| 销售收费 App 或内购 | 必签
**Safari 开发者**（Web Extensions）| Safari 扩展（如有）| 如有需签

### 1.3 配置银行信息

1. 在"协议、税务和银行"页面点击 **"添加银行账户"**
2. 选择银行所在国家/地区
3. 输入银行账户信息（账户号码、路由号码等）
4. 验证银行账户（可能需要1-2天）

### 1.4 配置税务信息

1. 美国：填写 **W-8BEN** 或 **W-9** 表
2. 其他国家：根据提示填写相应表单
3. 在 App Store Connect 的"税务"部分完成

### 1.5 协议生效时间

- 协议签署后通常 **1-2个工作日** 生效
- 银行验证可能需要 **几天到几周**
- 期间可以准备其他材料

---

## 💰 第二步：创建内购产品

> ⚠️ **必须等协议生效后才能创建内购产品**

### 2.1 在 App Store Connect 创建订阅

1. 登录 App Store Connect
2. 进入 **我的 App** → 选择 **StretchGoGo**
3. 点击左侧菜单 **"内购"**（In-App Purchases）
4. 点击 **"+"** 添加内购

### 2.2 选择产品类型

选择 **"自动续费订阅"**（Auto-Renewable Subscription）

### 2.3 填写产品信息

| 字段 | 填写内容 |
|------|---------|
| **产品 ID** | `com.ggsheng.StretchGoGo.PremiumMonthly` |
| **参考名称** | `StretchGoGo Premium Monthly` |
| **订阅时长** | `1 个月` |
| **App Store 地区** | 选择 App 可用的地区（默认全选）|

### 2.4 定价

| 字段 | 值 |
|------|-----|
| **价格** | $0.99 USD |
| **订阅类型** | 非公开订阅（Private Subscription）|
| **分享组织** | 选择不共享（订阅只对用户本人可见）|

### 2.5 订阅本地化（多语言）

为每种语言添加本地化名称和描述：

| 语言 | 本地化名称 | 描述 |
|------|-----------|------|
| English (US) | Premium Monthly | Unlock all 72+ sessions, advanced stats, voice guidance, and iCloud sync. |
| Chinese (Simplified) | 高级会员月卡 | 解锁全部72+课程、高级统计、语音指导和iCloud同步。 |

### 2.6 审核信息

| 字段 | 内容 |
|------|------|
| **演示账号** | 提供测试用沙盒账号（如有）|
| **审核备注** | 说明内购功能（如：Premium subscription to unlock all features）|

### 2.7 保存并提交

点击 **"存储"** 保存产品

---

## 📱 第三步：在 App 内配置 StoreKit

> ⚠️ **如果代码未实现 StoreKit，提交审核会被拒**

### 3.1 项目必须包含以下文件

```
Sources/
├── App/
│   └── StretchGoGoApp.swift
├── Features/
│   ├── Premium/
│   │   └── PremiumManager.swift     ← 订阅管理
│   │   └── PremiumPaywallView.swift ← 订阅界面
│   └── Home/
│       └── HomeView.swift          ← 显示订阅状态
└── Resources/
    └── Assets.xcassets
```

### 3.2 PremiumManager.swift 关键实现

```swift
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    private let productId = "com.ggsheng.StretchGoGo.PremiumMonthly"
    
    @Published var isPremium = false
    @Published var products: [Product] = []
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: [productId])
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase() async throws {
        guard let product = products.first else { return }
        
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePremiumStatus(true)
            await transaction.finish()
        case .userCancelled:
            break
        default:
            break
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        let hasActive = await Environment().isPurchased(productId)
        isPremium = hasActive
    }
    
    private func updatePremiumStatus(_ status: Bool) {
        isPremium = status
        UserDefaults.standard.set(status, forKey: "isPremium")
    }
}
```

### 3.3 订阅界面 PremiumPaywallView.swift

```swift
struct PremiumPaywallView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题
            Text("Unlock Premium")
                .font(.largeTitle)
            
            // 功能列表
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "star.fill", text: "All 72+ Sessions")
                FeatureRow(icon: "chart.bar.fill", text: "Advanced Statistics")
                FeatureRow(icon: "mic.fill", text: "Voice Guidance")
                FeatureRow(icon: "icloud.fill", text: "iCloud Sync")
            }
            
            // 价格
            Text("$0.99/month")
                .font(.title2)
            
            // 订阅按钮
            Button("Subscribe") {
                Task {
                    try? await premiumManager.purchase()
                }
            }
            .buttonStyle(.borderedProminent)
            
            // 恢复购买按钮
            Button("Restore Purchases") {
                Task {
                    await premiumManager.restorePurchases()
                }
            }
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
    }
}
```

### 3.4 恢复购买按钮（必须实现）

Apple 审核要求：**必须提供"恢复购买"按钮**

在设置界面或订阅界面添加恢复购买按钮：
```swift
Button("Restore Purchases") {
    Task {
        await premiumManager.restorePurchases()
    }
}
```

---

## 🔒 第四步：配置 App 隐私

> ⚠️ **包含内购的 App 必须在隐私配置中设置"购买行为"为"是"**

### 4.1 App Store Connect 隐私配置

登录 App Store Connect → 我的 App → StretchGoGo → **App 隐私**

找到 **"购买行为"**（Purchase History）：

| 选项 | 选择 |
|------|------|
| 从 App 购买 | **是** |

### 4.2 隐私政策更新

在 `docs/PrivacyPolicy.html` 中添加订阅相关条款：

```html
<h2>In-App Purchases and Subscriptions</h2>
<p>StretchGoGo offers auto-renewing subscriptions for premium features. 
Subscription details:</p>
<ul>
<li>Premium Monthly: $0.99/month</li>
<li>Subscriptions automatically renew unless cancelled 24 hours before the end of the current period.</li>
<li>Users can manage or cancel subscriptions via iOS Settings > Apple ID > Subscriptions.</li>
<li>No refunds for unused portions.</li>
</ul>
```

---

## 📸 第五步：准备内购审核截图

> ⚠️ **提交含内购的 App 必须提供内购相关截图**

### 5.1 截图要求

| 类型 | 尺寸 | 数量 |
|------|------|------|
| 内购产品截图 | 与 App 截图尺寸相同 | 至少 1 张 |

### 5.2 截图内容

截取 App 内购界面（订阅墙/Premium 界面），显示：
- 订阅价格 ($0.99/month)
- 订阅功能列表
- 订阅按钮

### 5.3 截图示例命名

```
screenshots/
├── iPhone6.7-inPurchase-En.png
├── iPhone6.5-inPurchase-En.png
└── iPad12.9-inPurchase-En.png
```

---

## ⬆️ 第六步：提交审核

### 6.1 提交前检查

| 检查项 | 说明 |
|--------|------|
| ✅ 协议已签署 | "协议、税务和银行"状态为"生效" |
| ✅ 内购产品已创建 | 在 App Store Connect 可看到产品 |
| ✅ StoreKit 已实现 | 代码包含完整的购买/恢复逻辑 |
| ✅ 隐私政策已更新 | 包含内购和订阅条款 |
| ✅ 内购截图已准备 | 显示订阅墙界面 |
| ✅ App 已 Archive | 在 Xcode 中成功 Archive |

### 6.2 提交步骤（VNC 操作）

1. **Xcode → Product → Archive** → 选择 StretchGoGo
2. **Distribute App** → App Store Connect → Sign and Upload
3. 等待上传完成（验证通过）
4. **App Store Connect** → 我的 App → StretchGoGo
5. **版本** → 选择刚上传的版本
6. 填写 App 信息：
   - 类别: **Health & Fitness**
   - 价格: **Free**
   - 隐私政策 URL: `https://lauer3912.github.io/ios-StretchFlow/docs/PrivacyPolicy.html`
7. **App 隐私** → 配置购买行为为"是"
8. **内购** → 确认产品已添加
9. **上传内购截图**
10. **提交审核**

### 6.3 提交后状态

提交后 App 状态变为 **"等待审核"**（Waiting for Review）

首次审核通常需要 **7-14 个工作日**

---

## ❌ 常见被拒原因

| 被拒原因 | 解决方案 |
|---------|---------|
| "IAP not implemented correctly" | 确保完整的 StoreKit 实现（购买+恢复） |
| "Cannot restore purchases" | 必须提供恢复购买按钮 |
| "Product ID mismatch" | 产品 ID 必须与 App Store Connect 完全一致 |
| "App crashes" | 使用沙盒账号完整测试购买流程 |
| "Missing privacy policy" | 隐私政策必须包含内购和订阅条款 |

---

## 📞 沙盒测试

### 测试账号创建

1. App Store Connect → 用户和访问 → 测试
2. 创建沙盒测试员账号（用真实邮箱但非已注册 Apple ID）

### 测试步骤

1. 在设备上登录沙盒测试账号（设置 → iTunes Store → 登出 → 登录沙盒账号）
2. 运行 StretchGoGo
3. 点击订阅按钮
4. 确认购买成功（不扣真实费用）

---

## 📅 项目时间线

| 阶段 | 预计时间 |
|------|----------|
| 协议签署 | 1-2 个工作日（银行验证可能更长）|
| 内购产品创建 | 协议生效后即可 |
| 代码实现 | 根据现有代码进度 |
| App Store Connect 填写 | 1-2 小时 |
| Apple 审核 | 7-14 个工作日 |

---

*本文档由 AI Agent 生成 | 如有疑问请参考 SOP-iOS-AppStore-Launch.md §8.7*