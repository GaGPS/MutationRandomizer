
-- Visual Mutation Preview GUI (Final - Renamed Texts)

local wordPool = {
    "Tranquil", "Ascended", "Radiant", "Rainbow", "Shocked",
    "IronSkin", "Tiny", "Mega", "Golden", "Frozen",
    "Windy", "Inverted", "Shiny"
}

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VisualMutationGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main draggable frame
local box = Instance.new("Frame")
box.Size = UDim2.new(0, 220, 0, 60)
box.Position = UDim2.new(0.5, -110, 0.25, 0)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.Active = true
box.Draggable = false
box.Parent = gui

-- Title drag bar
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0.3, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dragBar.Text = "Mutation Tool"
dragBar.TextColor3 = Color3.new(1, 1, 1)
dragBar.TextScaled = true
dragBar.Font = Enum.Font.GothamBold
dragBar.Parent = box

-- Button
local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(1, 0, 0.7, 0)
runBtn.Position = UDim2.new(0, 0, 0.3, 0)
runBtn.Text = "Randomize Mutation"
runBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
runBtn.TextColor3 = Color3.new(1, 1, 1)
runBtn.TextScaled = true
runBtn.Font = Enum.Font.GothamBold
runBtn.Parent = box

-- Drag logic
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    box.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                             startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = box.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Recursive finder
local function findMachine()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "PetMutationMachine" then
            return obj
        end
    end
    return nil
end

-- Click action
runBtn.MouseButton1Click:Connect(function()
    local target = findMachine()

    if not target then
        runBtn.Text = "Machine Not Found"
        warn("❌ PetMutationMachine not found.")
        return
    end

    if target:FindFirstChild("MutationTag") then
        target.MutationTag:Destroy()
    end

    local tag = Instance.new("BillboardGui")
    tag.Name = "MutationTag"
    tag.Adornee = target:FindFirstChildWhichIsA("BasePart") or target
    tag.Size = UDim2.new(0, 200, 0, 50)
    tag.StudsOffset = Vector3.new(0, 5, 0)
    tag.AlwaysOnTop = true
    tag.Parent = target

    local label = Instance.new("TextLabel", tag)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "🔁 Randomizing Mutation..."

    local fx = Instance.new("Part", target)
    fx.Anchored = true
    fx.CanCollide = false
    fx.Transparency = 1
    fx.Size = Vector3.new(0.1, 0.1, 0.1)
    fx.Position = tag.Adornee.Position + Vector3.new(0, 3, 0)

    local sparkle = Instance.new("ParticleEmitter", fx)
    sparkle.Rate = 10
    sparkle.Lifetime = NumberRange.new(1)
    sparkle.Speed = NumberRange.new(1)
    sparkle.Size = NumberSequence.new(0.2)
    sparkle.Texture = "rbxassetid://243660364"
    sparkle.Color = ColorSequence.new(Color3.fromRGB(255,255,0), Color3.fromRGB(255,150,0))

    task.delay(3, function()
        local chosen = wordPool[math.random(1, #wordPool)]
        label.Text = "🧬 Mutation: " .. chosen
        sparkle.Enabled = false
        fx:Destroy()
    end)
end)
