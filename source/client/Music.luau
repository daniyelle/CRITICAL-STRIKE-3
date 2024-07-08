local player=game.Players.LocalPlayer
local addaudio = Instance.new("Sound") addaudio.Parent = script addaudio.Name = "Audio"
player:WaitForChild("Mute")
script:WaitForChild("Audio")
local audio=script.Audio
local source=game.Workspace.Music.CurrentMusic
local speed=game.Workspace.Music.Speed
local volume=game.Workspace.Music.Volume
local mute=player.Mute

function playmusic()
	if source.Value=="None" then
		audio:Stop()
	else
		audio:Stop()
		audio.SoundId=source.Value
		if mute.Value==true then
			audio.Volume=0
		else
			audio.Volume=volume.Value
		end
		audio.PlaybackSpeed=speed.Value
		audio:Play()
	end
end

mute.Changed:connect(function()
	if mute.Value==true then
		audio.Volume=0
	else
		audio.Volume=volume.Value
	end
end)

source.Changed:connect(function()
	playmusic()
end)

playmusic()
