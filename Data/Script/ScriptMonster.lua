MonsterPassiveAbilitiesTable = {}

MonsterActiveAbilitiesTable = {}

LifespanTable = {}

Monster_ActiveTable = {}


ScriptLoader_AddOnReadScript("OnReadScript")

ScriptLoader_AddOnTimerThread("OnTimerLifespan")


function OnReadScript()

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

			MonsterTableRow["PMonsterSpawn"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1

			MonsterTableRow["PNoMonsters"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1

			MonsterTableRow["PSpawnChance"] = tonumber(ReadPassiveTable[ReadCount])

			ReadCount = ReadCount+1
			
			table.insert(MonsterPassiveAbilitiesTable,MonsterTableRow)
	
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

			table.insert(MonsterActiveAbilitiesTable,MonsterTableRow)
	
		end

	end

	math.randomseed(os.time())

end


function OnTimerLifespan()

	if #LifespanTable > 0 then
	
		for n=1,#LifespanTable,1 do
		
			local LifespanTime = LifespanTable[n].Timer
		
			if LifespanTime == 0 then

				MonsterDelete(LifespanTable[n].Index)
			
				table.remove(LifespanTable,n)

			else
			
				LifespanTable[n].Timer = LifespanTime - 1
			
			end
		
		end
	
	end

end


--Passive abilities are abilities called when monster dies.
--Active abilities are abilities called while monster is fighting.

	
function Monster_CallPassiveAbilities(aIndex)
--The monster performs all passive abilities

end


function Monster_CallActiveAbilities(aIndex)
--The monster performs all active abilities

end


function Monster_Spawn(aClass,bMap,cMapX,dMapY,eTurn,dTime)

	local MonsterIndex = MonsterCreate(aClass,bMap,cMapX,dMapY,eTurn)

	if dTime ~= nil and dTime > 0 then
	
		local LifespanTableRow = {}
		
		LifespanTableRow["Index"] = MonsterIndex
		
		LifespanTableRow["Timer"] = dTime
	
		table.insert(LifespanTable,LifespanTableRow)

	end

	return MonsterIndex
	
end