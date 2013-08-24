local bounties = {}
local tableOfKills = {}

function checkBounties( victim, weapon, killer )
	if bounties[""..victim:SteamID()..""] ~= nil then
		bounty = bounties[""..victim:SteamID()..""]
		by = nil
		if victim == killer then return end
		if bounty.by ~= killer:SteamID() then
			players = player.GetAll()
			for k,v in pairs ( players ) do
			     if bounty.by == v:SteamID() then
			     	by = v
			     	break
			     end
			end
			if by == nil then
				bounties[""..victim:SteamID()..""] = nil
				return
			end
			by:AddMoney( -bounty.amount )
			killer:AddMoney( bounty.amount )
			for k,v in pairs (players) do
				local tagcol, tag = Color(230, 20, 20, 255), "[RG Bounty] "
				local colpass, colfail = Color(20,230,20,255), Color(230,125,20,22)
				local victimcol, killercol = team.GetColor( victim:Team() ), team.GetColor( killer:Team() )
				SendText(v, tagcol, tag, killercol, killer:Nick(), colpass, " won the bounty set on ", victimcol, victim:Nick(), colpass, " for " .. UTIL_FormatMoney( bounty.amount ) .. "!" )
			end
			bounties[""..victim:SteamID()..""] = nil
		end
	end
end
hook.Add( "PlayerDeath", "checkBounties", checkBounties )

function addBounty( ply, text, public )
	if string.lower( string.sub( text, 1, 7) ) == "!bounty" then
		local args = string.Split(text, " ")
		playerName = args[2]
		local tagcol, tag = Color(230, 20, 20, 255), "[RG Bounty] "
		local colpass, colfail = Color(20,230,20,255), Color(230,125,20,22)
		money = tonumber(args[3])
		if playerName == nil or money == nil or args[4] ~= nil then
			SendText(ply, tagcol, tag, colfail, "Usage: !bounty PlayerName AmountOfMoney" )
			return ""
		end
		bountied = nil
		players = player.GetAll()
		for k,v in pairs ( players ) do
		     if v:Nick():lower():find(playerName:lower()) then
		     	bountied = v
		     	break
		     end
		end
		if bountied == nil then
			SendText( ply, tagcol, tag, colfail, "Player was not found." )
			return ""
		end
		if money > ply:GetMoney() then
			SendText( ply, tagcol, tag, colfail, "You don't have that much money! You need " .. UTIL_FormatMoney(money-ply:GetMoney()) .. " more.")
			return ""
		end
		if money <= 0 then
			SendText( ply, tagcol, tag, colfail, "Please enter a value greater than 0.")
			return ""
		end
		if money < 0.01 then
			SendText( ply, tagcol, tag, colfail, "Only a maximum of two decimal places is allowed.")
			return ""
		end
		bounties[""..bountied:SteamID()..""] = { by=ply:SteamID(), amount=money }
		for k,v in pairs ( players ) do
			local colbountied, colby = team.GetColor( bountied:Team() ), team.GetColor( ply:Team() )
			SendText( v, tagcol, tag, colby, ply:Nick(), colpass, " made a bounty on ", colbountied, bountied:Nick(), colpass, " for " .. UTIL_FormatMoney( money ) .. "!" )
		end
		return ""
	end
end
hook.Add( "PlayerSay", "addBounty", addBounty )

function SendText( pl, ... )
	local t, k, v, s
	
	t = { ... }
	
	for k, v in ipairs( t ) do
		if type( v ) == "table" then
			if v.r and v.g and v.b then
				t[ k ] = string.format( "Color(%d,%d,%d,255)", tonumber( v.r ) or 255, tonumber( v.g ) or 255, tonumber( v.b ) or 255 )
			end
		else
			t[ k ] = string.format( "%q", tostring( v ) )
		end
	end
	
	s = "chat.AddText( %s )"
	
	pl:SendLua( s:format( table.concat( t, "," ) ) )
end

local function UTIL_FormatMoney( amount )
	local negative = amount < 0
	amount = math.abs( amount )
	return Format( (!negative and "$" or "- $").."%d.%02d", math.floor(amount), math.floor( (amount-math.floor(amount))*100 ) )
end