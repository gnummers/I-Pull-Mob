local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-karathress", {
	name = "Fathom-Lord Karathress",
	description = "Starter timing pass for add swaps, interrupt windows, and totem kill reminders.",
	cycles = {
		kick = {},
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Cataclysmic Bolt", prompt = "Kick the next Cataclysmic Bolt.", interruptCycle = "kick", sound = true },
	},
	timeline = {
		{ after = 15, label = "Totem check", prompt = "Kill totems and keep add control clean.", sound = true, repeatCount = 4, every = 30, ["until"] = 105 },
		{ after = 38, label = "Add swap", prompt = "Swap to the empowered add and stabilize the raid.", sound = true },
		{ after = 72, label = "Heavy damage", prompt = "Healing spike incoming. Prepare externals.", sound = true },
	},
})
