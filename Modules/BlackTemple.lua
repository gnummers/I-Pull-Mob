local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("bt-najentus", {
	name = "Black Temple - High Warlord Naj'entus",
	description = "Starter timing pass for Impaling Spine and shield breaks.",
	bossIds = { 22887 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Impaling Spine", prompt = "Impaling Spine - catch the spine and keep the raid safe.", announce = "Impaling Spine", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread for spines and keep the tank stable.", sound = true },
		{ after = 35, label = "Shield window", prompt = "Break the shield and keep the boss moving.", sound = true },
		{ after = 70, label = "Repeat", prompt = "Prepare for the next spine and reset positioning.", sound = true },
	},
})

IPM:RegisterModule("bt-supremus", {
	name = "Black Temple - Supremus",
	description = "Starter timing pass for the kite and face-swapping fight.",
	bossIds = { 22898 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Molten Flame", prompt = "Molten Flame - move the raid and keep the kiter safe.", announce = "Molten Flame", sound = true },
	},
	timeline = {
		{ after = 12, label = "Kite phase", prompt = "Keep the boss moving and avoid the fire patches.", sound = true },
		{ after = 48, label = "Burn phase", prompt = "Prepare for the stationary burn window.", sound = true },
		{ after = 96, label = "Repeat", prompt = "Reset to kite phase and keep fire lanes clean.", sound = true },
	},
})

IPM:RegisterModule("bt-akama", {
	name = "Black Temple - Shade of Akama",
	description = "Starter timing pass for the shade phase and add control.",
	bossIds = { 22841 },
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open with add control and protect Akama.", sound = true },
		{ after = 40, label = "Shade phase", prompt = "Swap to the Shade and keep interrupts organized.", sound = true },
		{ after = 80, label = "Transition", prompt = "Re-center and prepare for the next add wave.", sound = true },
	},
})

IPM:RegisterModule("bt-teron", {
	name = "Black Temple - Teron Gorefiend",
	description = "Starter timing pass for Shadow of Death and ghost management.",
	bossIds = { 22871 },
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Shadow of Death", prompt = "Shadow of Death - ghost duty and corpse management.", announce = "Shadow of Death", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Keep the raid spread and watch for the first ghost target.", sound = true },
		{ after = 45, label = "Ghost check", prompt = "Handle ghost spawns and stabilize the raid.", sound = true },
		{ after = 90, label = "Repeat", prompt = "Prepare for the next Shadow of Death and add control.", sound = true },
	},
})

IPM:RegisterModule("bt-gurtogg", {
	name = "Black Temple - Gurtogg Bloodboil",
	description = "Starter timing pass for Fel Rage, Acidic Wound, and raid swapping.",
	bossIds = { 22948 },
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Fel Rage", icon = 8, target = "dest", clearOnRemove = true, announce = "Fel Rage marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Fel Rage", prompt = "Fel Rage - swap targets and protect the player.", announce = "Fel Rage", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellName = "Acidic Wound", prompt = "Acidic Wound - tank swap and healing spike.", announce = "Acidic Wound", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open with tank control and raid spread.", sound = true },
		{ after = 35, label = "Fel Rage", prompt = "Fel Rage window - move and protect the target.", sound = true },
		{ after = 75, label = "Bloodboil", prompt = "Stabilize through the raid damage spike.", sound = true },
	},
})

IPM:RegisterModule("bt-reliquary", {
	name = "Black Temple - Reliquary of Souls",
	description = "Starter timing pass for the three essence phases.",
	timeline = {
		{ after = 10, label = "Essence 1", prompt = "Phase 1 - control the first essence and keep the raid alive.", sound = true },
		{ after = 50, label = "Essence 2", prompt = "Phase 2 - swap targets and handle the next set of mechanics.", sound = true },
		{ after = 95, label = "Essence 3", prompt = "Phase 3 - finish the last essence and prepare the final burn.", sound = true },
	},
})

IPM:RegisterModule("bt-mother-shahraz", {
	name = "Black Temple - Mother Shahraz",
	description = "Starter timing pass for Fatal Attraction and beam handling.",
	bossIds = { 22947 },
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Fatal Attraction", icon = 8, target = "dest", clearOnRemove = true, announce = "Fatal Attraction marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Fatal Attraction", prompt = "Fatal Attraction - spread immediately and resolve the link.", announce = "Fatal Attraction", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Spread for beams and keep the raid clean.", sound = true },
		{ after = 45, label = "Beam check", prompt = "Prepare for the next beam and movement call.", sound = true },
		{ after = 90, label = "Attraction", prompt = "Watch for Fatal Attraction and resolve it cleanly.", sound = true },
	},
})

IPM:RegisterModule("bt-council", {
	name = "Black Temple - Illidari Council",
	description = "Starter timing pass for the four-boss council and priority interrupts.",
	cycles = {
		kick = { "Rogue", "Shaman", "Mage" },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Assign target priorities and interrupts by boss.", sound = true },
		{ after = 40, label = "Interrupt check", prompt = "Kick the next dangerous cast.", interruptCycle = "kick", sound = true, repeatCount = 6, every = 20, ["until"] = 140 },
		{ after = 95, label = "Transition", prompt = "Stabilize the group and keep your assigned target locked.", sound = true },
	},
})

IPM:RegisterModule("bt-illidan", {
	name = "Black Temple - Illidan Stormrage",
	description = "Starter timing pass for Shear, Flame Crash, and phase transitions.",
	bossIds = { 22917 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Shear", prompt = "Shear - tank cooldown or swap immediately.", announce = "Shear", sound = true },
		{ event = "SPELL_CAST_START", spellName = "Flame Crash", prompt = "Flame Crash - move the raid off the fire.", announce = "Flame Crash", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Open with tank control and raid spread.", sound = true },
		{ after = 55, label = "Phase 2", prompt = "Prepare for the demon phase and add control.", sound = true },
		{ after = 110, label = "Phase 3", prompt = "Reset for the next wave and keep the raid spread.", sound = true },
		{ after = 165, label = "Final burn", prompt = "Execute the burn plan and keep Shear covered.", sound = true },
	},
})
