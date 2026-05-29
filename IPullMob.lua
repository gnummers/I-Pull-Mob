local ADDON_NAME = ...
local ADDON_TITLE = "I Pull Mob"
local ADDON_PREFIX = "I Pull Mob"

local DEFAULT_WIDTH = 340
local DEFAULT_HEIGHT = 180
local MAX_BARS = 8
local DEFAULT_SCALE = 1
local DEFAULT_ALERT_VOLUME = 1
local DEFAULT_SOUND_ENABLED = true
local DEFAULT_AUTO_SHOW = true
local DEFAULT_LOCKED = false
local DEFAULT_KILL_HISTORY_LIMIT = 20
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

	if type(db.alertVolume) ~= "number" then
		db.alertVolume = DEFAULT_ALERT_VOLUME
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

	if type(db.moduleEnabled) ~= "table" then
		db.moduleEnabled = {}
	end

	if type(db.killTimes) ~= "table" then
		db.killTimes = {}
	end

	if type(db.reportModuleId) ~= "string" then
		db.reportModuleId = nil
	end

	if type(db.markerRules) ~= "table" then
		db.markerRules = {}
	end

	if type(db.rangeValue) ~= "number" then
		db.rangeValue = nil
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

	local db = GetDB()
	local previousVolume
	local volumeCVar = "Sound_MasterVolume"

	if type(GetCVar) == "function" and type(SetCVar) == "function" then
		previousVolume = tonumber(GetCVar(volumeCVar))
		if not previousVolume then
			volumeCVar = "Sound_SFXVolume"
			previousVolume = tonumber(GetCVar(volumeCVar))
		end

		if previousVolume then
			SetCVar(volumeCVar, math.max(0, math.min(1, db.alertVolume or DEFAULT_ALERT_VOLUME)))
		end
	end

	if type(PlaySound) == "function" then
		local alertSound = 8959
		if type(_G.IPullMobSupport) == "table" then
			if type(_G.IPullMobSupport.ResolveMedia) == "function" then
				alertSound = _G.IPullMobSupport:ResolveMedia("sounds", "alert") or alertSound
			elseif type(_G.IPullMobSupport.GetMedia) == "function" then
				alertSound = _G.IPullMobSupport:GetMedia("sounds", "alert") or alertSound
			end
		end
		PlaySound(alertSound, "Master")
	end

	if previousVolume and type(SetCVar) == "function" then
		SetCVar(volumeCVar, previousVolume)
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

local function NormalizeMarkerIcon(icon)
	local value = tonumber(icon)
	if not value then
		return nil
	end

	value = math.floor(value)
	if value < 1 or value > 8 then
		return nil
	end

	return value
end

local function GetMobIdFromGUID(guid)
	if type(guid) ~= "string" or guid == "" then
		return nil
	end

	if type(strsplit) ~= "function" then
		return nil
	end

	local mobId = select(6, strsplit("-", guid))
	return tonumber(mobId)
end

local function FindRaidUnitByName(name)
	if type(name) ~= "string" or name == "" then
		return nil
	end

	if UnitName("player") == name then
		return "player"
	end

	if IsInRaid() then
		for i = 1, 40 do
			local unit = "raid" .. i
			if UnitExists(unit) and UnitName(unit) == name then
				return unit
			end
		end
	end

	if IsInGroup() then
		for i = 1, 4 do
			local unit = "party" .. i
			if UnitExists(unit) and UnitName(unit) == name then
				return unit
			end
		end
	end

	return nil
end

local function CanAssignRaidMarker()
	return type(SetRaidTarget) == "function" and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end

local function ApplyRaidMarker(name, icon, overwrite)
	local unit = FindRaidUnitByName(name)
	icon = NormalizeMarkerIcon(icon)
	if not unit or not icon then
		return false
	end

	if not CanAssignRaidMarker() then
		return false
	end

	if not overwrite and GetRaidTargetIndex(unit) then
		return false
	end

	SetRaidTarget(unit, icon)
	return true
end

local function IsModuleEnabled(id)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId then
		return false
	end

	local db = GetDB()
	if db.moduleEnabled[normalizedId] == nil then
		return true
	end

	return db.moduleEnabled[normalizedId] ~= false
end

local function SetModuleEnabled(id, enabled)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId then
		return false
	end

	local db = GetDB()
	db.moduleEnabled[normalizedId] = enabled and true or false

	if state.encounterId == normalizedId and not enabled then
		ClearEncounter(false)
		Print(string.format("Stopped disabled module: %s", normalizedId))
	end

	if optionsFrame and optionsFrame:IsShown() and type(RefreshOptionsWindow) == "function" then
		RefreshOptionsWindow()
	end

	return true
end

local Modules = {}
local optionsFrame
local optionsModuleButtons = {}
local OpenOptionsWindow
local RefreshOptionsWindow

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
	combatLogState = {},
	markerState = {},
	nextEventId = 0,
	timerTicks = 0,
	encounterStart = nil,
	encounterFinished = nil,
	encounterFinishReason = nil,
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

local function ValueMatches(candidate, expected)
	if expected == nil then
		return true
	end

	if type(expected) == "table" then
		if #expected > 0 then
			for _, item in ipairs(expected) do
				if item == candidate then
					return true
				end
			end
			return false
		end

		return expected[candidate] == true
	end

	return candidate == expected
