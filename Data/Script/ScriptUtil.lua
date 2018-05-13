ScriptLoader_OnReadScriptTable = {}
ScriptLoader_OnShutScriptTable = {}
ScriptLoader_OnTimerThreadTable = {}
ScriptLoader_OnCommandManagerTable = {}
ScriptLoader_OnCharacterEntryTable = {}
ScriptLoader_OnCharacterCloseTable = {}
ScriptLoader_OnNpcTalkTable = {}
ScriptLoader_OnMonsterDieTable = {}
ScriptLoader_OnUserDieTable = {}
ScriptLoader_OnUserRespawnTable = {}
ScriptLoader_OnCheckUserTargetTable = {}
ScriptLoader_OnCheckUserKillerTable = {}
ScriptLoader_OnPacketRecvTable = {}


function FileLoad(FilePath)

	local file = io.open(FilePath,"r")

	if file ~= nil then

		local ReadTable = {}

		for line in file:lines("l") do

			local LastStr = 0

			local LastCmt = 0

			local LastRow = nil

			for char in string.gmatch(line,".") do

				if (char == " " or char == "	") and LastStr == 0 then

					if LastRow ~= nil then

						table.insert(ReadTable,LastRow)

						LastRow = nil

					end

				else

					if char == "/" and LastStr == 0 then

						if LastCmt == 0 then LastCmt = 1 else break end

					else

						if char == "\"" then

							if LastStr == 0 then LastStr = 1 else LastStr = 0 end

						else

							if LastRow == nil then LastRow = char else LastRow = LastRow..char end

						end

					end

				end

			end

			if LastRow ~= nil then

				table.insert(ReadTable,LastRow)

				LastRow = nil

			end

		end

		file:close()

		return ReadTable

	end

	return nil

end


function ScriptLoader_OnReadScript()

	for n=1,#ScriptLoader_OnReadScriptTable,1 do

		_G[ScriptLoader_OnReadScriptTable[n].Function]()

	end

end


function ScriptLoader_OnShutScript()

	for n=1,#ScriptLoader_OnShutScriptTable,1 do

		_G[ScriptLoader_OnShutScriptTable[n].Function]()

	end

end


function ScriptLoader_OnTimerThread()

	for n=1,#ScriptLoader_OnTimerThreadTable,1 do

		_G[ScriptLoader_OnTimerThreadTable[n].Function]()

	end

end


function ScriptLoader_OnCommandManager(aIndex,code,arg)

	for n=1,#ScriptLoader_OnCommandManagerTable,1 do

		if _G[ScriptLoader_OnCommandManagerTable[n].Function](aIndex,code,arg) ~= 0 then

			return 1

		end

	end

	return 0

end


function ScriptLoader_OnCharacterEntry(aIndex)

	for n=1,#ScriptLoader_OnCharacterEntryTable,1 do

		_G[ScriptLoader_OnCharacterEntryTable[n].Function](aIndex)

	end

end


function ScriptLoader_OnCharacterClose(aIndex)

	for n=1,#ScriptLoader_OnCharacterCloseTable,1 do

		_G[ScriptLoader_OnCharacterCloseTable[n].Function](aIndex)

	end

end


function ScriptLoader_OnNpcTalk(aIndex,bIndex)

	for n=1,#ScriptLoader_OnNpcTalkTable,1 do

		if _G[ScriptLoader_OnNpcTalkTable[n].Function](aIndex,bIndex) ~= 0 then

			return 1

		end

	end

	return 0

end


function ScriptLoader_OnMonsterDie(aIndex,bIndex)

	for n=1,#ScriptLoader_OnMonsterDieTable,1 do

		_G[ScriptLoader_OnMonsterDieTable[n].Function](aIndex,bIndex)

	end

end


function ScriptLoader_OnUserDie(aIndex,bIndex)

	for n=1,#ScriptLoader_OnUserDieTable,1 do

		_G[ScriptLoader_OnUserDieTable[n].Function](aIndex,bIndex)

	end

end


function ScriptLoader_OnUserRespawn(aIndex,KillerType)

	for n=1,#ScriptLoader_OnUserRespawnTable,1 do

		_G[ScriptLoader_OnUserRespawnTable[n].Function](aIndex,KillerType)

	end

end


function ScriptLoader_OnCheckUserTarget(aIndex,bIndex)

	for n=1,#ScriptLoader_OnCheckUserTargetTable,1 do

		if _G[ScriptLoader_OnCheckUserTargetTable[n].Function](aIndex,bIndex) == 0 then

			return 0

		end

	end

	return 1

end


