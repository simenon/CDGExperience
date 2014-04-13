CDGExperience = {}

CDGExperience.currentXP = 0

CRAFTING_TYPES = { 
	CRAFTING_TYPE_ALCHEMY,
	CRAFTING_TYPE_BLACKSMITHING,
	CRAFTING_TYPE_CLOTHIER,
	CRAFTING_TYPE_ENCHANTING,
	CRAFTING_TYPE_PROVISIONING,
	CRAFTING_TYPE_WOODWORKING }

CRAFTING_TYPES_EN = { 
	[CRAFTING_TYPE_ALCHEMY]       = "alchemy",
	[CRAFTING_TYPE_BLACKSMITHING] = "blacksmithing",
	[CRAFTING_TYPE_CLOTHIER]      = "clothier",
	[CRAFTING_TYPE_ENCHANTING]    = "enchanting",
	[CRAFTING_TYPE_PROVISIONING]  = "provisioning",
	[CRAFTING_TYPE_WOODWORKING]   = "woodworking" }
	
SKILL_TYPES_EN = {
	[SKILL_TYPE_ARMOR]      = "armor",
	[SKILL_TYPE_AVA]        = "ava",
	[SKILL_TYPE_CLASS]      = "class",
	[SKILL_TYPE_GUILD]      = "guild",
	[SKILL_TYPE_NONE]       = "none",
	[SKILL_TYPE_RACIAL]     = "racial",
	[SKILL_TYPE_TRADESKILL] = "tradeskill",
	[SKILL_TYPE_WEAPON]     = "weapon",
	[SKILL_TYPE_WORLD]      = "world" }


function CDGExperience_OnInitialized()
	CDGExperience.currentXP = GetUnitXP('player')
	
	for _, tradeSkillType in ipairs(CRAFTING_TYPES) do
		if not CDGExperience.craft then CDGExperience.craft = {} end
		if not CDGExperience.craft.currentXP then CDGExperience.craft.currentXP = {} end
		if not CDGExperience.craft.currentXP[tradeSkillType] then CDGExperience.craft.currentXP[tradeSkillType] = {} end

		skillType, skillIndex = GetCraftingSkillLineIndices(tradeSkillType)
	  _, _, CDGExperience.craft.currentXP[tradeSkillType] = GetSkillLineXPInfo(skillType, skillIndex)
	end
	
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_SKILL_XP_UPDATE, CDGExperience_SkillXPUpdate)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_UPDATE, CDGExperience_ExperienceUpdate)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_QUEST_COMPLETE_EXPERIENCE, CDGExperience_QuestCompleteExperience)
--	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN, CDGExperience_ExperienceGain)
	EVENT_MANAGER:RegisterForEvent("CDGExperience",EVENT_EXPERIENCE_GAIN_DISCOVERY,CDGExperience_ExperienceGainDiscovery )
end

function XPReasonToString(reason)
	local sReason = "UNKNOWN"
	if     reason == XP_REASON_ACTION then sReason = "XP_REASON_ACTION"
	elseif reason == XP_REASON_BATTLEGROUND then sReason = "XP_REASON_BATTLEGROUND"
	elseif reason == XP_REASON_COLLECT_BOOK then sReason = "XP_REASON_COLLECT_BOOK"
	elseif reason == XP_REASON_COMMAND then sReason = "XP_REASON_COMMAND"
	elseif reason == XP_REASON_COMPLETE_POI then sReason = "for completing POI"
	elseif reason == XP_REASON_DISCOVER_POI then sReason = "for discovering POI"
	elseif reason == XP_REASON_FINESSE then sReason = "XP_REASON_FINESSE"
	elseif reason == XP_REASON_KEEP_REWARD then sReason = "XP_REASON_KEEP"
	elseif reason == XP_REASON_KILL then sReason = "for killing a mob"
	elseif reason == XP_REASON_LOCK_PICK then sReason = "for lockpicking"
	elseif reason == XP_REASON_MEDAL then sReason = "XP_REASON_MEDAL"
	elseif reason == XP_REASON_NONE then sReason = "XP_REASON_NONE"
	elseif reason == XP_REASON_OVERLAND_BOSS_KILL then sReason = "for killing an overland boss"
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

function CDGExperience_ExperienceUpdate(eventCode,unitTag,currentExp,maxExp,reason)
	if ( unitTag ~= 'player' ) then 
		return 
	end
	
	if reason ~= XP_REASON_DISCOVER_POI and
		 reason ~= XP_REASON_QUEST then
		local XPgain = currentExp - CDGExperience.currentXP
		d(string.format("%d XP gained %s ", XPgain, XPReasonToString(reason)))
	end

	CDGExperience.currentXP = currentExp
end

function CDGExperience_SkillXPUpdate(eventCode, skillType, skillIndex, oldXP, maxXP, newXP)

	for _, tradeSkillType in ipairs(CRAFTING_TYPES) do

		sType, sIndex = GetCraftingSkillLineIndices(tradeSkillType)
		if sType == skillType and sIndex == skillIndex then
			local XPgain = newXP - CDGExperience.craft.currentXP[tradeSkillType]
			d(string.format("%d %s XP gained for %s",XPgain, CRAFTING_TYPES_EN[tradeSkillType], SKILL_TYPES_EN[sType] ))
			CDGExperience.craft.currentXP[tradeSkillType] = newXP
		end
	
	end

end

function CDGExperience_QuestCompleteExperience(eventCode, questName, xpGained)
	d(string.format("%d XP gained for completing %s",xpGained, questName))
end

--function CDGExperience_ExperienceGain(eventCode, value, reason)
--	d(string.format("XP GAIN : Gained %d XP from %s[%d]",value, XPReasonToString(reason),reason))
--end

function CDGExperience_ExperienceGainDiscovery(eventCode, areaName, value)
	d(string.format("%d XP gained for discovering %s",value, areaName))
end