end

local function MatchesCombatLogTrigger(trigger, info)
	if type(trigger) ~= "table" or type(info) ~= "table" then
		return false
	end

	if type(trigger.match) == "function" then
		local ok, matched = pcall(trigger.match, trigger, info, state)
		if ok and matched then
			return true
		end
		return false
	end

	local events = trigger.events or trigger.event
	if not ValueMatches(info.event, events) then
		return false
	end

	if not ValueMatches(info.spellId, trigger.spellIds or trigger.spellId) then
		return false
	end

	if not ValueMatches(info.spellName, trigger.spellNames or trigger.spellName) then
		return false
	end

	if not ValueMatches(info.sourceName, trigger.sourceNames or trigger.sourceName) then
		return false
	end

	if not ValueMatches(info.destName, trigger.destNames or trigger.destName) then
		return false
	end

	return true
end

local function FireCombatLogTrigger(trigger, info, triggerKey)
	local now = info.timestamp or GetTime()
	local triggerState = state.combatLogState[triggerKey] or { lastFire = 0, fired = false }

	if trigger.once and triggerState.fired then
		return
	end

	local cooldown = tonumber(trigger.cooldown) or 0
	if cooldown > 0 and triggerState.lastFire > 0 and (now - triggerState.lastFire) < cooldown then
		return
	end

	triggerState.lastFire = now
	if trigger.once then
		triggerState.fired = true
	end
	state.combatLogState[triggerKey] = triggerState

	local prompt = trigger.prompt
	if prompt and prompt ~= "" then
		if trigger.interruptCycle then
			local nextName = GetNextInterruptName(trigger.interruptCycle)
			if nextName then
				prompt = string.format("%s - %s", prompt, nextName)
			end
		end

		SetPrompt(prompt)
		RaidWarn(prompt)
	elseif trigger.interruptCycle then
		local nextName = GetNextInterruptName(trigger.interruptCycle)
		if nextName then
			SetPrompt(string.format("Interrupt: %s", nextName))
			RaidWarn(string.format("Interrupt: %s", nextName))
		end
	end

	if trigger.announce then
		RaidWarn(trigger.announce)
	end

	if trigger.sound ~= false then
		PlayAlertSound()
	end

	if trigger.interruptCycle then
		AdvanceInterruptCycle(trigger.interruptCycle)
	end
end

local function FireAutoMarker(rule, info, ruleKey)
	if type(rule) ~= "table" or type(info) ~= "table" then
		return false
	end

	local targetName = info.destName
	if rule.target == "source" then
		targetName = info.sourceName
	end

	if rule.targetName and type(rule.targetName) == "string" then
		targetName = rule.targetName
	end

	if type(targetName) ~= "string" or targetName == "" then
		return false
	end

	local markerState = state.markerState[ruleKey] or { index = 0 }
	state.markerState[ruleKey] = markerState

	if rule.clearOnRemove and info.event == "SPELL_AURA_REMOVED" then
		local clearName = markerState.lastTarget or targetName
		local unit = FindRaidUnitByName(clearName)
		if unit and CanAssignRaidMarker() then
			SetRaidTarget(unit, 0)
			markerState.lastTarget = nil
			return true
		end
	end

	local icon = NormalizeMarkerIcon(rule.icon)

	local sequence = rule.sequence
	if type(sequence) == "table" and #sequence > 0 then
		markerState.index = markerState.index + 1
		local seqIndex = markerState.index
		if seqIndex > #sequence then
			seqIndex = #sequence
		end
		icon = NormalizeMarkerIcon(sequence[seqIndex]) or icon
	elseif rule.nextIcon then
		markerState.index = markerState.index + 1
		icon = NormalizeMarkerIcon(rule.nextIcon + markerState.index - 1) or icon
	end

	if not icon then
		return false
	end

	if rule.clearOnRemove then
		if info.event == "SPELL_AURA_REMOVED" then
			local unit = FindRaidUnitByName(targetName)
			if unit and CanAssignRaidMarker() then
				SetRaidTarget(unit, 0)
				return true
			end
		end
	end

	if rule.overwrite == false then
		local unit = FindRaidUnitByName(targetName)
		if unit and GetRaidTargetIndex(unit) then
			return false
		end
	end

	if ApplyRaidMarker(targetName, icon, rule.overwrite ~= false) then
		markerState.lastTarget = targetName
		if rule.announce ~= false then
			local message = rule.announce or string.format("Mark %s on %s", icon, targetName)
			RaidWarn(message)
		end
		return true
	end

	return false
end

local function HandleModuleAutoMarkers(info)
	local module = state.module
	if not module or type(module.autoMarkers) ~= "table" then
		return
	end

	for index, rule in ipairs(module.autoMarkers) do
		local ruleKey = string.format("%s:auto:%d", module.id or state.encounterId or "module", index)
		if MatchesCombatLogTrigger(rule, info) then
			FireAutoMarker(rule, info, ruleKey)
		end
	end
end

