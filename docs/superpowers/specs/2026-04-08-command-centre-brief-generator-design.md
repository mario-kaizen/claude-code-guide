# Command Centre Brief Generator

**Date:** 2026-04-08
**Location:** `code.kaizencollective.com.au/command-centre`
**Project:** `~/Projects/claude-code-guide/`
**Purpose:** Week 4 Wednesday training call — clients build their own Command Centre + Content Pipeline using a generated Claude Code brief

---

## Context

This is Week 4 of Kaizen's Wednesday training program for clients:

- Week 1: Claude 101 (thinking with Claude)
- Week 2: Cowork (executing with Claude)
- Week 3: Claude Code (building with Claude — design system exercise)
- **Week 4: Command Centre (owning a system)**

Clients now have Claude Code set up with a CLAUDE.md (business context) and a design system on their machine from Week 3. They're still cautious with Code. This session needs to produce a "holy shit I just built that" moment.

The brief generator is an interactive page where clients answer a few questions about their business, and it outputs a single combined Claude Code brief they copy-paste into their terminal. The brief builds:

1. A Command Centre shell (sidebar, navigation, branding, placeholder modules)
2. A Content Pipeline as Module 1 (media library, content calendar, caption generator)

Mario walks them through the page live during the 20-minute teach, they fill it out, then spend ~60 minutes building.

---

## Technical Spec

### Stack

- Static HTML page (matches existing code.kaizencollective.com.au pattern)
- No framework, no build step
- Single file: `command-centre/index.html` in the `claude-code-guide` project
- MLP design system: Dark Forest (`#141F1B`) + Cream (`#F5F0E8`) + Warm Brass (`#BFA278`), Barlow Condensed + DM Sans
- Deployed via existing Docker/nginx setup on Coolify

### Page Structure

#### Hero Section

- Title: "Build Your Command Centre"
- Subtitle: Something like "Your business operating system. Every tool you build from here lives under one roof."
- Brief explanation: This page generates a Claude Code brief tailored to your business. Fill in the details, copy the brief, paste it into Claude Code, and watch it build.

#### Step-by-Step Wizard (Not a Form Dump)

The page walks them through the inputs one section at a time, progressive disclosure style. Each section reveals after the previous one is filled. This keeps the cautious ones from feeling overwhelmed.

**Section 1: Your Business**
- Business name (text input)
- Industry/type (dropdown or pills: Gym, Pilates Studio, Yoga Studio, CrossFit Box, Personal Training, Coaching, Other + free text)
- One-liner description (text input, placeholder: "e.g., Boutique Pilates studio in Bondi specialising in reformer classes")

**Section 2: Content Pillars**
- Instruction text: "Content pillars are the 3-5 themes you always post about. Pick or type yours."
- Pre-populated pill suggestions they can toggle on/off: Transformations, Behind the Scenes, Education/Tips, Community, Promotions, Team/Culture, Client Spotlights, Events
- Custom pillar input (free text, add button)
- Minimum 3, maximum 6

**Section 3: Posting Schedule**
- Platforms (checkboxes): Instagram, Facebook, TikTok, LinkedIn
- Posts per week per platform (number input for each selected platform)
- Best days (optional multi-select per platform, or just "any")

**Section 4: Brand Voice**
- Instruction text: "If you set up your CLAUDE.md in Week 3, your brand voice is already there. Otherwise, describe it here."
- Radio: "It's in my CLAUDE.md" / "Let me describe it"
- If describing: textarea (placeholder: "e.g., Casual, encouraging, uses fitness slang, speaks directly to busy mums")

**Section 5: Future Modules (Sets the Vision)**
- Instruction text: "These won't be built today — but they'll appear in your sidebar as coming soon. What else would you want in your Command Centre?"
- Pre-populated pill suggestions: Bookings Dashboard, Client Tracker, Lead Pipeline, Analytics, Staff Roster, Class Timetable, Financials, Membership Retention
- Custom module input (free text, add button)
- These will render as greyed-out nav items in the sidebar

#### Brief Preview & Copy

Once all sections are filled, the page generates the full Claude Code brief in a styled code block at the bottom.

The brief is a single prompt that:

1. References their existing CLAUDE.md and design system files
2. Creates a Next.js app (or plain HTML/CSS/JS app — see Open Question below)
3. Builds the Command Centre shell:
   - Sticky sidebar with business name, collapsible
   - Active nav item: "Content Pipeline" under a "Marketing" section
   - Greyed-out future modules from Section 5 under appropriate sections
   - Main content area with welcome state
   - Full design system applied (colours, fonts from their Week 3 setup)
4. Builds the Content Pipeline module:
   - Media Library: drag-drop upload zone, grid view with thumbnails, tag by content pillar, search/filter
   - Content Calendar: weekly grid, slots based on their posting schedule, pillar assignment per slot, drag assets from library into slots
   - Caption Generator: select a filled slot, click generate, Claude writes caption in brand voice, platform-specific variations, copy button

**Copy to Clipboard button** — large, prominent, brass-coloured. One click copies the entire brief.

**"Edit Brief" toggle** — lets them see and manually edit the raw brief text before copying. For the confident ones who want to tweak.

---

## Brief Template Structure

The generated brief follows this structure (variables filled from the wizard):

