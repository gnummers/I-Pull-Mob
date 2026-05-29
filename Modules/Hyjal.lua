local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("hyjal-rage-winterchill", {
	name = "Mount Hyjal - Rage Winterchill",
	description = "Starter timing pass for the opening Hyjal wave boss and its core damage checks.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Death and Decay", prompt = "Death and Decay - move the raid out immediately.", announce = "Death and Decay", sound = true },
	},
	timeline = {
		{ after = 8, label = "Pull setup", prompt = "Set the first wave and keep the raid spread.", sound = true },
		{ after = 35, label = "Core damage", prompt = "Stabilize the raid and keep tanks topped.", sound = true },
		{ after = 70, label = "Transition", prompt = "Prepare for the next undead wave and reset cooldowns.", sound = true },
	},
})

IPM:RegisterModule("hyjal-anetheron", {
	name = "Mount Hyjal - Anetheron",
	description = "Starter timing pass for the infernal and swarm pressure in Hyjal.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Carrion Swarm", prompt = "Carrion Swarm - brace the raid and heal through it.", announce = "Carrion Swarm", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread for swarm and watch the infernal landing zone.", sound = true },
		{ after = 40, label = "Pressure", prompt = "Stabilize the raid and keep the infernal clear.", sound = true },
		{ after = 80, label = "Transition", prompt = "Reset and prepare for the next add cycle.", sound = true },
	},
})

IPM:RegisterModule("hyjal-kazrogal", {
	name = "Mount Hyjal - Kaz'rogal",
	description = "Starter timing pass for mana burn management and tank stability.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "War Stomp", prompt = "War Stomp - stabilize after the hit and watch mana.", announce = "War Stomp", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Mark of Kaz'rogal", prompt = "Mark of Kaz'rogal - mana check and defensive cooldowns.", announce = "Mark of Kaz'rogal", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open cleanly and track mana burn pressure.", sound = true },
		{ after = 50, label = "Mana check", prompt = "Check healer mana and assign the next recovery window.", sound = true },
		{ after = 95, label = "Transition", prompt = "Prepare for the next mark and keep cooldowns available.", sound = true },
	},
})

IPM:RegisterModule("hyjal-azgalor", {
	name = "Mount Hyjal - Azgalor",
	description = "Starter timing pass for doom, swarm, and ground pressure.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Rain of Fire", prompt = "Rain of Fire - move out of the patch.", announce = "Rain of Fire", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Howl of Azgalor", prompt = "Howl of Azgalor - stabilize the raid and keep tanks covered.", announce = "Howl of Azgalor", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellName = "Doom", prompt = "Doom - assign the target and prepare the dispel plan.", announce = "Doom", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Spread for Rain of Fire and keep Doom assignments ready.", sound = true },
		{ after = 48, label = "Healing spike", prompt = "Brace for heavy raid damage and watch for Doom.", sound = true },
		{ after = 96, label = "Transition", prompt = "Reset the raid and prepare for the next ground phase.", sound = true },
	},
})

IPM:RegisterModule("hyjal-archimonde", {
	name = "Mount Hyjal - Archimonde",
	description = "Starter timing pass for Doomfire, Air Burst, and the final Hyjal burn.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Air Burst", prompt = "Air Burst - move fast and survive the drop.", announce = "Air Burst", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Doomfire", prompt = "Doomfire - move away from the flames immediately.", announce = "Doomfire", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Spread out and keep the doomfire lane clear.", sound = true },
		{ after = 45, label = "Ground pressure", prompt = "Watch your feet and keep the raid stabilized.", sound = true },
		{ after = 90, label = "Final burn", prompt = "Prepare defensive cooldowns for the last burn window.", sound = true },
	},
})
