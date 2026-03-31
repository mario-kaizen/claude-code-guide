# Setup Tab Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite Tab 4 ("Setup") of `index.html` with a 4-phase guided setup flow for non-technical users, including new CSS for phase headers, inline troubleshooting blocks, and expanded checklist content.

**Architecture:** Single-file edit to `index.html`. New CSS classes added to the existing `<style>` block. The HTML for Tab 4 (`<div id="setup">`) is replaced entirely. No new files, no JS changes needed — existing `toggleCheck()` function handles all interactivity.

**Tech Stack:** HTML, CSS, vanilla JS (existing)

---

## File Map

- **Modify:** `index.html`
  - CSS block (lines ~529-600): Add new styles for `.phase-block`, `.phase-header`, `.setup-fix`, `.setup-explain`, `.setup-command`, `.setup-paths`
  - HTML Tab 4 (lines 1088-1147): Replace entire `<div id="setup">` content
  - Mobile CSS (lines ~838-876): Add responsive rules for new classes

---

### Task 1: Add New CSS Classes

**Files:**
- Modify: `index.html` — CSS block after the existing `.setup-item-content code` rule (after line 600)

- [ ] **Step 1: Add phase block styles**

Insert after the closing `}` of `.setup-item-content code` (line 600), before the `STEP LIST` comment (line 602):

```css
  /* ============================================
     PHASE BLOCKS
     ============================================ */
  .phase-block {
    margin-bottom: 64px;
  }

  .phase-block:last-child {
    margin-bottom: 0;
  }

  .phase-header {
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid var(--neutral-700);
  }

  .phase-number {
    font-family: var(--font-body);
    font-size: 10px;
    letter-spacing: 0.25em;
    text-transform: uppercase;
    color: var(--gold);
    font-weight: 600;
    margin-bottom: 8px;
  }

  .phase-title {
    font-family: var(--font-heading);
    font-size: clamp(22px, 3vw, 30px);
    font-weight: 400;
    color: var(--cream);
    line-height: 1.2;
    margin-bottom: 8px;
  }

  .phase-title em {
    font-style: italic;
    color: var(--gold);
  }

  .phase-tagline {
    font-family: var(--font-body);
    font-size: 14px;
    color: var(--stone);
    font-weight: 300;
  }

  .setup-explain {
    font-family: var(--font-body);
    font-size: 14px;
    color: var(--neutral-400);
    font-weight: 300;
    line-height: 1.8;
    margin-top: 8px;
    padding: 12px 16px;
    background: var(--neutral-800);
    border-left: 2px solid var(--neutral-600);
    border-radius: 0 4px 4px 0;
  }

  .setup-explain strong {
    color: var(--cream);
    font-weight: 500;
  }

  .setup-fix {
    font-family: var(--font-body);
    font-size: 13px;
    color: var(--amber);
    font-weight: 300;
    line-height: 1.7;
    margin-top: 10px;
    padding: 12px 16px;
    background: rgba(196, 150, 74, 0.08);
    border-left: 2px solid var(--amber);
    border-radius: 0 4px 4px 0;
  }

  .setup-fix strong {
    font-weight: 500;
    color: var(--amber);
  }

  .setup-fix code {
    font-family: 'SF Mono', 'Fira Code', monospace;
    font-size: 12px;
    background: var(--neutral-800);
    padding: 1px 6px;
    border-radius: 3px;
    color: var(--gold-light);
  }

  .setup-command {
    display: block;
    font-family: 'SF Mono', 'Fira Code', monospace;
    font-size: 13px;
    background: var(--neutral-800);
    padding: 10px 14px;
    border-radius: 4px;
    color: var(--gold-light);
    margin-top: 10px;
    line-height: 1.6;
    white-space: pre-wrap;
    word-break: break-all;
  }

  .setup-paths {
    margin-top: 16px;
    padding: 16px 20px;
    background: var(--neutral-800);
    border-radius: 4px;
  }

  .setup-paths h5 {
    font-family: var(--font-body);
    font-size: 12px;
    letter-spacing: 0.15em;
    text-transform: uppercase;
    color: var(--gold);
    font-weight: 600;
    margin-bottom: 12px;
  }

  .setup-paths p {
    font-family: var(--font-body);
    font-size: 13px;
    color: var(--neutral-400);
    font-weight: 300;
    line-height: 1.7;
    margin-bottom: 8px;
  }

  .setup-paths p:last-child {
    margin-bottom: 0;
  }

  .setup-item-content .setup-substeps {
    margin-top: 8px;
    padding-left: 0;
    list-style: none;
  }

  .setup-item-content .setup-substeps li {
    font-family: var(--font-body);
    font-size: 13px;
    color: var(--neutral-500);
    font-weight: 300;
    line-height: 1.7;
    padding: 2px 0;
    padding-left: 16px;
    position: relative;
  }

  .setup-item-content .setup-substeps li::before {
    content: '→';
    position: absolute;
    left: 0;
    color: var(--neutral-600);
  }

  .phase-done {
    margin-top: 24px;
    padding: 16px 20px;
    background: rgba(90, 158, 111, 0.1);
    border-left: 2px solid var(--green);
    border-radius: 0 4px 4px 0;
  }

  .phase-done p {
    font-family: var(--font-body);
    font-size: 13px;
    color: var(--green);
    font-weight: 400;
    line-height: 1.6;
  }
```

