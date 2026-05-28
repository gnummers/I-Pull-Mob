local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("ssc-vashj", {
	name = "Lady Vashj",
	description = "Starter timing pass for shock blasts, phase transition reminders, and core handling.",
	timeline = {
		{ after = 6, label = "Phase 1 setup", prompt = "Spread for Phase 1 and keep Grounding / tank coverage ready.", sound = true },
		{ after = 18, label = "Shock Blast", prompt = "Shock Blast - tank check and healer attention.", announce = "Shock Blast", sound = true, repeatCount = 7, every = 20, ["until"] = 150 },
		{ after = 70, label = "Phase 2 soon", prompt = "Phase 2 soon. Move to add control positions and assign cores.", sound = true },
		{ after = 92, label = "Phase 2", prompt = "Phase 2 - assign strider control, elite add kills, and core runners.", announce = "Phase 2", sound = true },
		{ after = 110, label = "Core toss", prompt = "Tainted Core delivery check - keep a runner ready.", sound = true, repeatCount = 5, every = 18, ["until"] = 190 },
		{ after = 160, label = "Phase 3 soon", prompt = "Phase 3 soon. Reset the raid and prepare for Static Charge.", sound = true },
		{ after = 182, label = "Phase 3", prompt = "Phase 3 - stack and execute the burn plan.", announce = "Phase 3", sound = true },
		{ after = 205, label = "Static Charge", prompt = "Static Charge - move out with the debuffed player.", announce = "Static Charge", sound = true, repeatCount = 4, every = 22, ["until"] = 290 },
	},
})
