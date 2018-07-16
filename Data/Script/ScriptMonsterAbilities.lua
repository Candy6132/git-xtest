MonsterAbilities_SystemSwitch = 1

IceQueen = 25

HellSpider = 13

DeathBeamKnight = 63

MonsterAbilities_MonsterTable = {}

MidFireTimer = 0

FirstBeamKnightIndex = 0

FirstBeamKnightMap = 0

FirstBeamKnightMapX = 0

FirstBeamKnightMapY = 0

FirstBeamKillerIndex = 0






MonsterAbilities_NumberOfMonstersSpawned = {}

MonsterAbilities_MonsterSpawnIndex = {}

MonsterAbilities_NumberOfMonstersSpawned[IceQueen] = 4

MonsterAbilities_NumberOfMonstersSpawned[HellSpider] = 5

MonsterAbilities_MonsterSpawnIndex[IceQueen] = 22

MonsterAbilities_MonsterSpawnIndex[HellSpider] = 3



ScriptLoader_AddOnReadScript("MonsterAbilities_OnReadScript")

ScriptLoader_AddOnMonsterDie("MonsterAbilities_OnMonsterDie")

------------------------- Fire Festival Bosses---------------------

ScriptLoader_AddOnTimerThread("MonsterAbilities_OnTimerThread")

------------------------- Fire Festival Bosses---------------------



function MonsterAbilities_OnReadScript()

	if MonsterAbilities_SystemSwitch == 1 then

		local ReadTable = FileLoad("..\\Data\\Script\\Data\\MonsterAbilities.txt")

		if ReadTable == nil then return end

		local ReadCount = 1

		while ReadCount < #ReadTable do

			if ReadTable[ReadCount] == "end" then

				ReadCount = ReadCount+1

				break

			else

				MonsterAbilities_MonsterTableRow = {}
	
				MonsterAbilities_MonsterTableRow["LordClass"] = tonumber(ReadTable[ReadCount])

				ReadCount = ReadCount+1

				MonsterAbilities_MonsterTableRow["MonsterClass"] = tonumber(ReadTable[ReadCount])

				ReadCount = ReadCount+1

				MonsterAbilities_MonsterTableRow["NoMonsters"] = tonumber(ReadTable[ReadCount])

				ReadCount = ReadCount+1

				MonsterAbilities_MonsterTableRow["SpawnChance"] = tonumber(ReadTable[ReadCount])

				ReadCount = ReadCount+1
			
				table.insert(MonsterAbilities_MonsterTable,MonsterAbilities_MonsterTableRow)
	
			end

		end

		math.randomseed(os.time())

	end
	
end


function MonsterAbilities_OnMonsterDie(aIndex,bIndex)

	if MonsterAbilities_SystemSwitch == 1 then
	
		------------------------- Fire Festival Bosses---------------------
		
		if GetObjectClass(aIndex) == DeathBeamKnight then
		
			if GetObjectMap(aIndex) ~= 8 then
			
				if FirstBeamKnightIndex == 0 or FirstBeamKnightIndex == nil then
				
					FirstBeamKnightIndex = aIndex
					
					FirstBeamKillerIndex = bIndex
					
					FirstBeamKnightMap = GetObjectMap(aIndex)
					
					FirstBeamKnightMapX = GetObjectMapX(aIndex)
					
					FirstBeamKnightMapY = GetObjectMapY(aIndex)
					
					MidFireTimer = 10
					
				elseif MidFireTimer >= 5 then
					
					local Map = GetObjectMap(aIndex)
						
					local MapX = GetObjectMapX(aIndex)
						
					local MapY = GetObjectMapY(aIndex)
					
					ItemDrop(bIndex,Map,MapX,MapY,100)
						
					FireworksSend(bIndex,MapX,MapY)
						
					ItemDrop(FirstBeamKillerIndex,FirstBeamKnightMap,FirstBeamKnightMapX,FirstBeamKnightMapY,100)
						
					FireworksSend(FirstBeamKillerIndex,FirstBeamKnightMapX,FirstBeamKnightMapY)
					
					local MessageText = ""
					
					if FirstBeamKillerIndex == bIndex then
										
						MessageText = string.format("%s have defeated both Fire Beam Knights!",GetObjectName(bIndex))
						
					else
					
						MessageText = string.format("%s and %s have defeated both Fire Beam Knights!",GetObjectName(FirstBeamKillerIndex),GetObjectName(bIndex))
					
					end
					
					--local MessageText = string.format("%s and %s have defeated both Fire Beam Knights!",GetObjectName(FirstBeamKillerIndex),GetObjectName(bIndex))
						
					NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
						
					MidFireTimer = 0
						
					FirstBeamKnightIndex = nil

					FirstBeamKnightMap = nil

					FirstBeamKnightMapX = nil

					FirstBeamKnightMapY = nil

					FirstBeamKillerIndex = nil

				end
			
			end
		
		end
		------------------------- Fire Festival Bosses---------------------
		
		------------------------- CUSTOM INVASION - 259 Erohim, 7269 Jewel of Luck w 51 Elbeland:
		
		if GetObjectClass(aIndex) == 295 and GetObjectMap(aIndex) == 51 then

			ItemDropEx(bIndex,51,GetObjectMapX(aIndex),GetObjectMapY(aIndex),7269,9,0,0,0,0,0)

		end
		
		------------------------- CUSTOM INVASION
	
		for i=1,#MonsterAbilities_MonsterTable,1 do
		
			local LordClass = MonsterAbilities_MonsterTable[i].LordClass
			
			--NoticeSend(GetObjectIndexByName("Candy"),1,string.format("Lord Class: %s",MonsterAbilities_MonsterTable[i].SpawnChance))

			if GetObjectClass(aIndex) == LordClass then MonsterAbilities_SpawnMonster(aIndex,LordClass,i) end

		end
	
	end

end

function MonsterAbilities_SpawnMonster(aIndex,bClass,i)

	if math.random(99)+1 <= MonsterAbilities_MonsterTable[i].SpawnChance then

		local LordMap = GetObjectMap(aIndex)
			
		local LordMapX = GetObjectMapX(aIndex)
			
		local LordMapY = GetObjectMapY(aIndex)
		
		for n=1,MonsterAbilities_MonsterTable[i].NoMonsters,1 do
			
			--MonsterCreate(IceMonster,LordMap,math.random(LordMapX-4,LordMapX+4),math.random(LordMapY-4,LordMapY+4),1)
			
			MonsterCreate(MonsterAbilities_MonsterTable[i].MonsterClass,LordMap,LordMapX,LordMapY,1)
			
		end

	end
	
end


------------------------- Fire Festival Bosses---------------------

function MonsterAbilities_OnTimerThread()

	if MonsterAbilities_SystemSwitch == 1 then
	
		if MidFireTimer > 0 then
		
			if MidFireTimer == 1 then
			
				if FirstBeamKillerIndex ~= nil and FirstBeamKillerIndex ~= 0 then
			
					NoticeSend(FirstBeamKillerIndex,1,"You have failed to kill both Fire Beam Knights at the same time.")
					
					local MessageText = string.format("%s failed to kill both Fire Beam Knights. Try again tomorrow!",GetObjectName(FirstBeamKillerIndex))
						
					NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
					
				end
	
				FirstBeamKnightIndex = nil

				FirstBeamKnightMap = nil

				FirstBeamKnightMapX = nil

				FirstBeamKnightMapY = nil

				FirstBeamKillerIndex = nil
			
			end
			
			MidFireTimer = MidFireTimer-1
		
		end
	
	end

end

------------------------- Fire Festival Bosses---------------------