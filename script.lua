-- 🥥 Coconut Field AutoFarm with Smooth Tweening + AutoClick
-- For modded/private BSS only

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")

local coconutField = workspace:WaitForChild("FieldZones"):WaitForChild("Coconut")

-- Farming toggle
local autofarm = true

-- Define bounds of movement (based on coconut field size)
local fieldSize = coconutField.Size
local fieldCenter = coconutField.Position
local minX = fieldCenter.X - fieldSize.X / 2 + 5
local maxX = fieldCenter.X + fieldSize.X / 2 - 5
local minZ = fieldCenter.Z - fieldSize.Z / 2 + 5
local maxZ = fieldCenter.Z + fieldSize.Z / 2 - 5
local yHeight = fieldCenter.Y + 4 -- Stay above field slightly

-- Smooth move to random point within the field
local function tweenToRandomSpot()
    local targetPos = Vector3.new(
        math.random(minX, maxX),
        yHeight,
        math.random(minZ, maxZ)
    )
    local goal = {CFrame = CFrame.new(targetPos)}
    local tween = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Simulate tool activation (clicking)
local function clickTool()
    if not tool then
        tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
    end
    if tool and tool:FindFirstChild("Activate") then
        tool:Activate()
    elseif tool and tool:FindFirstChild("RemoteFunction") then
        tool.RemoteFunction:InvokeServer()
    end
end

-- Optional jump to dodge coconuts
local function jumpRandomly()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and math.random(1, 5) == 1 then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- MAIN LOOP
task.spawn(function()
    while autofarm do
        clickTool()
        jumpRandomly()
        tweenToRandomSpot()
        task.wait(0.2) -- Delay before next move/click cycle
    end
end)

