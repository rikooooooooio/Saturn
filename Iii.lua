-- ===========================================================
-- 🪐 SATURN HUB - Grow a Garden 2 (Saturn UI / PiHub)
-- ===========================================================

-- Carrega a UI Saturn (PiHub)
local Update = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/rikooooooooio/Saturn/refs/heads/main/ui.lua"))()

-- Serviços
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===========================================================
-- NETWORK / DATA (original do WalkyHub)
-- ===========================================================
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then local ok, m = pcall(require, mod); if ok then Net = m end end
end
if not Net then warn("[SaturnHub] Networking module not found"); return end

local _rl = { w = 0, c = 0, cap = 60 }
local function pace()
    local now = os.clock()
    if now - _rl.w >= 1 then _rl.w = now; _rl.c = 0 end
    if _rl.c >= _rl.cap then task.wait(0.05); return pace() end
    _rl.c = _rl.c + 1
end
local function jitter(a, b) a = a or 0.05; b = b or 0.12; return a + math.random() * (b - a) end

local function action(path)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return nil end
        cur = cur[part]
    end
    return cur
end
local function fire(path, ...)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    pace()
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end
local function fireFast(path, ...)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end

-- Replica do jogador
local _replica
local function replica()
    if _replica then return _replica end
    local ok, psc = pcall(function() return require(ReplicatedStorage.ClientModules.PlayerStateClient) end)
    if ok and psc and psc.WaitForLocalReplica then
        local ok2, r = pcall(function() return psc:WaitForLocalReplica(30) end)
        if ok2 and r then _replica = r end
    end
    return _replica
end
local function pdata() local r = replica(); return (r and r.Data) or {} end
local function getSheckles() return tonumber(pdata().Sheckles) or 0 end
local function getTokens()   return tonumber(pdata().Tokens) or 0 end
local function inv(category) local i = pdata().Inventory; return (i and i[category]) or {} end
local function fmt(n)
    n = tonumber(n) or 0
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
    else return tostring(math.floor(n)) end
end
local function invNames(category)
    local out = {}
    for k, v in pairs(inv(category)) do
        local name, count
        if type(v) == "table" then
            name = v.Name or v.ItemName or v.Type or (type(k) == "string" and not v.Name and k) or tostring(k)
            count = tonumber(v.Count) or tonumber(v.Amount) or 1
        elseif type(v) == "number" then
            name, count = tostring(k), v
        else
            name, count = tostring(k), 1
        end
        if name then out[name] = (out[name] or 0) + (count or 1) end
    end
    return out
end

