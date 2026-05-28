local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-curator", {
	name = "Karazhan - The Curator",
	description = "Starter Curator module: flare waves, Evocation, and burn reminders.",
	cycles = {
		flare = { "Rogue", "Mage", "Shaman" },
	},
	timeline = {
		{ after = 10, label = "Astral Flare", prompt = "Burn the current flare wave", repeatCount = 10, every = 10, ["until"] = 100 },
		{
			after = 110,
			label = "Evocation",
			prompt = "Switch to boss and use cooldowns",
			announce = "Curator is evoking",
			sound = true,
		},
	},
})
