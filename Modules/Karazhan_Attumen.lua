local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-attumen", {
	name = "Karazhan - Attumen the Huntsman",
	description = "Starter Attumen module: phase swap and charge reminders.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Berserker Charge", prompt = "Berserker Charge - move immediately and keep the tank safe.", announce = "Berserker Charge", sound = true },
	},
	timeline = {
		{ after = 15, label = "Shadow Cleave", prompt = "Stay out of cleave range on the tank." },
		{
			after = 60,
			label = "Mount Phase",
			prompt = "Swap to Midnight and get ready to reposition.",
			announce = "Attumen is mounting",
			sound = true,
		},
		{ after = 90, label = "Berserker Charge", prompt = "Move for charge and keep spread." },
	},
})
