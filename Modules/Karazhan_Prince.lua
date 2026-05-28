local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-prince", {
	name = "Karazhan - Prince Malchezaar",
	description = "Starter Prince module: axes, enfeeble, and infernal reminders.",
	timeline = {
		{
			after = 20,
			label = "Infernal 1",
			prompt = "Watch for infernal landing zones",
			announce = "Infernal incoming",
			sound = true,
		},
		{
			after = 35,
			label = "Enfeeble 1",
			prompt = "Be ready to heal or use a health item",
			announce = "Enfeeble incoming",
			sound = true,
		},
		{ after = 50, label = "Axe Toss", prompt = "Watch clothies and heal through the spike" },
		{
			after = 70,
			label = "Infernal 2",
			prompt = "Watch for infernal landing zones",
			announce = "Infernal incoming",
			sound = true,
		},
		{
			after = 95,
			label = "Enfeeble 2",
			prompt = "Be ready to heal or use a health item",
			announce = "Enfeeble incoming",
			sound = true,
		},
		{ after = 110, label = "Axe Toss", prompt = "Watch clothies and heal through the spike" },
	},
})
