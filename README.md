# لو | What iF ⏳🎓

**A graduation and GPA simulator for Statistics students at King Saud University.**
*Unofficial project, not affiliated with the university.*

🔗 **Live site:** https://farahalosaimi.github.io/whatif

## The problem
Students plan their degree with a PDF study plan and a calculator. It's hard to answer simple questions like:
*When will I graduate? What happens if I postpone a course? What GPA do I need to reach honors?*

## Features

### 📚 Interactive study plan
- Two tracks: Statistics B.Sc. (136 hours) or Statistics + AI minor (156 hours)
- Every course shows its credit hours, its prerequisites, and the courses it unlocks
- Course states: completed, available now, needs a retake, locked
- Tap a course: its prerequisites light up in red and what it unlocks in blue
- "Passed ✓" button marks a whole level as completed in one tap
- Collapsible sections for the first year, core courses, electives and the grade record

### 🧮 GPA & graduation counter
- Cumulative GPA on the KSU 5-point scale, with every retake counted
- Grade label and honors zones (second-class 4.25–4.74, first-class 4.75+)
- Graduation counter: hours left, progress bar by requirement group, and expected graduation term
- Full grade record with all attempts and points

### ✅ Plan rules built in
- Prerequisites for every course
- The whole first year must be completed before level 3
- Outside electives open after completing level 3
- Graduation project needs 43 hours or fewer left
- AI seminar needs 15 minor hours
- One Islamic studies course per term
- 12–20 hours per term

### 🔮 What iF tools
- **What-if scenarios**: postpone a course, fail a course and pick the retake grade, change your term load, add an AI summer term, and compare two plans side by side with a term-by-term timeline
- **GPA tools**: target GPA planner (graduation or next term) with the range of reachable GPAs, and a final-exam calculator for every grade
- **Forecast 🎲**: a Monte Carlo simulation of 1,000 possible futures: probability of graduating on time, of reaching honors and your target, a GPA distribution chart, and graduation-term probabilities

### ⚠️ Smart alerts & 🧭 elective helper
- Alerts for courses that delay many others, the minor finishing after the major, the graduation-project rule, Islamic studies pacing, retakes, newly opened electives, and academic probation
- Suggested electives you can register now, with the reason for each suggestion

### 💬 Course ratings
- Like / dislike, difficulty (easy, medium, hard) and a short comment, with no login
- One rating per course per device, editable later
- Moderation: no instructor names, a profanity filter, and a report button (a comment hides after 3 reports)

### 🌍 Experience
- Arabic / English · Light / Dark · Male / Female wording
- Thmanyah font · auto-save on your device · works on phones

## Database
Course ratings are stored in **Supabase (PostgreSQL)**:
- One `ratings` table, with **Row Level Security** turned on so nobody can read or edit the table directly
- The site only talks to four database functions: `get_stats`, `get_comments`, `rate` and `report`
- A unique constraint guarantees **one rating per course per device**
- Comment length and difficulty values are checked by the database itself
- The setup script is in [`supabase/setup.sql`](supabase/setup.sql)

## The statistics behind the forecast
Each simulated grade = the student's estimated level + a shared random effect + course-level noise, snapped to the KSU grade scale.
With few past grades, the estimate is pulled toward a general average (Bayesian shrinkage).
A failed course is retaken and the whole schedule is rebuilt.

## Built with
HTML · CSS · JavaScript (no frameworks) · Supabase (PostgreSQL) · GitHub Pages
