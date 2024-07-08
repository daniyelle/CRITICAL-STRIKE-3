local bans=game:GetService("DataStoreService"):GetDataStore("BanVersion2")
local admins={"EpicCritical", "Rosie6729", "MegumuSenpai","audi_t"}

local badgeleak=game:GetService("DataStoreService"):GetDataStore("BadgeLeakVersion5")
local badgeids={"674694549"}

for _, admins in pairs(admins) do
	local misc=Instance.new("Model")
	misc.Name=admins
	misc.Parent=script.Admins
end

function findInTable(tabl, name)
	for _, tablman in pairs(tabl) do
		if tablman==name then
			return true
		end
	end
	return false
end

function findPlayer(name)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower() == name:lower() then
            return player
        end
    end
end

function sendmessage(player, text)
	local msg=game.ServerStorage.ServerMessage:Clone()
	msg.Text.Value=text
	msg.Color.Value=Color3.new(1, 1, 1)
	msg.Parent=player.PlayerGui
end

local UsernameFromID = function(ID)
    if type(ID) ~= "number" then
        return
    end
    local sets = game:service("InsertService"):GetUserSets(ID)
    for k, Item in next, sets do
        if Item.Name == "My Models" then
            return Item.CreatorName
        end
    end
end

game.Players.PlayerAdded:connect(function(player)
	--ban handling
	if bans:GetAsync(player.UserId)==nil then
		bans:SetAsync(player.UserId, {0, 0})
	elseif bans:GetAsync(player.UserId)[1]==1 then
		if bans:GetAsync(player.UserId)[2]<=os.time() then
			sendmessage(player, "Your ban has expired, don't screw up again mmkay?")
			bans:SetAsync(player.UserId, {0, 0})
		else
			player:Kick("You have been banned for the next "..(math.floor(100*((bans:GetAsync(player.UserId)[2]-os.time())/86400))/100).." days. Come back later :^)")
		end		
	end
	if findInTable(admins, player.Name) then
		sendmessage(player, "You can ban people with tban, dban, wban, mban, and pban.")
	end
	for _, adminz in pairs(game.Players:GetChildren()) do
		if findInTable(admins, adminz.Name) then
			if bans:GetAsync(player.UserId)[1]==1 then
				sendmessage(adminz, player.Name.." joined the game but was banned. ID: "..player.UserId)
			else
				local total=player.AccountAge
				local years=math.floor(total/365)
				total=total-years*365
				local months=math.floor(total/30)
				total=total-months*30
				local days=total
				sendmessage(adminz, player.Name.." has joined the game. Account Age: "..years.." years, "..months.." months, "..days.." days. ID: "..player.UserId)
			end
		end
	end
    player.Chatted:connect(function(message)
		if findInTable(admins, player.Name) then
			if message:sub(1, 6)=="pban: " then
				local bannee=findPlayer(message:sub(7))
				if bannee~=nil then
					sendmessage(player, "Banned "..bannee.Name)
					bans:SetAsync(bannee.UserId, {1, os.time()+9999999999})
					bannee:Kick("You have been banned from the game")
				else
					bannee=message:sub(7)
					local user=UsernameFromID(tonumber(message:sub(7)))
					sendmessage(player, "Banned "..user)
					bans:SetAsync(message:sub(7), {1, os.time()+9999999999})
				end
			end
			if message:sub(1, 6)=="dban: " then
				local bannee=findPlayer(message:sub(7))
				if bannee~=nil then
					sendmessage(player, "Banned "..bannee.Name)
					bans:SetAsync(bannee.UserId, {1, os.time()+86400})
					bannee:Kick("You've recieved a one day ban. RIP")
				else
					bannee=message:sub(7)
					local user=UsernameFromID(tonumber(message:sub(7)))
					sendmessage(player, "Banned "..user)
					bans:SetAsync(message:sub(7), {1, os.time()+86400})
				end
			end
			if message:sub(1, 6)=="wban: " then
				local bannee=findPlayer(message:sub(7))
				if bannee~=nil then
					sendmessage(player, "Banned "..bannee.Name)
					bans:SetAsync(bannee.UserId, {1, os.time()+(86400*7)})
					bannee:Kick("You've recieved a 7 day ban. Never lucky rubber ducky")
				else
					bannee=message:sub(7)
					local user=UsernameFromID(tonumber(message:sub(7)))
					sendmessage(player, "Banned "..user)
					bans:SetAsync(message:sub(7), {1, os.time()+(86400*7)})
				end
			end
			if message:sub(1, 6)=="mban: " then
				local bannee=findPlayer(message:sub(7))
				if bannee~=nil then
					sendmessage(player, "Banned "..bannee.Name)
					bans:SetAsync(bannee.UserId, {1, os.time()+(86400*30)})
					bannee:Kick("The rumour come out. Was "..bannee.Name.." banned? 30 days")
				else
					bannee=message:sub(7)
					local user=UsernameFromID(tonumber(message:sub(7)))
					sendmessage(player, "Banned "..user)
					bans:SetAsync(message:sub(7), {1, os.time()+(86400*7)})
				end
			end
			if message:sub(1, 6)=="tban: " then
				local bannee=findPlayer(message:sub(7))
				if bannee~=nil then
					sendmessage(player, "Banned "..bannee.Name)
					bans:SetAsync(bannee.UserId, {1, os.time()+(30)})
					bannee:Kick("You've recieved a 30 second ban. RIP AGAIN")
				else
					bannee=message:sub(7)
					local user=UsernameFromID(tonumber(message:sub(7)))
					sendmessage(player, "Banned "..user)
					bans:SetAsync(message:sub(7), {1, os.time()+(30)})
				end
			end
			if message:sub(1, 7)=="unban: " then
				local user=UsernameFromID(tonumber(message:sub(8)))
				sendmessage(player, "Unbanned "..user)
				bans:SetAsync(message:sub(8), {0, 0})			
			end
		end
    end)
end)

game.Players.PlayerRemoving:connect(function(player)
	for _, adminz in pairs(game.Players:GetChildren()) do
		if findInTable(admins, adminz.Name) then
			sendmessage(adminz, player.Name.." has left the game. ID: "..player.UserId)
		end
	end
end)

coroutine.resume(coroutine.create(function()
	while wait() do
		for _,p in ipairs(script.Admins:GetChildren()) do
			if findInTable(admins,p.Name)==false then
				local bannee=game.Players[p.Name]
				bannee:Kick()
				--bans:SetAsync(bannee.UserId, {1, os.time()+9999999999})
				--bannee:Kick("RIPP IN RIPP")
			end
		end
	end
end))
