local stats=game:GetService("DataStoreService"):GetDataStore("CriticalStrikeStats")

function loadStats(player)
	--wins, losses, coins, points
	if stats:GetAsync(player.UserId)==nil then
		local folder=_G.getFolder(player)
		local newStats={0,0,0,0,0}
		folder.Stats.Wins.Value=newStats[1]
		folder.Stats.Losses.Value=newStats[2]
		folder.Stats.Coins.Value=newStats[3]
		folder.Stats.Points.Value=newStats[4]
		folder.Stats.Kills.Value=newStats[5]
	else
		local folder=_G.getFolder(player)
		local newStats=stats:GetAsync(player.UserId)
		folder.Stats.Wins.Value=newStats[1]
		folder.Stats.Losses.Value=newStats[2]
		folder.Stats.Coins.Value=newStats[3]
		folder.Stats.Points.Value=newStats[4]
		folder.Stats.Kills.Value=newStats[5]
		player:WaitForChild("leaderstats").Points = folder.Stats.Points.Value
	end
	wait()
end

function saveStats(player)
	local folder=_G.getFolder(player)
	stats:SetAsync(player.UserId, {folder.Stats.Wins.Value, folder.Stats.Losses.Value, folder.Stats.Coins.Value, folder.Stats.Points.Value, folder.Stats.Kills.Value})
end

game.Players.PlayerAdded:connect(function(player)
	local pfolder=Instance.new("Folder")
	pfolder.Name=player.Name
	pfolder.Parent=game.ServerStorage.Players
	local folderTag=Instance.new("ObjectValue")
	folderTag.Value=pfolder
	folderTag.Name="FolderTag"
	folderTag.Parent=player
	local statclone=game.ServerStorage.Storage.Stats:Clone()
	statclone.Parent=pfolder
	loadStats(player)
end)

game.Players.PlayerRemoving:connect(function(Player)
	if Player:FindFirstChild("KickTag")==nil then
		saveStats(Player)
	end	
	_G.getFolder(Player):Destroy()
end)
