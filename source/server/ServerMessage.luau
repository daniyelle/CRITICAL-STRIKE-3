--THIS IS A CLIENT SIDED SCRIPT BUT KEEP IT IN SERVER STORAGE IF U ARE PLANNIGN TO CLONE CS3 USING THIS SHIT *****

wait(.1)

local col = Instance.new("Color3Value") col.Parent = script
local txt = Instance.new("StringValue") txt.Parent = script

game.StarterGui:SetCore('ChatMakeSystemMessage', {
	Text="[Security]: "..txt.Value,
	Color=col.Value
})
wait()
script:Destroy()
