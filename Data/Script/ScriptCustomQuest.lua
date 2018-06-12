CustomQuest_QuestList = {}

CustomQuest_QuestStatusTable = {}

CustomQuest_CharacterIndexes = {}

CustomQuest_TableLength = 0

ScriptLoader_AddOnReadScript("CustomQuest_OnReadScript")

ScriptLoader_AddOnCommandManager("CustomQuest_OnCommandManager")

ScriptLoader_AddOnNpcTalk("CustomQuest_OnNpcTalk")

ScriptLoader_AddOnMonsterDie("CustomQuest_OnMonsterDie")

ScriptLoader_AddOnCharacterEntry("CustomQuest_OnCharacterEntry")

ScriptLoader_AddOnCharacterClose("CustomQuest_OnCharacterClose")


function CustomQuest_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	
	CustomQuest_SystemSwitch = ConfigReadNumber("CustomQuestInfo","SystemSwitch","..\\Data\\Script\\Data\\CustomQuest.ini")
	
	CustomQuest_NPCNumber = ConfigReadNumber("CustomQuestInfo","QuestNPC","..\\Data\\Script\\Data\\CustomQuest.ini")
	
	CustomQuest_NPCName = ConfigReadString("CustomQuestInfo","NPCName","..\\Data\\Script\\Data\\CustomQuest.ini")
	

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
			
			CustomQuest_QuestListRow["MonsterFEIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["MonsterFEString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["MonsterSUIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["MonsterSUString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["NoItem"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemLevel"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemString"] = tostring(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemDropIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemDropLevel"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemDropRate"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ExpReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["PointReward"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemRewardIndex"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1
			
			CustomQuest_QuestListRow["ItemRewardLevel"] = tonumber(ReadTable[ReadCount])

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
	
		for n=1,CustomQuest_TableLength,1 do
		
		--for n=1,#CustomQuest_QuestStatusTable,1 do
		
			local CharacterName = CustomQuest_QuestStatusTable[n].Name
		
			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
			
			local QuestStatus = CustomQuest_QuestStatusTable[n].QuestStatus
			
			local MonsterCount = CustomQuest_QuestStatusTable[n].MonsterCount
			
			if CharacterName == nil then CharacterName = "nil" end
			
			if CharacterIndex == nil then CharacterIndex = "-1" end
			
			if QuestStatus == nil then QuestStatus = "-1" end
			
			if MonsterCount == nil then MonsterCount = "-1" end
			
			NoticeSend(aIndex,1,string.format("#%d: %s %d %d",CharacterIndex,CharacterName,QuestStatus,MonsterCount))
			
		end
		
		NoticeSend(aIndex,1,string.format("--------------------"))
		
		NoticeSend(aIndex,1,string.format("CustomQuest_TableLength=%d, #CustomQuest_QuestStatusTable=%d",CustomQuest_TableLength,#CustomQuest_QuestStatusTable))
		
	end

end

--Status = 0 - quest nie rozpoczety
--Status = 1 - quest rozpoczety


function CustomQuest_OnCharacterEntry(aIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)

		if CustomQuest_AddCharToTable(CharacterName) == 1 then
			
			NoticeSend(aIndex,1,CustomQuest_GetQuestMessage(aIndex,CharacterName))
			
		else
			
			NoticeSend(aIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
		end
	
	end

end


function CustomQuest_OnCharacterClose(aIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		CustomQuest_RemoveCharFromTable(GetObjectName(aIndex))
		
	end

end


function CustomQuest_OnNpcTalk(aIndex,bIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		if GetObjectClass(aIndex) == CustomQuest_NPCNumber then
		
			NoticeSend(bIndex,1,string.format("Guardian: I'll help you, %s.",GetObjectName(bIndex)))
			
			-----------------------------------------------------------------------------------------------------------
			
			
			
			-----------------------------------------------------------------------------------------------------------
	
		end
		
	end
	
	return 0

end


function CustomQuest_OnMonsterDie(aIndex,bIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(bIndex)
		
		if CustomQuest_AddCharToTable(CharacterName) == 1 then

			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
		
			local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 10
			
			local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 10
			
			if PartialQuestStatus ~= 0 and MainQuestStatus <= #CustomQuest_QuestList-1 then
			
				local CharacterClass = GetObjectClass(bIndex)
		
				local MonsterSUString = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUString
		
				local MonsterFEString = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEString
		
				local MonsterClass = ""

				local MonsterName = ""
		
				if CharacterClass == 81 and MonsterSUString ~= nil then
		
					MonsterClass = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUIndex
			
					MonsterName = MonsterSUString
			
				elseif CharacterClass == 32 and MonsterFEString ~= nil then
		
					MonsterClass = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEIndex
			
					MonsterName = MonsterFEString
			
				else
			
					MonsterClass = CustomQuest_QuestList[MainQuestStatus+1].MonsterIndex
			
					MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterString
			
				end
		
				if GetObjectClass(aIndex) == MonsterClass then
				
					local ItemDropRate = CustomQuest_QuestList[MainQuestStatus+1].ItemDropRate

					if ItemDropRate > 0 and ItemDropRate <= 100 then

						if math.random(99)+1 <= ItemDropRate then
						
							local ItemDropIndex = CustomQuest_QuestList[MainQuestStatus+1].ItemDropIndex
							
							local ItemDropLevel = CustomQuest_QuestList[MainQuestStatus+1].ItemDropLevel
						
							ItemDropEx(bIndex,GetObjectMap(aIndex),GetObjectMapX(aIndex),GetObjectMapY(aIndex),ItemDropIndex,ItemDropLevel,0,0,0,0,0)
						
						end
						
					else
					
						local MonsterCount = CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount

						if MonsterCount < CustomQuest_QuestList[MainQuestStatus+1].NoMonsters then
						
							MonsterCount = MonsterCount+1
							
							CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount = MonsterCount
							
							if MonsterCount % 10 == 0 then
							
								--Zapis do bazy
								
							end
					
						end
					
						NoticeSend(bIndex,1,CustomQuest_GetQuestMessage(bIndex,CharacterName))
					
					end
						
				
				end
	
			end
		
		else
			
			--NoticeSend(bIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
		end
		
	end
	
end


function CustomQuest_GetQuestMessage(aIndex,bName)

	local CharacterIndex = CustomQuest_CharacterIndexes[bName]
	
	local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 10
	
	local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 10
	
	local NoticeText
			
	if MainQuestStatus <= #CustomQuest_QuestList-1 then
			
		if PartialQuestStatus == 0 then
			
			NoticeText = string.format("[Quest #%d] Meet %s to obtain new quest.",MainQuestStatus+1,CustomQuest_NPCName)
				
		else
				
			NoticeText = string.format("[Quest #%d]",MainQuestStatus+1)
					
			local NoMonsters = CustomQuest_QuestList[MainQuestStatus+1].NoMonsters
					
			local MonsterName
			
			local MonstersComplete = 0
			
			local ItemsComplete = 0

			if NoMonsters ~= nil then
					
				local MonsterSUString = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUString
						
				local MonsterFEString = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEString
					
				if GetObjectClass(aIndex) == 81 and MonsterSUString ~= nil then
			
					MonsterName = MonsterSUString
					
				elseif GetObjectClass(aIndex) == 32 and MonsterFEString ~= nil then
						
					MonsterName = MonsterFEString
							
				else
							
					MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterString
			
				end
					
				local MonsterCount = CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount
						
				NoticeText = NoticeText..(string.format(" [%d/%d %s killed]",MonsterCount,NoMonsters,MonsterName))
				
				if MonsterCount >= NoMonsters then MonstersComplete = 1 end
				
			end
					
			local ItemIndex = CustomQuest_QuestList[MainQuestStatus+1].ItemIndex
					
			local NoItem = CustomQuest_QuestList[MainQuestStatus+1].NoItem
					
			local ItemLevel = CustomQuest_QuestList[MainQuestStatus+1].ItemLevel
					
			if ItemIndex ~= nil and ItemLevel ~= nil and NoItem > 0 then
					
				local NoItemCollected = InventoryGetItemCount(aIndex,ItemIndex,ItemLevel)
						
				local ItemString = CustomQuest_QuestList[MainQuestStatus+1].ItemString

				NoticeText = NoticeText..(string.format(" [%d/%d %s collected]",NoItemCollected,NoItem,ItemString))
				
				if NoItemCollected >= NoItem then ItemsComplete = 1 end
				
			end
				
			if MonstersComplete == 1 and ItemsComplete == 1 then
			
				NoticeText = NoticeText..(string.format(" Talk with %s to complete your quest.",CustomQuest_NPCName))
			
			end	
				
		end

	end

	return NoticeText
	
end


function CustomQuest_AddCharToTable(aName)

	--Ladowanie Quest Status postaci jesli jej nie ma w tabeli:
			
	local CharacterIndex = CustomQuest_CharacterIndexes[aName]
			
	if CharacterIndex == nil or CharacterIndex == -1 then
		
		if SQLQuery(string.format("SELECT * FROM Character WHERE Name='%s'",aName)) == 0 or SQLFetch() == 0 then

			SQLClose()
			
			if SQLCheck() == 0 then
			
				local SQL_ODBC = "MuOnline"

				local SQL_USER = ""

				local SQL_PASS = ""

				SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
			end
			
			return 0

		else

			CustomQuest_QuestStatusTableRow = {}
			
			CustomQuest_QuestStatusTableRow["Name"] = aName
			
			CustomQuest_QuestStatusTableRow["QuestStatus"] = SQLGetNumber("CustomQuest")
			
			CustomQuest_QuestStatusTableRow["MonsterCount"] = SQLGetNumber("CQMonsterCount")
			
			SQLClose()
			
			table.insert(CustomQuest_QuestStatusTable,CustomQuest_QuestStatusTableRow)
			
			CustomQuest_TableLength = CustomQuest_TableLength+1
			
			CustomQuest_CharacterIndexes[aName] = CustomQuest_TableLength
		
			return 1
			
		end
	
	else
	
		return 1
		
	end

end


function CustomQuest_RemoveCharFromTable(aName)
	
	local CharacterIndex = CustomQuest_CharacterIndexes[aName]
			
	if CharacterIndex ~= nil and CharacterIndex ~= -1 then
	
		local QuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus
		
		local MonsterCount = CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount
		
		local QueryStatus1 = SQLQuery(string.format("UPDATE Character SET CustomQuest=%d WHERE Name='%s'",QuestStatus,aName))

		SQLClose()
		
		if QueryStatus1 == 0 then
			
			LogPrint(string.format("CustomQuestScript: SQLQuery failed to save QuestStatus for %s, CharacterIndex=%d, QuestStatus=%d, MonsterCount=%d",aName,CharacterIndex,QuestStatus,MonsterCount))

			LogColor(1,string.format("CustomQuestScript: SQLQuery failed to save QuestStatus for %s!",aName))
			
			if SQLCheck() == 0 then
			
				local SQL_ODBC = "MuOnline"

				local SQL_USER = ""

				local SQL_PASS = ""

				SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
			end
			
		end
		
		local QueryStatus2 = SQLQuery(string.format("UPDATE Character SET CQMonsterCount=%d WHERE Name='%s'",MonsterCount,aName))
		
		SQLClose()
		
		if QueryStatus2 == 0 then
			
			LogPrint(string.format("CustomQuestScript: SQLQuery failed to save MonsterCount for %s, CharacterIndex=%d, QuestStatus=%d, MonsterCount=%d",aName,CharacterIndex,QuestStatus,MonsterCount))

			LogColor(1,string.format("CustomQuestScript: SQLQuery failed to save MonsterCount for %s!",aName))
			
			if SQLCheck() == 0 then
			
				local SQL_ODBC = "MuOnline"

				local SQL_USER = ""

				local SQL_PASS = ""

				SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
			end
			
		end
		
		--NIE DZIALA KURLA:
		
		--if QueryStatus1 == 1 and QueryStatus2 == 1 then
			
			--CustomQuest_TableLength = CustomQuest_TableLength-1
			
			--table.remove(CustomQuest_QuestStatusTable,CharacterIndex)
				
			--CustomQuest_CharacterIndexes[aName] = -1

			--NoticeSend(GetObjectIndexByName("Candy"),1,string.format("new index=%d",CustomQuest_CharacterIndexes[aName]))
			
			--if CharacterIndex <= CustomQuest_TableLength then
			
				--for n=CharacterIndex,CustomQuest_TableLength,1 do
				
					--local CharacterName = CustomQuest_QuestStatusTable[n+1].Name
				
					--CustomQuest_QuestStatusTable[n].Name = CharacterName
					
					--CustomQuest_QuestStatusTable[n].QuestStatus = CustomQuest_QuestStatusTable[n+1].QuestStatus
					
					--CustomQuest_QuestStatusTable[n].MonsterCount = CustomQuest_QuestStatusTable[n+1].MonsterCount
					
					--CustomQuest_CharacterIndexes[CharacterName] = n
				
				--end

				--table.remove(CustomQuest_QuestStatusTable,CustomQuest_TableLength+1)

			--end
			
		--end
	
	end

end