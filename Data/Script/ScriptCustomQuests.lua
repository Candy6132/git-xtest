CustomQuests_SystemSwitch = 1

CustomQuests_QuestList = {}


ScriptLoader_AddOnReadScript("CustomQuests_OnReadScript")

ScriptLoader_AddOnNpcTalk("CustomQuests_OnNpcTalk")


function CustomQuests_OnReadScript()

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

function CustomQuests_OnNpcTalk(aIndex,bIndex)

	if aIndex == 257 then
	
		NoticeSend(bIndex,0,"Guardian: I'll help you my friend.")
	
	end
	
	return 1

end