# Command Centre Brief Generator — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an interactive brief generator page at `code.kaizencollective.com.au/command-centre` that walks Kaizen clients through a wizard and outputs a tailored Claude Code brief for building their own Command Centre + Content Pipeline.

**Architecture:** Single static HTML file (`command-centre/index.html`) with inline CSS and JavaScript. Progressive disclosure wizard collects business details across 5 sections, then generates and displays a Claude Code brief with copy-to-clipboard. MLP design system (Dark Forest + Cream + Warm Brass, Barlow Condensed + DM Sans). Deployed via existing Docker/nginx on Coolify.

**Tech Stack:** HTML, CSS, vanilla JavaScript, nginx (Docker), Coolify auto-deploy on push to main.

**Spec:** `docs/superpowers/specs/2026-04-08-command-centre-brief-generator-design.md`

**Reference:** The existing `index.html` in this project is the Week 3 Claude Code guide — use it as a reference for code style, CSS patterns, and JavaScript conventions. The new page uses a DIFFERENT design system (MLP Dark Forest, not Kaizen ink/cream/gold) but follows similar structural patterns.

---

### Task 1: Scaffold page with Dockerfile routing

**Files:**
- Create: `command-centre/index.html`
- Modify: `Dockerfile`

- [ ] **Step 1: Create the directory and empty HTML shell**

Create `command-centre/index.html` with the DOCTYPE, html/head/body structure, meta tags, Google Fonts links for Barlow Condensed (weights 300,400,500,600,700) and DM Sans (weights 300,400,500,600), and the page title "Build Your Command Centre | Kaizen Collective".

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
<title>Build Your Command Centre | Kaizen Collective</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@300;400;500;600;700&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&display=swap" rel="stylesheet">
<style>
  /* CSS will be added in Task 2 */
</style>
</head>
<body>
  <!-- Content will be added in Tasks 3-7 -->
  <script>
    // JavaScript will be added in Task 8
  </script>
</body>
</html>
```

- [ ] **Step 2: Update Dockerfile to serve the command-centre directory**

The current Dockerfile only copies `index.html` and `img/`. Update it to also copy the `command-centre/` directory so nginx can serve it at `/command-centre/`.

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY img/ /usr/share/nginx/html/img/
COPY command-centre/ /usr/share/nginx/html/command-centre/
EXPOSE 80
```

nginx serves `index.html` from directories automatically, so `code.kaizencollective.com.au/command-centre/` will serve `command-centre/index.html` without custom config.

- [ ] **Step 3: Commit**

```bash
git add command-centre/index.html Dockerfile
git commit -m "feat: scaffold command-centre page and update Dockerfile routing"
```

---

### Task 2: CSS foundation — MLP design system variables and base styles

**Files:**
- Modify: `command-centre/index.html` (the `<style>` block)

- [ ] **Step 1: Add CSS custom properties and reset**

Add all MLP design system variables and base reset styles inside the `<style>` tag. Reference the spec's design table for exact values.

```css
:root {
  /* MLP Design System */
  --forest: #141F1B;
  --forest-deep: #0D1512;
  --forest-light: #1B2E28;
  --forest-muted: #243D35;
  --brass: #BFA278;
  --brass-dark: #9E8560;
  --brass-light: #DDD0BC;
  --cream: #F5F0E8;
  --warm-white: #FAF7F2;
  --sage: #7A9E8C;
  --stone: #8C8778;
  --parchment: #EDE8DC;
  --red: #C45B4A;
  --green: #5A9E6F;
  --amber: #C4964A;

  --font-heading: 'Barlow Condensed', sans-serif;
  --font-body: 'DM Sans', -apple-system, sans-serif;
}

* { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }

body {
  font-family: var(--font-body);
  background: var(--forest);
  color: var(--cream);
  font-size: 16px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
}
```

- [ ] **Step 2: Add layout, typography, and animation utilities**

```css
/* Layout */
.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 0 40px;
}

/* Typography */
h1, h2, h3 {
  font-family: var(--font-heading);
  font-weight: 600;
  letter-spacing: -0.01em;
}

/* Animations */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Section base */
.wizard-section {
  padding: 60px 0;
  border-bottom: 1px solid var(--forest-muted);
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.5s ease, transform 0.5s ease;
  pointer-events: none;
}

.wizard-section.active {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

.wizard-section.locked {
  opacity: 0.3;
  filter: blur(2px);
  pointer-events: none;
}
```

- [ ] **Step 3: Add form element styles**

