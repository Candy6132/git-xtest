Monster_MonsterPassiveAbilitiesTable = {}

Monster_MonsterActiveAbilitiesTable = {}

Monster_LifespanTable = {}

Monster_ActiveTable = {}


ScriptLoader_AddOnReadScript("Monster_OnReadScript")

ScriptLoader_AddOnTimerThread("Monster_OnTimerLifespan")


function Monster_OnReadScript()

	local ReadPassiveTable = FileLoad("..\\Data\\Script\\Data\\MonsterPassiveAbilities.txt")
	
	local ReadActiveTable = FileLoad("..\\Data\\Script\\Data\\MonsterActiveAbilities.txt")

	if ReadPassiveTable == nil or ReadActiveTable == nil then return end

	local ReadCount = 1

	while ReadCount < #ReadPassiveTable do

		if ReadPassiveTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			local MonsterTableRow = {}
	
			MonsterTableRow["LordClass"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1

			MonsterTableRow["PSpawnClass"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1

			MonsterTableRow["PNoMonsters"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1

			MonsterTableRow["PSpawnChance"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1
			
			MonsterTableRow["Effect"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1
			
			MonsterTableRow["EffectTime"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1
			
			MonsterTableRow["EffectChance"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1
			
			table.insert(Monster_MonsterPassiveAbilitiesTable,MonsterTableRow)
	
		end

	end
	
	ReadCount = 1

	while ReadCount < #ReadActiveTable do

		if ReadActiveTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			local MonsterTableRow = {}
	
			MonsterTableRow["LordClass"] = tonumber(ReadActiveTable[ReadCount])

			ReadCount = ReadCount+1

			table.insert(Monster_MonsterActiveAbilitiesTable,MonsterTableRow)
	
		end

	end

	math.randomseed(os.time())

end


function Monster_OnTimerLifespan()

	local LifespanTableLength = #Monster_LifespanTable

	if LifespanTableLength > 0 then
	
		for n=1,LifespanTableLength,1 do
		
			local LifespanTime = Monster_LifespanTable[n].Timer
		
			if LifespanTime == 0 then

				MonsterDelete(Monster_LifespanTable[n].Index)
			
				table.remove(Monster_LifespanTable,n)

			else
			
				Monster_LifespanTable[n].Timer = LifespanTime - 1
			
			end
		
		end
	
	end

end


--Passive abilities are abilities called when monster dies.
--Active abilities are abilities called while monster is fighting.

	
function Monster_CallPassiveAbilities(aMonster,bKiller)
--The monster performs all passive abilities

	if #Monster_MonsterPassiveAbilitiesTable > 0 then

		for n=1,#Monster_MonsterPassiveAbilitiesTable,1 do
		
			local LordClass = Monster_MonsterPassiveAbilitiesTable[n].LordClass
		
			if LordClass == GetObjectClass(aMonster) then
			
				local SpawnClass = Monster_MonsterPassiveAbilitiesTable[n].PSpawnClass
				
				local NoMonsters = Monster_MonsterPassiveAbilitiesTable[n].PNoMonsters

				if SpawnClass ~= nil and NoMonsters ~= nil and NoMonsters > 0 then
				
					local MonsterMap = GetObjectMap(aMonster)
					
					local MonsterMapX = GetObjectMapX(aMonster)
					
					local MonsterMapY = GetObjectMapY(aMonster)
				
					local SpawnChance = Monster_MonsterPassiveAbilitiesTable[n].PSpawnChance
					
					if SpawnChance == nil or SpawnChance == 10000 then
					
						for i=1,NoMonsters,1 do
					
							Monster_Spawn(SpawnClass,MonsterMap,MonsterMapX,MonsterMapY,-1,60)
							
						end

					else
					
						if math.random(9999)+1 <= SpawnChance then
						
							for i=1,NoMonsters,1 do
					
								Monster_Spawn(SpawnClass,MonsterMap,MonsterMapX,MonsterMapY,-1,60)
							
							end
						
						end
					
					end

				end
				
				local Effect = Monster_MonsterPassiveAbilitiesTable[n].Effect
				
				if Effect ~= nil then
				
					local EffectChance = Monster_MonsterPassiveAbilitiesTable[n].EffectChance
					
					local EffectTime = Monster_MonsterPassiveAbilitiesTable[n].EffectTime
					
					if EffectTime == nil or EffectTime == 0 then EffectTime = 5 end
					
					if EffectChance == nil or EffectChance == 10000 then
					
						EffectAdd(bKiller,0,Effect,EffectTime,0,0,0,0)
					
					else
					
						if math.random(9999)+1 <= EffectChance then
						
							EffectAdd(bKiller,0,Effect,EffectTime,0,0,0,0)
	
						end
					
					end
					
				end
				
				break
			
			end
		
		end
	
	end

end


function Monster_CallActiveAbilities(aIndex)
--The monster performs all active abilities

end


function Monster_Spawn(aClass,bMap,cMapX,dMapY,eTurn,dTime)

	local MonsterIndex = MonsterCreate(aClass,bMap,cMapX,dMapY,eTurn)

	if dTime ~= nil and dTime > 0 then
	
		local LifespanTableRow = {}
		
		LifespanTableRow["Index"] = tonumber(MonsterIndex)
		
		LifespanTableRow["Timer"] = tonumber(dTime)
	
		table.insert(Monster_LifespanTable,LifespanTableRow)

	end

	return MonsterIndex
	
end


function Monster_CheckDistanceBetweenObjects(aIndex,bIndex)

	aMap = GetObjectMap(aIndex)
	
	aMapX = GetObjectMapY(aIndex)
	
	aMapY = GetObjectMapY(aIndex)

	bMap = GetObjectMap(bIndex)
	
	bMapX = GetObjectMapY(bIndex)
	
	bMapY = GetObjectMapY(bIndex)

	if bMap ~= nil and aMap ~= nil and aMap == bMap then
	
		local Distance = tonumber(math.sqrt((aMapX-bMapX)^2+(aMapY-bMapY)^2))
		
		return Distance
	
	else
	
		return -1
	
	end

end


function Monster_FrostBloom(aIndex,bRange,cDuration)

	for nBloom=GetMinUserIndex(),GetMaxUserIndex(),1 do
	
		local nDistance = Monster_CheckDistanceBetweenObjects(aIndex,nBloom)
	
		if nDistance ~= -1 and nDistance <= bRange then
		
			local IndexMap = GetObjectMap(aIndex)
		
			if IndexMap == 58 then
		
				Monster_Spawn(101,GetObjectMap(nBloom),GetObjectMapX(nBloom),GetObjectMapY(nBloom),0,1)
				
			end
		
			EffectAdd(nBloom,0,57,cDuration,0,0,0,0)
			
			EffectAdd(nBloom,0,86,cDuration,0,0,0,0)
			
			local PendantItem = InventoryGetItemIndex(nBloom,9)
				
			local Ring1Item = InventoryGetItemIndex(nBloom,10)
				
			local Ring2Item = InventoryGetItemIndex(nBloom,11)

			if PendantItem ~= 6681 and Ring1Item ~= 6664 and Ring2Item ~= 6664 then
				
				EffectAdd(nBloom,0,61,cDuration,0,0,0,0)
			
			end
		
		end
	
	end

end