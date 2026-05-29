local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("gruuls-lair", {
	name = "Gruul's Lair - Gruul the Dragonkiller",
	description = "Starter Gruul module: Growth, Cave In, Hurtful Strike, and Shatter reminders.",
	bossIds = { 19044 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Shatter", prompt = "Shatter - spread immediately and keep the raid moving.", announce = "Shatter incoming", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Cave In", prompt = "Cave In - move out of the void zone.", announce = "Cave In", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellName = "Growth", prompt = "Growth - watch your stack count and prepare for the next hit.", sound = true },
	},
	timeline = {
		{ after = 30, label = "Growth 1", prompt = "Watch your stack count and spread." },
		{ after = 50, label = "Cave In", prompt = "Move out of the void zone." },
		{ after = 60, label = "Shatter", prompt = "Spread immediately for Shatter.", announce = "Shatter incoming", sound = true },
		{ after = 90, label = "Growth 2", prompt = "Watch for higher damage on tanks." },
		{ after = 100, label = "Cave In", prompt = "Move out of the void zone." },
		{ after = 120, label = "Shatter", prompt = "Spread immediately for Shatter.", announce = "Shatter incoming", sound = true },
		{ after = 150, label = "Growth 3", prompt = "Prepare for stronger hits." },
		{ after = 160, label = "Cave In", prompt = "Move out of the void zone." },
		{ after = 180, label = "Shatter", prompt = "Spread immediately for Shatter.", announce = "Shatter incoming", sound = true },
	},
})
