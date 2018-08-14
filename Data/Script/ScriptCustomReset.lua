CustomReset_GameServerInfoPath = "C:\\MuServer\\GameServer\\DATA\\GameServerInfo - Command.dat"

ScriptLoader_AddOnReadScript("CustomReset_OnReadScript")


function CustomReset_OnReadScript()

	CustomReset_CommandResetLevel = ConfigReadNumber("GameServerInfo","CommandResetLevel_AL0",GameServerInfoPath)
	
	CustomReset_CommandResetPoint = ConfigReadNumber("GameServerInfo","CommandResetPoint_AL0",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateDW = ConfigReadNumber("GameServerInfo","CommandResetPointRateDW",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateDK = ConfigReadNumber("GameServerInfo","CommandResetPointRateDK",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateFE = ConfigReadNumber("GameServerInfo","CommandResetPointRateFE",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateMG = ConfigReadNumber("GameServerInfo","CommandResetPointRateMG",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateDL = ConfigReadNumber("GameServerInfo","CommandResetPointRateDL",GameServerInfoPath)
	
	CustomReset_CommandResetPointRateSU = ConfigReadNumber("GameServerInfo","CommandResetPointRateSU",GameServerInfoPath)

end



function CustomReset_Reset(aIndex)

	local ClassIndex = GetObjectClass(aIndex)
	
	NoticeSend(aIndex,1,string.format("ClassIndex: %d",ClassIndex))
	
	NoticeSend(aIndex,1,string.format("CommandResetLevel: %d",CustomReset_CommandResetLevel))
	
	local MasterLevel = GetObjectMasterLevel(aIndex)
	
	SetObjectMasterLevel(aIndex,MasterLevel+1)

end