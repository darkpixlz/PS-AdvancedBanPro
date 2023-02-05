local PreloadServicePluginConfig = {}

PreloadServicePluginConfig.Name = "Advanced Ban Pro"
PreloadServicePluginConfig.ShortDescription = "Ban list, DataStore Banning, Ban Checker, Appeals"
PreloadServicePluginConfig.LongDescription = "This plugin has been made to give more control over your game to you.\nThe plugin has been made from scratch to help you ban players, and immediately get them out of it.\nThe plugin is open sourced and will later have API. For now, I am accepting feature requests/bug reports in the Discord server or PreloadService Thread. "
PreloadServicePluginConfig.BackgroundImage = "" --TBA

-- // SETTINGS \\ --

----------------------------------------------------  PLEASE CONFIGURE BLOCKLIST IN THE BannedItems SCRIPT  -----------------------------------------------------------------
PreloadServicePluginConfig.ExcludedUserIDs = {
	-- Seperated by commas, who (by User ID), should not be allowed to ban people?
	1,
}

PreloadServicePluginConfig.AppealPlaceID = 0 -- Place ID of your appeal place. Configuration is required, please view the topic for more info
-- WARNING: An incorrect place ID WILL BREAK IT AND PLAYERS WILL NOT BE ABLE TO APPEAL!!
-- PLEASE TEST THIS BEFORE PUSHING TO PRODUCTION!

PreloadServicePluginConfig.BanWebhookURLs = {
	-- Add Discord webhooks here which will be fired when a player is banned.
	-- If you are being ratelimited, add more URLs. Can be blank.
}

PreloadServicePluginConfig.RunTests = false -- Enable this if something's gone wrong, it'll run tests to make sure everything works.


PreloadServicePluginConfig.BanJoinsURLs = {
	-- Add Discord webhooks here which will be fired when a player who is *banned*, joins. 
	-- Not fired for blacklisted players for now..?
	-- If you are being ratelimited, add more URLs. Can be blank.
}

PreloadServicePluginConfig.ExploitsDetectedURLs = {
	-- Add Discord webhooks here which will be fired when a player is caught exploiting to try and ban/unban
	-- or request ban information off the server.
	-- If you are being ratelimited, add more URLs. Can be blank.
}

PreloadServicePluginConfig.BanWhenExploits = true -- Ban the player if exploits are detected if true.

PreloadServicePluginConfig.ExploitsDetected = function(Player)
	--What should happen when PreloadService catches the exploiter? Ban will be handled for you if the above is true.
	-- NOTE: The request is dropped by default. Nobody is banned besides the exploiter.
end

PreloadServicePluginConfig.BanComplete = function(Player,PlayerBanned,Reason)
	-- Optionally, a function that you can run code from when a ban is complete.
	print(Player.Name.." banned "..PlayerBanned.Name.." for "..Reason.."!")
end

-- Probably more later.

return PreloadServicePluginConfig
