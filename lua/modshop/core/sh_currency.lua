
modshop.currency = modshop.currency or {}
modshop.currency.name = "DarkRP"

function modshop.currency.get()
	return self.name or "nil"
end

function modshop.currency.CanAfford(pPlayer, intAmount)
	if pPlayer.canAfford then
		return pPlayer:canAfford(intAmount)
	else
		return pPlayer:CanAfford(intAmount)
	end
end

if SERVER then

	function modshop.currency.AddMoney(pPlayer, intAmount)
		if pPlayer.addMoney then
			pPlayer:addMoney(intAmount)
		else
			pPlayer:AddMoney(intAmount)
		end
	end
	
end