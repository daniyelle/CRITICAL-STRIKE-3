script.Parent.Touched:connect(function(part)
    local h =part.Parent:findFirstChild("Humanoid")
    if h then -- If there is a Humanoid then
        h.MaxHealth = 1000
        h.Health = 1000
        h.WalkSpeed = 35
    end
end)
