local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-solarian", {
	name = "High Astromancer Solarian",
	description = "Starter timing pass for Wrath of the Astromancer, phase swaps, and add control.",
	timeline = {
		{ after = 12, label = "Wrath", prompt = "Wrath of the Astromancer - watch the debuffed player and spread.", announce = "Wrath of the Astromancer", sound = true, repeatCount = 7, every = 18, ["until"] = 138 },
		{ after = 75, label = "Phase shift", prompt = "Phase shift soon. Prepare for adds and priest control.", sound = true },
		{ after = 95, label = "Add phase", prompt = "Add phase - focus the priests and keep interrupts organized.", sound = true },
		{ after = 125, label = "Return phase", prompt = "Return to boss damage and reset spacing.", sound = true },
	},
})
