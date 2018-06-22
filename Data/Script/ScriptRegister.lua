Register_SystemSwitch = 1

Register_CharTimer = {}

Register_CharTimer[1] = 15

Register_CharTimer[2] = 15

Register_CharTimer[3] = 15

Register_CharTimer[4] = 15

Register_CharTimer[5] = 15

Register_CharTimer[6] = 15

Register_CharTimer[7] = 15

Register_CharTimer[8] = 15

Register_CharTimer[9] = 15

Register_CharTimer[10] = 15


Register_RegisterCharacterName = {}

Register_RegisterCharacterName[1] = "Register1"

Register_RegisterCharacterName[2] = "Register2"

Register_RegisterCharacterName[3] = "Register3"

Register_RegisterCharacterName[4] = "Register4"

Register_RegisterCharacterName[5] = "Register5"

Register_RegisterCharacterName[6] = "Register6"

Register_RegisterCharacterName[7] = "Register7"

Register_RegisterCharacterName[8] = "Register8"

Register_RegisterCharacterName[9] = "Register9"

Register_RegisterCharacterName[10] = "Register10"



ScriptLoader_AddOnCharacterEntry("Register_OnCharacterEntry")

ScriptLoader_AddOnTimerThread("Rgister_OnTimerThread")

ScriptLoader_AddOnCharacterClose("Rgister_OnCharacterClose")

ScriptLoader_AddOnCommandManager("Rgister_OnCommandManager")

ScriptLoader_AddOnReadScript("Register_OnReadScript")




function Register_OnReadScript()

	local SQL_ODBC = "MuOnline"

	local SQL_USER = ""

	local SQL_PASS = ""

	SQLConnect(SQL_ODBC,SQL_USER,SQL_PASS)

end


function Rgister_OnCommandManager(aIndex,code,arg)

	local RegisterPermission = 0

	if Register_SystemSwitch == 1 then
	
		if code == 250 then

			local CharacterName = GetObjectName(aIndex)
		
			for n=1,#Register_RegisterCharacterName,1 do
		
				if CharacterName == Register_RegisterCharacterName[n] then
				
					Argument0 = CommandGetArgNumber(arg,0)
					
					Argument1 = CommandGetArgNumber(arg,1)
					
					Argument2 = CommandGetArgNumber(arg,2)
				
					if Argument0 ~= nil and Argument1 ~= nil and Argument2 ~= nil then
					
						Register_Execute(aIndex,Argument0,Argument1,Argument2)
						
						return 1
			
					else
			
						NoticeSend(aIndex,0,"invalid register data")
			
					end
					
				end
				
			end
		
		end
		
	end
	
	return 0

end



function Register_Execute(aIndex,Argument0,Argument1,Argument2)

	if SQLQuery(string.format("INSERT INTO MEMB_INFO (memb___id, memb__pwd, memb_name, sno__numb, bloc_code, ctl1_code, mail_chek, mail_addr, appl_days, modi_days, out__days, true_days, fpas_ques, fpas_answ) VALUES ('%s','%s','%s','123456','0','0','0','%s','','','','','','')",Argument0,Argument1,Argument0,Argument2)) == 0 then
	
		NoticeSend(aIndex,0,"invalid register data")
		
	end

	SQLClose()

end

function Register_OnCharacterEntry(aIndex)

	if Register_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)
		
		for n=1,#Register_RegisterCharacterName,1 do
		
			if CharacterName == Register_RegisterCharacterName[n] then
			
				--NoticeSend(aIndex,0,string.format("--------------------"))
				
				NoticeSend(aIndex,0,"THIS IS REGISTER ACCOUNT")
				
				NoticeSend(aIndex,0,"TYPE /register <login> <password> <email>")
				
			end
			
		end
	end
	
end



function Rgister_OnCharacterClose(aIndex)
	
	if Register_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)
		
		for n=1,#Register_RegisterCharacterName,1 do
		
			if CharacterName == Register_RegisterCharacterName[n] then
			
				Register_CharTimer[n] = 15
				
			end
			
		end
	
	end	

end



function Register_OnTimerThread()

	if Register_SystemSwitch == 1 then

		for n=1,#Register_CharTimer,1 do

			Register_CharTimer[n] = Register_CharTimer[n]-1
		
			local RegisterCharIndex = GetObjectIndexByName(Register_RegisterCharacterName[n])
		
			if Register_CharTimer[n] <= 0 then
		
				UserDisconnect(RegisterCharIndex)
			
				Register_CharTimer[n] = 15
		
			else
		
				NoticeSend(RegisterCharIndex,1,string.format("You will be disconnecterd in: %d",Register_CharTimer[n]))
		
			end
	
		end
	
	end
end

