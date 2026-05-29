local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-nightbane", {
	name = "Karazhan - Nightbane",
	description = "Starter Nightbane module: air phase and fear handling reminders.",
	bossIds = { 17225, 17261 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Smoking Blast", prompt = "Smoking Blast - move the tank and keep the raid healthy.", announce = "Smoking Blast", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Charred Earth", prompt = "Charred Earth - move out of the fire patch.", announce = "Charred Earth", sound = true },
	},
	timeline = {
		{ after = 40, label = "Air Phase 1", prompt = "Air phase - handle Rain of Bones and stay clear of the fire.", sound = true },
		{ after = 70, label = "Ground Phase", prompt = "Ground phase - reset positions and get ready for the next air phase.", sound = true },
		{ after = 115, label = "Air Phase 2", prompt = "Air phase - handle Rain of Bones and stay clear of the fire.", sound = true },
		{ after = 145, label = "Ground Phase", prompt = "Ground phase - reset positions and get ready for the next air phase.", sound = true },
		{ after = 190, label = "Air Phase 3", prompt = "Air phase - finish the fight and keep the raid spread.", sound = true },
	},
})
