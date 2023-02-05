--- DarkPixlz 2022 ---

--- Made for PreloadService 3 ---

--- Is appealing configured? ---

local Strings = {
	["Disclaimer"] = "WARNING: Your username, date, and time is being logged. Do NOT abuse this system."
}

--- Variables ---
local DSS = game:GetService("DataStoreService")
local KEY = "PreloadService-AdvancedBanPro_Bans" --[[ DO NOT CHANGE THIS UNLESS YOU HAVE TO!!]]
-- Changing that WILL RESET THE BANNED PLAYERS and ALL BANNED PLAYERS WILL BE UNBANNED
local PluginAPI = require(game.ReplicatedStorage:WaitForChild("PreloadService").PluginsAPI)
local BannedPlayers = DSS:GetDataStore(KEY)
local Folder = PluginAPI.PluginEventsFolder("AdvancedBanPro")
local MS = game:GetService("MessagingService")
local AdminsScript = script.Parent.Parent.Parent.Admins
local AdminIDs, GroupIDs = require(AdminsScript).Admins, require(AdminsScript).Groups
---

--- Text ---

-- EDIT ME
local UserBanMessage = "You're banned for " -- Reason will be added on
local AccountBlacklistMessage = "[Error 2] \n Your account has been blacklisted. You are not welcome in our game."
local AccountWordBlacklist = "[Error 3] \n Sorry, but your username or display name contains a blacklisted word "
--blacklisted word
local AccountWordBlacklistEndString = ". Please change this before attempting to join the game again."

-- Check to make sure that you didn't change the DataStore Key
local Keys_Info = DSS:GetDataStore("PreloadService-AdvancedBanPro-Keys")
local Success, Result = pcall(function()
	Keys_Info:GetAsync(KEY)
end)
if not Success then
	warn("[PreloadService]: CRITICAL: COULD NOT FIND BAN INFO FOR THIS KEY!\nIf you changed the key, REVERT IT! ALL PLAYERS ARE UNBANNED.")
end



if require(script.Configuration).AppealPlaceID <= 10 then
	task.spawn(function()
		for i = 1,100 do
			warn("CRITICAL: APPEALING IS NOT CONFIGURED PROPERLY!!!\nCONFIGURE IT, OR ELSE PLAYERS WILL BE BANNED!!!!!")
			task.wait(.5)
		end
	end)
end

--- Functions ---
local function ShouldAppeal(Moderator)
	if Moderator == "Automod" then
		return false
	else return true end 
end

local function IsAdmin(Player, IsString)
	-- Uses the same logic as core PS
	if IsString == nil or not IsString then
		if table.find(AdminIDs, Player.UserId) then
			return true
		else
			for i, v in pairs(GroupIDs) do
				if Player:IsInGroup(v) then
					return true
				end
			end
		end
		return false
	end
	if table.find(AdminIDs, game.Players:GetUserIdFromNameAsync(Player)) then
		return true
	else
		for i, v in pairs(GroupIDs) do
			if false then
				return true
			end
		end
	end
	return false
end

local TodaysBans = DSS:GetDataStore("PS-"..os.date("%A").."_"..os.date("%B").."_"..os.date("%d").."_"..os.date("%Y"))

local function GetPlayerBansToday(p)
	return  TodaysBans:GetAsync(p.UserId) or 0
end

local function AddToPlayerBans(p)
	local Data = GetPlayerBansToday(p)
	Data += 1 
	TodaysBans:SetAsync(p.UserId, Data)
end

local function Heat(rgb)
	local hexadecimal = '0x'
	for key, value in pairs(rgb) do
		local hex = ''
		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end
		if(string.len(hex) == 0)then
			hex = '00'
		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end
	return hexadecimal
end

--test
--print(Heat({255, 69, 72}))

local function LocalTime()
	local Date = os.date("*t")
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	local Hour = string.format("%0.2i", ((Date.hour % 12 == 0) and 12) or (Date.hour % 12))
	local Minute = string.format("%0.2i", Date.min)
	local Second = string.format("%0.2i", Date.sec)
	local Meridiem = (Date.hour < 12 and "AM" or "PM")

	return tostring(DayTxt..", "..Month.." "..DayDate.." "..Hour ..":".. Minute ..":".. Second .." ".. Meridiem)
