local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-nightbane", {
	name = "Karazhan - Nightbane",
	description = "Starter Nightbane module: air phase and fear handling reminders.",
	timeline = {
		{ after = 45, label = "Air Phase 1", prompt = "Handle Rain of Bones and avoid fire damage" },
		{ after = 75, label = "Ground Phase", prompt = "Stabilize after landing and recover positions" },
		{ after = 120, label = "Air Phase 2", prompt = "Handle Rain of Bones and avoid fire damage" },
		{ after = 150, label = "Ground Phase", prompt = "Stabilize after landing and recover positions" },
		{ after = 195, label = "Air Phase 3", prompt = "Handle Rain of Bones and avoid fire damage" },
	},
})
