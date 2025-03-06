-- Script para exibir ESP de outros jogadores
local p = game:GetService("Players")
local r = game:GetService("RunService")
local lp = p.LocalPlayer
local c = game:GetService("Workspace").CurrentCamera
local d = 3000 -- Distância máxima para exibir ESP
local e = {} -- Tabela de armazenamento

local function a(t)
    if t == lp or e[t] then return end
    
    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 200, 0, 60)
    b.StudsOffset = Vector3.new(0, 2, 0)
    b.AlwaysOnTop = true
    b.Enabled = false
    
    local n = Instance.new("TextLabel")
    n.Parent = b
    n.Size = UDim2.new(1, 0, 0.5, 0)
    n.Position = UDim2.new(0, 0, 0, 0)
    n.BackgroundTransparency = 1
    n.TextColor3 = Color3.new(1, 0, 0)
    n.TextStrokeTransparency = 0.5
    n.Font = Enum.Font.SourceSansBold
    n.TextSize = 14
    
    local h = Instance.new("TextLabel")
    h.Parent = b
    h.Size = UDim2.new(1, 0, 0.5, 0)
    h.Position = UDim2.new(0, 0, 0.5, 0)
    h.BackgroundTransparency = 1
    h.TextColor3 = Color3.new(0, 1, 0)
    h.TextStrokeTransparency = 0.5
    h.Font = Enum.Font.SourceSansBold
    h.TextSize = 14
    
    b.Parent = t.Character and t.Character:FindFirstChild("Head")
    e[t] = { b = b, n = n, h = h }
end

local function u()
    for t, v in pairs(e) do
        if t.Character and t.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local r = t.Character.HumanoidRootPart
            local h = t.Character:FindFirstChild("Head")
            local hm = t.Character:FindFirstChild("Humanoid")
            local s = (lp.Character.HumanoidRootPart.Position - r.Position).Magnitude
            if s <= d and hm and h then
                v.n.Text = string.format("%s\n[%.0f Studs]", t.Name, s)
                v.h.Text = string.format("Vida: %.0f", hm.Health)
                v.b.Enabled = true
                v.b.Parent = h
            else
                v.b.Enabled = false
            end
        else
            if v.b then v.b:Destroy() end
            e[t] = nil
        end
    end
end

local function o(t)
    task.wait(math.random(0.05, 0.2))
    local function s()
        if t.Character then
            a(t)
        end
    end
    
    t.CharacterAdded:Connect(s)
    s()
end

for _, t in pairs(p:GetPlayers()) do
    o(t)
end

p.PlayerAdded:Connect(o)
r.RenderStepped:Connect(function()
    task.wait(math.random(0.03, 0.07))
    u()
end)
