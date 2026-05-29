local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-vashj", {
	name = "Lady Vashj",
	description = "Imported timing pass for Shock Blast, Static Charge, Entangle, and phase transition reminders.",
	bossIds = { 21212 },
	autoMarkers = {
		{ event = "SPELL_AURA_APPLIED", spellIds = { 38280 }, icon = 8, target = "dest", clearOnRemove = true, announce = "Static Charge marked" },
	},
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellIds = { 38253 }, prompt = "Shock Blast - tank check and healer attention.", announce = "Shock Blast", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellIds = { 38280 }, prompt = "Static Charge - move out with the debuffed player.", announce = "Static Charge", sound = true },
		{ event = "SPELL_CAST_SUCCESS", spellIds = { 38316 }, prompt = "Entangle - recover quickly and keep the raid stable.", announce = "Entangle", sound = true },
		{ event = "SPELL_AURA_REMOVED", spellIds = { 38112 }, prompt = "Barrier down - expect the next phase pressure soon.", announce = "Barrier down", sound = true },
	},
	timeline = {
		{ after = 6, label = "Phase 1 setup", prompt = "Spread for Phase 1 and keep Grounding / tank coverage ready.", sound = true },
		{ after = 70, label = "Phase 2 soon", prompt = "Phase 2 soon. Move to add control positions and assign cores.", sound = true },
		{ after = 92, label = "Phase 2", prompt = "Phase 2 - assign strider control, elite add kills, and core runners.", announce = "Phase 2", sound = true },
		{ after = 110, label = "Core toss", prompt = "Tainted Core delivery check - keep a runner ready.", sound = true, repeatCount = 3, every = 24, ["until"] = 170 },
		{ after = 160, label = "Phase 3 soon", prompt = "Phase 3 soon. Reset the raid and prepare for Static Charge.", sound = true },
		{ after = 182, label = "Phase 3", prompt = "Phase 3 - stack and execute the burn plan.", announce = "Phase 3", sound = true },
	},
})
