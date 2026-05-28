local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-hydross", {
	name = "Hydross the Unstable",
	description = "Starter timing pass for Hydross with mark swaps, tomb reminders, and phase transition prompts.",
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Keep the boss on the marker line and watch the tank debuff." , sound = true },
		{ after = 15, label = "Mark swap", prompt = "Mark swap is due. Check tank positioning.", sound = true },
		{ after = 22, label = "Water Tomb", prompt = "Watch for Water Tomb on a ranged player.", sound = true },
		{ after = 30, label = "Phase swap", prompt = "Prepare for the next phase transition.", sound = true },
		{ after = 45, label = "Mark swap", prompt = "Mark swap is due. Check tank positioning.", sound = true, repeatCount = 6, every = 15, ["until"] = 120 },
		{ after = 52, label = "Water Tomb", prompt = "Watch for Water Tomb on a ranged player.", sound = true, repeatCount = 8, every = 15, ["until"] = 150 },
		{ after = 135, label = "Full phase change", prompt = "Hard swap now and reset stack positioning.", sound = true },
	},
})