```css
/* Inputs */
input[type="text"],
input[type="number"],
textarea {
  width: 100%;
  background: var(--forest-muted);
  border: 1px solid transparent;
  color: var(--cream);
  font-family: var(--font-body);
  font-size: 15px;
  padding: 14px 18px;
  border-radius: 0;
  outline: none;
  transition: border-color 0.2s ease;
}

input[type="text"]:focus,
input[type="number"]:focus,
textarea:focus {
  border-color: var(--brass);
}

input::placeholder,
textarea::placeholder {
  color: var(--stone);
  font-weight: 300;
}

textarea {
  min-height: 100px;
  resize: vertical;
}

/* Pills */
.pill-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 16px;
}

.pill {
  background: var(--forest-muted);
  color: var(--stone);
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 500;
  padding: 10px 20px;
  border: 1px solid transparent;
  cursor: pointer;
  transition: all 0.2s ease;
  user-select: none;
}

.pill.selected {
  background: var(--brass);
  color: var(--forest);
  border-color: var(--brass);
}

.pill:hover:not(.selected) {
  border-color: var(--stone);
}

/* Section headers */
.section-eyebrow {
  font-family: var(--font-body);
  font-size: 11px;
  letter-spacing: 0.25em;
  text-transform: uppercase;
  color: var(--brass);
  font-weight: 600;
  margin-bottom: 12px;
}

.section-heading {
  font-family: var(--font-heading);
  font-size: clamp(24px, 3vw, 32px);
  font-weight: 600;
  color: var(--cream);
  margin-bottom: 8px;
}

.section-desc {
  font-size: 15px;
  color: var(--stone);
  font-weight: 300;
  line-height: 1.75;
  max-width: 700px;
  margin-bottom: 32px;
}

/* Form groups */
.form-group {
  margin-bottom: 24px;
}

.form-label {
  display: block;
  font-family: var(--font-body);
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--brass-light);
  margin-bottom: 8px;
}

/* Platform row */
.platform-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 0;
  border-bottom: 1px solid var(--forest-muted);
}

.platform-check {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  user-select: none;
  min-width: 140px;
}

.platform-check input[type="checkbox"] {
  appearance: none;
  width: 20px;
  height: 20px;
  background: var(--forest-muted);
  border: 1px solid var(--stone);
  cursor: pointer;
  position: relative;
}

.platform-check input[type="checkbox"]:checked {
  background: var(--brass);
  border-color: var(--brass);
}

.platform-check input[type="checkbox"]:checked::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 12px;
  color: var(--forest);
  font-weight: 700;
}

.platform-count {
  display: flex;
  align-items: center;
  gap: 8px;
  opacity: 0.3;
  transition: opacity 0.2s ease;
}

.platform-count.enabled {
  opacity: 1;
}

.platform-count input[type="number"] {
  width: 60px;
  text-align: center;
  padding: 8px;
}

.platform-count span {
  font-size: 13px;
  color: var(--stone);
}

/* Radio */
.radio-group {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 14px;
  color: var(--cream);
}

.radio-option input[type="radio"] {
  appearance: none;
  width: 18px;
  height: 18px;
  border: 2px solid var(--stone);
  border-radius: 50%;
  cursor: pointer;
  position: relative;
}

.radio-option input[type="radio"]:checked {
  border-color: var(--brass);
}

.radio-option input[type="radio"]:checked::after {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 8px;
  height: 8px;
  background: var(--brass);
  border-radius: 50%;
}

/* Custom pill input */
.custom-pill-input {
  display: flex;
  gap: 8px;
  margin-top: 16px;
}

.custom-pill-input input {
  flex: 1;
}

.custom-pill-input button {
  background: var(--forest-muted);
  color: var(--brass);
  border: 1px solid var(--brass);
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 600;
  padding: 10px 24px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.custom-pill-input button:hover {
  background: var(--brass);
  color: var(--forest);
}
```

- [ ] **Step 4: Add brief output and copy button styles**

```css
/* Brief output */
.brief-output {
  margin-top: 40px;
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.brief-output.visible {
  opacity: 1;
  transform: translateY(0);
}

.brief-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.brief-header h2 {
  font-family: var(--font-heading);
  font-size: 28px;
  color: var(--cream);
}

.brief-toggle {
  background: none;
  border: 1px solid var(--stone);
  color: var(--stone);
  font-family: var(--font-body);
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  padding: 8px 16px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.brief-toggle:hover {
  border-color: var(--cream);
  color: var(--cream);
}

.brief-preview {
  background: var(--forest-deep);
  padding: 32px;
  font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
  font-size: 13px;
  line-height: 1.7;
  color: var(--cream);
  white-space: pre-wrap;
  word-wrap: break-word;
  max-height: 600px;
  overflow-y: auto;
  border: 1px solid var(--forest-muted);
}

.brief-preview .brief-heading {
  color: var(--brass);
  font-weight: 600;
}

.brief-preview .brief-subheading {
  color: var(--brass-light);
  font-weight: 500;
}

.brief-textarea {
  display: none;
  width: 100%;
  min-height: 500px;
  background: var(--forest-deep);
  border: 1px solid var(--brass);
  color: var(--cream);
  font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
  font-size: 13px;
  line-height: 1.7;
  padding: 32px;
  resize: vertical;
  outline: none;
}

.brief-textarea.visible {
  display: block;
}

.copy-btn {
  width: 100%;
  background: var(--brass);
  color: var(--forest);
  font-family: var(--font-heading);
  font-size: 18px;
  font-weight: 600;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  padding: 20px;
  border: none;
  cursor: pointer;
  margin-top: 24px;
  transition: all 0.2s ease;
}

.copy-btn:hover {
  background: var(--brass-light);
}

.copy-btn.copied {
  background: var(--green);
  color: var(--cream);
}
```

