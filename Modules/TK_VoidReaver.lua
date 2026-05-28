local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-void-reaver", {
	name = "Void Reaver",
	description = "Starter timing pass for Pounding, Arcane Orb, and spread checks.",
	timeline = {
		{ after = 8, label = "Spread check", prompt = "Spread for Arcane Orb and keep healers assigned.", sound = true },
		{ after = 12, label = "Pounding", prompt = "Pounding - raid-wide damage, stabilize now.", announce = "Pounding", sound = true, repeatCount = 9, every = 12, ["until"] = 120 },
		{ after = 18, label = "Orb check", prompt = "Arcane Orb - move immediately if targeted.", announce = "Arcane Orb", sound = true, repeatCount = 6, every = 18, ["until"] = 126 },
		{ after = 96, label = "Recovery", prompt = "Recovery window - reset ranged spacing and prepare for the next Pounding.", sound = true },
	},
})
