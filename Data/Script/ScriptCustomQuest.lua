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
	
	CustomQuest_PartyRange = ConfigReadNumber("CustomQuestInfo","PartyRange","..\\Data\\Script\\Data\\CustomQuest.ini")
		
	
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
			
			CustomQuest_QuestListRow["ZenReward"] = tonumber(ReadTable[ReadCount])

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
			
			CustomQuest_QuestListRow["QuestFinishMessage"] = tonumber(ReadTable[ReadCount])
			
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
	
		if code == 202 then

		CustomQuest_QuestInfoCommand(aIndex)
		
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

function CustomQuest_QuestInfoCommand(aIndex)

	if CustomQuest_SystemSwitch ~= 1 then
	
		NoticeSend(aIndex,1,"Quest System is currently disabled. Please contact the administrator.")
		
	else
	
		local CharacterName = GetObjectName(aIndex)
		
		if CustomQuest_AddCharToTable(CharacterName) == 1 then

			NoticeSend(aIndex,1,CustomQuest_GetQuestMessage(aIndex,CharacterName))
			
			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
		
			local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 2
			
			local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 2
			
			if PartialQuestStatus == 1 then
			
				NoticeSend(aIndex,1,string.format("'%s'",MessageGet(CustomQuest_QuestList[MainQuestStatus+1].QuestStartMessage,GetObjectLang(aIndex))))
			
			end
			
		else
		
			LogPrint(string.format("CustomQuestScript: Failed to load  QuestStatus for %s",CharacterName))

			LogColor(1,string.format("CustomQuestScript: Failed to load  QuestStatus for %s",CharacterName))
			
			NoticeSend(aIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
		end
		
	end

end

--Status = 0 - quest nie rozpoczety
--Status = 1 - quest rozpoczety


function CustomQuest_OnCharacterEntry(aIndex)

	if CustomQuest_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)

		if CustomQuest_AddCharToTable(CharacterName) == 1 then

			NoticeSend(aIndex,1,CustomQuest_GetQuestMessage(aIndex,CharacterName))
			
			local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
		
			local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 2
			
			local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 2
			
			if PartialQuestStatus == 1 then
			
				NoticeSend(aIndex,1,string.format("'%s'",MessageGet(CustomQuest_QuestList[MainQuestStatus+1].QuestStartMessage,GetObjectLang(aIndex))))
			
			end
			
		else
		
			LogPrint(string.format("CustomQuestScript: Failed to load  QuestStatus for %s",CharacterName))

			LogColor(1,string.format("CustomQuestScript: Failed to load  QuestStatus for %s",CharacterName))
			
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
			
			local CharacterName = GetObjectName(bIndex)
		
			if CustomQuest_AddCharToTable(CharacterName) == 1 then
			
				local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
		
				local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 2
			
				local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 2
			
				if MainQuestStatus <= #CustomQuest_QuestList-1 then
								
					if PartialQuestStatus == 0 then
				
						local PlayerLevel = GetObjectLevel(bIndex)
						
						local PlayerReset = GetObjectReset(bIndex)
						
						local PlayerMasterReset = GetObjectMasterReset(bIndex)
						
						local RequiredLevel = CustomQuest_QuestList[MainQuestStatus+1].ReqLevel
						
						local RequiredReset = CustomQuest_QuestList[MainQuestStatus+1].ReqReset
						
						local RequiredMasterReset = CustomQuest_QuestList[MainQuestStatus+1].ReqMReset
						
						if RequiredLevel == nil then RequiredLevel = 0 end
						
						if RequiredReset == nil then RequiredReset = 0 end
						
						if RequiredMasterReset == nil then RequiredMasterReset = 0 end
						
						if PlayerLevel >= RequiredLevel and PlayerReset >= RequiredReset and PlayerMasterReset >= RequiredMasterReset then
						
							PartialQuestStatus = PartialQuestStatus + 1 -- <--  POTRZEBNE????
							
							CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus + 1
							
							local QuestMessageNumber = CustomQuest_QuestList[MainQuestStatus+1].QuestStartMessage
							
							local CharText
						
							if QuestMessageNumber ~= nil then
							
								CharText = MessageGet(QuestMessageNumber,GetObjectLang(bIndex))
								
							else
							
								local NoMonsters = CustomQuest_QuestList[MainQuestStatus+1].NoMonsters
								
								local NoItem = CustomQuest_QuestList[MainQuestStatus+1].NoItem
								
								local MonsterName
								
								local ItemName
								
								local QuestHasMonsters = 0
								
								local QuestHasItem = 0
								
								if NoMonsters ~= nil then

									QuestHasMonsters = 1
									
									local MonsterSUIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUIndex
						
									local MonsterFEIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEIndex
					
									if GetObjectClass(bIndex) == 5 and MonsterSUIndex ~= nil then
			
										MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUString

									elseif GetObjectClass(bIndex) == 2 and MonsterFEIndex ~= nil then
						
										MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEString

									else
							
										MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterString
			
									end
									
								end
								
								if NoItem ~= nil then
								
									ItemName = CustomQuest_QuestList[MainQuestStatus+1].ItemString
									
									QuestHasItem = 1
									
								end
								
								if QuestHasMonsters == 1 and QuestHasItem == 1 then
								
									CharText = string.format("Kill %d %s and collect %d %s.",NoMonsters,MonsterName,NoItem,ItemName)
									
								elseif QuestHasMonsters == 1 then
								
									CharText = string.format("Slay %d %s.",NoMonsters,MonsterName)
									
								elseif QuestHasItem == 1 then
								
									CharText = string.format("Bring me %d %s.",NoItem,ItemName)
			
								end

							end
							
							ChatTargetSend(aIndex,bIndex,CharText)
							
							NoticeSend(bIndex,1,CustomQuest_GetQuestMessage(bIndex,CharacterName))
							
							return 1
							
						else
						
							local CharText
							
							local NoticeText = string.format("[Quest #%d] You need ",MainQuestStatus+1)
							
							if RequiredLevel > 0 then
							
								NoticeText = NoticeText..(string.format("%d level, ",RequiredLevel))
								
							end
							
							if RequiredReset > 0 then
							
								NoticeText = NoticeText..(string.format("%d reset, ",RequiredReset))
							
							end
							
							if RequiredMasterReset > 0 then
							
								NoticeText = NoticeText..(string.format("%d master reset, ",RequiredMasterReset))
							
							end
							
							NoticeText = NoticeText.."to start this quest."
							
							if PlayerMasterReset < RequiredMasterReset then
							
								CharText = string.format("You need at least %d master reset, to start this quest.",RequiredMasterReset)
								
							elseif RequiredReset < RequiredReset then
							
								CharText = string.format("You don't have enough resets. Come back after %d reset!",RequiredReset)
							
							elseif PlayerLevel < RequiredLevel then
							
								CharText = string.format("You're not strong enough! Come back when you'll be %d level.",RequiredLevel)
								
							end
							
							NoticeSend(bIndex,1,NoticeText)
			
							ChatTargetSend(aIndex,bIndex,CharText)
						
						end
				
					else
				
						local NoMonsters = CustomQuest_QuestList[MainQuestStatus+1].NoMonsters
						
						local MonsterCount = CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount
						
						local NoItem = CustomQuest_QuestList[MainQuestStatus+1].NoItem
						
						local NoItemCollected = 0

						local ItemIndex = CustomQuest_QuestList[MainQuestStatus+1].ItemIndex
							
						local ItemLevel = CustomQuest_QuestList[MainQuestStatus+1].ItemLevel
							
						if ItemLevel == nil then ItemLevel = -1 end
						
						if NoItem ~= nil then
						
							NoItemCollected = InventoryGetItemCount(bIndex,ItemIndex,ItemLevel)
							
						end
						
						local CharText
							
						if (NoMonsters ~= nil and MonsterCount >= NoMonsters) or (NoItem ~= nil and NoItemCollected >= NoItem) then

							local QuestMessageNumber = CustomQuest_QuestList[MainQuestStatus+1].QuestFinishMessage

							if QuestMessageNumber ~= nil then

								CharText = MessageGet(QuestMessageNumber,GetObjectLang(bIndex))
								
							else
							
								CharText = string.format("Good job, %s. I hope you will like this reward.",CharacterName)
							
							end
							
							ChatTargetSend(aIndex,bIndex,CharText)
							
							if NoItem ~= nil and NoItemCollected >= NoItem then
								
								InventoryDelItemCount(bIndex,ItemIndex,ItemLevel,NoItem)
							
							end
							
							-------------------------------------------- REWARDS --------------------------------------------
							
							local ItemRewardIndex = CustomQuest_QuestList[MainQuestStatus+1].ItemRewardIndex
							
							if ItemRewardIndex ~= nil then
								
								local ItemRewardLevel = CustomQuest_QuestList[MainQuestStatus+1].ItemRewardLevel
								
								if InventoryCheckSpaceByItem(bIndex,ItemRewardIndex) == 1 then
								
									ItemGiveEx(bIndex,ItemRewardIndex,ItemRewardLevel,0,0,0,0,0)
									
								else
									
									ItemDropEx(bIndex,ItemRewardIndex,ItemRewardLevel,0,0,0,0,0)
									
								end
							
							end
							
							local EventItemBagSpecialValue = CustomQuest_QuestList[MainQuestStatus+1].EventItemBagSpecialValue
							
							if EventItemBagSpecialValue ~= nil then
							
								ItemDrop(bIndex,GetObjectMap(bIndex),GetObjectMapX(bIndex),GetObjectMapY(bIndex),EventItemBagSpecialValue)
								
								--ItemGive(bIndex,EventItemBagSpecialValue) - NIE DZIAŁa
							
							end
							
							local ZenReward = CustomQuest_QuestList[MainQuestStatus+1].ZenReward
							
							if ZenReward ~= nil then
							
								local CharacterZen = GetObjectMoney(bIndex)
							
								SetObjectMoney(bIndex,CharacterZen+ZenReward*100)
								
								MoneySend(bIndex,CharacterZen+ZenReward*100)   -- TEST
								
								UserCalcAttribute(bIndex)
								
								UserInfoSend(bIndex)
								
								NoticeSend(bIndex,1,string.format("You've been granted with %d Zen.",ZenReward*100))
							
							end
							
							local PointReward = CustomQuest_QuestList[MainQuestStatus+1].PointReward
							
							if PointReward ~= nil then
							
								local LevelUpPoint = GetObjectLevelUpPoint(bIndex)
								
								SetObjectLevelUpPoint(bIndex,LevelUpPoint+PointReward)
								
								UserCalcAttribute(bIndex)
								
								UserInfoSend(bIndex)
								
								LevelUpSend(bIndex)
								
								NoticeSend(bIndex,1,string.format("You've been granted with %d Level Up Points.",PointReward))
							
							end

							--aIndex = User index.
 
							--Update the user level at the client.
							
							-------------------------------------------------------------------------------------------------

							MainQuestStatus = MainQuestStatus + 1
							
							CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus + 1
							
							CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount = 0
							
							if SQLQuery(string.format("UPDATE Character SET CQMonsterCount=%d WHERE Name='%s'",MonsterCount,CharacterName)) == 0 or SQLQuery(string.format("UPDATE Character SET CustomQuest=%d WHERE Name='%s'",MainQuestStatus*2,CharacterName)) == 0 then
								
								if SQLCheck() == 0 then
			
									local SQL_ODBC = "MuOnline"

									local SQL_USER = ""

									local SQL_PASS = ""

									SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
								end
								
								LogPrint(string.format("CustomQuestScript: Failed to save Custom Quest for %s",CharacterName))

								LogColor(1,string.format("CustomQuestScript: Failed to save Custom Quest for %s",CharacterName))
								
							end

							SQLClose()

							NoticeSend(bIndex,1,string.format("[Quest #%d] Speak with %s to obtain new quest.",MainQuestStatus+1,CustomQuest_NPCName))
							
							return 1
						
						else
						
							local RandomTalk = {}
							
							RandomTalk[1] = "Hey, not so easy. Have you finished your task yet?"
							
							RandomTalk[2] = "Come back when you have your quest finished."
							
							RandomTalk[3] = "Have you finished that quest I gave you?"
							
							RandomTalk[4] = string.format("I'm still waiting for that job beeing done, %s.",CharacterName)
							
							CharText = RandomTalk[math.random(#RandomTalk)]
		
							NoticeSend(bIndex,1,CustomQuest_GetQuestMessage(bIndex,CharacterName))
							
							ChatTargetSend(aIndex,bIndex,CharText)

						end

					end
				
				else
				
					ChatTargetSend(aIndex,bIndex,"You've finished all my quests. Come back later.")
					
					NoticeSend(bIndex,1,"Custom Quest: You have finished all quests. Congratulations!")
				
				end
			
			else
			
			--NoticeSend(bIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
			end
	
		
		
		--WRZUCIĆ BLOKADĘ WYSKAKUJĄCEGO OKNA DLA ELF SOLIDER (IsNPCShadowPhantomSoldier)
		
		--local local ElfBufferMaxLevel_AL0 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxLevel_AL0","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxLevel_AL1 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxLevel_AL1","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxLevel_AL2 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxLevel_AL2","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxLevel_AL3 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxLevel_AL3","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxReset_AL0 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxReset_AL0","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxReset_AL1 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxReset_AL1","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxReset_AL2 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxReset_AL2","..\\Data\\Script\\Data\\CustomQuest.ini")
	
		--local ElfBufferMaxReset_AL3 = ConfigReadNumber("CustomQuestInfo","ElfBufferMaxReset_AL3","..\\Data\\Script\\Data\\CustomQuest.ini")
		
		end
		
	end
	
	return 0

end


function CustomQuest_OnMonsterDie(aIndex,bIndex)

	if CustomQuest_SystemSwitch == 1 then

		local PartyIndex = GetObjectPartyNumber(bIndex)

		if PartyIndex == -1 or PartyIndex == nil then
		
			CustomQuest_UpdateQuest(aIndex,bIndex,bIndex)
			
		else

			for n=0,PartyGetMemberCount(PartyIndex)-1,1 do
			
				CustomQuest_UpdateQuest(aIndex,bIndex,PartyGetMemberIndex(PartyIndex,n))
			
			end
			
		end
		
	end
	
end


function CustomQuest_UpdateQuest(MonsterIndex,KillerIndex,ParticipantIndex)
		
	local MonsterMap = GetObjectMap(MonsterIndex)
		
	local MonsterMapX = GetObjectMapX(MonsterIndex)
		
	local MonsterMapY = GetObjectMapY(MonsterIndex)
	
	local ParticipantMap = GetObjectMap(ParticipantIndex)
		
	local ParticipantMapX = GetObjectMapX(ParticipantIndex)
		
	local ParticipantMapY = GetObjectMapY(ParticipantIndex)
	
	if MonsterMap == ParticipantMap then
	
		if ParticipantMapX > MonsterMapX-CustomQuest_PartyRange and ParticipantMapX < MonsterMapX+CustomQuest_PartyRange then
		
			if ParticipantMapY > MonsterMapY-CustomQuest_PartyRange and ParticipantMapY < MonsterMapY+CustomQuest_PartyRange then
			
				local CharacterName = GetObjectName(ParticipantIndex)
		
				if CustomQuest_AddCharToTable(CharacterName) == 1 then

					local CharacterIndex = CustomQuest_CharacterIndexes[CharacterName]
		
					local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 2
			
					local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 2
			
					if PartialQuestStatus ~= 0 and MainQuestStatus <= #CustomQuest_QuestList-1 then
			
						local CharacterClass = GetObjectClass(ParticipantIndex)
		
						local MonsterSUIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUIndex
		
						local MonsterFEIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEIndex
		
						local MonsterClass = ""

						local MonsterName = ""
		
						if CharacterClass == 5 and MonsterSUIndex ~= nil then
		
							MonsterClass = MonsterSUIndex
					
							MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUString
			
						elseif CharacterClass == 2 and MonsterFEIndex ~= nil then
		
							MonsterClass = MonsterFEIndex
			
							MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEString
			
						else
			
							MonsterClass = CustomQuest_QuestList[MainQuestStatus+1].MonsterIndex
			
							MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterString
			
						end
						
						--[SPECIAL QUEST] - BROKEN CHAOS WEAPON:
						
						if GetObjectClass(MonsterIndex) == 9 and KillerIndex == ParticipantIndex and PartialQuestStatus == 1 and CustomQuest_QuestList[MainQuestStatus+1].ItemString == "Broken Chaos Weapon" then
						
							if math.random(99)+1 <= 3 then
							
								MonsterCreate(88,MonsterMap,MonsterMapX,MonsterMapY,0)

							end
							
						end
						
						--[/SPECIAL QUEST]
		
						if GetObjectClass(MonsterIndex) == MonsterClass then
				
							local ItemDropRate = CustomQuest_QuestList[MainQuestStatus+1].ItemDropRate
	
							if ItemDropRate ~= nil and KillerIndex == ParticipantIndex then
					
								if math.random(99)+1 <= ItemDropRate then
						
									local ItemDropIndex = CustomQuest_QuestList[MainQuestStatus+1].ItemDropIndex
							
									local ItemDropLevel = CustomQuest_QuestList[MainQuestStatus+1].ItemDropLevel
						
									ItemDropEx(ParticipantIndex,GetObjectMap(MonsterIndex),GetObjectMapX(MonsterIndex),GetObjectMapY(MonsterIndex),ItemDropIndex,ItemDropLevel,0,0,0,0,0)
						
								end

							end
					
							local MonsterCount = CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount

							if MonsterCount < CustomQuest_QuestList[MainQuestStatus+1].NoMonsters then
						
								MonsterCount = MonsterCount+1
							
								CustomQuest_QuestStatusTable[CharacterIndex].MonsterCount = MonsterCount
							
								if MonsterCount % 10 == 0 then
							
									if SQLQuery(string.format("UPDATE Character SET CQMonsterCount=%d WHERE Name='%s'",MonsterCount,CharacterName)) == 0 then
								
										if SQLCheck() == 0 then
			
											local SQL_ODBC = "MuOnline"

											local SQL_USER = ""

											local SQL_PASS = ""

											SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
										end
								
										LogPrint(string.format("CustomQuestScript: Failed to save MonsterCount for %s",CharacterName))

										LogColor(1,string.format("CustomQuestScript: Failed to save MonsterCount for %s",CharacterName))
								
									end

									SQLClose()
								
								end
					
							end
					
							NoticeSend(ParticipantIndex,1,CustomQuest_GetQuestMessage(ParticipantIndex,CharacterName))

						end
	
					end
		
				else
			
					--NoticeSend(ParticipantIndex,1,"Your quests are currently unavailable. Please contact the administrator.")
			
				end
			
			end
		
		end
	
	end
	
end


function CustomQuest_GetQuestMessage(aIndex,bName)

	local CharacterIndex = CustomQuest_CharacterIndexes[bName]
	
	local PartialQuestStatus = CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus % 2
	
	local MainQuestStatus = (CustomQuest_QuestStatusTable[CharacterIndex].QuestStatus - PartialQuestStatus) / 2
	
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
					
				local MonsterSUIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUIndex
						
				local MonsterFEIndex = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEIndex

				if GetObjectClass(aIndex) == 5 and MonsterSUIndex ~= nil then
			
					MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterSUString

				elseif GetObjectClass(aIndex) == 2 and MonsterFEIndex ~= nil then
						
					MonsterName = CustomQuest_QuestList[MainQuestStatus+1].MonsterFEString
	
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
			
			if ItemLevel == nil then ItemLevel = -1 end
					
			if ItemIndex ~= nil and NoItem > 0 then
					
				local NoItemCollected = InventoryGetItemCount(aIndex,ItemIndex,ItemLevel)

				local ItemString = CustomQuest_QuestList[MainQuestStatus+1].ItemString
				
				if ItemLevel ~= -1 and ItemLevel > 0 then
				
					NoticeText = NoticeText..(string.format(" [%d/%d %s+%d collected]",NoItemCollected,NoItem,ItemString,ItemLevel))
				
				else

					NoticeText = NoticeText..(string.format(" [%d/%d %s collected]",NoItemCollected,NoItem,ItemString))
					
				end
				
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
			
			LogPrint(string.format("CustomQuestScript: Failed to save MonsterCount for %s",aName))

			LogColor(1,string.format("CustomQuestScript: Failed to save MonsterCount for %s",aName))
			
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