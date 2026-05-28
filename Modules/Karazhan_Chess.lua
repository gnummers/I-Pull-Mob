local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-chess", {
	name = "Karazhan - Chess Event",
	description = "Starter Chess Event module: board control reminders.",
	timeline = {
		{ after = 5, label = "Start", prompt = "Open with your assigned piece" },
		{ after = 20, label = "Board pressure", prompt = "Keep pushing the enemy backline" },
		{ after = 40, label = "Board pressure", prompt = "Use piece abilities on cooldown" },
		{ after = 60, label = "Finish", prompt = "Push for king pressure and cleanup" },
	},
})
