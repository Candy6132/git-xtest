MonsterAbilities_SystemSwitch = 1

IceQueen = 25

HellSpider = 13

MonsterAbilities_MonsterTable = {}






MonsterAbilities_NumberOfMonstersSpawned = {}

MonsterAbilities_MonsterSpawnIndex = {}

MonsterAbilities_NumberOfMonstersSpawned[IceQueen] = 4

MonsterAbilities_NumberOfMonstersSpawned[HellSpider] = 5

MonsterAbilities_MonsterSpawnIndex[IceQueen] = 22

MonsterAbilities_MonsterSpawnIndex[HellSpider] = 3



ScriptLoader_AddOnReadScript("MonsterAbilities_OnReadScript")

ScriptLoader_AddOnMonsterDie("MonsterAbilities_OnMonsterDie")



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
	
		for i=1,#MonsterAbilities_MonsterTable,1 do
		
			local LordClass = MonsterAbilities_MonsterTable[i].LordClass

			if GetObjectClass(aIndex) == LordClass then MonsterAbilities_SpawnMonster(aIndex,LordClass) end

		end
	
	end

end

function MonsterAbilities_SpawnMonster(aIndex,bClass)

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