- [ ] **Step 5: Add responsive styles**

```css
/* Responsive */
@media (max-width: 640px) {
  .container { padding: 0 20px; }
  .wizard-section { padding: 40px 0; }
  .platform-row { flex-direction: column; align-items: flex-start; gap: 8px; }
  .radio-group { flex-direction: column; }
  .brief-preview { padding: 20px; font-size: 12px; }
  .brief-header { flex-direction: column; gap: 12px; align-items: flex-start; }
}
```

- [ ] **Step 6: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add MLP design system CSS foundation for command-centre page"
```

---

### Task 3: Hero section HTML

**Files:**
- Modify: `command-centre/index.html` (the `<body>` section)

- [ ] **Step 1: Add the hero section**

Add the hero section inside `<body>`, before the `<script>` tag. This follows the same hero pattern from the existing `index.html` but uses MLP design system colours.

```html
<div class="hero">
  <div class="hero-content">
    <div class="hero-eyebrow">Session 4 · Build</div>
    <h1 class="hero-title">Build Your<br><em>Command Centre</em></h1>
    <p class="hero-subtitle">Your business operating system. Every tool you build from here lives under one roof. Fill in the details below, copy the brief, paste it into Claude Code.</p>
    <div class="hero-line"></div>
    <div class="hero-session">Week 4 · Wednesday Training</div>
  </div>
</div>
```

- [ ] **Step 2: Add hero CSS**

Add to the `<style>` block:

```css
/* Hero */
.hero {
  min-height: 70vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 80px 40px;
  background: var(--forest-deep);
  position: relative;
  overflow: hidden;
}

.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 60% 50% at 70% 20%, rgba(191,162,120,0.06) 0%, transparent 70%),
    radial-gradient(ellipse 50% 60% at 20% 80%, rgba(191,162,120,0.04) 0%, transparent 70%);
  pointer-events: none;
}

.hero-content { position: relative; z-index: 1; }

.hero-eyebrow {
  font-family: var(--font-body);
  font-size: 11px;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  color: var(--brass);
  margin-bottom: 36px;
  font-weight: 500;
  opacity: 0;
  animation: slideUp 0.7s ease 0.2s forwards;
}

.hero-title {
  font-family: var(--font-heading);
  font-size: clamp(40px, 5.5vw, 72px);
  font-weight: 600;
  color: var(--cream);
  line-height: 1.05;
  margin-bottom: 24px;
  letter-spacing: -0.02em;
  opacity: 0;
  animation: slideUp 0.7s ease 0.4s forwards;
}

.hero-title em {
  font-style: normal;
  color: var(--brass);
}

.hero-subtitle {
  font-family: var(--font-body);
  font-size: 17px;
  color: var(--stone);
  max-width: 520px;
  margin: 0 auto 48px;
  font-weight: 300;
  line-height: 1.75;
  opacity: 0;
  animation: slideUp 0.7s ease 0.6s forwards;
}

.hero-line {
  width: 48px;
  height: 1px;
  background: var(--brass);
  margin: 0 auto 32px;
  opacity: 0;
  animation: slideUp 0.5s ease 0.8s forwards;
}

.hero-session {
  font-family: var(--font-body);
  font-size: 12px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--stone);
  font-weight: 500;
  opacity: 0;
  animation: slideUp 0.5s ease 1s forwards;
}
```

- [ ] **Step 3: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add hero section for command-centre page"
```

---

### Task 4: Wizard sections 1-2 (Business details + Content pillars)

**Files:**
- Modify: `command-centre/index.html` (add HTML after hero, before `<script>`)

- [ ] **Step 1: Add Section 1 — Your Business**

