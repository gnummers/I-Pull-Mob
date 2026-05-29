local IPM = _G.IPullMob
if not IPM then
	return
end

local Support = _G.IPullMobSupport
if type(Support) ~= "table" then
	Support = {}
	_G.IPullMobSupport = Support
end

local SharedMedia = LibStub and LibStub("LibSharedMedia-3.0", true) or nil

Support.media = type(Support.media) == "table" and Support.media or {}
Support.utilities = type(Support.utilities) == "table" and Support.utilities or {}

local function EnsureBucket(kind)
	if type(kind) ~= "string" or kind == "" then
		return nil
	end

	local bucket = Support.media[kind]
	if type(bucket) ~= "table" then
		bucket = {}
		Support.media[kind] = bucket
	end

	return bucket
end

function Support:RegisterMedia(kind, key, value)
	local bucket = EnsureBucket(kind)
	if not bucket then
		return false
	end

	bucket[key] = value
	return true
end

function Support:GetMedia(kind, key)
	local bucket = EnsureBucket(kind)
	if not bucket then
		return nil
	end

	return bucket[key]
end

function Support:ResolveMedia(kind, key)
	local value = self:GetMedia(kind, key)
	if type(value) == "string" and (kind == "sounds" or kind == "sound") then
		if SharedMedia then
			local fetched = SharedMedia:Fetch("sound", value, true)
			if fetched then
				return fetched
			end
		end
		return nil
	end

	return value
end

function Support:RegisterUtility(name, func)
	if type(name) ~= "string" or name == "" or type(func) ~= "function" then
		return false
	end

	Support.utilities[name] = func
	return true
end

function Support:CallUtility(name, ...)
	local func = Support.utilities[name]
	if type(func) ~= "function" then
		return nil
	end

	local ok, result = pcall(func, ...)
	if ok then
		return result
	end

	return nil
end

Support:RegisterMedia("sounds", "alert", "fojji Bell")
Support:RegisterMedia("sounds", "pull", "fojji Beep")
Support:RegisterMedia("sounds", "warning", "fojji Interrupt")
Support:RegisterMedia("sounds", "info", "fojji Info")
Support:RegisterMedia("sounds", "success", "fojji Notification")
Support:RegisterMedia("sounds", "ready", "fojji Click")
Support:RegisterMedia("sounds", "kill", "fojji MultiPop")
Support:RegisterMedia("sounds", "phase2", "fojji Phase2")
Support:RegisterMedia("sounds", "phase3", "fojji Phase3")
Support:RegisterMedia("sounds", "phase4", "fojji Phase4")
Support:RegisterMedia("sounds", "berserk", "fojji Berserk")
Support:RegisterMedia("sounds", "taunt", "fojji Taunt")
Support:RegisterMedia("sounds", "watchfeet", "fojji |cFFFF0000Watch your feet|r")
Support:RegisterMedia("textures", "warning", "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
Support:RegisterMedia("textures", "pull", "Interface\\Icons\\INV_Misc_QuestionMark")
Support:RegisterMedia("textures", "ready", "Interface\\RaidFrame\\ReadyCheck-Ready")
Support:RegisterMedia("textures", "kill", "Interface\\RaidFrame\\ReadyCheck-Ready")
Support:RegisterMedia("textures", "range", "Interface\\Icons\\Spell_Nature_Sentinal")

IPM.RegisterSharedMedia = function(_, kind, key, value)
	return Support:RegisterMedia(kind, key, value)
end

IPM.GetSharedMedia = function(_, kind, key)
	return Support:GetMedia(kind, key)
end

IPM.RegisterUtility = function(_, name, func)
	return Support:RegisterUtility(name, func)
end

IPM.CallUtility = function(_, name, ...)
	return Support:CallUtility(name, ...)
end
