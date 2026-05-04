# AvatarAI Pro - Specification Document

## 1. Project Overview

- **Project Name**: AvatarAI Pro
- **Bundle ID**: com.ggsheng.AvatarAIPro
- **Core Functionality**: AI-powered avatar generator - users upload selfies and receive AI-generated avatars in various styles (anime, 3D game, cyberpunk, professional, fantasy)
- **Target Users**: Gen-Z and Millennials who want personalized AI avatars for social media (TikTok, Instagram, Discord)
- **iOS Version Support**: iOS 17.0+
- **Language**: English (no CJK)
- **Market**: Global (Western focus)

## 2. UI/UX Specification

### 2.1 Screen Structure

1. **Onboarding Screen** (first launch only)
   - Welcome carousel (3 slides)
   - Privacy policy consent
   - Push notification permission

2. **Home Screen** (Main)
   - Hero section with "Create Avatar" CTA
   - Gallery of user's generated avatars (horizontal scroll)
   - "Try Now" sample avatars section
   - Bottom tab bar

3. **Style Selection Screen**
   - Grid of style categories (2 columns)
   - Each style shows preview image + name + credit cost
   - Filter by category (All, Anime, 3D Game, Cyberpunk, Professional, Fantasy)

4. **Photo Upload Screen**
   - PHPicker for photo selection
   - Face detection feedback
   - Upload progress indicator

5. **Generation Progress Screen**
   - Animated progress indicator
   - "Creating your avatars..." text
   - Cancel button

6. **Results Screen**
   - Full-screen avatar display (swipeable)
   - Save to Photos button
   - Share button (TikTok, Instagram, Messages)
   - "Create More" button

7. **Profile Screen**
   - User avatar stats (total created, styles used)
   - Credits balance display
   - Purchase credits button
   - Settings (notifications, privacy, terms)
   - Account deletion

8. **Credits Store Screen**
   - Credit packages (50/200/500 credits)
   - Monthly subscription option
   - Price display

### 2.2 Navigation Structure

```
TabBarController
├── HomeTab (UINavigationController)
│   ├── HomeViewController
│   ├── StyleSelectionViewController
│   ├── PhotoUploadViewController
│   ├── GenerationProgressViewController
│   └── ResultsViewController
├── GalleryTab (UINavigationController)
│   └── GalleryViewController (grid of all user avatars)
└── ProfileTab (UINavigationController)
    ├── ProfileViewController
    └── CreditsStoreViewController
```

### 2.3 Visual Design

**Color Palette**
- Primary: Deep Purple `#6C3CE9`
- Secondary: Cyan `#00D4FF`
- Accent: Magenta `#FF00FF`
- Background Dark: `#0D0D1A`
- Background Light: `#F5F5FA`
- Surface Dark: `#1A1A2E`
- Surface Light: `#FFFFFF`
- Text Primary Dark: `#FFFFFF`
- Text Primary Light: `#1A1A2E`
- Text Secondary: `#8B8B9E`
- Success: `#00E676`
- Error: `#FF5252`

**Typography**
- Font Family: SF Pro Display (system)
- Heading 1: 34pt Bold
- Heading 2: 28pt Bold
- Heading 3: 22pt Semibold
- Body: 17pt Regular
- Caption: 13pt Regular
- Button: 17pt Semibold

**Spacing System** (8pt grid)
- xs: 4pt
- sm: 8pt
- md: 16pt
- lg: 24pt
- xl: 32pt
- xxl: 48pt

**Corner Radius**
- Small: 8pt (buttons, text fields)
- Medium: 16pt (cards, images)
- Large: 24pt (bottom sheets, modals)
- Full: 50% (avatars, circular buttons)

### 2.4 Views & Components

**Reusable Components**

1. **AAPrimaryButton**
   - Gradient background (Purple → Cyan)
   - White text, 17pt Semibold
   - Height: 56pt
   - Corner radius: 28pt (full round)
   - States: default, highlighted (0.8 opacity), disabled (0.5 opacity)

2. **AASecondaryButton**
   - Border: 2pt white/primary
   - Transparent background
   - Same text style as primary
   - Height: 56pt

