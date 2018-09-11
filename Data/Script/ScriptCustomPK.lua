CustomPK_SystemSwitch = 1

CustomPK_PKList = {}

CustomPK_BountyTax = 20

CustomPK_BountyTimer = 0

CustomPK_BountyMinTime = 30

CustomPK_UserDieTable = {}

CustomPK_DieTableTime = 30

CustomPK_BountyTable = {}

CURRENCYSTRING = {"zen","chaos","life","bless","soul"}

CURRENCYINDEX = {0,6159,7184,7181,7182}

CURRENCYBUNDLEINDEX = {0,0,0,6174,6175}

ZEN = 1

CHAOS = 2

LIFE = 3

BLESS = 4

SOUL = 5

MINAMMOUNT = {1000000,1,1,1,1}

MAXAMMOUNT = {1000000000,10,10,160,160}

ScriptLoader_AddOnTimerThread("CustomPK_OnTimerThread")

ScriptLoader_AddOnReadScript("CustomPK_OnReadScript")

ScriptLoader_AddOnCheckUserKiller("CustomPK_OnCheckUserKiller")

ScriptLoader_AddOnUserRespawn("CustomPK_OnUserRespawn")

ScriptLoader_AddOnCharacterEntry("CustomPK_OnCharacterEntry")

ScriptLoader_AddOnCharacterClose("CustomPK_OnCharacterClose")



function CustomPK_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)

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


function CustomPK_OnCheckUserKiller(aIndex,bIndex)		-- aIndex - Killer, bIndex - Victim

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
		
		if #CustomPK_UserDieTable > 0 then

			local DieTablePos = 0
		
			for n=1,#CustomPK_UserDieTable,1 do
		
				if CustomPK_UserDieTable[n].Victim == bIndex then
				
					DieTablePos = n
					
					break
					
				end
		
			end

			CustomPK_AddToDieTable(DieTablePos,bIndex,aIndex)
			
		else

			CustomPK_AddToDieTable(0,bIndex,aIndex)
		
		end

	end

	return 1

end


function CustomPK_OnUserRespawn(aIndex,KillerType)

	if CustomPK_SystemSwitch ~= 0 then

		if KillerType == 0 or KillerType == 1 then

			if #CustomPK_UserDieTable > 0 then

				for n=1,#CustomPK_UserDieTable,1 do
			
					local VictimIndex = CustomPK_UserDieTable[n].Victim
		
					if VictimIndex == aIndex then
				
						local KillerIndex = CustomPK_UserDieTable[n].Killer
					
						table.remove(CustomPK_UserDieTable,n)
					
						--Co sie ma dziac po zabiciu VictimIndex przez KillerIndex:
						
						


						CustomPK_GiveBounty(KillerIndex,VictimIndex)
						
						break
					
					end
		
				end

			end
	
		end
	
	end

end


function CustomPK_OnCharacterEntry(aIndex)

	if CustomPK_SystemSwitch ~= 0 then
	
		local TableIndex = CustomPK_AddCharToBountyTable(aIndex)

		if TableIndex > 0 then
			
			local CharacterName = GetObjectName(aIndex)

			local MessageText = ""
			
			local BountyZen = CustomPK_BountyTable[TableIndex].BountyZen
			
			if BountyZen ~= nil then
			
				MessageText = string.format("%s Zen ",GetZenString(BountyZen))
			
			end
			
			local BountyChaos = CustomPK_BountyTable[TableIndex].BountyChaos
			
			if BountyChaos ~= nil then
			
				MessageText = MessageText..string.format("%d Chaos ",BountyChaos)
			
			end
			
			if BountyLife ~= nil then
			
				MessageText = MessageText..string.format("%d JoL ",BountyLife)
			
			end
			
			if BountyBless ~= nil then
			
				MessageText = MessageText..string.format("%d Bless ",BountyBless)
			
			end
			
			if BountySoul ~= nil then
			
				MessageText = MessageText..string.format("%d Soul ",BountySoul)
			
			end
			
			if MessageText ~= "" and MessageText ~= nil then
			
				MessageText = "Your head is worth: "..MessageText
			
				NoticeSend(aIndex,1,MessageText)
			
			end

		else

			NoticeSend(aIndex,1,"Bounty system is currently unavailable. Please contact the Administrator.")
		
		end
	
	end
	
