--THIS IS A CLIENT SIDED SCRIPT*****

wait(.1)

local col = Instance.new("Color3Value") col.Parent = script
local txt = Instance.new("StringValue") txt.Parent = script

game.StarterGui:SetCore('ChatMakeSystemMessage', {
	Text="[Security]: "..txt.Value,
	Color=col.Value
})
wait()
script:Destroy()
