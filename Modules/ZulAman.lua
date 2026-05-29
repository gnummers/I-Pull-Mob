local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("za-nalorakk", {
	name = "Zul'Aman - Nalorakk",
	description = "Starter timing pass for the bear phase swap and surge pressure.",
	combatLogTriggers = {
		{ event = "SPELL_AURA_APPLIED", spellName = "Surge", prompt = "Surge - tank swap and stabilize the target.", announce = "Surge", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open cleanly and track the bear phase swap.", sound = true },
		{ after = 45, label = "Bear phase", prompt = "Watch for the bear phase and keep the tank safe.", sound = true },
		{ after = 90, label = "Troll phase", prompt = "Reset for the troll phase and prepare to move.", sound = true },
	},
})

IPM:RegisterModule("za-akilzon", {
	name = "Zul'Aman - Akil'zon",
	description = "Starter timing pass for Electrical Storm and add control.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Electrical Storm", prompt = "Electrical Storm - stack and follow the safe call.", announce = "Electrical Storm", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Spread for Static Disruption and be ready to stack.", sound = true },
		{ after = 40, label = "Storm soon", prompt = "Prepare to stack for Electrical Storm.", sound = true },
		{ after = 80, label = "Repeat", prompt = "Reset spread and watch the next storm timing.", sound = true },
	},
})

IPM:RegisterModule("za-janalai", {
	name = "Zul'Aman - Jan'alai",
	description = "Starter timing pass for eggs, bombs, and hatchling waves.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Flame Breath", prompt = "Flame Breath - move the tank and keep the raid safe.", announce = "Flame Breath", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open on the boss and be ready for eggs.", sound = true },
		{ after = 35, label = "Egg phase", prompt = "Egg phase - clear the hatchlings and keep adds controlled.", sound = true },
		{ after = 70, label = "Bomb phase", prompt = "Bomb phase - watch your feet and keep moving.", sound = true },
	},
})

IPM:RegisterModule("za-halazzi", {
	name = "Zul'Aman - Halazzi",
	description = "Starter timing pass for totems, splits, and lynx pressure.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Lynx Rush", prompt = "Lynx Rush - move the raid and stabilize the target.", announce = "Lynx Rush", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Keep totems and tank positioning under control.", sound = true },
		{ after = 45, label = "Split phase", prompt = "Split phase - pick up the lynx and protect the raid.", sound = true },
		{ after = 85, label = "Reform", prompt = "Reset after the split and prepare for the next push.", sound = true },
	},
})

IPM:RegisterModule("za-malacrass", {
	name = "Zul'Aman - Hex Lord Malacrass",
	description = "Starter timing pass for the spirit bolts and possessed adds.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Spirit Bolts", prompt = "Spirit Bolts - heal through the raid damage spike.", announce = "Spirit Bolts", sound = true },
	},
	timeline = {
		{ after = 12, label = "Pull setup", prompt = "Assign interrupts and watch the possessed adds.", sound = true },
		{ after = 42, label = "Bolts", prompt = "Spirit Bolts window - stabilize the raid.", sound = true },
		{ after = 82, label = "Transition", prompt = "Prepare for the next possessed add and spell set.", sound = true },
	},
})

IPM:RegisterModule("za-zuljin", {
	name = "Zul'Aman - Zul'jin",
	description = "Starter timing pass for the phase swaps and final burn.",
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Whirlwind", prompt = "Whirlwind - keep melee out and protect the raid.", announce = "Whirlwind", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Open cleanly and prepare for the first phase swap.", sound = true },
		{ after = 40, label = "Phase 2", prompt = "Phase 2 - handle the second form and keep the raid moving.", sound = true },
		{ after = 80, label = "Phase 3", prompt = "Phase 3 - reset for the bear form and damage spikes.", sound = true },
		{ after = 120, label = "Final burn", prompt = "Final burn - keep the raid stable and finish the boss.", sound = true },
	},
})
