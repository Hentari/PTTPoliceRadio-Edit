ESX = nil

local playerJob = nil

-- playerJob.name
-- playerJob.grade_name

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerJob = xPlayer.job
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	playerJob = job
end)

local holstered = true

local skins = {
	"mp_f_freemode_01",
	"mp_m_freemode_01"

}

local weapons = {
	"WEAPON_PISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_NIGHTSTICK",
	"WEAPON_FLASHLIGHT",
}

-- RADIO ANIMATIONS --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and IsServiceJob() then
			if not IsPauseMenuActive() then 
				loadAnimDict( "random@arrests" )
				if GetLastInputMethod(2) and IsControlJustReleased( 0, 19 ) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
					ClearPedTasks(ped)
					SetEnableHandcuffs(ped, false)
					Wait(1000)
				else
					if GetLastInputMethod(2) and IsControlJustPressed( 0, 19 ) and IsServiceJob() and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming (ped) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						SetEnableHandcuffs(ped, true)
					elseif GetLastInputMethod(2) and IsControlJustPressed( 0, 19 ) and IsServiceJob() and IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming (ped) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						SetEnableHandcuffs(ped, true)
					end 
					if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
						DisableActions(ped)
					elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
						DisableActions(ped)
					end
				end
			end 
		end 
	end
end )
 
---Weapon Services
  Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(0)
 		local ped = PlayerPedId()
 		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and IsServiceJob() and not IsPedInParachuteFreeFall (ped) then
 			loadAnimDict( "rcmjosh4" )
 			loadAnimDict( "weapons@pistol@" )
 			if CheckWeapon(ped) then
 				if holstered then
 					TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
 					Citizen.Wait(600)
 					ClearPedTasks(ped)
 					holstered = false
 				end
 			elseif not CheckWeapon(ped) then
 				if not holstered then
 					TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
 					Citizen.Wait(500)
 					ClearPedTasks(ped)
 					holstered = true
 				end
 			end
 		end
 	end
 end)


 ---Weapon Civilians
 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and not IsServiceJob() and not IsPedInParachuteFreeFall (ped) then
			loadAnimDict("reaction@intimidation@1h")
			loadAnimDict("weapons@pistol_1h@gang")
			if CheckWeapon(ped) then
				if holstered then
					TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
					Citizen.Wait(2500)
					ClearPedTasks(ped)
					holstered = false
				end
			elseif not CheckWeapon(ped) then
				if not holstered then
					TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
					Citizen.Wait(1500)
					ClearPedTasks(ped)
					holstered = true
				end
			end
		end
	end
end)

-- DO NOT REMOVE THESE! --

function CheckSkin(ped)
	for i = 1, #skins do
		if GetHashKey(skins[i]) == GetEntityModel(ped) then
			return true
		end
	end
	return false
end

function IsServiceJob()
	if playerJob ~= nil then
		if playerJob.name == 'police' or playerJob.name == 'ambulance' then
			return true
		end
	end

	return false
end

function CheckWeapon(ped)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 2000 )
	end
end