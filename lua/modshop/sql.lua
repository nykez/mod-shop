if not SERVER then return end

local mysql_config = {
	hostname = "",

	username = "",

	password = "",

	table = "",

	port = 3306,

	module = "mysqloo"
}

// No need to edit anything below this //

modshop.sql = modshop.sql or {}
modshop.sql.firstTimeConnected = false

function modshop.sql.ConnectTo()
	mysql:SetModule(mysql_config and mysql_config.module or "sqlite")
	mysql:Connect(mysql_config.hostname, mysql_config.username, mysql_config.password, mysql_config.table, 3306);
end


hook.Add("DatabaseConnected", "modshop_databaseOnConnect", function()
	if modshop.sql.firstTimeConnected  then return end
	
	local queryObj = mysql:Create("modshop_data")
		queryObj:Create("id", "INT NOT NULL AUTO_INCREMENT")
		queryObj:Create("steam_id", "VARCHAR(25) NOT NULL")
		queryObj:Create("data", "longtext")
		queryObj:PrimaryKey("id")
	queryObj:Execute();
	modshop.sql.firstTimeConnected = true
	print('created modshop tables')
end);

hook.Add("OnReloaded", "modshop_databasereconnect", function()
	if !mysql:IsConnected() then
		modshop.sql.ConnectTo()
	end
end)


hook.Add("Initialize", "modshop_connectdatabase", function()
	timer.Simple(1, function()
		if !mysql:IsConnected() then
			modshop.sql.ConnectTo()
			if !modshop.sql.firstTimeConnected then
				modshop.sql.CreateTables()
			end
			print('[mod-shop] connected to database using ' ..mysql_config.module)
		end
	end)
end)

