local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-moroes", {
	name = "Karazhan - Moroes",
	description = "Starter Moroes module: Garrote cadence, add control, and execute reminders.",
	cycles = {
		garrote = { "Priest", "Paladin", "Shaman" },
	},
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Garrote", prompt = "Garrote - dispel the target now.", interruptCycle = "garrote", sound = true },
	},
	timeline = {
		{ after = 10, label = "Garrote 1", prompt = "Dispel the garrote target.", interruptCycle = "garrote" },
		{ after = 25, label = "Moroes adds", prompt = "Control the add pack." },
		{ after = 40, label = "Garrote 2", prompt = "Dispel the next garrote target.", interruptCycle = "garrote" },
		{ after = 70, label = "Moroes adds", prompt = "Re-control adds and keep tanks stable." },
		{ after = 90, label = "Garrote 3", prompt = "Dispel the next garrote target.", interruptCycle = "garrote" },
		{
			after = 120,
			label = "Execute",
			prompt = "Prepare for Moroes enrage pressure at low health.",
			announce = "Moroes is close to execute range",
			sound = true,
		},
	},
})
