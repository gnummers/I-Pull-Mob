local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-maiden", {
	name = "Karazhan - Maiden of Virtue",
	description = "Starter Maiden module: Holy Fire and Repentance reminders.",
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Holy Fire", prompt = "Holy Fire - get the target away from the raid.", announce = "Holy Fire", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Repentance", prompt = "Repentance - move to break it or prepare a self-heal.", announce = "Repentance incoming", sound = true },
	},
	timeline = {
		{ after = 13, label = "Holy Fire", prompt = "Keep distance from the debuffed target." },
		{ after = 30, label = "Repentance", prompt = "Move to break repentance or prepare self-heals.", announce = "Repentance incoming", sound = true },
		{ after = 43, label = "Holy Fire", prompt = "Keep distance from the debuffed target." },
		{ after = 60, label = "Repentance", prompt = "Move to break repentance or prepare self-heals.", announce = "Repentance incoming", sound = true },
		{ after = 73, label = "Holy Fire", prompt = "Keep distance from the debuffed target." },
		{ after = 90, label = "Repentance", prompt = "Move to break repentance or prepare self-heals.", announce = "Repentance incoming", sound = true },
	},
})
