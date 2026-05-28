# I Pull Mob

`I Pull Mob` is a World of Warcraft TBC Anniversary raid helper addon focused on boss timers, interrupt cycles, and player-action prompts.

It is intentionally structured like a lightweight encounter framework:

- encounter modules define the fight timeline
- the core addon renders timer bars and prompts
- interrupt rotations are tracked separately from the encounter script
- the addon can be tested with built-in demo modules before real boss data is added

## Current Features

- Movable raid helper frame with timer bars
- Prompt text for the next player action
- Raid-warning style alerts when events fire
- Interrupt cycle tracking and rotation advancement
- Slash-command driven testing
- Example boss modules already registered in the core

## Slash Commands

- `/ipm` or `/ipm help` - show help
- `/ipm demo` - start the built-in example boss module
- `/ipm start <module>` - start a registered module
- `/ipm stop` - stop the current module
- `/ipm modules` - list registered modules
- `/ipm cycles` - list configured interrupt cycles
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
- `kara-aran` - Shade of Aran
- `kara-chess` - The Chess Event
- `kara-netherspite` - Netherspite
- `kara-nightbane` - Nightbane
- `kara-prince` - Prince Malchezaar
- `gruuls-lair` - Gruul the Dragonkiller, with Growth, Cave In, and Shatter reminders
- `maulgar` - High King Maulgar
- `magtheridons-lair` - Magtheridon, with Blast Nova cube rotations and a Quake reminder

These are starter modules that can be refined further with raid testing and pull logs.

## Module Model

Each raid module can define:

- `name` and `description`
- `cycles` for initial interrupt assignments
- `timeline` entries with `after`, `label`, `prompt`, `announce`, `sound`, `interruptCycle`, `repeatCount`, `every`, and `until`
- optional hooks like `onStart`, `onSchedule`, `onEvent`

That makes the addon suitable for converting WeakAura-style raid logic into a standalone raid assistant.

## Installation

1. Copy the `I-Pull-Mob` folder into your WoW `Interface\AddOns` directory.
2. Enable `I Pull Mob` in the addon list.
3. Reload the UI.

## Notes

- Addon title: `I Pull Mob`
- Saved variables: `IPullMobDB`
- Main file: `IPullMob.lua`

## Next Step

Add real boss modules for the raids you care about, then tune the prompts and interrupt rotations for each fight.
