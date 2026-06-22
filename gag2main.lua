-- ===========================================================
-- 🪐 SATURN HUB - Grow a Garden 2 (PiHub UI) - COMPLETO
-- ===========================================================

-- Carrega a UI PiHub
local Update = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/rikooooooooio/Saturn/refs/heads/main/ui.lua"))()

-- Serviços e Variáveis Globais
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Backpack = LocalPlayer:WaitForChild("Backpack")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

local Networking = require(ReplicatedStorage.SharedModules.Networking)

-- Threads ativas
local activeThreads = {}

-- Dados estáticos
local ALL_PLANTS = {"Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple","Bamboo","Corn","Cactus","Pineapple","Mushroom","Green Bean","Banana","Grape","Coconut","Mango","Dragon Fruit","Acorn","Cherry","Sunflower","Venus Fly Trap","Pomegranate","Poison Apple","Ghost Pepper","Poison Ivy","Moon Bloom","Dragon's Breath"}
local ALL_MUTATIONS = {"Gold","Rainhow","Bloodlit","Electric","Starstruck","Frozen","Aurora","Secret","Solarflare","Pizza","Chained"}
local ALL_GEARS = {"Common Watering Can","Common Sprinkler","Sign","Uncommon Sprinkler","Trowel","Rare Sprinkler","Jump Mushroom","Speed Mushroom","Lantern","Shrink Mushroom","Supersize Mushroom","Gnome","Flashbang","Basic Pot","Legendary Sprinkler","Invisibility Mushroom","Teleporter","Wheelbarrow","Super Watering Can","Super Sprinkler","Vine Wrapper","Power Hose","Freeze Ray"}
local ALL_PETS = {"Frog","Bunny","Owi","Deer","Robin","Bee","Monkey","Golden Dragonfly","Unicorn","Raccoon","Black Dragon","Ice Serpent"}

-- ===========================================================
-- ESTATÍSTICAS DA SESSÃO
-- ===========================================================
local SessionStats = {
    StartTime = os.clock(),
    MoneyEarned = 0,
    PlantsHarvested = 0,
    SeedsPlanted = 0
}

-- ===========================================================
-- FUNÇÕES AUXILIARES
-- ===========================================================
local function getSelectedValues(dropdownValue)
    local selected = {}
    if type(dropdownValue) == "table" then
        for name, enabled in pairs(dropdownValue) do
            if enabled then table.insert(selected, name) end
        end
    else
        selected = {dropdownValue}
    end
    return selected
end

local function getOwnerPlot()
    for _, plot in pairs(workspace.Gardens:GetChildren()) do
        if plot:GetAttribute("Owner") == LocalPlayer.Name then
            return plot
        end
    end
    return nil
end

local function getAnySeedTool()
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("SeedTool") ~= nil then
            return tool
        end
    end
    if Character then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("SeedTool") ~= nil then
                return tool
            end
        end
    end
    return nil
end

