function CDGExperience_OnInitialized()
	--	EVENT_QUEST_COMPLETE_EXPERIENCE (string questName, integer xpGained)
	--	EVENT_EXPERIENCE_GAIN (integer value, integer reason)
--EVENT_EXPERIENCE_GAIN_DISCOVERY (string areaName, integer value)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN, CDGExperience_ExperienceGain)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN_DISCOVERY,CDGExperience_ExperienceGainDiscovery )
end

function XPReasonToString(reason)
	local sReason = "UNKNOWN"
	if     reason == XP_REASON_ACTION then sReason = "XP_REASON_ACTION"
	elseif reason == XP_REASON_BATTLEGROUND then sReason = "XP_REASON_BATTLEGROUND"
	elseif reason == XP_REASON_COLLECT_BOOK then sReason = "XP_REASON_COLLECT_BOOK"
	elseif reason == XP_REASON_COMMAND then sReason = "XP_REASON_COMMAND"
	elseif reason == XP_REASON_COMPLETE_POI then sReason = "XP_REASON_COMPLETE_POI"
	elseif reason == XP_REASON_DISCOVER_POI then sReason = "XP_REASON_DISCOVER_POI"
	elseif reason == XP_REASON_FINESSE then sReason = "XP_REASON_FINESSE"
	elseif reason == XP_REASON_KEEP_REWARD then sReason = "XP_REASON_KEEP"
	elseif reason == XP_REASON_KILL then sReason = "XP_REASON_KILL"
	elseif reason == XP_REASON_LOCK_PICK then sReason = "XP_REASON_LOCK_PICK"
	elseif reason == XP_REASON_MEDAL then sReason = "XP_REASON_MEDAL"
	elseif reason == XP_REASON_NONE then sReason = "XP_REASON_NONE"
	elseif reason == XP_REASON_OVERLAND_BOSS_KILL then sReason = "XP_REASON_OVERLAND_BOSS_KILL"
	elseif reason == XP_REASON_QUEST then sReason = "XP_REASON_QUEST"
	elseif reason == XP_REASON_REWARD then sReason = "XP_REASON_REWARD"
	elseif reason == XP_REASON_SCRIPTED_EVENT then sReason = "XP_REASON_SCRIPTED_EVENT"
	elseif reason == XP_REASON_SKILL_AVA then sReason = "XP_REASON_SKILL_AVA"
	elseif reason == XP_REASON_SKILL_BOOK then sReason = "XP_REASON_SKILL_BOOK"
	elseif reason == XP_REASON_SKILL_GUILD_REP then sReason = "XP_REASON_SKILL_GUILD_REP"
	elseif reason == XP_REASON_SKILL_TRADESKILL then sReason = "XP_REASON_SKILL_TRADESKILL"
	elseif reason == XP_REASON_SKILL_TRADESKILL_ACHIEVEMENT then sReason = "XP_REASON_SKILL_TRADESKILL_ACHIEVEMENT"
	elseif reason == XP_REASON_SKILL_TRADESKILL_CONSUME then sReason = "XP_REASON_SKILL_TRADESKILL_CONSUME"
	elseif reason == XP_REASON_SKILL_TRADESKILL_HARVEST then sReason = "XP_REASON_SKILL_TRADESKILL_HARVEST"
	elseif reason == XP_REASON_SKILL_TRADESKILL_QUEST then sReason = "XP_REASON_SKILL_TRADESKILL_QUEST"
	elseif reason == XP_REASON_SKILL_TRADESKILL_RECIPE then sReason = "XP_REASON_SKILL_TRADESKILL_RECIPE"
	elseif reason == XP_REASON_SKILL_TRADESKILL_TRAIT then sReason = "XP_REASON_SKILL_TRADESKILL_TRAIT"
	end
	return sReason
end

function CDGExperience_ExperienceGain(value, reason)
	
	d(string.format("Gained %d XP from %s",value, XPReasonToString(reason)))
end

function CDGExperience_ExperienceGainDiscovery(areaName, value)
	d(string.format("Gained %d Discover XP from %s",value, areaName))
end
