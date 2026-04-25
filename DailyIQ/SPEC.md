# DailyIQ — Intelligent Daily Autopilot

> _"Your day, orchestrated by AI."_

---

## 1. Concept & Vision

DailyIQ is not a to-do list. It's an **AI-powered daily autopilot** that plans your entire day while you sleep. Unlike passive task managers that wait for your input, DailyIQ actively analyzes your goals, energy patterns, and priorities to create and continuously optimize a personalized daily schedule.

**The Experience:** You wake up, open DailyIQ, and your entire day is already planned — intelligently structured around your peak productivity hours, aligned with your goals, and adaptive to real-time changes. It's like having a chief of staff who never sleeps.

**Core Promise:** "Stop planning. Start doing."

---

## 2. Design Language

### Aesthetic Direction
**Reference:** Notion meets Linear meets a premium watch face.

Clean, confident, data-dense but never cluttered. Numbers are prominent and celebratory. The interface should feel like looking at a beautifully designed dashboard of your life.

### Color Palette

**Dark Theme:**
```
Background Primary:   #09090B (obsidian black)
Background Secondary: #141417 (card surfaces)
Background Tertiary:  #1E1E22 (elevated surfaces)
Accent Primary:       #6366F1 (indigo — intelligence, focus)
Accent Secondary:     #22D3EE (cyan — energy, alerts)
Accent Warm:          #F59E0B (amber — achievements, streaks)
Text Primary:         #FAFAFA (pure white)
Text Secondary:       #A1A1AA (muted gray)
Text Tertiary:        #52525B (very muted)
Border:               #27272A (subtle dividers)
Success:              #10B981 (emerald)
Warning:              #F59E0B (amber)
Destructive:          #EF4444 (red)
```

**Light Theme:**
```
Background Primary:   #FFFFFF (pure white)
Background Secondary: #F4F4F5 (zinc-100)
Background Tertiary:  #E4E4E7 (zinc-200)
Accent Primary:       #4F46E5 (indigo-600)
Accent Secondary:     #0891B2 (cyan-600)
Accent Warm:          #D97706 (amber-600)
Text Primary:         #18181B (zinc-900)
Text Secondary:       #71717A (zinc-500)
Text Tertiary:        #A1A1AA (zinc-400)
Border:               #E4E4E7 (zinc-200)
Success:              #059669 (emerald-600)
Warning:              #D97706 (amber-600)
Destructive:          #DC2626 (red-600)
```

### Typography
- **Headings:** SF Pro Display (Bold, 700)
- **Body:** SF Pro Text (Regular, 400)
- **Numbers/Stats:** SF Mono (for time, counts, metrics — distinct feel)
- **Fallback:** -apple-system, system-ui

### Spatial System
- Base unit: 4pt
- Component padding: 12pt / 16pt / 20pt
- Card border-radius: 16pt
- Button border-radius: 12pt
- Screen padding: 20pt horizontal

### Motion Philosophy
- Transitions: 300ms ease-out for page transitions
- Micro-interactions: 150ms for buttons, toggles
- Numbers animate on change (count up/down animation)
- Cards use spring physics on drag
- Success states use subtle scale pulse (1.0 → 1.05 → 1.0)

---

## 3. App Architecture

### Screen Structure

```
App Launch
    ↓
OnboardingFlow (3 screens, shown once)
    ↓
MainTabBarController
    ├── TodayScreen (Tab 0 - "Today")
    ├── CalendarScreen (Tab 1 - "Calendar")
    ├── GoalsScreen (Tab 2 - "Goals")
    ├── InsightsScreen (Tab 3 - "Insights")
    └── SettingsScreen (Tab 4 - "Profile")
```

### Screen Specifications

#### 1. TodayScreen (Home)
The heart of DailyIQ — your AI-generated daily plan.

**Layout (top to bottom):**
- **Status Bar Area:** Date, day of week, weather icon
- **Energy Ring:** Large circular progress showing today's energy level (0-100)
- **Focus Timer Card:** Current/next focus block with countdown
- **Task Flow:** Vertically scrolling task cards, each showing:
  - Time block (e.g., "9:00 AM - 10:30 AM")
  - Task title (bold)
  - Duration badge
  - Category icon
  - Energy requirement indicator (low/medium/high)
