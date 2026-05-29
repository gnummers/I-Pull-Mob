local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-kaelthas", {
	name = "Kael'thas Sunstrider",
	description = "Imported timing pass for advisors, Conflagration, Mind Control, Phoenix, and Gravity Lapse handling.",
	bossIds = { 19622 },
	cycles = {
		kick = {},
	},
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 37018 }, icon = 8, target = "dest", clearOnRemove = true, announce = "Conflagration marked" },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 36797 }, sequence = { 8, 7, 6, 5, 4, 3, 2, 1 }, target = "dest", clearOnRemove = true, announce = "Mind Control marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellIds = { 44863 }, prompt = "Fear - recover quickly and keep the raid stable.", announce = "Fear", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 36819 }, prompt = "Pyroblast - kick the cast.", announce = "Pyroblast", interruptCycle = "kick", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 35941 }, prompt = "Gravity Lapse - reposition immediately.", announce = "Gravity Lapse", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 37018 }, prompt = "Conflagration - move the marked player out now.", announce = "Conflagration", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 36797 }, prompt = "Mind Control - swap control and stop extra damage.", announce = "Mind Control", sound = true },
		{ event = "SPELL_AURA_APPLIED_DOSE", spellIds = { 35859 }, prompt = "Nether Vapor stacks - reset before it becomes dangerous.", announce = "Nether Vapor", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 36723 }, prompt = "Phoenix spawn - swap and burn it down.", announce = "Phoenix", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 36834 }, prompt = "Arcane Disruption - keep the arena clear and stabilize.", announce = "Arcane Disruption", sound = true },
	},
	timeline = {
		{ after = 5, label = "Advisor pull", prompt = "Pull the advisors cleanly and keep them separated.", sound = true },
		{ after = 35, label = "Advisor control", prompt = "Advisor control check - maintain target assignments and CC.", sound = true, repeatCount = 3, every = 45, ["until"] = 125 },
		{ after = 100, label = "Phase 2", prompt = "Phase 2 - move for weapons and clear the arena.", announce = "Phase 2", sound = true },
		{ after = 160, label = "Weapon cleanup", prompt = "Weapon cleanup - keep assigned targets on their weapon.", sound = true },
		{ after = 225, label = "Phase 3", prompt = "Phase 3 - reset for phoenix and Gravity Lapse handling.", announce = "Phase 3", sound = true },
		{ after = 300, label = "Final phase", prompt = "Final phase - burn the boss and keep interrupts clean.", sound = true },
	},
})
