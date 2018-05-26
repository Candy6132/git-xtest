-- Configurações --

System_Item_Info_Way = "C:\\MuServer\\Data\\Item\\Item.txt"




-- Sistema --

System_Item_Info = { Name = {} }

function loadInfo_Item()

	local Category = 0
	local File = io.open(System_Item_Info_Way, r)

	for line in File:lines() do

		if not string.find(line, "//") and not string.sub(line, 1, 3) ~= "end" then

			if not string.find(line, " ") and not string.find(line, "	") then

				Category = line

			else

				local Pos = {}

				for i = 1, string.len(line) do

					if string.sub(line, i, i) == "\"" then

						Pos[#Pos+1] = i

					end

				end

				local Index = ""

				for i = 1, 3 do

					if string.sub(line, i, i) ~= " " and string.sub(line, i, i) ~= "	" then

						Index = Index..string.sub(line, i, i)

					end

				end

				table.insert(System_Item_Info.Name, Category..";"..string.sub(line, Pos[1]+1, Pos[2]-1)..";"..Index)

			end

		end

	end

	File:close()

end

ScriptLoader_AddOnReadScript("loadInfo_Item")



function getItem_Name(Category,Index)

	local Item = {}

	for i = 1, #System_Item_Info.Name do

		if string.sub(System_Item_Info.Name[i], 1, string.find(System_Item_Info.Name[i], ";")-1) == tostring(Category) then

			Item[#Item+1] = string.sub(System_Item_Info.Name[i], string.find(System_Item_Info.Name[i], ";")+1)

		end

	end

	for i = 1, #Item do

		if string.sub(Item[i], string.find(Item[i], ";")+1) == tostring(Index) then

			return string.sub(Item[i], 1, string.find(Item[i], ";")-1)

		end

	end

	return -1

end



function CommandGetItemName(aIndex,code,arg)

	if code ~= 130 then

		return 0

	end

	NoticeSend(aIndex,1,string.format("Nome: %s",getItem_Name(CommandGetArgNumber(arg,0),CommandGetArgNumber(arg,1))))

	return 1

end

ScriptLoader_AddOnCommandManager("CommandGetItemName")