- **Quick Add FAB:** Floating action button

**Interactions:**
- Tap task → Expand details, show edit options
- Swipe left → Complete task (slides right with checkmark animation)
- Swipe right → Defer to tomorrow
- Long press → Reorder tasks
- Pull down → Regenerate today's schedule with AI

#### 2. CalendarScreen
Monthly overview with daily task blocks.

**Layout:**
- Month header with navigation arrows
- 7-column day grid (like iOS Calendar)
- Each day cell shows: task count dot, energy color bar
- Tap day → Expand to show that day's full task list

#### 3. GoalsScreen
Long-term goal tracking with quarterly/monthly breakdown.

**Layout:**
- Goal cards (3 max for clarity):
  - Goal title
  - Target date
  - Progress bar (animated on load)
  - Tasks needed this week badge
- Add Goal button
- Archive completed goals section

#### 4. InsightsScreen
Weekly/monthly analytics dashboard.

**Layout:**
- **Weekly Summary Card:**
  - Tasks completed vs planned (ring chart)
  - Most productive day
  - Total focus hours
  - Streak status

- **Energy Patterns:**
  - Line chart showing your energy curve over the week
  - AI insight: "You focus best before noon. Consider scheduling deep work before 12 PM."

- **AI Weekly Report:**
  - Written summary generated by AI
  - "This week you completed 23 tasks, 15% above your average..."
  - Key achievement highlighted

#### 5. SettingsScreen
User profile and preferences.

**Sections:**
- **Profile:** Name, avatar, timezone
- **Daily Preferences:**
  - Wake time
  - Preferred focus hours
  - Rest break frequency
- **AI Settings:**
  - AI planning aggressiveness (conservative/moderate/aggressive)
  - Auto-regenerate on task completion toggle
- **Appearance:** Dark/Light/System toggle
- **Notifications:** Reminder toggles, quiet hours
- **Data:** Export, iCloud sync toggle
- **Pro Status:** Upgrade button (if free user)

---

## 4. Feature List (50+ Features)

### Core AI Features
1. **AI Daily Planning** — On app open, show today's complete schedule
2. **Energy-Based Scheduling** — Match task energy requirements to predicted energy
3. **Smart Defer** — One-tap defer task to optimal future slot
4. **Dynamic Rescheduling** — When task completes early/late, AI recalculates remaining day
5. **Focus Block Optimization** — Group similar tasks into focus blocks
6. **Conflict Resolution** — When tasks overlap, AI prioritizes and suggests alternatives
7. **Weekly AI Report** — Natural language summary of week's productivity

### Task Management
8. **Quick Add Task** — Natural language input ("Meeting with John at 2pm tomorrow")
9. **Recurring Tasks** — Daily/weekly/monthly with AI smart timing
10. **Subtasks** — Break large tasks into actionable steps
11. **Task Categories** — Work, Personal, Health, Learning, Social
12. **Priority Levels** — P0/P1/P2/P3 with AI-aware scheduling
13. **Time Estimates** — User sets estimate, AI adjusts schedule
14. **Task Dependencies** — "This task must come after that task"

### Focus & Productivity
15. **Pomodoro Timer** — Built-in focus timer with work/break cycles
16. **Focus Mode** — Hide all except current task
17. **Deep Work Blocks** — Protected 2+ hour blocks for important work
18. **Break Reminders** — Smart reminders based on focus duration
19. **Daily Standup** — AI-generated morning plan summary
20. **End-of-Day Review** — What you accomplished, what didn't, why

### Goals & Habits
21. **Goal Setting** — Quarterly/yearly goal with task breakdown
22. **Habit Tracking** — Daily habits with streak counters
23. **Goal Progress** — Visual progress toward milestones
24. **Weekly Goal Reset** — AI suggests next week's goals based on progress
25. **Achievement Badges** — Unlock for milestones (first task, 7-day streak, etc.)

### Calendar & Scheduling
26. **Full Calendar View** — Month/week/day views
27. **Google Calendar Sync** — Import external events (read-only)
28. **Smart Scheduling** — AI finds optimal slots for new tasks
29. **Meeting Buffers** — Auto-add travel/preparation time between tasks
30. **Timezone Support** — For remote workers