```html
<div class="container">

  <!-- SECTION 1: YOUR BUSINESS -->
  <div class="wizard-section active" id="section-1">
    <div class="section-eyebrow">Step 1</div>
    <h2 class="section-heading">Your Business</h2>
    <p class="section-desc">The basics. Claude Code already has your CLAUDE.md, but the brief needs to know what to name things and where to focus.</p>

    <div class="form-group">
      <label class="form-label" for="business-name">Business Name</label>
      <input type="text" id="business-name" placeholder="e.g., Peak Performance Fitness" oninput="checkSection1()">
    </div>

    <div class="form-group">
      <label class="form-label">Industry</label>
      <div class="pill-grid" id="industry-pills">
        <div class="pill" onclick="selectIndustry(this)">Gym</div>
        <div class="pill" onclick="selectIndustry(this)">Pilates Studio</div>
        <div class="pill" onclick="selectIndustry(this)">Yoga Studio</div>
        <div class="pill" onclick="selectIndustry(this)">CrossFit Box</div>
        <div class="pill" onclick="selectIndustry(this)">Personal Training</div>
        <div class="pill" onclick="selectIndustry(this)">Coaching</div>
        <div class="pill" onclick="selectIndustry(this)">Other</div>
      </div>
      <div class="custom-pill-input" id="industry-custom" style="display: none; margin-top: 12px;">
        <input type="text" id="industry-custom-input" placeholder="Your industry...">
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="business-desc">One-liner Description</label>
      <input type="text" id="business-desc" placeholder="e.g., Boutique Pilates studio in Bondi specialising in reformer classes" oninput="checkSection1()">
    </div>
  </div>

  <!-- SECTION 2: CONTENT PILLARS -->
  <div class="wizard-section locked" id="section-2">
    <div class="section-eyebrow">Step 2</div>
    <h2 class="section-heading">Content Pillars</h2>
    <p class="section-desc">The 3-6 themes you always come back to when you post. Pick from the suggestions or add your own.</p>

    <div class="pill-grid" id="pillar-pills">
      <div class="pill" onclick="togglePillar(this)">Transformations</div>
      <div class="pill" onclick="togglePillar(this)">Behind the Scenes</div>
      <div class="pill" onclick="togglePillar(this)">Education / Tips</div>
      <div class="pill" onclick="togglePillar(this)">Community</div>
      <div class="pill" onclick="togglePillar(this)">Promotions</div>
      <div class="pill" onclick="togglePillar(this)">Team / Culture</div>
      <div class="pill" onclick="togglePillar(this)">Client Spotlights</div>
      <div class="pill" onclick="togglePillar(this)">Events</div>
    </div>

    <div class="custom-pill-input">
      <input type="text" id="custom-pillar" placeholder="Add a custom pillar..." onkeydown="if(event.key==='Enter')addCustomPillar()">
      <button onclick="addCustomPillar()">Add</button>
    </div>

    <div class="pillar-count" id="pillar-count" style="margin-top: 16px; font-size: 13px; color: var(--stone);">
      0 selected — pick at least 3
    </div>
  </div>

</div>
```

- [ ] **Step 2: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add wizard sections 1-2 (business details + content pillars)"
```

---

### Task 5: Wizard sections 3-5 (Posting schedule + Brand voice + Future modules)

**Files:**
- Modify: `command-centre/index.html` (add HTML inside `.container`, after section-2, before closing `</div>`)

- [ ] **Step 1: Add Section 3 — Posting Schedule**

Add inside the `.container` div, after section-2:

```html
  <!-- SECTION 3: POSTING SCHEDULE -->
  <div class="wizard-section locked" id="section-3">
    <div class="section-eyebrow">Step 3</div>
    <h2 class="section-heading">Posting Schedule</h2>
    <p class="section-desc">Which platforms do you post on, and how often? This builds your content calendar slots.</p>

    <div id="platforms">
      <div class="platform-row">
        <label class="platform-check">
          <input type="checkbox" onchange="togglePlatform('instagram', this.checked)">
          <span>Instagram</span>
        </label>
        <div class="platform-count" id="platform-instagram">
          <input type="number" min="1" max="14" value="3" id="count-instagram" oninput="checkSection3()">
          <span>posts/week</span>
        </div>
      </div>
      <div class="platform-row">
        <label class="platform-check">
          <input type="checkbox" onchange="togglePlatform('facebook', this.checked)">
          <span>Facebook</span>
        </label>
        <div class="platform-count" id="platform-facebook">
          <input type="number" min="1" max="14" value="3" id="count-facebook" oninput="checkSection3()">
          <span>posts/week</span>
        </div>
      </div>
      <div class="platform-row">
        <label class="platform-check">
          <input type="checkbox" onchange="togglePlatform('tiktok', this.checked)">
          <span>TikTok</span>
        </label>
        <div class="platform-count" id="platform-tiktok">
          <input type="number" min="1" max="14" value="3" id="count-tiktok" oninput="checkSection3()">
          <span>posts/week</span>
        </div>
      </div>
      <div class="platform-row">
        <label class="platform-check">
          <input type="checkbox" onchange="togglePlatform('linkedin', this.checked)">
          <span>LinkedIn</span>
        </label>
        <div class="platform-count" id="platform-linkedin">
          <input type="number" min="1" max="14" value="2" id="count-linkedin" oninput="checkSection3()">
          <span>posts/week</span>
        </div>
      </div>
    </div>
  </div>

  <!-- SECTION 4: BRAND VOICE -->
  <div class="wizard-section locked" id="section-4">
    <div class="section-eyebrow">Step 4</div>
    <h2 class="section-heading">Brand Voice</h2>
    <p class="section-desc">Your captions need to sound like you. If you set up your CLAUDE.md in Week 3, your voice is already saved. Otherwise, describe it here.</p>

    <div class="radio-group">
      <label class="radio-option">
        <input type="radio" name="voice" value="claudemd" checked onchange="handleVoiceChange()">
        <span>It's in my CLAUDE.md</span>
      </label>
      <label class="radio-option">
        <input type="radio" name="voice" value="describe" onchange="handleVoiceChange()">
        <span>Let me describe it</span>
      </label>
    </div>

    <div id="voice-textarea-wrap" style="display: none;">
      <textarea id="voice-desc" placeholder="e.g., Casual, encouraging, uses fitness slang, speaks directly to busy mums who want to feel strong. Short punchy sentences. Never corporate." oninput="checkSection4()"></textarea>
    </div>
  </div>

  <!-- SECTION 5: FUTURE MODULES -->
  <div class="wizard-section locked" id="section-5">
    <div class="section-eyebrow">Step 5</div>
    <h2 class="section-heading">Future Modules</h2>
    <p class="section-desc">These won't be built today. But they'll show up in your sidebar as "coming soon" so you can see where this is heading. What else would live in your Command Centre?</p>

    <div class="pill-grid" id="module-pills">
      <div class="pill" onclick="toggleModule(this)">Bookings Dashboard</div>
      <div class="pill" onclick="toggleModule(this)">Client Tracker</div>
      <div class="pill" onclick="toggleModule(this)">Lead Pipeline</div>
      <div class="pill" onclick="toggleModule(this)">Analytics</div>
      <div class="pill" onclick="toggleModule(this)">Staff Roster</div>
      <div class="pill" onclick="toggleModule(this)">Class Timetable</div>
      <div class="pill" onclick="toggleModule(this)">Financials</div>
      <div class="pill" onclick="toggleModule(this)">Membership Retention</div>
    </div>

    <div class="custom-pill-input">
      <input type="text" id="custom-module" placeholder="Add a custom module..." onkeydown="if(event.key==='Enter')addCustomModule()">
      <button onclick="addCustomModule()">Add</button>
    </div>
  </div>
