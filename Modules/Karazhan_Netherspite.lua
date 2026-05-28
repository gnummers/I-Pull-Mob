local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-netherspite", {
	name = "Karazhan - Netherspite",
	description = "Starter Netherspite module: beam swap and portal cycle reminders.",
	timeline = {
		{ after = 15, label = "Portal Phase", prompt = "Assign beams and establish rotations" },
		{ after = 35, label = "Portal Phase", prompt = "Swap beam users before stacks get high" },
		{
			after = 55,
			label = "Banished Phase",
			prompt = "Boss is vulnerable, burn hard and reset positioning",
			announce = "Banish phase",
			sound = true,
		},
		{ after = 75, label = "Portal Phase", prompt = "Reassign beams and stabilize tanks" },
		{ after = 95, label = "Portal Phase", prompt = "Swap beam users before stacks get high" },
	},
})
