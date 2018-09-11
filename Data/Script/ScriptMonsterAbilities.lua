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

SelupanStartFightTimer = 0

SelupanIndex = 0

SelupanLastHP = 0

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
	
		Monster_CallPassiveAbilities(aIndex)
	
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
		
		if GetObjectClass(aIndex) == 460 or GetObjectClass(aIndex) == 461 or GetObjectClass(aIndex) == 462 then
		
			SelupanStartFightTimer = 20

		elseif GetObjectClass(aIndex) == 459 then

			SelupanPlayerList = nil

			SelupanMasterTimer = 0

			SelupanStartFightTimer = 0

			SelupanIndex = 0

			SelupanLastHP = 0
		
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
			
			for o=GetMinMonsterIndex(),GetMaxMonsterIndex(),1 do
			
				if GetObjectClass(o) == 459 then
				
					SelupanIndex = o
					
					break
				
				end
			
			end
			
			if SelupanIndex ~= 0 then
			
				SelupanMasterTimer = 600
			
				SelupanLastHP = GetObjectLife(SelupanIndex)
			
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Selupan Index: %d",SelupanIndex))	--TEST
				
				NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Selupan HP: %d",SelupanLastHP))	--TEST
				
				SelupanPlayerList = nil
			
				for p=GetMinUserIndex(),GetMaxUserIndex(),1 do
			
					if GetObjectMap(p) == 58 then
				
						table.insert(SelupanPlayerList,p)
					
						NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("Player: %s",GetObjectName(p)))	--TEST
						
						
				
					end
				
				end

			end
		
		elseif SelupanStartFightTimer > 0 then
		
			SelupanStartFightTimer = SelupanStartFightTimer - 1
			
			NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SelupanStartFightTimer: %d",SelupanStartFightTimer))	--TEST
		
		end
		
		if SelupanMasterTimer > 0 then
		
			SelupanMasterTimer = SelupanMasterTimer - 1
			
			SelupanLastHP = GetObjectLife(SelupanIndex)
			
			NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SelupanMasterTimer: %d",SelupanMasterTimer))	--TEST
			
			NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("SelupanLastHP: %d",SelupanLastHP))	--TEST
		
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