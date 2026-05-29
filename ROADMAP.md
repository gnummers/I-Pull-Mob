# I Pull Mob Roadmap

This roadmap tracks the remaining work to turn `I Pull Mob` from a strong raid assistant scaffold into a finished, reliable TBC Anniversary addon.

The addon already has:

- raid coverage for Phase 1 through Phase 4, plus a starter Sunwell pass
- leader tools, kill tracking, automarkers, break timers, pull timers, and range helpers
- a shared support layer for media and utility services
- a modular encounter system that can hold boss logic fight by fight

The remaining work is mostly about tightening accuracy, finishing edge cases, improving usability, and hardening the addon for real raid use.

## Milestone 1: Encounter Accuracy Pass

Goal: make the imported boss modules dependable enough to trust in progression raids.

Deliverables:

- review every boss module against local DBM and BigWigs references
- replace heuristic timers with event-driven triggers where spell IDs or combat-log events are available
- verify phase transitions, add waves, and interrupt cycles for each encounter
- tighten prompt wording so it tells the player what to do, not just what is happening
- normalize spell names, marker logic, and boss IDs across all raid modules

Exit criteria:

- each boss module has clear trigger logic and readable prompt text
- no module relies on obviously generic or placeholder timing assumptions
- special encounters like Karazhan event fights remain handled through explicit completion logic

## Milestone 2: Full Boss Coverage Audit

Goal: make sure every meaningful TBC raid encounter is represented and correctly classified.

Deliverables:

- audit the module list against the full TBC raid roster
- confirm all boss encounters, special event encounters, and multi-target encounters are present
- separate single-boss kill tracking from event-end tracking where needed
- add or refine boss IDs for automatic kill recording
- ensure utility modules are not mistaken for raid encounters in summaries or reports

Exit criteria:

- every raid instance in TBC Anniversary has complete coverage in `Modules\`
- edge cases like opera, chess, council-style fights, and add-driven encounters are classified correctly
- kill history and encounter completion are reliable across the full roster

## Milestone 3: Leader Tools Polish

Goal: make the raid-leading features feel intentional and fast to use during an actual raid night.

Deliverables:

- refine pull, ready check, break, and kill-recording flows
- keep the options window usable during combat and between pulls
- surface the slash-command set in the options window with buttons and small form fields
- continue improving sound alias selection and preview behavior
- expand shared media aliases only where they improve raid communication
- add any remaining leader prompts that reduce raid lead friction

Exit criteria:

- the core leader actions are available in one or two clicks
- slash commands and options-window controls do the same thing
- prompts are concise enough to be useful under pressure

## Milestone 4: Utility Module Completion

Goal: finish the support modules that make the addon useful outside of pure boss timelines.

Deliverables:

- continue refining automarker support for the fights that benefit from it most
- improve range helper behavior and any remaining visibility rules
- refine raid movement prompts, taunt reminders, mana reminders, and pre-pull checks
- keep break timers and utility modules consistent with the rest of the addon

Exit criteria:

- utility modules are purposeful and not redundant
- each utility module has a clear use case and minimal configuration burden
- the shared support layer stays small and reusable

## Milestone 5: UX and Options Cleanup

Goal: make the addon easy to configure without forcing users into the Lua files.

Deliverables:

- keep the options window consistent in layout and terminology
- make saved settings easy to understand and maintain
- add or refine controls for range value, break presets, sound presets, and module enablement
- keep the command center aligned with the slash commands so the GUI stays authoritative
- improve post-fight report presentation where it helps decision-making

Exit criteria:

- the options UI feels like part of the addon, not an afterthought
- common settings are discoverable in-game
- module management is obvious and fast

## Milestone 6: Maintainability Pass

Goal: keep the addon easy to extend without reworking the core every time a new raid or utility is added.

Deliverables:

- keep each boss or utility in a separate module file when that improves clarity
- maintain consistent naming for module IDs, encounter IDs, and saved variables
- continue documenting special cases in `README.md` and `Research\`
- keep the support layer focused on shared services rather than encounter logic

Exit criteria:

- new boss modules can be added without editing unrelated code paths
- the repo structure makes it obvious where each kind of logic belongs
- future contributors can find the right file quickly

## Milestone 7: Release Readiness

Goal: prepare the addon for a stable public release candidate.

Deliverables:

- run a full parse check over every Lua file
- smoke test core flows:
  - start and stop encounters
  - pull timers
  - break timers
  - range helper
  - module enable and disable
  - kill summary and report panel
- verify the addon loads cleanly with saved variables present
- confirm the TOC, README, and module list match the actual files
- tag a release candidate once the remaining issues are closed

Exit criteria:

- the addon loads without parse errors
- the advertised features match the actual implementation
- no known high-priority boss module issues remain

## Suggested Work Order

1. Finish the encounter accuracy pass.
2. Audit the remaining edge cases and event encounters.
3. Polish the leader tools and utility modules.
4. Clean up the options UI and post-fight reporting.
5. Do one final maintainability and release-readiness sweep.

## Definition of Done

`I Pull Mob` is finished when:

- the full TBC raid roster is covered
- boss prompts are accurate enough for real raid use
- the leader tools and utility modules are reliable and easy to use
- the options window exposes the important controls cleanly
- the documentation matches the code
- the addon loads and runs without parse or packaging issues
