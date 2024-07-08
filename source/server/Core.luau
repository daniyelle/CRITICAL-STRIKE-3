wait(10)

local livingplayers = Instance.new("Folder") livingplayers.Parent = script livingplayers.Name = "LivingPlayers"
local workingtick = Instance.new("IntValue") workingtick.Parent = script workingtick.Name = "WorkingTick"

local map
local boss
local newmapchance=0
local ffachance=10
local bosschance=0
local telimchance=0
local juggchance=0
local juggernaut=nil
local redteam=0
local blueteam=0
local modes={}
local requiredplayers=2
local bosssuccess = 2
math.randomseed(tick())

for i=1, newmapchance, 1 do
	table.insert(modes, 1, "NEWMAP")
end
for i=1, ffachance, 1 do
	table.insert(modes, 1, "FFA")
end
for i=1, bosschance, 1 do
	table.insert(modes, 1, "BOSS")
end
for i=1, telimchance, 1 do
	table.insert(modes, 1, "TE")
end
for i=1, juggchance, 1 do
	table.insert(modes, 1, "JUGG")
end

--In case roblox fix their chat, delete these--
--[==[
function displayMSG(string, parent, time)
	local msg = Instance.new("Message")
	msg.Parent = parent
	msg.Text = string
	wait(time)
	msg:remove()
end

function displayHINT(string, parent, time)
	local msg = Instance.new("Hint")
	msg.Parent = parent
	msg.Text = string
	if time ~= nil then
	wait(time)
	msg:remove()
	end
end
]==]

function findInTable(tabl, name)
	for _, tablman in pairs(tabl) do
		if tablman==name then
			return true
		end
	end
	return false
end

function findInTableIndex(tabl, name)
	for index, tablman in pairs(tabl) do
		if tablman==name then
			return index
		end
	end
	return -1
end

function getReadyPlayers()
	local ready=0
	for _, people in pairs(game.Players:GetChildren()) do
		if playerReady(people) then
			ready=ready+1
		end
	end
	return ready
end

function playerReady(player)
	if not player.Character then
	    player.CharacterAdded:wait();
	end
	if player.Character:FindFirstChild("Spectating")==nil and player.Character.Humanoid.Health>0 and player.Character:FindFirstChild("Chest")~=nil then
		return true
	else
		return false
	end
end

function serverMessage(text, color)
	local msg=game.ServerStorage.ServerMessage:Clone()
	msg.Text.Value=text
	msg.Color.Value=color
	for _, people in pairs(game.Players:GetChildren()) do
		msg:Clone().Parent=people.PlayerGui
	end
	msg:Destroy()
	script.WorkingTick.Value=script.WorkingTick.Value+1
end

