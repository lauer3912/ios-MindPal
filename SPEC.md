# MindPal — AI Journal & Emotion Tracker

## 1. Concept & Vision

**"Your AI companion for emotional clarity"**

MindPal is a personal journal app that combines traditional journaling with AI-powered emotion analysis. Unlike generic diary apps, MindPal understands your emotional patterns and generates personalized reflection questions to deepen self-awareness. The experience feels like having a thoughtful friend who remembers everything and helps you see patterns you'd miss.

The app has a calm, therapeutic aesthetic — a safe digital space where users can process their thoughts without judgment. The AI acts as a gentle guide, not a cold algorithm.

## 2. Design Language

### Aesthetic Direction
**Therapeutic Minimalism** — Soft, muted tones with organic shapes. Think meditation app meets premium journal. The UI should feel like a warm hug, not a productivity tool.

### Color Palette

**Dark Theme (Default Night Mode)**
- Background Primary: #0F0F14 (deep space)
- Background Secondary: #1A1A24 (card surfaces)
- Background Tertiary: #252532 (elevated elements)
- Accent Primary: #9B8FE8 (soft violet — AI spark)
- Accent Secondary: #6EE7B7 (mint green — positive emotions)
- Accent Warm: #FCD34D (amber — highlights)
- Text Primary: #F5F5F7
- Text Secondary: #A1A1AA
- Text Tertiary: #6B6B7A
- Mood Happy: #6EE7B7
- Mood Neutral: #9B8FE8
- Mood Sad: #60A5FA
- Mood Anxious: #FBBF24
- Mood Angry: #F87171
- Mood Calm: #A78BFA

**Light Theme**
- Background Primary: #FEFEFE
- Background Secondary: #F5F5F7
- Background Tertiary: #EDEDEF
- Accent Primary: #7C6FD9 (deeper violet)
- Text Primary: #1A1A24
- Text Secondary: #6B6B7A

### Typography
- Heading 1: SF Pro Display, 28pt, Semibold
- Heading 2: SF Pro Display, 22pt, Medium
- Body: SF Pro Text, 16pt, Regular
- Caption: SF Pro Text, 13pt, Regular
- Quotes: New York (serif), 18pt, Italic

### Spatial System
- Base unit: 8pt
- Card padding: 24pt
- Section spacing: 32pt
- Safe area: 16pt horizontal

### Motion Philosophy
- Gentle, slow transitions (300-400ms)
- Spring animations for interactive elements
- Fade-in for new content
- Subtle parallax on mood charts
- No jarring or sudden movements

### Visual Assets
- SF Symbols for all icons (rounded style)
- Gradient orbs for mood indicators
- Soft shadows (blur: 20, opacity: 0.1)
- Custom illustrated empty states

## 3. Layout & Structure

### Navigation
Tab-based with 4 main sections:
1. **Journal** — Main writing interface
2. **Insights** — Emotion analytics
3. **Growth** — Goals and achievements
4. **Settings** — Preferences and data

### Screen Flow
```
[Today] → Journal Entry → AI Analysis → Reflection Prompts
     ↓
[Mood Selector] → Quick mood check-in (< 10 seconds)
     ↓
[Insights] → Weekly Mood Graph → Pattern Detection → AI Insights
     ↓
[Growth] → Streaks → Achievements → Badges
```

### Responsive Strategy
- iPhone: Single column, full-width cards
- iPad: Two-column layout for journal + insights side by side

## 4. Features (50+)

### Core Journal Features
1. **Quick Journal** — One-tap to start writing
2. **AI Title Generation** — Auto-generates a title from entry content
3. **Mood Selection** — 6 emotion options with intensity slider (1-5)
4. **Rich Text Entry** — Bold, italic, bullet points
5. **Voice-to-Text** — Speech recognition for hands-free journaling
6. **Photo Attachments** — Attach photos to journal entries
7. **Location Tagging** — Optional location on entries
8. **Weather Integration** — Auto-capture weather (sunny/rainy/etc)
9. **Date Navigation** — Calendar view with entry indicators
10. **Search** — Full-text search across all entries
11. **Tags/Categories** — Custom tags for organization
12. **Favorites** — Mark entries as favorites

### AI Features
13. **Emotion Analysis** — AI detects emotion patterns in writing
14. **Reflection Prompts** — AI generates personalized questions based on content
15. **Mood Prediction** — "Based on your week, you seem..." insights
16. **Pattern Detection** — "You've been anxious on Mondays..."
17. **Weekly Summary** — AI-generated weekly emotional review
18. **Sentiment Trends** — Line graph of mood over time
19. **Word Cloud** — Visual representation of common themes
20. **Writing Streak Detection** — Pattern of journaling habits
21. **Peak Hours** — "You write best at 9 PM"
22. **Relationship Insights** — Track emotions around people/events
23. **Trigger Identification** — "Your anxiety spikes after work"
24. **Growth Recognition** — "You handled that situation better than before"

