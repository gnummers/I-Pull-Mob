local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-vashj", {
	name = "Lady Vashj",
	description = "Starter timing pass for shock blasts, phase transition reminders, and core handling.",
	timeline = {
		{ after = 6, label = "Phase 1 setup", prompt = "Spread for Phase 1 and watch the current tank.", sound = true },
		{ after = 18, label = "Shock Blast", prompt = "Shock Blast - tank check and healer attention.", announce = "Shock Blast", sound = true, repeatCount = 7, every = 20, ["until"] = 150 },
		{ after = 65, label = "Phase 2 soon", prompt = "Phase 2 soon. Move to add control positions.", sound = true },
		{ after = 90, label = "Phase 2", prompt = "Phase 2 - assign cores, strider control, and ranged cleanup.", sound = true },
		{ after = 120, label = "Core toss", prompt = "Tainted Core delivery / throw assignment check.", sound = true, repeatCount = 4, every = 20, ["until"] = 185 },
		{ after = 155, label = "Phase 3 soon", prompt = "Phase 3 soon. Reset the raid and prepare for static charge.", sound = true },
		{ after = 180, label = "Phase 3", prompt = "Phase 3 - stack and execute the burn plan.", sound = true },
		{ after = 205, label = "Static Charge", prompt = "Static Charge - move out with the debuffed player.", announce = "Static Charge", sound = true, repeatCount = 4, every = 22, ["until"] = 290 },
	},
})