```

- [ ] **Step 2: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add wizard sections 3-5 (schedule, voice, future modules)"
```

---

### Task 6: Brief output section HTML

**Files:**
- Modify: `command-centre/index.html` (add HTML inside `.container`, after section-5)

- [ ] **Step 1: Add the brief output section**

Add inside `.container`, after section-5, before the closing `</div>` of container:

```html
  <!-- BRIEF OUTPUT -->
  <div class="brief-output" id="brief-output">
    <div style="padding: 80px 0;">
      <div class="brief-header">
        <h2>Your Brief</h2>
        <button class="brief-toggle" onclick="toggleEdit()">Edit Brief</button>
      </div>

      <div class="brief-preview" id="brief-preview"></div>
      <textarea class="brief-textarea" id="brief-textarea"></textarea>

      <button class="copy-btn" id="copy-btn" onclick="copyBrief()">
        Copy Brief to Clipboard
      </button>

      <p style="text-align: center; margin-top: 20px; font-size: 14px; color: var(--stone); font-weight: 300;">
        Paste this into Claude Code and hit enter. Then watch it build.
      </p>
    </div>
  </div>

</div> <!-- end .container -->

<!-- Footer -->
<div class="footer">
  <span class="footer-brand">Kaizen Collective</span>
  <p>Command Centre Builder · 2026</p>
</div>
```

- [ ] **Step 2: Add footer CSS**

```css
.footer {
  text-align: center;
  padding: 60px 40px;
  border-top: 1px solid var(--forest-muted);
}

.footer-brand {
  font-family: var(--font-heading);
  font-size: 14px;
  letter-spacing: 0.08em;
  color: var(--brass);
  font-weight: 500;
}

.footer p {
  font-size: 12px;
  color: var(--stone);
  margin-top: 8px;
}
```

- [ ] **Step 3: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add brief output section and footer"
```

---

### Task 7: JavaScript — wizard logic, validation, and progressive disclosure

**Files:**
- Modify: `command-centre/index.html` (the `<script>` block)

- [ ] **Step 1: Add state management and section unlock logic**

Replace the empty `<script>` tag content with:

```javascript
// ============================================
// STATE
// ============================================
const state = {
  businessName: '',
  industry: '',
  businessDesc: '',
  pillars: [],
  platforms: {},
  voiceSource: 'claudemd',
  voiceDesc: '',
  futureModules: []
};

// ============================================
// SECTION 1: BUSINESS
// ============================================
function selectIndustry(pill) {
  document.querySelectorAll('#industry-pills .pill').forEach(p => p.classList.remove('selected'));
  pill.classList.add('selected');
  state.industry = pill.textContent.trim();

  const customWrap = document.getElementById('industry-custom');
  if (state.industry === 'Other') {
    customWrap.style.display = 'flex';
    document.getElementById('industry-custom-input').focus();
  } else {
    customWrap.style.display = 'none';
  }
  checkSection1();
}

