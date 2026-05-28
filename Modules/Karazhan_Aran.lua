local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-aran", {
	name = "Karazhan - Shade of Aran",
	description = "Starter Aran module: Flame Wreath, Blizzard, and Arcane Explosion reminders.",
	timeline = {
		{
			after = 30,
			label = "Special 1",
			prompt = "Watch for Flame Wreath, Blizzard, or Arcane Explosion",
			announce = "Shade of Aran is casting a special",
			sound = true,
		},
		{
			after = 65,
			label = "Special 2",
			prompt = "Watch for Flame Wreath, Blizzard, or Arcane Explosion",
			announce = "Shade of Aran is casting a special",
			sound = true,
		},
		{
			after = 100,
			label = "Special 3",
			prompt = "Watch for Flame Wreath, Blizzard, or Arcane Explosion",
			announce = "Shade of Aran is casting a special",
			sound = true,
		},
		{
			after = 135,
			label = "Elementals",
			prompt = "Handle water elementals and keep interrupts going",
		},
	},
})
