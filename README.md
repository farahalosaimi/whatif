# لو | What iF ⏳🎓

**A graduation and GPA simulator for students of the Statistics & Operations Research Department at King Saud University.**
*Unofficial project, not affiliated with the university.*

🔗 **Live site:** https://farahalosaimi.github.io/whatif

## The problem
Students plan their degree with a PDF study plan and a calculator. It's hard to answer simple questions like:
*When will I graduate? What happens if I postpone a course? What GPA do I need to reach honors?*

## Features

### 📚 Interactive study plans
- Two majors: **Statistics** and **Operations Research** (136 hours each), each with an optional **AI minor** (156 hours)
- Operations Research is shown to male students only, as offered by the department
- Every course shows its credit hours, its prerequisites, and the courses it unlocks
- Course states: completed, available now, registered this term, needs a retake, locked
- Tap a course: its prerequisites light up in red and what it unlocks in blue
- "Passed ✓" marks a whole level as completed in one tap; "Registered this term ✓" counts a course as done before next term for a sharper estimate
- Special cases from the registrar: **prerequisite bypassed**, **alternative exam** (counted as passed, outside the GPA until the grade is out) and **approved concurrent enrollment** (a course and its prerequisite in the same term)

### 🧮 GPA & graduation counter
- Cumulative GPA on the KSU 5-point scale, with every retake counted
- Grade label and honors zones (second-class 4.25–4.74, first-class 4.75+)
- Graduation counter: hours left, progress bar by requirement group, and expected graduation term
- Compact grade record with all attempts and points

### ✅ Plan rules built in
- Prerequisites and co-requisites for every course
- Direct admission: department courses open after STAT 101, MATH 101 and CT 101 (with a GPA alert under 3.25)
- Department electives open once their prerequisites are passed; outside electives after completing level 3
- Graduation project needs 43 hours or fewer left
- AI seminar needs 15 minor hours
- One Islamic studies course per term
- 12–20 hours per term

### 🧭 Suggested for you & ⚠️ alerts
- A highlighted box with the courses to register next term, electives included
- **Delay alerts**: compares your progress with the official plan from your first term, tells you what to register, which courses not to postpone, and whether a heavier load helps
- A red warning when a student reaches the 12-term maximum study period
- Alerts for courses that delay many others, the minor finishing after the major, the graduation-project rule, Islamic studies pacing, retakes, newly opened electives, and academic probation

### 🔮 What iF tools
- **What-if scenarios**: postpone a course, fail a course and pick the retake grade, change your term load, add an AI summer term, and compare two plans side by side with a term-by-term timeline
- **GPA tools**: target GPA planner (graduation or next term) with the range of reachable GPAs, and a final-exam calculator for every grade
- **Forecast 🎲**: a Monte Carlo simulation of 1,000 possible futures: probability of graduating on time, of reaching honors and your target, a GPA distribution chart, and graduation-term probabilities

### 💬 Course ratings
- A separate page open to everyone, no plan or login needed
- Smart search by Arabic or English name, course code, number only, or initials (e.g. "LP"), with similar courses suggested
- Average difficulty bar and number of ratings, comments sortable by newest, liked first or hardest first
- One rating per course per device, editable later
- Moderation: no instructor names, a profanity filter, and a report button (a comment hides after 5 reports)

### 🤖 What iF assistant
- A chat assistant that answers from the student's own plan: prerequisites, hours left, GPA, what to register, project eligibility, target GPA, delay status and course ratings
- Plus answers to common questions (admission, alternative exams, bypass, concurrency, electives, summer, maximum study period)
- Runs entirely in the browser, no AI service and no data sent anywhere

### 🌍 Experience
- Arabic / English · Light / Dark · Male / Female wording
- First-visit tips · Thmanyah font · auto-save on your device · works on phones

## Database
Course ratings are stored in **Supabase (PostgreSQL)**:
- One `ratings` table, with **Row Level Security** turned on so nobody can read or edit the table directly
- The site only talks to database functions: `get_stats`, `get_comments`, `rate`, `report` and `backup_ratings`
- A unique constraint guarantees **one rating per course per device**
- Comment length and difficulty values are checked by the database itself
- **Automatic backup**: a GitHub Action runs every 3 days, keeps the database awake and saves all ratings to [`backups/ratings.json`](backups/ratings.json); if the database can't be reached, the site shows this backup read-only
- Scripts: [`supabase/setup.sql`](supabase/setup.sql) and [`supabase/update-2.sql`](supabase/update-2.sql)

## The statistics behind the forecast
Each simulated grade = the student's estimated level + a shared random effect + course-level noise, snapped to the KSU grade scale.
With few past grades, the estimate is pulled toward a general average (Bayesian shrinkage).
A failed course is retaken and the whole schedule is rebuilt.

## Contact
Problems, suggestions or questions: **whatif.ksu@gmail.com**

## Built with
HTML · CSS · JavaScript (no frameworks) · Supabase (PostgreSQL) · GitHub Actions · GitHub Pages
