local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-kaelthas", {
	name = "Kael'thas Sunstrider",
	description = "Starter timing pass for advisor burn, weapon phase, and final interrupt windows.",
	cycles = {
		kick = {},
	},
	timeline = {
		{ after = 5, label = "Advisor pull", prompt = "Pull the advisors cleanly and keep them separated.", sound = true },
		{ after = 30, label = "Advisor control", prompt = "Advisor control check - maintain target assignments and CC.", sound = true, repeatCount = 3, every = 45, ["until"] = 120 },
		{ after = 110, label = "Phase 2", prompt = "Phase 2 - move for weapons and clear the arena.", sound = true },
		{ after = 180, label = "Weapon cleanup", prompt = "Weapon cleanup - keep assigned targets on their weapon.", sound = true },
		{ after = 240, label = "Phase 3", prompt = "Phase 3 - reset for phoenix and gravity / fire handling.", sound = true },
		{ after = 320, label = "Final phase", prompt = "Final phase - burn the boss and prepare to interrupt the dangerous casts.", sound = true },
		{ after = 340, label = "Interrupt check", prompt = "Kick the next dangerous cast.", interruptCycle = "kick", sound = true, repeatCount = 6, every = 20, ["until"] = 440 },
	},
})
