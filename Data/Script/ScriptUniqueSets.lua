Hex = {}

Hex[0] = "0"

Hex[1] = "1"

Hex[2] = "2"

Hex[3] = "3"

Hex[4] = "4"

Hex[5] = "5"

Hex[6] = "6"

Hex[7] = "7"

Hex[8] = "8"

Hex[9] = "9"

Hex[10] = "A"

Hex[11] = "B"

Hex[12] = "C"

Hex[13] = "D"

Hex[14] = "E"

Hex[15] = "F"


LargeVialIndex = 7734


DyableItem = {}

DyableItem[1] = 3601

DyableItem[2] = 3602

DyableItem[3] = 3603

DyableItem[4] = 3612

DyableItem[5] = 3626

DyableItem[6] = 4113

DyableItem[7] = 4114

DyableItem[8] = 4115

DyableItem[9] = 4116

DyableItem[10] = 4124

DyableItem[11] = 4138

DyableItem[12] = 4625

DyableItem[13] = 4626

DyableItem[14] = 4627

DyableItem[15] = 4628

DyableItem[16] = 4636

DyableItem[17] = 4650

DyableItem[18] = 5137

DyableItem[19] = 5138

DyableItem[20] = 5139

DyableItem[21] = 5140

DyableItem[22] = 5148

DyableItem[23] = 5162

DyableItem[24] = 5649

DyableItem[25] = 5650

DyableItem[26] = 5651

DyableItem[27] = 5652

DyableItem[28] = 5660

DyableItem[29] = 5674


UniqueItem = {}

UniqueItem[1] = 3701

UniqueItem[2] = 3702

UniqueItem[3] = 3703

UniqueItem[4] = 3712

UniqueItem[5] = 3726

UniqueItem[6] = 4213

UniqueItem[7] = 4214

UniqueItem[8] = 4215

UniqueItem[9] = 4216

UniqueItem[10] = 4224

UniqueItem[11] = 4238

UniqueItem[12] = 4725

UniqueItem[13] = 4726

UniqueItem[14] = 4727

UniqueItem[15] = 4728

UniqueItem[16] = 4736

UniqueItem[17] = 4750

UniqueItem[18] = 5237

UniqueItem[19] = 5238

UniqueItem[20] = 5239

UniqueItem[21] = 5240

UniqueItem[22] = 5248

UniqueItem[23] = 5262

UniqueItem[24] = 5749

UniqueItem[25] = 5750

UniqueItem[26] = 5751

UniqueItem[27] = 5752

UniqueItem[28] = 5760

UniqueItem[29] = 5774




ScriptLoader_AddOnReadScript("CustomQuest_OnReadScript")




function CustomQuest_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
	


end




function UniqueSets_DyeItem(aIndex)

	if InventoryGetItemCount(aIndex,LargeVialIndex,-1) >= 1 then				--Large Vial of Dye - dowolny level itemu (-1)

		local ItemIndex = InventoryGetItemIndex(aIndex,12)
		
		local AllowDye = 0
		
		for n=1,#DyableItem,1 do
		
			if ItemIndex == DyableItem[n] then
			
				AllowDye = 1
				
			end
		
		end
		
		local CharacterName = GetObjectName(aIndex)
			
		if SQLQuery(string.format("SELECT Inventory FROM Character WHERE Name='%s'",CharacterName)) == 0 or SQLFetch() == 0 then
		
			SQLClose()
			
			if SQLCheck() == 0 then
			
				local SQL_ODBC = "MuOnline"

				local SQL_USER = ""

				local SQL_PASS = ""

				SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)
			
			end
			
			LogPrint(string.format("UniqueSets: Failed to read inventory for %s",CharacterName))

			LogColor(1,string.format("UniqueSets: Failed to read inventory for %s",CharacterName))
			
			NoticeSend(aIndex,1,"Failed to dye the item. Try again or contact the Administrator.")
		
		else
		
			local InventoryHex = tostring(SQLGetString("Inventory"))
			
			SQLClose()
		
			InventoryHex = string.sub(InventoryHex,387,32)
		
		
		------------
		
			NoticeSend(aIndex,1,string.format("InventoryHex: %s",InventoryHex))
			
		------------
		
		
		
		
		
			if AllowDye == 1 then
			
			else
		
				NoticeSend(aIndex,1,"This item cannot be dyed.")
			
				NoticeSend(aIndex,1,"Place the item in top left corner of your inventory, relog and retry.")
		
			end
		
		end
		
	else
	
		NoticeSend(aIndex,1,"You don't have a Large Vial of Dye, to dye this item.")
		
	end

end


function UniqueSets_UndyeItem(aIndex)

end




function UniqueSets_HexToDec(aString)

	local Number = 0

	for n=1,#aString,1 do
	
		for i=0,15,1 do
		
			if string.sub(aString,n,1) == Hex[i] then
			
				Number = Number + (i * 16^(#aString-n))
			
			end		
		
		end
	
	end
	
	return Number

end













