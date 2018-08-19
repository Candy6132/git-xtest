












--CO NIE DZIALA:
--PO QUERY ZE ZMIANA RESETU LICZBA RESETOW W KLIENCIE NIE AKTUALIZUJE SIĘ
--POZOSTALO DO OGARNIECIA USTAWIENIE MASTER LEVEL I MASTER POINT PODCZAS RESETU













ScriptLoader_AddOnReadScript("CustomReset_OnReadScript")


function CustomReset_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	
	

	CustomReset_ResetLevel = ConfigReadNumber("CustomResetInfo","CommandResetLevel_AL0","..\\Data\\Script\\Data\\CustomReset.ini")

	CustomReset_ResetPoint = ConfigReadNumber("CustomResetInfo","CommandResetPoint_AL0","..\\Data\\Script\\Data\\CustomReset.ini")

	CustomReset_ResetMoney = ConfigReadNumber("CustomResetInfo","CommandResetMoney_AL0","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDW = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDW","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDK = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDK","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateFE = ConfigReadNumber("CustomResetInfo","CommandResetPointRateFE","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateMG = ConfigReadNumber("CustomResetInfo","CommandResetPointRateMG","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDL = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDL","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateSU = ConfigReadNumber("CustomResetInfo","CommandResetPointRateSU","..\\Data\\Script\\Data\\CustomReset.ini")
	
	if CustomReset_ResetLevel < 220 or CustomReset_ResetLevel == nil then
	
		CustomReset_ResetLevel = 220
		
	end
	
	math.randomseed(os.time())	

end



function CustomReset_Reset(aIndex)

	local PlayerLevel = GetObjectLevel(aIndex)

	if PlayerLevel >= CustomReset_ResetLevel then
	
		local PlayerMoney = GetObjectMoney(aIndex)
	
		if PlayerMoney >= CustomReset_ResetMoney then

			local CharacterClass = GetObjectClass(aIndex)
			
			local CharacterName = GetObjectName(aIndex)
			
			local DefaultStrength = GetObjectDefaultStrength(aIndex)
			
			local DefaultDexterity = GetObjectDefaultDexterity(aIndex)
			
			local DefaultVitality = GetObjectDefaultVitality(aIndex)
			
			local DefaultEnergy = GetObjectDefaultEnergy(aIndex)
			
			local DefaultLeadership = GetObjectDefaultLeadership(aIndex)
		
			local CharacterInitialPoints = DefaultStrength + DefaultDexterity + DefaultVitality + DefaultEnergy + DefaultLeadership
			
			local CharacterTotalPoints = 0
			
			---------------------------------------TEST------------------------------------------
			
			NoticeSend(aIndex,1,string.format("CharacterClass: %d",CharacterClass))
			
			NoticeSend(aIndex,1,string.format("ChangeUp: %d",GetObjectChangeUp(aIndex)))
			
			NoticeSend(aIndex,1,string.format("InitialStr: %d",DefaultStrength))
			
			NoticeSend(aIndex,1,string.format("InitialAgi: %d",DefaultDexterity))
			
			NoticeSend(aIndex,1,string.format("InitialVit: %d",DefaultVitality))
			
			NoticeSend(aIndex,1,string.format("InitialEne: %d",DefaultEnergy))
			
			NoticeSend(aIndex,1,string.format("InitialCmd: %d",DefaultLeadership))
			
			---------------------------------------TEST------------------------------------------
			
			if CharacterClass == 3 or CharacterClass == 4 then
			
				CharacterTotalPoints = CharacterInitialPoints + ((CustomReset_ResetLevel - 1) * 7)
			
			else

				if GetObjectChangeUp(aIndex) > 1 then
				
					CharacterTotalPoints = CharacterInitialPoints + (219 * 5) + ((CustomReset_ResetLevel - 220) * 6)
				
				else
				
					local QuestHex = CustomReset_GetQuestHex(CharacterName)
					
					if QuestHex == "FF" or QuestHex == "FD" or QuestHex == "FE" or QuestHex == "F6" or QuestHex == "FA" or QuestHex == "DA" then
				
						CharacterTotalPoints = CharacterInitialPoints + ((CustomReset_ResetLevel - 1) * 5)
					
					else
				
						CharacterTotalPoints = CharacterInitialPoints + (219 * 5) + ((CustomReset_ResetLevel - 220) * 6)
					
					end
				
				end
			
			end

			local PlayerReset = GetObjectReset(aIndex)
			
			local PlayerNewReset = PlayerReset + 1

			if QuestHex ~= "nil" and CustomReset_SetObjectReset(aIndex,CharacterName,PlayerNewReset) == 1 then
			
				SetObjectLevel(aIndex,1)
				
				local CharacterBonusPoints = 0
				
				if CharacterClass == 0 then
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateDW / 100
					
				elseif CharacterClass == 1 then
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateDK / 100
				
				elseif CharacterClass == 2 then
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateFE / 100
					
				elseif CharacterClass == 3 then
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateMG / 100
				
				elseif CharacterClass == 4 then
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateDL / 100
				
				else
				
					CharacterBonusPoints = CustomReset_ResetPoint * CustomReset_ResetPointRateSU / 100
				
				end
				
				CharacterBonusPoints = CharacterBonusPoints + GetObjectLevelUpPoint(aIndex) + GetObjectStrength(aIndex) + GetObjectDexterity(aIndex) + GetObjectVitality(aIndex) + GetObjectEnergy(aIndex) + GetObjectLeadership(aIndex) - CharacterTotalPoints - CharacterInitialPoints
				
				SetObjectLevelUpPoint(aIndex,CharacterBonusPoints)
			
				local PlayerMasterPoint = GetObjectMasterPoint(aIndex)
			
				local PlayerMasterLevel = GetObjectMasterLevel(aIndex)
				
				SetObjectLevel(aIndex,1)
				
				SetObjectMasterPoint(aIndex,PlayerMasterPoint + PlayerNewReset - PlayerMasterLevel)
				
				SetObjectMasterLevel(aIndex,PlayerNewReset)
				
				EffectClear(aIndex)
				
				SetObjectStrength(aIndex,DefaultStrength)
			
				SetObjectDexterity(aIndex,DefaultDexterity)
			
				SetObjectVitality(aIndex,DefaultVitality)
			
				SetObjectEnergy(aIndex,DefaultEnergy)
			
				SetObjectLeadership(aIndex,DefaultLeadership)

				SetObjectMoney(aIndex,PlayerMoney-CustomReset_ResetMoney)

				MoneySend(aIndex,PlayerMoney-CustomReset_ResetMoney)

				LevelUpSend(aIndex)
			
				UserCalcAttribute(aIndex)

				UserInfoSend(aIndex)
			
				MasterLevelUpSend(aIndex)
				
				--Warpnac do Lorki

			end

			
			
			
			
			

		else
		
			NoticeSend(aIndex,1,string.format(MessageGet(92,GetObjectLang(aIndex)),CustomReset_ResetMoney))			--"You need at least %d zen to use /reset"
			
		end
		
	else

		NoticeSend(aIndex,1,string.format(MessageGet(91,GetObjectLang(aIndex)),CustomReset_ResetLevel))			--"You must be level %d before use /reset"
	
	end
	
end


function CustomReset_GetQuestHex(aName)

	if SQLQuery(string.format("SELECT Quest FROM Character WHERE Name='%s'",aName)) == 0 or SQLFetch() == 0 then
		
		SQLClose()
			
		if SQLCheck() == 0 then
			
			local SQL_ODBC = "MuOnline"

			local SQL_USER = ""

			local SQL_PASS = ""

			SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
				
		end
	
		LogPrint(string.format("CustomResetScript: Failed to read Quest from Query for %s",aName))

		LogColor(1,string.format("CustomResetScript: Failed to read Quest from Query for %s",aName))
			
		NoticeSend(aIndex,1,"Failed to make a reset. Please try again or contact the administrator.")
		
		return "nil"
	
	else

		local Quest = tostring(SQLGetString("Quest"))

		SQLClose()
					
		Quest = string.sub(Quest,1,2)
			
		return Quest

	end

end



function CustomReset_SetObjectReset(aIndex,bName,cValue)

	if SQLQuery(string.format("UPDATE Character SET ResetCount=%d WHERE Name='%s'",cValue,bName)) == 0 then
								
		if SQLCheck() == 0 then
			
			local SQL_ODBC = "MuOnline"

			local SQL_USER = ""

			local SQL_PASS = ""

			SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
		end
		
		LogPrint(string.format("CustomReset: Failed to change reset for %s",bName))

		LogColor(1,string.format("CustomReset: Failed to change reset for %s",bName))
		
		NoticeSend(aIndex,1,"Failed to make a reset. Please try again or contact the administrator.")
		
		return 0
	
	else
	
		--LevelUpSend(aIndex)
		
		--UserCalcAttribute(aIndex)
		
		--UserInfoSend(aIndex)
		
		return 1
		
	end

end