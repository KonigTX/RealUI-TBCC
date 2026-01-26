# RealUI for TBC Classic (TBCC)

A port of the popular [RealUI](https://www.realui.net/) addon suite for World of Warcraft: The Burning Crusade Classic.

RealUI is a minimalist UI replacement that provides a clean, efficient interface focused on what matters during gameplay. This port brings RealUI's aesthetic and functionality to TBC Classic.

## Features

- **Clean HUD** - Minimalist unit frames with angled health/power bars
- **Integrated Nameplates** - Kui Nameplates with RealUI styling
- **Action Bars** - Bartender4 integration with clean, minimal styling
- **Raid Frames** - Grid2 with RealUI profiles for DPS and Healer layouts
- **Aura Tracking** - Raven for buff/debuff monitoring
- **Inventory** - Custom bag management with category filtering
- **Combat Text** - Floating combat text with RealUI styling
- **Aurora Skins** - UI skinning for Blizzard frames (work in progress)
- **Infobar** - Data broker display with system information

## Installation

1. Download or clone this repository
2. Copy the contents of the `AddOns` folder to your WoW TBC Classic AddOns directory:
   ```
   World of Warcraft\_classic_\Interface\AddOns\
   ```
3. Restart WoW or `/reload` if already in-game
4. RealUI will run the initial setup on first login

## Included AddOns

### Core RealUI
| Addon | Description |
|-------|-------------|
| **nibRealUI** | Core addon - HUD, unit frames, modules |
| **nibRealUI_Config** | Configuration interface |
| **RealUI_Skins** | Aurora-based UI skinning |
| **RealUI_Bugs** | Error handler and bug reporter |
| **RealUI_CombatText** | Floating combat text |
| **RealUI_Inventory** | Bag and inventory management |
| **!RealUI_Preloads** | Bootstrap loader |

### Bundled Third-Party AddOns
| Addon | Description | Author |
|-------|-------------|--------|
| **Bartender4** | Action bar replacement | Nevcairiel |
| **Grid2** | Raid/party frames | Michael |
| **Kui_Nameplates** | Nameplate framework | Kesava |
| **Raven** | Buff/debuff tracking | Tomber |
| **Masque** | Button skinning library | StormFX |
| **BadBoy** | Chat spam blocker | Funkydude |
| **ClassicSpellActivations** | Spell proc highlights | d87 |

## Known Issues

This is a work-in-progress port. The following issues are known:

### Aurora Skins (RealUI_Skins)
Aurora skinning is still very rough and has compatibility issues with TBC Classic:

- **MailFrame** - `FRAME_TITLE_HEIGHT` constant missing in TBC, causes errors when opening mail
- **TradeFrame** - `SetNormalTexture` method missing on some trade slot buttons
- **SpellBook** - Not yet implemented for TBC Classic
- **PlayerChoice** - Not fully implemented
- **BankFrame** - Limited support in Classic clients
- **Various Blizzard frames** - Some skins may error or display incorrectly

### General Issues
- Some Retail-specific API calls may cause errors on first load
- Unit frame positioning may need manual adjustment after setup
- Grid2 profiles may need to be manually selected for healer specs

### Workarounds
If you experience errors:
1. Use `/realui` to access settings
2. Check RealUI_Bugs for error details
3. Some Aurora skins can be disabled individually if problematic

## Configuration

- `/realui` - Open RealUI configuration
- `/bt4` or `/bartender` - Bartender4 settings
- `/grid2` - Grid2 raid frame settings
- `/raven` - Raven aura settings
- `/kui` - Kui Nameplates settings

## Requirements

- World of Warcraft: The Burning Crusade Classic (2.5.x)
- Recommended resolution: 1920x1080 or higher

## Credits

RealUI was originally created by **Nibelheim**. This TBC Classic port maintains compatibility with the original design philosophy while adapting to the Classic client.

### Third-Party Libraries
This addon suite includes the following libraries and addons, with thanks to their respective authors:
- Ace3 libraries (Ace community)
- LibStub, CallbackHandler (WoW library authors)
- LibSharedMedia (Elkano)
- LibDataBroker (Tekkub)
- LibQTip (Kemayo)
- oUF (Haste)
- Aurora (Haleth, Lightsword)

## License

RealUI and its components are provided under their respective licenses. See individual addon folders for specific license information.

---

*This is an unofficial port for TBC Classic. For the official Retail version, visit [realui.net](https://www.realui.net/)*