local function HandleCombatLogEvent()
	if not state.module then
		return
	end

	if type(CombatLogGetCurrentEventInfo) ~= "function" then
		return
	end

	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
	local info = {
		timestamp = timestamp or GetTime(),
		event = subevent,
		sourceGUID = sourceGUID,
		sourceName = sourceName,
		sourceFlags = sourceFlags,
		sourceRaidFlags = sourceRaidFlags,
		destGUID = destGUID,
		destName = destName,
		destFlags = destFlags,
		destRaidFlags = destRaidFlags,
		spellId = spellId,
		spellName = spellName,
	}

	if info.event == "UNIT_DIED" and type(state.module.bossIds) == "table" then
		local mobId = GetMobIdFromGUID(info.destGUID)
		if mobId then
			for _, bossId in ipairs(state.module.bossIds) do
				if tonumber(bossId) == mobId then
					state.encounterFinished = true
					state.encounterFinishReason = "boss died"
					break
				end
			end
		end
	end

	if type(state.module.onCombatLog) == "function" then
		SafeCall(state.module.onCombatLog, state.module, info, state)
	end

	HandleModuleAutoMarkers(info)

	local triggers = state.module.combatLogTriggers
	if type(triggers) ~= "table" then
		return
	end

	for index, trigger in ipairs(triggers) do
		local triggerKey = string.format("%s:%d", state.module.id or state.encounterId or "module", index)
		if MatchesCombatLogTrigger(trigger, info) then
			FireCombatLogTrigger(trigger, info, triggerKey)
		end
	end
end

local function HandleEncounterEnd(encounterId, status)
	local module = state.module
	if not module or type(module.encounterEndIds) ~= "table" then
		return
	end

	for _, id in ipairs(module.encounterEndIds) do
		if tonumber(id) == tonumber(encounterId) then
			if tonumber(status) ~= 0 then
				state.encounterFinished = true
				state.encounterFinishReason = "encounter end"
				ClearEncounter(true)
			end
			return
		end
	end
end

local function ClearEncounter(showComplete)
	if showComplete and state.encounterId then
		FinishEncounter(state.encounterFinished == true, state.encounterFinishReason or "encounter finished")
	end
	state.encounterId = nil
	state.module = nil
	state.activeEvents = {}
	state.combatLogState = {}
	state.markerState = {}
	state.nextEventId = 0
	state.encounterStart = nil
	state.encounterFinished = nil
	state.encounterFinishReason = nil
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

	local db = GetDB()
	module.id = normalizedId
	module.name = module.name or normalizedId
	module.description = module.description or ""
	module.timeline = type(module.timeline) == "table" and module.timeline or {}
	module.combatLogTriggers = type(module.combatLogTriggers) == "table" and module.combatLogTriggers or {}
	if db.moduleEnabled[normalizedId] == nil then
		db.moduleEnabled[normalizedId] = true
	end
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

local function GetKillHistory(id)
	local db = GetDB()
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId then
		return nil
	end

	local history = db.killTimes[normalizedId]
	if type(history) ~= "table" then
		history = {}
		db.killTimes[normalizedId] = history
	end

	return history
end

local function GetOrderedModuleIds()
	local names = {}
	for id in pairs(Modules) do
		table.insert(names, id)
	end
	table.sort(names)
	return names
end

local function GetReportModuleId()
	if state.encounterId then
		return state.encounterId
	end

	local db = GetDB()
	if type(db.reportModuleId) == "string" and db.reportModuleId ~= "" and Modules[db.reportModuleId] then
		return db.reportModuleId
	end

	local names = GetOrderedModuleIds()
	return names[1]
end

local function SetReportModuleId(id)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId or not Modules[normalizedId] then
		return false
	end

	GetDB().reportModuleId = normalizedId
	if optionsFrame and optionsFrame:IsShown() and type(RefreshOptionsWindow) == "function" then
		RefreshOptionsWindow()
	end

	return true
end

local function RecordKillTime(id, duration)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId then
		return nil
	end

	duration = tonumber(duration)
	if not duration or duration <= 0 then
		return nil
	end

	local history = GetKillHistory(normalizedId)
	if not history then
		return nil
	end

	local entry = {
		duration = duration,
		timestamp = time and time() or nil,
	}
	table.insert(history, 1, entry)
	while #history > DEFAULT_KILL_HISTORY_LIMIT do
		table.remove(history)
	end

	return entry
end

local function FormatDuration(seconds)
	seconds = tonumber(seconds) or 0
	if seconds < 60 then
		return string.format("%.1fs", seconds)
	end

	local minutes = math.floor(seconds / 60)
	local remainder = seconds - (minutes * 60)
	return string.format("%dm %.1fs", minutes, remainder)
end

