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
	combatLogTriggers = {
		{ event = "SPELL_SUMMON", spellName = "Phoenix", prompt = "Phoenix add spawned - swap and burn it down.", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Pyroblast", prompt = "Kick the next dangerous cast.", interruptCycle = "kick", sound = true },
	},
	timeline = {
		{ after = 5, label = "Advisor pull", prompt = "Pull the advisors cleanly and keep them separated.", sound = true },
		{ after = 35, label = "Advisor control", prompt = "Advisor control check - maintain target assignments and CC.", sound = true, repeatCount = 3, every = 45, ["until"] = 125 },
		{ after = 100, label = "Phase 2", prompt = "Phase 2 - move for weapons and clear the arena.", announce = "Phase 2", sound = true },
		{ after = 160, label = "Weapon cleanup", prompt = "Weapon cleanup - keep assigned targets on their weapon.", sound = true },
		{ after = 225, label = "Phase 3", prompt = "Phase 3 - reset for phoenix and gravity / fire handling.", announce = "Phase 3", sound = true },
		{ after = 300, label = "Final phase", prompt = "Final phase - burn the boss and prepare to interrupt the dangerous casts.", sound = true },
	},
})
