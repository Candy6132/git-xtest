MonsterAbilities_SystemSwitch = 1

--DeathBeamKnight = 63

--MidFireTimer = 0

--FirstBeamKnigtIndex = 0

--FirstBeamKnightMap = 0

--FirstBeamKnightMapX = 0

--FirstBeamKnightMapY = 0

--FirstBeamKillerIndex = 0

MonsterCounter = 0

MonsterCounterGMName = ""

MonsterCounterTimer = 0

-------SELUPAN--------

SelupanPlayerList = {}

SelupanMasterTimer = 0

SelupanMaxFightTime = 1199

--SelupanEnrageTime = 600

SelupanEnrageTime = 1000 -- TEST

SelupanStartFightTimer = 0

SelupanMammothFreq = 10

SelupanIceGiantFreq = 30

SelupanTitanFreq = 45

SelupanTitanIndex = 0

SelupanTitanTimer = 0

SelupanTitanDuration = 15

SelupanTitanGateIndex = 0

SelupanTitanGateTimer = 0

SelupanTitanGateDuration = 10

SelupanMeteorFrequency = 30

SelupanMeteorTimer = 0

SelupanMeteorDuration = 15

SelupanMeteorTarget = 0

SelupanPhase = 0

SelupanIndex = 0

SelupanLastHP = 0

RINGOFICE = 6664

PENDANTOFICE = 6681

ScriptLoader_AddOnUserRespawn("MonsterAbilities_OnUserRespawn")

------/SELUPAN--------



ScriptLoader_AddOnReadScript("MonsterAbilities_OnReadScript")

ScriptLoader_AddOnMonsterDie("MonsterAbilities_OnMonsterDie")

ScriptLoader_AddOnTimerThread("MonsterAbilities_OnTimerThread")



function MonsterAbilities_OnReadScript()

	if MonsterAbilities_SystemSwitch == 1 then

		math.randomseed(os.time())

	end
	
end


