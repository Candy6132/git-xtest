require("ScriptDefine")
require("ScriptUtil")
require("ScriptCustomRespawn")
require("ScriptExtraCommand")
require("ScriptCustomPK")


function OnReadScript()

	ScriptLoader_OnReadScript()

end


function OnShutScript()

	ScriptLoader_OnShutScript()

end


function OnTimerThread()

	ScriptLoader_OnTimerThread()

end


function OnCommandManager(aIndex,code,arg)

	if ScriptLoader_OnCommandManager(aIndex,code,arg) ~= 0 then

		return 1

	end

	return 0

end


function OnCharacterEntry(aIndex)

	local UserName = GetObjectName(aIndex)

	local UserAccountLevel = GetObjectAccountLevel(aIndex)

	local UserAccountExpireDate = GetObjectAccountExpireDate(aIndex)

	NoticeSend(aIndex,0,string.format(MessageGet(256,GetObjectLang(aIndex)),UserName))

	if UserAccountLevel == 0 then 

		NoticeSend(aIndex,1,string.format(MessageGet(248,GetObjectLang(aIndex)),UserAccountExpireDate))

	elseif UserAccountLevel == 1 then

		NoticeSend(aIndex,1,string.format(MessageGet(249,GetObjectLang(aIndex)),UserAccountExpireDate))

	elseif UserAccountLevel == 2 then

		NoticeSend(aIndex,1,string.format(MessageGet(250,GetObjectLang(aIndex)),UserAccountExpireDate))

	elseif UserAccountLevel == 3 then

		NoticeSend(aIndex,1,string.format(MessageGet(251,GetObjectLang(aIndex)),UserAccountExpireDate))

	end

	ScriptLoader_OnCharacterEntry(aIndex)

end


function OnCharacterClose(aIndex)

	ScriptLoader_OnCharacterClose(aIndex)

end


function OnNpcTalk(aIndex,bIndex)

	if ScriptLoader_OnNpcTalk(aIndex,bIndex) ~= 0 then

		return 1

	end

	return 0

end


function OnMonsterDie(aIndex,bIndex)

	ScriptLoader_OnMonsterDie(aIndex,bIndex)

end


function OnUserDie(aIndex,bIndex)

	ScriptLoader_OnUserDie(aIndex,bIndex)

end


function OnUserRespawn(aIndex,KillerType)

	ScriptLoader_OnUserRespawn(aIndex,KillerType)

end


function OnCheckUserTarget(aIndex,bIndex)

	if ScriptLoader_OnCheckUserTarget(aIndex,bIndex) == 0 then

		return 0

	end

	return 1

end


function OnCheckUserKiller(aIndex,bIndex)

	if ScriptLoader_OnCheckUserKiller(aIndex,bIndex) == 0 then

		return 0

	end

	return 1

end


function OnPacketRecv(aIndex,buff,size)

	ScriptLoader_OnPacketRecv(aIndex,buff,size)

end