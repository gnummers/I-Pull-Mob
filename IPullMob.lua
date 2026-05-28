local ADDON_NAME = ...
local ADDON_TITLE = "I Pull Mob"
local ADDON_PREFIX = "I Pull Mob"

local DEFAULT_WIDTH = 340
local DEFAULT_HEIGHT = 180
local MAX_BARS = 8
local DEFAULT_SCALE = 1
local DEFAULT_SOUND_ENABLED = true
local DEFAULT_AUTO_SHOW = true
local DEFAULT_LOCKED = false
local UPDATE_INTERVAL = 0.05

local function Print(message)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff33ff99%s|r: %s", ADDON_PREFIX, message))
	end
end

local function SafeCall(func, ...)
	if type(func) ~= "function" then
		return true
	end

	return pcall(func, ...)
end

local function CopyTable(source)
	local copy = {}
	if type(source) ~= "table" then
		return copy
	end

	for key, value in pairs(source) do
		copy[key] = value
	end

	return copy
end

local function NormalizeCycleMembers(members)
	local normalized = {}
	if type(members) ~= "table" then
		return normalized
	end

	for _, member in ipairs(members) do
		if type(member) == "string" then
			member = member:gsub("^%s+", ""):gsub("%s+$", "")
			if member ~= "" then
				table.insert(normalized, member)
			end
		end
	end

	return normalized
end

local function GetDB()
	if type(IPullMobDB) ~= "table" then
		IPullMobDB = {}
	end

	local db = IPullMobDB

	if type(db.scale) ~= "number" then
		db.scale = DEFAULT_SCALE
	end

	if type(db.soundEnabled) ~= "boolean" then
		db.soundEnabled = DEFAULT_SOUND_ENABLED
	end

	if type(db.autoShow) ~= "boolean" then
		db.autoShow = DEFAULT_AUTO_SHOW
	end

	if type(db.locked) ~= "boolean" then
		db.locked = DEFAULT_LOCKED
	end

	if type(db.cycles) ~= "table" then
		db.cycles = {}
	end

	if type(db.frame) ~= "table" then
		db.frame = { x = 0, y = 0 }
	end

	return db
end

local function FormatSeconds(seconds)
	seconds = math.max(0, seconds or 0)
	if seconds >= 10 then
		return string.format("%d", math.ceil(seconds))
	end

	return string.format("%.1f", seconds)
end

local function PlayAlertSound()
	if not GetDB().soundEnabled then
		return
	end

	if type(PlaySound) == "function" then
		PlaySound(8959, "Master")
	end
end

local function RaidWarn(message)
	if type(RaidNotice_AddMessage) == "function" and RaidWarningFrame and ChatTypeInfo and ChatTypeInfo["RAID_WARNING"] then
		RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"])
	elseif DEFAULT_CHAT_FRAME then
		Print(message)
	end
end

