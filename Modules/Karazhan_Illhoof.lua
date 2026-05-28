local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-illhoof", {
	name = "Terestian Illhoof",
	description = "Starter timing pass for sacrifice, imp waves, and demonic chains.",
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Sacrifice", prompt = "Sacrifice - free the target and keep healing focused.", announce = "Sacrifice", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Demonic Chains", prompt = "Demonic Chains - break the target out and keep the add controlled.", announce = "Demonic Chains", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread for imp waves and keep the boss in position.", sound = true },
		{ after = 35, label = "Imp wave", prompt = "Imp wave soon - swap to adds if needed and keep them controlled.", sound = true },
		{ after = 60, label = "Imp wave", prompt = "Imp wave - clear the adds and stabilize the raid.", sound = true },
		{ after = 95, label = "Dark phase", prompt = "Prepare for the next sacrifice or chain and keep the tank alive.", sound = true },
	},
})
