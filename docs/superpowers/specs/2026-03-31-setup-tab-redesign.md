# Setup Tab Redesign — code.kaizencollective.com.au

## Context

The Setup tab (Tab 4) of the Claude Code session guide at code.kaizencollective.com.au needs a complete rewrite. The current version has 6 brief checklist items that assume technical familiarity. The audience — Kaizen Collective clients — are non-technical service business owners who have never opened Terminal.

## Audience

- Non-technical business owners (gym owners, PTs, service-based founders)
- Mac users
- Have a Claude Pro subscription ($20/mo)
- Have the Claude Code desktop app but nothing else installed
- Some have completed a Business Profile document in Claude Chat
- Goal: get them to CLI with `--dangerously-skip-permissions` capability

## Design Principles

- Every technical term gets a plain-English explanation (what it is, what it does, why they need it)
- Inline troubleshooting — fixes appear right where errors happen, not in a separate section
- Copy-paste commands — they should never have to type a command from memory
- Conversational tone matching the existing guide (Mario's voice)
- No jargon without analogy

## Structure: 4 Phases

The setup is organised into 4 phases. Each phase has a clear purpose, a set of numbered steps with interactive checkboxes (matching existing UI pattern), and a satisfying "done" moment.

### Phase 1 — Install Claude Code
*Tagline: "Get Claude Code running on your Mac"*

Steps:
1. **Open Terminal**
   - What it is: "the text version of your computer — instead of clicking, you type"
   - How: Cmd+Space → type "Terminal" → hit Enter
   - Reassurance: "It looks like a hacker movie. That's normal. You'll only need to paste a few commands."

2. **Install Xcode Command Line Tools**
   - What it is: "background tools that let your Mac install and run developer software — you'll never open this directly, but your Mac needs it before anything else will work"
   - Command: `xcode-select --install`
   - A popup appears → click "Install" → wait 5-10 minutes
   - Inline fix: if "already installed" message appears, that's fine — skip to next step
   - Verify: `xcode-select -p` should show a path

3. **Install Node.js**
   - What it is: "the engine that runs Claude Code — like how your car needs petrol to drive, Claude Code needs Node to run"
   - Go to nodejs.org → download the LTS version ("LTS means Long Term Support — it's the stable, recommended version, the green button")
   - Run the installer, click through the steps
   - Verify: close Terminal, reopen it, type `node --version` — should show v20.x.x or higher
   - Inline fix: "command not found" → close Terminal completely (Cmd+Q), reopen, try again. Still nothing? Restart your Mac and try once more.

4. **Install Claude Code**
   - What npm is: "Node's app store — this command downloads and installs Claude Code onto your Mac"
   - Command: `npm install -g @anthropic-ai/claude-code`
   - Inline fix: EACCES / permission denied → run `sudo npm install -g @anthropic-ai/claude-code` instead. Explain sudo: "You're telling your Mac you're the owner and to let this through." It will ask for your Mac login password. "When you type your password, nothing will appear on screen — no dots, no stars, nothing. That's normal. Just type it and hit Enter."
   - Inline fix: `claude: command not found` after install → close Terminal, reopen, try `claude --version`
   - Verify: `claude --version` shows a version number

5. **Sign In**
   - Command: type `claude` and hit Enter
   - It will open your browser → sign in with the same claude.ai account you use for Chat
   - Come back to Terminal — you should see a welcome message
   - Inline fix: browser doesn't open → copy the URL shown in Terminal and paste it into your browser manually

6. **First Test**
   - Type: `cd ~/Desktop` then `claude`
   - Ask Claude: "Create a file called hello.txt that says Claude Code is working"
   - Check your Desktop — if the file is there, Phase 1 is done

### Phase 2 — Set Up Your Workspace
*Tagline: "Install VS Code — the app you'll actually work in every day"*

Steps:
1. **Download VS Code**
   - What it is: "a workspace app where you can see your files, write instructions, and run Claude Code all in one place — think of it as Claude Code's office. It's free, made by Microsoft, and used by millions of developers. You're about to be one of them."
   - Go to code.visualstudio.com → click the big blue download button for Mac → open the .zip → drag VS Code into Applications

2. **Quick Orientation**
   - Open VS Code from Applications
   - Left sidebar = your files (like Finder)
   - Bottom panel = Terminal (where Claude Code runs)
   - Top menu = everything else
   - "Don't worry about all the buttons. You'll use about 5% of what's here."

3. **Install the Claude Code Extension**
   - What extensions are: "add-ons that give VS Code new abilities — like apps on your phone"
   - Click the Extensions icon in the left sidebar (looks like 4 squares)
   - Search "Claude Code" → click Install on the one by Anthropic
   - The Claude icon appears in the sidebar — that's your Claude Code panel

4. **Open a Project Folder**
   - File → Open Folder → pick Desktop (or create a new folder like "My Projects")
   - "A project folder is just a regular folder. Claude Code works best when it knows which folder you're working in."

5. **Run Claude Inside VS Code**
   - Open the built-in terminal: press Ctrl+` (backtick, the key above Tab) or View → Terminal
   - Type `claude` and hit Enter
   - Same Claude, same power — but now you can see your files and Claude side by side

### Phase 3 — Teach Claude Your Business
*Tagline: "Give Claude a cheat sheet so it already knows who you are"*

Steps:
1. **What CLAUDE.md Is**
   - "A file that Claude reads at the start of every single conversation. It's your business cheat sheet — so you never have to re-explain who you are, what you do, or how you work. The more detail you put in here, the less you explain later."

2. **Path A: You've Done Your Business Profile in Chat**
   - Open Claude Chat (claude.ai) → find your Business Profile conversation
   - Click the copy/download button on the Business Profile output → save it somewhere easy (like your Desktop)
   - Open Terminal or VS Code terminal
   - Run: `claude`
   - Tell Claude: "Read the file called [filename] on my Desktop and use it to create my CLAUDE.md file at ~/.claude/CLAUDE.md. Include everything relevant about my business — who I am, what I do, who I serve, my platforms, my brand voice."
   - Claude will read the document, extract the key information, and create the file for you

3. **Path B: You Haven't Done a Business Profile Yet**
   - Run `claude` in Terminal
   - Tell Claude: "Create a CLAUDE.md file at ~/.claude/CLAUDE.md with the following information about my business:" then fill in:
     - Business name
     - What you do (services, offers)
     - Who you serve (target market)
     - Platforms you use (CRM, social, email, etc.)
     - How you communicate (brand voice, tone)
     - Any other context that would help Claude understand your world

4. **Verify It Works**
   - Quit Claude (type `/exit` or Ctrl+C)
   - Start a new session: `claude`
   - Ask: "What do you know about my business?"
   - Claude should respond with details from your CLAUDE.md — if it does, Phase 3 is done

### Phase 4 — Unlock Full Power
*Tagline: "Remove the training wheels"*

Steps:
1. **What This Means**
   - "By default, Claude asks your permission before it reads a file, runs a command, or makes any change. That's responsible — but it's slow. When you're building something new and you trust the process, you can tell Claude to just go."
   - "It's the difference between micromanaging a new hire and trusting a senior employee."

2. **How to Use It**
   - Instead of `claude`, run: `claude --dangerously-skip-permissions`
   - Claude will plan, execute, test, and fix — without stopping to ask after every step
   - "A 20-minute build becomes a 5-minute build."

3. **When NOT to Use It**
   - "Don't use this when you're changing something critical that already works. Use it when you're building something new."
   - "Think of it like this: you'd give a trusted employee the keys to set up a new office. You wouldn't give them the keys to rearrange your existing one without checking in."

## UI/UX Notes

- Maintain the existing dark section styling (`.section-dark`) for consistency with current Setup tab
- Each phase gets its own visual block with a phase number, title, and tagline
- Steps within each phase use the existing interactive checklist pattern (`.setup-item` with `.setup-check` toggle)
- Inline troubleshooting blocks should be visually distinct — slightly different background or a subtle warning-style left border (amber/gold) so they're clearly "if something went wrong" blocks, not regular steps
- Commands remain in `<code>` blocks matching existing styling
- The CLAUDE.md prompt blocks (Path A and Path B) should use the existing `.brief-block` code block style

## What's NOT Included

- Deployment (GitHub, Docker, Coolify)
- API keys or Anthropic Console
- Advanced CLI flags beyond `--dangerously-skip-permissions`
- MCP servers or plugins
- Any content changes to other tabs

## Success Criteria

A non-technical Kaizen client can go from "I have the desktop app" to "Claude Code is running in VS Code with my business context loaded and I know how to use --dangerously-skip-permissions" — without messaging Mario for help.