```
I want you to build me a Command Centre — a personal business operating system.

You already have my business context in CLAUDE.md and my design system from our previous session. Use those as the foundation for all styling and brand voice decisions.

## What to Build

### The Shell
- A web application with a sticky sidebar navigation and a main content area
- Sidebar header: "{businessName}" in my brand heading font
- Sidebar should be collapsible (default expanded)
- Navigation structure:
  - **Marketing** (section header)
    - Content Pipeline (active, this is what we're building)
  - **Operations** (section header, greyed out)
    {futureModules mapped under appropriate sections}
  - **Analytics** (section header, greyed out)
- Main area: clean, uses my brand colours and fonts throughout
- Responsive — works on desktop and tablet

### Module 1: Content Pipeline

**Media Library** (tab or section within Content Pipeline)
- Drag-and-drop upload area for images and videos
- Grid view showing thumbnails of uploaded media
- Each asset can be tagged with one or more content pillars: {pillars}
- Filter by pillar, search by filename
- Assets stored locally in the project

**Content Calendar** (tab or section within Content Pipeline)
- Weekly view grid
- Platforms: {platforms}
- Schedule: {schedule breakdown, e.g., "Instagram: Mon, Wed, Fri — 3 posts/week"}
- Each slot shows: assigned pillar, thumbnail if asset attached, caption preview if generated
- Can drag assets from the media library into calendar slots
- Click a slot to assign a pillar and attach an asset

**Caption Generator**
- When a calendar slot has an asset and pillar assigned, show a "Generate Caption" button
- Generate a caption that matches my brand voice {voiceSource — "from CLAUDE.md" or the provided description}
- Generate platform-specific variations for: {platforms}
- Each generated caption has a "Copy" button
- Captions should feel natural, not robotic — match the tone and language style in my brand profile

## Technical Notes
- Use my existing design system (colours, fonts, spacing) — do not introduce new styling
- Keep the file structure clean and organised
- This is a local tool — no deployment needed, just runs on my machine
- Build it so I can add new modules to the sidebar in future sessions
```

---

## Design Details

### MLP Design System Application

| Element | Style |
|---------|-------|
| Page background | Dark Forest `#141F1B` |
| Card/section backgrounds | Forest Light `#1B2E28` |
| Primary accent | Warm Brass `#BFA278` |
| Body text | Cream `#F5F0E8` |
| Muted text | Stone `#8C8778` |
| Headings | Barlow Condensed, semi-bold |
| Body | DM Sans, regular |
| Input fields | Forest Muted `#243D35` background, Cream text, Brass focus ring |
| Pills (selected) | Brass background, Forest text |
| Pills (unselected) | Forest Muted background, Stone text |
| Copy button | Brass background, Forest text, full width, large |
| Code block | Forest Deep `#0D1512` background, monospace, Cream text |

### Interactions

- Progressive disclosure: sections reveal one at a time as previous section is completed
- Pill toggles for content pillars and future modules (click to select/deselect)
- Brief preview updates live as inputs change
- Smooth scroll to brief preview when all sections complete
- Copy button shows "Copied!" confirmation state for 2 seconds
- Edit toggle shows/hides raw brief textarea

### Responsive

- Full width on mobile, max-width ~900px container on desktop
- Pill grids wrap naturally
- Brief code block scrolls horizontally if needed

---

## Open Question: App Framework in the Brief

The generated brief tells Claude Code to build "a web application." For these business owners (not developers), the simplest output is:

**Plain HTML/CSS/JS** — no npm, no build step, just open index.html. This is the safest for cautious users. But it limits complexity (no proper component system, no routing, media library harder to implement).

**Next.js** — Mario's Command Centre uses this, and they already have Node.js installed from Week 3 setup. More capable, matches the vision of where they're heading. But adds `npm install` and `npm run dev` steps.

**Recommendation:** The brief should generate a **Next.js app** since they installed Node.js in Week 3, and it sets them up for all future modules. The brief includes the `npm install && npm run dev` instruction so they know what to run. Claude Code handles the scaffolding — they don't need to understand the framework, just trust the build.

---

## Deployment

- New file: `command-centre/index.html` added to the `claude-code-guide` project
- Nginx config in the existing Dockerfile may need a route for `/command-centre`
- Push to main triggers auto-deploy via Coolify
- No database, no API, no server-side logic — pure client-side page

---

## Session Flow (For Mario's Reference)

| Time | Activity |
|------|----------|
| 0-5 min | Mario shows his Command Centre (screen share). "This is what's possible." |
| 5-15 min | Walk through the brief generator page together. Explain each section. |
| 15-20 min | Everyone fills out their details, generates their brief, copies it. |
| 20-25 min | Paste brief into Claude Code. Watch the shell build. |
| 25-35 min | Shell complete — open in browser. First "holy shit" moment. |
| 35-70 min | Content Pipeline builds. Upload a test photo. Generate a caption. |
| 70-80 min | Show off — volunteers share their screen. |
| 80-90 min | Point at the greyed-out modules. "Next week, we light up another one." |

---

## Success Criteria

- Every attendee leaves with a working Command Centre running locally
- The Content Pipeline module has functional media upload, calendar view, and caption generation
- They can see their own brand (colours, fonts, name) throughout the app
- The sidebar shows future modules — they can visualise the growth path
- The brief generator page is reusable — they could run it again or share it with someone who missed the session
