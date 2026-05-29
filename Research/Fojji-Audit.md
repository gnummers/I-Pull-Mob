# Fojji Category Audit for I Pull Mob

This audit maps the current addon to the public Fojji-style category model.

## Already Covered

- `pull-timers`
  - Present as `pull-timers`
  - Covers basic countdown behavior
- `reminder-popups`
  - Present as `reminder-popups`
  - Covers generic prompt reminders
- `taunt-alerter`
  - Present as `taunt-alerter`
  - Covers tank swap reminders
- `raid-cooldowns`
  - Present as `raid-cooldowns`
  - Covers raid-wide cooldown prompts
- `raid-leader-tools`
  - Present as `raid-leader-tools`
  - Covers pull countdowns, ready checks, and kill recording
- `automarker`
  - Present as `automarker`
  - Provides shared marker support for boss modules that declare marker rules
- `boss-kill-times`
  - Present as `boss-kill-times`
  - Covers kill-time history and summary output
- `interrupt-cycle`
  - Present in the core interrupt cycle engine
  - Used by boss modules and utility modules
- `raid-watch`
  - Present as boss modules with `timeline` and `combatLogTriggers`
  - The core already behaves like a lightweight watch layer

## Partially Covered

- `boss-frames`
  - The addon has a frame and bars, but not a dedicated boss resource frame system
- `buff-tracker`
  - Only indirect coverage through reminders and encounter prompts
- `debuff-tracker`
  - Boss modules warn on mechanics, but there is no general-purpose raid debuff tracker

## Missing

- `external-aura-range`
  - No dedicated range module
- `gear-checker`
  - No gear or enchant sanity checker
- `consumables`
  - No pre-pull consumable audit
- `combat-log-import`
  - No log import or post-fight replay pipeline
- `raid-reporting`
  - No broader performance dashboard beyond kill-time history

## Best Next Additions

1. Add a small raid leader tools panel for pull control and assignment notes.
2. Add automarker support for selected debuffs or assigned targets.
3. Add a kill-time tracker and a post-pull summary report.
4. Add a range reminder helper for mechanics that require spread checks.
5. Add consumable and pre-pull readiness checks for raid nights.