end


function CustomPK_OnCharacterClose(aIndex)

	if CustomPK_SystemSwitch ~= 0 then
	
		CustomPK_RemoveCharFromBountyTable(aIndex)
	
		if #CustomPK_UserDieTable > 0 then

			for n=1,#CustomPK_UserDieTable,1 do
		
				if CustomPK_UserDieTable[n].Victim == aIndex or CustomPK_UserDieTable[n].Killer == aIndex then
				
					table.remove(CustomPK_UserDieTable,n)
					
					break
					
				end
		
			end

		end

	end

end


function CustomPK_OnTimerThread()

	if #CustomPK_UserDieTable > 0 then
		
		for r=1,#CustomPK_UserDieTable,1 do

			local DieTimer = CustomPK_UserDieTable[r].Time
			
			if DieTimer > 0 then

				CustomPK_UserDieTable[r].Time = DieTimer - 1
				
			else
			
				table.remove(CustomPK_UserDieTable,r)
			
			end

		end

	end

	if CustomPK_BountyTimer > 0 then
	
		CustomPK_BountyTimer = CustomPK_BountyTimer - 1
	
	end

end





function CustomPK_AddToDieTable(aPosition,bVictim,cKiller)

	local CustomPK_UserDieTableRow = {}

	if aPosition > 0 then
	
		CustomPK_UserDieTable[aPosition].Victim = bVictim
		
		CustomPK_UserDieTable[aPosition].Killer = cKiller
		
		CustomPK_UserDieTable[aPosition].Time = CustomPK_DieTableTime
	
	else
	
		CustomPK_UserDieTableRow["Victim"] = bVictim
		
		CustomPK_UserDieTableRow["Killer"] = cKiller
		
		CustomPK_UserDieTableRow["Time"] = CustomPK_DieTableTime
		
		table.insert(CustomPK_UserDieTable,CustomPK_UserDieTableRow)
	
	end

end


