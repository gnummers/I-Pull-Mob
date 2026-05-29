local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-morogrim", {
	name = "Morogrim Tidewalker",
	description = "Starter timing pass for Watery Grave, Earthquake, and murloc wave movement.",
	bossIds = { 21213 },
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Watery Grave", prompt = "Watery Grave - pick up the encased player and keep the raid spread.", announce = "Watery Grave", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Earthquake", prompt = "Earthquake - move the raid and avoid stacked damage.", announce = "Earthquake", sound = true },
	},
	timeline = {
		{ after = 12, label = "Watery Grave", prompt = "Watery Grave - pick up the encased player and keep the raid spread.", announce = "Watery Grave", sound = true, repeatCount = 5, every = 22, ["until"] = 120 },
		{ after = 28, label = "Murloc wave", prompt = "Murloc wave incoming. Be ready to kite and slow.", sound = true, repeatCount = 4, every = 45, ["until"] = 180 },
		{ after = 152, label = "Phase 2", prompt = "Phase 2 - stop Watery Grave and pivot into water globule cleanup.", sound = true },
	},
})
