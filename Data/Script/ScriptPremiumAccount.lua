PremiumAccount_SystemSwitch = 1

CardIndex = {}

CardName = {}

CardIndex[1] = 7279

CardIndex[2] = 7280

CardIndex[3] = 7281

CardName[1] = "Premium Card Bronze"

CardName[2] = "Premium Card Silver"

CardName[3] = "Premium Card Gold"


ScriptLoader_AddOnCommandManager("PremiumAccount_OnCommandManager")

ScriptLoader_AddOnCharacterEntry("PremiumAccount_OnCharacterEntry")


function PremiumAccount_OnCharacterEntry(aIndex)

	if PremiumAccount_SystemSwitch == 1 then
	
		--NoticeSend(aIndex,1,string.format("VIP Date: %d.",GetObjectAccountExpireDate(aIndex)))
	
		--To produce a date table, we use the format string "*t". For instance, the following code

		--temp = os.date("*t", 906000490)
		--produces the table
		--{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
		--hour = 23, min = 48, sec = 10, isdst = false}
	 
	 
	
	end

end


function PremiumAccount_OnCommandManager(aIndex,code,arg)

	if PremiumAccount_SystemSwitch == 1 then

		if code == 260 then

			local Argument = CommandGetArgNumber(arg,0)
			
			if Argument == 1 or Argument == 2 or Argument == 3 then
			
				if InventoryGetItemCount(aIndex,CardIndex[Argument],-1) >= 1 then
				
					PremiumAccount_Upgrade(aIndex,Argument)
				
				else
				
					NoticeSend(aIndex,1,string.format("You don't have %s.",CardName[Argument]))
					
					NoticeSend(aIndex,1,"Please buy the card in Webshop on www.wykopmu.pl")
	
				end

			else
			
				NoticeSend(aIndex,1,"Type: '/buypremium x' x - level of VIP: 1, 2 or 3")

			end
	
		elseif code == 261 then

			local AccountLevel = GetObjectAccountLevel(aIndex)
			
			if AccountLevel >= 2 then										--Vip level 2 do dye

				UniqueSets_DyeItemCommand(aIndex)
				
			else
				
				NoticeSend(aIndex,1,"You need at least Vip 2 to dye items.")
			
			end
		
		elseif code == 262 then

			UniqueSets_UndyeItemCommand(aIndex)

		end
		
		return 1
	
	end

end


function PremiumAccount_Upgrade(aIndex,bLevel)

	InventoryDelItemCount(aIndex,CardIndex[bLevel],-1,1)

	UserSetAccountLevel(aIndex,bLevel,2680000)
	
	EffectAdd(aIndex,0,8,3600,0,0,0,0)
	
	local MapX = GetObjectMapX(aIndex)
	
	local MapY = GetObjectMapY(aIndex)
	
	FireworksSend(aIndex,MapX+2,MapY+2)
	
	FireworksSend(aIndex,MapX-2,MapY+2)
	
	FireworksSend(aIndex,MapX+2,MapY-2)
	
	FireworksSend(aIndex,MapX-2,MapY-2)
	
	NoticeSend(aIndex,0,string.format("You have upgraded your account to VIP %d!",bLevel))
	



	--LogPrint(aString)
	
	
	--UserSetAccountLevel(aIndex,aValue,bValue)

	--aIndex = User index.
	--aValue = Account level.
	--bValue = Account expire time, in seconds.
	
	
	
	--GetObjectAccountLevel(aIndex)
	--aIndex = Object index.
	--Return object account level.
 
	--GetObjectAccountExpireDate(aIndex)
	--aIndex = Object index.
	--Return object account expire date.
end