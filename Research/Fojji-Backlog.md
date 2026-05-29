# I Pull Mob Backlog Inspired by Fojji

This backlog turns the public Fojji module list and the local DBM/BigWigs research into concrete work items for `I Pull Mob`.

## Tier 1: Core Raid Leader Features

- `raid-leader-tools`
  - Pull timer control
  - Ready check prompts
  - Countdown announcements
  - Pre-pull assignment reminders
- `raid-watch`
  - Role-aware mechanic prompts
  - Boss-specific warning overlays
  - Phase transition banners
- `reminder-popups`
  - Buff, consume, and assignment reminders
  - Post-pull mid-fight checklist prompts
- `pull-timers`
  - Clickable or slash-command pull countdowns
  - Optional voice and sound cues

## Tier 2: Raid Execution Helpers

- `automarker`
  - Assignment-based markers for debuffs and adds
  - Boss-target icon support
- `taunt-alerter`
  - Tank swap alerts tied to boss mechanics
  - Boss-specific taunt windows
- `interrupt-cycle`
  - Per-boss interrupt rotations
  - Fallback manual cycle management
- `raid-cooldowns`
  - Assignment prompts for defensive and healing cooldowns
  - Scheduled cooldown callouts by phase

## Tier 3: Player Status and Utility

- `buff-tracker`
  - Core raid buffs
  - Missing raid-buff reminders before and after pull
- `debuff-tracker`
  - Dangerous debuff highlighting
  - Player-specific movement prompts
- `external-aura-range`
  - Range reminders for bosses with spread checks
- `gear-checker`
  - Enchants, gems, and gear sanity prompts
- `consumables`
  - Flasks, food, oils, and potion reminders

## Tier 4: Boss Support and Reporting

- `boss-kill-times`
  - Track clear times per boss
  - Show improvement trends
- `boss-frames`
  - Boss resource frames and phase state display
- `range-and-threat-helpers`
  - Awareness tools for tanks and ranged players
- `combat-log-import`
  - Optional import path for spell IDs, phase windows, and pull logs

## Implementation Notes

- Keep the core generic and module-driven.
- Add support services in the core for shared media, utilities, and standardized announcements.
- Prefer boss modules for actual encounter logic.
- Keep utility modules disabled by default unless they solve a recurring raid problem.

## Suggested Order

1. Finish a full Sunwell tuning pass.
2. Add raid leader tools and pull-time helpers.
3. Add automarker and cooldown helper services.
4. Add buff, debuff, and consumable checks.
5. Add kill-time reporting and post-raid analysis.