### Insights & Analytics
31. **Productivity Score** — Daily score (0-100) based on completed vs planned
32. **Weekly Analytics** — Tasks completed, focus hours, patterns
33. **Energy Pattern Tracking** — When you're most productive
34. **Focus Time Report** — Monthly focus hour trends
35. **Goal Completion Rate** — Rolling percentage
36. **Streak Tracking** — Current streak, longest streak

### Personalization
37. **Dark/Light Themes** — Full support, system-aware
38. **Multiple Languages** — EN (v1), CN (v2), JP (v2)
39. **Widget Support** — Home screen widget showing today's tasks
40. **iCloud Sync** — Seamless across devices
41. **Notification Center** — Today's focus block reminder
42. **Haptic Feedback** — Tactile confirmation on interactions
43. **Dynamic Type** — Accessibility text scaling
44. **Focus Sounds** — Optional ambient background sounds

### Pro Features ($9.99 unlock)
45. **Unlimited Goals** — Free tier: 3 goals, Pro: unlimited
46. **AI Weekly Reports** — Free: 1/month, Pro: unlimited
47. **Advanced Analytics** — Detailed patterns and trends
48. **Custom Categories** — Create own task categories
49. **Priority Support** — Faster response on issues
50. **Early Access** — New features before general release

### System Features
51. **Data Export** — JSON/CSV export of all data
52. **Offline Mode** — Full functionality without internet
53. **Widget** — iOS widget showing next 3 tasks

---

## 5. Technical Specification

### Architecture
- **Pattern:** MVVM + Coordinator
- **UI Framework:** UIKit (programmatic, no Storyboards)
- **Layout:** SnapKit for Auto Layout
- **Reactive:** Combine for data binding
- **Local Storage:** SQLite (via SQLite.swift) for tasks/goals
- **Cloud Sync:** iCloud Key-Value Storage (free) + CloudKit (Pro)

### Dependencies (Swift Package Manager)
```
- SnapKit (layout)
- SQLite.swift (local database)
- KeychainAccess (secure storage)
```

### Key Models
```swift
struct Task {
    let id: UUID
    var title: String
    var notes: String?
    var estimatedMinutes: Int
    var priority: Priority // P0, P1, P2, P3
    var category: Category
    var energyRequired: EnergyLevel // low, medium, high
    var dueDate: Date?
    var recurring: RecurringRule?
    var status: TaskStatus // pending, completed, deferred
    var createdAt: Date
    var completedAt: Date?
}

struct DailySchedule {
    let date: Date
    var taskBlocks: [TaskBlock]
    var energyLevel: Int // 0-100
    var completedTasks: Int
    var totalTasks: Int
}

struct Goal {
    let id: UUID
    var title: String
    var targetDate: Date
    var progress: Double // 0.0 - 1.0
    var linkedTasks: [UUID]
}
```

### AI Planning Algorithm (Simplified)
```
1. Collect all pending tasks for today
2. Fetch user's energy preference pattern
3. Sort tasks by: priority × energy-match × time-constraint
4. Generate time blocks respecting:
   - User's preferred focus hours
   - Meeting slots (from calendar)
   - Break requirements (every 90 min)
5. Output: [TaskBlock] with start/end times
```

---

## 6. Monetization

### Pricing
- **Free Tier:** Core features, 3 goals max, 5 tasks/day AI planning
- **Pro Unlock:** $9.99 (one-time) — unlimited everything, full AI

### Revenue Model
- One-time purchase $9.99 for Pro
- No subscription (PageBrin's preference: clean, no recurring)

---

## 7. Deliverables Checklist

- [ ] SPEC.md — This document
- [ ] project.yml — XcodeGen configuration
- [ ] Sources/App/Info.plist — App configuration
- [ ] Sources/App/AppDelegate.swift — Entry point
- [ ] Sources/App/SceneDelegate.swift — UI lifecycle
- [ ] 5 main screens implemented
- [ ] Dark + Light themes complete
- [ ] 50+ features coded
- [ ] Local SQLite database wired
- [ ] AppStore Listing.md ready
- [ ] PrivacyPolicy.html hosted
- [ ] 1024×1024 App Icon
- [ ] 5 screenshots for App Store
- [ ] Video demo (60 seconds)