function MonsterAbilities_OnMonsterDie(aIndex,bIndex)

	if MonsterAbilities_SystemSwitch == 1 then
	
		Monster_CallPassiveAbilities(aIndex,bIndex)
		
		if GetObjectClass(aIndex) == 53 then
		
			Monster_FrostBloom(aIndex,7,10)
			
			------------------------- Selupan Boss Fight ---------------------
			
			if aIndex == SelupanTitanIndex then
			
				SelupanTitanIndex = 0
				
				SelupanTitanTimer = 0
			
			end
			
			------------------------/ Selupan Boss Fight ---------------------
		
		end
	
		----------------Licznik Mobow--------------------
		
		if GetObjectAuthority(bIndex) == 32 and InventoryGetItemIndex(bIndex,12) == 0 then
		
			local GMName = GetObjectName(bIndex)
			
			if GMName == MonsterCounterGMName then

				MonsterCounter = MonsterCounter+1
			
			end
			
			if MonsterCounterTimer == 0 then
			
				MonsterCounter = 1
			
				MonsterCounterTimer = 61
				
				MonsterCounterGMName = GMName
			
			end
		
		end
		
		---------------/Licznik Mobow--------------------
		
		------------------------- CUSTOM INVASION - 259 Erohim, 7269 Jewel of Luck w 51 Elbeland:
		
		if GetObjectClass(aIndex) == 295 and GetObjectMap(aIndex) == 51 then

			ItemDropEx(bIndex,51,GetObjectMapX(aIndex),GetObjectMapY(aIndex),7269,9,0,0,0,0,0)

		end
		
		------------------------/ CUSTOM INVASION -------------------------

		------------------------- Level Restrictions ---------------------
		
		if GetObjectAuthority(bIndex) ~= 32 then
		
			local KillerLevel = GetObjectLevel(bIndex)
		
			local KillerMap = GetObjectMap(bIndex)
		
			if (KillerLevel < 300 and KillerMap == 57) or (KillerLevel < 270 and KillerMap == 56) then

				MoveUserEx(bIndex,1,174,218)
			
				local KillerZen = GetObjectMoney(bIndex)
			
				SetObjectMoney(bIndex,KillerZen-2000000)
			
				MoneySend(bIndex,KillerZen-2000000)
				
				SetObjectPKCount(bIndex,GetObjectPKCount(bIndex)+3)
			
				SetObjectPKLevel(bIndex,GetObjectPKLevel(bIndex)+6)
			
				SetObjectPKTimer(bIndex,GetObjectPKTimer(bIndex)+3600)
				
				PKLevelSend(bIndex,GetObjectPKLevel(bIndex)+6)

				NoticeSend(bIndex,1,"Exploiting DL Summon is not allowed. Enjoy your punishment. :)")
			
				NoticeSend(bIndex,1,"You paid 2 000 000 Zen for warp.")
		
			elseif KillerLevel < 200 then
		
				if KillerMap == 52 then
			
					MoveUserEx(bIndex,2,210,28)
				
					ItemGiveEx(bIndex,6674,8,0,0,0,0,0)
				
					NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")

				elseif KillerMap == 32 then
			
					MoveUserEx(bIndex,3,172,105)
				
					ItemGiveEx(bIndex,7187,7,0,0,0,0,0)
				
					NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")
				
				elseif KillerMap == 53 then
			
					MoveUserEx(bIndex,0,123,133)

					NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")
				
				end

			end
		
		end
		
		------------------------/ Level Restrictions ---------------------
	
		------------------------- Selupan Boss Fight ---------------------
		
		if GetObjectMap(aIndex) == 58 then
		
			local MonsterClass = GetObjectClass(aIndex)
		
			if SelupanMasterTimer == 0 and (MonsterClass == 460 or MonsterClass == 461 or MonsterClass == 462) then
		
				SelupanStartFightTimer = 20

			elseif MonsterClass == 459 then

				MonsterAbilities_SelupanResetFight()
		
			elseif MonsterClass == 22 then

				local PendantItem = InventoryGetItemIndex(bIndex,9)
				
				local Ring1Item = InventoryGetItemIndex(bIndex,10)
				
				local Ring2Item = InventoryGetItemIndex(bIndex,11)

				if PendantItem ~= PENDANTOFICE and Ring1Item ~= RINGOFICE and Ring2Item ~= RINGOFICE then
				
					EffectAdd(bIndex,0,57,10,0,0,0,0)
				
					for nPlayer=1,#SelupanPlayerList,1 do
					
						local nPlayerIndex = SelupanPlayerList[nPlayer]
				
						if bIndex ~= nPlayerIndex and Monster_CheckDistanceBetweenObjects(nPlayerIndex,bIndex) <= 4 then

							EffectAdd(nPlayerIndex,0,57,10,0,0,0,0)
					
						end
						
					end
					
				else
				
					EffectAdd(bIndex,0,57,5,0,0,0,0)
				
				end
				
			elseif MonsterClass == 158 then
			
				SelupanTitanGateTimer = 0
				
				SelupanTitanGateIndex = 0
		
			end
		
		end
		
		------------------------/ Selupan Boss Fight ---------------------
	
		------------------------- Fire Festival Bosses---------------------
		
		--if GetObjectClass(aIndex) == DeathBeamKnight then
		
		--	if GetObjectMap(aIndex) ~= 8 then
			
		--		if FirstBeamKnightIndex == 0 or FirstBeamKnightIndex == nil then
				
		--			FirstBeamKnightIndex = aIndex
					
		--			FirstBeamKillerIndex = bIndex
					
		--			FirstBeamKnightMap = GetObjectMap(aIndex)
					
		--			FirstBeamKnightMapX = GetObjectMapX(aIndex)
					
		--			FirstBeamKnightMapY = GetObjectMapY(aIndex)
					
		--			MidFireTimer = 10
					
		--		elseif MidFireTimer >= 5 then
					
		--			local Map = GetObjectMap(aIndex)
						
		--			local MapX = GetObjectMapX(aIndex)
						
		--			local MapY = GetObjectMapY(aIndex)
					
		--			ItemDrop(bIndex,Map,MapX,MapY,100)
						
		--			FireworksSend(bIndex,MapX,MapY)
						
		--			ItemDrop(FirstBeamKillerIndex,FirstBeamKnightMap,FirstBeamKnightMapX,FirstBeamKnightMapY,100)
						
		--			FireworksSend(FirstBeamKillerIndex,FirstBeamKnightMapX,FirstBeamKnightMapY)
					
		--			local MessageText = ""
					
		--			if FirstBeamKillerIndex == bIndex then
										
		--				MessageText = string.format("%s have defeated both Fire Beam Knights!",GetObjectName(bIndex))
						
		--			else
					
		--				MessageText = string.format("%s and %s have defeated both Fire Beam Knights!",GetObjectName(FirstBeamKillerIndex),GetObjectName(bIndex))
					
		--			end
					
		--			--local MessageText = string.format("%s and %s have defeated both Fire Beam Knights!",GetObjectName(FirstBeamKillerIndex),GetObjectName(bIndex))
						
		--			NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
						
		--			MidFireTimer = 0
						
		--			FirstBeamKnightIndex = nil

		--			FirstBeamKnightMap = nil

		--			FirstBeamKnightMapX = nil

		--			FirstBeamKnightMapY = nil

		--			FirstBeamKillerIndex = nil

		--		end
			
		--	end
		
		--end
		
		------------------------- Fire Festival Bosses---------------------
		
	end

