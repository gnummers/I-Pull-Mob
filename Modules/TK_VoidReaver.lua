local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-void-reaver", {
	name = "Void Reaver",
	description = "Starter timing pass for Pounding, Arcane Orb, and spread checks.",
	bossIds = { 19516 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Pounding", prompt = "Pounding - raid-wide damage, stabilize now.", announce = "Pounding", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellName = "Arcane Orb", prompt = "Arcane Orb - move immediately if targeted.", announce = "Arcane Orb", sound = true },
	},
	timeline = {
		{ after = 8, label = "Spread check", prompt = "Spread for Arcane Orb and keep healers assigned.", sound = true },
		{ after = 96, label = "Recovery", prompt = "Recovery window - reset ranged spacing and prepare for the next Pounding.", sound = true },
	},
})
