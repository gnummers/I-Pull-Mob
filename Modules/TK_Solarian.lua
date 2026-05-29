local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-solarian", {
	name = "High Astromancer Solarian",
	description = "Starter timing pass for Wrath of the Astromancer, phase swaps, and add control.",
	bossIds = { 18805 },
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Wrath of the Astromancer", icon = 8, target = "dest", clearOnRemove = true, announce = "Wrath of the Astromancer marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Wrath of the Astromancer", prompt = "Wrath of the Astromancer - watch the debuffed player and spread immediately.", announce = "Wrath of the Astromancer", sound = true },
	},
	timeline = {
		{ after = 72, label = "Phase shift", prompt = "Phase shift soon. Prepare for the add burst and priest control.", sound = true },
		{ after = 92, label = "Add phase", prompt = "Add phase - focus the priests and keep interrupts organized.", sound = true },
		{ after = 122, label = "Return phase", prompt = "Return to boss damage and reset spacing.", sound = true },
		{ after = 170, label = "Voidwalker", prompt = "Voidwalker phase at 20% - stack the plan and finish the boss.", sound = true },
	},
})
