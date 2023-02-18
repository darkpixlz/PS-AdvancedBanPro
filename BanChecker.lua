--[[

Name: DarkPixlz's Ban Plugin
About: Checks for player bans.
]]

local DS = game:GetService("DataStoreService"):GetDataStore("PreloadService-AdvancedBanPro_Bans")

local function SafeTeleport(Player)
	local AttemptIndex = 0
	local success, result -- define pcall results outside of loop so results can be reported later on
	repeat
		success, result = pcall(function()
			return game:GetService("TeleportService"):TeleportAsync(require(script.Parent.Configuration).AppealPlaceID, {Player}) -- teleport the user in a protected call to prevent erroring
		end)
		AttemptIndex += 1
		if not success then
			task.wait(2)
		end
	until success or AttemptIndex == 25 -- stop trying to teleport if call was successful, or if retry limit has been reached


	if not success then
		warn(result) -- print the failure reason to output
	end
	return success, result
end

local UserBanMessage = "You're banned for " -- Reason will be added on
local AccountBlacklistMessage = "[Error 2] \n Your account has been blacklisted. You are not welcome in our game."
local AccountWordBlacklist = "[Error 3] \n Sorry, but your username or display name contains a blacklisted word "
local function Check()
	print("CHECKING")
	for i, player in ipairs(game.Players:GetPlayers()) do
		local Data = DS:GetAsync(player.UserId.."_BanV1")
		if Data then
			if Data["IsBanned"] then
				if Data["Appeals"]["CanAppeal"] then
					SafeTeleport(player)
					return
				end
				print("Banned "..player.Name)
				local get = DS:GetAsync(player.UserId.."_BanV1")
				player:Kick(UserBanMessage..get.Reason..". Responsible Moderator: "..Data["Moderator"])
			else 
				warn("Not banned")
				--Not banned
			end
		else
			warn("Not Found")
			--Not found in the database, new player that the server hasn't registered yet
		end

		for i, v in ipairs(require(script.Parent.BannedItems).IDs) do
			if v == player.UserId then
				player:Kick(AccountBlacklistMessage)
			end
		end
	end
end

--This new system is more efficient, and wont crash (hopefully)

local MS = game:GetService("MessagingService")

MS:SubscribeAsync("OnPlayerBanned",function()
	Check()
end)
