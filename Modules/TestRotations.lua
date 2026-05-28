local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("test-rotations", {
	name = "Interrupt Rotation Test",
	description = "Utility module for testing cycle order and prompt behavior without an actual boss.",
	cycles = {
		main = { "Player One", "Player Two", "Player Three" },
	},
	timeline = {
		{ after = 8, label = "Kick 1", prompt = "Interrupt the first cast", interruptCycle = "main" },
		{ after = 16, label = "Kick 2", prompt = "Interrupt the second cast", interruptCycle = "main" },
		{ after = 24, label = "Kick 3", prompt = "Interrupt the third cast", interruptCycle = "main" },
	},
})
