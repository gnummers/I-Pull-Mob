local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-hydross", {
	name = "Hydross the Unstable",
	description = "Starter timing pass for Hydross with mark swaps, tomb reminders, and phase transition prompts.",
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Pull on the line and keep raid spacing open for Water Tomb.", sound = true },
		{ after = 18, label = "Water Tomb", prompt = "Water Tomb - heal the target and keep the raid spread.", announce = "Water Tomb", sound = true, repeatCount = 4, every = 18, ["until"] = 90 },
		{ after = 55, label = "Mark swap", prompt = "Mark swap soon. Move the boss to the phase-change marker.", sound = true },
		{ after = 60, label = "Phase swap", prompt = "Phase swap - move into the new resist zone and reset stacks.", announce = "Phase swap", sound = true },
		{ after = 78, label = "Water Tomb", prompt = "Water Tomb - re-stabilize the raid after the swap.", announce = "Water Tomb", sound = true, repeatCount = 4, every = 18, ["until"] = 150 },
		{ after = 115, label = "Mark swap", prompt = "Mark swap soon. Prep the next tank handoff.", sound = true },
		{ after = 120, label = "Phase swap", prompt = "Second phase swap - reset positioning and survivability.", announce = "Phase swap", sound = true },
	},
})