-- ===========================================================
-- CATÁLOGOS E PLOT (originais)
-- ===========================================================
local function seedCatalog()
    local out = {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.SeedData) end)
    if ok and type(data) == "table" then
        for _, e in pairs(data) do
            if type(e) == "table" and e.SeedName and e.RestockShop ~= false and e.PurchasePrice then
                out[#out + 1] = { name = e.SeedName, price = tonumber(e.PurchasePrice) or 0, rarity = e.Rarity or "" }
            end
        end
    end
    table.sort(out, function(a, b) return a.price < b.price end)
    if #out == 0 then
        for _, n in ipairs({ "Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple","Bamboo","Corn",
            "Cactus","Pineapple","Mushroom","Green Bean","Banana","Grape","Coconut","Mango","Dragon Fruit",
            "Acorn","Cherry","Sunflower","Venus Fly Trap","Pomegranate","Poison Apple","Moon Bloom",
            "Dragon's Breath","Ghost Pepper","Poison Ivy" }) do out[#out + 1] = { name = n, price = 0, rarity = "" } end
    end
    return out
end
local function gearCatalog()
    local out, seen = {}, {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.GearShopData) end)
    if ok and data and type(data.Data) == "table" then
        for _, e in pairs(data.Data) do
            if type(e) == "table" and e.ItemName and not e.RobuxOnly then
                if not seen[e.ItemName] then seen[e.ItemName] = true; out[#out + 1] = e.ItemName end
            end
        end
    end
    if #out == 0 then
        local ok2, items = pcall(function() return ReplicatedStorage.StockValues.GearShop.Items end)
        if ok2 and items then for _, c in ipairs(items:GetChildren()) do out[#out + 1] = c.Name end end
    end
    table.sort(out)
    return out
end
local CATALOG = seedCatalog()
local SEED_NAMES = {} ; for _, s in ipairs(CATALOG) do SEED_NAMES[#SEED_NAMES + 1] = s.name end
local GEAR_NAMES = gearCatalog()

local function stockOf(shop, name)
    local ok, items = pcall(function() return ReplicatedStorage.StockValues[shop].Items end)
    if not ok or not items then return nil end
    local v = items:FindFirstChild(name)
    return v and tonumber(v.Value) or 0
end

local function myPlot()
    local id = LocalPlayer:GetAttribute("PlotId")
    local gardens = Workspace:FindFirstChild("Gardens")
    if not (id and gardens) then return nil end
    return gardens:FindFirstChild("Plot" .. tostring(id))
end
local function myPlotId() return LocalPlayer:GetAttribute("PlotId") end
local function humanoid() local c = LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") end

local function toolsByAttr(attr, wantName)
    local out = {}
    local function scan(c)
        if not c then return end
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t:GetAttribute(attr) ~= nil then
                if (not wantName) or t:GetAttribute(attr) == wantName or t.Name == wantName then out[#out + 1] = t end
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack")); scan(LocalPlayer.Character)
    return out
end
local function heldToolByAttr(attr)
    local c = LocalPlayer.Character
    local t = c and c:FindFirstChildWhichIsA("Tool")
    if t and t:GetAttribute(attr) ~= nil then return t end
    return nil
end
local function equipByAttr(attr, wantName)
    local t = heldToolByAttr(attr)
    if t and ((not wantName) or t:GetAttribute(attr) == wantName) then return t end
    local tools = toolsByAttr(attr, wantName)
    if #tools == 0 then return nil end
    t = tools[1]
    local hum = humanoid(); if not hum then return nil end
    local ok = pcall(function() hum:EquipTool(t) end)
    if not ok then return nil end
    task.wait(0.22)
    return heldToolByAttr(attr)
end

local function myPlantAreas()
    local out, plot = {}, myPlot()
    if not plot then return out end
    for _, p in ipairs(CollectionService:GetTagged("PlantArea")) do
        if p:IsA("BasePart") and p:IsDescendantOf(plot) then out[#out + 1] = p end
    end
    return out
end
local function plantGrid(spacing)
    local pts, areas = {}, myPlantAreas()
    if #areas == 0 then return pts end
    spacing = math.max(2, spacing or 4)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = areas
    for _, area in ipairs(areas) do
        local ok, cf, size = pcall(function() return area.CFrame, area.Size end)
        if ok then
            local topY = (cf * CFrame.new(0, size.Y/2, 0)).Position.Y
            for dx = -size.X/2 + spacing/2, size.X/2 - spacing/2, spacing do
                for dz = -size.Z/2 + spacing/2, size.Z/2 - spacing/2, spacing do
                    local w = (cf * CFrame.new(dx, 0, dz)).Position
                    local hit = Workspace:Raycast(Vector3.new(w.X, topY + 10, w.Z), Vector3.new(0, -40, 0), params)
                    if hit then pts[#pts + 1] = hit.Position end
                end
            end
        end
    end
    return pts
end
local function existingPlantPositions()
    local out, plot = {}, myPlot()
    local plants = plot and plot:FindFirstChild("Plants")
    if not plants then return out end
    for _, m in ipairs(plants:GetChildren()) do
        local ok, pivot = pcall(function() return m:GetPivot().Position end)
        if ok then out[#out + 1] = pivot end
    end
    return out
end
local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= Workspace and node:GetAttribute("PlantId") == nil do node = node.Parent end
    if node and node:GetAttribute("PlantId") ~= nil then return node end
    return prompt:FindFirstAncestorWhichIsA("Model")
end
local function ripeHarvests()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local uid = tonumber(m:GetAttribute("UserId"))
                if uid == nil or uid == LocalPlayer.UserId then
                    out[#out + 1] = { plantId = tostring(pid), fruitId = tostring(m:GetAttribute("FruitId") or "") }
                end
            end
        end
    end
    return out
end
local function stealable()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local pos
                local pp = pr.Parent
                if pp and pp:IsA("BasePart") then pos = pp.Position
                elseif m then local ok, pv = pcall(function() return m:GetPivot().Position end); if ok then pos = pv end end
                out[#out + 1] = {
                    owner = tonumber(m:GetAttribute("UserId")) or 0,
                    plantId = tostring(pid),
                    fruitId = tostring(m:GetAttribute("FruitId") or ""),
                    pos = pos,
                }
            end
        end
    end
    return out
end
local function isNight()
    local n = ReplicatedStorage:FindFirstChild("Night")
    return n and n.Value == true
end
local function wildPets()
    local out = {}
    local map = Workspace:FindFirstChild("Map")
    local ref = map and map:FindFirstChild("WildPetRef")
    if ref then for _, p in ipairs(ref:GetChildren()) do
        if p:IsA("BasePart") then
            out[#out + 1] = {
                part = p, name = p:GetAttribute("PetName"),
                price = tonumber(p:GetAttribute("Price")) or 0,
                owner = tonumber(p:GetAttribute("OwnerUserId")) or 0,
                pos = p.Position,
            }
        end
    end end
    return out
end
local function atPosition(pos, fn)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local saved = hrp.CFrame
    pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end)
    task.wait(0.45)
    local ok = pcall(fn)
    task.wait(0.15)
    if hrp and hrp.Parent then pcall(function() hrp.CFrame = saved end) end
    return ok
end
local function myBasePos()
    local plot = myPlot(); if not plot then return nil end
    for _, tag in ipairs({ "GardenTotalArea", "GardenZone" }) do
        for _, p in ipairs(CollectionService:GetTagged(tag)) do
            if p:IsA("BasePart") and p:IsDescendantOf(plot) then
                return Vector3.new(p.Position.X, p.Position.Y - p.Size.Y / 2 + 5, p.Position.Z)
            end
        end
    end
    local sp = plot:FindFirstChild("SpawnPoint")
    if sp and sp:IsA("BasePart") then return sp.Position end
    local ok, piv = pcall(function() return plot:GetPivot().Position end)
    return ok and piv or nil
end

-- ===========================================================
-- ESTADO (S) E ESTATÍSTICAS
-- ===========================================================
local S = {
    autoFarm = false,
    autoBuy = false, buySeeds = {}, buyInterval = 5, buyPerTick = 8,
    autoPlant = false, plantSpacing = 4, plantSeed = "Best owned",
    autoHarvest = false, harvestInterval = 2, harvestDelay = 0.01,
    autoSell = false, sellInterval = 15,
    autoExpand = false, autoPot = false, autoDaily = false,
    autoSprinkler = false, sprinklerInterval = 30,
    autoWater = false, waterInterval = 8,
    autoSkill = false, skillStats = {},
    autoEquipPets = false, autoPetSlot = false,
    autoBuyPets = false, maxPetPrice = 25000, petTeleport = true, petBuyInterval = 5,
    sellPets = {}, autoSellPets = false,
    autoEgg = false, autoCrate = false, autoPack = false, openInterval = 4,
    autoGear = false, gearBuy = {}, gearInterval = 10,
    autoSteal = false, stealTeleport = true, stealReturnBase = true, stealDelay = 0.05,
    autoMail = false, autoAcceptGift = false, autoHop = false, hopInterval = 0,
    codeText = "", autoCodes = false, antiAfk = true,
    fpsBoost = false,
    webhookEnabled = false, webhookUrl = "", webhookInterval = 300,
    killed = false,
}
local Stats = { bought = 0, planted = 0, harvested = 0, sold = 0, earned = 0,
    sprinklers = 0, watered = 0, tamed = 0, opened = 0, stolen = 0, codes = 0, startAt = os.clock() }

local _due = {}
local function due(key, period)
    local now = os.clock()
    if not _due[key] or now - _due[key] >= period then _due[key] = now; return true end
    return false
end
local function loopOn(getOn, period, body)
    task.spawn(function()
        while not S.killed do
            if getOn() then
                pcall(body)
                local p = (type(period) == "function") and period() or period
                local e = 0; while e < p and getOn() and not S.killed do task.wait(0.4); e += 0.4 end
            else task.wait(0.4) end
        end
    end)
end
local function picked(t) for _ in pairs(t) do return true end return false end
local function pickMulti(sel, into)
    for k in pairs(into) do into[k] = nil end
    if type(sel) == "table" then for k, v in pairs(sel) do
        if v == true then into[k] = true elseif type(v) == "string" then into[v] = true end
    end end
end

-- ===========================================================
-- FUNÇÕES PRINCIPAIS DO FARM (mantidas iguais)
-- ===========================================================
local function stepBuy()
    if not due("buy", S.buyInterval) then return end
    if not picked(S.buySeeds) then return end
    for _, s in ipairs(CATALOG) do
        if not (S.autoFarm or S.autoBuy) then break end
        if S.buySeeds[s.name] then
            local stock, bought = stockOf("SeedShop", s.name), 0
            while bought < S.buyPerTick do
                if stock ~= nil and stock <= 0 then break end
                if s.price > 0 and getSheckles() < s.price then break end
                local ok = fire("SeedShop.PurchaseSeed", s.name)
                if not ok then break end
                Stats.bought += 1; bought += 1
                if stock ~= nil then stock -= 1 end
                task.wait(jitter(0.1, 0.22))
            end
        end
    end
end

local function pickPlantTool()
    if S.plantSeed ~= "Best owned" and S.plantSeed ~= "" then
        local t = toolsByAttr("SeedTool", S.plantSeed)[1]
        if t then return t end
    end
    local best, bestPrice
    for _, t in ipairs(toolsByAttr("SeedTool")) do
        local nm = t:GetAttribute("SeedTool")
        local price = 0
        for _, s in ipairs(CATALOG) do if s.name == nm then price = s.price; break end end
        if not bestPrice or price > bestPrice then best, bestPrice = t, price end
    end
    return best or toolsByAttr("SeedTool")[1]
end

local function stepPlant()
    local grid = plantGrid(S.plantSpacing)
    if #grid == 0 then return end
    local tool = pickPlantTool(); if not tool then return end
    local hum = humanoid(); if not hum then return end
    if heldToolByAttr("SeedTool") ~= tool then 
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.22) 
    end
    tool = heldToolByAttr("SeedTool"); if not tool then return end
    local seedAttr = tool:GetAttribute("SeedTool")
    if not seedAttr then return end
    local occupied = existingPlantPositions()
    for _, pos in ipairs(grid) do
        if not (S.autoFarm or S.autoPlant) then break end
        local clear = true
        for _, op in ipairs(occupied) do
            if (Vector2.new(pos.X, pos.Z) - Vector2.new(op.X, op.Z)).Magnitude < 1 then clear = false; break end
        end
        if clear then
            if not heldToolByAttr("SeedTool") then
                local nx = pickPlantTool(); if not nx then return end
                pcall(function() hum:EquipTool(nx) end)
                task.wait(0.2)
                tool = heldToolByAttr("SeedTool"); if not tool then return end
                seedAttr = tool:GetAttribute("SeedTool")
                if not seedAttr then return end
            end
            pcall(function() fire("Plant.PlantSeed", pos, seedAttr, tool) end)
            Stats.planted += 1; occupied[#occupied + 1] = pos
            task.wait(jitter(0.08, 0.16))
        end
    end
end

local function maxFruitCap() return tonumber(LocalPlayer:GetAttribute("MaxFruitCapacity")) or 100 end
local function fruitCount()  return tonumber(LocalPlayer:GetAttribute("FruitCount")) or 0 end
local function sellAllNow()
    local ok, res = fireFast("NPCS.SellAll")
    if ok and type(res) == "table" and res.Success then
        local n = tonumber(res.SoldCount) or 0
        Stats.sold += n; Stats.earned += tonumber(res.SellPrice) or 0
        return n
    end
    return 0
end

local function stepHarvest()
    local sell = (S.autoFarm or S.autoSell)
    local list = ripeHarvests()
    if #list == 0 then
        if sell and fruitCount() > 0 then pcall(sellAllNow) end
        return
    end
    local cap = maxFruitCap()
    local d = S.harvestDelay or 0
    for _, h in ipairs(list) do
        if not (S.autoFarm or S.autoHarvest) then break end
        if fruitCount() >= cap - 1 then break end
        pcall(function() fireFast("Garden.CollectFruit", h.plantId, h.fruitId) end)
        Stats.harvested += 1
        if d > 0 then task.wait(d) end
    end
    if sell then pcall(sellAllNow) end
end

local function stepSell()
    if not due("sell", S.sellInterval) then return end
    sellAllNow()
end

local function stepExpand()
    if not due("expand", 12) then return end
    fire("Actions.ExpandGarden")
end
local function stepDaily()
    if not due("daily", 60) then return end
    fire("NPCS.CheckDailyDeal"); task.wait(0.3); fire("NPCS.UseDailyDealAll")
end

-- ===========================================================
-- LOOPS PRINCIPAIS (mantidos)
-- ===========================================================
task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoBuy     then pcall(stepBuy) end
        if S.autoFarm or S.autoPlant   then pcall(stepPlant) end
        if S.autoFarm or S.autoExpand  then pcall(stepExpand) end
        if S.autoFarm or S.autoDaily   then pcall(stepDaily) end
        task.wait(0.55)
    end
end)

task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoHarvest then
            pcall(stepHarvest)
            task.wait(0.05)
        elseif S.autoSell then
            pcall(stepSell)
            task.wait(0.3)
        else
            task.wait(0.4)
        end
    end
end)

-- ===========================================================
-- BOOSTS E PETS (mantidos)
-- ===========================================================
loopOn(function() return S.autoSprinkler end, function() return S.sprinklerInterval end, function()
    local pid = myPlotId(); if not pid then return end
    local placed = existingPlantPositions()
    for _, t in ipairs(toolsByAttr("Sprinkler")) do
        if not S.autoSprinkler then break end
        local hum = humanoid(); if not hum then break end
        pcall(function() hum:EquipTool(t) end)
        task.wait(0.22)
        t = heldToolByAttr("Sprinkler"); if not t then break end
        local grid = plantGrid(8)
        for _, pos in ipairs(grid) do
            local far = true
            for _, op in ipairs(placed) do if (pos - op).Magnitude < 12 then far = false; break end end
            if far then
                fire("Place.PlaceSprinkler", pos, t:GetAttribute("Sprinkler"), t, pid)
                Stats.sprinklers += 1; placed[#placed + 1] = pos; task.wait(0.3)
                break
            end
        end
    end
    pcall(function() humanoid():UnequipTools() end)
end)

loopOn(function() return S.autoWater end, function() return S.waterInterval end, function()
    local t = equipByAttr("WateringCan"); if not t then return end
    local name = t:GetAttribute("WateringCan")
    for _, pos in ipairs(existingPlantPositions()) do
        if not S.autoWater then break end
        fire("WateringCan.UseWateringCan", pos - Vector3.new(0, 0.3, 0), name, t)
        Stats.watered += 1; task.wait(jitter(0.15, 0.3))
    end
end)

loopOn(function() return S.autoSkill end, 6, function()
    if not picked(S.skillStats) then return end
    for stat in pairs(S.skillStats) do
        if not S.autoSkill then break end
        fire("SkillPoints.SpendSkillPoint", stat); task.wait(0.25)
    end
end)

local function ownedPetNames()
    local names, seen = {}, {}
    for nm in pairs(invNames("Pets")) do if not seen[nm] then seen[nm] = true; names[#names + 1] = nm end end
    for _, t in ipairs(toolsByAttr("PetId")) do
        local nm = t:GetAttribute("PetName") or t.Name
        if nm and not seen[nm] then seen[nm] = true; names[#names + 1] = nm end
    end
    table.sort(names); return names
end
local function equippedPetCount()
    local ok, list = fire("Pets.GetEquippedPets")
    if ok and type(list) == "table" then
        local n = 0; for _ in pairs(list) do n += 1 end; return n
    end
    return 0
end
loopOn(function() return S.autoEquipPets end, 12, function()
    local cap = tonumber(LocalPlayer:GetAttribute("MaxEquippedPets")) or 3
    local have = equippedPetCount()
    if have >= cap then return end
    for _, nm in ipairs(ownedPetNames()) do
        if not S.autoEquipPets or have >= cap then break end
        fire("Pets.RequestEquipByName", nm); have += 1; task.wait(0.3)
    end
end)
loopOn(function() return S.autoPetSlot end, 20, function()
    fire("Pets.RequestPurchasePetSlot")
end)
loopOn(function() return S.autoBuyPets end, function() return S.petBuyInterval end, function()
    for _, w in ipairs(wildPets()) do
        if not S.autoBuyPets then break end
        if w.owner == 0 and w.price > 0 and w.price <= S.maxPetPrice and getSheckles() >= w.price then
            if S.petTeleport and w.pos then
                atPosition(w.pos, function() fire("Pets.WildPetTame", w.part) end)
            else
                fire("Pets.WildPetTame", w.part)
            end
            Stats.tamed += 1
            task.wait(jitter(0.3, 0.6))
        end
    end
end)
loopOn(function() return S.autoSellPets end, 4, function()
    if not picked(S.sellPets) then return end
    for _, t in ipairs(toolsByAttr("PetId")) do
        if not S.autoSellPets then break end
        local nm = t:GetAttribute("PetName") or t.Name
        if S.sellPets[nm] then
            local hum = humanoid()
            if hum then pcall(function() hum:EquipTool(t) end); task.wait(0.25) end
            fire("NPCS.SellPet", t:GetAttribute("PetId")); task.wait(0.3)
        end
    end
end)

-- ===========================================================
-- EGGS / CRATES / PACKS (mantidos)
-- ===========================================================
local function openAll(category, path)
    for nm, count in pairs(invNames(category)) do
        if S.killed then break end
        for _ = 1, math.min(count, 25) do
            local ok, res = fire(path, nm)
            if not ok then break end
            if type(res) == "table" and res.Success == false then break end
            Stats.opened += 1; task.wait(jitter(0.25, 0.5))
        end
    end
end
loopOn(function() return S.autoEgg  end, function() return S.openInterval end, function() openAll("Eggs", "Egg.OpenEgg") end)
loopOn(function() return S.autoCrate end, function() return S.openInterval end, function() openAll("Crates", "Crate.OpenCrate") end)
loopOn(function() return S.autoPack  end, function() return S.openInterval end, function() openAll("SeedPacks", "SeedPack.OpenSeedPack") end)

-- ===========================================================
-- SHOP (gear) (mantido)
-- ===========================================================
loopOn(function() return S.autoGear end, function() return S.gearInterval end, function()
    if not picked(S.gearBuy) then return end
    for name in pairs(S.gearBuy) do
        if not S.autoGear then break end
        local stock = stockOf("GearShop", name)
        if stock == nil or stock > 0 then
            fire("GearShop.PurchaseGear", name); task.wait(jitter(0.2, 0.4))
        end
    end
end)

-- ===========================================================
-- STEAL (mantido)
-- ===========================================================
local function hrpNow() local c = LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
loopOn(function() return S.autoSteal end, 1.5, function()
    if not isNight() then return end
    for _, f in ipairs(stealable()) do
        if not (S.autoSteal and isNight()) then break end
        if S.stealTeleport and f.pos then
            local hrp = hrpNow(); if hrp then pcall(function() hrp.CFrame = CFrame.new(f.pos + Vector3.new(0, 4, 0)) end); task.wait(0.4) end
        end
        fire("Steal.BeginSteal", f.owner, f.plantId, f.fruitId)
        fire("Steal.CompleteSteal")
        Stats.stolen += 1
        if S.stealReturnBase then
            local base = myBasePos()
            local hrp = hrpNow()
            if base and hrp then
                pcall(function() hrp.CFrame = CFrame.new(base + Vector3.new(0, 4, 0)) end)
                local t0 = os.clock()
                while LocalPlayer:GetAttribute("CarryingStolenFruit") and os.clock() - t0 < 3 and S.autoSteal do task.wait(0.15) end
            end
        end
        if (S.stealDelay or 0) > 0 then task.wait(S.stealDelay) end
    end
end)

-- ===========================================================
-- MISC (mail, gifts, hop, anti-afk, codes) (mantidos)
-- ===========================================================
loopOn(function() return S.autoMail end, 30, function()
    local ok, box = fire("Mailbox.OpenInbox")
    if ok and type(box) == "table" then
        local mb = box.Mailbox or box.Inbox or box
        for id, entry in pairs(mb) do
            if not S.autoMail then break end
            if type(entry) == "table" and (entry.Claimed == true or entry.IsClaimed == true) then
            else
                fire("Mailbox.Claim", id); task.wait(0.3)
            end
        end
    end
end)
pcall(function()
    local g = action("Gifting.Prompted")
    if g and g.OnClientEvent then
        g.OnClientEvent:Connect(function(fromPlayer)
            if S.autoAcceptGift and fromPlayer then pcall(function() fire("Gifting.Response", fromPlayer, true) end) end
        end)
    end
end)
loopOn(function() return S.autoHop end, function() return math.max(60, S.hopInterval) end, function()
    if S.hopInterval > 0 then fire("AntiAfk.RequestHop") end
end)
if VirtualUser then
    LocalPlayer.Idled:Connect(function()
        if S.killed or not S.antiAfk then return end
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
    end)
end
local CODE_LIST = {}
local triedCodes = {}
local function redeemCodes(list)
    local n = 0
    for _, code in ipairs(list) do
        if code ~= "" and not triedCodes[code] then
            local ok, res = fire("Settings.SubmitCode", code)
            triedCodes[code] = true
            if ok and res == true then n += 1; Stats.codes += 1 end
            task.wait(0.4)
        end
    end
    return n
end
loopOn(function() return S.autoCodes end, 120, function() redeemCodes(CODE_LIST) end)

-- ===========================================================
-- PERFORMANCE (mantido)
-- ===========================================================
local _fpsApplied = false
local function applyFpsBoost(on)
    if on and not _fpsApplied then
        _fpsApplied = true
        pcall(function()
            Lighting.GlobalShadows = false; Lighting.FogEnd = 1e6
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e.Enabled = false end
            end
            if sethiddenproperty then pcall(sethiddenproperty, Lighting, "Technology", 1) end
            settings().Rendering.QualityLevel = 1
        end)
        task.spawn(function()
            for _, d in ipairs(Workspace:GetDescendants()) do
                if not S.fpsBoost then break end
                if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false
                elseif d:IsA("Texture") or d:IsA("Decal") then pcall(function() d.Transparency = 1 end) end
            end
        end)
    end
end

-- ===========================================================
-- WEBHOOK (mantido)
-- ===========================================================
local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local function hms(sec)
    sec = math.floor(sec); local h = sec//3600; local m = (sec%3600)//60
    if h > 0 then return string.format("%dh %dm", h, m) end
    if m > 0 then return string.format("%dm %ds", m, sec%60) end
    return sec .. "s"
end
local function sendWebhook(isTest)
    if not httpRequest then warn("[Webhook] Executor exposes no HTTP request fn"); return false end
    if not string.match(S.webhookUrl or "", "^https?://") then warn("[Webhook] Set a valid webhook URL"); return false end
    local payload = { username = "Grow a Garden 2", embeds = { {
        title = "🌱 Farm Report — " .. LocalPlayer.Name, color = 5763719,
        fields = {
            { name = "💰 Sheckles", value = fmt(getSheckles()), inline = true },
            { name = "🪙 Tokens",   value = fmt(getTokens()),   inline = true },
            { name = "🌾 Plot",     value = tostring((myPlot() and myPlot().Name) or "?"), inline = true },
            { name = "📊 Session",  value = string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
                Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned)), inline = false },
            { name = "✨ Extras",   value = string.format("sprinklers %d · watered %d · tamed %d · opened %d · stolen %d",
                Stats.sprinklers, Stats.watered, Stats.tamed, Stats.opened, Stats.stolen), inline = false },
            { name = "⏱️ Uptime",   value = hms(os.clock() - Stats.startAt), inline = true },
        }, footer = { text = "SaturnHub · GAG2" },
    } } }
    local ok, res = pcall(function()
        return httpRequest({ Url = S.webhookUrl, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
    end)
    local code = ok and res and (res.StatusCode or res.Status or res.status_code)
    local good = ok and (code == nil or code == 200 or code == 204)
    if isTest then warn("[Webhook] " .. (good and "Test sent ✅" or ("Failed (" .. tostring(code) .. ")"))) end
    return good
end
loopOn(function() return S.webhookEnabled end, function() return S.webhookInterval end, function() sendWebhook(false) end)

-- ===========================================================
-- UI SATURN (PiHub)
-- ===========================================================
local Window = Update:Window({
    SubTitle = "Grow a Garden 2",
    Size = UDim2.new(0, 550, 0, 420),
    TabWidth = 140
})

local Tabs = {
    Farm = Window:Tab("Farm", "rbxassetid://10723407389"),
    Boosts = Window:Tab("Boosts", "rbxassetid://10734950020"),
    Pets = Window:Tab("Pets", "rbxassetid://10709770317"),
    Open = Window:Tab("Eggs & Crates", "rbxassetid://10734886004"),
    Shop = Window:Tab("Shop", "rbxassetid://10723415335"),
    Steal = Window:Tab("Steal", "rbxassetid://10709782497"),
    Misc = Window:Tab("Misc", "rbxassetid://10723424838"),
    Settings = Window:Tab("Settings", "rbxassetid://10734883986")
}

-- ===========================================================
-- FARM TAB
-- ===========================================================
Tabs.Farm:Seperator("Status")
local plotLabel = Tabs.Farm:Label("Plot: …")
local cashLabel = Tabs.Farm:Label("Sheckles: …")
local statLabel = Tabs.Farm:Label("—")

Tabs.Farm:Seperator("Auto-Farm (master)")
Tabs.Farm:Toggle("Auto-Farm (buy+plant+harvest+sell+expand)", false, "", function(v) S.autoFarm = v end)
Tabs.Farm:Toggle("Auto-Expand garden", false, "", function(v) S.autoExpand = v end)
Tabs.Farm:Toggle("Auto-Daily deals", false, "", function(v) S.autoDaily = v end)

Tabs.Farm:Seperator("Buy seeds")
local buySeedsOptions = {"None", "All"}
for _, n in ipairs(SEED_NAMES) do buySeedsOptions[#buySeedsOptions + 1] = n end
Tabs.Farm:Dropdown("Seeds to buy", buySeedsOptions, "None", function(value)
    if value == "All" then
        local all = {}
        for _, s in ipairs(CATALOG) do all[s.name] = true end
        pickMulti(all, S.buySeeds)
    elseif value ~= "None" then
        pickMulti({[value] = true}, S.buySeeds)
    else
        for k in pairs(S.buySeeds) do S.buySeeds[k] = nil end
    end
end)
Tabs.Farm:Toggle("Auto-Buy selected", false, "", function(v) S.autoBuy = v end)
Tabs.Farm:Slider("Buy interval (s)", 1, 30, 5, function(v) S.buyInterval = v end)
Tabs.Farm:Slider("Max buys / seed / pass", 1, 50, 8, function(v) S.buyPerTick = v end)

Tabs.Farm:Seperator("Plant / Harvest / Sell")
local plantOpts = {"Best owned"}
for _, n in ipairs(SEED_NAMES) do plantOpts[#plantOpts + 1] = n end
Tabs.Farm:Dropdown("Seed to plant", plantOpts, "Best owned", function(v) S.plantSeed = v end)
Tabs.Farm:Toggle("Auto-Plant (fill plot)", false, "", function(v) S.autoPlant = v end)
Tabs.Farm:Slider("Plant spacing (studs)", 2, 10, 4, function(v) S.plantSpacing = v end)
Tabs.Farm:Toggle("Auto-Harvest ripe fruit", false, "", function(v) S.autoHarvest = v end)
Tabs.Farm:Slider("Harvest pace (s/fruit)", 0, 0.2, 0.01, function(v) S.harvestDelay = v end)
Tabs.Farm:Toggle("Auto-Sell (auto-sells when pack full)", false, "", function(v) S.autoSell = v end)
Tabs.Farm:Slider("Sell interval (s, sell-only mode)", 3, 120, 15, function(v) S.sellInterval = v end)
Tabs.Farm:Toggle("Auto-Pot grown plants", false, "", function(v) S.autoPot = v end)

-- ===========================================================
-- BOOSTS TAB
-- ===========================================================
Tabs.Boosts:Seperator("Sprinklers & Water")
Tabs.Boosts:Toggle("Auto-place Sprinklers", false, "", function(v) S.autoSprinkler = v end)
Tabs.Boosts:Slider("Sprinkler interval (s)", 10, 120, 30, function(v) S.sprinklerInterval = v end)
Tabs.Boosts:Toggle("Auto-Watering Can", false, "", function(v) S.autoWater = v end)
Tabs.Boosts:Slider("Water interval (s)", 2, 60, 8, function(v) S.waterInterval = v end)

Tabs.Boosts:Seperator("Skill points")
Tabs.Boosts:Textbox("Stats to level (comma-separated)", "BaseSpeed, BaseJump", function(text)
    for k in pairs(S.skillStats) do S.skillStats[k] = nil end
    if text and text ~= "" then
        for stat in string.gmatch(text, "[^,]+") do
            stat = stat:gsub("^%s+", ""):gsub("%s+$", "")
            if stat ~= "" then S.skillStats[stat] = true end
        end
    end
end)
Tabs.Boosts:Toggle("Auto-Spend skill points", false, "", function(v) S.autoSkill = v end)

-- ===========================================================
-- PETS TAB
-- ===========================================================
Tabs.Pets:Seperator("Pets")
Tabs.Pets:Toggle("Auto-Equip pets (to slot cap)", false, "", function(v) S.autoEquipPets = v end)
Tabs.Pets:Toggle("Auto-Buy pet slots", false, "", function(v) S.autoPetSlot = v end)
Tabs.Pets:Toggle("Auto-Buy world pets (walk up & buy)", false, "", function(v) S.autoBuyPets = v end)
Tabs.Pets:Slider("Max pet price (Sheckles)", 1000, 1000000, 25000, function(v) S.maxPetPrice = v end)
Tabs.Pets:Toggle("Teleport to pet (needed to buy)", true, "", function(v) S.petTeleport = v end)
Tabs.Pets:Slider("Pet buy interval (s)", 2, 60, 5, function(v) S.petBuyInterval = v end)

Tabs.Pets:Seperator("Sell pets")
local petSellOptions = {"None", "All"}
for _, n in ipairs(ownedPetNames()) do petSellOptions[#petSellOptions + 1] = n end
Tabs.Pets:Dropdown("Pets to sell", petSellOptions, "None", function(value)
    if value == "All" then
        local all = {}
        for _, n in ipairs(ownedPetNames()) do all[n] = true end
        pickMulti(all, S.sellPets)
    elseif value ~= "None" then
        pickMulti({[value] = true}, S.sellPets)
    else
        for k in pairs(S.sellPets) do S.sellPets[k] = nil end
    end
end)
Tabs.Pets:Toggle("Auto-Sell selected pets", false, "", function(v) S.autoSellPets = v end)

-- ===========================================================
-- EGGS & CRATES TAB
-- ===========================================================
Tabs.Open:Seperator("Auto-Open")
Tabs.Open:Toggle("Auto-Open Eggs", false, "", function(v) S.autoEgg = v end)
Tabs.Open:Toggle("Auto-Open Crates", false, "", function(v) S.autoCrate = v end)
Tabs.Open:Toggle("Auto-Open Seed Packs", false, "", function(v) S.autoPack = v end)
Tabs.Open:Slider("Open interval (s)", 1, 30, 4, function(v) S.openInterval = v end)
Tabs.Open:Seperator("Info")
Tabs.Open:Label("Opens everything you own in each")
Tabs.Open:Label("category. Confirm is automatic.")

-- ===========================================================
-- SHOP TAB
-- ===========================================================
Tabs.Shop:Seperator("Gear shop")
local gearOptions = {"None", "All"}
for _, n in ipairs(GEAR_NAMES) do gearOptions[#gearOptions + 1] = n end
Tabs.Shop:Dropdown("Gear to buy", gearOptions, "None", function(value)
    if value == "All" then
        local all = {}
        for _, n in ipairs(GEAR_NAMES) do all[n] = true end
        pickMulti(all, S.gearBuy)
    elseif value ~= "None" then
        pickMulti({[value] = true}, S.gearBuy)
    else
        for k in pairs(S.gearBuy) do S.gearBuy[k] = nil end
    end
end)
Tabs.Shop:Toggle("Auto-Buy selected gear", false, "", function(v) S.autoGear = v end)
Tabs.Shop:Slider("Gear buy interval (s)", 2, 60, 10, function(v) S.gearInterval = v end)

-- ===========================================================
-- STEAL TAB
-- ===========================================================
Tabs.Steal:Seperator("Auto-Steal (night only)")
Tabs.Steal:Toggle("Auto-Steal others' ripe fruit", false, "", function(v) S.autoSteal = v end)
Tabs.Steal:Toggle("Teleport to fruit (needed to steal)", true, "", function(v) S.stealTeleport = v end)
Tabs.Steal:Toggle("Return to base after each fruit (banks it)", true, "", function(v) S.stealReturnBase = v end)
Tabs.Steal:Slider("Steal speed (delay/fruit, 0=instant)", 0, 1, 0.05, function(v) S.stealDelay = v end)
Tabs.Steal:Seperator("Info")
Tabs.Steal:Label("Night-only · TP to fruit, steal,")
Tabs.Steal:Label("then TP home to bank each one.")

-- ===========================================================
-- MISC TAB
-- ===========================================================
Tabs.Misc:Seperator("Mail & Gifts")
Tabs.Misc:Toggle("Auto-Claim mailbox", false, "", function(v) S.autoMail = v end)
Tabs.Misc:Toggle("Auto-Accept gifts", false, "", function(v) S.autoAcceptGift = v end)

Tabs.Misc:Seperator("Session")
Tabs.Misc:Toggle("Anti-AFK (never idle-kicked)", true, "", function(v) S.antiAfk = v end)
Tabs.Misc:Toggle("Auto server-hop", false, "", function(v) S.autoHop = v end)
Tabs.Misc:Slider("Hop every (min, 0=off)", 0, 120, 0, function(v) S.hopInterval = v * 60 end)

Tabs.Misc:Seperator("Codes")
Tabs.Misc:Textbox("Redeem a code", "enter code", function(text)
    if text and text ~= "" then
        local ok, res = fire("Settings.SubmitCode", text)
        warn("[Code] " .. ((ok and res == true) and ("Redeemed: " .. text) or ("Invalid: " .. text)))
    end
end)
Tabs.Misc:Toggle("Auto-redeem code list", false, "", function(v) S.autoCodes = v end)

-- ===========================================================
-- SETTINGS TAB
-- ===========================================================
Tabs.Settings:Seperator("Performance & Interface")
Tabs.Settings:Toggle("FPS Boost (low graphics)", false, "", function(v) S.fpsBoost = v; applyFpsBoost(v) end)
Tabs.Settings:Button("Unload hub (stops everything)", function()
    S.killed = true
    pcall(function()
        -- Destroi a janela
        local saturnHub = game.CoreGui:FindFirstChild("SaturnHub")
        if saturnHub then saturnHub:Destroy() end
        local screenGui = game.CoreGui:FindFirstChild("ScreenGui")
        if screenGui then screenGui:Destroy() end
    end)
end)

Tabs.Settings:Seperator("Discord Webhook")
Tabs.Settings:Textbox("Webhook URL", "https://discord.com/api/webhooks/...", function(t) S.webhookUrl = t or "" end)
Tabs.Settings:Toggle("Enable reports", false, "", function(v) S.webhookEnabled = v end)
Tabs.Settings:Slider("Report interval (min)", 1, 60, 5, function(v) S.webhookInterval = v * 60 end)
Tabs.Settings:Button("Send test report", function() task.spawn(function() sendWebhook(true) end) end)

Tabs.Settings:Seperator("Info")
Tabs.Settings:Label("Grow a Garden 2 · SaturnHub")
Tabs.Settings:Label("Hotkey: Insert toggles UI")

-- ===========================================================
-- LIVE STATUS (mantido)
-- ===========================================================
task.spawn(function()
    while not S.killed do
        local p = myPlot()
        pcall(function() plotLabel:Set("Plot: " .. (p and p.Name or "?")) end)
        pcall(function() cashLabel:Set(string.format("Sheckles: %s · Tokens: %s", fmt(getSheckles()), fmt(getTokens()))) end)
        pcall(function() statLabel:Set(string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
            Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned))) end)
        task.wait(2)
    end
end)

-- ===========================================================
-- NOTIFICAÇÃO DE CARREGAMENTO
-- ===========================================================
Update:Notify({
    Title = "Saturn Hub",
    Description = "Grow a Garden 2 carregado!",
    Duration = 5
})

warn("[SaturnHub] GAG2 full-auto loaded · " .. #SEED_NAMES .. " seeds · " .. #GEAR_NAMES .. " gear")
print("[SaturnHub] Grow a Garden 2 full-auto loaded.")