end

local function Time()
	local Date = os.date("*t")
	local Hour = string.format("%0.2i", ((Date.hour % 12 == 0) and 12) or (Date.hour % 12))
	local Minute = tostring(string.format("%0.2i", Date.min))
	local Second = tostring(string.format("%0.2i", Date.sec))
	local Meridiem = tostring((Date.hour < 12 and "AM" or "PM"))

	return tostring(Hour ..":".. Minute ..":".. Second .." ".. Meridiem)
end
--[[
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	]]
local function Date()
	local DayTxt = os.date("%A")
	local Month = os.date("%B")
	local DayDate = os.date("%d")
	local Year = os.date("%Y")

	return tostring(DayTxt..", "..Month.." "..DayDate.." "..Year)
end

local function GetPlayerJoinDate(PlayerName)
	-- I know using proxies is bad but I have to do it here
	local Data = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("https://legoproxy.veriblox.ml/users/v1/users/"..game.Players:GetUserIdFromNameAsync(PlayerName)))["created"]
	local day, time = string.match(Data, "(%d+%-%d+%-%d+)T(%d+:%d+:%d+%.%d+)Z")
	local date = day
	local function GetTimes()
		local times = {}
		local count = 0
		local ConstructedString = ""
		for i = 1,#date do
			local number = tonumber(string.sub(date,i,i))
			if number then
				ConstructedString = ConstructedString..number
			else
				table.insert(times,tonumber(ConstructedString))
				ConstructedString = ""
			end
		end
		if #ConstructedString > 0 then
			table.insert(times,tonumber(ConstructedString))
		end
		return times[1],times[2],times[3]
	end
	local year,month,day = GetTimes()

	local universaltimeunix = math.floor(tonumber(tostring(DateTime.fromUniversalTime(year,month,day))/1000))
	local unixtime = os.time()-universaltimeunix
	local DaysAgo = math.floor(unixtime/60/60/24)
	return DaysAgo
end


local function SendWebhook(Type,Title,Body, FieldName,FieldValue, Red)
	local HttpService = game:GetService("HttpService")
	if Red ~= nil and Red >= 255 then
		Red = 255
	end
	local Color = Heat({Red,137,34})
	if Type == "BanJoin" then
		local url = ""

		local data = 
			{
				["contents"] = "",
				--["username"] = GameName.." Logging",
				--["avatar_url"] = "https://cdn.discordapp.com/avatars/1032431346385178655/e6bde5fcfd3b994456fa578b8956ff0c.png?size=4096",
				["embeds"] = {{
					["title"]= Title,
					["description"] = Body,
					["type"]= "rich",
					["color"]= tonumber(0x006DFF),
					["fields"]={
						{
							["name"]=FieldName,
							["value"]=FieldValue,
							["inline"]=true
						},
						{
							["name"]="Report Data", 
							["value"]="Sent at "..LocalTime(),
							["inline"]=true
						},
					},
					["footer"] = {
						["text"] = "Advanced Ban Pro 1.0 | Powered By PreloadService",
						["icon_url"] = "https://preloadservice.darkpixlz.com/uploads/default/original/1X/5ea4d4cface5e897e9f1e70118c757209a75edc9.png"
					}
				}
				}
			}
		HttpService:PostAsync(url,HttpService:JSONEncode(data))
	elseif Type == "Ban" then
		local url = ""

		local data = 
			{
				["contents"] = "",
				--["username"] = GameName.." logging",
				--["avatar_url"] = "https://cdn.discordapp.com/avatars/1032431346385178655/e6bde5fcfd3b994456fa578b8956ff0c.png?size=4096",
				["embeds"] = {{
					["title"]= Title,
					["description"] = Body,
					["type"]= "rich",
					["color"]= tonumber(Color),
					["fields"]={
						{
							["name"]=FieldName,
							["value"]=FieldValue,
							["inline"]=true
						},
						{
							["name"]="Report Data", 
							["value"]="Sent at "..LocalTime(),
							["inline"]=true
						},
					},
					["footer"] = {
						["text"] = "Advanced Ban Pro 1.0 | Powered By PreloadService",
						["icon_url"] = "https://preloadservice.darkpixlz.com/uploads/default/original/1X/5ea4d4cface5e897e9f1e70118c757209a75edc9.png"
					}
				}
				}
			}
		HttpService:PostAsync(url,HttpService:JSONEncode(data))

	elseif Type == "AttemptedBan" then
		local url = ""

		local data = 
			{
				--["content"] = "@everyone IMPORTANT",
				--["username"] = GameName.." Logging",
				--["avatar_url"] = "https://cdn.discordapp.com/avatars/1032431346385178655/e6bde5fcfd3b994456fa578b8956ff0c.png?size=4096",
				["embeds"] = {{
					["title"]= Title,
					["description"] = Body,
					["type"]= "rich",
					["color"]= tonumber(0x006DFF),
					["fields"]={
						{
							["name"]="Report Data", 
							["value"]="Sent at "..LocalTime(),
							["inline"]=true
						},
					},
					["footer"] = {
						["text"] = "Advanced Ban Pro 1.0 | Protected By PreloadService",
						["icon_url"] = "https://preloadservice.darkpixlz.com/uploads/default/original/1X/5ea4d4cface5e897e9f1e70118c757209a75edc9.png"
					}
				}
				}
			}
		HttpService:PostAsync(url,HttpService:JSONEncode(data))
	else
		warn("Invalid Type value.")
	end