### Gamification Features
25. **Streak Counter** — Consecutive journaling days
26. **Achievement Badges** — "First entry", "7-day streak", etc.
27. **Journey Map** — Visual representation of journaling progress
28. **Milestone Rewards** — Unlock themes/badges at milestones
29. **Mood Improvement Tracking** — "Your average mood improved this week"
30. **Reflection Completeness** — Track if users respond to AI prompts

### User Experience Features
31. **Dark/Light Theme** — Full theme support
32. **Scheduled Reminders** — Daily journaling reminder (customizable time)
33. **Quick Mood Check-in Widget** — Home screen widget
34. **Lock with Face ID** — Privacy protection
35. **Export Data** — JSON/PDF export of all entries
36. **Reminder Notifications** — Gentle, non-intrusive reminders
37. **Writing Timer** — Optional timer while writing
38. **Prompt Suggestions** — "What to write about today"
39. **Time of Day Analysis** — When user typically journals
40. **Mood Distribution Chart** — Pie chart of emotion breakdown
41. **Best Streak Record** — Personal best streak display
42. **Entry Tags Analytics** — Which tags generate most entries
43. **Word Count Statistics** — Average words per entry
44. **Consistency Score** — Weekly journaling consistency %
45. **Monthly Review** — AI-generated monthly report
46. **Year in Review** — Annual emotional journey summary
47. **Custom Prompts Library** — User can save favorite prompts
48. **Templates** — "Morning gratitude", "Evening reflection", etc.
49. **Focus Mode** — Distraction-free writing mode
50. **Haptic Feedback** — Gentle vibrations on interactions

### Data Features
51. **iCloud Sync** — Sync across devices
52. **Offline Mode** — Full functionality without internet
53. **Data Privacy** — All data stays on device unless iCloud enabled
54. **Backup/Restore** — Manual backup option

## 5. Component Inventory

### Journal Entry Card
- Date/time header
- AI-generated title (or user title)
- Entry preview (first 100 chars)
- Mood indicator dot (color-coded)
- Tags row
- States: default, expanded, editing

### Mood Selector
- 6 emotion buttons in circular arrangement
- Intensity slider below
- Selected state: enlarged + glow effect
- Unselected: dimmed with subtle border

### AI Insight Card
- Icon indicator (lightbulb/sparkle)
- Insight text
- "Tap to learn more" interaction
- Subtle gradient background

### Streak Counter
- Large number display
- Flame icon animation when active
- Ring progress indicator
- "days" label

### Calendar View
- Month grid with dot indicators for entries
- Mood color dots on dates
- Selected date highlight
- Swipe to change month

### Chart Components
- Line chart: mood over time (7/30/90 days)
- Pie chart: mood distribution
- Bar chart: entries per day
- Gradient fills on charts

### Empty States
- Friendly illustration
- Encouraging message
- "Write your first entry" CTA button

## 6. Technical Approach

### Framework
- **UIKit** (programmatic, no storyboards)
- **SnapKit** for Auto Layout
- **SwiftUI** for charts (Swift Charts)

### Architecture
- **MVVM** pattern
- **Repository pattern** for data access
- **Combine** for reactive data binding

### Data Storage
- **SQLite.swift** for entries and metadata
- **UserDefaults** for settings/preferences
- **iCloud** (CloudKit) for sync

### AI Integration
- **On-device ML** for emotion analysis (CoreML)
- **Local processing** — no cloud AI needed
- Fallback to keyword-based analysis if ML unavailable

### Privacy
- Face ID/Touch ID lock option
- All data encrypted at rest
- No analytics/tracking
- GDPR compliant data export

### Dependencies
- SnapKit (Auto Layout)
- SQLite.swift (local database)
- Charts (SwiftUI charts, iOS 16+)
- Speech (voice-to-text)

## 7. App Store Details

### Name
**MindPal** — AI Journal & Emotion Tracker

### Subtitle
Your private space for emotional clarity

### Description
```
Meet MindPal — your AI-powered journal companion.

Unlike ordinary diary apps, MindPal understands your emotional patterns and helps you gain deeper self-awareness through personalized AI insights.

📝 **Smart Journaling**
Write freely with rich text, photos, and voice dictation. MindPal's AI titles your entries automatically and analyzes your emotional tone.

💭 **AI Reflections**
After each entry, MindPal generates thoughtful questions to help you reflect deeper. "What made you feel anxious about that meeting?"

📊 **Emotion Insights**
See your mood patterns over time. Discover when you feel best, what triggers stress, and how your emotional health evolves.

🔥 **Stay Consistent**
Build a journaling habit with streak tracking, achievements, and gentle reminders.

🌙 **Beautiful & Private**
Dark and light themes, Face ID lock, and all data stays on your device.

Your journal, your space — MindPal helps you understand yourself better.
```

### Keywords
```
journal, diary, mood tracker, emotion, AI, mental health, gratitude, 
self-care, reflection, wellness, mindfulness, writing, therapy, 
emotional intelligence, psychology, personal growth, habits, 
daily journal, mood journal, mental wellness
```

### Category
**Health & Fitness** (Mental Health focus)

### Price
$9.99 USD (one-time purchase)

### Privacy Policy URL
https://lauer3912.github.io/ios-MindPal/docs/PrivacyPolicy.html