function checkSection1() {
  state.businessName = document.getElementById('business-name').value.trim();
  state.businessDesc = document.getElementById('business-desc').value.trim();

  if (state.industry === 'Other') {
    state.industry = document.getElementById('industry-custom-input').value.trim() || 'Other';
  }

  if (state.businessName && state.industry && state.businessDesc) {
    unlockSection(2);
  }
}

// ============================================
// SECTION 2: PILLARS
// ============================================
function togglePillar(pill) {
  pill.classList.toggle('selected');
  updatePillars();
}

function addCustomPillar() {
  const input = document.getElementById('custom-pillar');
  const val = input.value.trim();
  if (!val) return;

  const grid = document.getElementById('pillar-pills');
  const newPill = document.createElement('div');
  newPill.className = 'pill selected';
  newPill.textContent = val;
  newPill.onclick = function() { togglePillar(this); };
  grid.appendChild(newPill);
  input.value = '';
  updatePillars();
}

function updatePillars() {
  const selected = document.querySelectorAll('#pillar-pills .pill.selected');
  state.pillars = Array.from(selected).map(p => p.textContent.trim());
  const countEl = document.getElementById('pillar-count');
  const n = state.pillars.length;

  if (n < 3) {
    countEl.textContent = n + ' selected — pick at least 3';
    countEl.style.color = 'var(--stone)';
  } else if (n > 6) {
    countEl.textContent = n + ' selected — max 6 recommended';
    countEl.style.color = 'var(--amber)';
  } else {
    countEl.textContent = n + ' selected ✓';
    countEl.style.color = 'var(--green)';
    unlockSection(3);
  }
}

// ============================================
// SECTION 3: PLATFORMS
// ============================================
function togglePlatform(platform, checked) {
  const countEl = document.getElementById('platform-' + platform);
  if (checked) {
    countEl.classList.add('enabled');
    state.platforms[platform] = parseInt(document.getElementById('count-' + platform).value) || 3;
  } else {
    countEl.classList.remove('enabled');
    delete state.platforms[platform];
  }
  checkSection3();
}

function checkSection3() {
  // Update counts in state
  Object.keys(state.platforms).forEach(p => {
    state.platforms[p] = parseInt(document.getElementById('count-' + p).value) || 3;
  });

  if (Object.keys(state.platforms).length > 0) {
    unlockSection(4);
  }
}

// ============================================
// SECTION 4: BRAND VOICE
// ============================================
function handleVoiceChange() {
  const val = document.querySelector('input[name="voice"]:checked').value;
  state.voiceSource = val;
  const wrap = document.getElementById('voice-textarea-wrap');

  if (val === 'describe') {
    wrap.style.display = 'block';
    document.getElementById('voice-desc').focus();
  } else {
    wrap.style.display = 'none';
    unlockSection(5);
  }
  checkSection4();
}

function checkSection4() {
  state.voiceDesc = document.getElementById('voice-desc').value.trim();
  if (state.voiceSource === 'claudemd' || state.voiceDesc.length > 10) {
    unlockSection(5);
  }
}

// ============================================
// SECTION 5: FUTURE MODULES
// ============================================
function toggleModule(pill) {
  pill.classList.toggle('selected');
  updateModules();
}

function addCustomModule() {
  const input = document.getElementById('custom-module');
  const val = input.value.trim();
  if (!val) return;

  const grid = document.getElementById('module-pills');
  const newPill = document.createElement('div');
  newPill.className = 'pill selected';
  newPill.textContent = val;
  newPill.onclick = function() { toggleModule(this); };
  grid.appendChild(newPill);
  input.value = '';
  updateModules();
}

function updateModules() {
  const selected = document.querySelectorAll('#module-pills .pill.selected');
  state.futureModules = Array.from(selected).map(p => p.textContent.trim());
  generateBrief();
}