3. **AAStyleCard**
   - Size: (screenWidth - 48) / 2
   - Image preview (aspect ratio 1:1)
   - Style name below (17pt Semibold)
   - Credit cost badge (top right)
   - Corner radius: 16pt
   - Shadow: 0 4pt 12pt rgba(0,0,0,0.15)

4. **AAAvatarCell**
   - Square cell in collection view
   - Corner radius: 12pt
   - Selection checkmark overlay

5. **AACreditBadge**
   - Pill shape (height: 24pt)
   - Background: Primary color
   - Text: white, 13pt Medium
   - Format: "🪙 X credits"

6. **AAProgressRing**
   - Animated circular progress
   - Gradient stroke
   - Center: percentage text

7. **AAShareButton**
   - Circular button (48pt)
   - Platform icon (TikTok/Instagram/Messages)
   - Background: Surface color

### 2.5 Animations & Transitions

- Screen transitions: Standard iOS push (0.35s)
- Button press: Scale to 0.95, 150ms ease-out
- Card appearance: Fade in + scale from 0.9, 300ms ease-out
- Progress ring: Continuous rotation 1s linear
- Avatar generation: Pixelate reveal effect, 500ms
- Tab bar: Cross-fade, 200ms

## 3. Functionality Specification

### 3.1 Core Features (Priority Order)

**P0 - Must Have (MVP)**
1. User photo upload via PHPicker
2. AI avatar generation (10 styles minimum)
3. Results display (swipeable gallery)
4. Save to Photos
5. Share to TikTok/Instagram/Messages
6. Credits system (local)
7. Credits purchase (packages)

**P1 - Should Have**
8. Onboarding flow
9. Gallery view of all generated avatars
10. Face detection feedback
11. Generation progress animation
12. Push notifications (optional)

**P2 - Nice to Have**
13. Monthly subscription
14. More styles (target: 50+)
15. Face enhancement filters
16. Batch generation

### 3.2 AI Styles (MVP - 10 Styles)

| Style | Name | Credits | Description |
|-------|------|---------|-------------|
| 1 | Anime | 10 | Japanese anime style |
| 2 | Cyberpunk | 10 | Neon-lit futuristic |
| 3 | 3D Game | 15 | Video game character |
| 4 | Professional | 15 | Business headshot |
| 5 | Fantasy | 15 | Medieval/fantasy warrior |
| 6 | Sci-Fi | 10 | Space explorer |
| 7 | Retro | 10 | 80s vaporwave |
| 8 | Portrait | 20 | Realistic portrait |
| 9 | Pixar | 15 | 3D animated movie style |
| 10 | Gothic | 10 | Dark romantic |

### 3.3 User Interactions & Flows

**Flow 1: First Launch**
1. App opens → Onboarding carousel
2. Swipe through 3 slides → Continue button
3. Privacy policy modal → Agree/Decline
4. Main app (Home tab)

**Flow 2: Generate Avatar**
1. Tap "Create Avatar" on Home
2. Select style from grid
3. Upload photo (PHPicker)
4. Face detection check → Show feedback if no face
5. Confirm generation → Progress screen
6. Wait 30-60 seconds (mock for MVP, real AI later)
7. Results display
8. Save/Share/Close

**Flow 3: Purchase Credits**
1. Tap credits badge or Profile → Credits Store
2. Select package (50/200/500 credits)
3. Apple IAP confirmation
4. Credits added to account

### 3.4 Data Handling

**Local Storage (UserDefaults)**
- `credits_balance`: Int (default: 5 free credits)
- `has_completed_onboarding`: Bool
- `generated_avatars`: [String] (file paths)
- `preferred_style`: String?
- `notification_enabled`: Bool

**Local Storage (SQLite)**
- Avatars table: id, image_path, style, created_at
- Styles table: id, name, credit_cost, preview_url

**API Calls**
- Avatar generation: Replicate API / OpenAI DALL-E API
- For MVP: Mock generation with sample images

### 3.5 Architecture Pattern

**MVVM (Model-View-ViewModel)**
- Models: Avatar, Style, User, CreditTransaction
- ViewModels: HomeViewModel, GenerationViewModel, ProfileViewModel, StoreViewModel
- Views: UIKit ViewControllers + SwiftUI views where appropriate
- Services: AIService, CreditsService, StorageService, ShareService

