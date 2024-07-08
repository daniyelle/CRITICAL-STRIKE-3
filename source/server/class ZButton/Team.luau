debounce = true
function onTouched(hit)
	local h = hit.Parent:FindFirstChild("Humanoid")
	local v = Instance.new("ObjectValue")
	if hit.Parent:FindFirstChild("Team") then return end
	if hit.Parent:FindFirstChild("Team") then
	else if h ~= nil then
		v.Parent = hit.Parent
		v.Name = "Team"
		end
	end
end
script.Parent.Touched:connect(onTouched)
