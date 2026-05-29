local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("sw-brutallus", {
	name = "Sunwell Plateau - Brutallus",
	description = "Imported timer pass for Burn, Meteor Slash, Stomp, and burn-resist handling.",
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 46394 }, prompt = "Burn - spread to 5 yards and keep the debuff target alive.", announce = "Burn", sound = true },
		{ event = "SPELL_MISSED", spellIds = { 45141 }, prompt = "Burn resisted - note the resist and keep the soak plan stable.", announce = "Burn resist", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 45150 }, prompt = "Meteor Slash - tank hit incoming, heal through the slam.", announce = "Meteor Slash", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45185 }, prompt = "Stomp - top the raid and reset positioning.", announce = "Stomp", sound = true },
	},
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Open with the burn-soak plan and keep the raid spread.", sound = true },
		{ after = 18, label = "Burn check", prompt = "Burn assignment check - keep the debuffed player out and stable.", sound = true, repeatCount = 10, every = 20, ["until"] = 200 },
		{ after = 27, label = "Stomp recovery", prompt = "Prepare for the next Stomp and keep tank healing heavy.", sound = true, repeatCount = 8, every = 30.5, ["until"] = 270 },
	},
})

IPM:RegisterModule("sw-muru", {
	name = "Sunwell Plateau - M'uru",
	description = "Imported timer pass for Darkness, add waves, and the Entropius transition.",
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45996 }, prompt = "Darkness - heal through the cast and keep the boss stable.", announce = "Darkness", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45934 }, prompt = "Dark Fiend - swap and clear the spawn.", announce = "Dark Fiend", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 46177 }, prompt = "Phase 2 - portals open and Entropius is active.", announce = "Phase 2", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 46282 }, prompt = "Black Hole - react immediately and keep the room open.", announce = "Black Hole", sound = true },
	},
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Open with disciplined add control and assign pickup duties.", sound = true },
		{ after = 10, label = "Humanoid add", prompt = "Humanoid add spawn - keep the next control pack ready.", sound = true, repeatCount = 6, every = 60, ["until"] = 310 },
		{ after = 30, label = "Sentinel", prompt = "Void Sentinel spawn - swap and burn it down.", sound = true, repeatCount = 9, every = 30, ["until"] = 280 },
		{ after = 105, label = "Phase 2 soon", prompt = "Entropius soon - finish stage 1 control and prepare the transition.", sound = true },
	},
})

IPM:RegisterModule("sw-kiljaeden", {
	name = "Sunwell Plateau - Kil'jaeden",
	description = "Imported timer pass for reflections, orbs, Fire Bloom, and Shadow Spike handling.",
	cycles = {
		kick = {},
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45892 }, prompt = "Sinister Reflection - handle clones and stop extra damage.", announce = "Sinister Reflection", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45848 }, prompt = "Shield of the Blue - swap to the correct target and keep the orb under control.", announce = "Shield of the Blue", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45641 }, prompt = "Fire Bloom - move out and keep the bloom target alive.", announce = "Fire Bloom", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 46680 }, prompt = "Shadow Spike - kick the cast or prepare to move.", announce = "Shadow Spike", interruptCycle = "kick", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45885 }, prompt = "Shadow Spike target - react to the debuff immediately.", announce = "Shadow Spike", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open with orb assignments and keep the ranged spread.", sound = true },
		{ after = 40, label = "Bomb window", prompt = "Prepare for the next Darkness of a Thousand Souls window.", sound = true, repeatCount = 6, every = 45, ["until"] = 265 },
		{ after = 120, label = "Phase check", prompt = "Check phase progression and keep dragon orb usage efficient.", sound = true },
		{ after = 220, label = "Final burn", prompt = "Final burn - save raid cooldowns and keep the raid spread.", sound = true },
	},
})