- [ ] **Step 2: Add mobile responsive rules for new classes**

Insert into the existing `@media (max-width: 768px)` block (around line 876, before the closing `}`):

```css
    .phase-block {
      margin-bottom: 48px;
    }

    .phase-header {
      margin-bottom: 24px;
      padding-bottom: 20px;
    }

    .phase-title {
      font-size: clamp(20px, 5vw, 26px);
    }

    .setup-explain,
    .setup-fix {
      font-size: 13px;
      padding: 10px 14px;
    }

    .setup-command {
      font-size: 12px;
      padding: 8px 12px;
    }

    .setup-paths {
      padding: 14px 16px;
    }
```

- [ ] **Step 3: Verify CSS is valid**

Open `index.html` in a browser and check that the page still renders correctly (no broken styles on other tabs). The new classes won't be visible yet since we haven't added the HTML.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "style: add phase block, inline fix, and explain CSS for setup tab"
```

---

### Task 2: Replace Setup Tab HTML — Phase 1 (Install Claude Code)

**Files:**
- Modify: `index.html` — replace the `<div id="setup">` block (lines 1088-1147)

- [ ] **Step 1: Delete existing setup tab HTML**

Remove everything from `<div id="setup" class="page">` through its closing `</div>` (the entire Tab 4 content, lines 1088-1147).

- [ ] **Step 2: Insert new setup tab HTML — section header + Phase 1**

Replace with the following (this step covers the outer wrapper, section header, and Phase 1):

```html
<div id="setup" class="page">

  <div class="section section-dark">
    <div class="section-header">
      <div class="section-number">04 — Setup</div>
      <div class="section-title" style="color: var(--cream);">Get <em>Set Up</em></div>
      <div class="section-subtitle">This takes about 30 minutes. Put a podcast on, grab a coffee, and knock it out in one sitting. Each phase builds on the last — by the end, you'll have a fully loaded AI building tool that already knows your business.</div>
    </div>

    <!-- ======== PHASE 1 ======== -->
    <div class="phase-block">
      <div class="phase-header">
        <div class="phase-number">Phase 1</div>
        <div class="phase-title">Install <em>Claude Code</em></div>
        <div class="phase-tagline">Get Claude Code running on your Mac</div>
      </div>

      <div class="setup-list">

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Open Terminal</h4>
            <p>Press <code>Cmd + Space</code>, type <code>Terminal</code>, hit Enter.</p>
            <div class="setup-explain"><strong>What is Terminal?</strong> It's the text version of your computer. Instead of clicking buttons and dragging files, you type short commands. It looks like a hacker movie — that's normal. You'll only need to paste a few commands into it.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Install Xcode Command Line Tools</h4>
            <p>Paste this into Terminal and hit Enter:</p>
            <code class="setup-command">xcode-select --install</code>
            <div class="setup-explain"><strong>What is this?</strong> These are background tools that let your Mac install and run developer software. You'll never open this directly — but your Mac needs it before anything else will work. Think of it as laying the foundation before building the house.</div>
            <ul class="setup-substeps">
              <li>A popup will appear — click <strong style="color: var(--cream);">Install</strong></li>
              <li>Wait 5–10 minutes for it to finish</li>
              <li>When it's done, paste this to verify: <code>xcode-select -p</code> — it should show a file path</li>
            </ul>
            <div class="setup-fix"><strong>Already installed?</strong> If you see "command line tools are already installed" — perfect. Skip to the next step.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Install Node.js</h4>
            <p>Go to <strong style="color: var(--cream);">nodejs.org</strong> and click the big green button that says <strong style="color: var(--cream);">LTS</strong>. Download it, open the installer, and click through the steps.</p>
            <div class="setup-explain"><strong>What is Node.js?</strong> It's the engine that runs Claude Code. Like how your car needs petrol to drive, Claude Code needs Node to run. You'll install it once and never think about it again. <strong>LTS</strong> stands for Long Term Support — it just means "the stable, recommended version."</div>
            <ul class="setup-substeps">
              <li>Once installed, <strong style="color: var(--cream);">close Terminal completely</strong> (<code>Cmd + Q</code>)</li>
              <li>Reopen Terminal (same way — <code>Cmd + Space</code>, type Terminal)</li>
              <li>Paste this to verify: <code>node --version</code> — you should see a number like <code>v20.x.x</code> or higher</li>
            </ul>
            <div class="setup-fix"><strong>"command not found"?</strong> Close Terminal completely with <code>Cmd + Q</code> (not just the window — quit the app), reopen it, and try again. Still nothing? Restart your Mac and try once more.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Install Claude Code</h4>
            <p>Paste this into Terminal and hit Enter:</p>
            <code class="setup-command">npm install -g @anthropic-ai/claude-code</code>
            <div class="setup-explain"><strong>What is npm?</strong> It's Node's app store. This command downloads Claude Code from the internet and installs it on your Mac. You'll see a progress bar — wait for it to finish.</div>
            <ul class="setup-substeps">
              <li>When it finishes, verify by typing: <code>claude --version</code> — you should see a version number</li>
            </ul>
            <div class="setup-fix"><strong>"permission denied" or "EACCES" error?</strong> Your Mac is being protective. Run this instead:<br><code>sudo npm install -g @anthropic-ai/claude-code</code><br><br><strong>What is sudo?</strong> You're telling your Mac "I'm the owner, let this through." It will ask for your Mac login password. <strong>When you type your password, nothing will appear on screen</strong> — no dots, no stars, nothing. That's normal and it's a security feature. Just type it and hit Enter.</div>
            <div class="setup-fix"><strong>"claude: command not found" after install?</strong> Close Terminal with <code>Cmd + Q</code>, reopen it, and try <code>claude --version</code> again.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Sign In</h4>
            <p>Type <code>claude</code> and hit Enter. It will open your browser automatically.</p>
            <ul class="setup-substeps">
              <li>Sign in with the <strong style="color: var(--cream);">same claude.ai account</strong> you use for Chat</li>
              <li>Once signed in, come back to Terminal — you should see a welcome message</li>
            </ul>
            <div class="setup-fix"><strong>Browser didn't open?</strong> Look in Terminal for a URL — copy it and paste it into your browser manually.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>First Test</h4>
            <p>Let's make sure everything works. Paste these two commands one at a time:</p>
            <code class="setup-command">cd ~/Desktop</code>
            <code class="setup-command">claude</code>
            <p style="margin-top: 8px;">Once Claude is running, type this:</p>
            <code class="setup-command">Create a file called hello.txt that says Claude Code is working</code>
            <ul class="setup-substeps">
              <li>Check your Desktop — if <strong style="color: var(--cream);">hello.txt</strong> appears, you're live</li>
            </ul>
          </div>
        </div>

      </div>

      <div class="phase-done">
        <p>Phase 1 complete — Claude Code is installed and running on your Mac.</p>
      </div>
    </div>