function CustomPK_GiveBounty(aKiller,bVictim)

	local VictimName = GetObjectName(bVictim)
	
	local KillerName = GetObjectName(aKiller)

	if KillerName ~= nil then
	
		local TableIndex = CustomPK_AddCharToBountyTable(bVictim)
	
		if TableIndex > 0 then

			if TableIndex >= 1 then

				CustomPK_BountyTable[TableIndex].LastKilledBy = KillerName
			
				if CustomPK_CheckBounty(TableIndex) then
			
					if GetObjectIpAddress(aKiller) ~= GetObjectIpAddress(bVictim) then

						if SQLQuery(string.format("DELETE FROM Bounty WHERE Name='%s'",VictimName)) == 0 then
		
							SQLClose()
		
							if SQLCheck() == 0 then
			
								local SQL_ODBC = "MuOnline"

								local SQL_USER = ""

								local SQL_PASS = ""

								SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
							end
			
							LogPrint(string.format("CustomPK: Failed to remove %s from Bounty database.",VictimName))

							LogColor(1,string.format("CustomPK: Failed to remove %s from Bounty database.",VictimName))

						else
					
							SQLClose()
							
							local BountyZen = CustomPK_BountyTable[TableIndex].BountyZen
							
							local PriceText = ""
							
							if BountyZen ~= nil and BountyZen > 0 then
							
								BountyZen = tonumber(math.max(BountyZen * (100 - CustomPK_BountyTax) / 100,1))
							
								PriceText = string.format("%s Zen",GetZenString(BountyZen))
								
								local CharacterZen = GetObjectMoney(aKiller)
								
								if CharacterZen + BountyZen > 2000000000 then
								
									SetObjectMoney(aKiller,2000000000)
									
									SetObjectMoney(aKiller,2000000000)
								
								else

									SetObjectMoney(aKiller,CharacterZen+BountyZen)

									MoneySend(aKiller,CharacterZen+BountyZen)
									
								end
								
								CustomPK_BountyTable[TableIndex].BountyZen = nil
							
							end
							
							local BountyChaos = CustomPK_BountyTable[TableIndex].BountyChaos
							
							if BountyChaos ~= nil and BountyChaos > 0 then
							
								BountyChaos = tonumber(math.max(BountyChaos * (100 - CustomPK_BountyTax) / 100,1))
							
								if #PriceText > 0 then PriceText = PriceText..", " end
							
								PriceText = PriceText..string.format("%d Chaos",BountyChaos)
								
								CustomPK_BountyTable[TableIndex].BountyChaos = nil
								
								CustomPK_GiveBountyJewel(CHAOS,BountyChaos,aKiller)
							
							end
							
							local BountyLife = CustomPK_BountyTable[TableIndex].BountyLife
							
							if BountyLife ~= nil and BountyLife > 0 then
							
								BountyLife = tonumber(math.max(BountyLife * (100 - CustomPK_BountyTax) / 100,1))
							
								if #PriceText > 0 then PriceText = PriceText..", " end
							
								PriceText = PriceText..string.format("%d Life",BountyLife)
								
								CustomPK_BountyTable[TableIndex].BountyLife = nil
								
								CustomPK_GiveBountyJewel(LIFE,BountyLife,aKiller)
							
							end
							
							local BountyBless = CustomPK_BountyTable[TableIndex].BountyBless
							
							if BountyBless ~= nil and BountyBless > 0 then
							
								BountyBless = tonumber(math.max(BountyBless * (100 - CustomPK_BountyTax) / 100,1))
							
								if #PriceText > 0 then PriceText = PriceText..", " end
							
								PriceText = PriceText..string.format("%d Bless",BountyBless)
								
								CustomPK_BountyTable[TableIndex].BountyBless = nil

								CustomPK_GiveBountyJewel(BLESS,BountyBless,aKiller)
							
							end
							
							local BountySoul = CustomPK_BountyTable[TableIndex].BountySoul
							
							if BountySoul ~= nil and BountySoul > 0 then
							
								BountySoul = tonumber(math.max(BountySoul * (100 - CustomPK_BountyTax) / 100,1))
							
								if #PriceText > 0 then PriceText = PriceText..", " end
							
								PriceText = PriceText..string.format("%d Soul",BountySoul)
								
								CustomPK_BountyTable[TableIndex].BountySoul = nil
								
								CustomPK_GiveBountyJewel(SOUL,BountySoul,aKiller)
							
							end
						
							NoticeSend(aKiller,1,string.format("You killed %s and won %s for their head.",VictimName,PriceText))

							NoticeSend(bVictim,1,string.format("%s took %s for your head.",KillerName,PriceText))

							local MessageText = string.format("%s killed %s and took %s for their head.",KillerName,VictimName,PriceText)

							NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)

						end
						
					else
					
						NoticeSend(aKiller,1,"You can't get Bounty for your alt.")
					
					end
				
				end
		
			end

		end
		
	end

end


function CustomPK_GiveBountyJewel(aJewel,bNumber,cIndex)

	local JewelIndex = CURRENCYINDEX[aJewel]
	
	local JewelBundleIndex = CURRENCYBUNDLEINDEX[aJewel]

	if JewelIndex > 0 and JewelBundleIndex ~= nil and bNumber > 0 and cIndex ~= nil then
	
		if JewelBundleIndex > 0 and bNumber >= 10 then
		
			local BundleNumber = (bNumber - (bNumber % 10)) / 10 - 1
			
			bNumber = bNumber % 10
			
			if InventoryCheckSpaceBySize(cIndex,1,1) == 1 then
			
				ItemGiveEx(cIndex,JewelBundleIndex,BundleNumber,0,0,0,0,0)
			
			else
			
				local Map = GetObjectMap(cIndex)
				
				local MapX = GetObjectMapX(cIndex) + math.random(4) - 2
				
				local MapY = GetObjectMapY(cIndex) + math.random(4) - 2
			
				ItemDropEx(cIndex,Map,MapX,MapY,JewelBundleIndex,BundleNumber,0,0,0,0,0)
			
			end
		
		end
		
		if bNumber > 0 then

			for n=1,bNumber,1 do
		
				if InventoryCheckSpaceBySize(cIndex,1,1) == 1 then
			
					ItemGiveEx(cIndex,CURRENCYINDEX[aJewel],0,0,0,0,0,0)
			
				else
			
					local Map = GetObjectMap(cIndex)
				
					local MapX = GetObjectMapX(cIndex) + math.random(4) - 2
				
					local MapY = GetObjectMapY(cIndex) + math.random(4) - 2
			
					ItemDropEx(cIndex,Map,MapX,MapY,CURRENCYINDEX[aJewel],0,0,0,0,0,0)
				
					NoticeSend(GetObjectIndexByName("Candy_GM"),1,string.format("cIndex %d Item %d Map %d MapX %d MapY %d",cIndex,CURRENCYINDEX[aJewel],Map,MapX,MapY))
			
				end
	
			end
		
		end
	
	end

