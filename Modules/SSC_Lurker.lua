local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-lurker", {
	name = "The Lurker Below",
	description = "Starter timing pass for Spout, submerge cycles, and melee repositioning.",
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Spread on the outer ring and leave room for Spout movement.", sound = true },
		{ after = 35, label = "Spout soon", prompt = "Spout soon - get ready to move as soon as the cast starts.", sound = true },
		{ after = 60, label = "Spout", prompt = "Spout - move immediately around the pool.", announce = "Spout", sound = true, repeatCount = 4, every = 60, ["until"] = 240 },
		{ after = 90, label = "Submerge", prompt = "Submerge - stack adds, then reset your position for the next phase.", announce = "Submerge", sound = true, repeatCount = 2, every = 120, ["until"] = 210 },
		{ after = 105, label = "Whirl", prompt = "Whirl - melee check and tank positioning.", sound = true, repeatCount = 3, every = 60, ["until"] = 225 },
	},
})