```

- [ ] **Step 3: Verify Phase 1 renders**

Open `index.html` in a browser, navigate to Tab 4. Phase 1 should display with the phase header, 6 checklist items, inline explanations, inline troubleshooting blocks, and a green "phase done" bar. Checkboxes should toggle when clicked.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "content: setup tab Phase 1 — install Claude Code with full walkthroughs"
```

---

### Task 3: Add Phase 2 HTML (VS Code Workspace)

**Files:**
- Modify: `index.html` — insert after Phase 1's closing `</div>`, before the closing `</div>` of the section

- [ ] **Step 1: Insert Phase 2 HTML**

Insert directly after the Phase 1 `</div>` (the one closing `.phase-block`):

```html
    <!-- ======== PHASE 2 ======== -->
    <div class="phase-block">
      <div class="phase-header">
        <div class="phase-number">Phase 2</div>
        <div class="phase-title">Set Up Your <em>Workspace</em></div>
        <div class="phase-tagline">Install VS Code — the app you'll actually work in every day</div>
      </div>

      <div class="setup-list">

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Download VS Code</h4>
            <p>Go to <strong style="color: var(--cream);">code.visualstudio.com</strong> and click the big blue download button for Mac.</p>
            <div class="setup-explain"><strong>What is VS Code?</strong> It's a workspace app where you can see your files, write instructions, and run Claude Code all in one place — think of it as Claude Code's office. It's free, made by Microsoft, and used by millions of developers. You're about to be one of them.</div>
            <ul class="setup-substeps">
              <li>Open the downloaded <code>.zip</code> file</li>
              <li>Drag <strong style="color: var(--cream);">Visual Studio Code</strong> into your <strong style="color: var(--cream);">Applications</strong> folder</li>
              <li>Open it from Applications</li>
            </ul>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Quick Orientation</h4>
            <p>VS Code looks overwhelming at first. Here's all you need to know:</p>
            <ul class="setup-substeps">
              <li><strong style="color: var(--cream);">Left sidebar</strong> = your files (like Finder)</li>
              <li><strong style="color: var(--cream);">Bottom panel</strong> = Terminal (where Claude Code runs)</li>
              <li><strong style="color: var(--cream);">Top menu</strong> = everything else</li>
            </ul>
            <div class="setup-explain">Don't worry about all the buttons. You'll use about 5% of what's here. The rest is for software engineers — and you don't need to be one.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Install the Claude Code Extension</h4>
            <p>Click the <strong style="color: var(--cream);">Extensions</strong> icon in the left sidebar — it looks like four small squares.</p>
            <div class="setup-explain"><strong>What are extensions?</strong> Add-ons that give VS Code new abilities — like apps on your phone. The Claude Code extension lets you use Claude directly inside VS Code instead of switching to Terminal.</div>
            <ul class="setup-substeps">
              <li>In the search bar, type <code>Claude Code</code></li>
              <li>Click <strong style="color: var(--cream);">Install</strong> on the one by <strong style="color: var(--cream);">Anthropic</strong></li>
              <li>A Claude icon will appear in the left sidebar — that's your Claude Code panel</li>
            </ul>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Open a Project Folder</h4>
            <p>Go to <strong style="color: var(--cream);">File → Open Folder</strong> and pick your Desktop, or create a new folder called something like <code>My Projects</code>.</p>
            <div class="setup-explain"><strong>What is a project folder?</strong> Just a regular folder. Claude Code works best when it knows which folder you're working in — it can see the files, understand the context, and build things in the right place. Think of it as giving Claude a desk to work at.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Run Claude Inside VS Code</h4>
            <p>Open the built-in terminal: press <code>Ctrl + `</code> (backtick — the key above Tab) or go to <strong style="color: var(--cream);">View → Terminal</strong>.</p>
            <ul class="setup-substeps">
              <li>Type <code>claude</code> and hit Enter</li>
              <li>Same Claude, same power — but now you can see your files and Claude side by side</li>
            </ul>
            <div class="setup-explain">From now on, this is where you'll work. VS Code gives you everything in one window — your files on the left, Claude at the bottom, and the results appearing in real time. No more switching between apps.</div>
          </div>
        </div>

      </div>

      <div class="phase-done">
        <p>Phase 2 complete — VS Code is your new workspace. Everything in one place.</p>
      </div>
    </div>
