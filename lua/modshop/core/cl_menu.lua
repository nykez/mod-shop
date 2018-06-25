
local PANEL = {}

-- function PANEL:Init()
-- 	self:SetSize(ScrW(), ScrH())
-- 	self:MakePopup()

-- 	self:TDLib():Background(Color(35, 35, 35)):Gradient(Color(28, 28, 28))


-- 	self.Navigation = self:Add('DScrollPanel')
-- 	self.Navigation:Dock(LEFT)
-- 	self.Navigation:SetWide(200)
-- 	self.Navigation:DockMargin(0, 5, 0, 0)
-- 	self.Navigation:TDLib():Background(Color(34, 34, 34)):Outline(Color(60, 60, 60))

-- 	self.Options = self:Add('DScrollPanel')
-- 	self.Options:Dock(LEFT)
-- 	self.Options:SetWide(250)
-- 	self.Options:TDLib():Background(Color(34, 34, 34)):Outline(Color(60, 60, 60))

-- 	self.cats = {}
-- 	self.options = {}


-- 	for k,v in pairs(modshop.cats) do
-- 		self.cats[k] = self.Navigation:Add('DButton')
-- 		self.cats[k]:Dock(TOP)
-- 		self.cats[k]:SetText(k)
-- 		self.cats[k]:DockMargin(5, 5, 5, 0)
-- 		self.cats[k]:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50)):FadeHover()
-- 		self.cats[k]:SetTextColor(color_white)

-- 		table.sort(v, function( a, b ) return a.price > b.price end )

-- 		for i, data in SortedPairsByMemberValue(v, "price") do
-- 			//if self.options[data.unique] thenthen continue end

-- 			if self.options[data.unique] then
-- 				local list = self.options[data.unique].list

-- 				if data.onCalled then
-- 					data.onCalled(list)
-- 				end

-- 			else
-- 				self.options[data.unique] = self.Options:Add('DCollapsibleCategory')
-- 				self.options[data.unique]:Dock(TOP)
-- 				self.options[data.unique]:SetLabel(data.unique)
-- 				self.options[data.unique]:DockMargin(5, 5, 5, 0)
-- 				self.options[data.unique]:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50))
-- 				local parent = self.options[data.unique]

-- 				parent.list = vgui.Create( "DPanelList", parent )
-- 				parent.list:SetSpacing( 5 )
-- 				parent.list:EnableHorizontal( false )
-- 				parent.list:EnableVerticalScrollbar( true )
-- 				parent:SetContents( parent.list )		

-- 				if data.onCalled then
-- 					data.onCalled(parent.list)
-- 				end
-- 			end
-- 		end

-- 	end

-- 	local exit_btn = self.Navigation:Add("DButton")
-- 	exit_btn:Dock(TOP)
-- 	exit_btn:DockMargin(3, 50, 3, 0)
-- 	exit_btn:TDLib():Background(Color(46, 204, 113)):FadeHover()
-- 	exit_btn:SetTextColor(color_white)
-- 	exit_btn:SetText("Exit")
-- 	exit_btn:On('DoClick', function(s)
-- 		self:Remove()
-- 	end)

-- end


function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Gradient(Color(28, 28, 28))

	self.docker = self:Add("ModSheet")
	self.docker:Dock(FILL)


	local categories = {}

	for k, v in pairs(modshop.cats) do
		if categories[k] then continue end 

		categories[k] = self.docker:Add('DPanel')
		local pnl = categories[k]
		pnl:Dock(FILL)

		
		local desc;
		

		for i, data in SortedPairsByMemberValue(v, "price") do
			//if categories[k][data.unique] then continue end

			if data.desc then
				desc = data.desc
			end

			if categories[k][data.unique] then
				local list = categories[k][data.unique].list

				if data.onCalled then
					data.onCalled(list)
				end

				local childs = list:GetChildren()

				for k,v in pairs(childs) do
					local className = v:GetClassName()

					if (className == "Label") then
						v:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50)):FadeHover()
						v:SetTextColor(color_white)
						v:DockMargin(0, 3, 0, 0)
					end
				end
	
			else
				categories[k][data.unique] = categories[k][data.unique] or {}

				categories[k][data.unique] = pnl:Add('DCollapsibleCategory')
				categories[k][data.unique]:Dock(TOP)
				categories[k][data.unique]:SetLabel(data.unique)
				categories[k][data.unique]:DockMargin(5, 8, 5, 0)
				categories[k][data.unique]:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50))
				local parent = categories[k][data.unique]

				parent.list = vgui.Create( "DPanelList", parent )
				parent.list:SetSpacing( 5 )
				parent.list:EnableHorizontal( false )
				parent.list:EnableVerticalScrollbar( true )
				parent:SetContents( parent.list )		

				if data.onCalled then
					data.onCalled(parent.list)
				end
			end



		
		end

		self.docker:AddSheet(k, pnl, desc)

	end

end

function PANEL:Think()
	if input.IsKeyDown(KEY_F2) then
		self:Remove()
	end
end

vgui.Register("Modshopmain", PANEL, "EditablePanel")

concommand.Add("modshop", function()
	-- if modshop then
	-- 	modshop:Remove()
	-- end

	testmenu = vgui.Create("Modshopmain")

end)