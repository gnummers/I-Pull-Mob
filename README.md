# I Pull Mob

`I Pull Mob` is a World of Warcraft TBC Anniversary raid helper addon focused on boss timers, interrupt cycles, and player-action prompts.

It is intentionally structured like a lightweight encounter framework:

- encounter modules define the fight timeline
- the core addon renders timer bars and prompts
- interrupt rotations are tracked separately from the encounter script
- the addon can be tested with built-in demo modules before real boss data is added
- raid and utility modules live in `Modules\*.lua` and register themselves after the core API loads

## Current Features

- Movable raid helper frame with timer bars
- Prompt text for the next player action
- Raid-warning style alerts when events fire
- Interrupt cycle tracking and rotation advancement
- Slash-command driven testing
- In-game options window for enabling and disabling modules
- Shared support layer for media and utility services
- Shared media defaults that prefer FojjiCore-style sound names when available
- Leader tools, automarker support, and kill-time tracking
- Break countdown and minimal range helper utilities
- Command-center buttons and fields for the slash-command set
- Post-fight report panel in the options window
- Starter raid modules for the full Phase 1 through Phase 4 TBC raid roster, plus a starter Sunwell import pass for the full Sunwell raid roster

## Slash Commands

- `/ipm` or `/ipm help` - show help
- `/ipm demo` - start the built-in example boss module
- `/ipm start <module>` - start a registered module
- `/ipm stop` - stop the current module
- `/ipm modules` - list registered modules
- `/ipm cycles` - list configured interrupt cycles
- `/ipm options` - open the module and settings window
- `/ipm pull` - start the pull countdown module
- `/ipm pull cancel` - cancel the pull countdown
- `/ipm break` - start the break countdown module
- `/ipm break <minutes>` - start a break preset such as 5, 10, or 15 minutes
- `/ipm break cancel` - cancel the break countdown
- `/ipm range <yards>` - start the minimal range helper
- `/ipm range cancel` - clear the range helper
- `/ipm ready` - send a ready check
- `/ipm kill` - record the current encounter as a kill and save the time
- `/ipm summary [module]` - print kill history for the current or named module
- `/ipm leader` - print a leader-tools reminder
- `/ipm enable <module>` - enable a module
- `/ipm disable <module>` - disable a module
- `/ipm cycle <name> add <player>` - add a player to a cycle
- `/ipm cycle <name> list` - show cycle members
- `/ipm cycle <name> next` - advance the cycle manually
- `/ipm cycle <name> clear` - clear a cycle
- `/ipm sound on|off` - toggle alert sounds
- `/ipm lock` and `/ipm unlock` - prevent or allow dragging the window

## Example Modules

The addon ships with starter modules:

- `demo` - an example boss module with a pull timer, movement prompt, and interrupt cycle
- `test-rotations` - a utility module for checking interrupt order and prompt flow
- `kara-attumen` - Attumen the Huntsman
- `kara-moroes` - Moroes
- `kara-maiden` - Maiden of Virtue
- `kara-curator` - The Curator in Karazhan, with flare waves and Evocation warnings
- `kara-illhoof` - Terestian Illhoof
- `kara-aran` - Shade of Aran
- `kara-chess` - The Chess Event
- `kara-opera` - The Opera Event
- `kara-netherspite` - Netherspite
- `kara-nightbane` - Nightbane
- `kara-prince` - Prince Malchezaar
- `gruuls-lair` - Gruul the Dragonkiller, with Growth, Cave In, and Shatter reminders
- `maulgar` - High King Maulgar
- `magtheridons-lair` - Magtheridon, with Blast Nova cube rotations and a Quake reminder
- `pull-timers` - a simple pull countdown module
- `break-timers` - a fixed break countdown module
- `break-5`, `break-10`, `break-15` - break countdown presets
- `range-helper` - a minimal range reminder
- `reminder-popups` - generic pre-pull or mid-raid reminder prompts
- `taunt-alerter` - generic tank swap reminders
- `raid-leader-tools` - shared pull, ready, and leader reminders
- `automarker` - shared marker support for selected boss mechanics
- `boss-kill-times` - kill-time tracking and post-fight summaries
- `ssc-core-runners` - Tainted Core handoff reminders for Lady Vashj
- `tk-assignment-helper` - assignment and marker reminders for Tempest Keep fights
- `raid-movement` - spread, stack, and reposition reminders
- `hyjal-rage-winterchill` - Rage Winterchill
- `hyjal-anetheron` - Anetheron
- `hyjal-kazrogal` - Kaz'rogal
- `hyjal-azgalor` - Azgalor
- `hyjal-archimonde` - Archimonde
- `bt-najentus` - High Warlord Naj'entus
- `bt-supremus` - Supremus
- `bt-akama` - Shade of Akama
- `bt-teron` - Teron Gorefiend
- `bt-gurtogg` - Gurtogg Bloodboil
- `bt-reliquary` - Reliquary of Souls
- `bt-mother-shahraz` - Mother Shahraz
- `bt-council` - The Illidari Council
- `bt-illidan` - Illidan Stormrage
- `za-nalorakk` - Nalorakk
- `za-akilzon` - Akil'zon
- `za-janalai` - Jan'alai
- `za-halazzi` - Halazzi
- `za-malacrass` - Hex Lord Malacrass
- `za-zuljin` - Zul'jin
- `ssc-hydross` - Hydross the Unstable
- `ssc-lurker` - The Lurker Below
- `ssc-leotheras` - Leotheras the Blind
- `ssc-karathress` - Fathom-Lord Karathress
- `ssc-morogrim` - Morogrim Tidewalker
- `ssc-vashj` - Lady Vashj
- `tk-void-reaver` - Void Reaver
- `tk-alar` - Al'ar
- `tk-solarian` - High Astromancer Solarian
- `tk-kaelthas` - Kael'thas Sunstrider
- `sw-brutallus` - Brutallus
- `sw-kalecgos` - Kalecgos
- `sw-felmyst` - Felmyst
- `sw-twins` - The Eredar Twins
- `sw-muru` - M'uru
- `sw-kiljaeden` - Kil'jaeden
- `prepull-checklist` - a short pre-pull readiness checklist
- `raid-cooldowns` - generic raid cooldown reminders
- `mana-reminders` - mana check and potion prompts

