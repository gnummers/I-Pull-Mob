local IPM = _G.IPullMob
if not IPM then
	return
end

IPM:RegisterModule("tk-alar", {
	name = "Al'ar",
	description = "Starter timing pass for Flame Quills, Melt Armor, and phase movement.",
	bossIds = { 19514 },
	combatLogTriggers = {
		{ event = "SPELL_CAST_START", spellName = "Flame Quills", prompt = "Flame Quills - move off the platform.", announce = "Flame Quills", sound = true },
		{ event = "SPELL_AURA_APPLIED", spellName = "Melt Armor", prompt = "Melt Armor - tank swap and cooldowns.", announce = "Melt Armor", sound = true },
	},
	timeline = {
		{ after = 10, label = "Pull setup", prompt = "Spread loosely and watch for platform movement.", sound = true },
		{ after = 78, label = "Ember add", prompt = "Ember / add movement - regroup after Quills and pick up the spawn.", sound = true, repeatCount = 3, every = 60, ["until"] = 198 },
		{ after = 150, label = "Platform swap", prompt = "Platform swap - re-center and prepare for the next Quills cycle.", sound = true },
	},
})