```

- [ ] **Step 2: Verify Phase 2 renders**

Open in browser, check Tab 4. Phase 2 should appear below Phase 1 with 5 checklist items.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "content: setup tab Phase 2 — VS Code workspace setup"
```

---

### Task 4: Add Phase 3 HTML (Teach Claude Your Business)

**Files:**
- Modify: `index.html` — insert after Phase 2's closing `</div>`

- [ ] **Step 1: Insert Phase 3 HTML**

Insert directly after the Phase 2 `</div>` (the one closing `.phase-block`):

```html
    <!-- ======== PHASE 3 ======== -->
    <div class="phase-block">
      <div class="phase-header">
        <div class="phase-number">Phase 3</div>
        <div class="phase-title">Teach Claude <em>Your Business</em></div>
        <div class="phase-tagline">Give Claude a cheat sheet so it already knows who you are</div>
      </div>

      <div class="setup-list">

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Understand What CLAUDE.md Is</h4>
            <p>CLAUDE.md is a file that Claude reads at the <strong style="color: var(--cream);">start of every single conversation</strong>. It's your business cheat sheet.</p>
            <div class="setup-explain">Think of it this way: every time you start a new conversation with Claude Chat, you have to re-explain who you are, what your business does, and how you work. CLAUDE.md removes that entirely. Claude reads it automatically and already knows your business name, your services, your platforms, your brand voice — everything. The more detail you put in here, the less you explain later.</div>
          </div>
        </div>

      </div>

      <div class="setup-paths">
        <h5>Choose Your Path</h5>
        <p style="margin-bottom: 16px;">Pick the one that applies to you:</p>
      </div>

      <div class="setup-list" style="margin-top: 16px;">

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Path A: You've Done Your Business Profile in Chat</h4>
            <p>If you've already created a Business Profile document inside Claude Chat, you can use it to generate your CLAUDE.md automatically.</p>
            <ul class="setup-substeps">
              <li>Open <strong style="color: var(--cream);">claude.ai</strong> → find your Business Profile conversation</li>
              <li>Copy or download the Business Profile output → save it to your Desktop</li>
              <li>Open VS Code terminal (<code>Ctrl + `</code>)</li>
              <li>Type <code>claude</code> and hit Enter</li>
              <li>Paste this prompt:</li>
            </ul>
            <code class="setup-command">Read the file called [your-filename] on my Desktop and use it to create my CLAUDE.md file at ~/.claude/CLAUDE.md. Include everything relevant about my business — who I am, what I do, who I serve, my platforms, my brand voice.</code>
            <div class="setup-explain">Replace <strong>[your-filename]</strong> with the actual name of the file you saved — e.g. <code>Business-Profile.pdf</code> or <code>business-profile.txt</code>. Claude will read the document, extract the key information, and create the file for you.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Path B: You Haven't Done a Business Profile Yet</h4>
            <p>No worries — you can create your CLAUDE.md from scratch. Open VS Code terminal, type <code>claude</code>, and paste this:</p>
            <code class="setup-command">Create a CLAUDE.md file at ~/.claude/CLAUDE.md with the following information about my business:

