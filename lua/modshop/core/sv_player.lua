
modshop.player = modshop.player or {}

function modshop.player.PurchaseUpgrade(pPlayer, indexUpgrade, entVehicle, extra)
	if not IsValid(pPlayer) then return end

	if not IsValid(entVehicle) then return end
	
	local upgrade = modshop.vars[indexUpgrade]

	if (!upgrade) then 
		print("Can't find a vehicle index to use.")
		return 
	end

	
	if !modshop.currency.CanAfford(pPlayer, upgrade.price) then
		pPlayer:PrintMessage(HUD_PRINTTALK, "You can't afford this upgrade.")
		return
	end

	local mdlVehicle = entVehicle:GetModel()

	if pPlayer.modshop and pPlayer.modshop[mdlVehicle] then
		if upgrade.useExtra then
			pPlayer.modshop[mdlVehicle] = pPlayer.modshop[mdlVehicle] or {}
			pPlayer.modshop[mdlVehicle][upgrade.unique] = {upgrade.indentifer,  extra = extra}
		else
			pPlayer.modshop[mdlVehicle] = pPlayer.modshop[mdlVehicle] or {}
			pPlayer.modshop[mdlVehicle][upgrade.unique] = upgrade.indentifer
		end
	else
		pPlayer.modshop = pPlayer.modshop or {}
		pPlayer.modshop[mdlVehicle] = pPlayer.modshop[mdlVehicle] or {}
		if upgrade.useExtra then
			pPlayer.modshop[mdlVehicle][upgrade.unique] = {upgrade.indentifer,  extra = extra}
		else
			pPlayer.modshop[mdlVehicle][upgrade.unique] = upgrade.indentifer
		end
	end

	if upgrade.onPurchase then
		upgrade.onPurchase(pPlayer, mdlVehicle, upgrade.unique, extra)
	end

	modshop.currency.AddMoney(pPlayer, -upgrade.price)
	modshop.player.Save(pPlayer)

	pPlayer:PrintMessage(HUD_PRINTTALK, "You succesfully purchased your upgrade.")

	modshop.player.ProcessUpgrades(pPlayer, entVehicle)
end

function modshop.player.Save(pPlayer)
	if not pPlayer then return end
	if not pPlayer.modshop then return end
		
	local ourVehicleData = util.TableToJSON(pPlayer.modshop)

	local queryObj = mysql:Select("modshop_data")
	queryObj:Where("steam_id", pPlayer:SteamID())
	queryObj:Callback(function(result, status, lastID)
		if (type(result) == "table" and #result > 0) then

			local updateObj = mysql:Update("modshop_data")
			updateObj:Update("data", ourVehicleData)
			updateObj:Where("steam_id", pPlayer:SteamID())
			updateObj:Execute();
		else

			local insertObj = mysql:Insert("modshop_data")
			insertObj:Insert("steam_id", pPlayer:SteamID())
			insertObj:Insert("data", ourVehicleData)
			insertObj:Execute();
		end

	end)
	queryObj:Execute();
end

function modshop.player.Load(pPlayer)
	if not pPlayer then return end
	
	local queryObj = mysql:Select("modshop_data")
	queryObj:Where("steam_id", pPlayer:SteamID())
	queryObj:Callback(function(result, status, lastID)
		if (type(result) == "table" and #result > 0) then
			if result[1].data then
				local ourUpgrades = util.JSONToTable(result[1].data)
				pPlayer.modshop = ourUpgrades
			end
		end
	end)
	queryObj:Execute();
end

function modshop.player.ProcessUpgrades(pPlayer, entVehicle)
	if (!entVehicle) then return end
	
	local mdlVehicle = entVehicle:GetModel()


	for k,v in pairs(pPlayer.modshop[mdlVehicle]) do
		if (type(v) == 'table') then
			local ourUpgrade = modshop.vars[v[1]]
			if ourUpgrade.onSpawn then
				ourUpgrade.onSpawn(pPlayer, entVehicle, ourUpgrade.indentifer, v.extra)
			end
		else
			local ourUpgrade = modshop.vars[v]

			if ourUpgrade.onSpawn then
				if ourUpgrade.indentifer then
					ourUpgrade.onSpawn(pPlayer, entVehicle, ourUpgrade.indentifer)
				else
					ourUpgrade.onSpawn(pPlayer, entVehicle)
				end
			end
		end
	end

	pPlayer:PrintMessage(HUD_PRINTTALK, "Your upgrades have been applied to your vehicle.")
end

hook.Add("PlayerSpawnedVehicle", "modshop_processvehicle", function(pPlayer, entVehicle)
	local mdlVehicle = entVehicle:GetModel()

	if pPlayer.modshop and pPlayer.modshop[mdlVehicle] then
		modshop.player.ProcessUpgrades(pPlayer, entVehicle)
	end
end)

hook.Add("PlayerInitialSpawn", "modshop_loadplayervehicles", function(pPlayer)
	timer.Simple(5, function()
		if !IsValid(pPlayer) then return end
		modshop.player.Load(pPlayer)
	end)
end)

concommand.Add("purchase_mod", function(pPlayer)
	local entVehicle = pPlayer:GetEyeTrace().Entity
	if !entVehicle:IsVehicle() then return end
	
	modshop.player.PurchaseUpgrade(pPlayer, "body_color", entVehicle, Color(139, 193, 0))
end)