local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("sw-brutallus", {
	name = "Sunwell Plateau - Brutallus",
	description = "Imported timer pass for Burn, Meteor Slash, Stomp, and burn-resist handling.",
	bossIds = { 24882 },
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

IPM:RegisterModule("sw-kalecgos", {
	name = "Sunwell Plateau - Kalecgos",
	description = "Imported timer pass for portals, Arcane Buffet, Frost Breath, and Wild Magic handling.",
	bossIds = { 24850, 24892 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellIds = { 44799 }, prompt = "Frost Breath - heal the tank and keep buffs ready.", announce = "Frost Breath", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45018 }, prompt = "Arcane Buffet - stack reset and tank stabilization.", announce = "Arcane Buffet", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 46021 }, prompt = "Spectral Realm - handle portal groups and assignments.", announce = "Spectral Realm", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45032, 45034 }, prompt = "Curse of Boundless Agony - move out and resolve the curse.", announce = "Curse of Boundless Agony", sound = true },
	},
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Open with portal assignments and tank rotation ready.", sound = true },
		{ after = 20, label = "Portal", prompt = "Possible portal soon - watch the spectral realm assignments.", sound = true, repeatCount = 10, every = 25, ["until"] = 245 },
		{ after = 15, label = "Breath check", prompt = "Keep Frost Breath coverage ready and stabilize the tank.", sound = true, repeatCount = 12, every = 15, ["until"] = 180 },
		{ after = 60, label = "Buffet ramp", prompt = "Arcane Buffet stacks are climbing - plan your reset.", sound = true, repeatCount = 10, every = 8, ["until"] = 140 },
	},
})

IPM:RegisterModule("sw-felmyst", {
	name = "Sunwell Plateau - Felmyst",
	description = "Imported timer pass for Gas Nova, Encapsulate, Demonic Vapor, Corrosion, and phase timing.",
	bossIds = { 25038 },
	autoMarkers = {
		{ event = "SPELL_DAMAGE", spellIds = { 45661 }, icon = 7, target = "dest", clearOnRemove = true, announce = "Encapsulate marked" },
		{ event = "SPELL_SUMMON", spellIds = { 45392 }, icon = 8, target = "dest", clearOnRemove = true, announce = "Demonic Vapor marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellIds = { 45855 }, prompt = "Gas Nova - heal through the blast and reset positioning.", announce = "Gas Nova", sound = true },
		{ event = "SPELL_SUMMON", spellIds = { 45392 }, prompt = "Demonic Vapor - swap and kill the spawn.", announce = "Demonic Vapor", sound = true },
		{ event = "SPELL_DAMAGE", spellIds = { 45661 }, prompt = "Encapsulate - rescue the target and keep the lane open.", announce = "Encapsulate", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45866 }, prompt = "Corrosion - tank cooldown and healer focus.", announce = "Corrosion", sound = true },
	},
	timeline = {
		{ after = 5, label = "Pull setup", prompt = "Open with spread positions and vapor assignments.", sound = true },
		{ after = 30, label = "Encapsulate", prompt = "Prepare for Encapsulate and keep the proximity clean.", sound = true, repeatCount = 8, every = 30, ["until"] = 240 },
		{ after = 55, label = "Deep Breath soon", prompt = "Watch for the air phase and clear the lane for Deep Breath.", sound = true, repeatCount = 4, every = 100, ["until"] = 360 },
		{ after = 60, label = "Phase marker", prompt = "Track the landing and takeoff pattern for the next phase.", sound = true },
	},
})

IPM:RegisterModule("sw-twins", {
	name = "Sunwell Plateau - The Eredar Twins",
	description = "Imported timer pass for Pyrogenics, Shadow Nova, Conflagration, and threat handling.",
	bossIds = { 25166, 25165 },
	cycles = {
		kick = {},
	},
	autoMarkers = {
		{ event = "SPELL_CAST_START", spellIds = { 45342 }, icon = 8, target = "dest", clearOnRemove = true, announce = "Conflagration marked" },
		{ event = "SPELL_AURA_REMOVED", spellIds = { 45342 }, icon = 8, target = "dest", clearOnRemove = true },
	},
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45230 }, prompt = "Pyrogenics - dispel the buff if assigned.", announce = "Pyrogenics", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 45256 }, prompt = "Confounding Blow - tank check and next swap.", announce = "Confounding Blow", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 45248 }, prompt = "Shadow Blades - watch the cleave and keep the boss faced away.", announce = "Shadow Blades", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 45342 }, prompt = "Conflagration - move immediately and keep the target safe.", announce = "Conflagration", sound = true },
		{ event = "SPELL_CAST_START", spellIds = { 45329 }, prompt = "Shadow Nova - kick or interrupt the cast sequence.", announce = "Shadow Nova", interruptCycle = "kick", sound = true },
	},
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Open with threat assignments and proximity spacing.", sound = true },
		{ after = 15, label = "Nova cycle", prompt = "Kick the next Shadow Nova and keep the interrupt rotation clean.", interruptCycle = "kick", sound = true, repeatCount = 8, every = 32, ["until"] = 250 },
		{ after = 25, label = "Conflag check", prompt = "Watch for Conflagration and move the marked player out.", sound = true, repeatCount = 7, every = 32, ["until"] = 220 },
		{ after = 45, label = "Threat check", prompt = "Check the threat ordering for Alythess and Sacrolash.", sound = true, repeatCount = 5, every = 40, ["until"] = 220 },
	},
})

IPM:RegisterModule("sw-muru", {
	name = "Sunwell Plateau - M'uru",
	description = "Imported timer pass for Darkness, add waves, and the Entropius transition.",
	bossIds = { 25741, 25840 },
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
	bossIds = { 25315, 25588 },
	cycles = {
		kick = {},
	},
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 45641 }, icon = 1, sequence = { 1, 2, 3, 4, 5, 6, 7, 8 }, clearOnRemove = true, announce = "Fire Bloom marked" },
		{ event = "SPELL_AURA_REMOVED", spellIds = { 45641 }, icon = 1, clearOnRemove = true },
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