// ============================================
// SECTION UNLOCK / PROGRESSIVE DISCLOSURE
// ============================================
function unlockSection(num) {
  const section = document.getElementById('section-' + num);
  if (!section) return;
  if (section.classList.contains('active')) return;

  section.classList.remove('locked');
  section.classList.add('active');

  // Smooth scroll to the newly unlocked section
  setTimeout(() => {
    section.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }, 100);

  // If section 5 is unlocked, also trigger brief generation on any change
  if (num === 5) {
    generateBrief();
  }
}
```

- [ ] **Step 2: Add brief generation function**

Append to the `<script>` block:

```javascript
// ============================================
// BRIEF GENERATION
// ============================================
function generateBrief() {
  // Don't generate until section 5 is active
  const s5 = document.getElementById('section-5');
  if (!s5 || !s5.classList.contains('active')) return;

  const platformLines = Object.entries(state.platforms).map(([p, count]) => {
    const name = p.charAt(0).toUpperCase() + p.slice(1);
    return '  - ' + name + ': ' + count + ' posts/week';
  }).join('\n');

  const pillarList = state.pillars.join(', ');

  const voiceLine = state.voiceSource === 'claudemd'
    ? 'Use the brand voice defined in my CLAUDE.md'
    : 'Brand voice: ' + state.voiceDesc;

  const moduleCategories = categoriseModules(state.futureModules);
  const moduleLines = buildModuleNavLines(moduleCategories);

  const brief = `I want you to build me a Command Centre — a personal business operating system called "${state.businessName} Command Centre".

You already have my business context in CLAUDE.md and my design system from our previous session. Use those as the foundation for all styling and brand voice decisions.

My business: ${state.businessName} — ${state.businessDesc} (${state.industry})

## What to Build

### The Shell
Build a Next.js application with a sticky sidebar navigation and a main content area.

- Sidebar header: "${state.businessName}" in my brand heading font
- Sidebar should be collapsible (default expanded)
- Navigation structure:
  - **Marketing** (section header)
    - Content Pipeline (active — this is what we're building today)
${moduleLines}
- Main area: clean layout using my brand colours and fonts throughout
- Responsive — works on desktop and tablet
- Run \`npm install\` then \`npm run dev\` so I can see it in my browser

### Module 1: Content Pipeline

Build this as the main page of the app. It has three tabs or sections:

**Media Library**
- Drag-and-drop upload area for images and videos
- Grid view showing thumbnails of uploaded media
- Each asset can be tagged with one or more content pillars: ${pillarList}
- Filter by pillar, search by filename
- Assets stored locally in the project (public folder or similar)

**Content Calendar**
- Weekly view grid showing each day
- Platforms and frequency:
${platformLines}
- Each slot shows: assigned pillar colour, thumbnail if asset attached, caption preview if generated
- Click a slot to assign a pillar and attach an asset from the media library
- Drag assets from the media library into calendar slots

**Caption Generator**
- When a calendar slot has an asset and pillar assigned, show a "Generate Caption" button
- ${voiceLine}
- Generate platform-specific caption variations for: ${Object.keys(state.platforms).map(p => p.charAt(0).toUpperCase() + p.slice(1)).join(', ')}
- Each generated caption has a "Copy" button
- Captions should feel natural, not robotic — match my brand's tone and language

## Technical Notes
- Use my existing design system (colours, fonts, spacing) from my design system files — do not introduce new styling
- Keep the file structure clean and organised
- This is a local tool — no deployment needed, just runs on my machine
- Build it so I can add new modules to the sidebar in future sessions
- Use Next.js App Router with file-based routing
- After building, start the dev server so I can see it immediately`;

  // Update preview and textarea
  const previewEl = document.getElementById('brief-preview');
  const textareaEl = document.getElementById('brief-textarea');
  const outputEl = document.getElementById('brief-output');

  previewEl.textContent = brief;
  textareaEl.value = brief;
  outputEl.classList.add('visible');

  // Scroll to brief on first generation
  if (!outputEl.dataset.shown) {
    outputEl.dataset.shown = 'true';
    setTimeout(() => {
      outputEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 300);
  }
}

// Categorise future modules into nav sections
function categoriseModules(modules) {
  const categories = {
    'Operations': ['Bookings Dashboard', 'Staff Roster', 'Class Timetable'],
    'Clients': ['Client Tracker', 'Lead Pipeline', 'Membership Retention'],
    'Analytics': ['Analytics', 'Financials']
  };

  const result = {};
  const uncategorised = [];

  modules.forEach(mod => {
    let placed = false;
    for (const [cat, items] of Object.entries(categories)) {
      if (items.includes(mod)) {
        if (!result[cat]) result[cat] = [];
        result[cat].push(mod);
        placed = true;
        break;
      }
    }
    if (!placed) uncategorised.push(mod);
  });

  // Put uncategorised modules under "Other"
  if (uncategorised.length > 0) {
    result['Other'] = uncategorised;
  }

  return result;
}

function buildModuleNavLines(categories) {
  let lines = '';
  for (const [cat, modules] of Object.entries(categories)) {
    lines += '  - **' + cat + '** (section header, greyed out)\n';
    modules.forEach(mod => {
      lines += '    - ' + mod + ' (coming soon, greyed out)\n';
    });
  }
  return lines;
}
```

- [ ] **Step 3: Add copy and edit toggle functions**

Append to the `<script>` block:

```javascript
// ============================================
// COPY & EDIT
// ============================================
function copyBrief() {
  const textareaEl = document.getElementById('brief-textarea');
  const isEditing = textareaEl.classList.contains('visible');
  const text = isEditing ? textareaEl.value : document.getElementById('brief-preview').textContent;

  navigator.clipboard.writeText(text).then(() => {
    const btn = document.getElementById('copy-btn');
    btn.textContent = 'Copied!';
    btn.classList.add('copied');
    setTimeout(() => {
      btn.textContent = 'Copy Brief to Clipboard';
      btn.classList.remove('copied');
    }, 2000);
  });
}

function toggleEdit() {
  const preview = document.getElementById('brief-preview');
  const textarea = document.getElementById('brief-textarea');
  const btn = document.querySelector('.brief-toggle');

  if (textarea.classList.contains('visible')) {
    // Switch back to preview — update preview with edited text
    preview.textContent = textarea.value;
    preview.style.display = 'block';
    textarea.classList.remove('visible');
    btn.textContent = 'Edit Brief';
  } else {
    // Switch to edit mode
    preview.style.display = 'none';
    textarea.classList.add('visible');
    btn.textContent = 'Preview Brief';
    textarea.focus();
  }
}

// ============================================
// RE-GENERATE ON INPUT CHANGES
// ============================================
// Attach listeners to re-generate brief when inputs change after section 5 is active
document.addEventListener('input', function(e) {
  if (document.getElementById('section-5')?.classList.contains('active')) {
    // Debounce brief generation
    clearTimeout(window._briefTimeout);
    window._briefTimeout = setTimeout(generateBrief, 300);
  }
});

// Trigger section 4 auto-unlock on page load (since default is "claudemd" radio)
document.addEventListener('DOMContentLoaded', function() {
  // Section 1 starts active, rest are locked — no action needed on load
});
```

- [ ] **Step 4: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add wizard logic, brief generation, copy and edit functionality"
```

---

### Task 8: Polish — visual refinements, scroll behaviour, and final QA

**Files:**
- Modify: `command-centre/index.html`

- [ ] **Step 1: Add progress indicator**

Add HTML after the hero, before the `.container` div:

```html
<div class="progress-bar" id="progress-bar">
  <div class="progress-fill" id="progress-fill"></div>
</div>
```

Add CSS:

```css
.progress-bar {
  position: sticky;
  top: 0;
  z-index: 100;
  height: 3px;
  background: var(--forest-muted);
}

.progress-fill {
  height: 100%;
  background: var(--brass);
  width: 20%;
  transition: width 0.5s ease;
}
```

Add to the `unlockSection` function (at the end, before the closing brace):

```javascript
  // Update progress bar
  const progress = document.getElementById('progress-fill');
  const pct = Math.min((num / 5) * 100, 100);
  progress.style.width = pct + '%';
```

And also update `generateBrief` to set progress to 100% when brief is visible. Add at the end of `generateBrief`, before the closing brace:

```javascript
  // Progress bar to 100%
  document.getElementById('progress-fill').style.width = '100%';
```

- [ ] **Step 2: Add section completion indicators**

Add CSS for completed section styling:

```css
.wizard-section.completed .section-eyebrow::after {
  content: ' ✓';
  color: var(--green);
}
```

Update `unlockSection` to mark the previous section as completed. Add at the start of the function:

```javascript
  // Mark previous section as completed
  if (num > 1) {
    const prev = document.getElementById('section-' + (num - 1));
    if (prev) prev.classList.add('completed');
  }
```

- [ ] **Step 3: Verify the full page works end-to-end**

Open the file locally to verify:

```bash
cd /Users/mariopaguio/Projects/claude-code-guide && open command-centre/index.html
```

Check:
- Hero renders with MLP design system (dark forest background, brass accents, Barlow Condensed heading)
- Section 1 is visible, sections 2-5 are locked/blurred
- Filling section 1 (name + industry pill + description) unlocks section 2
- Selecting 3+ pillars unlocks section 3
- Checking a platform unlocks section 4
- Section 4 auto-advances (since "It's in my CLAUDE.md" is default)
- Section 5 triggers brief generation
- Brief preview shows correct interpolated values
- Copy button works
- Edit toggle switches between preview and textarea
- Progress bar advances with each section

- [ ] **Step 4: Commit**

```bash
git add command-centre/index.html
git commit -m "feat: add progress bar, completion indicators, and polish"
```

---

### Task 9: Deployment — push to main and verify

**Files:**
- No changes — just push and verify.

- [ ] **Step 1: Push to main**

```bash
cd /Users/mariopaguio/Projects/claude-code-guide
git push origin main
```

This triggers Coolify auto-deploy.

- [ ] **Step 2: Verify deployment**

Wait 1-2 minutes for build, then:

```bash
curl -s -o /dev/null -w "%{http_code}" https://code.kaizencollective.com.au/command-centre/
```

Expected: `200`

Then open in browser:

```bash
open https://code.kaizencollective.com.au/command-centre/
```

Verify all 5 wizard sections work, brief generates, copy works.

- [ ] **Step 3: Done**

Mark task complete. Page is live and ready for the Wednesday call.
