local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-prince", {
	name = "Karazhan - Prince Malchezaar",
	description = "Starter Prince module: axes, enfeeble, and infernal reminders.",
	bossIds = { 15690 },
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Enfeeble", prompt = "Enfeeble - heal or use a health item immediately.", announce = "Enfeeble incoming", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Infernal", prompt = "Infernal - watch the landing zone and move out.", announce = "Infernal incoming", sound = true },
	},
	timeline = {
		{ after = 20, label = "Phase 1", prompt = "Phase 1 - handle axes and keep the raid spread.", sound = true },
		{ after = 60, label = "Phase 2", prompt = "Phase 2 - prepare for infernals and enfeeble recovery.", sound = true },
		{ after = 100, label = "Phase 3", prompt = "Phase 3 - burn the boss and keep the tank stable.", sound = true },
	},
})
