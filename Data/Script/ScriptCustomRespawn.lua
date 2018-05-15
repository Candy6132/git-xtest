CustomRespawn_SystemSwitch = 1

CustomRespawn_RespawnList = {}


ScriptLoader_AddOnReadScript("CustomRespawn_OnReadScript")

ScriptLoader_AddOnUserRespawn("CustomRespawn_OnUserRespawn")


function CustomRespawn_OnReadScript()

	local ReadTable = FileLoad("..\\Data\\Script\\Data\\CustomRespawn.txt")

	if ReadTable == nil then return end

	local ReadCount = 1

	while ReadCount < #ReadTable do

		if ReadTable[ReadCount] == "end" then

			ReadCount = ReadCount+1

			break

		else

			CustomRespawn_RespawnListRow = {}

			CustomRespawn_RespawnListRow["Map"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["MapSX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["MapSY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["MapTX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["MapTY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["RespawnMap"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["RespawnMapSX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["RespawnMapSY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["RespawnMapTX"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			CustomRespawn_RespawnListRow["RespawnMapTY"] = tonumber(ReadTable[ReadCount])

			ReadCount = ReadCount+1

			table.insert(CustomRespawn_RespawnList,CustomRespawn_RespawnListRow)

		end

	end

	math.randomseed(os.time())

end


function CustomRespawn_OnUserRespawn(aIndex,KillerType)

	if CustomRespawn_SystemSwitch ~= 0 and (KillerType == 0 or KillerType == 1) then

		local UserDeathMap = GetObjectDeathMap(aIndex)
		local UserDeathMapX = GetObjectDeathMapX(aIndex)
		local UserDeathMapY = GetObjectDeathMapY(aIndex)

		for n=1,#CustomRespawn_RespawnList,1 do

			if CustomRespawn_RespawnList[n].Map == UserDeathMap then

				if CustomRespawn_RespawnList[n].MapSX == -1 or CustomRespawn_RespawnList[n].MapSX <= UserDeathMapX then

					if CustomRespawn_RespawnList[n].MapSY == -1 or CustomRespawn_RespawnList[n].MapSY <= UserDeathMapY then

						if CustomRespawn_RespawnList[n].MapTX == -1 or CustomRespawn_RespawnList[n].MapTX >= UserDeathMapX then

							if CustomRespawn_RespawnList[n].MapTY == -1 or CustomRespawn_RespawnList[n].MapTY >= UserDeathMapY then

								local UserRespawnMap = CustomRespawn_RespawnList[n].RespawnMap
								local UserRespawnMapX = CustomRespawn_RespawnList[n].RespawnMapSX
								local UserRespawnMapY = CustomRespawn_RespawnList[n].RespawnMapSY

								if CustomRespawn_RespawnList[n].RespawnMapTX > CustomRespawn_RespawnList[n].RespawnMapSX then

									UserRespawnMapX = math.random(CustomRespawn_RespawnList[n].RespawnMapSX,CustomRespawn_RespawnList[n].RespawnMapTX)

								end

								if CustomRespawn_RespawnList[n].RespawnMapTY > CustomRespawn_RespawnList[n].RespawnMapSY then

									UserRespawnMapY = math.random(CustomRespawn_RespawnList[n].RespawnMapSY,CustomRespawn_RespawnList[n].RespawnMapTY)

								end

								SetObjectMap(aIndex,UserRespawnMap)

								SetObjectMapX(aIndex,UserRespawnMapX)

								SetObjectMapY(aIndex,UserRespawnMapY)

							end

						end

					end

				end

			end

		end

	end

end