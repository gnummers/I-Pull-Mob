local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-curator", {
	name = "Karazhan - The Curator",
	description = "Starter Curator module: flare waves, Evocation, and burn reminders.",
	bossIds = { 15691 },
	cycles = {
		flare = { "Rogue", "Mage", "Shaman" },
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Evocation", prompt = "Evocation - swap to boss and use cooldowns.", announce = "Curator is evoking", sound = true },
		{ event = "SPELL_SUMMON", spellName = "Astral Flare", prompt = "Astral Flare - burn the current flare wave.", sound = true },
	},
	timeline = {
		{ after = 10, label = "Flare wave", prompt = "Burn the current flare wave.", repeatCount = 6, every = 15, ["until"] = 90 },
		{ after = 105, label = "Evocation soon", prompt = "Get ready to switch to boss damage for Evocation.", sound = true },
		{ after = 120, label = "Burn window", prompt = "Boss burn - use cooldowns and finish the phase cleanly.", sound = true },
	},
})
