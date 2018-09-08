
ScriptLoader_AddOnCommandManager("ExtraCommand_OnCommandManager")


function ExtraCommand_OnCommandManager(aIndex,code,arg)

	if code == 100 then

		ExtraCommand_OnlineUser(aIndex,arg)
		return 1

	elseif code == 101 then

		ExtraCommand_UserInfo(aIndex,arg)
		return 1

	elseif code == 102 then

		ExtraCommand_UserLogout(aIndex,arg)
		return 1

	elseif code == 103 then

		ExtraCommand_UserClearInv(aIndex,arg)
		return 1

	elseif code == 110 then

		ExtraCommand_GameMasterDrop(aIndex,arg)
		return 1

	elseif code == 111 then

		ExtraCommand_GameMasterMonsterSpawn(aIndex,arg)
		return 1

	elseif code == 112 then

		ExtraCommand_GameMasterSetLevel(aIndex,arg)
		return 1

	elseif code == 113 then

		ExtraCommand_GameMasterSetLevelUpPoint(aIndex,arg)
		return 1

	elseif code == 114 then

		ExtraCommand_GameMasterSetStrength(aIndex,arg)
		return 1

	elseif code == 115 then

		ExtraCommand_GameMasterSetDexterity(aIndex,arg)
		return 1

	elseif code == 116 then

		ExtraCommand_GameMasterSetVitality(aIndex,arg)
		return 1

	elseif code == 117 then

		ExtraCommand_GameMasterSetEnergy(aIndex,arg)
		return 1

	elseif code == 118 then

		ExtraCommand_GameMasterSetLeadership(aIndex,arg)
		return 1

	elseif code == 119 then

		ExtraCommand_GameMasterSetMasterLevel(aIndex,arg)
		return 1

	elseif code == 120 then

		ExtraCommand_GameMasterSetMasterPoint(aIndex,arg)
		return 1

	elseif code == 121 then

		ExtraCommand_GameMasterSetEffect(aIndex,arg)
		return 1

	elseif code == 122 then

		ExtraCommand_GameMasterSetRuud(aIndex,arg)
		return 1

	elseif code == 204 then

		CustomPK_SetBountyCommand(aIndex,arg)
		return 1

	elseif code == 205 then

		CustomPK_TrackBounty(aIndex,arg)
		return 1

	end

	return 0

end


function ExtraCommand_OnlineUser(aIndex,arg)

	local CurUser = GetGameServerCurUser()

	local MaxUser = GetGameServerMaxUser()

	NoticeSend(aIndex,1,string.format("Online User: %d/%d",CurUser,MaxUser))

end


function ExtraCommand_UserInfo(aIndex,arg)

	local TargetName = CommandGetArgString(arg,0)

	local TargetIndex = GetObjectIndexByName(TargetName)

	if TargetIndex ~= -1 then

		local TargetLevel = GetObjectLevel(TargetIndex)

		local TargetReset = GetObjectReset(TargetIndex)

		NoticeSend(aIndex,1,string.format("[%s] Level: %d, Reset: %d",TargetName,TargetLevel,TargetReset))

	end

end


function ExtraCommand_UserLogout(aIndex,arg)

	local LogoutType = CommandGetArgNumber(arg,0)

	UserGameLogout(aIndex,LogoutType)

end


function ExtraCommand_UserClearInv(aIndex,arg)

	for n=12,76,1 do

		if InventoryGetItemIndex(aIndex,n) ~= -1 then

			InventoryDelItemIndex(aIndex,n)

		end

	end

end


