
ScriptLoader_AddOnReadScript("CustomReset_OnReadScript")


function CustomReset_OnReadScript()

	CustomReset_ResetLevel = ConfigReadNumber("CustomResetInfo","CommandResetLevel_AL0","..\\Data\\Script\\Data\\CustomReset.ini")

	CustomReset_ResetPoint = ConfigReadNumber("CustomResetInfo","CommandResetPoint_AL0","..\\Data\\Script\\Data\\CustomReset.ini")

	CustomReset_ResetMoney = ConfigReadNumber("CustomResetInfo","CommandResetMoney_AL0","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDW = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDW","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDK = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDK","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateFE = ConfigReadNumber("CustomResetInfo","CommandResetPointRateFE","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateMG = ConfigReadNumber("CustomResetInfo","CommandResetPointRateMG","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateDL = ConfigReadNumber("CustomResetInfo","CommandResetPointRateDL","..\\Data\\Script\\Data\\CustomReset.ini")
	
	CustomReset_ResetPointRateSU = ConfigReadNumber("CustomResetInfo","CommandResetPointRateSU","..\\Data\\Script\\Data\\CustomReset.ini")

end



function CustomReset_Reset(aIndex)

	if CustomReset_ResetLevel == nil then CustomReset_ResetLevel = -1 end
	
	if CustomReset_ResetMoney == nil then CustomReset_ResetMoney = -1 end

	if GetObjectLevel(aIndex) >= CustomReset_ResetLevel then
	
		if GetObjectMoney(aIndex) >= CustomReset_ResetMoney then

			NoticeSend(aIndex,1,"dupacycki")
			
			NoticeSend(aIndex,1,string.format("CommandResetLevel: %d",CustomReset_ResetLevel))
	
			local MasterLevel = GetObjectMasterLevel(aIndex)
	
			SetObjectMasterLevel(aIndex,MasterLevel+1)
			
		end
		
	else

		NoticeSend(aIndex,1,string.format(MessageGet(91,GetObjectLang(aIndex)),CustomReset_ResetLevel))			--"You must be level %d before use /reset"
	
	end
	
	--NoticeSend(aIndex,1,string.format("CommandResetLevel: %d",CustomReset_ResetLevel))    91
	
	--GetObjectLang(aIndex)
	
	--MessageGet(aValue,bValue)

end