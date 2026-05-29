local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-hydross", {
	name = "Hydross the Unstable",
	description = "Starter timing pass for Hydross with mark swaps, tomb reminders, and phase transition prompts.",
	bossIds = { 21216 },
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Mark of Hydross", prompt = "Mark swap - check tank positioning and resist cleanup.", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Water Tomb", prompt = "Water Tomb - heal the target and keep the raid spread.", announce = "Water Tomb", sound = true },
	},
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Pull on the line and keep raid spacing open for Water Tomb.", sound = true },
		{ after = 55, label = "Mark swap", prompt = "Mark swap soon. Move the boss to the phase-change marker.", sound = true },
		{ after = 60, label = "Phase swap", prompt = "Phase swap - move into the new resist zone and reset stacks.", announce = "Phase swap", sound = true },
		{ after = 115, label = "Mark swap", prompt = "Mark swap soon. Prep the next tank handoff.", sound = true },
		{ after = 120, label = "Phase swap", prompt = "Second phase swap - reset positioning and survivability.", announce = "Phase swap", sound = true },
	},
})
