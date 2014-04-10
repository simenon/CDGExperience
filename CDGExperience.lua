function CDGExperience_OnInitialized()
	--	EVENT_QUEST_COMPLETE_EXPERIENCE (string questName, integer xpGained)
	--	EVENT_EXPERIENCE_GAIN (integer value, integer reason)
--EVENT_EXPERIENCE_GAIN_DISCOVERY (string areaName, integer value)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN, CDGExperience_ExperienceGain)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN_DISCOVERY,CDGExperience_ExperienceGainDiscovery )
end

function CDGExperience_ExperienceGain(value, reason)
	p(string.format("Gained %d XP from %d",value, reason))
end

function CDGExperience_ExperienceGainDiscovery(value, areaName)
	p(string.format("Gained %d Discover XP from %s",value, areaName))
end
