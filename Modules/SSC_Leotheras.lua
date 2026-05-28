local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-leotheras", {
	name = "Leotheras the Blind",
	description = "Starter timing pass for human phase casts, Whirlwind warnings, and demon phase swaps.",
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Spread loosely and keep the center lane clear for Whirlwind.", sound = true },
		{ after = 32, label = "Whirlwind soon", prompt = "Whirlwind soon - melee should prepare to disengage.", sound = true },
		{ after = 45, label = "Whirlwind", prompt = "Whirlwind - move out and keep ranged safe.", announce = "Whirlwind", sound = true, repeatCount = 3, every = 75, ["until"] = 195 },
		{ after = 60, label = "Demon phase", prompt = "Demon phase - swap targets and prepare for the add.", announce = "Demon phase", sound = true, repeatCount = 2, every = 90, ["until"] = 150 },
		{ after = 85, label = "Inner demons", prompt = "Inner Demons - respond immediately and assign kills.", sound = true, repeatCount = 2, every = 90, ["until"] = 175 },
		{ after = 130, label = "Back to human", prompt = "Back to human phase - reset positioning and the kick rhythm.", sound = true, repeatCount = 2, every = 90, ["until"] = 220 },
	},
})