local function CreateStatusBar(parent, index)
	local row = CreateFrame("StatusBar", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	row:SetSize(290, 18)
	row:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
	row:SetStatusBarColor(0.20, 0.65, 1.00, 0.95)

	row.background = row:CreateTexture(nil, "BACKGROUND")
	row.background:SetAllPoints(row)
	row.background:SetColorTexture(0.08, 0.08, 0.10, 0.80)

	row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	row.label:SetPoint("LEFT", row, "LEFT", 6, 0)
	row.label:SetJustifyH("LEFT")
	row.label:SetWidth(200)

	row.timeText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.timeText:SetPoint("RIGHT", row, "RIGHT", -6, 0)
	row.timeText:SetJustifyH("RIGHT")
	row.timeText:SetWidth(48)

	row.promptText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.promptText:SetPoint("BOTTOMLEFT", row, "TOPLEFT", 0, 2)
	row.promptText:SetJustifyH("LEFT")
	row.promptText:SetWidth(290)
	row.promptText:SetText("")

	row:SetPoint("TOPLEFT", parent, "TOPLEFT", 18, -(44 + ((index - 1) * 22)))
	row:Hide()

	return row
end

local function NormalizeModuleId(id)
	if type(id) ~= "string" then
		return nil
	end

	id = id:lower():gsub("^%s+", ""):gsub("%s+$", "")
	if id == "" then
		return nil
	end

	return id
end

local Modules = {}

local Fojiji = CreateFrame("Frame", "IPullMobFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
Fojiji:SetSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
Fojiji:SetPoint("CENTER")
Fojiji:SetMovable(true)
Fojiji:SetClampedToScreen(true)
Fojiji:EnableMouse(true)
Fojiji:RegisterForDrag("LeftButton")
Fojiji:SetScript("OnDragStart", function(self)
	if GetDB().locked then
		return
	end

	self:StartMoving()
end)
Fojiji:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()

	local point, _, relativePoint, x, y = self:GetPoint(1)
	local db = GetDB()
	db.frame.point = point or "CENTER"
	db.frame.relativePoint = relativePoint or "CENTER"
	db.frame.x = x or 0
	db.frame.y = y or 0
end)
Fojiji:SetBackdrop({
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	tile = true,
	tileSize = 12,
	edgeSize = 12,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
Fojiji:SetBackdropColor(0.05, 0.05, 0.07, 0.92)
Fojiji:SetBackdropBorderColor(0.45, 0.45, 0.55, 1)
Fojiji:Hide()

Fojiji.title = Fojiji:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
Fojiji.title:SetPoint("TOPLEFT", Fojiji, "TOPLEFT", 14, -12)
Fojiji.title:SetText(ADDON_TITLE)

Fojiji.subtitle = Fojiji:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
Fojiji.subtitle:SetPoint("TOPLEFT", Fojiji.title, "BOTTOMLEFT", 0, -4)
Fojiji.subtitle:SetText("Timers, prompts, and interrupt-cycle support")

Fojiji.prompt = Fojiji:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
Fojiji.prompt:SetPoint("TOPLEFT", Fojiji.subtitle, "BOTTOMLEFT", 0, -12)
Fojiji.prompt:SetWidth(306)
Fojiji.prompt:SetJustifyH("LEFT")
Fojiji.prompt:SetText("")

local barParent = CreateFrame("Frame", nil, Fojiji)
barParent:SetPoint("TOPLEFT", Fojiji, "TOPLEFT", 0, 0)
barParent:SetPoint("BOTTOMRIGHT", Fojiji, "BOTTOMRIGHT", 0, 0)

local bars = {}
for i = 1, MAX_BARS do
	bars[i] = CreateStatusBar(barParent, i)
end

local state = {
	encounterId = nil,
	module = nil,
	activeEvents = {},
	nextEventId = 0,
	timerTicks = 0,
}

local function SetPrompt(text)
	Fojiji.prompt:SetText(text or "")
end

local function ClearBars()
	for _, bar in ipairs(bars) do
		bar:Hide()
		bar.label:SetText("")
		bar.timeText:SetText("")
		bar.promptText:SetText("")
		bar:SetValue(0)
	end
end

local function SortEvents()
	table.sort(state.activeEvents, function(left, right)
		if left.fireAt == right.fireAt then
			return left.id < right.id
		end

		return left.fireAt < right.fireAt
	end)
end

local function GetCycleState(name)
	local db = GetDB()
	db.cycles[name] = db.cycles[name] or { members = {}, index = 0 }
	db.cycles[name].members = NormalizeCycleMembers(db.cycles[name].members)
	if type(db.cycles[name].index) ~= "number" then
		db.cycles[name].index = 0
	end

	return db.cycles[name]
end

local function SeedCycle(name, members)
	local db = GetDB()
	local cycle = GetCycleState(name)
	if #cycle.members == 0 and type(members) == "table" then
		cycle.members = NormalizeCycleMembers(members)
		cycle.index = 0
	end
	db.cycles[name] = cycle
	return cycle
end

local function GetNextInterruptName(cycleName)
	local cycle = GetCycleState(cycleName)
	if #cycle.members == 0 then
		return nil
	end

	local nextIndex = cycle.index + 1
	if nextIndex > #cycle.members then
		nextIndex = 1
	end

	return cycle.members[nextIndex], nextIndex
end

local function AdvanceInterruptCycle(cycleName)
	local cycle = GetCycleState(cycleName)
	if #cycle.members == 0 then
		return nil
	end

	cycle.index = cycle.index + 1
	if cycle.index > #cycle.members then
		cycle.index = 1
	end

	return cycle.members[cycle.index], cycle.index
end

local function BuildPrompt(event)
	local prompt = event.prompt
	if prompt and prompt ~= "" then
		if event.interruptCycle then
			local nextName = GetNextInterruptName(event.interruptCycle)
			if nextName then
				return string.format("%s - %s", prompt, nextName)
			end
		end

		return prompt
	end

	if event.interruptCycle then
		local nextName = GetNextInterruptName(event.interruptCycle)
		if nextName then
			return string.format("Interrupt: %s", nextName)
		end
	end

	return nil
end

local function FireEvent(event)
	if event.fired then
		return
	end

	event.fired = true

	local prompt = BuildPrompt(event)
	if prompt then
		SetPrompt(prompt)
		RaidWarn(prompt)
	end

	if event.announce then
		RaidWarn(event.announce)
	end

	if event.sound ~= false then
		PlayAlertSound()
	end

	if event.interruptCycle then
		AdvanceInterruptCycle(event.interruptCycle)
	end

	if state.module and type(state.module.onEvent) == "function" then
		SafeCall(state.module.onEvent, state.module, event, state)
	end
end

local function ClearEncounter(showComplete)
	state.encounterId = nil
	state.module = nil
	state.activeEvents = {}
	state.nextEventId = 0
	SetPrompt("")
	ClearBars()

	if not showComplete then
		Fojiji:Hide()
	end
end

local function RegisterModule(id, module)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId or type(module) ~= "table" then
		return false
	end

	module.id = normalizedId
	module.name = module.name or normalizedId
	module.description = module.description or ""
	module.timeline = type(module.timeline) == "table" and module.timeline or {}
	Modules[normalizedId] = module
	return true
end

local function AddEvent(event)
	state.nextEventId = state.nextEventId + 1
	event.id = state.nextEventId
	event.fired = false
	table.insert(state.activeEvents, event)
	SortEvents()
end

local function StartEncounter(encounterId)
	local normalizedId = NormalizeModuleId(encounterId)
	local module = normalizedId and Modules[normalizedId] or nil
	if not module then
		Print(string.format("Unknown module '%s'. Use /ipm modules to list available modules.", tostring(encounterId)))
		return false
	end

	ClearEncounter(false)
	state.encounterId = normalizedId
	state.module = module

	if type(module.cycles) == "table" then
		for cycleName, members in pairs(module.cycles) do
			SeedCycle(cycleName, members)
		end
	end

	if type(module.onStart) == "function" then
		SafeCall(module.onStart, module, state)
	end

	local now = GetTime()
	for _, step in ipairs(module.timeline or {}) do
		local repeats = math.max(1, tonumber(step.repeatCount) or 1)
		local interval = tonumber(step.every) or 0
		local firstAfter = tonumber(step.after) or 0

		for i = 0, repeats - 1 do
			local fireAfter = firstAfter + (i * interval)
			if step["until"] and fireAfter > step["until"] then
				break
			end

			AddEvent({
				fireAt = now + fireAfter,
				label = step.label or step.prompt or "Timer",
				prompt = step.prompt,
				announce = step.announce,
				interruptCycle = step.interruptCycle,
				sound = step.sound,
			})
		end
	end

	if type(module.onSchedule) == "function" then
		SafeCall(module.onSchedule, module, state)
	end

	Fojiji:Show()
	Print(string.format("Started module: %s", module.name))
	return true
end

local function UpdateBars()
	local now = GetTime()
	local visibleCount = 0

	for _, event in ipairs(state.activeEvents) do
		if not event.fired then
			local remaining = event.fireAt - now
			if remaining <= 0 then
				FireEvent(event)
			else
				visibleCount = visibleCount + 1
				local bar = bars[visibleCount]
				if bar then
					bar:Show()
					bar:SetMinMaxValues(0, math.max(1, remaining))
					bar:SetValue(remaining)
					bar.label:SetText(event.label or "Timer")
					bar.timeText:SetText(FormatSeconds(remaining))
					bar.promptText:SetText(BuildPrompt(event) or "")
				end
			end
		end
	end

	for i = visibleCount + 1, MAX_BARS do
		bars[i]:Hide()
		bars[i].label:SetText("")
		bars[i].timeText:SetText("")
		bars[i].promptText:SetText("")
	end

	if state.encounterId and visibleCount == 0 then
		SetPrompt("Encounter complete")
	end
end

local function ListModules()
	local names = {}
	for id in pairs(Modules) do
		table.insert(names, id)
	end

	table.sort(names)
	if #names == 0 then
		Print("No modules registered.")
		return
	end

	for _, id in ipairs(names) do
		local module = Modules[id]
		Print(string.format("%s - %s", id, module.name or id))
	end
end

local function ListCycles()
	local db = GetDB()
	local names = {}
	for name in pairs(db.cycles) do
		table.insert(names, name)
	end

	table.sort(names)
	if #names == 0 then
		Print("No interrupt cycles configured.")
		return
	end

	for _, name in ipairs(names) do
		local cycle = GetCycleState(name)
		Print(string.format("%s: %s", name, #cycle.members > 0 and table.concat(cycle.members, ", ") or "(empty)"))
	end
end

local function ShowHelp()
	Print("Commands: /ipm demo, /ipm start <module>, /ipm stop, /ipm modules, /ipm cycles, /ipm cycle <name> add <player>, /ipm cycle <name> list, /ipm cycle <name> next, /ipm sound on|off, /ipm lock, /ipm unlock")
end

local function HandleSlash(msg)
	msg = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")
	local lower = msg:lower()

	if lower == "" or lower == "help" then
		ShowHelp()
		return
	end

	if lower == "demo" then
		StartEncounter("demo")
		return
	end

	if lower == "modules" then
		ListModules()
		return
	end

	if lower == "cycles" then
		ListCycles()
		return
	end

	if lower == "stop" then
		ClearEncounter(false)
		Print("Stopped current module.")
		return
	end

	if lower == "lock" then
		GetDB().locked = true
		Print("Window locked.")
		return
	end

	if lower == "unlock" then
		GetDB().locked = false
		Print("Window unlocked.")
		return
	end

	if lower == "sound on" then
		GetDB().soundEnabled = true
		Print("Sounds enabled.")
		return
	end

	if lower == "sound off" then
		GetDB().soundEnabled = false
		Print("Sounds disabled.")
		return
	end

	local startId = lower:match("^start%s+(.+)$")
	if startId then
		StartEncounter(startId)
		return
	end

	local cycleName, action, player = lower:match("^cycle%s+(%S+)%s+(%S+)%s*(.-)$")
	if cycleName then
		local dbCycle = GetCycleState(cycleName)
		action = action or ""

		if action == "add" then
			player = (msg:match("^cycle%s+%S+%s+%S+%s*(.-)$") or ""):gsub("^%s+", ""):gsub("%s+$", "")
			if player == "" then
				Print("Usage: /ipm cycle <name> add <player>")
				return
			end

			table.insert(dbCycle.members, player)
			Print(string.format("Added %s to cycle %s.", player, cycleName))
			return
		end

		if action == "list" then
			Print(string.format("%s: %s", cycleName, #dbCycle.members > 0 and table.concat(dbCycle.members, ", ") or "(empty)"))
			return
		end

		if action == "next" then
			local nextName = AdvanceInterruptCycle(cycleName)
			if nextName then
				Print(string.format("Next interrupt for %s: %s", cycleName, nextName))
			else
				Print(string.format("Cycle %s has no members.", cycleName))
			end
			return
		end

		if action == "clear" then
			dbCycle.members = {}
			dbCycle.index = 0
			Print(string.format("Cleared cycle %s.", cycleName))
			return
		end
	end

	Print("Unknown command. Use /ipm help.")
end

local function ApplySavedFramePosition()
	local db = GetDB()
	local point = db.frame.point or "CENTER"
	local relativePoint = db.frame.relativePoint or "CENTER"
	local x = db.frame.x or 0
	local y = db.frame.y or 0

	Fojiji:ClearAllPoints()
	Fojiji:SetPoint(point, UIParent, relativePoint, x, y)
end

local function UpdateScale()
	Fojiji:SetScale(GetDB().scale or DEFAULT_SCALE)
end

local function RegisterEventHandlers()
	Fojiji:RegisterEvent("PLAYER_LOGIN")
	Fojiji:RegisterEvent("PLAYER_REGEN_DISABLED")
	Fojiji:RegisterEvent("PLAYER_REGEN_ENABLED")
	Fojiji:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_LOGIN" then
			GetDB()
			UpdateScale()
			ApplySavedFramePosition()
			return
		end

		if event == "PLAYER_REGEN_DISABLED" and GetDB().autoShow and state.encounterId then
			Fojiji:Show()
			return
		end

		if event == "PLAYER_REGEN_ENABLED" and not state.encounterId then
			Fojiji:Hide()
			return
		end
	end)
end

local function RegisterUpdateHandler()
	Fojiji:SetScript("OnUpdate", function(self, elapsed)
		state.timerTicks = state.timerTicks + elapsed
		if state.timerTicks < UPDATE_INTERVAL then
			return
		end

		state.timerTicks = 0
		UpdateBars()

		if GetDB().autoShow and state.encounterId and not self:IsShown() then
			self:Show()
		end
	end)
end

local function RegisterAPI()
	_G.IPullMob = {
		RegisterModule = RegisterModule,
		StartEncounter = StartEncounter,
		ClearEncounter = ClearEncounter,
		RegisterInterruptCycle = function(_, name, members)
			local normalized = NormalizeModuleId(name)
			if not normalized then
				return
			end

			local cycle = GetCycleState(normalized)
			cycle.members = NormalizeCycleMembers(members)
			cycle.index = 0
		end,
		SetInterruptCycle = function(_, name, members)
			local normalized = NormalizeModuleId(name)
			if not normalized then
				return
			end

			local cycle = GetCycleState(normalized)
			cycle.members = NormalizeCycleMembers(members)
			cycle.index = 0
		end,
		GetNextInterrupt = GetNextInterruptName,
		AdvanceInterrupt = AdvanceInterruptCycle,
		GetModule = function(_, id)
			return Modules[NormalizeModuleId(id) or ""]
		end,
		GetModules = function()
			return Modules
		end,
		GetEncounterData = function(_, id)
			return Modules[NormalizeModuleId(id) or ""]
		end,
	}
end

local function RegisterDefaultModules()
	RegisterModule("demo", {
		name = "Example Boss Module",
		description = "A starter boss module showing a pull timer, a kick cycle, and movement prompts.",
		cycles = {
			main = { "Rogue", "Shaman", "Mage" },
		},
		timeline = {
			{
				after = 5,
				label = "Pull timer",
				prompt = "Get ready to pull",
				sound = true,
			},
			{
				after = 15,
				label = "Cast 1",
				prompt = "Kick the cast",
				interruptCycle = "main",
			},
			{
				after = 27,
				label = "Move out",
				prompt = "Spread and move out",
				sound = true,
			},
			{
				after = 40,
				label = "Cast 2",
				prompt = "Kick the next cast",
				interruptCycle = "main",
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-curator", {
		name = "Karazhan - The Curator",
		description = "Starter Curator module: flare waves, Evocation, and burn reminders.",
		cycles = {
			flare = { "Rogue", "Mage", "Shaman" },
		},
		timeline = {
			{ after = 10, label = "Astral Flare 1", prompt = "Burn the first flare" },
			{ after = 20, label = "Astral Flare 2", prompt = "Burn the second flare" },
			{ after = 30, label = "Astral Flare 3", prompt = "Burn the third flare" },
			{ after = 40, label = "Astral Flare 4", prompt = "Burn the fourth flare" },
			{ after = 50, label = "Astral Flare 5", prompt = "Burn the fifth flare" },
			{ after = 60, label = "Astral Flare 6", prompt = "Burn the sixth flare" },
			{ after = 70, label = "Astral Flare 7", prompt = "Burn the seventh flare" },
			{ after = 80, label = "Astral Flare 8", prompt = "Burn the eighth flare" },
			{ after = 90, label = "Astral Flare 9", prompt = "Burn the ninth flare" },
			{
				after = 100,
				label = "Astral Flare 10",
				prompt = "Burn the final flare and prepare for Evocation",
			},
			{
				after = 110,
				label = "Evocation",
				prompt = "Switch to boss and use cooldowns",
				announce = "Curator is evoking",
				sound = true,
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("gruuls-lair", {
		name = "Gruul's Lair - Gruul the Dragonkiller",
		description = "Starter Gruul module: Growth, Cave In, Hurtful Strike, and Shatter reminders.",
		timeline = {
			{ after = 30, label = "Growth 1", prompt = "Watch your stack count and spread" },
			{ after = 50, label = "Cave In", prompt = "Move out of the void zone" },
			{
				after = 60,
				label = "Shatter",
				prompt = "Spread immediately for Shatter",
				announce = "Shatter incoming",
				sound = true,
			},
			{ after = 90, label = "Growth 2", prompt = "Watch for higher damage on tanks" },
			{ after = 100, label = "Cave In", prompt = "Move out of the void zone" },
			{
				after = 120,
				label = "Shatter",
				prompt = "Spread immediately for Shatter",
				announce = "Shatter incoming",
				sound = true,
			},
			{ after = 150, label = "Growth 3", prompt = "Prepare for stronger hits" },
			{ after = 160, label = "Cave In", prompt = "Move out of the void zone" },
			{
				after = 180,
				label = "Shatter",
				prompt = "Spread immediately for Shatter",
				announce = "Shatter incoming",
				sound = true,
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("magtheridons-lair", {
		name = "Magtheridon's Lair - Magtheridon",
		description = "Starter Magtheridon module: cube rotations, Blast Nova, and Quake reminders.",
		cycles = {
			cube = { "Team A", "Team B", "Team C" },
		},
		timeline = {
			{
				after = 45,
				label = "Blast Nova 1",
				prompt = "Click cubes now",
				interruptCycle = "cube",
				announce = "Blast Nova incoming",
				sound = true,
			},
			{
				after = 95,
				label = "Blast Nova 2",
				prompt = "Click cubes now",
				interruptCycle = "cube",
				announce = "Blast Nova incoming",
				sound = true,
			},
			{ after = 120, label = "Quake", prompt = "Stop casting and stabilize" },
			{
				after = 145,
				label = "Blast Nova 3",
				prompt = "Click cubes now",
				interruptCycle = "cube",
				announce = "Blast Nova incoming",
				sound = true,
			},
			{
				after = 195,
				label = "Blast Nova 4",
				prompt = "Click cubes now",
				interruptCycle = "cube",
				announce = "Blast Nova incoming",
				sound = true,
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-attumen", {
		name = "Karazhan - Attumen the Huntsman",
		description = "Starter Attumen module: phase swap and charge reminders.",
		timeline = {
			{ after = 15, label = "Shadow Cleave", prompt = "Stay out of cleave range on the tank" },
			{
				after = 60,
				label = "Mount Phase",
				prompt = "Swap to Midnight and get ready to reposition",
				announce = "Attumen is mounting",
				sound = true,
			},
			{
				after = 90,
				label = "Berserker Charge",
				prompt = "Move for charge and keep spread",
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-moroes", {
		name = "Karazhan - Moroes",
		description = "Starter Moroes module: Garrote cadence, add control, and execute reminders.",
		cycles = {
			garrote = { "Priest", "Paladin", "Shaman" },
		},
		timeline = {
			{
				after = 10,
				label = "Garrote 1",
				prompt = "Dispel the garrote target",
				interruptCycle = "garrote",
			},
			{ after = 25, label = "Moroes adds", prompt = "Control the add pack" },
			{
				after = 40,
				label = "Garrote 2",
				prompt = "Dispel the next garrote target",
				interruptCycle = "garrote",
			},
			{ after = 70, label = "Moroes adds", prompt = "Re-control adds and keep tanks stable" },
			{
				after = 90,
				label = "Garrote 3",
				prompt = "Dispel the next garrote target",
				interruptCycle = "garrote",
			},
			{
				after = 120,
				label = "Execute",
				prompt = "Prepare for Moroes enrage pressure at low health",
				announce = "Moroes is close to execute range",
				sound = true,
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-maiden", {
		name = "Karazhan - Maiden of Virtue",
		description = "Starter Maiden module: Holy Fire and Repentance reminders.",
		timeline = {
			{ after = 13, label = "Holy Fire", prompt = "Keep distance from the debuffed target" },
			{
				after = 30,
				label = "Repentance",
				prompt = "Move to break repentance or prepare self-heals",
				announce = "Repentance incoming",
				sound = true,
			},
			{ after = 43, label = "Holy Fire", prompt = "Keep distance from the debuffed target" },
			{
				after = 60,
				label = "Repentance",
				prompt = "Move to break repentance or prepare self-heals",
				announce = "Repentance incoming",
				sound = true,
			},
			{ after = 73, label = "Holy Fire", prompt = "Keep distance from the debuffed target" },
			{
				after = 90,
				label = "Repentance",
				prompt = "Move to break repentance or prepare self-heals",
				announce = "Repentance incoming",
				sound = true,
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-aran", {
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
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-chess", {
		name = "Karazhan - Chess Event",
		description = "Starter Chess Event module: board control reminders.",
		timeline = {
			{ after = 5, label = "Start", prompt = "Open with your assigned piece" },
			{ after = 20, label = "Board pressure", prompt = "Keep pushing the enemy backline" },
			{ after = 40, label = "Board pressure", prompt = "Use piece abilities on cooldown" },
			{ after = 60, label = "Finish", prompt = "Push for king pressure and cleanup" },
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-netherspite", {
		name = "Karazhan - Netherspite",
		description = "Starter Netherspite module: beam swap and portal cycle reminders.",
		timeline = {
			{ after = 15, label = "Portal Phase", prompt = "Assign beams and establish rotations" },
			{ after = 35, label = "Portal Phase", prompt = "Swap beam users before stacks get high" },
			{
				after = 55,
				label = "Banished Phase",
				prompt = "Boss is vulnerable, burn hard and reset positioning",
				announce = "Banish phase",
				sound = true,
			},
			{ after = 75, label = "Portal Phase", prompt = "Reassign beams and stabilize tanks" },
			{ after = 95, label = "Portal Phase", prompt = "Swap beam users before stacks get high" },
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-nightbane", {
		name = "Karazhan - Nightbane",
		description = "Starter Nightbane module: air phase and fear handling reminders.",
		timeline = {
			{ after = 45, label = "Air Phase 1", prompt = "Handle Rain of Bones and avoid fire damage" },
			{ after = 75, label = "Ground Phase", prompt = "Stabilize after landing and recover positions" },
			{ after = 120, label = "Air Phase 2", prompt = "Handle Rain of Bones and avoid fire damage" },
			{ after = 150, label = "Ground Phase", prompt = "Stabilize after landing and recover positions" },
			{ after = 195, label = "Air Phase 3", prompt = "Handle Rain of Bones and avoid fire damage" },
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("kara-prince", {
		name = "Karazhan - Prince Malchezaar",
		description = "Starter Prince module: axes, enfeeble, and infernal reminders.",
		timeline = {
			{
				after = 20,
				label = "Infernal 1",
				prompt = "Watch for infernal landing zones",
				announce = "Infernal incoming",
				sound = true,
			},
			{
				after = 35,
				label = "Enfeeble 1",
				prompt = "Be ready to heal or use a health item",
				announce = "Enfeeble incoming",
				sound = true,
			},
			{
				after = 50,
				label = "Axe Toss",
				prompt = "Watch clothies and heal through the spike",
			},
			{
				after = 70,
				label = "Infernal 2",
				prompt = "Watch for infernal landing zones",
				announce = "Infernal incoming",
				sound = true,
			},
			{
				after = 95,
				label = "Enfeeble 2",
				prompt = "Be ready to heal or use a health item",
				announce = "Enfeeble incoming",
				sound = true,
			},
			{
				after = 110,
				label = "Axe Toss",
				prompt = "Watch clothies and heal through the spike",
			},
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("maulgar", {
		name = "Gruul's Lair - High King Maulgar",
		description = "Starter Maulgar module: whirlwind, fear, and add control reminders.",
		timeline = {
			{ after = 10, label = "Add Control", prompt = "Keep the council controlled and marked" },
			{ after = 25, label = "Whirlwind", prompt = "Move melee away from the king" },
			{ after = 40, label = "Fear", prompt = "Prepare to recover from fear" },
			{ after = 55, label = "Whirlwind", prompt = "Move melee away from the king" },
			{ after = 70, label = "Fear", prompt = "Prepare to recover from fear" },
		},
		onStart = function(module)
			Print(string.format("Loaded module: %s", module.name))
		end,
	})

	RegisterModule("test-rotations", {
		name = "Interrupt Rotation Test",
		description = "Utility module for testing cycle order and prompt behavior without an actual boss.",
		cycles = {
			main = { "Player One", "Player Two", "Player Three" },
		},
		timeline = {
			{ after = 8, label = "Kick 1", prompt = "Interrupt the first cast", interruptCycle = "main" },
			{ after = 16, label = "Kick 2", prompt = "Interrupt the second cast", interruptCycle = "main" },
			{ after = 24, label = "Kick 3", prompt = "Interrupt the third cast", interruptCycle = "main" },
		},
	})
end

RegisterDefaultModules()
RegisterAPI()
RegisterEventHandlers()
RegisterUpdateHandler()

SLASH_IPULLMOB1 = "/ipm"
SLASH_IPULLMOB2 = "/ipullmob"
SlashCmdList.IPULLMOB = HandleSlash

Print("Loaded. Use /ipm demo to test the example boss module.")
