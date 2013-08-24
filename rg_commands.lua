function fRGCommands( ply, text, public )
	if string.lower( string.sub( text, 1, 7) ) == "!donate" then
		ply:SendText(Color(25,250,25), "VIP is available to our supporters. To support us, go to http://www.raven-gaming.net on your browser and choose the \"VIP Donation\" tab to view available rewards. ", Color(250,25,25), "NOTE: ", Color(25,25,250), "You must be signed in through steam in the forums to receive in-game benefits.")
		return ""
	elseif string.lower( string.sub( text, 1, 4) ) == "!vip" then
		ply:SendText(Color(25,250,25), "VIP is available to our supporters. To support us, go to http://www.raven-gaming.net on your browser and choose the \"VIP Donation\" tab to view available rewards. ", Color(250,25,25), "NOTE: ", Color(25,25,250), "You must be signed in through steam in the forums to receive in-game benefits.")
		return ""
	elseif string.lower( string.sub( text, 1, 8) ) == "!getprop" then
		if not (ply:IsRGAdmin()) then return end
		local ent = ply:GetEyeTrace().Entity
		if IsValid(ent) and ent ~= game.GetWorld() and not ent:IsPlayer() then
			local propowner = ent:GetOwnerEnt()
			SendText(ply, Color(255,25,25,255), "The owner of this prop is ", team.GetColor(propowner:Team()), propowner:Nick())
		else
			SendText(ply, Color(255,25,25,255), "Can't pinpoint a prop from your aim angles.")
		end
		return ""
	elseif string.lower( string.sub( text, 1, 11) ) == "!removeprop" then
		if not (ply:IsRGAdmin()) then return end
		local ent = ply:GetEyeTrace().Entity
		if IsValid(ent) and ent ~= game.GetWorld() and not ent:IsPlayer() then
			local propowner = ent:GetOwnerEnt()
			if IsValid(propowner) then
				SendText(ply, Color(255,25,25,255), "Removing ", team.GetColor(propowner:Team()), propowner:Nick(), "'s ", Color(255,25,25,255), "prop. (This command is outdated, use the remover tool instead.)")
			else
				SendText(ply, Color(255,25,25,255), "Removing a disconnected player's prop. (This command is outdated, use the remover tool instead.)")
			end
			ent:Remove()
		else
			SendText(ply, Color(255,25,25,255), "Can't pinpoint a prop from your aim angles.")
		end
		return ""
	elseif string.lower( string.sub( text, 1, 7) ) == "!fixwep" then
		ply:SendLua("RunConsoleCommand('gm_demo', 'RGDisappearingWeaponsFix')")
		ply:SendLua("RunConsoleCommand('stop')")
		SendText(ply, Color(255,218,20,255), "RG Notification: ", Color(255,255,255,255), "Successfully fixed the invisible weapon model.")
		return ""
	end
end
hook.Add( "PlayerSay", "RGCommandsHL", fRGCommands)

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
