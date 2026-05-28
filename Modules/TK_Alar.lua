local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-alar", {
	name = "Al'ar",
	description = "Starter timing pass for Flame Quills, Melt Armor, and phase movement.",
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread loosely and watch for platform movement.", sound = true },
		{ after = 42, label = "Melt Armor", prompt = "Melt Armor - tank swap and cooldowns.", announce = "Melt Armor", sound = true, repeatCount = 4, every = 60, ["until"] = 222 },
		{ after = 60, label = "Flame Quills", prompt = "Flame Quills - move off the platform.", announce = "Flame Quills", sound = true, repeatCount = 4, every = 60, ["until"] = 240 },
		{ after = 78, label = "Ember add", prompt = "Ember / add movement - regroup after Quills and pick up the spawn.", sound = true, repeatCount = 4, every = 60, ["until"] = 258 },
		{ after = 150, label = "Platform swap", prompt = "Platform swap - re-center and prepare for the next Quills cycle.", sound = true },
	},
})
