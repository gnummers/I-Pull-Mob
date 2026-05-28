local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-lurker", {
	name = "The Lurker Below",
	description = "Starter timing pass for Spout, submerge cycles, and melee repositioning.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Spout", prompt = "Spout - move immediately around the pool.", announce = "Spout", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellName = "Submerge", prompt = "Submerge - stack adds, then reset your position for the next phase.", announce = "Submerge", sound = true },
	},
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Spread on the outer ring and leave room for Spout movement.", sound = true },
		{ after = 35, label = "Spout soon", prompt = "Spout soon - get ready to move as soon as the cast starts.", sound = true },
		{ after = 105, label = "Whirl", prompt = "Whirl - melee check and tank positioning.", sound = true, repeatCount = 3, every = 60, ["until"] = 225 },
	},
})
