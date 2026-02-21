# RealUI for TBC Classic Anniversary

A port of the popular [RealUI](https://www.wowinterface.com/downloads/info16068-RealUI.html) addon suite for World of Warcraft: The Burning Crusade Classic Anniversary (2.5.x).

RealUI is a minimalist UI replacement focused on clean, efficient gameplay. This port brings that experience to TBC Classic.

![scr1](https://github.com/user-attachments/assets/59090d62-f932-4a66-922a-898a22c36519)
![scr2](https://github.com/user-attachments/assets/5f5e3f85-97e6-4a4c-b712-e7c479707477)
![WoWScrnShot_012626_105505](https://github.com/user-attachments/assets/e5960ad4-151b-4448-8d54-f3621a629af8)

---

## Current Status: Beta

The core RealUI experience is functional and actively maintained.

### What Works

- **Core UI** — Unit frames, action bars, minimap, infobar, AFK screen
- **Setup Wizard** — First-time configuration walks you through setup
- **Inventory** — Custom bag system with filtering and bank support
- **Aurora Skins** — Dark, minimal styling for most Blizzard frames
- **Bundled Addons** — Bartender4, Grid2, Raven, Kui Nameplates, Masque

### Known Limitations

- **Aurora Skins** — Still rough in some areas. Text colors, frame borders, and backgrounds may look off on certain panels. Actively being improved.
- Some features from Retail RealUI aren't applicable to TBC

---

## Installation

1. **Download** — [Code → Download ZIP](https://github.com/KonigTX/RealUI-TBCC/archive/refs/heads/master.zip) or clone:
   ```
   git clone https://github.com/KonigTX/RealUI-TBCC.git
   ```

2. **Copy** the contents of `AddOns/` to your WoW directory:
   ```
   World of Warcraft\_anniversary_\Interface\AddOns\
   ```

3. **Launch** WoW TBC Classic and follow the setup wizard

---

## Commands

| Command | Description |
|---------|-------------|
| `/realui` | RealUI configuration panel |
| `/bt` | Bartender4 action bar settings |
| `/grid2` | Grid2 raid frame settings |
| `/raven` | Raven buff/debuff settings |
| `/kui` | Kui Nameplates settings |

---

## Reporting Issues

Found a bug? [Open an issue](https://github.com/KonigTX/RealUI-TBCC/issues) with:
- What happened
- Steps to reproduce
- Any Lua errors (copy from chat or use `/console scriptErrors 1`)

---

## About This Port

This port was created using AI-assisted development with **Claude Code**, **Gemini**, and **Codex** to translate ~1,500 files from the Retail API to TBC Classic.

The UI loaded successfully on the first run — a testament to how far AI tooling has come. Ongoing fixes and improvements are made through the same human-AI collaboration.

---

## Credits

- **Nibelheim** — Original RealUI creator
- **Gethe** — Continued RealUI development
- **ievil** — Contributions to RealUI

---

*Unofficial port for TBC Classic Anniversary. Not affiliated with the original RealUI team.*
