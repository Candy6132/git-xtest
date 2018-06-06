CustomQuest_QuestList = {}

CustomQuest_QuestStatusTable = {}

CustomQuest_CharacterIndexes = {}

ScriptLoader_AddOnReadScript("CustomQuest_OnReadScript")

ScriptLoader_AddOnCommandManager("CustomQuest_OnCommandManager")

ScriptLoader_AddOnNpcTalk("CustomQuest_OnNpcTalk")

ScriptLoader_AddOnCharacterEntry("CustomQuest_OnCharacterEntry")

ScriptLoader_AddOnCharacterClose("CustomQuest_OnCharacterClose")


function CustomQuest_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	
	CustomQuest_SystemSwitch = ConfigReadNumber("CustomQuestInfo","SystemSwitch","..\\Data\\Script\\Data\\CustomQuest.ini")
	
	CustomQuest_NPCNumber = ConfigReadNumber("CustomQuestInfo","QuestNPC","..\\Data\\Script\\Data\\CustomQuest.ini")
	

	local ReadTable = FileLoad("..\\Data\\Script\\Data\\CustomQuest.txt")

	if ReadTable == nil then return end

	local ReadCount = 1

	while ReadCount < #ReadTable do

		if ReadTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			CustomQuest_QuestListRow = {}

			CustomQuest_QuestListRow["ReqLevel"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuest_QuestListRow["ReqReset"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuest_QuestListRow["ReqMReset"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuest_QuestListRow["NoMonsters"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuest_QuestListRow["MonsterIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["MonsterString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["NoItem"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ExpReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["PointReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["EventItemBagSpecialValue"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["QuestStartMessage"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			table.insert(CustomQuest_QuestList,CustomQuest_QuestListRow)

		end

	end

	math.randomseed(os.time())

end


function CustomQuest_OnCommandManager(aIndex,code,arg)

	if code == 201 then

		CustomQuest_CheckTableCommand(aIndex)
		
		return 1
	
	end
	
	return 0
	
end


function CustomQuest_CheckTableCommand(aIndex)

	if GetObjectAuthority(aIndex) == 32 then
	
		NoticeSend(aIndex,1,string.format("Current Quest Table:"))
		
		NoticeSend(aIndex,1,string.format("--------------------"))
	
		for n=1,#CustomQuest_QuestStatusTable,1 do
		
			local CharacterName = CustomQuest_QuestStatusTable[n].Name
		
			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
			
			NoticeSend(aIndex,1,string.format("#%d: %s %d %d",CharacterIndex,CharacterName,CustomQuest_QuestStatusTable[n].QuestStatus,CustomQuest_QuestStatusTable[n].MonsterCount))
			
		end
		
		NoticeSend(aIndex,1,string.format("--------------------"))
		
	end

end

--Status = 0 - quest nie rozpoczety
--Status = 1 - quest rozpoczety
--Status = 2 - quest zakonczony


function CustomQuest_OnCharacterEntry(aIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)

		if CustomQuest_AddCharToTable(CharacterName) == 1 then
		
			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
			
			local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 10
			
			local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 10

			--NoticeSend(bIndex,1,string.format(PartialQuestStatus))
				
			--NoticeSend(bIndex,1,string.format(MainQuestStatus))
			
			NoticeSend(aIndex,1,string.format("[Quest #%d] Killed monsters: %d/?",MainQuestStatus,CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount))
			
		else
			
			NoticeSend(aIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
		end
	
	end

end


function CustomQuest_OnCharacterClose(aIndex)

end


function CustomQuest_OnNpcTalk(aIndex,bIndex)

	if CustomQuest_SystemSwitch ~= 0 then
	
		if GetObjectClass(aIndex) == CustomQuest_NPCNumber then
		
			NoticeSend(bIndex,1,string.format("Guardian: I'll help you, %s.",GetObjectName(bIndex)))
			
			-----------------------------------------------------------------------------------------------------------
			
			local CharacterName = GetObjectName(bIndex)
			
			if CustomQuest_AddCharToTable(CharacterName) == 1 then
			
				local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
			
				local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 10
			
				local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 10

				--NoticeSend(bIndex,1,string.format(PartialQuestStatus))
				
				--NoticeSend(bIndex,1,string.format(MainQuestStatus))
			
				NoticeSend(bIndex,1,string.format("Hi, %s. Your quest status is %d, monsters killed: %d",CustomQuest_QuestStatusTable[CharacterIndex].Name,MainQuestStatus,CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount))
			
			else
			
				NoticeSend(bIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
			end
			
			-----------------------------------------------------------------------------------------------------------
	
		end
		
	end
	
	return 0

end


function CustomQuest_AddCharToTable(aName)

	--Ladowanie Quest Status postaci jesli jej nie ma w tabeli
			
	local CharacterIndex = CustomQuest_CharacterIndexes[aName]
			
	if CharacterIndex == nil then
		
		if SQLQuery(string.format("SELECT * FROM Character WHERE Name='%s'",aName)) == 0 or SQLFetch() == 0 then

			SQLClose()
			
			return 0

		else

			CustomQuest_QuestStatusTableRow = {}
			
			CustomQuest_QuestStatusTableRow["Name"] = aName
			
			CustomQuest_QuestStatusTableRow["QuestStatus"] = SQLGetNumber("CustomQuest")
			
			CustomQuest_QuestStatusTableRow["MonsterCount"] = SQLGetNumber("CQMonsterCount")
			
			SQLClose()
			
			table.insert(CustomQuest_QuestStatusTable,CustomQuest_QuestStatusTableRow)
			
			CustomQuest_CharacterIndexes[aName] = #CustomQuest_QuestStatusTable
		
			return 1
			
		end
	
	else
	
		return 1
		
	end

end


function CustomQuest_RemoveCharFromTable(aName)

	--Usuwanie postaci z Tabeli jesli sie wylogowuje
	
	local CharacterIndex = CustomQuest_CharacterIndexes[aName]
			
	if CharacterIndex ~= nil then
		
		--Usuwanie postaci z Tabeli jesli sie wylogowuje
	
	end

end