end


------------------------- Selupan Boss Fight ---------------------

function MonsterAbilities_OnUserRespawn(aIndex,KillerType)

	if MonsterAbilities_SystemSwitch ~= 0 then
	
		local DeathMap = GetObjectDeathMap(aIndex)
		
		if aIndex == SelupanMeteorTarget then SelupanMeteorTimer = 0 end

		if DeathMap == 58 then
		
			if SelupanMasterTimer > 0 then
			
				local DeathMapX = GetObjectDeathMapX(aIndex)
				
				local DeathMapY = GetObjectDeathMapY(aIndex)

				Monster_FrostBloom(Monster_Spawn(55,DeathMap,DeathMapX,DeathMapY,-1,120),22,10)			--Frost Bloom + Spawn Szkieleta
				
				ChatTargetSend(SelupanIndex,-1,"This soul is mine now!")
		
				MonsterAbilities_SelupanRefreshPlayerList()
				
				if #SelupanPlayerList == 0 then
				
					MonsterAbilities_SelupanResetFight()
				
				end
			
			end
		
		end
		
	end
	
end

------------------------/ Selupan Boss Fight ---------------------



function MonsterAbilities_OnTimerThread()

	if MonsterAbilities_SystemSwitch == 1 then
	
		----------------Licznik Mobow--------------------
		
		if MonsterCounterTimer > 1 then
		
			MonsterCounterTimer = MonsterCounterTimer-1
			
		elseif MonsterCounterTimer == 1 then
		
			MonsterCounterTimer = MonsterCounterTimer-1
			
			NoticeSend(GetObjectIndexByName(MonsterCounterGMName),0,string.format("Monster Counter: %d monsters/min",MonsterCounter))
			
			MonsterCounter = 0
		
		end
		
		---------------/Licznik Mobow--------------------
		
		------------------------- Selupan Boss Fight ---------------------
		
		if SelupanStartFightTimer == 1 then
		
			SelupanStartFightTimer = 0
			
			MonsterAbilities_StartSelupanFight()
			
			ChatTargetSend(SelupanIndex,-1,"How dare you touch my eggs?!")

		elseif SelupanStartFightTimer > 0 then
		
			SelupanStartFightTimer = SelupanStartFightTimer - 1

		end
		
		if SelupanMeteorTimer > 0 then
		
			SelupanMeteorTimer = SelupanMeteorTimer - 1
			
			local MeteorTargetMapX = GetObjectMapX(SelupanMeteorTarget)
			
			local MeteorTargetMapY = GetObjectMapY(SelupanMeteorTarget)
			
			Monster_Spawn(103,58,MeteorTargetMapX,MeteorTargetMapY,0,5)

		end
		
		if SelupanTitanGateTimer > 1 then
		
			SelupanTitanGateTimer = SelupanTitanGateTimer - 1
		
		elseif SelupanTitanGateTimer == 1 then
		
			local GateMapX = GetObjectMapX(SelupanTitanGateIndex)
			
			local GateMapY = GetObjectMapY(SelupanTitanGateIndex)
		
			SelupanTitanIndex = Monster_Spawn(53,58,GateMapX,GateMapY,-1,SelupanTitanDuration)				--Goledn Titan
			
			SelupanTitanTimer = SelupanTitanDuration - 2
		
			SelupanTitanGateTimer = 0
			
			SelupanTitanGateIndex = 0
		
		end
		
		if SelupanTitanTimer > 1 then
		
			SelupanTitanTimer = SelupanTitanTimer - 1
			
		elseif SelupanTitanTimer == 1 then
		
			Monster_FrostBloom(SelupanTitanIndex,20,5)
		
			SelupanTitanTimer = 0
		
			SelupanTitanIndex = 0 
		
		end
		
		if SelupanMasterTimer > 1 then
		
			SelupanMasterTimer = SelupanMasterTimer - 1
			
			SelupanLastHP = tonumber(100*GetObjectLife(SelupanIndex)/GetObjectMaxLife(SelupanIndex))
			
			if SelupanPhase == 0 and SelupanLastHP <= 90 then							--Summon Mammoth + Meteor
			
				SelupanPhase = 1
				
				ChatTargetSend(SelupanIndex,-1,"You shall see my power!")
				
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("PHASE: %d",SelupanPhase))	--TEST
			
			elseif SelupanPhase == 1 and SelupanLastHP <= 60 then						--Summon Ice Giant + Meteor
			
				SelupanPhase = 2
				
				--ChatTargetSend(SelupanIndex,-1,"Come my creatures, freeze those mortals!")
				
				ChatTargetSend(SelupanIndex,-1,"Come to me, let it pierce you to the bone!")
				
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("PHASE: %d",SelupanPhase))	--TEST
			
			elseif SelupanPhase == 2 and SelupanLastHP <= 30 then						--Summon Golden Titan + Summon Ice Giant + Meteor
			
				SelupanPhase = 3
				
				ChatTargetSend(SelupanIndex,-1,"You're just a miserable dust!")
				
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("PHASE: %d",SelupanPhase))	--TEST
				
			elseif SelupanPhase == 3 and SelupanLastHP <= 10 then						--Summon Golden Titan + Summon Ice Giant + Meteor (Czesciej) razem z Ice Arrow
			
				SelupanPhase = 4
				
				ChatTargetSend(SelupanIndex,-1,"You won't run from me!")
				
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("PHASE: %d",SelupanPhase))	--TEST
			
			end
			
			local SelupanPlayerListLength = #SelupanPlayerList
			
			if SelupanPlayerListLength > 0 then
			
				for k=1,SelupanPlayerListLength,1 do
			
					if GetObjectMap(k) ~= 58 then
				
						MonsterAbilities_SelupanRefreshPlayerList()
						
						SelupanPlayerListLength = #SelupanPlayerList
					
						break
				
					end
					
				end
				
			end

			if SelupanPlayerListLength > 0 then

				if SelupanPhase == 1 and (SelupanMasterTimer % SelupanMammothFreq) == 0 then
				
					local SpawnX = math.random(-3,3) + GetObjectMapX(SelupanIndex)
					
					local SpawnY = math.random(-3,3) + GetObjectMapY(SelupanIndex)

					Monster_Spawn(455,58,SpawnX,SpawnY,-1,60)															--Mammoth
					
				elseif SelupanPhase > 1 and (SelupanMasterTimer % SelupanIceGiantFreq) == 0 then
				
					local SpawnX = math.random(-3,3) + GetObjectMapX(SelupanIndex)
					
					local SpawnY = math.random(-3,3) + GetObjectMapY(SelupanIndex)

					Monster_Spawn(456,58,SpawnX,SpawnY,-1,60)															--Ice Giant
			
				end
				
				if SelupanPhase > 3 and (SelupanMasterTimer % SelupanTitanFreq) == 0 then
					
					local SpawnX = math.random(-5,5) + GetObjectMapX(SelupanIndex)										--ZROBIC FUNKCJE ZEBY NIE RESPILO W SCIANIE
					
					local SpawnY = math.random(-5,5) + GetObjectMapY(SelupanIndex)

					SelupanTitanGateIndex = Monster_Spawn(158,58,SpawnX,SpawnY,-1,SelupanTitanGateDuration)				--Kalima Gate
					
					SelupanTitanGateTimer = SelupanTitanGateDuration - 2

					ChatTargetSend(SelupanIndex,-1,"Come my infernal minion. The master calls you!")
					
					NoticeRegionSend(0,"Selupan Spawns Titan Gate")														--TEST
				
				end

				if SelupanPhase < 4 then
				
					if (SelupanMasterTimer % SelupanMeteorFrequency) == 0 then
				
						SelupanMeteorTarget = SelupanPlayerList[math.random(1,#SelupanPlayerList)]
						
						SelupanMeteorTimer = SelupanMeteorDuration
						
						EffectAdd(SelupanMeteorTarget,0,75,SelupanMeteorDuration,0,0,0,0)
						
						local MeteorTargetMapX = GetObjectMapX(SelupanMeteorTarget)
						
						local MeteorTargetMapY = GetObjectMapY(SelupanMeteorTarget)
						
						Monster_Spawn(103,58,MeteorTargetMapX,MeteorTargetMapY,0,3)										--Meteor
						
						ChatTargetSend(SelupanIndex,-1,"I'll burn you!")
						
					end
					
				else
				
					if (SelupanMasterTimer % SelupanMeteorFrequency/2) == 0 then
				
						SelupanMeteorTarget = SelupanPlayerList[math.random(1,#SelupanPlayerList)]
						
						SelupanMeteorTimer = SelupanMeteorDuration
						
						EffectAdd(SelupanMeteorTarget,0,75,SelupanMeteorDuration,0,0,0,0)
						
						EffectAdd(SelupanMeteorTarget,0,57,SelupanMeteorDuration,0,0,0,0)
						
						local MeteorTargetMapX = GetObjectMapX(SelupanMeteorTarget)
						
						local MeteorTargetMapY = GetObjectMapY(SelupanMeteorTarget)
						
						Monster_Spawn(103,58,MeteorTargetMapX,MeteorTargetMapY,0,3)										--Meteor
					
					end
					
				end
			
				if SelupanPhase ~= 5 and SelupanMasterTimer < SelupanEnrageTime then
				
					SelupanPhase = 5
					
					ChatTargetSend(SelupanIndex,-1,"Your end is close, mortals!")
					
					NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("PHASE: %d",SelupanPhase))	--TEST
					
				end
				
				if SelupanPhase == 5 then
			
					for j=1,#SelupanPlayerList,1 do
				
						Monster_Spawn(101,58,GetObjectMapX(j),GetObjectMapY(j),0,5)
					
						EffectAdd(j,0,76,5,10,10,0,0)							--TEST
					
						EffectAdd(j,0,77,5,0,0,10,10)							--TEST
				
					end
			
				end

				--NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SelupanMasterTimer: %d",SelupanMasterTimer))	--TEST
			
				--NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SelupanLastHP: %d",SelupanLastHP))	--TEST
				
			else
			
				MonsterAbilities_SelupanResetFight()
			
			end
			
		elseif SelupanMasterTimer == 1 then

			MonsterAbilities_SelupanRefreshPlayerList()
			
			local SelupanPlayerListLength = #SelupanPlayerList
			
			if SelupanPlayerListLength > 0 then
			
				for g=1,SelupanPlayerListLength,1 do
				
					MoveUser(SelupanPlayerList[g],287)
				
				end
			
			end
			
			MonsterAbilities_SelupanResetFight()
		
		end
		
		------------------------/ Selupan Boss Fight ---------------------
	
	end

------------------------- Fire Festival Bosses---------------------

--	if MonsterAbilities_SystemSwitch == 1 then
	
--		if MidFireTimer > 0 then
		
--			if MidFireTimer == 1 then
			
--				if FirstBeamKillerIndex ~= nil and FirstBeamKillerIndex ~= 0 then
			
--					NoticeSend(FirstBeamKillerIndex,1,"You have failed to kill both Fire Beam Knights at the same time.")
					
--					local MessageText = string.format("%s failed to kill both Fire Beam Knights. Try again tomorrow!",GetObjectName(FirstBeamKillerIndex))
						
--					NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
					
--				end
	
--				FirstBeamKnightIndex = nil

--				FirstBeamKnightMap = nil

--				FirstBeamKnightMapX = nil

--				FirstBeamKnightMapY = nil

--				FirstBeamKillerIndex = nil
			
--			end
			
--			MidFireTimer = MidFireTimer-1
		
--		end
	
--	end

------------------------- Fire Festival Bosses---------------------

end

------------------------- Selupan Boss Fight ---------------------

function MonsterAbilities_StartSelupanFight()

	for o=GetMinMonsterIndex(),GetMaxMonsterIndex(),1 do
			
		if GetObjectClass(o) == 459 then
				
			if GetObjectLife(o) > 0 and GetObjectMap(o) == 58 then
				
				SelupanIndex = o
				
				--break
				
			end
				
		end
			
	end
			
	if SelupanIndex ~= 0 then
			
		SelupanLastHP = tonumber(100*GetObjectLife(SelupanIndex)/GetObjectMaxLife(SelupanIndex))

		SelupanMasterTimer = SelupanMaxFightTime

		NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Selupan Index: %d",SelupanIndex))	--TEST
		
		NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Selupan HP: %d",SelupanLastHP))	--TEST
		
		MonsterAbilities_SelupanRefreshPlayerList()
		
		return true
		
	else
	
		return false

	end

end


function MonsterAbilities_SelupanResetFight()

	SelupanPlayerList = {}

	SelupanMasterTimer = 0

	SelupanStartFightTimer = 0

	SelupanTitanIndex = 0

	SelupanTitanTimer = 0

	SelupanTitanGateIndex = 0

	SelupanTitanGateTimer = 0

	SelupanMeteorTimer = 0

	SelupanMeteorTarget = 0

	SelupanPhase = 0

	SelupanIndex = 0

	SelupanLastHP = 0

	for e=GetMinMonsterIndex(),GetMaxMonsterIndex(),1 do
	
		local eClass = GetObjectClass(e)
		
		local eMap = GetObjectMap(e)
			
		if eMap == 58 and eClass ~= 460 and eClass ~= 461 and eClass ~= 462 then
			
			MonsterDelete(e)
			
		end
			
	end
	
	NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SELUPAN FIGHT END"))	--TEST

end


function MonsterAbilities_SelupanRefreshPlayerList()

	SelupanPlayerList = {}
			
	for p=GetMinUserIndex(),GetMaxUserIndex(),1 do
			
		if GetObjectMap(p) == 58 then

			table.insert(SelupanPlayerList,p)

			--NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Player: %s",GetObjectName(p)))	--TEST
		
		end
	
	end

end


------------------------/ Selupan Boss Fight ---------------------