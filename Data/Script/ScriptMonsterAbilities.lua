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

		------------------------- BC, DS, CC Master Fix ---------------------
		
		if GetObjectLevel(bIndex) < 200 then
		
			if GetObjectMap(bIndex) == 52 then
			
				MoveUserEx(bIndex,2,210,28)
				
				ItemGiveEx(bIndex,6674,8,0,0,0,0,0)
				
				NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")
				
			elseif GetObjectMap(bIndex) == 32 then
			
				MoveUserEx(bIndex,3,172,105)
				
				ItemGiveEx(bIndex,7187,7,0,0,0,0,0)
				
				NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")
				
			elseif GetObjectMap(bIndex) == 53 then
			
				MoveUserEx(bIndex,0,123,133)

				NoticeSend(bIndex,1,"You must have at least 200 level to enter this location.")
				
			end
		
		end
		
		------------------------/ BC, DS, CC Master Fix ---------------------
	
		
		
	
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