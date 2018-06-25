PremiumAccount_SystemSwitch = 1


ScriptLoader_AddOnCommandManager("PremiumAccount_OnCommandManager")


function PremiumAccount_OnCommandManager(aIndex,code,arg)

	if PremiumAccount_SystemSwitch == 1 then

		if code == 260 then

			local Argument = CommandGetArgString(arg,0)
			
			if Argument == 1 then
			
				if InventoryGetItemCount(aIndex,7279,-1) >= 1 then
				
					PremiumAccount_Upgrade(aIndex,1)
				
				else
				
					NoticeSend(aIndex,0,"You don't have Premium Card Bronze.")
					
					NoticeSend(aIndex,0,"Please buy the card in Webshop on www.wykopmu.pl")
	
				end
			
			elseif Argument == 2 then
			
				if InventoryGetItemCount(aIndex,7280,-1) >= 1 then
				
					PremiumAccount_Upgrade(aIndex,2)
				
				else
				
					NoticeSend(aIndex,0,"You don't have Premium Card Silver.")
					
					NoticeSend(aIndex,0,"Please buy the card in Webshop on www.wykopmu.pl")
	
				end
						
			elseif Argument == 3 then
			
				if InventoryGetItemCount(aIndex,7281,-1) >= 1 then
				
					PremiumAccount_Upgrade(aIndex,3)
				
				else
				
					NoticeSend(aIndex,0,"You don't have Premium Card Gold.")
					
					NoticeSend(aIndex,0,"Please buy the card in Webshop on www.wykopmu.pl")
	
				end
			
			else
			
				NoticeSend(aIndex,0,"Type: '/buypremium x' x - level of VIP: 1, 2 or 3")

			end
	
		end
		
		return 1
	
	end

end


function PremiumAccount_Upgrade(aIndex,bLevel)

	NoticeSend(aIndex,0,string.format("%s",GetObjectAccountExpireDate(aIndex)))



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