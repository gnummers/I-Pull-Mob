local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("maulgar", {
	name = "Gruul's Lair - High King Maulgar",
	description = "Starter Maulgar module: whirlwind, fear, and add control reminders.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Whirlwind", prompt = "Whirlwind - move melee away from the king.", announce = "Whirlwind", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Intimidating Roar", prompt = "Fear - prepare to recover from fear.", announce = "Fear", sound = true },
	},
	timeline = {
		{ after = 10, label = "Add Control", prompt = "Keep the council controlled and marked." },
		{ after = 25, label = "Whirlwind", prompt = "Move melee away from the king." },
		{ after = 40, label = "Fear", prompt = "Prepare to recover from fear." },
		{ after = 55, label = "Whirlwind", prompt = "Move melee away from the king." },
		{ after = 70, label = "Fear", prompt = "Prepare to recover from fear." },
	},
})