function ExtraCommand_GameMasterDrop(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local ItemMap = GetObjectMap(aIndex)

		local ItemMapX = GetObjectMapX(aIndex)

		local ItemMapY = GetObjectMapY(aIndex)

		local ItemSect = CommandGetArgNumber(arg,0)

		local ItemType = CommandGetArgNumber(arg,1)

		local ItemLevel = CommandGetArgNumber(arg,2)

		local ItemOption1 = CommandGetArgNumber(arg,3)

		local ItemOption2 = CommandGetArgNumber(arg,4)

		local ItemOption3 = CommandGetArgNumber(arg,5)

		local ItemNewOption = CommandGetArgNumber(arg,6)

		ItemDropEx(aIndex,ItemMap,ItemMapX,ItemMapY,ItemSect*512+ItemType,ItemLevel,0,ItemOption1,ItemOption2,ItemOption3,ItemNewOption)

	end

end


function ExtraCommand_GameMasterMonsterSpawn(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local MonsterClass = CommandGetArgNumber(arg,0)
		
		local MonsterTime = CommandGetArgNumber(arg,1)
		
		if MonsterTime == nil or MonsterTime == 0 then MonsterTime = 60 end

		local MonsterMap = CommandGetArgNumber(arg,2)

		local MonsterMapX = CommandGetArgNumber(arg,3)

		local MonsterMapY = CommandGetArgNumber(arg,4)

		if MonsterMap == 0 and MonsterMapX == 0 and MonsterMapY == 0 then

			MonsterMap = GetObjectMap(aIndex)

			MonsterMapX = GetObjectMapX(aIndex)

			MonsterMapY = GetObjectMapY(aIndex)

		end
		
		Monster_Spawn(MonsterClass,MonsterMap,MonsterMapX,MonsterMapY,-1,MonsterTime)

	end

end


function ExtraCommand_GameMasterSetLevel(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetLevel = CommandGetArgNumber(arg,1)

			SetObjectLevel(TargetIndex,TargetLevel)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetLevelUpPoint(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetLevelUpPoint = CommandGetArgNumber(arg,1)

			SetObjectLevelUpPoint(TargetIndex,TargetLevelUpPoint)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetStrength(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetStrength = CommandGetArgNumber(arg,1)

			SetObjectStrength(TargetIndex,TargetStrength)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetDexterity(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetDexterity = CommandGetArgNumber(arg,1)

			SetObjectDexterity(TargetIndex,TargetDexterity)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetVitality(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetVitality = CommandGetArgNumber(arg,1)

			SetObjectVitality(TargetIndex,TargetVitality)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetEnergy(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetEnergy = CommandGetArgNumber(arg,1)

			SetObjectEnergy(TargetIndex,TargetEnergy)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetLeadership(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetLeadership = CommandGetArgNumber(arg,1)

			SetObjectLeadership(TargetIndex,TargetLeadership)

			UserCalcAttribute(TargetIndex)

			UserInfoSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetMasterLevel(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetMasterLevel = CommandGetArgNumber(arg,1)

			SetObjectMasterLevel(TargetIndex,TargetMasterLevel)

			UserCalcAttribute(TargetIndex)

			MasterLevelUpSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetMasterPoint(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetMasterPoint = CommandGetArgNumber(arg,1)

			SetObjectMasterPoint(TargetIndex,TargetMasterPoint)

			UserCalcAttribute(TargetIndex)

			MasterLevelUpSend(TargetIndex)

		end

	end

end


function ExtraCommand_GameMasterSetEffect(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local EffectIndex = CommandGetArgNumber(arg,1)

			local EffectCount = CommandGetArgNumber(arg,2)

			EffectAdd(TargetIndex,0,EffectIndex,EffectCount,0,0,0,0)

		end

	end

end


function ExtraCommand_GameMasterSetRuud(aIndex,arg)

	if GetObjectAuthority(aIndex) == 32 then

		local TargetName = CommandGetArgString(arg,0)

		local TargetIndex = GetObjectIndexByName(TargetName)

		if TargetIndex ~= -1 then

			local TargetRuud = CommandGetArgNumber(arg,1)

			SetObjectRuud(TargetIndex,TargetRuud)

			RuudSend(TargetIndex,TargetRuud)

		end

	end

end