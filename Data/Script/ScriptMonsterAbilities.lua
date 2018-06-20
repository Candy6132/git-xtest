MonsterAbilities_SystemSwitch = 1

MonsterAbilities_MainTimer = 0

MonsterAbilities_SummonedMonster1 = {}

MonsterAbilities_SummonedMonster2 = {}

MonsterAbilities_SummonedMonster3 = {}

MonsterAbilities_LordAbilityCooldown = {}

--MonsterAbilities_SummonedMonsterLord = {}

MonsterAbilities_AbilityCooldown = {}

MonsterAbilities_EffectNumber = {}

MonsterAbilities_LordEffectTime = {}

IceQueen = 25

IceMonster = 21

MonsterAbilities_AbilityCooldown[IceQueen] = 3

MonsterAbilities_EffectNumber[IceQueen] = 4

MonsterAbilities_LordEffectTime[IceQueen] = 0

function CustomQuest_OnReadScript()

	ScriptLoader_OnTimerThread("MonsterAbilities_OnTimerThread")
	
	ScriptLoader_OnCheckUserTarget("MonsterAbilities_OnCheckUserTarget")
	
	ScriptLoader_OnMonsterDie("MonsterAbilities_OnMonsterDie")
	
	math.randomseed(os.time())

end


function MonsterAbilities_OnTimerThread()

	MonsterAbilities_MainTimer = MonsterAbilities_MainTimer + 1
	
end

function OnCheckUserTarget(aIndex,bIndex)

	if MonsterAbilities_SystemSwitch == 1 then

		if GetObjectClass(bIndex) == IceQueen then
	
			if MonsterAbilities_LordAbilityCooldown[bIndex] == nil then
			
				MonsterAbilities_LordAbilityCooldown[bIndex] = MonsterAbilities_MainTimer
			
			elseif MonsterAbilities_MainTimer-MonsterAbilities_LordAbilityCooldown[bIndex] >= MonsterAbilities_Ability1Cooldown[IceQueen] then
			
				local LordMap = GetObjectMap(bIndex)
			
				local LordMapX = GetObjectMapX(bIndex)
				
				local LordMapY = GetObjectMapY(bIndex)
			
				if MonsterAbilities_SummonedMonster1[bIndex] == nil then
				
					MonsterCreate(IceMonster,LordMap,math.random(LordMapX-4,LordMapX+4),math.random(LordMapY-4,LordMapY+4),1)
					
					NoticeSend(GetObjectIndexByName("Candy"),1,string.format("Max Index: %d",GetMaxMonsterIndex()))
					
					MonsterAbilities_SummonedMonster1[bIndex] = 1
					
					MonsterAbilities_LordAbilityCooldown[bIndex] = MonsterAbilities_MainTimer

				elseif MonsterAbilities_SummonedMonster2[bIndex] == nil then
				
					MonsterCreate(IceMonster,LordMap,math.random(LordMapX-4,LordMapX+4),math.random(LordMapY-4,LordMapY+4),1)
					
					NoticeSend(GetObjectIndexByName("Candy"),1,string.format("Max Index: %d",GetMaxMonsterIndex()))
					
					MonsterAbilities_SummonedMonster2[bIndex] = 1
					
					MonsterAbilities_LordAbilityCooldown[bIndex] = MonsterAbilities_MainTimer
				
				elseif MonsterAbilities_SummonedMonster3[bIndex] == nil then
					
					MonsterCreate(IceMonster,LordMap,math.random(LordMapX-4,LordMapX+4),math.random(LordMapY-4,LordMapY+4),1)
					
					NoticeSend(GetObjectIndexByName("Candy"),1,string.format("Max Index: %d",GetMaxMonsterIndex()))
					
					MonsterAbilities_SummonedMonster3[bIndex] = 1
					
					MonsterAbilities_LordAbilityCooldown[bIndex] = MonsterAbilities_MainTimer

				end
			
			end
			
			local MonsterLifePercentage = GetObjectLife(bIndex)/GetObjectMaxLife(bIndex)*100
			
			if EffectCheck(bIndex,MonsterAbilities_EffectNumber[IceQueen]) ~= 1 and MonsterLifePercentage < 40 then
			
				EffectAdd(bIndex,0,MonsterAbilities_EffectNumber[IceQueen],MonsterAbilities_LordEffectTime[IceQueen],100,100,100,100)
				
									--EffectAdd(aIndex,aValue,bValue,cValue,dValue,eValue,fValue,gValue)
 
									--aIndex = Object index.
									--aValue = Effect mode.
									--bValue = Effect index.
									--cValue = Effect duration, in seconds.
									--dValue = Effect value 1.
									--eValue = Effect value 2.
									--fValue = Effect value 3.
									--gValue = Effect value 4.
									 
									--Add to the object the chosen effect.
			
			end
			
		end

	end
	
	return 1
	
end

function MonsterAbilities_OnMonsterDie(aIndex,bIndex)

	if MonsterAbilities_SystemSwitch == 1 then
	
		if GetObjectClass(aIndex) == IceQueen then
		
			MonsterAbilities_LordAbilityCooldown[aIndex] = nil
			
			MonsterAbilities_SummonedMonster1[aIndex] = nil
			
			MonsterAbilities_SummonedMonster2[aIndex] = nil
			
			MonsterAbilities_SummonedMonster3[aIndex] = nil
		
		end
	
	end

end