end


function CustomPK_AddCharToBountyTable(aIndex)

--Ladowanie Bounty postaci jesli jej nie ma w tabeli:

	local CharacterName = GetObjectName(aIndex)
	
	local TableIndex = CustomPK_GetIndexFromBountyTable(CharacterName)
	
	if TableIndex == 0 then
	
		if SQLQuery(string.format("SELECT * FROM Bounty WHERE Name='%s'",CharacterName)) == 0 then
		
			SQLClose()
		
			if SQLCheck() == 0 then
			
				local SQL_ODBC = "MuOnline"

				local SQL_USER = ""

				local SQL_PASS = ""

				SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
			end
			
			LogPrint(string.format("CustomPK: Failed to read Bounty for %s",CharacterName))

			LogColor(1,string.format("CustomPK: Failed to read Bounty for %s",CharacterName))
			
			return 0

		else

			local CustomPK_BountyTableRow = {}
				
			CustomPK_BountyTableRow["Name"] = tostring(CharacterName)
				
			CustomPK_BountyTableRow["LastKilledBy"] = ""
				
			if SQLFetch() == 1 then

				local BountyZen = tonumber(SQLGetNumber("BountyZen"))
			
				if BountyZen > 0 then CustomPK_BountyTableRow["BountyZen"] = BountyZen end
				
				local BountyChaos = tonumber(SQLGetNumber("BountyChaos"))

				if BountyChaos > 0 then CustomPK_BountyTableRow["BountyChaos"] = BountyChaos end
				
				local BountyLife = tonumber(SQLGetNumber("BountyLife"))
				
				if BountyLife > 0 then CustomPK_BountyTableRow["BountyLife"] = BountyLife end
				
				local BountyBless = tonumber(SQLGetNumber("BountyBless"))
				
				if BountyBless > 0 then CustomPK_BountyTableRow["BountyBless"] = BountyBless end
				
				local BountySoul = tonumber(SQLGetNumber("BountySoul"))
				
				if BountySoul > 0 then CustomPK_BountyTableRow["BountySoul"] = BountySoul end
				
			end

			table.insert(CustomPK_BountyTable,CustomPK_BountyTableRow)
			
			SQLClose()

			return #CustomPK_BountyTable

		end
	
	else
	
		return TableIndex
		
	end
	
end


function CustomPK_RemoveCharFromBountyTable(aIndex)