function pickMode()
	serverMessage("Selecting gamemode", Color3.new(1, 1, 1))
	wait(1)
	local pickedmode=modes[math.random(1, #modes)]
	if bosssuccess < 2 then
		pickedmode = "BOSS"
	end
	pickMap(pickedmode)
end

function pickMap(mode)
	redteam=0
	blueteam=0
	local maps=game.ServerStorage:FindFirstChild(mode.."MAPS"):GetChildren()
	local mapd=maps[math.random(1, #maps)]
	map=mapd:Clone()
	if mode=="BOSS" then
		boss=map:WaitForChild("BOSS")
	end
	--game:GetService("Debris"):AddItem(map, 600) get rekt
	if mode=="FFA" or mode=="NEWMAP" then
		serverMessage("Free For All, eliminate all other players", Color3.new(1, 1, 1))
	end
	if mode=="BOSS" then
		serverMessage("Boss Fight, defeat the enemy", Color3.new(1, 1, 1))
	end
	if mode=="TE" then
		serverMessage("Team Elimination, eliminate the enemy team", Color3.new(1, 1, 1))
	end
	if mode=="JUGG" then
		serverMessage("Juggernaut, defeat the juggernaut to win", Color3.new(1, 1, 1))
	end
	wait(5)	
	map.Parent=game.Workspace
	game.Lighting.TimeOfDay=map.TimeOfDay.Value
	game.Lighting.Ambient=map.Ambience.Value
	game.Workspace.Music.Speed.Value=map.Speed.Value
	game.Workspace.Music.Volume.Value=map.Volume.Value
	game.Workspace.Music.CurrentMusic.Value=map.MusicId.Value
	serverMessage("The map will be "..map.Name, Color3.new(1, 1, 1))
	game.Workspace.Blocker.CanCollide=true
	wait(5)
	if getReadyPlayers()>=requiredplayers then
		warpPlayers(mode)
		local list={}
		for _, people in pairs(game.Players:GetChildren()) do
			if playerReady(people) then
				table.insert(list, 1, people)
			end
		end
		gameWait(list, mode)
	else
		serverMessage("Not enough players to begin the game", Color3.new(1, 1, 1))
		checkIfReady()
	end
end

function setTeams(tablel)
	local oneteam=math.floor(#tablel/2)
	local redteamplayers={}
	local picks=0
	while picks<oneteam do
		local pickd=math.random(1, #tablel)
		if findInTable(redteamplayers, tablel[pickd].Name)==false then
			table.insert(redteamplayers, tablel[pickd].Name)
			picks=picks+1
			local tag=Instance.new("IntValue")
			tag.Name="Red"
			tablel[pickd].Character.Team:Destroy()
			local teamtag=Instance.new("IntValue")
			teamtag.Name="Team"
			teamtag.Value=1
			teamtag.Parent=tablel[pickd].Character
			tag.Parent=tablel[pickd].Character
			local teamtag2=Instance.new("Folder")
			teamtag2.Name=tablel[pickd].Name
			teamtag2.Parent=game.ServerStorage.Teams.RedTeam
			redteam=redteam+1
		end
	end
	for index, leftovers in pairs(tablel) do
		if findInTable(redteamplayers, tablel[index].Name)==false then
			local tag=Instance.new("IntValue")
			tag.Name="Blue"
			tablel[index].Character.Team:Destroy()
			local teamtag=Instance.new("IntValue")
			teamtag.Name="Team"
			teamtag.Value=2
			teamtag.Parent=tablel[index].Character
			tag.Parent=tablel[index].Character
			tag:Clone().Parent=tablel[index]
			local teamtag2=Instance.new("Folder")
			teamtag2.Name=tablel[index].Name
			teamtag2.Parent=game.ServerStorage.Teams.BlueTeam
			blueteam=blueteam+1
		end		
	end
end

function pickJugg(tablel)
	juggernaut=tablel[math.random(1, #tablel)]
	serverMessage("The juggernaut is "..juggernaut.Name, Color3.new(1, 1, 1))
	for _, people in pairs(tablel) do
		if people~=juggernaut then
			local char=people.Character
			local tag=Instance.new("IntValue")
			tag.Name="Blue"
			char.Team:Destroy()
			local teamtag=Instance.new("IntValue")
			teamtag.Name="Team"
			teamtag.Value=2
			teamtag.Parent=char
			tag.Parent=char
			local teamtag2=Instance.new("Folder")
			teamtag2.Name=people.Name
			teamtag2.Parent=game.ServerStorage.Teams.BlueTeam
			blueteam=blueteam+1
		else
			local char=people.Character
			local tag=Instance.new("IntValue")
			tag.Name="Red"
			char.Team:Destroy()
			local teamtag=Instance.new("IntValue")
			teamtag.Name="Team"
			teamtag.Value=1
			teamtag.Parent=char
			tag.Parent=char
			tag:Clone().Parent=people
			local teamtag2=Instance.new("Folder")
			teamtag2.Name=people.Name
			teamtag2.Parent=game.ServerStorage.Teams.RedTeam
			redteam=redteam+1
		end
	end
end

function getSpot(player, mode)
	if mode=="FFA" or mode=="NEWMAP" or mode=="BOSS" or mode=="JUGG" then
		local mult = 180
		if mode == "BOSS" then
			mult = 60
		end
		local list={}
		local spawnpos
		local spawned=false
		while spawned==false do
			local pos=Vector3.new(math.random(-mult, mult) , 100, math.random(-mult, mult))
			local testray=Ray.new(pos, Vector3.new(0, -300, 0))
			local hit, post=game.Workspace:FindPartOnRayWithIgnoreList(testray, list)
			if hit.CanCollide==false then
				table.insert(list, 1, hit)
			elseif hit.CanCollide==true and hit.Name=="VOIDINDICATOR" then				
				
			elseif post==nil then
				
			elseif hit:FindFirstChild("DONTSPAWN")~=nil then
				
			elseif post.Y>=50 then				
				
			else
				spawned=true
				spawnpos=post+Vector3.new(0, 2, 0)
			end
		end
		if spawnpos==nil then
			getSpot(player)
		else
			player.Character.HumanoidRootPart.CFrame=CFrame.new(spawnpos)
			game.ServerStorage.Storage.InGameHUD:Clone().Parent=player.PlayerGui
			local playtag=Instance.new("IntValue")
			playtag.Name="Playing"
			playtag.Parent=player.Character
			if mode == "BOSS" then
				local tag=Instance.new("IntValue")
				tag.Name="Red"
				player.Character.Team:Destroy()
				local teamtag=Instance.new("IntValue")
				teamtag.Name="Team"
				teamtag.Value=1
				teamtag.Parent=player.Character
				tag.Parent=player.Character
				tag:Clone().Parent=player
			end
		end		
	end
	if mode=="TE" then
		local redteampos=map.RedSpawn
		local blueteampos=map.BlueSpawn
		if player.Character:FindFirstChild("Red")~=nil then
			player.Character.HumanoidRootPart.CFrame=redteampos.CFrame+Vector3.new(math.random(-500, 500)/100, 2, math.random(-500, 500)/100)
			player.Character.HumanoidRootPart.BrickColor=BrickColor.new(21)
			game.Workspace.ACharacterColor:FindFirstChild(player.Name).ColorNeon.Value=BrickColor.new(21)		
		else
			player.Character.HumanoidRootPart.CFrame=blueteampos.CFrame+Vector3.new(math.random(-500, 500)/100, 2, math.random(-500, 500)/100)	
			player.Character.HumanoidRootPart.BrickColor=BrickColor.new(23)
			game.Workspace.ACharacterColor:FindFirstChild(player.Name).ColorNeon.Value=BrickColor.new(23)	
		end
		game.ServerStorage.Storage.InGameHUD:Clone().Parent=player.PlayerGui
		local playtag=Instance.new("IntValue")
		playtag.Name="Playing"
		playtag.Parent=player.Character
		local disc=Instance.new("Part")
		disc.Size=Vector3.new(4, .2, 4)
		disc.Transparency=.5
		disc.Material="Neon"
		disc.TopSurface="Smooth"
		disc.BottomSurface="Smooth"
		disc.CanCollide=false
		disc.BrickColor=player.Character.HumanoidRootPart.BrickColor
		game.ServerStorage.InvisPad:Clone().Parent=disc
		disc.CFrame=(player.Character.HumanoidRootPart.CFrame+Vector3.new(0, -2.9, 0))
		_G.weldTogther(disc, player.Character.HumanoidRootPart)
		disc.Parent=player.Character
	end
	if mode=="JUGG" then
		local list={}
		local spawnpos
		local spawned=false
		while spawned==false do
			local pos=Vector3.new(math.random(-180, 180) , 100, math.random(-180, 180))
			local testray=Ray.new(pos, Vector3.new(0, -300, 0))
			local hit, post=game.Workspace:FindPartOnRayWithIgnoreList(testray, list)
			if hit.CanCollide==false then
				table.insert(list, 1, hit)
			elseif hit.CanCollide==true and hit.Name=="VOIDINDICATOR" then				
				
			elseif post==nil then
				
			elseif hit:FindFirstChild("DONTSPAWN")~=nil then
				
			elseif post.Y>=50 then				
				
			else
				spawned=true
				spawnpos=post+Vector3.new(0, 2, 0)
			end
		end
		if spawnpos==nil then
			getSpot(player)
		else
			player.Character.HumanoidRootPart.CFrame=CFrame.new(spawnpos)
			game.ServerStorage.Storage.InGameHUD:Clone().Parent=player.PlayerGui
			local playtag=Instance.new("IntValue")
			playtag.Name="Playing"
			playtag.Parent=player.Character
			if player.Character:FindFirstChild("Red")~=nil then
				local pcount=0
				for _, people in pairs(game.Players:GetChildren()) do
					if playerReady(people) then
						pcount=pcount+1
					end
				end
				player.Character.HumanoidRootPart.BrickColor=BrickColor.new(21)
				game.Workspace.ACharacterColor:FindFirstChild(player.Name).ColorNeon.Value=BrickColor.new(21)	
				player.Character.Humanoid.MaxHealth=player.Character.Humanoid.MaxHealth*(pcount/1.5)
				player.Character.Humanoid.Health=player.Character.Humanoid.MaxHealth
				player.Character.Chest.Middle.Damage.Value=80*(pcount/2.2)
				game.ServerStorage.JuggScript:Clone().Parent=player.Character
			else
				player.Character.HumanoidRootPart.BrickColor=BrickColor.new(23)
				game.Workspace.ACharacterColor:FindFirstChild(player.Name).ColorNeon.Value=BrickColor.new(23)	
			end
			local disc=Instance.new("Part")
			disc.Size=Vector3.new(4, .2, 4)
			disc.Transparency=.5
			disc.Material="Neon"
			disc.TopSurface="Smooth"
			disc.BottomSurface="Smooth"
			disc.CanCollide=false
			disc.BrickColor=player.Character.HumanoidRootPart.BrickColor	
			game.ServerStorage.InvisPad:Clone().Parent=disc	
			disc.CFrame=(player.Character.HumanoidRootPart.CFrame+Vector3.new(0, -2.9, 0))
			_G.weldTogther(disc, player.Character.HumanoidRootPart)
			disc.Parent=player.Character
		end		
	end
end

function gameWait(players, mode)
	local limit=map.TimeLimit.Value
	local ended=false
	local winner="Nobody"
	local redteamdeads={}
	local blueteamdeads={}
	
	--game ends	
	local function endGame()
		if ended==false then
			ended=true
			game.Lighting.Ambient=Color3.new(0, 0, 0)
			game.Lighting.TimeOfDay="14:00:00"
			--ffa
			if mode=="FFA" or mode=="NEWMAP" then
				if winner=="Nobody" then
					serverMessage("Nobody wins the match", Color3.new(1, 1, 1))
					for _, people in pairs(script.LivingPlayers:GetChildren()) do
						_G.addPoints(people.Value, 10)
					end
				else
					serverMessage("The winner, "..winner.." (+20 Points)", Color3.new(1, 1, 1))
					for _, people in pairs(script.LivingPlayers:GetChildren()) do
						_G.addPoints(people.Value, 50)
						_G.addWins(people.Value, 1)
					end
				end
			end
			--boss
			if mode=="BOSS" then
				if winner=="Nobody" then
					game.Workspace.PumpkinDefeated.Value = 0
					serverMessage("The boss defeated you all, better luck next time", Color3.new(1, 1, 1))	
					bosssuccess = 2
				elseif winner=="Time" then
					game.Workspace.PumpkinDefeated.Value = 0
					serverMessage("You failed to defeat the boss in time", Color3.new(1, 1, 1))	
					bosssuccess = 2
				else
					serverMessage("The boss has been defeated. All survivors receive 50 points", Color3.new(1, 1, 1))	
					game.Workspace.Music.CurrentMusic.Value="None"
					wait(1)
					game.Workspace.Music.Speed.Value=map.VictorySpeed.Value
					game.Workspace.Music.Volume.Value=map.VictoryVolume.Value
					game.Workspace.Music.CurrentMusic.Value=map.VictoryId.Value
					for _, people in pairs(script.LivingPlayers:GetChildren()) do
						_G.addPoints(people.Value, 50)
						_G.addWins(people.Value, 1)
						game:GetService("BadgeService"):AwardBadge(people.Value.UserId, map.BadgeID.Value)
					end
					bosssuccess = bosssuccess - 1
					if bosssuccess < 0 then
						bosssuccess = 2
					end
					wait(15)
				end
			end
			--team elim
			if mode=="TE" then
				if winner=="Nobody" then
					serverMessage("Nobody won the match", Color3.new(1, 1, 1))	
				elseif winner=="Red" then
					serverMessage("Red team won the match", Color3.new(1, 1, 1))	
					for _, people in pairs(blueteamdeads) do
						if people~=nil then
							_G.addLosses(people, 1)
							_G.addPoints(people, -10)
						end
					end
					for _, people in pairs(redteamdeads) do
						if people~=nil then
							_G.addPoints(people, 50)
							_G.addWins(people, 1)
						end
					end
					for _, people in pairs(game.Players:GetChildren()) do
						if people.Character~=nil then
							if people.Character.Humanoid.Health>=0 and people.Character:FindFirstChild("Red")~=nil then
								_G.addPoints(people, 50)
								_G.addWins(people, 1)
							end
						end
					end
				elseif winner=="Blue" then
					serverMessage("Blue team won the match", Color3.new(1, 1, 1))	
					for _, people in pairs(redteamdeads) do
						if people~=nil then
							_G.addLosses(people, 1)
							_G.addPoints(people, -10)
						end
					end
					for _, people in pairs(blueteamdeads) do
						if people~=nil then
							_G.addPoints(people, 50)
							_G.addWins(people, 1)
						end
					end
					for _, people in pairs(game.Players:GetChildren()) do
						if people.Character~=nil then
							if people.Character.Humanoid.Health>=0 and people.Character:FindFirstChild("Blue")~=nil then
								_G.addPoints(people, 50)
								_G.addWins(people, 1)
							end
						end
					end
				end
			end
			--Juggernaut
			if mode=="JUGG" then
				if winner=="Nobody" then
					serverMessage("You didn't defeat the juggernaut in time", Color3.new(1, 1, 1))	
				elseif winner=="Juggernaut" then
					serverMessage("The juggernaut has defeated you all", Color3.new(1, 1, 1))						
					for _, people in pairs(blueteamdeads) do
						if people~=nil then
							_G.addLosses(people, 1)
							_G.addPoints(people, -10)
						end
					end
					for _, people in pairs(redteamdeads) do
						if people~=nil then
							_G.addPoints(people, 50)
							_G.addWins(people, 1)
						end
					end
					for _, people in pairs(game.Players:GetChildren()) do
						if people.Character~=nil then
							if people.Character.Humanoid.Health>=0 and people.Character:FindFirstChild("Red")~=nil then
								_G.addPoints(people, 50)
								_G.addWins(people, 1)
							end
						end
					end
				elseif winner=="Players" then
					serverMessage("You took down the juggernaut", Color3.new(1, 1, 1))	
					for _, people in pairs(redteamdeads) do
						
						if people~=nil then
							_G.addLosses(people, 1)
							_G.addPoints(people, -10)
						end
					end
					for _, people in pairs(blueteamdeads) do
						if people~=nil then
							_G.addPoints(people, 50)
							_G.addWins(people, 1)
						end
					end
					for _, people in pairs(game.Players:GetChildren()) do
						if people.Character~=nil then
							if people.Character.Humanoid.Health>=0 and people.Character:FindFirstChild("Blue")~=nil then
								_G.addPoints(people, 50)
								_G.addWins(people, 1)
							end
						end
					end
				end
			end
			wait(3)
			for _, people in pairs(script.LivingPlayers:GetChildren()) do
				people.Value.Character.Ult:Destroy()
				people.Value.Character.Humanoid.Health=0
				people:Destroy()
			end
			resetMusic()
			map:Destroy()
			if boss~=nil then
				boss:Destroy()
			end
			wait(5)
			checkIfReady()
		end
	end
	
	--remove from living list
	for _, people in pairs(players) do
		local tag=Instance.new("ObjectValue")
		tag.Value=people
		tag.Name=people.Name
		tag.Parent=script.LivingPlayers
		local class=string.sub(people.Character.Chest.Middle.Class.Value, 0, 1)..string.lower(string.sub(people.Character.Chest.Middle.Class.Value, 2))
		people.Character.Humanoid.Died:connect(function()
			if mode=="FFA" or mode=="NEWMAP" or mode=="BOSS" then
				if ended==false then
					_G.addLosses(people, 1)
					_G.addPoints(people, -10)
					game.Workspace.Died:Play()
					serverMessage(people.Name.."("..class..") has been eliminated", Color3.new(1, 100/255, 100/255))
				end
				script.LivingPlayers:FindFirstChild(people.Name):Destroy()				
			end
			if mode=="TE" then
				if ended==false then
					if people.Character:FindFirstChild("Red")~=nil then
						table.insert(redteamdeads, people)
						redteam=redteam-1
					else
						table.insert(blueteamdeads, people)
						blueteam=blueteam-1
					end
					serverMessage(people.Name.."("..class..") has been eliminated", Color3.new(1, 100/255, 100/255))
				end
				script.LivingPlayers:FindFirstChild(people.Name):Destroy()	
			end
			if mode=="JUGG" then
				if ended==false then
					if people.Character:FindFirstChild("Red")~=nil then
						table.insert(redteamdeads, people)
						redteam=redteam-1
					else
						table.insert(blueteamdeads, people)
						blueteam=blueteam-1
					end
					serverMessage(people.Name.."("..class..") has been eliminated", Color3.new(1, 100/255, 100/255))
				end
				script.LivingPlayers:FindFirstChild(people.Name):Destroy()	
			end
		end)
	end	
	
	--player leave
	game.Players.DescendantRemoving:connect(function(player)
		if mode=="TE" or mode=="JUGG" then
			if findInTableIndex(redteamdeads, player)~=-1 then					
				table.remove(redteamdeads, findInTableIndex(redteamdeads, player))
			end		
			if findInTableIndex(blueteamdeads, player)~=-1 then					
				table.remove(blueteamdeads, findInTableIndex(blueteamdeads, player))
			end
			if game.ServerStorage.Teams.RedTeam:FindFirstChild(player.Name)~=nil and player.Character:FindFirstChild("Playing")~=nil and player.Characer.Humanoid.Heath>0 then
				game.ServerStorage.Teams.RedTeam:FindFirstChild(player.Name):Destroy()
				redteam=redteam-1
						
			end			
			if game.ServerStorage.Teams.BlueTeam:FindFirstChild(player.Name)~=nil and player.Character:FindFirstChild("Playing")~=nil and player.Characer.Humanoid.Heath>0 then
				game.ServerStorage.Teams.BlueTeam:FindFirstChild(player.Name):Destroy()
				serverMessage(player.Name.."KILLED THIS KID", Color3.new(1, 100/255, 100/255))
				blueteam=blueteam-1	
			end
		end
		if script.LivingPlayers:FindFirstChild(player.Name)~=nil then
			script.LivingPlayers:FindFirstChild(player.Name):Destroy()
		end
	end)
	
	--player death
	script.LivingPlayers.ChildRemoved:connect(function()
		local playersleft=0
		local playerleft
		for _, players in pairs(script.LivingPlayers:GetChildren()) do
			playersleft=playersleft+1
			playerleft=players
		end
		if playersleft==1 and ended==false and mode=="FFA" then
			winner=playerleft.Name
			endGame()
		end
		if playersleft==1 and ended==false and mode=="NEWMAP" then
			winner=playerleft.Name
			endGame()
		end
		if playersleft==0 and ended==false and mode=="BOSS" then
			endGame()
		end
		if mode=="TE" then
			if redteam==0 then
				winner="Blue"
				endGame()
			elseif blueteam==0 then
				winner="Red"
				endGame()
			end
		end
		if mode=="JUGG" then
			if redteam==0 then
				winner="Players"
				endGame()
			elseif blueteam==0 then
				winner="Juggernaut"
				endGame()
			end
		end
	end)
	
	--boss dies	
	if mode=="BOSS" then
		boss.Parent=game.Workspace
		boss.Humanoid.Died:connect(function()
			winner=script.LivingPlayers:GetChildren()[math.random(1, #script.LivingPlayers:GetChildren())].Name
			endGame()
		end)
	end
	
	--kill blocker
	game.Workspace.Blocker.CanCollide=false	
	
	--time out end
	coroutine.resume(coroutine.create(function()
		--ffa		
		if mode=="FFA" or mode=="NEWMAP" then
			wait(limit-10)
			if ended==false then
				serverMessage("Final Strike will begin in 10 seconds", Color3.new(0, 1, 1))
				wait(10)		
				if ended==false then
					for _, people in pairs(script.LivingPlayers:GetChildren()) do
						local eff1 = game.Lighting.Effects.ForceFieldFE.Friendly:Clone()
						eff1.Parent = people.Value.Character
						local eff2 = game.Lighting.Effects.ForceFieldFE.Mark:Clone()
						eff2.Parent = people.Value.Character.Head
						people.Value.Character.HumanoidRootPart.CFrame=CFrame.new(Vector3.new(math.random(-5, 5), 30, math.random(-5, 5)))
					end
					map.Map.SD:Destroy()					
					game.Workspace.Music.CurrentMusic.Value="http://roblox.com/asset/?id=271959455"
					if map.Name == "Champion Stadium" then
						game.Workspace.Music.CurrentMusic.Value="http://roblox.com/asset/?id=271959455"
					end
					game.Workspace.Music.Volume.Value=1
					game.Workspace.Music.Speed.Value=1
					serverMessage("FINAL STRIKE", Color3.new(0, 1, 1))
				end
				--duration until end of match
				wait(120)
				if ended==false then
					coroutine.resume(coroutine.create(function()
						endGame()
					end))
					wait()
					for _, people in pairs(script.LivingPlayers:GetChildren()) do
						people.Value.Character.Humanoid.Health=0
					end
				end
			end
		end
		--boss
		if mode=="BOSS" then
			wait(limit)
			if ended==false then
				winner="Time"
				endGame()
			end
		end
		
		--team elimination
		if mode=="TE" then
			wait(limit)
			if ended==false then
				winner="Nobody"
				endGame()
			end
		end
		if mode=="JUGG" then
			wait(limit)
			if ended==false then
				winner="Nobody"
				endGame()
			end
		end
	end))
end

function resetMusic()	
	game.Workspace.Music.Volume.Value=1
	game.Workspace.Music.Speed.Value=1
	game.Workspace.Music.CurrentMusic.Value="rbxassetid://528388185"
	-- Normal 143571120 1 or 529377392
	-- Tournament 475208168 1
	-- Halloween 528388185 1
	-- Christmas 517993657 0.7
end

function warpPlayers(mode)
	if mode=="TE" then
		local peoplez={}
		for _, people in pairs(game.Players:GetChildren()) do
			if playerReady(people) then
				table.insert(peoplez, people)
			end
		end
		setTeams(peoplez)
	end
	if mode=="JUGG" then
		local peoplez={}
		for _, people in pairs(game.Players:GetChildren()) do
			if playerReady(people) then
				table.insert(peoplez, people)
			end
		end
		pickJugg(peoplez)
	end
	for _, people in pairs(game.Players:GetChildren()) do
		if playerReady(people) then
			getSpot(people, mode)
		end
	end
	serverMessage("STRIKE", Color3.new(0, 1, 1))
end

function checkIfReady()
	game.ServerStorage.Teams.RedTeam:ClearAllChildren()
	game.ServerStorage.Teams.BlueTeam:ClearAllChildren()
	wait(10)
	if map~=nil and map.Parent~=nil then
		map:Destroy()
	end
	resetMusic()
	if getReadyPlayers()>=requiredplayers then
		serverMessage("Intermission, the game will begin in 20 seconds", Color3.new(1, 1, 1))
		wait(10)
		serverMessage("The game will begin in 10 seconds", Color3.new(1, 1, 1))
		wait(10)
		if getReadyPlayers()>=requiredplayers then
			pickMode()
		else
			serverMessage("Not enough players to begin the game", Color3.new(1, 1, 1))
			checkIfReady()
		end
	else
		serverMessage("Not enough players to begin the game", Color3.new(1, 1, 1))
		checkIfReady()
	end
end

checkIfReady()
