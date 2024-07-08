-- this only exists due to an old bug where you could force yourself into full servers
-- in some instsances this still exists, if u use a script to rejoin the current script while someone is in queue to join

local playercount=0

game.Players.PlayerAdded:connect(function(player)	
	if (playercount>=game.Players.MaxPlayers-1 and game.Workspace.BanScript.Admins:FindFirstChild(player.Name)==nil) then
		script.KickTag:Clone().Parent=player
		player:kick("You have tried to join a reserved spot, sorry for the inconvenience")
	else
		playercount=playercount+1
	end
end)

game.Players.PlayerRemoving:connect(function(player)
	if player:FindFirstChild("KickTag")==nil then
		playercount=playercount-1
	end
end)