These cover the full boss list for Phase 1 through Phase 4 TBC raid content in this addon, plus a starter Sunwell import pass for the full Sunwell raid roster.

Note: `kara-chess` and `kara-opera` are special Karazhan event encounters. They finish through encounter-end tracking rather than a normal single-boss death, so the addon handles them with dedicated event-completion logic.

Note: the range helper auto-hides when started from `/ipm range`, but stays visible if you launch it from the options window.

## Module Model

Each raid module can define:

- `name` and `description`
- `cycles` for initial interrupt assignments
- `timeline` entries with `after`, `label`, `prompt`, `announce`, `sound`, `interruptCycle`, `repeatCount`, `every`, and `until`
- `combatLogTriggers` entries for cast-start and aura-based prompts that should fire from actual combat log events
- `bossIds` for auto-detecting boss deaths and recording kill times
- `encounterEndIds` for special event encounters that should finish on `ENCOUNTER_END`
- `autoMarkers` for assigning raid markers from combat-log events
- `persistentPrompt` and `persistentPromptText` for non-timer utility modules that should keep a live reminder visible
- optional hooks like `onStart`, `onSchedule`, `onEvent`, and `onCombatLog`

That makes the addon suitable for converting WeakAura-style raid logic into a standalone raid assistant.

## Options

Use `/ipm options` to open the configuration window. From there you can:

- toggle core behaviors like alert sounds, auto-show, and window lock
- adjust the frame scale
- adjust the alert volume used for addon sounds
- adjust the range helper yard value
- start or cancel the range helper from the options window
- launch preset break timers from the options window
- select and preview the alert sound alias from the options window
- use the command center to run help, demo, stop, modules, cycles, leader, start, summary, enable, disable, and cycle-management actions
- enable or disable any registered module
- keep utility modules disabled when you do not want them loaded for a night
- use leader tools buttons for pull countdowns, ready checks, and kill recording
- review kill-time history after a fight or by module name
- browse saved kill history in the post-fight report panel

Disabled modules remain registered, but `/ipm start <module>` will refuse to launch them until they are re-enabled.

## Installation

1. Copy the `I-Pull-Mob` folder into your WoW `Interface\AddOns` directory.
2. Enable `I Pull Mob` in the addon list.
3. Reload the UI.

## Notes

- Addon title: `I Pull Mob`
- Saved variables: `IPullMobDB`
- Main file: `IPullMob.lua`
- Support file: `IPullMobSupport.lua`
- Encounter modules: `Modules\*.lua`
- Research notes: `Research\*.md`
- Roadmap: `ROADMAP.md`

## Next Step

Tighten the imported timing windows with pull logs, then add more boss-specific leader tools where the raid benefits from them.
