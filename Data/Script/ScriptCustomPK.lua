CustomPK_SystemSwitch = 1

--------------BOUNTY SYSTEM--------------

CustomPK_MinBounty = 1000000

CustomPK_BountyTax = 90

CustomPK_BountyTimer = 0

CustomPK_BountyMinTime = 30

-------------/BOUNTY SYSTEM--------------

CustomPK_PKList = {}


ScriptLoader_AddOnReadScript("CustomPK_OnReadScript")

ScriptLoader_AddOnCheckUserKiller("CustomPK_OnCheckUserKiller")

ScriptLoader_AddOnTimerThread("CustomPK_OnTimerThread")

function CustomPK_OnReadScript()

	--------------BOUNTY SYSTEM--------------

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	
	-------------/BOUNTY SYSTEM--------------

	local ReadTable = FileLoad("..\\Data\\Script\\Data\\CustomPK.txt")

	if ReadTable == nil then return end

	local ReadCount = 1

	while ReadCount < #ReadTable do

		if ReadTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			CustomPK_PKListRow = {}

			CustomPK_PKListRow["Map"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomPK_PKListRow["MapSX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomPK_PKListRow["MapSY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomPK_PKListRow["MapTX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomPK_PKListRow["MapTY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			table.insert(CustomPK_PKList,CustomPK_PKListRow)

		end

	end

	math.randomseed(os.time())

end


function CustomPK_OnCheckUserKiller(aIndex,bIndex)

	if CustomPK_SystemSwitch ~= 0 then

		local KillerMap = GetObjectMap(aIndex)
		local KillerMapX = GetObjectMapX(aIndex)
		local KillerMapY = GetObjectMapY(aIndex)

		
		for n=1,#CustomPK_PKList,1 do

			if CustomPK_PKList[n].Map == KillerMap then

				if CustomPK_PKList[n].MapSX == -1 or CustomPK_PKList[n].MapSX <= KillerMapX then

					if CustomPK_PKList[n].MapSY == -1 or CustomPK_PKList[n].MapSY <= KillerMapY then

						if CustomPK_PKList[n].MapTX == -1 or CustomPK_PKList[n].MapTX >= KillerMapX then

							if CustomPK_PKList[n].MapTY == -1 or CustomPK_PKList[n].MapTY >= KillerMapY then

								return 0

							end

						end

					end

				end

			end

		end
		
		--------------BOUNTY SYSTEM--------------
		
		local VictimName = GetObjectName(bIndex)
		
		if CustomQuest_AddCharToTable(bIndex) == 1 then

			local TableIndex = CustomQuest_GetIndexFromTable(VictimName)
			
			if TableIndex >= 1 then
			
				local KillerName = GetObjectName(aIndex)
			
				CustomQuest_QuestStatusTable[TableIndex].LastKilledBy = KillerName
			
				local Bounty = CustomQuest_QuestStatusTable[TableIndex].Bounty
				
				if Bounty > 0 then
				
					if GetObjectIpAddress(aIndex) ~= GetObjectIpAddress(bIndex) then

						if SQLQuery(string.format("UPDATE Character SET Bounty=0 WHERE Name='%s'",VictimName)) == 0 then
					
							SQLClose()
			
							LogPrint(string.format("BountySystem: SQLQuery failed to save Bounty for %s",VictimName))

							LogColor(1,string.format("BountySystem: SQLQuery failed to save Bounty for %s",VictimName))
			
							if SQLCheck() == 0 then
			
								local SQL_ODBC = "MuOnline"
								
								local SQL_USER = ""

								local SQL_PASS = ""

								SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
							end
						
						else
					
							SQLClose()
						
							CustomQuest_QuestStatusTable[TableIndex].Bounty = 0

							local CharacterZen = GetObjectMoney(aIndex)

							SetObjectMoney(aIndex,CharacterZen+Bounty)

							MoneySend(aIndex,CharacterZen+Bounty)
						
							NoticeSend(aIndex,1,string.format("You killed %s and won %d Zen for their head.",VictimName,Bounty))

							NoticeSend(bIndex,1,string.format("%s took %d Bounty for your head.",KillerName,Bounty))

							local MessageText = string.format("%s killed %s and took %d Zen Bounty for their head.",KillerName,VictimName,Bounty)

							NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
							
								

							--KOMENDA SPRAWDZAJACA BOUNTY W LOKACJI
			
						end
						
					else
					
						NoticeSend(aIndex,1,"You can't get Bounty for your alt.")
					
					end
				
				end
		
			end

		end
		
		--CustomQuest_QuestStatusTableRow["LastKilledBy"] = tostring(CharacterName)
		
		-------------/BOUNTY SYSTEM--------------

	end

	return 1

end


--------------BOUNTY SYSTEM--------------

function CustomPK_SetBounty(aIndex,arg)

	local TargetName = CommandGetArgString(arg,1)
	
	if TargetName == nil or TargetName == "" then
	
		local CommandTableIndex = CustomQuest_GetIndexFromTable(GetObjectName(aIndex))
	
		if CommandTableIndex >= 1 then
	
			TargetName = CustomQuest_QuestStatusTable[CommandTableIndex].LastKilledBy
	
		end
	
	end
	
	local TargetIndex = GetObjectIndexByName(TargetName)
	
	if CustomPK_BountyTimer == 0 then
	
		if TargetIndex ~= -1 then
	
			local BountyZen = CommandGetArgNumber(arg,0)
		
			if BountyZen >= 1000000 then
		
				local CommandMoney = GetObjectMoney(aIndex)
			
				if BountyZen <= CommandMoney then
			
					if CustomQuest_AddCharToTable(TargetIndex) == 1 then

						local TableIndex = CustomQuest_GetIndexFromTable(TargetName)
			
						if TableIndex >= 1 then
					
																					--TIMER BLOKUJACY BOUNTY GRACZA
						
							local Bounty = CustomQuest_QuestStatusTable[TableIndex].Bounty + BountyZen * CustomPK_BountyTax / 100

							if SQLQuery(string.format("UPDATE Character SET Bounty=%d WHERE Name='%s'",Bounty,TargetName)) == 0 then
					
								SQLClose()
			
								LogPrint(string.format("BountySystem: SQLQuery failed to save Bounty for %s",TargetName))

								LogColor(1,string.format("BountySystem: SQLQuery failed to save Bounty for %s",TargetName))
			
								if SQLCheck() == 0 then
			
									local SQL_ODBC = "MuOnline"

									local SQL_USER = ""

									local SQL_PASS = ""

									SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
								end
						
							else
					
								SQLClose()
								
								CustomPK_BountyTimer = CustomPK_BountyMinTime
						
								SetObjectMoney(aIndex,CommandMoney-BountyZen)
						
								MoneySend(aIndex,CommandMoney-BountyZen)

								CustomQuest_QuestStatusTable[TableIndex].Bounty = Bounty
						
								NoticeSend(aIndex,1,string.format("You wish %s's death. Their total Bounty is %s Zen now.",TargetName,GetZenString(Bounty)))
						
								local MessageText = string.format("Someone set a %s Zen Bounty for %s's head.",GetZenString(Bounty),TargetName)
								
								NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)

							end	
						
						else
				
							NoticeSend(aIndex,1,string.format("No player %s found.",TargetName))
				
						end
				
					end
				
				else
			
					NoticeSend(aIndex,1,"You don't have enough Zen.")
			
				end
		
			else
	
				NoticeSend(aIndex,1,string.format("Minimum Bounty is %s Zen.",GetZenString(CustomPK_MinBounty)))
		
			end

		else
	
			if TargetName == nil or TargetName == "" then
	
				NoticeSend(aIndex,1,string.format("No player %s found.",TargetName))
		
			else
		
				NoticeSend(aIndex,1,"No player found for Bounty.")
		
			end
	
		end
	
	else
	
		NoticeSend(aIndex,1,string.format("You can't set Bounty now. Please wait %d sec.",CustomPK_BountyTimer))
	
	end
	
end

function CustomPK_OnTimerThread()

	if CustomPK_BountyTimer > 0 then
	
		CustomPK_BountyTimer = CustomPK_BountyTimer - 1
	
	end

end



function GetZenString(aZen)

	local ZenString = tostring(aZen)

	local ZenStringFinal = ""
	
	local ZenStringLength = #ZenString

	for n=ZenStringLength,1,-1 do

		ZenStringFinal = string.sub(ZenString,n,n)..ZenStringFinal
		
		if ((ZenStringLength+1-n) % 3) == 0 and n > 1 then
		
			ZenStringFinal = " "..ZenStringFinal
		
		end
	
	end

	return ZenStringFinal
	
end

-------------/BOUNTY SYSTEM--------------