# RealUI for TBC Classic (TBCC)

A port of the popular [RealUI](https://www.wowinterface.com/downloads/info16068-RealUI.html) addon suite for World of Warcraft: The Burning Crusade Classic.

RealUI is a minimalist UI replacement that provides a clean, efficient interface focused on what matters during gameplay. It was my favorite UI in Retail, and this port aims to bring that "at home" feel back to the TBC Classic era.

---

## ⚠️ Current Status: Alpha / Playtest

This is a functional but imperfect port.

**Working:** The base RealUI suite -- Welcome screen/wizard, Unit Frames, Bartender, Bags, Menu, AFK Bar, Infobar, Masque skins, and more...

**Broken / W.I.P:** Aurora (the skinning engine) is currently unstable. Some frames may not position correctly or may look "off." This is likely due to conflicts with the modern engine's EditMode backend vs. TBC's lack of it.
There are various RealUI features that are still broken. I plan to fix these issues in batches -- any LUA errors or bug descriptions will help make that possible.

---

## Installation

1. **Download** this repository (Code → Download ZIP) or clone it:
   ```
   git clone https://github.com/KonigTX/RealUI-TBCC.git
   ```

2. **Extract** the contents of the `AddOns` folder

3. **Copy** all addon folders to your WoW TBC Classic AddOns directory:
   ```
   World of Warcraft\_anniversary_\Interface\AddOns\
   ```

4. **Verify** your folder structure looks like:
   ```
   Interface/AddOns/nibRealUI/
   Interface/AddOns/nibRealUI_Config/
   Interface/AddOns/RealUI_Skins/
   Interface/AddOns/Bartender4/
   ... (and the rest)
   ```

5. **Launch** WoW TBC Classic (or `/reload` if already in-game)

6. **Follow** the RealUI setup wizard on first login

---

## AI Usage

This project is a unique experiment: 100% of the code was ported by AI.

I utilized **Claude Code (Opus 4.5)**, **Gemini CLI**, and **Codex** to orchestrate a massive translation of the Retail codebase to the TBCC API.

I used autonomous agents to research API changes, plan the overhaul, and execute the code rewrite.

To my delight, the UI loaded the Welcome Screen on the very first run. While it's not perfect -- 1,457 files is a lot for anyone (human or AI) to manage perfectly -- it is now in a "good enough" state for adventurous users to playtest.

**AI is a hell of a drug. Enjoy!**

---

## Configuration

- `/realui` - Open RealUI configuration
- `/bt4` or `/bartender` - Bartender4 settings
- `/grid2` - Grid2 raid frame settings
- `/raven` - Raven aura settings
- `/kui` - Kui Nameplates settings

## Known Issues

- **Aurora Skins** - Frame skinning is rough; some Blizzard frames may error or display incorrectly
- **MailFrame** - May error when opening mail
- **TradeFrame** - Some button textures missing
- **Frame Movement** - Some frames move, some don't
- **Bag Frame** - Ctrl+Shift+Alt Right Click to assign a filter bag doesn't work

## Credits

Thank you to **Nibelheim**, **Gethe**, and **ievil** — without their work, this port wouldn't be possible.

---

*This is an unofficial port for TBC Classic.*
