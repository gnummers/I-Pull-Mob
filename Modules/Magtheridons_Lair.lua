local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("magtheridons-lair", {
	name = "Magtheridon's Lair - Magtheridon",
	description = "Starter Magtheridon module: cube rotations, Blast Nova, and Quake reminders.",
	cycles = {
		cube = { "Team A", "Team B", "Team C" },
	},
	timeline = {
		{
			after = 45,
			label = "Blast Nova 1",
			prompt = "Click cubes now",
			interruptCycle = "cube",
			announce = "Blast Nova incoming",
			sound = true,
		},
		{
			after = 95,
			label = "Blast Nova 2",
			prompt = "Click cubes now",
			interruptCycle = "cube",
			announce = "Blast Nova incoming",
			sound = true,
		},
		{ after = 120, label = "Quake", prompt = "Stop casting and stabilize" },
		{
			after = 145,
			label = "Blast Nova 3",
			prompt = "Click cubes now",
			interruptCycle = "cube",
			announce = "Blast Nova incoming",
			sound = true,
		},
		{
			after = 195,
			label = "Blast Nova 4",
			prompt = "Click cubes now",
			interruptCycle = "cube",
			announce = "Blast Nova incoming",
			sound = true,
		},
	},
})
