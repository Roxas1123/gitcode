if CLIENT then
	local window = vgui.Create( "DFrame" )
	
	if ScrW() > 640 then
		window:SetSize( ScrW()*0.9, ScrH()*0.9 )
	else
		window:SetSize( 640, 480 )
	end
	window:Center()
	window:SetTitle( "Raven-Gaming Radio Module - Powered by Pandora® Internet Radio" )
	window:SetVisible( false )
	window:MakePopup()
	window:ShowCloseButton( false )

	local rgradioloaded = false
	timer.Simple( 5, function()
		if GetConVarNumber("rg_radio_autoload") == 1 then
			local button = vgui.Create( "DButton", window )
			local html = vgui.Create( "HTML", window )
			local autoloadcheckbox = vgui.Create( "DCheckBoxLabel", window )
			
			autoloadcheckbox:SetPos( (window:GetWide() - button:GetWide()) / 2 - 60, window:GetTall() - button:GetTall() - 50 )
			autoloadcheckbox:SetText( "Autoload radio when joining server" )
			autoloadcheckbox:SetConVar( "rg_radio_autoload" )
			autoloadcheckbox:SetValue( GetConVarNumber("rg_radio_autoload") )
			autoloadcheckbox:SizeToContents()
			
			html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 90 )
			html:SetPos( 10, 30 )
			html:OpenURL( "http://www.pandora.com" )
			
			button:SetText( "Back to the game!" )
			button.DoClick = function() window:SetVisible(false) end
			button:SetSize( 100, 40 )
			button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - button:GetTall() - 10 )
			
			rgradioloaded = true
			chat.AddText( Color(230, 20, 20, 255), "[RG Radio] ", Color(0,160,255,255), "Radio module loaded. Type !radio in chat to access it!" )
		end
	end)

	function fRG_radio( player, command, arguments )
		if not rgradioloaded then			
			local button = vgui.Create( "DButton", window )
			local html = vgui.Create( "HTML", window )
			local autoloadcheckbox = vgui.Create( "DCheckBoxLabel", window )
			
			autoloadcheckbox:SetPos( (window:GetWide() - button:GetWide()) / 2 - 60, window:GetTall() - button:GetTall() - 50 )
			autoloadcheckbox:SetText( "Autoload radio when joining server" )
			autoloadcheckbox:SetConVar( "rg_radio_autoload" )
			autoloadcheckbox:SetValue( GetConVarNumber("rg_radio_autoload") )
			autoloadcheckbox:SizeToContents()
			
			html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 90 )
			html:SetPos( 10, 30 )
			html:OpenURL( "http://www.pandora.com" )
			
			button:SetText( "Back to the game!" )
			button.DoClick = function() window:SetVisible(false) end
			button:SetSize( 100, 40 )
			button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - button:GetTall() - 10 )
			
			rgradioloaded = true
			chat.AddText( Color(230, 20, 20, 255), "[RG Radio] ", Color(0,160,255,255), "Radio module loaded. Type !radio in chat to access it!" )
		end
		if not window:IsVisible() then
			window:SetVisible( true )
		else
			window:SetVisible( false )
		end
	end
	concommand.Add( "rg_radio", fRG_radio )
end

if SERVER then
	function fPandoraRadioToggle( ply, text, public )
		if string.lower( string.sub( text, 1, 6) ) == "!radio" then
			ply:ConCommand("rg_radio")
		end
	end
	hook.Add( "PlayerSay", "PandoraRadioToggle", fPandoraRadioToggle )
end