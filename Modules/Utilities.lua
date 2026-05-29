local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("pull-timers", {
	name = "Utility - Pull Timers",
	description = "A simple pull countdown module for raid starts and sync checks.",
	timeline = {
		{ after = 1, label = "Pull 1", prompt = "Pull in 1", sound = true },
		{ after = 2, label = "Pull 2", prompt = "Pull in 2", sound = true },
		{ after = 3, label = "Pull 3", prompt = "Pull in 3", sound = true },
		{ after = 5, label = "Pull 5", prompt = "Pull in 5", sound = true },
		{ after = 10, label = "Pull 10", prompt = "Pull in 10", sound = true },
	},
})

IPM:RegisterModule("break-timers", {
	name = "Utility - Break Timers",
	description = "A fixed break countdown module for raid pauses and short AFK windows.",
	timeline = {
		{ after = 60, label = "Break 4", prompt = "Break ends in 4 minutes", sound = true },
		{ after = 120, label = "Break 3", prompt = "Break ends in 3 minutes", sound = true },
		{ after = 180, label = "Break 2", prompt = "Break ends in 2 minutes", sound = true },
		{ after = 240, label = "Break 1", prompt = "Break ends in 1 minute", sound = true },
		{ after = 270, label = "Break 30", prompt = "Break ends in 30 seconds", sound = true },
		{ after = 290, label = "Break 10", prompt = "Break ends in 10 seconds", sound = true },
		{ after = 295, label = "Break 5", prompt = "Break ends in 5 seconds", sound = true },
		{ after = 299, label = "Break 1", prompt = "Break ends in 1 second", sound = true },
	},
})

IPM:RegisterModule("range-helper", {
	name = "Utility - Range Helper",
	description = "A minimal range reminder for spread and stack assignments.",
	persistentPrompt = true,
	persistentPromptText = function()
		local yards = IPM.GetRangeValue and IPM:GetRangeValue()
		if yards then
			return string.format("Maintain %d-yard range", yards)
		end

		return "Maintain assigned range"
	end,
})

IPM:RegisterModule("reminder-popups", {
	name = "Utility - Reminder Popups",
	description = "Generic pre-pull or mid-raid reminder prompts.",
	timeline = {
		{ after = 15, label = "Reminder 1", prompt = "Check consumes, buffs, and assignments" },
		{ after = 30, label = "Reminder 2", prompt = "Refresh any raid markers or assignments" },
		{ after = 45, label = "Reminder 3", prompt = "Verify interrupts and cooldown rotation" },
	},
})

IPM:RegisterModule("taunt-alerter", {
	name = "Utility - Taunt Alerter",
	description = "Generic tank swap reminders for fights that use taunt rotations.",
	cycles = {
		taunt = { "Tank One", "Tank Two" },
	},
	timeline = {
		{ after = 10, label = "Taunt 1", prompt = "Taunt swap now", interruptCycle = "taunt", sound = true },
		{ after = 25, label = "Taunt 2", prompt = "Taunt swap now", interruptCycle = "taunt", sound = true },
		{ after = 40, label = "Taunt 3", prompt = "Taunt swap now", interruptCycle = "taunt", sound = true },
		{ after = 55, label = "Taunt 4", prompt = "Taunt swap now", interruptCycle = "taunt", sound = true },
	},
})

IPM:RegisterModule("prepull-checklist", {
	name = "Utility - Pre-Pull Checklist",
	description = "A short checklist for buffs, consumes, assignments, and ready checks before a pull.",
	timeline = {
		{ after = 5, label = "Buff check", prompt = "Verify buffs, consumes, and weapon enchants." },
		{ after = 12, label = "Assignment check", prompt = "Confirm assignments: tank, interrupts, and markers." },
		{ after = 20, label = "Ready check", prompt = "Run a final ready check and start the pull timer.", sound = true },
	},
})

IPM:RegisterModule("raid-cooldowns", {
	name = "Utility - Raid Cooldowns",
	description = "A generic reminder track for raid-wide healing or defensive cooldowns.",
	timeline = {
		{ after = 20, label = "CD 1", prompt = "Call for the first raid cooldown.", sound = true },
		{ after = 90, label = "CD 2", prompt = "Call for the second raid cooldown.", sound = true },
		{ after = 160, label = "CD 3", prompt = "Call for the third raid cooldown.", sound = true },
		{ after = 230, label = "CD 4", prompt = "Call for the next raid cooldown.", sound = true },
	},
})

