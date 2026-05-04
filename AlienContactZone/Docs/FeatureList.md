# Alien Contact Zone — Feature List

## 1. Core Concept
A sci-fi themed habit/productivity app where users receive "alien missions" (tasks), decode alien language by completing habits, chat with alien NPCs, and track their "cosmic journey". Wraps productivity in a fun sci-fi narrative that appeals to Gen Z/Young Adults.

## 2. Target Audience
- **Primary:** Gen Z (13-25) in Western markets (US, UK, Canada, Australia)
- **Secondary:** Young adults (26-40) who enjoy sci-fi and gamification
- **Tone:** Playful, mysterious, slightly absurd — not serious productivity

## 3. App Store Naming
- **App Name:** Alien Contact Zone
- **Bundle ID:** com.ggsheng.AlienContactZone
- **Widget Bundle ID:** com.ggsheng.AlienContactZone.widget

## 4. Core Features (60+)

### 🚀 Mission System (15)
1. Daily alien mission - randomized task each day
2. Mission difficulty levels (Easy/Medium/Hard/Impossible)
3. Mission timer - countdown pressure
4. Mission skip (costs "Stardust" currency)
5. Mission streak - consecutive days completed
6. Weekly mission pack - 7 missions
7. Emergency mission - last-minute urgent task
8. Mission categories (Focus/Fitness/Learn/Create/Connect)
9. Mission reward multiplier (2x/3x bonus)
10. Mission preview - see tomorrow's mission
11. Mission archive - past completed missions
12. Mission difficulty unlock (harder = better rewards)
13. Mission cooldown (skip resets 24h)
14. Mission completion celebration animation
15. Random event missions (double XP weekends)

### 👽 Alien NPC Chat (10)
16. "Zorp" - alien mission advisor NPC
17. "Nebula" - mood tracking companion
18. "Cosmo" - random tips and motivation
19. Daily alien conversation tree
20. Chat response animations (typing bubble)
21. Alien emoji responses (🛸🌌👽✨)
22. NPC mood affected by user performance
23. Unlock new NPCs via achievements
24. NPC seasonal outfits (Halloween aliens, Christmas aliens)
25. AI-generated alien language phrases

### 📅 Habit Tracking (12)
26. Create custom habits (name, icon, frequency)
27. Habit completion with alien celebration
28. Habit calendar view (weekly/monthly)
29. Habit reminder notifications
30. Habit streaks (7/21/30/100 day milestones)
31. Habit categories (Mind/Body/Soul/Social)
32. Habit completion sound effects
33. Habit completion animation (UFO beam up)
34. Habit grouping (Morning routine, Night routine, etc.)
35. Habit completion statistics
36. Habit failure recovery (1 free pass per week)
37. Habit templates (pre-made packs: "Student Starter", "Fitness Focus")

### 🌌 Alien Language Decoding (8)
38. Alphabet = 26 completed habits
39. Each habit unlocks 1 letter
40. Word building - 5 letters = word = unlock reward
41. Alien phrase library (decode phrases to learn real facts)
42. Language level progression (Beginner/Intermediate/Fluent/Alien Master)
43. Decoded words collection gallery
44. Alien word of the day
45. Secret code messages from aliens

### 🏆 Achievement System (8)
46. Achievement badges (Space Cadet → Cosmic Master)
47. XP system with level progression
48. Cosmic rank titles (Recruit → Commander → Admiral)
49. Achievement categories match mission types
50. Hidden/secret achievements
51. Achievement progress bar on each badge
52. Achievement unlock notification
53. Achievement showcase wall

### ⚙️ Settings & Customization (7)
54. Dark mode (default) / Light mode toggle
55. Notification preferences (time, frequency, sound)
56. Sound effects toggle
57. Language (English only for v1)
58. Account data export
59. Contact support (lauer3912@qq.com)
60. Privacy policy link

### 📊 Stats & Insights (6)
61. Daily/weekly/monthly completion rate
62. Best streak record
63. Most completed habit type
64. Total days active
65. XP and level progress chart
66. Calendar heat map (habit completion density)

### 🌟 Currency & Shop (5)
67. Stardust (soft currency earned per mission)
68. Cosmic shop - unlock custom alien avatars
69. Shop items: Alien suits, spaceship decorations, star backgrounds
70. Watch ads for bonus Stardust (optional)
71. Daily login bonus

## 5. Identifier Capabilities Recommended

| Capability | Reason |
|-----------|--------|
| Push Notifications | Daily alien missions, reminders, streak alerts |
| Background Modes | None required (no background refresh) |
| App Groups | For Widget data sharing |
| Siri | Not needed |
| HealthKit | Not needed |
| Data Protection | NSFileProtectionComplete for user data |
| Sign in with Apple | Not needed (local-first app) |

## 6. Technical Stack
- **UI:** SwiftUI (modern, fast development)
- **Data:** UserDefaults for settings, SQLite for habits/sessions
- **Notifications:** UserNotifications framework
- **AI Chat:** Basic chatbot UI (NPC uses pre-written responses)
- **Widget:** WidgetKit for home screen widget
- **Animations:** SwiftUI animations + Lottie (optional)

## 7. Privacy Policy Notes
- No data collection beyond device
- No third-party analytics
- All data stored locally on device
- Notification data stays on device

## 8. Suggested App Icon (already approved)
- UFO spacecraft with green/purple glow on dark space background
- 1024×1024 PNG generated and approved

## 9. Suggested UI Color Scheme
- **Primary:** Deep Space (#0F0F14)
- **Accent 1:** Alien Green (#00FF88)
- **Accent 2:** Cosmic Purple (#9B59FF)
- **Accent 3:** Neon Cyan (#00D4FF)
- **Text Primary:** White (#FFFFFF)
- **Text Secondary:** Gray (#8E8E93)