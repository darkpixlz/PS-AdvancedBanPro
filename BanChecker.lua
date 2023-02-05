--[[

Name: DarkPixlz's Ban Plugin
About: Checks for player bans.
]]

local DS = game:GetService("DataStoreService"):GetDataStore("PreloadService-AdvancedBanPro_Bans")


local UserBanMessage = "You're banned for " -- Reason will be added on
local AccountBlacklistMessage = "[Error 2] \n Your account has been blacklisted. You are not welcome in our game."
local AccountWordBlacklist = "[Error 3] \n Sorry, but your username or display name contains a blacklisted word "
local function Check()
	print("CHECKING")
	for i, player in ipairs(game.Players:GetPlayers()) do
		local Data = DS:GetAsync(player.UserId.."_BanV1")
		if Data then
			if Data["IsBanned"] then
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
