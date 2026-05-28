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
