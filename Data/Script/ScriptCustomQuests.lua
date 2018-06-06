CustomQuests_QuestList = {}

CustomQuests_QuestStatusTable = {}

CustomQuests_CharacterIndexes = {}

--QuestStatus = 1

--MonsterCount = 2

ScriptLoader_AddOnReadScript("CustomQuests_OnReadScript")

ScriptLoader_AddOnNpcTalk("CustomQuests_OnNpcTalk")

ScriptLoader_AddOnCharacterEntry("CustomQuests_OnCharacterEntry")

ScriptLoader_AddOnCharacterClose("CustomQuests_OnCharacterClose")


function CustomQuests_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	
	CustomQuests_SystemSwitch = ConfigReadNumber("CustomQuestInfo","SystemSwitch","..\\Data\\Script\\Data\\CustomQuest.ini")
	
	
	local ReadTable = FileLoad("..\\Data\\Script\\Data\\CustomQuests.txt")

	if ReadTable == nil then return end

	local ReadCount = 1

	while ReadCount < #ReadTable do

		if ReadTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			CustomQuests_QuestListRow = {}

			CustomQuests_QuestListRow["ReqLevel"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuests_QuestListRow["ReqReset"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuests_QuestListRow["ReqMReset"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuests_QuestListRow["NoMonsters"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomQuests_QuestListRow["MonsterIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["MonsterString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["NoItem"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["ItemIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["ItemString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["ExpReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["PointReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["EventItemBagSpecialValue"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuests_QuestListRow["QuestStartMessage"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			table.insert(CustomQuests_QuestList,CustomQuests_QuestListRow)

		end

	end

	math.randomseed(os.time())

end

function CustomQuests_OnCharacterEntry(aIndex)

	if CustomQuests_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)

		CustomQuests_AddCharToTable(CharacterName)
		
		
		
		
		
		--if SQLQuery(string.format("SELECT * FROM Character WHERE Name='%s'",CharacterName)) == 0 or SQLFetch() == 0 then

			--SQLClose()
			
			--NoticeSend(aIndex,1,"dupa")

		--else

			--CustomQuests_QuestStatusTable[CharacterName].QuestStatus = SQLGetNumber("CustomQuest")
		
			--CustomQuests_QuestStatusTable[CharacterName].MonsterCount = SQLGetNumber("CQMonsterCount")
		
			--SQLClose()
		
			--NoticeSend(aIndex,1,string.format("Your quest status: " + tostring(CustomQuests_QuestStatusTable[CharacterName].QuestStatus)))
		
			--NoticeSend(aIndex,1,string.format("Killed monsters: " + tostring(CustomQuests_QuestStatusTable[CharacterName].QuestStatus)))
		
		--end
	
	end

end


function CustomQuests_OnCharacterClose(aIndex)

end




function CustomQuests_OnNpcTalk(aIndex,bIndex)

	if CustomQuests_SystemSwitch ~= 0 then
	
		if GetObjectClass(aIndex) == 257 then
		
			NoticeSend(bIndex,1,string.format("Guardian: I'll help you, %s.",GetObjectName(bIndex)))
			
			-----------------------------------------------------------------------------------------------------------
			
			local CharacterName = GetObjectName(bIndex)
			
			if CustomQuests_AddCharToTable(CharacterName) == 1 then
			
				NoticeSend(bIndex,1,string.format("Hi, %s. Your quest status is %d, monsters killed: %d",CustomQuests_QuestStatusTable[CustomQuests_CharacterIndexes[CharacterName]].Name,CustomQuests_QuestStatusTable[CustomQuests_CharacterIndexes[CharacterName]].QuestStatus,CustomQuests_QuestStatusTable[CustomQuests_CharacterIndexes[CharacterName]].MonsterCount))
			
			else
			
				NoticeSend(bIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
			end
			
			--if SQLQuery(string.format("SELECT CustomQuest FROM Character WHERE Name='%s'",GetObjectName(bIndex))) == 0 or SQLFetch() == 0 then

			--	SQLClose()
			
			--	NoticeSend(bIndex,1,"dupa")

			--else

				-- TU COS JEST ZJEBANE: CustomQuests_QuestStatusTable[CharacterName].QuestStatus = SQLGetNumber("CustomQuest")
		
				-- TU COS JEST ZJEBANE: CustomQuests_QuestStatusTable[CharacterName].MonsterCount = SQLGetNumber("CQMonsterCount")

			--	local QuestStage = SQLGetNumber("CustomQuest")
				
			--	SQLClose()
			
			--	NoticeSend(bIndex,1,string.format(QuestStage))
				
			--end
	
		end
		
	end
	
	return 0

end

function CustomQuests_AddCharToTable(aName)

	--Ladowanie Quest Status postaci jesli jej nie ma w tabeli
			
	local CharacterIndex = CustomQuests_CharacterIndexes[aName]
			
	if CharacterIndex == nil then
		
		if SQLQuery(string.format("SELECT * FROM Character WHERE Name='%s'",aName)) == 0 or SQLFetch() == 0 then

			SQLClose()
			
			return 0

		else

			CustomQuests_QuestStatusTableRow = {}
			
			CustomQuests_QuestStatusTableRow["Name"] = aName
			
			CustomQuests_QuestStatusTableRow["QuestStatus"] = SQLGetNumber("CustomQuest")
			
			CustomQuests_QuestStatusTableRow["MonsterCount"] = SQLGetNumber("CQMonsterCount")
			
			SQLClose()
			
			table.insert(CustomQuests_QuestStatusTable,CustomQuests_QuestStatusTableRow)
			
			CustomQuests_CharacterIndexes[aName] = #CustomQuests_QuestStatusTable
		
			return 1
			
		end
	
	else
	
		return 1
		
	end

end

function CustomQuests_RemoveCharFromTable(aName)

	--Usuwanie postaci z Tabeli jesli sie wylogowuje
	
	local CharacterIndex = CustomQuests_CharacterIndexes[aName]
			
	if CharacterIndex ~= nil then
		
		--Usuwanie postaci z Tabeli jesli sie wylogowuje
	
	end

end