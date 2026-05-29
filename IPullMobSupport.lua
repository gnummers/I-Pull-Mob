local IPM = _G.IPullMob
if not IPM then
	return
end

local Support = _G.IPullMobSupport
if type(Support) ~= "table" then
	Support = {}
	_G.IPullMobSupport = Support
end

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

Support:RegisterMedia("sounds", "alert", 8959)
Support:RegisterMedia("sounds", "pull", 8959)
Support:RegisterMedia("sounds", "warning", 8959)
Support:RegisterMedia("textures", "warning", "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
Support:RegisterMedia("textures", "pull", "Interface\\Icons\\INV_Misc_QuestionMark")
Support:RegisterMedia("textures", "ready", "Interface\\RaidFrame\\ReadyCheck-Ready")

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
