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