--Zapisuje Bounty Postaci, jeśli ma jakieś Bounty lub wywala pozycję z bazy, jeśli nie ma Bounty

	local CharacterName = GetObjectName(aIndex)
	
	local TableIndex = CustomPK_GetIndexFromBountyTable(CharacterName)
	
	if TableIndex >= 1 then
	
		if CustomPK_CheckBounty(TableIndex) == true then
		
			local BountyZen = CustomPK_BountyTable[TableIndex].BountyZen
			
			if BountyZen == nil then BountyZen = 0 end
			
			local BountyChaos = CustomPK_BountyTable[TableIndex].BountyChaos
			
			if BountyChaos == nil then BountyChaos = 0 end
			
			local BountyLife = CustomPK_BountyTable[TableIndex].BountyLife
			
			if BountyLife == nil then BountyLife = 0 end
			
			local BountyBless = CustomPK_BountyTable[TableIndex].BountyBless
			
			if BountyBless == nil then BountyBless = 0 end
			
			local BountySoul = CustomPK_BountyTable[TableIndex].BountySoul
			
			if BountySoul == nil then BountySoul = 0 end
			
			if SQLQuery(string.format("UPDATE Bounty SET BountyZen=%d,BountyChaos=%d,BountyLife=%d,BountyBless=%d,BountySoul=%d WHERE Name='%s'",BountyZen,BountyChaos,BountyLife,BountyBless,BountySoul,CharacterName)) == 0 then

				if SQLCheck() == 0 then
			
					local SQL_ODBC = "MuOnline"

					local SQL_USER = ""

					local SQL_PASS = ""

					SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
				end
			
				LogPrint(string.format("CustomPK: Failed to save Bounty for %s",CharacterName))

				LogColor(1,string.format("CustomPK: Failed to save Bounty for %s",CharacterName))

			end
			
			SQLClose()
	
			if SQLQuery(string.format("SELECT * FROM Bounty WHERE Name='%s'",CharacterName)) == 0 or SQLFetch() == 0 then
			
				SQLClose()
				
				if SQLQuery(string.format("INSERT INTO Bounty (Name,BountyZen,BountyChaos,BountyLife,BountyBless,BountySoul) VALUES ('%s',%d,%d,%d,%d,%d)",CharacterName,BountyZen,BountyChaos,BountyLife,BountyBless,BountySoul)) == 0 then
		
					SQLClose()
		
					if SQLCheck() == 0 then
			
						local SQL_ODBC = "MuOnline"

						local SQL_USER = ""

						local SQL_PASS = ""

						SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
					end
			
					LogPrint(string.format("CustomPK: Failed to insert Bounty for %s",CharacterName))

					LogColor(1,string.format("CustomPK: Failed to insert Bounty for %s",CharacterName))
					
				else
				
					SQLClose()
		
				end
		
			end

		else
		
			if SQLQuery(string.format("DELETE FROM Bounty WHERE Name='s'",CharacterName)) == 0 then
		
				SQLClose()
		
				if SQLCheck() == 0 then
			
					local SQL_ODBC = "MuOnline"

					local SQL_USER = ""

					local SQL_PASS = ""

					SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
				end
			
				LogPrint(string.format("CustomPK: Failed to remove %s from Bounty database.",CharacterName))

				LogColor(1,string.format("CustomPK: Failed to remove %s from Bounty database.",CharacterName))
				
			else
			
				SQLClose()

			end
	
		end
		
		table.remove(CustomPK_BountyTable,TableIndex)
		
	end
	
end


function CustomPK_CheckBounty(aTableIndex)

	local BountyZen = CustomPK_BountyTable[aTableIndex].BountyZen
	
	local BountyChaos = CustomPK_BountyTable[aTableIndex].BountyChaos
		
	local BountyLife = CustomPK_BountyTable[aTableIndex].BountyLife
	
	local BountyBless = CustomPK_BountyTable[aTableIndex].BountyBless
	
	local BountySoul = CustomPK_BountyTable[aTableIndex].BountySoul

	if BountyZen ~= nil and BountyZen > 0 then
	
		return true
		
	elseif BountyChaos ~= nil and BountyChaos > 0 then
		
		return true
		
	elseif BountyLife ~= nil and BountyLife > 0 then
		
		return true
		
	elseif BountyBless ~= nil and BountyBless > 0 then
		
		return true
		
	elseif BountySoul ~= nil and BountySoul > 0 then
	
		return true
		
	else
	
		return false
	
	end

end


function CustomPK_GetIndexFromBountyTable(aName)

	local TableIndex = 0
	
	local BountyTableLength = #CustomPK_BountyTable
	
	if BountyTableLength >= 1 then
	
		for n=1,BountyTableLength,1 do
			
			if CustomPK_BountyTable[n].Name == aName then
			
				TableIndex = n
				
				break

			end			
			
		end
	
	end
	
	return TableIndex

end


