CustomPK_SystemSwitch = 1

CustomPK_PKList = {}


ScriptLoader_AddOnCheckUserKiller("CustomPK_OnCheckUserKiller")


function CustomPK_OnCheckUserKiller(aIndex,bIndex)

	if CustomRespawn_SystemSwitch ~= 0 then

		local KillerMap = GetObjectMap(aIndex)
		local KillerMapX = GetObjectMapX(aIndex)
		local KillerMapY = GetObjectMapY(aIndex)

		if KillerMap == 2 and KillerMapX <= 232 and KillerMapX >= 215 and KillerMapY <= 92 and KillerMapY >= 78 then

			return 0

		else

			return 1

		end

	else

		return 1

	end

end