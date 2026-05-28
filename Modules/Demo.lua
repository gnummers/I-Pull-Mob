local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("demo", {
	name = "Example Boss Module",
	description = "A starter boss module showing a pull timer, a kick cycle, and movement prompts.",
	cycles = {
		main = { "Rogue", "Shaman", "Mage" },
	},
	timeline = {
		{ after = 5, label = "Pull timer", prompt = "Get ready to pull", sound = true },
		{ after = 15, label = "Cast 1", prompt = "Kick the cast", interruptCycle = "main" },
		{ after = 27, label = "Move out", prompt = "Spread and move out", sound = true },
		{ after = 40, label = "Cast 2", prompt = "Kick the next cast", interruptCycle = "main" },
	},
})
