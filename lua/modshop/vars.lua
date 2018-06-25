
// You can define different options for the editor to use //
// Vehicle will be passed by arguement //
// Not recommend to edit or change unless you know what you're doing //

modshop.vars = modshop.vars or {}
modshop.cats = modshop.cats or {}


function modshop.RegisterVar(tblData)
	modshop.vars[tblData.indentifer] = tblData

	if not modshop.cats[tblData.category] then
		modshop.cats[tblData.category] = {}
	end

	modshop.cats[tblData.category][tblData.indentifer] = tblData
end


modshop.RegisterVar({
	category = "Engine",
	unique = "Engine Tunning",
	desc = "Increases horsepower by 25.",
	name = "Stage I",
	indentifer = "engine_stage1",
	price = 1,
	onSpawn = function(pPlayer, entVehicle)
		// No need to validate user or permissions
		// Both argumenets are validated by reference

		local params = entVehicle:GetVehicleParams()

		params.engine.horsepower = params.engine.horsepower + 25

		entVehicle:SetVehicleParams(params)

	end,
	onCalled = function(parent, dad)
		local dpanel = parent:Add("DButton")
		dpanel:Dock(TOP)
		dpanel:SetText("Stage I ($1)")
	
	end,
})

modshop.RegisterVar({
	category = "Engine",
	unique = "Engine Tunning",
	name = "Stage 2",
	indentifer = "engine_stage2",
	desc = "Increase horsepower by 35.",
	price = 5,	
	onSpawn = function(pPlayer, entVehicle)
		// No need to validate user or permissions
		// Both argumenets are validated by reference

		local params = entVehicle:GetVehicleParams()

		params.engine.horsepower = params.engine.horsepower + 35

		entVehicle:SetVehicleParams(params)
	end,
	onCalled = function(parent, dad)
		local dpanel = parent:Add("DButton")
		dpanel:Dock(TOP)
		dpanel:SetText("Stage II")		
	end,
})

modshop.RegisterVar({
	category = "Engine",
	unique = "Engine Tunning",
	name = "Stage 3",
	indentifer = "engine_stage3",
	desc = "Increase horsepower by 50.",
	price = 500,	
	onSpawn = function(pPlayer, entVehicle)
		// No need to validate user or permissions
		// Both argumenets are validated by reference
		local params = entVehicle:GetVehicleParams()

		params.engine.horsepower = params.engine.horsepower + 50

		entVehicle:SetVehicleParams(params)
	end,
	
	onCalled = function(parent, dad)
		local dpanel = parent:Add("DButton")
		dpanel:Dock(TOP)
		dpanel:SetText("Stage III")		
	end,
})

-- modshop.RegisterVar({
-- 	category = "Engine",
-- 	unique = "Nitrous",
-- 	name = "Stage 1",
-- 	indentifer = "engine_nitro1",
-- 	price = 35000,	
-- 	onSpawn = function(pPlayer, entVehicle, index, tblExtra)
-- 		// No need to validate user or permissions
-- 		// Both argumenets are validated by reference
-- 	end,
-- 	onCalled = function(parent, dad)
-- 		local dpanel = parent:Add("DPanel")
-- 		dpanel:Dock(FILL)

-- 		parent:SetContents( dpanel )		
-- 	end,
-- })

modshop.RegisterVar({
	category = "Body",
	unique = "Color",
	name = "Choose your color",
	indentifer = "body_color",
	price = 0,
	useExtra = true,
	onSpawn = function(pPlayer, entVehicle, index, tblExtra)
		entVehicle:SetColor(tblExtra)
	end,
	onCalled = function(parent, dad)
		-- local dpanel = parent:Add("DPanel")
		-- dpanel:Dock(FILL)

		local DermaColorCombo = parent:Add('DColorCombo')
		DermaColorCombo:Dock(TOP)
		DermaColorCombo:DockMargin(0, 0, 0, 5)
		DermaColorCombo:SetColor( Color( 255, 255, 255 ) )

		local dbutton = parent:Add('DButton')
		dbutton:Dock(TOP)
		dbutton:DockMargin(5, 1, 5, 5)
		dbutton:SetText("Purchase")
		dbutton:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50)):FadeHover()
		dbutton:SetTextColor(color_white)

		
	end,
})