function CustomPK_SetBountyCommand(aIndex,arg)

	if CustomPK_SystemSwitch ~= 0 then

		local Arg0 = CommandGetArgString(arg,0)
		
		local Arg1 = CommandGetArgString(arg,1)
		
		local Arg2 = CommandGetArgString(arg,2)
		
		local TargetName = ""
		
		local Ammount = 0
		
		local Currency = 0
		
		if Arg2 == nil then
		
			Ammount = tonumber(Arg0)
		
			for n=1,#CURRENCYSTRING,1 do
			
				if CURRENCYSTRING[n] == Arg1 then
				
					Currency = n
					
					break
				
				end
			
			end
		
		else
		
			TargetName = Arg0
			
			Ammount = tonumber(Arg1)
		
			for n=1,#CURRENCYSTRING,1 do
			
				if CURRENCYSTRING[n] == Arg2 then
				
					Currency = n
					
					break
				
				end
			
			end
		
		end

		if TargetName == "" then
	
			local PrincipalTableIndex = CustomPK_GetIndexFromBountyTable(GetObjectName(aIndex))
	
			if PrincipalTableIndex >= 1 then
	
				TargetName = CustomPK_BountyTable[PrincipalTableIndex].LastKilledBy
	
			end
	
		end
	
		if CustomPK_BountyTimer == 0 then
		
			local TargetIndex = GetObjectIndexByName(TargetName)
	
			if TargetIndex ~= -1 then
			
				if Currency > 0 then
				
					if Ammount >= MINAMMOUNT[Currency] then
					
						local TableIndex = CustomPK_AddCharToBountyTable(TargetIndex)
						
						if TableIndex > 0 then

							local TargetBounty = 0
							
							if Currency == ZEN then
							
								TargetBounty = CustomPK_BountyTable[TableIndex].BountyZen
								
							elseif Currency == CHAOS then
							
								TargetBounty = CustomPK_BountyTable[TableIndex].BountyChaos
							
							elseif Currency == LIFE then
							
								TargetBounty = CustomPK_BountyTable[TableIndex].BountyLife
								
							elseif Currency == BLESS then
							
								TargetBounty = CustomPK_BountyTable[TableIndex].BountyBless
								
							else
							
								TargetBounty = CustomPK_BountyTable[TableIndex].BountySoul
							
							end
							
							if TargetBounty == nil then TargetBounty = 0 end
							
							if TargetBounty + Ammount <= MAXAMMOUNT[Currency] then
							
								local PrincipalAmmount = 0
						
								if Currency == ZEN then
								
									PrincipalAmmount = GetObjectMoney(aIndex)
								
								else
								
									PrincipalAmmount = InventoryGetItemCount(aIndex,CURRENCYINDEX[Currency],-1)
								
									--CO Z PACZKAMI BLESSOW I SOULI??
								
								end
								
								if Ammount <= PrincipalAmmount then

									local QueryRowString = "Bounty"..CURRENCYSTRING[Currency]
									
									TargetBounty = TargetBounty + Ammount
								
									if SQLQuery(string.format("UPDATE Bounty SET %s=%d WHERE Name='%s'",QueryRowString,TargetBounty,TargetName)) == 0 then

										if SQLCheck() == 0 then
			
											local SQL_ODBC = "MuOnline"

											local SQL_USER = ""

											local SQL_PASS = ""

											SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
										end
			
										LogPrint(string.format("CustomPK: Failed to save Bounty for %s",TargetName))

										LogColor(1,string.format("CustomPK: Failed to save Bounty for %s",TargetName))

									end
									
									SQLClose()
	
									if SQLQuery(string.format("SELECT * FROM Bounty WHERE Name='%s'",TargetName)) == 0 or SQLFetch() == 0 then
									
										SQLClose()
				
										if SQLQuery(string.format("INSERT INTO Bounty (Name,%s) VALUES ('%s',%d)",QueryRowString,TargetName,TargetBounty)) == 0 then

											if SQLCheck() == 0 then
			
												local SQL_ODBC = "MuOnline"

												local SQL_USER = ""

												local SQL_PASS = ""

												SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
											end
			
											LogPrint(string.format("CustomPK: Failed to insert Bounty for %s",TargetName))

											LogColor(1,string.format("CustomPK: Failed to insert Bounty for %s",TargetName))

										end

									end
									
									SQLClose()
									
									if Currency == ZEN then
							
										CustomPK_BountyTable[TableIndex].BountyZen = TargetBounty

										SetObjectMoney(aIndex,PrincipalAmmount-Ammount)

										MoneySend(aIndex,PrincipalAmmount-Ammount)

									elseif Currency == CHAOS then
							
										CustomPK_BountyTable[TableIndex].BountyChaos = TargetBounty
										
										InventoryDelItemCount(aIndex,CURRENCYINDEX[Currency],-1,Ammount)
							
									elseif Currency == LIFE then
							
										CustomPK_BountyTable[TableIndex].BountyLife = TargetBounty
										
										InventoryDelItemCount(aIndex,CURRENCYINDEX[Currency],-1,Ammount)
								
									elseif Currency == BLESS then
							
										CustomPK_BountyTable[TableIndex].BountyBless = TargetBounty
										
										InventoryDelItemCount(aIndex,CURRENCYINDEX[Currency],-1,Ammount)
								
									else
							
										CustomPK_BountyTable[TableIndex].BountySoul = TargetBounty
										
										InventoryDelItemCount(aIndex,CURRENCYINDEX[Currency],-1,Ammount)
							
									end
									
									--Preparing message for Principal and all server players:
									
									local BountyZen = CustomPK_BountyTable[TableIndex].BountyZen
							
									local MessageText = ""
							
									if BountyZen ~= nil and BountyZen > 0 then
									
										BountyZen = tonumber(math.max(BountyZen * (100 - CustomPK_BountyTax) / 100,1))
							
										MessageText = string.format("%s Zen",GetZenString(BountyZen))
									
									end
							
									local BountyChaos = CustomPK_BountyTable[TableIndex].BountyChaos
							
									if BountyChaos ~= nil and BountyChaos > 0 then
							
										if #MessageText > 0 then MessageText = MessageText..", " end
										
										BountyChaos = tonumber(math.max(BountyChaos * (100 - CustomPK_BountyTax) / 100,1))
							
										MessageText = MessageText..string.format("%d Chaos",BountyChaos)
									
									end
									
									local BountyLife = CustomPK_BountyTable[TableIndex].BountyLife
							
									if BountyLife ~= nil and BountyLife > 0 then
							
										if #MessageText > 0 then MessageText = MessageText..", " end
										
										BountyLife = tonumber(math.max(BountyLife * (100 - CustomPK_BountyTax) / 100,1))
							
										MessageText = MessageText..string.format("%d Life",BountyLife)
								
									end
									
									local BountyBless = CustomPK_BountyTable[TableIndex].BountyBless
							
										if BountyBless ~= nil and BountyBless > 0 then
							
										if #MessageText > 0 then MessageText = MessageText..", " end
										
										BountyBless = tonumber(math.max(BountyBless * (100 - CustomPK_BountyTax) / 100,1))
							
										MessageText = MessageText..string.format("%d Bless",BountyBless)
										
									end
									
									local BountySoul = CustomPK_BountyTable[TableIndex].BountySoul
							
									if BountySoul ~= nil and BountySoul > 0 then
							
										if #MessageText > 0 then MessageText = MessageText..", " end
										
										BountySoul = tonumber(math.max(BountySoul * (100 - CustomPK_BountyTax) / 100,1))
							
										MessageText = MessageText..string.format("%d Soul",BountySoul)
							
									end
									
									NoticeSend(aIndex,1,string.format("You set %s %s Bounty for %s head.",GetZenString(Ammount),CURRENCYSTRING[Currency],TargetName))
								
									MessageText = string.format("Somebody set %s Bounty over %s's head.",MessageText,TargetName)

									NoticeLangGlobalSend(0,MessageText,MessageText,MessageText)
									
									CustomPK_BountyTimer = CustomPK_BountyMinTime

								else
			
									NoticeSend(aIndex,1,string.format("You don't have enough %s.",CURRENCYSTRING[Currency]))
			
								end
							
							else
							
								NoticeSend(aIndex,1,string.format("You can place only %s %s for a player's head.",GetZenString(MAXAMMOUNT[Currency]),CURRENCYSTRING[Currency]))
							
							end
							
						else	
						
							NoticeSend(aIndex,1,string.format("No player %s foundAAA.",TargetName))
							
						end
		
					else
	
						NoticeSend(aIndex,1,string.format("Minimum Bounty is %s %s.",GetZenString(MINAMMOUNT[Currency]),CURRENCYSTRING[Currency]))

					end
				
				else
				
					NoticeSend(aIndex,1,string.format("Type '%s', '%s', '%s', '%s', '%s' as currency.",CURRENCYSTRING[1],CURRENCYSTRING[2],CURRENCYSTRING[3],CURRENCYSTRING[4],CURRENCYSTRING[5]))
				
				end

			else
	
				if TargetName == nil or TargetName == "" then

					NoticeSend(aIndex,1,"No player found for Bounty.")
		
				else
		
					NoticeSend(aIndex,1,string.format("No player %s found.",TargetName))
		
				end
	
			end
	
		else
	
			NoticeSend(aIndex,1,string.format("You can't set Bounty now. Please wait %d sec.",CustomPK_BountyTimer))
	
		end

	end
	
