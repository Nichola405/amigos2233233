


-- Script para exibir ESP de outros jogadores de forma mais discreta
local p = game:GetService("Players")
local r = game:GetService("RunService")
local lp = p.LocalPlayer
local d = 3000 -- Distância máxima para exibir ESP
local e = {} -- Tabela de armazenamento

-- Função para criar o ESP invisível
local function a(t)
    if t == lp or e[t] then return end
    
    -- Criar um Part invisível para servir como marcador
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.5, 0.5, 0.5)  -- Pequeno para não chamar muita atenção
    part.Shape = Enum.PartType.Ball  -- Usar uma forma não óbvia
    part.CanCollide = false
    part.Anchored = true
    part.Transparency = 1  -- Tornar invisível
    part.Parent = game.Workspace
    
    -- Colocar o marcador na cabeça do jogador
    local h = t.Character and t.Character:FindFirstChild("Head")
    if h then
        part.Position = h.Position
    end
    
    -- Armazenar o marcador para remoção posterior
    e[t] = part
end

-- Função para atualizar a posição do ESP invisível
local function u()
    for t, part in pairs(e) do
        if t.Character and t.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = t.Character.HumanoidRootPart
            local distance = (lp.Character.HumanoidRootPart.Position - root.Position).Magnitude
            
            -- Se o jogador está dentro da distância de exibição
            if distance <= d then
                part.Position = root.Position + Vector3.new(0, 2, 0)  -- Ajustar a posição para acima da cabeça
            else
                part.Position = Vector3.new(0, -1000, 0)  -- Mover para longe, para não ser visível
            end
        else
            -- Remover marcador se o jogador não estiver mais no jogo
            if part then part:Destroy() end
            e[t] = nil
        end
    end
end

-- Função para adicionar o ESP invisível a novos jogadores
local function o(t)
    task.wait(math.random(0.05, 0.2))  -- Atraso aleatório para não ser tão óbvio
    local function s()
        if t.Character then
            a(t)
        end
    end
    
    t.CharacterAdded:Connect(s)
    s()
end

-- Aplicar o ESP invisível a todos os jogadores
for _, t in pairs(p:GetPlayers()) do
    o(t)
end

-- Quando um novo jogador entrar, adicionar o ESP invisível
p.PlayerAdded:Connect(o)

-- Atualizar a posição dos ESPs invisíveis constantemente
r.RenderStepped:Connect(function()
    task.wait(math.random(0.03, 0.07))  -- Atraso para evitar detecção
    u()
end)
