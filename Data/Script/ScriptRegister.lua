Register_SystemSwitch = 1

Register_CharTimer = {}

Register_CharTimer[1] = 30

Register_CharTimer[2] = 30

Register_CharTimer[3] = 30

Register_CharTimer[4] = 30

Register_CharTimer[5] = 30

Register_CharTimer[6] = 30

Register_CharTimer[7] = 30

Register_CharTimer[8] = 30

Register_CharTimer[9] = 30

Register_CharTimer[10] = 30

Register_CountingTime = {}

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

ScriptLoader_AddOnTimerThread("Register_OnTimerThread")

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
				
					local Argument0 = CommandGetArgString(arg,0)
					
					local Argument1 = CommandGetArgString(arg,1)
					
					local Argument2 = CommandGetArgString(arg,2)
					
					
					if string.len(Argument0) < 5 then Argument0 = nil end

					if string.len(Argument1) < 5 then Argument1 = nil end
					
					if string.len(Argument2) < 5 then Argument2 = nil end
					
				
					if Argument0 ~= nil and Argument1 ~= nil and Argument2 ~= nil then
					
						Register_Execute(aIndex,n,Argument0,Argument1,Argument2)
						
						return 1
			
					else
			
						NoticeSend(aIndex,0,"passowrd and email must have at least 5 character")
			
					end
					
				end
				
			end
		
		end
		
	end
	
	return 0

end



function Register_Execute(aIndex,CharNumber,Argument0,Argument1,Argument2)

	if SQLQuery(string.format("INSERT INTO MEMB_INFO (memb___id, memb__pwd, memb_name, sno__numb, bloc_code, ctl1_code, mail_chek, mail_addr, appl_days, modi_days, out__days, true_days, fpas_ques, fpas_answ) VALUES ('%s','%s','%s','123456','0','0','0','%s','','','','','','')",Argument0,Argument1,Argument0,Argument2)) == 0 then
	
		NoticeSend(aIndex,0,"invalid register data")
		
	else
		
		NoticeSend(aIndex,0,"ACCOUNT SUCCESFULY CREATED")
		
		Register_CharTimer[CharNumber] = 0
		
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
				
				NoticeSend(aIndex,0,"TYPE /register yourlogin yourpassword your@mail.com")
				
				Register_CountingTime[n] = 1
				
			end
			
		end
	
	end
	
end



function Rgister_OnCharacterClose(aIndex)
	
	if Register_SystemSwitch == 1 then
	
		local CharacterName = GetObjectName(aIndex)
		
		for n=1,#Register_RegisterCharacterName,1 do
		
			if CharacterName == Register_RegisterCharacterName[n] then
			
				Register_CharTimer[n] = 30
				
				Register_CountingTime[n] = 0
				
			end
			
		end
	
	end	

end



function Register_OnTimerThread()

	if Register_SystemSwitch == 1 then

		for n=1,#Register_CharTimer,1 do

			local RegisterCharIndex = GetObjectIndexByName(Register_RegisterCharacterName[n])
		
			if Register_CharTimer[n] <= 0 then
		
				UserGameLogout(RegisterCharIndex,2)
			
				Register_CharTimer[n] = 30
		
			else
			
				if Register_CountingTime[n] == 1 then

					Register_CharTimer[n] = Register_CharTimer[n]-1
					
					NoticeSend(RegisterCharIndex,1,string.format("You will be disconnecterd in: %d",Register_CharTimer[n]))
				
				end

			end
	
		end
	
	end

end