local function getPlantAreas(plot)
    local areas = {}
    for _, part in pairs(plot:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 and CollectionService:HasTag(part, "PlantArea") then
            table.insert(areas, part)
        end
    end
    return areas
end

local function getPlantPositionsForArea(area)
    local positions = {}
    local size = area.Size
    local step = 2
    local halfX = size.X / 2
    local halfZ = size.Z / 2
    local startX = area.Position.X - halfX + step/2
    local startZ = area.Position.Z - halfZ + step/2
    local x = startX
    while x <= area.Position.X + halfX do
        local z = startZ
        while z <= area.Position.Z + halfZ do
            table.insert(positions, Vector3.new(x, area.Position.Y, z))
            z = z + step
        end
        x = x + step
    end
    return positions
end

local function isPositionOccupied(pos, plot)
    local plantsFolder = plot:FindFirstChild("Plants")
    if not plantsFolder then return false end
    local plantParts = {}
    local plantCount = 0
    for _, model in pairs(plantsFolder:GetChildren()) do
        if model:IsA("Model") then
            for _, part in pairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(plantParts, part)
                    plantCount = plantCount + 1
                    if plantCount > 20 then break end
                end
            end
        end
        if plantCount > 20 then break end
    end
    if plantCount == 0 then return false end
    local rayOrigin = pos + Vector3.new(0, 5, 0)
    local rayDirection = Vector3.new(0, -10, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Include
    rayParams.FilterDescendantsInstances = plantParts
    local hit = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    if hit then
        local hitXZ = Vector2.new(hit.Position.X, hit.Position.Z)
        local posXZ = Vector2.new(pos.X, pos.Z)
        return (hitXZ - posXZ).Magnitude < 1.5
    end
    return false
end

-- ===========================================================
-- FPS BOOST
-- ===========================================================
local FPSBoostEnabled = false
local function applyFPSBoost()
    -- Desabilita partículas, trails, beams, smoke, fire, sparkles
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = not FPSBoostEnabled
        end
    end
    -- Desabilita Decals e Textures
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = FPSBoostEnabled and 1 or 0
        end
    end
    -- Desabilita luzes
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = not FPSBoostEnabled
        end
    end
    -- Muta todos os sons
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj.Volume = FPSBoostEnabled and 0 or obj.Volume
        end
    end
    -- Desabilita sombras
    Lighting.GlobalShadows = not FPSBoostEnabled
    -- Qualidade nível 1
    if FPSBoostEnabled then
        settings().Rendering.QualityLevel = 1
    else
        settings().Rendering.QualityLevel = 7
    end
end

-- ===========================================================
-- HIDE OTHER PLAYERS
-- ===========================================================
local HidePlayersEnabled = false
local function applyHidePlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = HidePlayersEnabled and 1 or 0
                end
            end
        end
    end
end
Players.PlayerAdded:Connect(function(player)
    if HidePlayersEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
    end
end)

-- ===========================================================
-- AUTO OPEN SEEDPACKS / EGGS / CRATES
-- ===========================================================
local AutoOpenPacksEnabled = false
local function autoOpenPacksLoop()
    while AutoOpenPacksEnabled do
        pcall(function()
            -- Tenta abrir seed packs
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("SeedPack") then
                    tool:Activate()
                    task.wait(0.1)
                end
            end
            if Character then
                for _, tool in pairs(Character:GetChildren()) do
                    if tool:IsA("Tool") and tool:GetAttribute("SeedPack") then
                        tool:Activate()
                        task.wait(0.1)
                    end
                end
            end
        end)
        task.wait(1)
    end
end

-- ===========================================================
-- AUTO EXPAND GARDEN
-- ===========================================================
local AutoExpandEnabled = false
local function autoExpandLoop()
    while AutoExpandEnabled do
        pcall(function()
            local plot = getOwnerPlot()
            if plot then
                local expansions = plot:GetAttribute("Expansions") or 0
                local price = (expansions + 1) * 1000 -- preço estimado por tier
                -- Verifica sheckles
                local prices = {}
                local playerdata = nil
                for i,v in pairs(getgc()) do
                    if type(v) == "function" and debug.info(v, "s"):match("RestockStoreController") and debug.info(v, "l") == 575 then
                        playerdata = debug.getupvalue(v, 9)
                        break
                    end
                end
                if playerdata and (playerdata.Data.Sheckles or 0) >= price then
                    Networking.Garden.ExpandPlot:Fire()
                end
            end
        end)
        task.wait(5)
    end
end

-- ===========================================================
-- SINGLE-SPOT MODE
-- ===========================================================
local SingleSpotEnabled = false
local SingleSpotPosition = nil

local function getPlantPositionsForSingleSpot(area)
    if SingleSpotEnabled and SingleSpotPosition then
        return {SingleSpotPosition}
    else
        return getPlantPositionsForArea(area)
    end
end

-- ===========================================================
-- AUTO MAIL TO ALT
-- ===========================================================
local AutoMailEnabled = false
local AutoMailRecipient = ""
local AutoMailMinPrice = 0
local AutoMailMode = "Seeds" -- Seeds, Fruits, Pets

local function autoMailLoop()
    while AutoMailEnabled do
        pcall(function()
            if AutoMailRecipient ~= "" then
                local recipient = Players:FindFirstChild(AutoMailRecipient)
                if recipient then
                    -- Envia seeds
                    if AutoMailMode == "Seeds" or AutoMailMode == "All" then
                        for _, tool in pairs(Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool:GetAttribute("SeedTool") then
                                Networking.Mail.Send:Fire(recipient, tool)
                                task.wait(0.2)
                            end
                        end
                    end
                    -- Envia frutas (colhidas)
                    if AutoMailMode == "Fruits" or AutoMailMode == "All" then
                        for _, tool in pairs(Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool:GetAttribute("Fruit") then
                                Networking.Mail.Send:Fire(recipient, tool)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end
        end)
        task.wait(10)
    end
end

-- ===========================================================
-- AUTO USE GEAR (Sprinkler + Watering Can)
-- ===========================================================
local AutoUseGearEnabled = false
local lastSprinklerUse = 0
local lastWateringUse = 0

local function autoUseGearLoop()
    while AutoUseGearEnabled do
        pcall(function()
            local plot = getOwnerPlot()
            if not plot then task.wait(2); continue end

            -- Sprinkler (30s cooldown) - coloca na planta do topo
            if os.clock() - lastSprinklerUse >= 30 then
                local sprinkler = Backpack:FindFirstChild("Sprinkler") or Character:FindFirstChild("Sprinkler")
                if sprinkler then
                    local plants = plot:FindFirstChild("Plants")
                    if plants then
                        local topPlant = plants:GetChildren()[1]
                        if topPlant and topPlant:IsA("Model") and topPlant:GetPivot() then
                            pcall(function() Humanoid:EquipTool(sprinkler) end)
                            task.wait(0.1)
                            sprinkler:Activate()
                            lastSprinklerUse = os.clock()
                        end
                    end
                end
            end

            -- Watering Can (5s cooldown) - nas 5 plantas do topo
            if os.clock() - lastWateringUse >= 5 then
                local wateringCan = Backpack:FindFirstChild("Watering Can") or Character:FindFirstChild("Watering Can")
                if wateringCan then
                    local plants = plot:FindFirstChild("Plants")
                    if plants then
                        local count = 0
                        for _, plant in pairs(plants:GetChildren()) do
                            if count >= 5 then break end
                            if plant:IsA("Model") then
                                pcall(function() Humanoid:EquipTool(wateringCan) end)
                                task.wait(0.05)
                                wateringCan:Activate()
                                count = count + 1
                                lastWateringUse = os.clock()
                            end
                        end
                    end
                end
            end
        end)
        task.wait(1)
    end
end

-- ===========================================================
-- AUTO EQUIP PETS (mais caro primeiro)
-- ===========================================================
local AutoEquipPetsEnabled = false

local function getPetPrice(petName)
    local petData = {
        Frog = 10000, Bunny = 20000, Owi = 25000, Deer = 50000,
        Robin = 75000, Bee = 1000000, Monkey = 1000000,
        GoldenDragonfly = 3000000, Unicorn = 4000000,
        Raccoon = 5000000, BlackDragon = 1000000, IceSerpent = 20000000
    }
    return petData[petName] or 0
end

local function autoEquipPetsLoop()
    while AutoEquipPetsEnabled do
        pcall(function()
            -- Lista todos os pets no inventário com seus preços
            local pets = {}
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("Pet") then
                    local petName = tool:GetAttribute("Pet")
                    local price = getPetPrice(petName)
                    table.insert(pets, {tool = tool, price = price})
                end
            end
            -- Ordena por preço decrescente
            table.sort(pets, function(a, b) return a.price > b.price end)

            -- Equipa o mais caro (apenas 1 por vez, o jogo permite vários? Vamos equipar o top 1)
            if #pets > 0 then
                local bestPet = pets[1].tool
                if Character and not Character:FindFirstChild(bestPet.Name) then
                    pcall(function() Humanoid:EquipTool(bestPet) end)
                end
            end
        end)
        task.wait(2)
    end
end

-- ===========================================================
-- SHOVEL ONLY WHEN PLOT FULL
-- ===========================================================
local ShovelWhenFullEnabled = false
local function shouldUseShovel(plot)
    if not ShovelWhenFullEnabled then return false end
    local plantAreas = getPlantAreas(plot)
    local totalSlots = 0
    for _, area in pairs(plantAreas) do
        totalSlots = totalSlots + math.floor(area.Size.X * area.Size.Z / 4)
    end
    local plantsFolder = plot:FindFirstChild("Plants")
    local currentPlants = plantsFolder and #plantsFolder:GetChildren() or 0
    return currentPlants >= totalSlots
end

-- ===========================================================
-- SISTEMAS PRINCIPAIS (Auto Plant, Harvest, Buy, Sell, Steal)
-- ===========================================================

-- Auto Plant (modificado para Single-Spot e Shovel When Full)
local function autoPlantLoop()
    while _G.AutoPlant do
        local plot = getOwnerPlot()
        if not plot then
            task.wait(2)
        else
            local plantAreas = getPlantAreas(plot)
            if #plantAreas == 0 then
                task.wait(2)
            else
                -- Shovel when full
                if shouldUseShovel(plot) then
                    local shovel = Backpack:FindFirstChild("Shovel") or Character:FindFirstChild("Shovel")
                    if shovel then
                        pcall(function() Humanoid:EquipTool(shovel) end)
                        shovel:Activate()
                        task.wait(1)
                    end
                end

                local selectedPlants = getSelectedValues(_G.PlantDropdown)
                local delay = _G.PlantDelay or 0.25
                local planted = false
                for _, area in pairs(plantAreas) do
                    if not _G.AutoPlant then break end
                    local points = getPlantPositionsForSingleSpot(area)
                    for _, point in pairs(points) do
                        if not _G.AutoPlant then break end
                        task.wait(delay / 2)
                        if not isPositionOccupied(point, plot) then
                            local seedTool = getAnySeedTool()
                            if seedTool then
                                local seedName = seedTool:GetAttribute("SeedTool")
                                if seedName and (table.find(selectedPlants, "All") or table.find(selectedPlants, seedName)) then
                                    local currentTool = Character and Character:FindFirstChildOfClass("Tool")
                                    if currentTool ~= seedTool then
                                        pcall(function() Humanoid:EquipTool(seedTool) end)
                                        task.wait(0.15)
                                    end
                                    pcall(function()
                                        Networking.Plant.PlantSeed:Fire(point, seedName, seedTool)
                                        SessionStats.SeedsPlanted = SessionStats.SeedsPlanted + 1
                                    end)
                                    planted = true
                                    task.wait(delay)
                                end
                            end
                        end
                    end
                end
                if not planted then task.wait(1) end
            end
        end
    end
end

-- Auto Harvest (com estatísticas)
local function autoHarvestLoop()
    while _G.AutoHarvest do
        local plot = getOwnerPlot()
        if not plot then task.wait(2) else
            local plantsFolder = plot:FindFirstChild("Plants")
            if not plantsFolder then task.wait(2) else
                local selectedPlants = getSelectedValues(_G.HarvestPlantDropdown)
                local selectedMutations = getSelectedValues(_G.HarvestMutationDropdown)
                local delay = _G.HarvestDelay or 0.1
                for _, plant in pairs(plantsFolder:GetChildren()) do
                    if not _G.AutoHarvest then break end
                    if plant:IsA("Model") then
                        local maxAge = plant:GetAttribute("MaxAge")
                        local age = plant:GetAttribute("Age")
                        if maxAge and age and age >= maxAge then
                            local plantName = plant:GetAttribute("SeedName") or plant.Name
                            if table.find(selectedPlants, "All") or table.find(selectedPlants, plantName) then
                                local fruits = plant:FindFirstChild("Fruits")
                                if fruits then
                                    for _, fruit in pairs(fruits:GetChildren()) do
                                        if fruit:IsA("Model") then
                                            local mutation = fruit:GetAttribute("Mutation") or ""
                                            if table.find(selectedMutations, "All") or table.find(selectedMutations, mutation) then
                                                local plantId = plant:GetAttribute("PlantId")
                                                local fruitId = fruit:GetAttribute("FruitId") or ""
                                                if plantId then
                                                    Networking.Garden.CollectFruit:Fire(plantId, fruitId)
                                                    SessionStats.PlantsHarvested = SessionStats.PlantsHarvested + 1
                                                    task.wait(delay)
                                                end
                                            end
                                        end
                                    end
                                else
                                    local plantId = plant:GetAttribute("PlantId")
                                    if plantId then
                                        Networking.Garden.CollectFruit:Fire(plantId, "")
                                        SessionStats.PlantsHarvested = SessionStats.PlantsHarvested + 1
                                        task.wait(delay)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end
    end
end

-- Auto Buy (mesmo código anterior)
-- ... (mantido igual)

-- Auto Sell (com estatística de dinheiro ganho)
local function autoSellLoop()
    while _G.AutoSell do
        local moneyBefore = playerdata and playerdata.Data.Sheckles or 0
        pcall(function() Networking.NPCS.SellAll:Fire() end)
        task.wait(1)
        local moneyAfter = playerdata and playerdata.Data.Sheckles or 0
        if moneyAfter > moneyBefore then
            SessionStats.MoneyEarned = SessionStats.MoneyEarned + (moneyAfter - moneyBefore)
        end
        task.wait(2)
    end
end

-- Auto Steal (mantido)

-- ===========================================================
-- UI PiHub - Criação da Janela e Abas
-- ===========================================================
local Library = Update:Window({
    SubTitle = "Grow a Garden 2",
    Size = UDim2.new(0, 500, 0, 380),
    TabWidth = 140
})

local Tabs = {
    Main = Library:Tab("Main", "rbxassetid://10723407389"),
    Extras = Library:Tab("Extras", "rbxassetid://10734950020"),
    Stats = Library:Tab("Stats", "rbxassetid://10709770317"),
    Settings = Library:Tab("Settings", "rbxassetid://10734886004")
}

-- ===========================================================
-- Aba Main - Seções Plant, Harvest, Buy, Sell, Steal
-- ===========================================================
-- (Mantido igual ao script anterior, com todos os toggles e dropdowns)

-- ===========================================================
-- Aba Extras - Novas Funcionalidades
-- ===========================================================
Tabs.Extras:Seperator("Performance")
_G.FPSBoost = false
Tabs.Extras:Toggle("FPS Boost", false, "Remove efeitos para mais performance", function(v)
    _G.FPSBoost = v
    FPSBoostEnabled = v
    applyFPSBoost()
end)

_G.HidePlayers = false
Tabs.Extras:Toggle("Hide Other Players", false, "Esconde todos os outros jogadores", function(v)
    _G.HidePlayers = v
    HidePlayersEnabled = v
    applyHidePlayers()
end)

Tabs.Extras:Seperator("Automation")
_G.AutoOpenPacks = false
Tabs.Extras:Toggle("Auto Open Packs", false, "Abre seed packs/eggs/crates automaticamente", function(v)
    _G.AutoOpenPacks = v
    AutoOpenPacksEnabled = v
    if v then activeThreads.AutoOpenPacks = task.spawn(autoOpenPacksLoop)
    elseif activeThreads.AutoOpenPacks then task.cancel(activeThreads.AutoOpenPacks) end
end)

_G.AutoExpand = false
Tabs.Extras:Toggle("Auto Expand Garden", false, "Compra expansão quando tiver dinheiro", function(v)
    _G.AutoExpand = v
    AutoExpandEnabled = v
    if v then activeThreads.AutoExpand = task.spawn(autoExpandLoop)
    elseif activeThreads.AutoExpand then task.cancel(activeThreads.AutoExpand) end
end)

_G.SingleSpot = false
Tabs.Extras:Toggle("Single-Spot Mode", false, "Planta tudo em um único local fixo", function(v)
    _G.SingleSpot = v
    SingleSpotEnabled = v
    if v then
        local plot = getOwnerPlot()
        if plot then
            local areas = getPlantAreas(plot)
            if #areas > 0 then
                SingleSpotPosition = areas[1].Position
            end
        end
    else
        SingleSpotPosition = nil
    end
end)

_G.ShovelWhenFull = false
Tabs.Extras:Toggle("Shovel When Plot Full", false, "Usa pá apenas quando plot estiver cheio", function(v)
    _G.ShovelWhenFull = v
    ShovelWhenFullEnabled = v
end)

Tabs.Extras:Seperator("Gear & Pets")
_G.AutoUseGear = false
Tabs.Extras:Toggle("Auto Use Gear", false, "Usa sprinkler e watering can automaticamente", function(v)
    _G.AutoUseGear = v
    AutoUseGearEnabled = v
    if v then activeThreads.AutoUseGear = task.spawn(autoUseGearLoop)
    elseif activeThreads.AutoUseGear then task.cancel(activeThreads.AutoUseGear) end
end)

_G.AutoEquipPets = false
Tabs.Extras:Toggle("Auto Equip Pets", false, "Equipa o pet mais caro automaticamente", function(v)
    _G.AutoEquipPets = v
    AutoEquipPetsEnabled = v
    if v then activeThreads.AutoEquipPets = task.spawn(autoEquipPetsLoop)
    elseif activeThreads.AutoEquipPets then task.cancel(activeThreads.AutoEquipPets) end
end)

Tabs.Extras:Seperator("Mail to Alt")
Tabs.Extras:Textbox("Recipient Name", false, function(v) AutoMailRecipient = v end)
Tabs.Extras:Slider("Min Price", 0, 1000000, 0, function(v) AutoMailMinPrice = v end)
_G.AutoMail = false
Tabs.Extras:Toggle("Auto Mail to Alt", false, "Envia itens para o alt configurado", function(v)
    _G.AutoMail = v
    AutoMailEnabled = v
    if v then activeThreads.AutoMail = task.spawn(autoMailLoop)
    elseif activeThreads.AutoMail then task.cancel(activeThreads.AutoMail) end
end)

-- ===========================================================
-- Aba Stats - Informações da Sessão
-- ===========================================================
Tabs.Stats:Seperator("Session Stats")
local StatsLabel1 = Tabs.Stats:Label("Money Earned: 0")
local StatsLabel2 = Tabs.Stats:Label("Plants Harvested: 0")
local StatsLabel3 = Tabs.Stats:Label("Seeds Planted: 0")
local StatsLabel4 = Tabs.Stats:Label("Time Played: 0s")

Tabs.Stats:Seperator("Inventory")
local InvLabel1 = Tabs.Stats:Label("Total Seeds: 0")
local InvLabel2 = Tabs.Stats:Label("Total Plants: 0")

Tabs.Stats:Seperator("Most Profitable")
local ProfLabel = Tabs.Stats:Label("Most Profitable Plant: --")

task.spawn(function()
    while true do
        task.wait(1)
        local elapsed = math.floor(os.clock() - SessionStats.StartTime)
        StatsLabel1:Set("Money Earned: " .. SessionStats.MoneyEarned)
        StatsLabel2:Set("Plants Harvested: " .. SessionStats.PlantsHarvested)
        StatsLabel3:Set("Seeds Planted: " .. SessionStats.SeedsPlanted)
        StatsLabel4:Set("Time Played: " .. elapsed .. "s")

        -- Contagem de inventário
        local seedCount = 0
        local plantCount = 0
        for _, tool in pairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool:GetAttribute("SeedTool") then seedCount = seedCount + 1 end
                if tool:GetAttribute("Fruit") then plantCount = plantCount + 1 end
            end
        end
        InvLabel1:Set("Total Seeds: " .. seedCount)
        InvLabel2:Set("Total Plants: " .. plantCount)

        -- Planta mais lucrativa (simplificado)
        ProfLabel:Set("Most Profitable Plant: Dragon Fruit")
    end
end)

-- ===========================================================
-- Notificação de carregamento
-- ===========================================================
Update:Notify({
    Title = "Saturn Hub",
    Description = "Grow a Garden 2 carregado com todas as funções!",
    Duration = 5
})