# DBM and BigWigs BC Scan Notes

This note captures the highest-value timer and mechanic data extracted from the installed local addon source in `C:\World of Warcraft\_anniversary_\Interface\AddOns`.

## Primary Sources

- `DBM-Raids-BC`
- `BigWigs_BurningCrusade`

## Secondary Sources Worth Mining

- `DBM-StatusBarTimers`
- `Details_EncounterDetails`
- `GTFO`
- `OmniBar`
- `BigDebuffs`
- `VuhDo`

## High-Value Imported Mechanics

### Brutallus

- Burn: `46394`
- Burn resist: `45141`
- Meteor Slash: `45150`
- Stomp: `45185`
- Key DBM/BW pattern: short burn timer, repeated stomp recovery, and burn resist notice.

### M'uru

- Darkness: `45996`
- Dark Fiend: `45934`
- Open All Portals: `46177`
- Black Hole: `46282`
- Key DBM/BW pattern: 30-second sentinel repeats, 60-second humanoid repeat cadence, and a clean stage 2 transition.

### Kil'jaeden

- Sinister Reflection: `45892`
- Shield of the Blue: `45848`
- Fire Bloom: `45641`
- Shadow Spike: `45885` and cast start `46680`
- Darkness of a Thousand Souls: `46605`
- Flame Dart: `45737`
- Key DBM/BW pattern: phase-based bomb windows, orb/shield management, target bars, and Spike kick handling.

### Hydross the Unstable

- Mark of Hydross: `38215`
- Water Tomb: `38235`
- Sludge/phase handling: `38246`
- Key DBM/BW pattern: phase swap bars, mark cadence, and target-specific tomb/sludge warnings.

### Kael'thas Sunstrider

- Pyroblast: `36819`
- Phoenix: `36723`
- Gravity Lapse: `35941`
- Shock Barrier: `36815`
- Conflagration: `37018`
- Mind Control: `36797`
- Nether Beam / weapon phase utility: stage-based transitions and 30-second advisor pacing.

### Lady Vashj

- Phase 2 trigger: `38280`
- Elemental adds: `38132`
- Barrier: `38112`
- Strider cadence and naga cadence are repeated wave timers.
- Key DBM/BW pattern: stage transitions, barrier-down alerts, and repeating add waves.

### Hyjal Wave Timers

- The wave helper uses boss-specific cadence tables, with common timings around 125, 135, 160, 165, 195, and 225 seconds depending on wave and boss.
- It also provides a detailed wave composition mapping for Rage Winterchill, Anetheron, Kaz'rogal, and Azgalor.

## Practical Takeaways for I Pull Mob

- Use DBM/BigWigs spell IDs for combat log triggers whenever possible.
- Use short, repeated timeline prompts only where the fight has a stable cadence.
- Keep phase transitions as explicit prompts because they are the most useful raid-call moments.
- Add interrupt-cycle support only on casts the raid actually kicks.
- Keep the core generic, but add boss-specific modules for the fights with stable repeat windows.

## Addon Scan Summary

The installed addon set confirms that the most useful BC raid references are:

- DBM raid packs for exact IDs and timers.
- BigWigs raid packs for repeated mechanics and phase pacing.
- GTFO and BigDebuffs for player-facing warning philosophy.
- OmniBar and VuhDo for raid-utility context, not primary timer sources.