- Business name: [your business name]
- What I do: [your services/offers]
- Who I serve: [your target market]
- Platforms I use: [CRM, social, email, etc.]
- How I communicate: [brand voice, tone]
- Other context: [anything else that helps]</code>
            <div class="setup-explain">Fill in the brackets with your own details before hitting Enter. The more specific you are, the better Claude will understand your business. You can always update this file later — it's not a one-shot deal.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Verify It Works</h4>
            <p>Let's make sure Claude actually reads your business context:</p>
            <ul class="setup-substeps">
              <li>Quit Claude — type <code>/exit</code> or press <code>Ctrl + C</code></li>
              <li>Start a new session: type <code>claude</code> and hit Enter</li>
              <li>Ask: <code>What do you know about my business?</code></li>
              <li>Claude should respond with details from your CLAUDE.md</li>
            </ul>
          </div>
        </div>

      </div>

      <div class="phase-done">
        <p>Phase 3 complete — Claude now knows your business before you say a word.</p>
      </div>
    </div>
```

- [ ] **Step 2: Verify Phase 3 renders**

Open in browser, check Tab 4. Phase 3 should show the "Choose Your Path" block with Path A and Path B, plus the verify step.

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "content: setup tab Phase 3 — CLAUDE.md from Business Profile or template"
```

