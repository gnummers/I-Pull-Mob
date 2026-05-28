local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-lurker", {
	name = "The Lurker Below",
	description = "Starter timing pass for Spout, submerge cycles, and melee repositioning.",
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread on the edge and be ready to reposition for Spout.", sound = true },
		{ after = 45, label = "Spout soon", prompt = "Spout soon. Face the boss away and move to the safe side.", sound = true },
		{ after = 60, label = "Spout", prompt = "Spout - move immediately.", announce = "Spout", sound = true, repeatCount = 4, every = 60, ["until"] = 240 },
		{ after = 120, label = "Submerge", prompt = "Submerge - stack adds and prepare for phase movement.", announce = "Submerge", sound = true, repeatCount = 2, every = 120, ["until"] = 240 },
		{ after = 165, label = "Whirl", prompt = "Whirl / melee check - keep clear of the boss if needed.", sound = true },
	},
})
