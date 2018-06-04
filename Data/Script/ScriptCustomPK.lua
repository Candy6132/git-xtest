CustomPK_SystemSwitch = 1

CustomPK_PKList = {}


ScriptLoader_AddOnReadScript("CustomPK_OnReadScript")

ScriptLoader_AddOnCheckUserKiller("CustomPK_OnCheckUserKiller")


function CustomPK_OnReadScript()

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

	if CustomRespawn_SystemSwitch ~= 0 then

		local KillerMap = GetObjectMap(aIndex)
		local KillerMapX = GetObjectMapX(aIndex)
		local KillerMapY = GetObjectMapY(aIndex)

		for n=1,#CustomPK_PKList,1 do

			if CustomPK_PKList[n].Map == KillerMap then

				if CustomPK_PKList[n].MapSX == -1 or CustomPK_PKList[n].MapSX <= KillerMapX then

					if CustomPK_PKList[n].MapSY == -1 or CustomPK_PKList[n].MapSy <= KillerMapY then

						if CustomPK_PKList[n].MapTX == -1 or CustomPK_PKList[n].MapTX >= KillerMapX then

							if CustomPK_PKList[n].MapTY == -1 or CustomPK_PKList[n].MapTY >= KillerMapY then

								return 0

							end

						end

					end

				end

			end

		end

	end

	return 1

end