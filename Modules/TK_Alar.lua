local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-alar", {
	name = "Al'ar",
	description = "Starter timing pass for Flame Quills, Melt Armor, and phase movement.",
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread loosely and watch for dive / platform movement.", sound = true },
		{ after = 45, label = "Melt Armor", prompt = "Melt Armor - tank swap and cooldowns.", announce = "Melt Armor", sound = true, repeatCount = 4, every = 60, ["until"] = 225 },
		{ after = 60, label = "Flame Quills", prompt = "Flame Quills - move off the platform.", announce = "Flame Quills", sound = true, repeatCount = 4, every = 75, ["until"] = 285 },
		{ after = 82, label = "Add movement", prompt = "Ember / add movement - regroup after Quills.", sound = true, repeatCount = 4, every = 75, ["until"] = 300 },
	},
})