IPM:RegisterModule("mana-reminders", {
	name = "Utility - Mana Reminders",
	description = "Reminder prompts for healers and casters who need to watch mana throughout a fight.",
	timeline = {
		{ after = 45, label = "Mana check", prompt = "Check healer mana and plan the next external cooldown." },
		{ after = 90, label = "Mana pot", prompt = "Use a mana potion or ask for an innervate if needed.", sound = true },
		{ after = 150, label = "Mana check 2", prompt = "Re-evaluate mana and assign the next recovery window." },
	},
})

IPM:RegisterModule("ssc-core-runners", {
	name = "Utility - SSC Core Runners",
	description = "Tainted Core handoff reminders for Lady Vashj and similar pickup mechanics.",
	cycles = {
		core = { "Runner One", "Runner Two", "Runner Three" },
	},
	timeline = {
		{ after = 20, label = "Core 1", prompt = "Tainted Core handoff", interruptCycle = "core", sound = true },
		{ after = 40, label = "Core 2", prompt = "Tainted Core handoff", interruptCycle = "core", sound = true },
		{ after = 60, label = "Core 3", prompt = "Tainted Core handoff", interruptCycle = "core", sound = true },
		{ after = 80, label = "Core 4", prompt = "Tainted Core handoff", interruptCycle = "core", sound = true },
	},
})

IPM:RegisterModule("tk-assignment-helper", {
	name = "Utility - TK Assignment Helper",
	description = "Assignment and marker reminders for Kael'thas, Solarian, and other Tempest Keep mechanics.",
	timeline = {
		{ after = 15, label = "Assignment check", prompt = "Confirm target assignments, CC, and tank marks." },
		{ after = 50, label = "Weapon check", prompt = "Assign your weapon target or add pickup." },
		{ after = 95, label = "Swap check", prompt = "Reconfirm swaps, interrupts, and priority targets.", sound = true },
	},
})

IPM:RegisterModule("raid-movement", {
	name = "Utility - Raid Movement",
	description = "Generic spread, stack, and reposition reminders for heavy movement fights.",
	timeline = {
		{ after = 10, label = "Spread", prompt = "Spread out and leave room for targeted mechanics.", sound = true },
		{ after = 35, label = "Stack", prompt = "Stack on the marker and prepare for the next mechanic.", sound = true },
		{ after = 60, label = "Move", prompt = "Move now and keep your camera on the boss.", sound = true },
	},
})

IPM:RegisterModule("raid-leader-tools", {
	name = "Utility - Raid Leader Tools",
	description = "Shared pull countdown, ready check, and leader reminder helpers.",
	onStart = function()
		if IPM.PrintRaidLeaderTools then
			IPM:PrintRaidLeaderTools()
		end
	end,
	timeline = {
		{ after = 1, label = "Pull countdown", prompt = "Use /ipm pull for a countdown or hit the pull button in options.", sound = true },
		{ after = 5, label = "Ready check", prompt = "Use /ipm ready to send a ready check.", sound = true },
		{ after = 15, label = "Kill record", prompt = "Use /ipm kill after the boss dies to save the time.", sound = true },
	},
})

IPM:RegisterModule("automarker", {
	name = "Utility - Automarker",
	description = "Shared raid marker support for boss modules that declare autoMarkers.",
	onStart = function()
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99I Pull Mob|r: Automarker support is ready for modules that define autoMarkers.")
		end
	end,
	timeline = {
		{ after = 2, label = "Marker reminder", prompt = "Boss modules can assign markers automatically from combat log events.", sound = true },
		{ after = 10, label = "Marker check", prompt = "Verify you have raid assist rights before relying on markers.", sound = true },
	},
})

IPM:RegisterModule("boss-kill-times", {
	name = "Utility - Boss Kill Times",
	description = "Kill-time recording and post-fight summary helper.",
	onStart = function()
		local encounterId = IPM.GetCurrentEncounter and IPM:GetCurrentEncounter()
		if encounterId then
			IPM:PrintKillSummary(encounterId)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99I Pull Mob|r: Use /ipm kill to record a boss time and /ipm summary <module> to review history.")
		end
	end,
	timeline = {
		{ after = 3, label = "Record kill", prompt = "Use /ipm kill when the boss dies to save the kill time.", sound = true },
		{ after = 12, label = "Review history", prompt = "Use /ipm summary <module> to review recent kill times.", sound = true },
	},
})
