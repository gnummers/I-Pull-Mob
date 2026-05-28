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

-- Encounter modules are registered from Modules/*.lua after the core API loads.
RegisterAPI()
RegisterEventHandlers()
RegisterUpdateHandler()

SLASH_IPULLMOB1 = "/ipm"
SLASH_IPULLMOB2 = "/ipullmob"
SlashCmdList.IPULLMOB = HandleSlash

Print("Core loaded. Use /ipm modules to list available encounters.")