local function BuildKillSummaryLines(id)
	local normalizedId = NormalizeModuleId(id)
	if not normalizedId then
		return { "No encounter selected." }
	end

	local history = GetKillHistory(normalizedId)
	if not history or #history == 0 then
		return { string.format("No kill history recorded for %s.", normalizedId) }
	end

	local module = Modules[normalizedId]
	local lines = {}
	local best = history[1]
	for i = 2, #history do
		if history[i].duration < best.duration then
			best = history[i]
		end
	end

	table.insert(lines, string.format("%s", module and module.name or normalizedId))
	table.insert(lines, string.format("Best: %s", FormatDuration(best.duration)))
	table.insert(lines, string.format("Runs: %d", #history))
	for i = 1, math.min(5, #history) do
		table.insert(lines, string.format("%d. %s", i, FormatDuration(history[i].duration)))
	end

	return lines
end

local function BuildKillSummaryText(id)
	return table.concat(BuildKillSummaryLines(id), "\n")
end

local function PrintKillSummary(id)
	for _, line in ipairs(BuildKillSummaryLines(id)) do
		Print(line)
	end
end

local function FinishEncounter(victory, reason)
	local module = state.module
	if not module or not state.encounterId then
		return false
	end

	local duration = state.encounterStart and (GetTime() - state.encounterStart) or 0
	if victory then
		local entry = RecordKillTime(state.encounterId, duration)
		if entry then
			Print(string.format("Recorded kill for %s: %s%s", module.name or state.encounterId, FormatDuration(entry.duration), reason and reason ~= "" and string.format(" (%s)", reason) or ""))
		end
		PrintKillSummary(state.encounterId)
	elseif reason and reason ~= "" then
		Print(string.format("Finished %s: %s", module.name or state.encounterId, reason))
	end

	return true
end

local function MarkEncounterVictory(reason)
	if not state.encounterId then
		Print("No active encounter to record.")
		return false
	end

	state.encounterFinished = true
	state.encounterFinishReason = reason or "manual kill"
	ClearEncounter(true)
	return true
end

local function StartLeaderPull()
	local started = StartEncounter("pull-timers")
	if not started then
		Print("Pull timer module is unavailable.")
	end
	return started
end

local function CancelLeaderPull()
	if state.encounterId ~= "pull-timers" then
		Print("No active pull timer to cancel.")
		return false
	end

	ClearEncounter(false)
	Print("Pull timer cancelled.")
	return true
end

local function StartBreakTimer()
	local started = StartEncounter("break-timers")
	if not started then
		Print("Break timer module is unavailable.")
	end
	return started
end

local function CancelBreakTimer()
	if state.encounterId ~= "break-timers" then
		Print("No active break timer to cancel.")
		return false
	end

	ClearEncounter(false)
	Print("Break timer cancelled.")
	return true
end

local function StartRangeHelper(rangeValue)
	local normalizedRange = tonumber(rangeValue)
	if not normalizedRange then
		Print("Usage: /ipm range <yards> or /ipm range cancel")
		return false
	end

	normalizedRange = math.max(5, math.min(100, math.floor(normalizedRange + 0.5)))
	GetDB().rangeValue = normalizedRange
	local started = StartEncounter("range-helper")
	if not started then
		Print("Range helper module is unavailable.")
	end
	return started
end

local function CancelRangeHelper()
	GetDB().rangeValue = nil

	if state.encounterId == "range-helper" then
		ClearEncounter(false)
		Print("Range helper cancelled.")
	else
		Print("Range helper cleared.")
	end

	return true
end

local function TriggerReadyCheck()
	if type(DoReadyCheck) == "function" then
		DoReadyCheck()
		Print("Ready check sent.")
		return true
	end

	Print("Ready check is unavailable in this client.")
	return false
end

local function PrintRaidLeaderTools()
	Print("Leader tools: pull countdown, break timer, range helper, ready check, kill summary, and marker support.")
end

local function GetRangeValue()
	return GetDB().rangeValue
end

local function SetRangeValue(value)
	local normalized = tonumber(value)
	if normalized then
		normalized = math.max(5, math.min(100, math.floor(normalized + 0.5)))
	end
	GetDB().rangeValue = normalized
	return GetDB().rangeValue
end

local function GetPersistentPromptText(module)
	if not module then
		return nil
	end

	local promptText = module.persistentPromptText
	if type(promptText) == "function" then
		local ok, result = pcall(promptText, module, state)
		promptText = ok and result or nil
	end

	if type(promptText) == "string" and promptText ~= "" then
		return promptText
	end

	return nil
end

local function StartEncounter(encounterId)
	local normalizedId = NormalizeModuleId(encounterId)
	local module = normalizedId and Modules[normalizedId] or nil
	if not module then
		Print(string.format("Unknown module '%s'. Use /ipm modules to list available modules.", tostring(encounterId)))
		return false
	end

	if not IsModuleEnabled(normalizedId) then
		Print(string.format("Module '%s' is disabled. Use /ipm enable %s or the options window.", normalizedId, normalizedId))
		return false
	end

	ClearEncounter(false)
	state.encounterId = normalizedId
	state.module = module
	state.combatLogState = {}
	state.markerState = {}
	state.encounterStart = GetTime()
	state.encounterFinished = nil
	state.encounterFinishReason = nil

	if type(module.cycles) == "table" then
		for cycleName, members in pairs(module.cycles) do
			SeedCycle(cycleName, members)
		end
	end

	if type(module.onStart) == "function" then
		SafeCall(module.onStart, module, state)
	end

	if module.persistentPrompt then
		local promptText = GetPersistentPromptText(module)
		if promptText then
			SetPrompt(promptText)
		end
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

	if state.module and state.module.persistentPrompt then
		local promptText = GetPersistentPromptText(state.module)
		if promptText then
			SetPrompt(promptText)
		end
	elseif state.encounterId and visibleCount == 0 then
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
		local status = IsModuleEnabled(id) and "enabled" or "disabled"
		Print(string.format("%s [%s] - %s", id, status, module.name or id))
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
	Print("Commands: /ipm demo, /ipm start <module>, /ipm stop, /ipm kill, /ipm modules, /ipm cycles, /ipm options, /ipm pull, /ipm pull cancel, /ipm break, /ipm break cancel, /ipm range <yards>, /ipm range cancel, /ipm ready, /ipm summary [module], /ipm enable <module>, /ipm disable <module>, /ipm cycle <name> add <player>, /ipm cycle <name> list, /ipm cycle <name> next, /ipm sound on|off, /ipm lock, /ipm unlock")
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

	if lower == "pull" then
		StartLeaderPull()
		return
	end

	if lower == "pull cancel" then
		CancelLeaderPull()
		return
	end

	if lower == "break" then
		StartBreakTimer()
		return
	end

	if lower == "break cancel" then
		CancelBreakTimer()
		return
	end

	if lower == "range cancel" then
		CancelRangeHelper()
		return
	end

	local rangeValue = lower:match("^range%s+(%d+)$")
	if rangeValue then
		StartRangeHelper(rangeValue)
		return
	end

	if lower == "range" then
		local currentRange = GetDB().rangeValue
		if currentRange then
			Print(string.format("Current range helper: %d yards. Use /ipm range cancel to clear it.", currentRange))
		else
			Print("Usage: /ipm range <yards> or /ipm range cancel")
		end
		return
	end

	if lower == "ready" then
		TriggerReadyCheck()
		return
	end

	if lower == "leader" then
		PrintRaidLeaderTools()
		return
	end

	if lower == "kill" then
		MarkEncounterVictory("manual kill")
		return
	end

	local summaryId = lower:match("^summary%s*(.-)$")
	if summaryId then
		summaryId = summaryId:gsub("^%s+", ""):gsub("%s+$", "")
		if summaryId == "" then
			summaryId = state.encounterId
		end
		if summaryId then
			PrintKillSummary(summaryId)
		else
			Print("Usage: /ipm summary <module>")
		end
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

	if lower == "options" then
		OpenOptionsWindow()
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

	local enableId = lower:match("^enable%s+(.+)$")
	if enableId then
		if SetModuleEnabled(enableId, true) then
			Print(string.format("Enabled module %s.", NormalizeModuleId(enableId)))
		end
		return
	end

	local disableId = lower:match("^disable%s+(.+)$")
	if disableId then
		if SetModuleEnabled(disableId, false) then
			Print(string.format("Disabled module %s.", NormalizeModuleId(disableId)))
		end
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

local function CreateOptionsWindow()
	if optionsFrame then
		return optionsFrame
	end

	optionsFrame = CreateFrame("Frame", "IPullMobOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	optionsFrame:SetSize(700, 560)
	optionsFrame:SetPoint("CENTER")
	optionsFrame:SetMovable(true)
	optionsFrame:SetClampedToScreen(true)
	optionsFrame:EnableMouse(true)
	optionsFrame:RegisterForDrag("LeftButton")
	optionsFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	optionsFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	optionsFrame:SetBackdrop({
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		tile = true,
		tileSize = 12,
		edgeSize = 12,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	optionsFrame:SetBackdropColor(0.05, 0.05, 0.07, 0.95)
	optionsFrame:SetBackdropBorderColor(0.45, 0.45, 0.55, 1)
	optionsFrame:Hide()

	optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	optionsFrame.title:SetPoint("TOPLEFT", 14, -12)
	optionsFrame.title:SetText("I Pull Mob Options")

	optionsFrame.subtitle = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	optionsFrame.subtitle:SetPoint("TOPLEFT", optionsFrame.title, "BOTTOMLEFT", 0, -4)
	optionsFrame.subtitle:SetText("Enable modules and tune the core raid helper settings.")

	local close = CreateFrame("Button", nil, optionsFrame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 4, 4)

	optionsFrame.generalLabel = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	optionsFrame.generalLabel:SetPoint("TOPLEFT", 16, -52)
	optionsFrame.generalLabel:SetText("General")

	local function MakeToggle(buttonName, label, anchorPoint, relativeTo, relativePoint, x, y, getter, setter)
		local button = CreateFrame("CheckButton", buttonName, optionsFrame, "UICheckButtonTemplate")
		button:SetPoint(anchorPoint, relativeTo, relativePoint, x, y)
		button.Text:SetText(label)
		button:SetScript("OnClick", function(self)
			setter(self:GetChecked() and true or false)
		end)
		button.Refresh = function(self)
			self:SetChecked(getter() and true or false)
		end
		return button
	end

	optionsFrame.soundToggle = MakeToggle(
		"IPullMobOptionsSoundToggle",
		"Play alert sounds",
		"TOPLEFT",
		optionsFrame,
		"TOPLEFT",
		12,
		-72,
		function()
			return GetDB().soundEnabled
		end,
		function(value)
			GetDB().soundEnabled = value and true or false
		end
	)

	optionsFrame.autoShowToggle = MakeToggle(
		"IPullMobOptionsAutoShowToggle",
		"Auto-show on combat start",
		"TOPLEFT",
		optionsFrame.soundToggle,
		"BOTTOMLEFT",
		0,
		-6,
		function()
			return GetDB().autoShow
		end,
		function(value)
			GetDB().autoShow = value and true or false
		end
	)

	optionsFrame.lockToggle = MakeToggle(
		"IPullMobOptionsLockToggle",
		"Lock the raid window",
		"TOPLEFT",
		optionsFrame.autoShowToggle,
		"BOTTOMLEFT",
		0,
		-6,
		function()
			return GetDB().locked
		end,
		function(value)
			GetDB().locked = value and true or false
		end
	)

	local function MakeSlider(sliderName, label, anchorPoint, relativeTo, relativePoint, x, y, minValue, maxValue, stepValue, getter, setter, formatValue)
		local slider = CreateFrame("Slider", sliderName, optionsFrame, "OptionsSliderTemplate")
		slider:SetPoint(anchorPoint, relativeTo, relativePoint, x, y)
		slider:SetWidth(180)
		slider:SetMinMaxValues(minValue, maxValue)
		slider:SetValueStep(stepValue)
		slider:SetObeyStepOnDrag(true)
		slider:SetValue(getter())
		_G[sliderName .. "Low"]:SetText(formatValue(minValue))
		_G[sliderName .. "High"]:SetText(formatValue(maxValue))
		_G[sliderName .. "Text"]:SetText(label)
		slider.valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		slider.valueText:SetPoint("LEFT", slider, "RIGHT", 8, 0)
		slider.valueText:SetWidth(80)
		slider.valueText:SetJustifyH("LEFT")
		slider:SetScript("OnValueChanged", function(self, value)
			local snapped = math.floor((value / stepValue) + 0.5) * stepValue
			snapped = math.max(minValue, math.min(maxValue, snapped))
			snapped = math.floor(snapped * 100 + 0.5) / 100
			if self._updating then
				return
			end
			self._updating = true
			self:SetValue(snapped)
			setter(snapped)
			self.valueText:SetText(formatValue(snapped))
			self._updating = false
		end)
		slider.Refresh = function(self)
			self._updating = true
			local value = getter()
			self:SetValue(value)
			self.valueText:SetText(formatValue(value))
			self._updating = false
		end
		slider:Refresh()
		return slider
	end

	optionsFrame.scaleSlider = MakeSlider(
		"IPullMobOptionsScaleSlider",
		"Frame scale",
		"TOPLEFT",
		optionsFrame.lockToggle,
		"BOTTOMLEFT",
		4,
		-26,
		0.5,
		2.0,
		0.05,
		function()
			return GetDB().scale
		end,
		function(value)
			GetDB().scale = value
			UpdateScale()
		end,
		function(value)
			return string.format("%.2fx", value)
		end
	)

	optionsFrame.volumeSlider = MakeSlider(
		"IPullMobOptionsVolumeSlider",
		"Alert volume",
		"TOPLEFT",
		optionsFrame.scaleSlider,
		"BOTTOMLEFT",
		0,
		-30,
		0,
		1,
		0.05,
		function()
			return GetDB().alertVolume
		end,
		function(value)
			GetDB().alertVolume = value
		end,
		function(value)
			return string.format("%d%%", math.floor(value * 100 + 0.5))
		end
	)

	optionsFrame.rangeSlider = MakeSlider(
		"IPullMobOptionsRangeSlider",
		"Range helper",
		"TOPLEFT",
		optionsFrame.volumeSlider,
		"BOTTOMLEFT",
		0,
		-30,
		5,
		100,
		1,
		function()
			return GetDB().rangeValue or 8
		end,
		function(value)
			GetDB().rangeValue = value
			if state.encounterId == "range-helper" and state.module and state.module.persistentPrompt then
				local promptText = GetPersistentPromptText(state.module)
				if promptText then
					SetPrompt(promptText)
				end
			end
		end,
		function(value)
			return string.format("%d yd", math.floor(value + 0.5))
		end
	)

	optionsFrame.reportLabel = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	optionsFrame.reportLabel:SetPoint("TOPRIGHT", optionsFrame, "TOPRIGHT", -18, -52)
	optionsFrame.reportLabel:SetText("Post-Fight Report")

	optionsFrame.reportPanel = CreateFrame("Frame", nil, optionsFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	optionsFrame.reportPanel:SetSize(200, 250)
	optionsFrame.reportPanel:SetPoint("TOPRIGHT", optionsFrame, "TOPRIGHT", -14, -72)
	optionsFrame.reportPanel:SetBackdrop({
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		tile = true,
		tileSize = 12,
		edgeSize = 12,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	optionsFrame.reportPanel:SetBackdropColor(0.08, 0.08, 0.10, 0.92)
	optionsFrame.reportPanel:SetBackdropBorderColor(0.35, 0.35, 0.45, 1)

	optionsFrame.reportText = optionsFrame.reportPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	optionsFrame.reportText:SetPoint("TOPLEFT", 8, -8)
	optionsFrame.reportText:SetPoint("BOTTOMRIGHT", -8, 48)
	optionsFrame.reportText:SetJustifyH("LEFT")
	optionsFrame.reportText:SetJustifyV("TOP")
	optionsFrame.reportText:SetText("Select a module or start an encounter to see recent kill history.")

	local function ShiftReportSelection(delta)
		local names = GetOrderedModuleIds()
		if #names == 0 then
			return
		end

		local current = GetReportModuleId()
		local index = 1
		for i, id in ipairs(names) do
			if id == current then
				index = i
				break
			end
		end

		index = index + delta
		if index < 1 then
			index = #names
		elseif index > #names then
			index = 1
		end

		SetReportModuleId(names[index])
	end

	optionsFrame.reportPrev = CreateFrame("Button", nil, optionsFrame.reportPanel, "UIPanelButtonTemplate")
	optionsFrame.reportPrev:SetSize(56, 20)
	optionsFrame.reportPrev:SetPoint("BOTTOMLEFT", 8, 10)
	optionsFrame.reportPrev:SetText("Prev")
	optionsFrame.reportPrev:SetScript("OnClick", function()
		ShiftReportSelection(-1)
	end)

	optionsFrame.reportNext = CreateFrame("Button", nil, optionsFrame.reportPanel, "UIPanelButtonTemplate")
	optionsFrame.reportNext:SetSize(56, 20)
	optionsFrame.reportNext:SetPoint("LEFT", optionsFrame.reportPrev, "RIGHT", 6, 0)
	optionsFrame.reportNext:SetText("Next")
	optionsFrame.reportNext:SetScript("OnClick", function()
		ShiftReportSelection(1)
	end)

	optionsFrame.reportActive = CreateFrame("Button", nil, optionsFrame.reportPanel, "UIPanelButtonTemplate")
	optionsFrame.reportActive:SetSize(68, 20)
	optionsFrame.reportActive:SetPoint("LEFT", optionsFrame.reportNext, "RIGHT", 6, 0)
	optionsFrame.reportActive:SetText("Active")
	optionsFrame.reportActive:SetScript("OnClick", function()
		if state.encounterId then
			SetReportModuleId(state.encounterId)
		end
	end)

	optionsFrame.reportHint = optionsFrame.reportPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	optionsFrame.reportHint:SetPoint("BOTTOMLEFT", 8, -2)
	optionsFrame.reportHint:SetWidth(184)
	optionsFrame.reportHint:SetJustifyH("LEFT")
	optionsFrame.reportHint:SetText("Preview recent kill times for the chosen module.")

	local function MakeButton(buttonName, label, anchorPoint, relativeTo, relativePoint, x, y, width, onClick)
		local button = CreateFrame("Button", buttonName, optionsFrame, "UIPanelButtonTemplate")
		button:SetSize(width or 120, 22)
		button:SetPoint(anchorPoint, relativeTo, relativePoint, x, y)
		button:SetText(label)
		button:SetScript("OnClick", onClick)
		return button
	end

	optionsFrame.leaderLabel = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	optionsFrame.leaderLabel:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", 16, -240)
	optionsFrame.leaderLabel:SetText("Leader Tools")

	optionsFrame.pullButton = MakeButton(
		"IPullMobPullButton",
		"Pull Countdown",
		"TOPLEFT",
		optionsFrame.leaderLabel,
		"BOTTOMLEFT",
		0,
		-6,
		120,
		function()
			StartLeaderPull()
		end
	)

	optionsFrame.readyButton = MakeButton(
		"IPullMobReadyButton",
		"Ready Check",
		"LEFT",
		optionsFrame.pullButton,
		"RIGHT",
		10,
		0,
		110,
		function()
			TriggerReadyCheck()
		end
	)

	optionsFrame.killButton = MakeButton(
		"IPullMobKillButton",
		"Record Kill",
		"LEFT",
		optionsFrame.readyButton,
		"RIGHT",
		10,
		0,
		110,
		function()
			MarkEncounterVictory("manual button")
		end
	)

	optionsFrame.summaryButton = MakeButton(
		"IPullMobSummaryButton",
		"Kill Summary",
		"TOPLEFT",
		optionsFrame.pullButton,
		"BOTTOMLEFT",
		0,
		-6,
		120,
		function()
			if state.encounterId then
				PrintKillSummary(state.encounterId)
			else
				Print("No active encounter selected.")
			end
		end
	)

	optionsFrame.toolsHint = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	optionsFrame.toolsHint:SetPoint("LEFT", optionsFrame.summaryButton, "RIGHT", 12, 0)
	optionsFrame.toolsHint:SetWidth(250)
	optionsFrame.toolsHint:SetJustifyH("LEFT")
	optionsFrame.toolsHint:SetText("Use these buttons to coordinate pulls, cancel timers, and save kill times.")

	optionsFrame.modulesLabel = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	optionsFrame.modulesLabel:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", 16, -310)
	optionsFrame.modulesLabel:SetText("Modules")

	local scrollFrame = CreateFrame("ScrollFrame", "IPullMobOptionsScrollFrame", optionsFrame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 14, -334)
	scrollFrame:SetPoint("BOTTOMRIGHT", -214, 14)

	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(1, 1)
	scrollFrame:SetScrollChild(content)
	optionsFrame.scrollFrame = scrollFrame
	optionsFrame.scrollContent = content

	local scrollbar = _G[scrollFrame:GetName() .. "ScrollBar"]
	if scrollbar then
		scrollbar:ClearAllPoints()
		scrollbar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 0, -16)
		scrollbar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 0, 16)
	end

	RefreshOptionsWindow = function()
		optionsFrame.soundToggle:Refresh()
		optionsFrame.autoShowToggle:Refresh()
		optionsFrame.lockToggle:Refresh()
		optionsFrame.scaleSlider:Refresh()
		optionsFrame.volumeSlider:Refresh()
		optionsFrame.rangeSlider:Refresh()
		optionsFrame.reportText:SetText(BuildKillSummaryText(GetReportModuleId()))
		optionsFrame.reportLabel:SetText(string.format("Post-Fight Report: %s", (function()
			local id = GetReportModuleId()
			local module = id and Modules[id]
			return module and module.name or (id or "none")
		end)()))
		optionsFrame.reportHint:SetText(state.encounterId and "Showing the active encounter history." or "Use Prev / Next to browse saved histories, or Active during a fight.")

		local names = {}
		for id in pairs(Modules) do
			table.insert(names, id)
		end
		table.sort(names)

		local spacing = 24
		local visibleHeight = 0

		for i, id in ipairs(names) do
			local button = optionsModuleButtons[i]
			if not button then
				button = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
				optionsModuleButtons[i] = button
				button:SetScript("OnClick", function(self)
					SetModuleEnabled(self.moduleId, self:GetChecked() and true or false)
				end)
			end

			local module = Modules[id]
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -visibleHeight)
			button.moduleId = id
			button.Text:SetText(string.format("%s (%s)", module.name or id, id))
			button:SetChecked(IsModuleEnabled(id) and true or false)
			button:Show()
			visibleHeight = visibleHeight + spacing
		end

		for i = #names + 1, #optionsModuleButtons do
			optionsModuleButtons[i]:Hide()
		end

		content:SetHeight(math.max(visibleHeight, 1))
		optionsFrame.modulesLabel:SetText(string.format("Modules (%d enabled / %d total)", (function()
			local enabledCount = 0
			for _, id in ipairs(names) do
				if IsModuleEnabled(id) then
					enabledCount = enabledCount + 1
				end
			end
			return enabledCount
		end)(), #names))
	end

	optionsFrame:SetScript("OnShow", function()
		if type(RefreshOptionsWindow) == "function" then
			RefreshOptionsWindow()
		end
	end)

	return optionsFrame
end

OpenOptionsWindow = function()
	local frame = CreateOptionsWindow()
	if type(RefreshOptionsWindow) == "function" then
		RefreshOptionsWindow()
	end
	frame:Show()
	return frame
end

local function RegisterEventHandlers()
	Fojiji:RegisterEvent("PLAYER_LOGIN")
	Fojiji:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Fojiji:RegisterEvent("ENCOUNTER_END")
	Fojiji:RegisterEvent("PLAYER_REGEN_DISABLED")
	Fojiji:RegisterEvent("PLAYER_REGEN_ENABLED")
	Fojiji:SetScript("OnEvent", function(_, event, ...)
		if event == "PLAYER_LOGIN" then
			GetDB()
			UpdateScale()
			ApplySavedFramePosition()
			return
		end

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if state.encounterId then
				HandleCombatLogEvent()
			end
			return
		end

		if event == "ENCOUNTER_END" then
			HandleEncounterEnd(...)
			return
		end

		if event == "PLAYER_REGEN_DISABLED" and GetDB().autoShow and state.encounterId then
			Fojiji:Show()
			return
		end

		if event == "PLAYER_REGEN_ENABLED" then
			if state.encounterId then
				if state.module and state.module.persistentPrompt then
					if GetDB().autoShow then
						Fojiji:Show()
					else
						Fojiji:Hide()
					end
				else
					ClearEncounter(state.encounterFinished == true)
				end
			else
				Fojiji:Hide()
			end
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
		IsModuleEnabled = IsModuleEnabled,
		SetModuleEnabled = SetModuleEnabled,
		RegisterSharedMedia = function(_, kind, key, value)
			if type(_G.IPullMobSupport) == "table" and type(_G.IPullMobSupport.RegisterMedia) == "function" then
				return _G.IPullMobSupport:RegisterMedia(kind, key, value)
			end
		end,
		GetSharedMedia = function(_, kind, key)
			if type(_G.IPullMobSupport) == "table" and type(_G.IPullMobSupport.GetMedia) == "function" then
				return _G.IPullMobSupport:GetMedia(kind, key)
			end
		end,
		StartEncounter = StartEncounter,
		ClearEncounter = ClearEncounter,
		StartLeaderPull = StartLeaderPull,
		TriggerReadyCheck = TriggerReadyCheck,
		MarkEncounterVictory = MarkEncounterVictory,
		PrintKillSummary = PrintKillSummary,
		PrintRaidLeaderTools = PrintRaidLeaderTools,
		GetRangeValue = GetRangeValue,
		SetRangeValue = SetRangeValue,
		ApplyRaidMarker = ApplyRaidMarker,
		FindRaidUnitByName = FindRaidUnitByName,
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
		GetCurrentEncounter = function()
			return state.encounterId, state.module, state.encounterStart
		end,
		GetReportModule = GetReportModuleId,
		SetReportModule = function(_, id)
			return SetReportModuleId(id)
		end,
		GetKillSummaryLines = BuildKillSummaryLines,
		GetKillSummaryText = BuildKillSummaryText,
		GetSupport = function()
			return _G.IPullMobSupport
		end,
		OpenOptions = OpenOptionsWindow,
		RefreshOptions = function()
			if type(RefreshOptionsWindow) == "function" then
				RefreshOptionsWindow()
			end
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