end

local function Ban(Player, Data, LogMode)
	--TODO
	local function Log(msg)
		if LogMode then
			print("[PreloadService ABP]: "..msg)
		end
	end
	
	---
	Log("Beginning ban process...")
end

local function Unban(Player)
	
end


local function OnInvoke(p, Player,Intent,Table)
	--[[
		Info:
		Intent 1: Check Status/Pull Data
		Intent 2: Unban player
		Intent 3: Ban Player
		Table Format:
		{
			Reason,
			CanAppeal,
			Length,
		}
	]]
	if Intent == 1 then --Check status
		local IsAdmin = IsAdmin(p)
		if not IsAdmin then
			SendWebhook(
				"AttemptedBan",
				"Exploiter attempted to loopup ban!",
				p.Name.." Attempted to look up ban data for "..Player.."! Player has been permabanned.\nPreloadService has automatically banned the user, no further action required, unless stated.",
				"",
				""
			)
			require(script.Configuration).ExploitsDetected(p)
			local DataToWrite = {
				IsBanned = true,
				TimeToUnban = 0,
				Reason = "Ban exploits. Method: CHECK",
				Moderator = "Automod",
				Date = Date(),
				Time = Time(),
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
			p:Kick("Exploits Detected! Powered by PreloadService.")
			local succ, err = pcall(function()
				BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(p.Name).."_BanV1", DataToWrite)
			end)
			if not succ then
				SendWebhook("AttemptedBan", "DSS BAN FAILED, PLEASE BAN INSTANTLY", "Error: "..err,"","")
			end
			p:Destroy()
			return
		end
		local data = BannedPlayers:GetAsync(game.Players:GetUserIdFromNameAsync(Player).."_BanV1")
		if not data then
			warn("Data not found.")
			return  {
				IsBanned = false,
				TimeToUnban = 0,
				Reason = "",
				Moderator = "",
				Date = "",
				Time = "",
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
		end
		return data
	elseif Intent == 2 then -- Unban Player
		local IsAdmin = IsAdmin(p)
		if not IsAdmin then
			SendWebhook(
				"AttemptedBan",
				"EXPLOITER FIRED BAN EVENT",
				p.Name.." Attempted to unban "..Player.."! Player has been permabanned.\nPreloadService has automatically banned the user, no further action required, unless stated.",
				"",
				""
			)
			require(script.Configuration).ExploitsDetected(p)
			local DataToWrite = {
				IsBanned = true,
				TimeToUnban = 9999999999999999,
				Reason = "Ban Exploits.",
				Moderator = "Automod",
				Date = Date(),
				Time = Time(),
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
			p:Kick("Exploits Detected! Powered by PreloadService.")
			local succ, err = pcall(function()
				BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(p.Name).."_BanV1", DataToWrite)
			end)
			if not succ then
				SendWebhook("AttemptedBan", "DSS BAN FAILED, PLEASE BAN INSTANTLY", "Error: "..err,"","")
			end
			p:Destroy()
			return
		end

		--Completely overwrite data
		local DataToWrite = {
			IsBanned = false,
			TimeToUnban = 0,
			Reason = "",
			Moderator = "",
			Date = "",
			Time = "",
			DoesExist=true,
			Appeals = {
				CanAppeal = false,
				AppealSubmitted = false
			}
		}
		local Data = DataToWrite
		BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(Player).."_BanV1", DataToWrite)
		SendWebhook(
			"Ban",
			"Player has been unbanned!",
			"More info below.", 
			"Event details", 
			"Player name: "..Player.."\nPlayer ID: "..game.Players:GetUserIdFromNameAsync(Player).." \Original ban was on on "..Data["Date"].." at "..Data["Time"].."\nResponsible Moderator: @"..p.Name.."\n Server Time: "..LocalTime()
		)
	elseif Intent == 3 then --Ban player
		local Found = IsAdmin(Player, true)
		if Found then
			SendWebhook(
				"AttemptedBan",
				"Admin attempted to unban other admin!",
				p.Name.." Attempted to ban "..Player.." for "..Table[1] or "N/A".."! Attention required.",
				"",
				""
			)
			p:Kick("Attempt to ban an admin. We've logged this and your request did not go through.")
			return
		end
		local IsAdmin = IsAdmin(p)
		if not IsAdmin then
			SendWebhook(
				"AttemptedBan",
				"EXPLOITER HAS ACCESS TO BANS",
				p.Name.." Attempted to unban "..Player.." for "..Table[1] or "N/A".."! Player has been permabanned.\nATTENTION NEEDED ASAP",
				"",
				""
			)
			p:Kick("Ban was successful. Please rejoin to ban more players.")
			local DataToWrite = {
				IsBanned = true,
				TimeToUnban = 999999999999,
				Reason = "Exploits are not permitted!",
				Moderator = "Automoderator",
				Date = Date(),
				Time = Time(),
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
			local Data = DataToWrite
			local succ, err = pcall(function()
				BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(p.Name).."_BanV1", DataToWrite)
			end)
			if not succ then
				SendWebhook("AttemptedBan", "DSS BAN FAILED, PLEASE BAN INSTANTLY", "Error: "..err,"","")
			end
			return
		end
		--Everything for future use will not be included
		-- I'll add times and that stuff laterrr
		if string.lower(Table[3]) == "perm" then
			Table[3] = 99999999999999999
		end
		--print(Table[3])
		--print(Table[3] + GetPlayerJoinDate(Player))
		--print(Table[3] + GetPlayerJoinDate(Player) >= GetPlayerJoinDate(Player))
		local DataToWrite = {
			IsBanned = true,
			TimeToUnban = Table[3] + GetPlayerJoinDate(Player),
			Reason = Table[1],
			Moderator=tostring(p.Name),
			Date = Date(),
			Time = Time(),
			DoesExist=true,
			Appeals = {
				CanAppeal = Table[2],
				AppealSubmitted = false
			}
		}
		print("Adding to bans for today...")
		AddToPlayerBans(p)
		local Data = DataToWrite
		warn("Writing...")
		BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(Player).."_BanV1", DataToWrite)
		print("Sending...")
		SendWebhook(
			"Ban",
			"Player has been banned!",
			"More info below.", 
			"Event details", 
			"Player name: "..Player.."\nPlayer ID: "..game.Players:GetUserIdFromNameAsync(Player).."\nBan reason: "..Data["Reason"].." \nBanned on "..Data["Date"].." at "..Data["Time"].."\nBanned by @"..Data["Moderator"]..".\nCan Appeal: "..tostring(Data["Appeals"]["CanAppeal"]).."\nBan Length: "..tostring(Data["TimeToUnban"] -GetPlayerJoinDate(Player).."\nAdmin's Bans Today: "..tostring(GetPlayerBansToday(p))),           
			GetPlayerBansToday(p)*17
		)
		print("Brodcasting...")
		MS:PublishAsync("OnPlayerBanned")
		print("Success!")
	end