end


function CustomPK_TrackBounty(aIndex,arg)

	if CustomPK_SystemSwitch ~= 0 then
	
		local TrackBountyTable = {}

		PlayerMap = GetObjectMap(aIndex)

		for n=1,#CustomPK_BountyTable,1 do
		
			local nName = CustomPK_BountyTable[n].Name
			
			local nMap = GetObjectMap(GetObjectIndexByName(nName))
			
			if nMap == PlayerMap then
			
				local BountyZen = CustomPK_BountyTable[n].BountyZen
			
				local TrackBountyTableRow = ""
		
				local BountyZen = CustomPK_BountyTable[n].BountyZen
				
				local BountyChaos = CustomPK_BountyTable[n].BountyChaos
				
				local BountyLife = CustomPK_BountyTable[n].BountyLife
				
				local BountyBless = CustomPK_BountyTable[n].BountyBless
				
				local BountySoul = CustomPK_BountyTable[n].BountySoul

				if BountyZen ~= nil and BountyZen > 0 then
				
					BountyZen = tonumber(math.max(BountyZen * (100 - CustomPK_BountyTax) / 100,1))
				
					TrackBountyTableRow = string.format("%s %s ",GetZenString(BountyZen),CURRENCYSTRING[1])
				
				end
				
				if BountyChaos ~= nil and BountyChaos > 0 then
				
					BountyChaos = tonumber(math.max(BountyChaos * (100 - CustomPK_BountyTax) / 100,1))
				
					TrackBountyTableRow = TrackBountyTableRow..string.format("%s %s ",GetZenString(BountyChaos),CURRENCYSTRING[2])
				
				end
				
				if BountyLife ~= nil and BountyLife > 0 then
				
					BountyLife = tonumber(math.max(BountyLife * (100 - CustomPK_BountyTax) / 100,1))
				
					TrackBountyTableRow = TrackBountyTableRow..string.format("%s %s ",GetZenString(BountyLife),CURRENCYSTRING[3])
				
				end
				
				if BountyBless ~= nil and BountyBless > 0 then
				
					BountyBless = tonumber(math.max(BountyBless * (100 - CustomPK_BountyTax) / 100,1))
				
					TrackBountyTableRow = TrackBountyTableRow..string.format("%s %s ",GetZenString(BountyBless),CURRENCYSTRING[4])
				
				end
				
				if BountySoul ~= nil and BountySoul > 0 then
				
					BountySoul = tonumber(math.max(BountySoul * (100 - CustomPK_BountyTax) / 100,1))
				
					TrackBountyTableRow = TrackBountyTableRow..string.format("%s %s ",GetZenString(BountySoul),CURRENCYSTRING[5])
				
				end
				
				if #TrackBountyTableRow > 0 then
				
					TrackBountyTableRow = string.format("Name: %s, Bounty: ",nName)..TrackBountyTableRow
				
					table.insert(TrackBountyTable,TrackBountyTableRow)
			
				end
		
			end
	
		end

		if #TrackBountyTable > 0 then
		
			NoticeSend(aIndex,1,"You sense the presence of victims:")
		
			for n=1,#TrackBountyTable,1 do
			
				NoticeSend(aIndex,1,TrackBountyTable[n])
			
			end
		
		else
		
			NoticeSend(aIndex,1,"No one can be hunted down in this vicinity.")
			
		end
	
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
