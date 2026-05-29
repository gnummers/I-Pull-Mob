local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("kara-opera", {
	name = "The Opera Event",
	description = "A generic timing pass for the Karazhan Opera event rotations.",
	encounterEndIds = { 655 },
	timeline = {
		{ after = 8, label = "Stage set", prompt = "Opera event starting - identify the performance and assign swaps.", sound = true },
		{ after = 20, label = "First mechanic", prompt = "Handle the first Opera mechanic and keep the stage clear.", sound = true },
		{ after = 45, label = "Second mechanic", prompt = "Resolve the next Opera mechanic quickly.", sound = true },
		{ after = 70, label = "Final mechanic", prompt = "Finish the event cleanly and be ready for the next encounter.", sound = true },
	},
})