end

---


local function SafeTeleport(Player)
	local AttemptIndex = 0
	local success, result -- define pcall results outside of loop so results can be reported later on
	repeat
		success, result = pcall(function()
			return game:GetService("TeleportService"):TeleportAsync(12207611270, {Player}) -- teleport the user in a protected call to prevent erroring
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



function RemoveNegativeSign(num)
	if num < 0 then
		num = -num
	end
	return num
end


local function PlrAdded(Player)
	-- Get old data
	local OldData
	local succ, err = pcall(function()
		OldData = DSS:GetDataStore("CUR_BANNED_PLRS_v1"):GetAsync(Player.UserId.."_BanV1")
	end)
	if OldData then
		warn("Found old data for "..Player.Name.."!")
		--Set new data
		BannedPlayers:SetAsync(
			Player.UserId.."_BanV1", {
				IsBanned = OldData["IsBanned"],
				TimeToUnban = 0,
				Reason = OldData["Reason"],
				Moderator = OldData["Moderator"],
				Date = OldData["Date"],
				Time = OldData["Time"],
				DoesExist=true,
				Appeals = {
					CanAppeal = ShouldAppeal(OldData["Moderator"]),
					AppealSubmitted = false
				}
			}
		)
		print("Moved over to new data!")
		DSS:GetDataStore("CUR_BANNED_PLRS_v1"):RemoveAsync(Player.UserId.."_BanV1")
	end
	print(Player.Name)
	local Retries = 0
	local keytest = BannedPlayers:GetAsync(Player.UserId.."_BanV1")
	--Ban check will happen in ./BanChecker
	if not BannedPlayers:GetAsync(Player.UserId.."_BanV1") then
		warn("Not found")
		--Player is new
		BannedPlayers:SetAsync(
			Player.UserId.."_BanV1", {
				IsBanned = false,
				TimeToUnban = 0,
				Reason = "",
				Moderator = "",
				Date = "",
				Time = "",
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
		)
	elseif keytest["IsBanned"] then
		local ui = script.ScreenBlocker:Clone()
		ui.Parent = Player.PlayerGui
		print("Is banned!")
		if keytest["Appeals"]["CanAppeal"] then
			print("Can Appeal")
			--The same system is used in Jailbreak, and a known exploit there can be used to avoid the ban.
			-- So, we try up to 5 times, then make the ban permanant	
			task.spawn(function()
				local Success, Error = SafeTeleport(Player)
			end)
			if not Success then
				SendWebhook(
					"AttemptedBan",
					"Exploiter detected!",
					Player.Name.." used exploits to try and avoid the appeal teleport! Player has been banned.",
					"",
					""
				)
				Player:Kick("Exploits detected, or teleport failed. Powered by PreloadService. If this was a mistake, contact staff.")
				local DataToWrite = {
					IsBanned = true,
					TimeToUnban = 99999999999,
					Reason = "Exploits. Method: Avoid appeal",
					Moderator = "",
					Date = "",
					Time = "",
					DoesExist=true,
					Appeals = {
						CanAppeal = false,
						AppealSubmitted = false
					}
				}
				local Data = DataToWrite
				local succ, err = pcall(function()
					BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(Player.Name).."_BanV1", DataToWrite)
				end)
				if not succ then
					SendWebhook("AttemptedBan", "DSS BAN FAILED, PLEASE BAN INSTANTLY", "Error: "..err,"","")
				end
			end
			task.wait(15)
			repeat
				Player:Kick("Failed to teleport you for your appeal - please try again later.")
			until not game.Players:FindFirstChild(Player.Name)
			return
		end
		if Player.AccountAge >= keytest["TimeToUnban"] then
			print(Player.AccountAge.."-"..keytest["TimeToUnban"])
			warn("Unbanning as time has come!")
			local DataToWrite = {
				IsBanned = false,
				TimeToUnban = 0,
				Reason = "",
				Moderator = "",
				Date = "",
				Time = "",
				DoesExist=true,
				Appeals = {
					CanAppeal = false,
					AppealSubmitted = false
				}
			}
			local Data = DataToWrite
			local succ, err = pcall(function()
				BannedPlayers:SetAsync(game.Players:GetUserIdFromNameAsync(Player.Name).."_BanV1", DataToWrite)
			end)
			ui:Destroy()
			return
		else
			warn(tostring(Player.AccountAge.."-"..keytest["TimeToUnban"]).." left!")
		end
		print("Kicking!")
		local Attempts = 0
		repeat
			Attempts += 1
			Player:Kick(UserBanMessage..keytest["Reason"].." by "..keytest["Moderator"]..". You'll be unbanned in "..tostring(RemoveNegativeSign(Player.AccountAge - keytest["TimeToUnban"])).." days.")
		until not game.Players:FindFirstChild(Player.Name) or Attempts == 15
		if Attempts == 15 then
			Player:Destroy()
		end
		SendWebhook("BanJoin",
			"Banned user attempted to join.",
			"More info below.", 
			"Event details", 
			"Player name: "..Player.Name.."\nPlayer ID: "..Player.UserId.."\nBan reason: "..keytest["Reason"].." \nBanned on "..keytest["Date"].." at "..keytest["Time"].."\nBanned by @"..keytest["Moderator"].."\nCan Appeal: "..tostring(keytest["Appeals"]["CanAppeal"]).."\nBan Length: "..tostring(keytest["TimeToUnban"]).."\Has Appealed: "..tostring(keytest["Appeals"]["HasAppealed"]))
	end
end
game.Players.PlayerAdded:Connect(PlrAdded)
--catch the leftovers
for i,v in ipairs(game.Players:GetPlayers()) do
	PlrAdded(v)
end

-- Finish API calls
PluginAPI.NewRemoteFunction("BanPlr", "AdvancedBanPro", OnInvoke)
PluginAPI.NewButton("rbxassetid://12177660905", "Bans", script.Bans, "G")

print("========================================================================================")
print("--------------------------------- PreloadService Ban v1 ---------------------------------")
print("========================================================================================")
print("                   Plugin is running! Errors will be logged here.                   ")

if require(script.Configuration).RunTests then
	print("====================================================================================================")
	print("--------------------------------- PreloadService Ban Debugger Tool ---------------------------------")
	print("====================================================================================================")
	print("PreloadService is now running a test ban to diagnose any issues with the plugin. WARNING: You will be kicked in this process.\n\nBeginning...")
	
	warn("Broadcasting ban message to test MessagingService functionality...")
	local succ, err = pcall(function()
		MS:PublishAsync("OnPlayerBanned")
	end)
	if not succ then
		warn("[PreloadService AdvancedBanPro]:\nTest complete!\nERROR FOUND!\nWe couldn't broadcast the message to check for banned players in-game. Make sure API services is enabled!\n\nError: "..err)
		return
	end
	warn("Successfully connected to MessagingService! Attempting to send a webhook to all hooks...")
	local succ1, err1 = pcall(function()
		SendWebhook("AttemptedBan", "Ban Plugin Testing!", "A test is currently running - no action is needed. If you're seeing this, then everything is configured properly!", "", "")
		SendWebhook("BanJoin", "Ban Plugin Testing!", "A test is currently running - no action is needed. If you're seeing this, then everything is configured properly!", "N/A", "N/A")
		SendWebhook("Ban", "Ban Plugin Testing!", "A test is currently running - no action is needed. If you're seeing this, then everything is configured properly!", "N/A", "N/A")
	end)
	if not succ1 then
		warn("[PreloadService AdvancedBanPro]:\nTest complete!\nERROR FOUND!\nWe couldn't send out webhooks. Make sure HTTP requests are enabled, and the settings are configured!\n\nError: "..err1)
		return
	end
	warn("Successfully reached webhooks! Attempting to ban a player (appeal false)...")
	Ban(game.Players:FindFirstChildWhichIsA("Player", true), {"Testing bans!", false, 500000000}, true)
	warn("Success! Unbanning...")
	Unban(game.Players:FindFirstChildWhichIsA("Player", true))
	warn("Success! Rebanning with appeal status true...")
	Ban(game.Players:FindFirstChildWhichIsA("Player", true), {"Testing bans!", true, 5000000000}, true)
	warn("Success! Checking for bans locally and teleporting you...")
	for i,v in ipairs(game.Players:GetPlayers()) do
		PlrAdded(v)
	end
	warn("Success! Unbanning you...")
	Unban(game.Players:FindFirstChildWhichIsA("Player", true))
	warn("COMPLETE!")
end