---

### Task 5: Add Phase 4 HTML (Unlock Full Power) + Close Tab

**Files:**
- Modify: `index.html` — insert after Phase 3's closing `</div>`, then close the section and tab

- [ ] **Step 1: Insert Phase 4 HTML and closing tags**

Insert directly after the Phase 3 `</div>` (the one closing `.phase-block`):

```html
    <!-- ======== PHASE 4 ======== -->
    <div class="phase-block">
      <div class="phase-header">
        <div class="phase-number">Phase 4</div>
        <div class="phase-title">Unlock <em>Full Power</em></div>
        <div class="phase-tagline">Remove the training wheels</div>
      </div>

      <div class="setup-list">

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>Understand What This Means</h4>
            <p>By default, Claude asks your permission before it reads a file, runs a command, or makes any change. That's responsible — but it's slow.</p>
            <div class="setup-explain">When you're building something new and you trust the process, you can tell Claude to just <strong>go</strong>. It's the difference between micromanaging a new hire and trusting a senior employee. Claude will plan the work, execute it, test it, and fix issues — all without stopping to ask after every step.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>How to Use It</h4>
            <p>Instead of typing <code>claude</code>, run this:</p>
            <code class="setup-command">claude --dangerously-skip-permissions</code>
            <div class="setup-explain">That's it. Claude will plan, execute, test, and fix — without stopping to ask after every step. A 20-minute build becomes a 5-minute build. The name sounds scary on purpose — it's a reminder that you're giving Claude more freedom. For building new things, that's exactly what you want.</div>
          </div>
        </div>

        <div class="setup-item" onclick="toggleCheck(this)">
          <div class="setup-check"></div>
          <div class="setup-item-content">
            <h4>When NOT to Use It</h4>
            <p>Don't use this when you're changing something critical that already works. Use it when you're <strong style="color: var(--cream);">building something new</strong>.</p>
            <div class="setup-explain">Think of it like this: you'd give a trusted employee the keys to set up a new office. You wouldn't give them the keys to rearrange your existing one without checking in first. New build? Skip permissions. Editing something important? Let Claude check with you.</div>
          </div>
        </div>

      </div>

      <div class="phase-done">
        <p>Phase 4 complete — you're fully set up. Claude Code is installed, your workspace is ready, Claude knows your business, and you know how to build at full speed. Go to the next tab and build something.</p>
      </div>
    </div>

  </div>

</div>
```

- [ ] **Step 2: Verify full setup tab renders**

Open in browser, check Tab 4. All 4 phases should display correctly with proper spacing. All checkboxes should toggle. Inline troubleshooting blocks should have amber/gold left borders. Phase done blocks should have green left borders. Test on mobile viewport (resize browser to 375px width).

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "content: setup tab Phase 4 — dangerously-skip-permissions + close tab"
```

---

### Task 6: Final Review + Push

**Files:**
- Modify: `index.html` (if any fixes needed)

- [ ] **Step 1: Full tab review**

Open `index.html` in browser. Navigate through all 6 tabs to make sure nothing is broken:
- Tab 1 (The Shift): unchanged, renders correctly
- Tab 2 (What It Builds): unchanged, renders correctly
- Tab 3 (Power Tools): unchanged, renders correctly
- Tab 4 (Setup): all 4 phases render, checkboxes work, mobile responsive
- Tab 5 (First Build): unchanged, renders correctly
- Tab 6 (What's Next): unchanged, renders correctly

- [ ] **Step 2: Mobile test**

Resize browser to 375px width. Check Tab 4:
- Phase headers readable
- Checklist items not overflowing
- Code blocks wrapping properly
- Inline fix blocks readable
- Substep arrows aligned

- [ ] **Step 3: Fix any issues found**

If any rendering issues are found in steps 1-2, fix them.

- [ ] **Step 4: Push to deploy**

```bash
git push origin main
```

Coolify will auto-build and deploy from the push to main.