### 3.6 Error Handling

- No face detected: Show alert with retry option
- Generation failed: Show error + refund credits
- Network error: Show offline message + retry
- Insufficient credits: Show purchase prompt
- Photo permission denied: Show settings redirect

## 4. Technical Specification

### 4.1 Dependencies

**Swift Package Manager**
- SnapKit (Auto Layout)
- SQLite.swift (Local database)
- Kingfisher (Image loading/caching)

### 4.2 UI Framework

- **Primary**: UIKit (for complex animations and performance)
- **Secondary**: SwiftUI (for simple views if needed)

### 4.3 Asset Requirements

**App Icon**
- 1024x1024 AppIcon.png (confirmed by user)

**Images**
- Onboarding illustrations (3)
- Style preview images (10 for MVP)
- Placeholder images
- Empty state illustrations

**SF Symbols Used**
- house.fill (Home tab)
- square.grid.2x2.fill (Gallery tab)
- person.fill (Profile tab)
- camera.fill
- square.and.arrow.up (Share)
- checkmark.circle.fill
- xmark.circle.fill
- crown.fill (Premium)

**Colors** (Asset Catalog)
- AccentColor (Purple gradient)
- BackgroundColor (Dark/Light)
- SurfaceColor
- TextPrimary
- TextSecondary

### 4.4 Info.plist Keys

- `NSPhotoLibraryUsageDescription`: "AvatarAI Pro needs access to your photos to generate AI avatars."
- `NSCameraUsageDescription`: "AvatarAI Pro can use your camera to take selfies for avatar creation."
- `NSPhotoLibraryAddUsageDescription`: "Save your generated avatars to your photo library."

### 4.5 Project Structure

```
AvatarAIPro/
├── Sources/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   └── Info.plist
│   ├── Models/
│   │   ├── Avatar.swift
│   │   ├── Style.swift
│   │   └── CreditTransaction.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── GenerationViewModel.swift
│   │   ├── GalleryViewModel.swift
│   │   ├── ProfileViewModel.swift
│   │   └── StoreViewModel.swift
│   ├── Views/
│   │   ├── Components/
│   │   │   ├── AAPrimaryButton.swift
│   │   │   ├── AASecondaryButton.swift
│   │   │   ├── AAStyleCard.swift
│   │   │   ├── AAAvatarCell.swift
│   │   │   ├── AACreditBadge.swift
│   │   │   └── AAProgressRing.swift
│   │   ├── Home/
│   │   │   └── HomeViewController.swift
│   │   ├── StyleSelection/
│   │   │   └── StyleSelectionViewController.swift
│   │   ├── PhotoUpload/
│   │   │   └── PhotoUploadViewController.swift
│   │   ├── Generation/
│   │   │   └── GenerationViewController.swift
│   │   ├── Results/
│   │   │   └── ResultsViewController.swift
│   │   ├── Gallery/
│   │   │   └── GalleryViewController.swift
│   │   ├── Profile/
│   │   │   ├── ProfileViewController.swift
│   │   │   └── CreditsStoreViewController.swift
│   │   └── Onboarding/
│   │       └── OnboardingViewController.swift
│   ├── Services/
│   │   ├── AIService.swift
│   │   ├── CreditsService.swift
│   │   ├── StorageService.swift
│   │   ├── ShareService.swift
│   │   └── IAPService.swift
│   ├── Extensions/
│   │   ├── UIColor+Theme.swift
│   │   ├── UIFont+Theme.swift
│   │   └── UIView+Extensions.swift
│   └── Resources/
│       └── Assets.xcassets/
├── project.yml
└── Package.swift
```

## 5. Build Configuration

- **Development Team**: ZhiFeng Sun (9L6N2ZF26B)
- **Code Signing**: Automatic
- **Deployment Target**: iOS 17.0
- **Swift Version**: 5.9
- **Build Configuration**: Debug / Release

## 6. Testing Strategy

- Unit tests for ViewModels
- UI tests for critical flows (onboarding, generation, purchase)
- Manual testing on various iOS devices

## 7. Privacy & Compliance

- Privacy Policy required (English)
- No data shared with third parties
- All AI processing done via secure API
- User can delete all data from Profile screen