function ScriptLoader_OnCheckUserKiller(aIndex,bIndex)

	for n=1,#ScriptLoader_OnCheckUserKillerTable,1 do

		if _G[ScriptLoader_OnCheckUserKillerTable[n].Function](aIndex,bIndex) == 0 then

			return 0

		end

	end

	return 1

end


function ScriptLoader_OnPacketRecv(aIndex,buff,size)

	for n=1,#ScriptLoader_OnPacketRecvTable,1 do

		_G[ScriptLoader_OnPacketRecvTable[n].Function](aIndex,buff,size)

	end

end


function ScriptLoader_AddOnReadScript(name)

	local ScriptLoader_OnReadScriptTableRow = {}

	ScriptLoader_OnReadScriptTableRow["Function"] = name

	table.insert(ScriptLoader_OnReadScriptTable,ScriptLoader_OnReadScriptTableRow)

end


function ScriptLoader_AddOnShutScript(name)

	local ScriptLoader_OnShutScriptTableRow = {}

	ScriptLoader_OnShutScriptTableRow["Function"] = name

	table.insert(ScriptLoader_OnShutScriptTable,ScriptLoader_OnShutScriptTableRow)

end


function ScriptLoader_AddOnTimerThread(name)

	local ScriptLoader_OnTimerThreadTableRow = {}

	ScriptLoader_OnTimerThreadTableRow["Function"] = name

	table.insert(ScriptLoader_OnTimerThreadTable,ScriptLoader_OnTimerThreadTableRow)

end


function ScriptLoader_AddOnCommandManager(name)

	local ScriptLoader_OnCommandManagerTableRow = {}

	ScriptLoader_OnCommandManagerTableRow["Function"] = name

	table.insert(ScriptLoader_OnCommandManagerTable,ScriptLoader_OnCommandManagerTableRow)

end


function ScriptLoader_AddOnCharacterEntry(name)

	local ScriptLoader_OnCharacterEntryTableRow = {}

	ScriptLoader_OnCharacterEntryTableRow["Function"] = name

	table.insert(ScriptLoader_OnCharacterEntryTable,ScriptLoader_OnCharacterEntryTableRow)

end


function ScriptLoader_AddOnCharacterClose(name)

	local ScriptLoader_OnCharacterCloseTableRow = {}

	ScriptLoader_OnCharacterCloseTableRow["Function"] = name

	table.insert(ScriptLoader_OnCharacterCloseTable,ScriptLoader_OnCharacterCloseTableRow)

end


function ScriptLoader_AddOnNpcTalk(name)

	local ScriptLoader_OnNpcTalkTableRow = {}

	ScriptLoader_OnNpcTalkTableRow["Function"] = name

	table.insert(ScriptLoader_OnNpcTalkTable,ScriptLoader_OnNpcTalkTableRow)

end


function ScriptLoader_AddOnMonsterDie(name)

	local ScriptLoader_OnMonsterDieTableRow = {}

	ScriptLoader_OnMonsterDieTableRow["Function"] = name

	table.insert(ScriptLoader_OnMonsterDieTable,ScriptLoader_OnMonsterDieTableRow)

end


function ScriptLoader_AddOnUserDie(name)

	local ScriptLoader_OnUserDieTableRow = {}

	ScriptLoader_OnUserDieTableRow["Function"] = name

	table.insert(ScriptLoader_OnUserDieTable,ScriptLoader_OnUserDieTableRow)

end


function ScriptLoader_AddOnUserRespawn(name)

	local ScriptLoader_OnUserRespawnTableRow = {}

	ScriptLoader_OnUserRespawnTableRow["Function"] = name

	table.insert(ScriptLoader_OnUserRespawnTable,ScriptLoader_OnUserRespawnTableRow)

end


function ScriptLoader_AddOnCheckUserTarget(name)

	local ScriptLoader_OnCheckUserTargetTableRow = {}

	ScriptLoader_OnCheckUserTargetTableRow["Function"] = name

	table.insert(ScriptLoader_OnCheckUserTargetTable,ScriptLoader_OnCheckUserTargetTableRow)

end


function ScriptLoader_AddOnCheckUserKiller(name)

	local ScriptLoader_OnCheckUserKillerTableRow = {}

	ScriptLoader_OnCheckUserKillerTableRow["Function"] = name

	table.insert(ScriptLoader_OnCheckUserKillerTable,ScriptLoader_OnCheckUserKillerTableRow)

end


function ScriptLoader_AddOnPacketRecv(name)

	local ScriptLoader_OnPacketRecvTableRow = {}

	ScriptLoader_OnPacketRecvTableRow["Function"] = name

	table.insert(ScriptLoader_OnPacketRecvTable,ScriptLoader_OnPacketRecvTableRow)

end