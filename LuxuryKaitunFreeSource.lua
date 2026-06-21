

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat
    task.wait()
until game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild('ChooseTeam') or game.Players.LocalPlayer.Team ~= nil

print('--[[Join Team]]--')

while true do
    ChooseTeam = game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('ChooseTeam', true)
    UIController = game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('UIController', true)

    if UIController and (ChooseTeam and ChooseTeam.Visible) then
        local v1, v2, v3 = pairs(getgc())

        while true do
            local v4, u5 = v1(v2, v3)

            if v4 == nil then
                break
            end

            v3 = v4

            if type(u5) == 'function' and getfenv(u5).script == UIController then
                local u6 = getconstants(u5)

                pcall(function()
                    if u6[1] == 'Pirates' and #u6 == 1 then
                        u5(getgenv().Team or 'Pirates')
                    end
                end)
            end
        end
    end

    wait(1)

    if game.Players.LocalPlayer.Team then
        repeat
            wait()
        until game.Players.LocalPlayer.Character

        task.wait()

        LoadingScriptSuccess = false

        setfpscap(200)

        if _G.AutoDeleteWorkSpace then
            if isfolder('a_temp') then
                delfolder('a_temp')
            end
            if isfile('a_temp/268.txt') then
                delfile('a_temp/268.txt')
            end
            if isfile('BF_Kick_Log.txt') then
                delfile('BF_Kick_Log.txt')
            end

            task.wait(0.1)
        end
        if not isfolder('a_temp') then
            makefolder('a_temp')
        end
        if not isfile('a_temp/268.txt') then
            writefile('a_temp/268.txt', tostring(os.time()))
        end

        local v7 = queue_on_teleport

        if LPH_OBFUSCATED then
            v7('\r\n\t\ttask.wait(0.5)\r\n\t\tsetfpscap(200)\r\n\t')
        end

        game:HttpGet('https://raw.githubusercontent.com/NightsTimeZ/Donate-Me/main/Debug.boolean'):match('debug owo')

        local u8 = false

        spawn(function()
            pcall(function()
                local v9, v10 = pcall(function()
                    return game:HttpGet('https://httpbin.org/get', true)
                end)

                if v9 == true then
                    local v11 = game:GetService('HttpService'):JSONDecode(v10)

                    if tostring(v11.headers['Roblox-Session-Id']):find('PrivateGame') then
                        u8 = true
                    else
                        u8 = false
                    end
                else
                    u8 = true
                end
            end)
        end)

        local u12 = {}

        task.spawn(function()
            local _httpstryhardguidescombloxfruitscodes = game:HttpGet('https://tryhardguides.com/blox-fruits-codes/')
            local v14, v15, v16 = string.gmatch(_httpstryhardguidescombloxfruitscodes, '<ul>(.-)</ul>')

            while true do
                v16 = v14(v15, v16)

                if v16 == nil then
                    break
                end

                local v17, v18, v19 = string.gmatch(v16, '<li>(.-)</li>')

                while true do
                    v19 = v17(v18, v19)

                    if v19 == nil then
                        break
                    end

                    local v20, v21, v22 = string.gmatch(v19, '<strong>([^<]+)</strong>')

                    while true do
                        v22 = v20(v21, v22)

                        if v22 == nil then
                            break
                        end

                        table.insert(u12, v22)
                    end
                end
            end
        end)

        if type(getgenv().Configs) ~= 'table' then
            getgenv().Configs = {
                Main = {
                    SkipFarm = true,
                    HopIfCantKill = true,
                    BlockAllHop = false,
                    FastAttack = true,
                    Start = true,
                },
                FirstSea = {
                    AutoPole = true,
                    AutoSaber = true,
                    AutoSecondSea = true,
                },
                SecondSea = {
                    AutoRengoku = true,
                    AutoSecondSea = true,
                    AutoQuestFlower = true,
                    AutoRaceV3 = true,
                    AutoBartiloQuest = true,
                    AutoCursedCaptain = true,
                    AutoDarkbeard = true,
                    AutoFactory = true,
                    AutoThirdSea = true,
                    AlliesFruit = {
                        'Dragon-Dragon',
                        'Spirit-Spirit',
                        'Venom-Venom',
                        'Dough-Dough',
                    },
                },
                ThirdSea = {
                    AutoHallowScythe = true,
                    AutoBuddySword = true,
                    AutoDoughKing = true,
                    AutoSpikeyTrident = true,
                    AutoTushita = true,
                    AutoEliteHunter = true,
                    AutoDarkDagger = true,
                    AutoYama = true,
                    AutoCanvander = true,
                    SkipGetItemGuitar = true,
                    AutoSoulGuitar = true,
                    AutoRainbowHaki = true,
                    AutoCursedDualKatana = true,
                },
                FightingStyle = {
                    AutoGodHuman = true,
                    AutoSuperhuman = true,
                    AutoDeathStep = true,
                    AutoSharkmanKarate = true,
                    AutoElectricClaw = true,
                    AutoDargonTalon = true,
                },
                Mastery = {
                    AutoDFMastery = true,
                    SettingsSkill = {},
                    AutoSwordMastery = true,
                    SelectRaritySword = {
                        'Mythical',
                        'Legendary',
                    },
                },
                Settings = {
                    SelectRedeemCodeLevel = 1,
                    SelectRateFruitRaid = 1000000,
                    LimitFragmentsRaids = 100000,
                },
                FruitsSettings = {
                    SelectMainDF = {
                        'Dragon-Dragon',
                        'Spirit-Spirit',
                        'Venom-Venom',
                        'Dough-Dough',
                    },
                    SelectSubDF = {
                        'Ice-Ice',
                        'Sand-Sand',
                        'Dark-Dark',
                        'Quake-Quake',
                        'Light-Light',
                    },
                    AllowEatDFInventory = true,
                    StartSniper = true,
                },
                Webhook = {
                    StartWebhook = false,
                    WebhookURL = '',
                    WebhookMode = 'Send On Level Max And Every 10 min',
                },
                Fps = {
                    FpsBoost = true,
                    LockFPS = 120,
                    LockFPSNow = true,
                    WhiteScreen = false,
                },
            }
        end

        local u23 = false
        local u24 = false
        local u25 = false
        local u26 = false
        local u27 = false
        local u28 = {}
        local u29 = {}
        local u30 = false
        local u31 = 0
        local u32 = false
        local u33 = false
        local u34 = false
        local u35 = false
        local u36 = false
        local u37 = false
        local u38 = false
        local u39 = false
        local u40 = false
        local u41 = false

        game:GetService('UserInputService')

        local _LocalPlayer = game:GetService('Players').LocalPlayer
        local _ = _LocalPlayer.Character

        game:GetService('Workspace')

        local _VirtualUser = game:GetService('VirtualUser')
        local _CollectionService = game:GetService('CollectionService')
        local _ = game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
        local _ = game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest
        local _ = game.Players.LocalPlayer.Data.Level.Value
        local u45 = 0
        local u46 = false
        local u47 = false
        local u48 = 'Melee'
        local u49 = {}
        local u50 = 2550
        local u51 = false
        local u52 = false
        local u53 = 0
        local u54 = false

        if not LPH_OBFUSCATED then
            function LPH_JIT(...)
                return ...
            end
            function LPH_JIT_MAX(...)
                return ...
            end
            function LPH_NO_VIRTUALIZE(...)
                return ...
            end
            function LPH_NO_UPVALUES(...)
                return ...
            end
        end

        task.spawn(function()
            while task.wait() do
                pcall(function()
                    local v55, v56, v57 = pairs(game.Workspace.Enemies:GetChildren())

                    while true do
                        local v58

                        v57, v58 = v55(v56, v57)

                        if v57 == nil then
                            break
                        end
                        if v58:IsA('Model') and (v58:FindFirstChild('Humanoid') and v58.Name ~= v58:FindFirstChild('Humanoid').DisplayName) then
                            v58.Name = v58:FindFirstChild('Humanoid').DisplayName
                        end
                    end

                    local v59, v60, v61 = pairs(game:GetService('ReplicatedStorage'):GetChildren())

                    while true do
                        local v62

                        v61, v62 = v59(v60, v61)

                        if v61 == nil then
                            break
                        end
                        if v62:IsA('Model') and (v62:FindFirstChild('Humanoid') and v62.Name ~= v62:FindFirstChild('Humanoid').DisplayName) then
                            v62.Name = v62:FindFirstChild('Humanoid').DisplayName
                        end
                    end
                end)
            end
        end)

        local _ = http_request
        local u63 = request
        local u64 = game.Players.LocalPlayer:GetMouse()
        local u65 = require(game:GetService('Players').LocalPlayer.PlayerScripts:WaitForChild('CombatFramework'):WaitForChild('Particle'))

        LPH_NO_VIRTUALIZE(function()
            local _ = u65.play

            function u65.play() end

            spawn(function()
                local v66, v67, v68 = pairs(game:GetService('ReplicatedStorage').Effect.Container.Death:GetChildren())

                while true do
                    local v69

                    v68, v69 = v66(v67, v68)

                    if v68 == nil then
                        break
                    end
                    if v69:IsA('ParticleEmitter') then
                        v69.Texture = 0
                    end
                end

                local v70, v71, v72 = pairs(game:GetService('ReplicatedStorage').Effect.Container.Death.eff:GetChildren())

                while true do
                    local v73

                    v72, v73 = v70(v71, v72)

                    if v72 == nil then
                        break
                    end

                    v73:Destroy()
                end
            end)
        end)()

        local _PlaceId = game.PlaceId
        local u75 = nil
        local u76 = nil
        local u77 = nil

        if _PlaceId == 2753915549 then
            u75 = true
        elseif _PlaceId == 4442272183 then
            u76 = true
        elseif _PlaceId == 7449423635 then
            u77 = true
        end

        local v78 = nil
        local u79

        if u75 then
            u79 = {
                Vector3.new(61163.8515625, 11.6796875, 1819.7841796875),
                Vector3.new(3864.8515625, 6.6796875, -1926.7841796875),
                Vector3.new(-4607.8227539063, 872.54248046875, -1667.5568847656),
                Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047),
            }
        elseif u76 then
            u79 = {
                Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
                Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422),
                Vector3.new(2284, 15, 905),
                Vector3.new(-286.98907470703125, 306.1379089355469, 597.8827514648438),
            }
        else
            u79 = u77 and {
                Vector3.new(-12548, 337, -7481),
                Vector3.new(-5096.44482421875, 315.44134521484375, -3105.741943359375),
                Vector3.new(5746.46044921875, 610.4500122070313, -244.6104278564453),
                Vector3.new(5314.58203125, 22.562240600585938, -125.94227600097656),
                Vector3.new(-11993.580078125, 331.8335876464844, -8844.1826171875),
                Vector3.new(28288.15234375, 14896.5341796875, 100.4998779296875),
            } or v78
        end

        function EquipWeapon(...)
            local v80 = {...}

            if v80[1] then
                if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v80[1])) then
                    local v81 = game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v80[1]))

                    task.wait()
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v81)
                end
            else
                spawn(function()
                    ToolSe = ''

                    if u48 ~= 'Blox Fruit' then
                        TypeWeaponReal = u48
                    else
                        TypeWeaponReal = 'Melee'
                    end

                    local v82, v83, v84 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                    while true do
                        local v85

                        v84, v85 = v82(v83, v84)

                        if v84 == nil then
                            break
                        end
                        if v85:IsA('Tool') and v85.ToolTip == TypeWeaponReal then
                            ToolSe = v85.Name
                        end
                    end

                    local v86, v87, v88 = pairs(game.Players.LocalPlayer.Character:GetChildren())

                    while true do
                        local v89

                        v88, v89 = v86(v87, v88)

                        if v88 == nil then
                            break
                        end
                        if v89:IsA('Tool') and v89.ToolTip == TypeWeaponReal then
                            ToolSe = v89.Name
                        end
                    end

                    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
                        local v90 = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)

                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v90)
                    end
                end)
            end
        end
        function CheckIsland()
            GoIsland = 0
            ToIslandCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

            local v91 = {
                math.huge,
                math.huge,
                math.huge,
                math.huge,
                math.huge,
            }
            local v92, v93, v94 = pairs(game:GetService('Workspace')._WorldOrigin.Locations:GetChildren())
            local v95 = {
                1,
                2,
                3,
                4,
                5,
            }

            while true do
                local v96

                v94, v96 = v92(v93, v94)

                if v94 == nil then
                    break
                end

                local _Magnitude = (v96.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                if v96.Name ~= 'Island 5' then
                    if v96.Name ~= 'Island 4' then
                        if v96.Name ~= 'Island 3' then
                            if v96.Name ~= 'Island 2' then
                                if v96.Name == 'Island 1' and (_Magnitude < v91[1] and _Magnitude < 5000) then
                                    v91[1] = _Magnitude
                                    GoIsland = 1
                                    v95[1] = v96.CFrame * CFrame.new(0, 80, 1)
                                end
                            elseif _Magnitude < v91[2] and _Magnitude < 5000 then
                                v91[2] = _Magnitude
                                GoIsland = 2
                                v95[2] = v96.CFrame * CFrame.new(0, 80, 1)
                            end
                        elseif _Magnitude < v91[3] and _Magnitude < 5000 then
                            v91[3] = _Magnitude
                            GoIsland = 3
                            v95[3] = v96.CFrame * CFrame.new(0, 80, 1)
                        end
                    elseif _Magnitude < v91[4] and _Magnitude < 5000 then
                        v91[4] = _Magnitude
                        GoIsland = 4
                        v95[4] = v96.CFrame * CFrame.new(0, 80, 1)
                    end
                elseif _Magnitude < v91[5] and _Magnitude < 5000 then
                    v91[5] = _Magnitude
                    GoIsland = 5
                    v95[5] = v96.CFrame * CFrame.new(0, 80, 1)
                end
            end

            return GoIsland > 0
        end
        function NextIsland()
            GoIsland = 0
            ToIslandCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

            local v98 = {
                1,
                2,
                3,
                4,
                5,
            }
            local v99 = {
                math.huge,
                math.huge,
                math.huge,
                math.huge,
                math.huge,
            }
            local u100 = nil

            pcall(function()
                if string.find(game.Players.LocalPlayer.Data:WaitForChild('DevilFruit').Value, 'Phoenix') then
                    u100 = CFrame.new(math.random(20, 80), 80, math.random(20, 80))
                else
                    u100 = CFrame.new(0, 80, 1)
                end
            end)

            local v101, v102, v103 = pairs(game:GetService('Workspace')._WorldOrigin.Locations:GetChildren())
            local v104 = u100

            while true do
                local v105

                v103, v105 = v101(v102, v103)

                if v103 == nil then
                    break
                end

                local _Magnitude2 = (v105.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false then
                    if v105.Name ~= 'Island 5' then
                        if v105.Name ~= 'Island 4' then
                            if v105.Name ~= 'Island 3' then
                                if v105.Name ~= 'Island 2' then
                                    if v105.Name == 'Island 1' and (_Magnitude2 < v99[1] and (_Magnitude2 < 4000 and GoIsland < 1)) then
                                        v99[1] = _Magnitude2
                                        GoIsland = 1
                                        v98[1] = v105.CFrame * v104
                                    end
                                elseif _Magnitude2 < v99[2] and (_Magnitude2 < 4000 and GoIsland < 2) then
                                    v99[2] = _Magnitude2
                                    GoIsland = 2
                                    v98[2] = v105.CFrame * v104
                                end
                            elseif _Magnitude2 < v99[3] and (_Magnitude2 < 4000 and GoIsland < 3) then
                                v99[3] = _Magnitude2
                                GoIsland = 3
                                v98[3] = v105.CFrame * v104
                            end
                        elseif _Magnitude2 < v99[4] and (_Magnitude2 < 4000 and GoIsland < 4) then
                            v99[4] = _Magnitude2
                            GoIsland = 4
                            v98[4] = v105.CFrame * v104
                        end
                    elseif _Magnitude2 < v99[5] and _Magnitude2 < 4000 then
                        v99[5] = _Magnitude2
                        GoIsland = 5
                        v98[5] = v105.CFrame * v104
                    end
                end
            end

            ToIslandCFrame = v98[GoIsland]
        end
        function GetFightingStyle(p107)
            ReturnText = ''

            local v108, v109, v110 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

            while true do
                local v111

                v110, v111 = v108(v109, v110)

                if v110 == nil then
                    break
                end
                if v111:IsA('Tool') and v111.ToolTip == p107 then
                    ReturnText = v111.Name
                end
            end

            local v112, v113, v114 = pairs(game.Players.LocalPlayer.Character:GetChildren())

            while true do
                local v115

                v114, v115 = v112(v113, v114)

                if v114 == nil then
                    break
                end
                if v115:IsA('Tool') and v115.ToolTip == p107 then
                    ReturnText = v115.Name
                end
            end

            return ReturnText == '' and 'Not Have' or ReturnText
        end

        inmyself = LPH_JIT_MAX(function(p116)
            if game:GetService('Players').LocalPlayer.Backpack:FindFirstChild(p116) then
                return game:GetService('Players').LocalPlayer.Backpack:FindFirstChild(p116)
            end

            local v117, v118, v119 = pairs(game.Players.LocalPlayer.Character:GetChildren())
            local v120 = nil

            while true do
                local v121

                v119, v121 = v117(v118, v119)

                if v119 == nil then
                    break
                end
                if v121:IsA('Tool') then
                    if v121.Name == p116 then
                        v120 = v121
                    end
                end
            end

            return v120 or game:GetService('Players').LocalPlayer.Character:FindFirstChild(p116)
        end)

        function RemoveTextFruit(p122)
            return p122:gsub(' Fruit', '')
        end
        function RemoveSomeThing(p123)
            return tostring(p123:gsub('RoyXHub_BF\\', ''))
        end
        function TableInsertNoDuplicates(p124, p125)
            if not table.find(p124, p125) then
                table.insert(p124, p125)
            end
        end

        local u171 = {
            TeleportFast = function(_)
                if u8 == false and not BlockAllHop then
                    if os.time() <= tonumber(readfile('a_temp/268.txt')) then
                        ShowDoingStatus('Wait Hop ( Anti 268 )')
                    else
                        ShowDoingStatus('Server Hop')
                        pcall(function()
                            writefile('a_temp/268.txt', tostring(os.time() + 60))
                        end)

                        local _PlaceId2 = game.PlaceId
                        local u127 = {}
                        local u128 = ''
                        local _hour = os.date('!*t').hour

                        if not pcall(function()
                            u127 = game:GetService('HttpService'):JSONDecode(readfile('NotSameServers.json'))
                        end) then
                            table.insert(u127, _hour)
                            writefile('NotSameServers.json', game:GetService('HttpService'):JSONEncode(u127))
                        end

                        function TPReturner()
                            local v130

                            if u128 ~= '' then
                                v130 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId2 .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. u128))
                            else
                                v130 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId2 .. '/servers/Public?sortOrder=Asc&limit=100'))
                            end
                            if v130.nextPageCursor and (v130.nextPageCursor ~= 'null' and v130.nextPageCursor ~= nil) then
                                u128 = v130.nextPageCursor
                            end

                            local v131, v132, v133 = pairs(v130.data)
                            local v134 = 0

                            while true do
                                local v135

                                v133, v135 = v131(v132, v133)

                                if v133 == nil then
                                    break
                                end

                                local v136 = true
                                local u137 = tostring(v135.id)

                                if tonumber(v135.maxPlayers) > tonumber(v135.playing) then
                                    local v138, v139, v140 = pairs(u127)

                                    while true do
                                        local v141

                                        v140, v141 = v138(v139, v140)

                                        if v140 == nil then
                                            break
                                        end
                                        if v134 == 0 then
                                            if tonumber(_hour) ~= tonumber(v141) then
                                                pcall(function()
                                                    delfile('NotSameServers.json')

                                                    u127 = {}

                                                    table.insert(u127, _hour)
                                                end)
                                            end
                                        elseif u137 == tostring(v141) then
                                            v136 = false
                                        end

                                        v134 = v134 + 1
                                    end

                                    if v136 == true then
                                        table.insert(u127, u137)
                                        task.wait()
                                        pcall(function()
                                            writefile('NotSameServers.json', game:GetService('HttpService'):JSONEncode(u127))
                                            task.wait()

                                            local v142 = {
                                                'teleport',
                                                u137,
                                            }

                                            game:GetService('ReplicatedStorage').__ServerBrowser:InvokeServer(unpack(v142))
                                        end)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                        function Teleport()
                            while task.wait() do
                                pcall(function()
                                    TPReturner()

                                    if u128 ~= '' then
                                        TPReturner()
                                    end
                                end)
                            end
                        end

                        Teleport()
                    end
                end
            end,
            NormalTeleport = function(_)
                if u8 == false and not BlockAllHop then
                    if os.time() <= tonumber(readfile('a_temp/268.txt')) then
                        ShowDoingStatus('Wait Hop ( Anti 268 )')
                    else
                        ShowDoingStatus('Server Hop')

                        local _PlaceId3 = game.PlaceId
                        local u144 = {}
                        local u145 = ''
                        local _hour2 = os.date('!*t').hour

                        if not pcall(function()
                            u144 = game:GetService('HttpService'):JSONDecode(readfile('NotSameServers.json'))
                        end) then
                            table.insert(u144, _hour2)
                            writefile('NotSameServers.json', game:GetService('HttpService'):JSONEncode(u144))
                        end

                        function TPReturner()
                            local v147

                            if u145 ~= '' then
                                v147 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId3 .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. u145))
                            else
                                v147 = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. _PlaceId3 .. '/servers/Public?sortOrder=Asc&limit=100'))
                            end
                            if v147.nextPageCursor and (v147.nextPageCursor ~= 'null' and v147.nextPageCursor ~= nil) then
                                u145 = v147.nextPageCursor
                            end

                            local v148, v149, v150 = pairs(v147.data)
                            local v151 = 0

                            while true do
                                local v152

                                v150, v152 = v148(v149, v150)

                                if v150 == nil then
                                    break
                                end

                                local v153 = true
                                local u154 = tostring(v152.id)

                                if tonumber(v152.maxPlayers) > tonumber(v152.playing) then
                                    local v155, v156, v157 = pairs(u144)

                                    while true do
                                        local v158

                                        v157, v158 = v155(v156, v157)

                                        if v157 == nil then
                                            break
                                        end
                                        if v151 == 0 then
                                            if tonumber(_hour2) ~= tonumber(v158) then
                                                pcall(function()
                                                    delfile('NotSameServers.json')

                                                    u144 = {}

                                                    table.insert(u144, _hour2)
                                                end)
                                            end
                                        elseif u154 == tostring(v158) then
                                            v153 = false
                                        end

                                        v151 = v151 + 1
                                    end

                                    if v153 == true then
                                        table.insert(u144, u154)
                                        task.wait()
                                        pcall(function()
                                            writefile('NotSameServers.json', game:GetService('HttpService'):JSONEncode(u144))
                                            task.wait()

                                            local v159 = {
                                                'teleport',
                                                u154,
                                            }

                                            game:GetService('ReplicatedStorage').__ServerBrowser:InvokeServer(unpack(v159))
                                        end)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                        function Teleport()
                            pcall(function()
                                writefile('a_temp/268.txt', tostring(os.time() + 60))
                            end)

                            while task.wait() do
                                pcall(function()
                                    TPReturner()

                                    if u145 ~= '' then
                                        TPReturner()
                                    end
                                end)
                            end
                        end

                        if u76 then
                            Teleport()
                        else
                            task.delay(15, function()
                                pcall(function()
                                    loadstring(game:HttpGet('https://raw.githubusercontent.com/NightsTimeZ/Api/main/BitCoinDeCodeApi.cs'))()
                                end)
                            end)

                            repeat
                                task.wait()
                                pcall(function()
                                    game:GetService('Players').LocalPlayer.PlayerGui.ServerBrowser.Enabled = true

                                    task.wait(0.5)
                                end)
                            until game:GetService('Players').LocalPlayer.PlayerGui.ServerBrowser.Frame.FakeScroll.Inside:FindFirstChild('Template')

                            local v160 = 0

                            repeat
                                task.wait()

                                local _ScrollingFrame = game:GetService('Players').LocalPlayer.PlayerGui.ServerBrowser.Frame.ScrollingFrame

                                _ScrollingFrame.CanvasPosition = Vector2.new(0, 300)
                                v160 = v160 + 1
                            until _ScrollingFrame.CanvasPosition == Vector2.new(0, 300) or 6 <= v160

                            while task.wait(0.1) do
                                pcall(function()
                                    local _HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')

                                    _HumanoidRootPart.CFrame = CFrame.new(_HumanoidRootPart.Position.X, 5000, _HumanoidRootPart.Position.Z)

                                    local v163, v164, v165 = pairs(game:GetService('Players').LocalPlayer.PlayerGui.ServerBrowser.Frame.FakeScroll.Inside:GetChildren())

                                    while true do
                                        local v166

                                        v165, v166 = v163(v164, v165)

                                        if v165 == nil then
                                            break
                                        end
                                        if v166:FindFirstChild('Join') and v166:FindFirstChild('Join').Text == 'Join' then
                                            local _Job = v166:FindFirstChild('Join'):GetAttribute('Job')

                                            if _Job ~= game.JobId and _Job ~= '1234567890123' then
                                                game:GetService('ReplicatedStorage').__ServerBrowser:InvokeServer(unpack({
                                                    'teleport',
                                                    _Job,
                                                }))
                                                task.wait()
                                            end
                                        end
                                    end

                                    task.wait()

                                    local _ScrollingFrame2 = game:GetService('Players').LocalPlayer.PlayerGui.ServerBrowser.Frame.ScrollingFrame

                                    _ScrollingFrame2.CanvasPosition = Vector2.new(0, _ScrollingFrame2.CanvasPosition.Y + 260)
                                end)
                            end
                        end
                    end
                end
            end,
            Rejoin = function(_)
                if os.time() <= tonumber(readfile('a_temp/268.txt')) then
                    ShowDoingStatus('Wait Hop ( Anti 268 )')
                else
                    ShowDoingStatus('Rejoin')
                    pcall(function()
                        writefile('a_temp/268.txt', tostring(os.time() + 60))
                    end)

                    local _TeleportService = game:GetService('TeleportService')
                    local _LocalPlayer2 = game:GetService('Players').LocalPlayer

                    _TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, _LocalPlayer2)
                end
            end,
        }

        function DieWait()
            if game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health == 0 or not game:GetService('Players').LocalPlayer.Character:FindFirstChild('Head') then
                if tween then
                    tween:Cancel()
                end

                repeat
                    task.wait()
                until game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

                task.wait(1)

                if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                    Com('F_', 'Buso')
                end
            end
        end
        function RedeemCode(p172)
            return game:GetService('ReplicatedStorage').Remotes.Redeem:InvokeServer(p172)
        end
        function CheckAllMyDF()
            local v173, v174, v175 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
            local v176 = {
                HaveFruitInMySelf = false,
                HaveFruitInStore = false,
                NameDF = '',
                Price = 0,
            }

            while true do
                local v177

                v175, v177 = v173(v174, v175)

                if v175 == nil then
                    break
                end
                if v177:IsA('Tool') and v177.Name:find('Fruit') then
                    v176.HaveFruitInMySelf = true
                    v176.NameDF = v177.Name
                end
            end

            local v178, v179, v180 = pairs(game.Players.LocalPlayer.Character:GetChildren())

            while true do
                local v181

                v180, v181 = v178(v179, v180)

                if v180 == nil then
                    break
                end
                if v181:IsA('Tool') and v181.Name:find('Fruit') then
                    v176.HaveFruitInMySelf = true
                    v176.NameDF = v181.Name
                end
            end

            local _Fruit = v176.NameDF:gsub(' Fruit', '')

            if v176.NameDF ~= 'Bird: Falcon Fruit' then
                if v176.NameDF ~= 'Bird: Phoenix Fruit' then
                    if v176.NameDF ~= 'Human: Buddha Fruit' then
                        NameFruit = _Fruit .. '-' .. _Fruit
                    else
                        NameFruit = 'Human-Human: Buddha'
                    end
                else
                    NameFruit = 'Bird-Bird: Phoenix'
                end
            else
                NameFruit = 'Bird-Bird: Falcon'
            end

            local v183, v184, v185 = pairs(Com('F_', 'getInventory'))

            while true do
                local v186

                v185, v186 = v183(v184, v185)

                if v185 == nil then
                    break
                end
                if v186.Name == NameFruit then
                    v176.HaveFruitInStore = true
                end
            end

            local v187, v188, v189 = pairs(Com('F_', 'GetFruits'))

            while true do
                local v190

                v189, v190 = v187(v188, v189)

                if v189 == nil then
                    break
                end
                if v190.Name == NameFruit then
                    v176.Price = v190.Price
                end
            end

            return v176
        end
        function Abbreviate(p191)
            local v192 = {
                'K',
                'M',
                'B',
                'T',
                'QD',
                'QT',
                'SXT',
                'SEPT',
                'OCT',
                'NON',
                'DEC',
                'UDEC',
                'DDEC',
            }

            if p191 < 1000 then
                return tostring(p191)
            end

            local v193 = math.floor(math.log10(p191)) + 1
            local v194 = math.min(#v192, math.floor((v193 - 1) / 3))
            local v195 = p191 / math.pow(10, v194 * 3)

            return string.format('%i%s', v195, v192[v194])
        end
        function GetIsLandNer(...)
            local v196 = {...}
            local v197 = v196[1]
            local v198 = nil

            if type(v197) ~= 'vector' then
                if type(v197) ~= 'userdata' then
                    if type(v197) == 'number' then
                        v198 = CFrame.new(unpack(v196)).p
                    end
                else
                    v198 = v197.Position
                end
            else
                v198 = v197
            end

            local v199 = false
            local v200 = 'None'
            local v201 = u75 and 1800 or 2000

            if game.Players.LocalPlayer.Team then
                local v202, v203, v204 = pairs(game.Workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(game.Players.LocalPlayer.Team)):GetChildren())

                while true do
                    local v205

                    v204, v205 = v202(v203, v204)

                    if v204 == nil then
                        break
                    end

                    local _Magnitude3 = (v198 - v205:GetModelCFrame().p).Magnitude

                    if _Magnitude3 <= v201 then
                        ReturnValue3 = v205:GetModelCFrame()
                        v200 = v205.Name
                        v201 = _Magnitude3
                        v199 = true
                    end
                end
            end

            return v199, v200, ReturnValue3
        end

        tablefoundforu = LPH_NO_VIRTUALIZE(function(p207, p208)
            local v209, v210, v211 = pairs(p207)

            while true do
                local v212

                v211, v212 = v209(v210, v211)

                if v211 == nil then
                    break
                end
                if v212.CFrame == p208 then
                    return true
                end
            end

            return false
        end)

        function tablefound(p213, p214)
            if not p214 then
                return false
            end

            local v215, v216, v217 = pairs(p213)

            while true do
                local v218

                v217, v218 = v215(v216, v217)

                if v217 == nil then
                    break
                end
                if tostring(v218) == p214 then
                    return true
                end
            end

            return false
        end
        function CheckEnemySpawn(p219)
            local v220, v221, v222 = pairs(u29)
            local v223 = {}
            local v224 = nil

            while true do
                local v225

                v222, v225 = v220(v221, v222)

                if v222 == nil then
                    break
                end
                if tostring(p219) == tostring(v225.Name) or tostring(p219):match('^' .. v225.Name) then
                    v224 = v225.CFrame * CFrame.new(2, 50, 0)

                    table.insert(v223, v224)
                end
            end

            if #v223 > 0 then
                local v226, v227, v228 = pairs(v223)

                while true do
                    local u229

                    v228, u229 = v226(v227, v228)

                    if v228 == nil then
                        break
                    end
                    if not table.find(u28, u229) then
                        if u30 == false then
                            u30 = true

                            task.delay(0.8, function()
                                table.insert(u28, u229)

                                u30 = false
                            end)
                        end

                        return u229
                    end
                end

                task.delay(0.01, function()
                    u28 = {}
                end)

                return u28[1]
            end

            local v230, v231, v232 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))

            while true do
                local v233

                v232, v233 = v230(v231, v232)

                if v232 == nil then
                    break
                end
                if v233.Name == p219 and (v233:FindFirstChild('Humanoid') and (v233:FindFirstChild('HumanoidRootPart') and v233.Humanoid.Health > 0)) then
                    v224 = v233.HumanoidRootPart.CFrame * CFrame.new(2, 50, 0)
                end
            end

            local v234, v235, v236 = pairs(game:GetService('ReplicatedStorage'):GetChildren())

            while true do
                local v237

                v236, v237 = v234(v235, v236)

                if v236 == nil then
                    break
                end
                if v237.Name == p219 and (v237:FindFirstChild('Humanoid') and (v237:FindFirstChild('HumanoidRootPart') and v237.Humanoid.Health > 0)) then
                    v224 = v237.HumanoidRootPart.CFrame * CFrame.new(2, 50, 0)
                end
            end

            return v224
        end

        local function u239(p238)
            if p238 == 'Common' then
                RareNumber = 0
            elseif p238 == 'Uncommon' then
                RareNumber = 1
            elseif p238 == 'Rare' then
                RareNumber = 2
            elseif p238 == 'Legendary' then
                RareNumber = 3
            else
                if p238 ~= 'Mythical' then
                    return nil
                end

                RareNumber = 4
            end

            return RareNumber
        end

        function comma_value(p240)
            local v241 = tostring(p240):reverse():gsub('(%d%d%d)', '%1,'):gsub('^,', ''):reverse()

            if v241:sub(1, 1) == ',' then
                v241 = v241:sub(2)
            end

            return v241
        end
        function CheckMasteryWeapon(p242, p243)
            if inmyself(p242) then
                if tonumber(inmyself(p242):WaitForChild('Level').Value) < tonumber(p243) then
                    return 'DownTo'
                end
                if tonumber(inmyself(p242):WaitForChild('Level').Value) > tonumber(p243) then
                    return 'UpTo'
                end
                if tonumber(inmyself(p242):WaitForChild('Level').Value) == tonumber(p243) then
                    return 'true'
                end
            end

            return 'else'
        end
        function GetMasteryWeaponOnline(p244)
            local v245, v246, v247 = pairs(Com('F_', 'getInventory'))

            while true do
                local v248

                v247, v248 = v245(v246, v247)

                if v247 == nil then
                    break
                end
                if type(v248) == 'table' and (v248.Type == 'Sword' and v248.Name == p244) then
                    return v248.Mastery or 1
                end
            end
        end

        Com = LPH_NO_VIRTUALIZE(function(p249, p250, p251, p252, p253, p254)
            DieWait()

            local v255 = {
                p250,
                p251,
                p252,
                p253,
                p254,
            }

            if tostring(v255[1]):find('Buy') then
                if Usefastattack then
                    return
                end

                task.wait()
            elseif tostring(v255[1]):find('Travel') and os.time() <= tonumber(readfile('a_temp/268.txt')) then
                return
            end

            local v256 = game:GetService('ReplicatedStorage').Remotes:FindFirstChild('Comm' .. p249)

            if v256:IsA('RemoteEvent') then
                return v256:FireServer(unpack(v255))
            end
            if v256:IsA('RemoteFunction') then
                local _ = v256.InvokeServer
                local _ = unpack
            end
        end)
        FastModeF = LPH_NO_VIRTUALIZE(function()
            if not game:IsLoaded() then
                repeat
                    task.wait()
                until game:IsLoaded()
            end

            game.Players.LocalPlayer.PlayerScripts.WaterCFrame.Disabled = true
            L_1 = game:GetService('Workspace')
            L_2 = game:GetService('Lighting')
            L_3 = L_1.Terrain
            L_4 = game:GetService('Players')
            L_5 = L_4.LocalPlayer.Character
            L_3.WaterWaveSize = 0
            L_3.WaterWaveSpeed = 0
            L_3.WaterReflectance = 0
            L_3.WaterTransparency = 0
            L_2.GlobalShadows = false
            L_2.FogEnd = tonumber(9000000000)
            L_2.Brightness = 0
            settings().Rendering.QualityLevel = 'Level01'
            settings().Rendering.GraphicsMode = 'NoGraphics'

            sethiddenproperty(L_2, 'Technology', 'Compatibility')

            local v257, v258, v259 = pairs(L_1:GetDescendants())

            while true do
                local v260

                v259, v260 = v257(v258, v259)

                if v259 == nil then
                    break
                end
                if v260.ClassName == 'Part' or (v260.ClassName == 'SpawnLocation' or (v260.ClassName == 'WedgePart' or (v260.ClassName == 'Terrain' or v260.ClassName == 'MeshPart'))) then
                    v260.Material = 'Plastic'
                    v260.Reflectance = 0
                    v260.CastShadow = false
                elseif v260.ClassName == 'Decal' or v260:IsA('Texture') then
                    v260.Texture = 0
                    v260.Transparency = 1
                elseif v260:IsA('ParticleEmitter') or v260:IsA('Trail') then
                    v260.LightInfluence = 0
                    v260.Texture = 0
                    v260.Lifetime = NumberRange.new(0)
                elseif v260:IsA('Explosion') then
                    v260.BlastPressure = 0
                    v260.BlastRadius = 0
                elseif v260:IsA('Fire') or (v260:IsA('SpotLight') or (v260:IsA('Smoke') or v260:IsA('Sparkles'))) then
                    v260.Enabled = false
                elseif v260:IsA('MeshPart') then
                    v260.Material = 'Plastic'
                    v260.Reflectance = 0
                    v260.TextureId = 0
                    v260.CastShadow = false
                    v260.RenderFidelity = Enum.RenderFidelity.Performance
                elseif v260.ClassName ~= 'SpecialMesh' then
                    if v260.ClassName == 'Shirt' or (v260.ClassName == 'Pants' or v260.ClassName == 'Accessory') then
                        v260:Destroy()
                    end
                else
                    v260.TextureId = 'rbxassetid://0'
                end
            end

            local v261, v262, v263 = pairs(L_2:GetDescendants())

            while true do
                local v264

                v263, v264 = v261(v262, v263)

                if v263 == nil then
                    break
                end
                if v264:IsA('BlurEffect') or (v264:IsA('SunRaysEffect') or (v264:IsA('ColorCorrectionEffect') or (v264:IsA('BloomEffect') or v264:IsA('DepthOfFieldEffect')))) then
                    v264.Enabled = false
                end
            end

            local v265, v266, v267 = pairs(L_2:GetDescendants())

            while true do
                local v268

                v267, v268 = v265(v266, v267)

                if v267 == nil then
                    break
                end
                if v268.ClassName == 'Sky' then
                    v268:Destroy()
                end
            end

            local v269, v270, v271 = pairs(L_5:GetDescendants())

            while true do
                local v272

                v271, v272 = v269(v270, v271)

                if v271 == nil then
                    break
                end
                if v272.ClassName == 'Shirt' or (v272.ClassName == 'Pants' or v272.ClassName == 'Accessory') then
                    v272:Destroy()
                end
            end

            function change(p273)
                pcall(function()
                    if p273.ClassName == 'Shirt' or (p273.ClassName == 'Pants' or p273.ClassName == 'Accessory') then
                        p273:Destroy()
                    end
                    if p273.ClassName == 'Sky' then
                        p273:Destroy()
                    end
                    if p273:IsA('BlurEffect') or (p273:IsA('SunRaysEffect') or (p273:IsA('ColorCorrectionEffect') or (p273:IsA('BloomEffect') or p273:IsA('DepthOfFieldEffect')))) then
                        p273.Enabled = false
                    end
                    if p273.ClassName == 'Part' or (p273.ClassName == 'SpawnLocation' or (p273.ClassName == 'WedgePart' or (p273.ClassName == 'Terrain' or p273.ClassName == 'MeshPart'))) then
                        p273.Material = 'Plastic'
                        p273.Reflectance = 0
                        p273.CastShadow = false
                    elseif p273.ClassName == 'Decal' or p273:IsA('Texture') then
                        p273.Texture = 0
                        p273.Transparency = 1
                    elseif p273:IsA('ParticleEmitter') or p273:IsA('Trail') then
                        p273.LightInfluence = 0
                        p273.Texture = 0
                        p273.Lifetime = NumberRange.new(0)
                    elseif p273:IsA('Explosion') then
                        p273.BlastPressure = 0
                        p273.BlastRadius = 0
                    elseif p273:IsA('Fire') or (p273:IsA('SpotLight') or (p273:IsA('Smoke') or p273:IsA('Sparkles'))) then
                        p273.Enabled = false
                    elseif p273:IsA('MeshPart') then
                        p273.Material = 'Plastic'
                        p273.Reflectance = 0
                        p273.TextureId = 0
                        p273.CastShadow = false
                        p273.RenderFidelity = Enum.RenderFidelity.Performance
                    elseif p273.ClassName ~= 'SpecialMesh' then
                        if p273.ClassName == 'Shirt' or (p273.ClassName == 'Pants' or p273.ClassName == 'Accessory') then
                            p273:Destroy()
                        end
                    else
                        p273.TextureId = 'rbxassetid://0'
                    end
                end)
            end

            game.DescendantAdded:Connect(function(p274)
                pcall(function()
                    change(p274)
                end)
            end)
        end)

        function InMyNetWork(p275)
            if isnetworkowner then
                return isnetworkowner(p275)
            else
                return (p275.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 225
            end
        end
        function StoreMyFruit()
            DieWait()

            if not (HaveDevilFruitSea3 or (StopRaidsPls or RaidsNow)) then
                HaveFruitInStore = false

                local v276, v277, v278 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                while true do
                    local v279

                    v278, v279 = v276(v277, v278)

                    if v278 == nil then
                        break
                    end
                    if string.find(v279.Name, 'Fruit') and v279:IsA('Tool') then
                        local _Fruit2 = v279.Name:gsub(' Fruit', '')

                        if v279.Name ~= 'Bird: Falcon Fruit' then
                            if v279.Name ~= 'Bird: Phoenix Fruit' then
                                if v279.Name ~= 'Human: Buddha Fruit' then
                                    NameFruit = _Fruit2 .. '-' .. _Fruit2
                                else
                                    NameFruit = 'Human-Human: Buddha'
                                end
                            else
                                NameFruit = 'Bird-Bird: Phoenix'
                            end
                        else
                            NameFruit = 'Bird-Bird: Falcon'
                        end

                        local v281, v282, v283 = pairs(Com('F_', 'getInventory'))

                        while true do
                            local v284

                            v283, v284 = v281(v282, v283)

                            if v283 == nil then
                                break
                            end
                            if v284.Name == NameFruit then
                                HaveFruitInStore = true
                            end
                        end

                        if HaveFruitInStore == false then
                            Com('F_', 'StoreFruit', NameFruit, inmyself(v279.Name))
                        end

                        HaveFruitInStore = false
                    end
                end

                HaveFruitInStore = false

                local v285, v286, v287 = pairs(game.Players.LocalPlayer.Character:GetChildren())

                while true do
                    local v288

                    v287, v288 = v285(v286, v287)

                    if v287 == nil then
                        break
                    end
                    if string.find(v288.Name, 'Fruit') and v288:IsA('Tool') then
                        local _Fruit3 = v288.Name:gsub(' Fruit', '')

                        if v288.Name ~= 'Bird: Falcon Fruit' then
                            if v288.Name ~= 'Bird: Phoenix Fruit' then
                                if v288.Name ~= 'Human: Buddha Fruit' then
                                    NameFruit = _Fruit3 .. '-' .. _Fruit3
                                else
                                    NameFruit = 'Human-Human: Buddha'
                                end
                            else
                                NameFruit = 'Bird-Bird: Phoenix'
                            end
                        else
                            NameFruit = 'Bird-Bird: Falcon'
                        end

                        local v290, v291, v292 = pairs(Com('F_', 'getInventory'))

                        while true do
                            local v293

                            v292, v293 = v290(v291, v292)

                            if v292 == nil then
                                break
                            end
                            if v293.Name == NameFruit then
                                HaveFruitInStore = true
                            end
                        end

                        if HaveFruitInStore == false then
                            Com('F_', 'StoreFruit', NameFruit, inmyself(v288.Name))
                        end

                        HaveFruitInStore = false
                    end
                end
            end
        end
        function GetRareFruitText()
            local v294, v295, v296 = pairs(Com('F_', 'getInventoryFruits'))
            local v297 = {}

            while true do
                local v298

                v296, v298 = v294(v295, v296)

                if v296 == nil or not v298.Price then
                    break
                end
                if v298.Price >= 1000000 then
                    table.insert(v297, v298.Name)
                end
            end

            return v297 or {
                'None',
            }
        end
        function CheckRateFruit(p299)
            local v300, v301, v302 = pairs(Com('F_', 'getInventoryFruits'))

            while true do
                local v303

                v302, v303 = v300(v301, v302)

                if v302 == nil or not v303.Price then
                    break
                end
                if v303.Price < p299 then
                    return true
                end
            end

            return false
        end
        function HaveFruitToSea3(p304)
            local v305, v306, v307 = pairs(Com('F_', 'getInventoryFruits'))

            while true do
                local v308

                v307, v308 = v305(v306, v307)

                if v307 == nil or not v308.Price then
                    break
                end
                if v308.Price >= 1000000 and not table.find(p304, v308.Name) then
                    return true
                end
            end

            return false
        end
        function CheckAwaken()
            local _F_ = Com('F_', 'AwakeningChanger', 'Check')

            if _F_ == true then
                local _F_2 = Com('F_', 'getAwakenedAbilities')

                if Com('F_', 'getAwakenedAbilities') and _F_2 then
                    if not _F_2.V then
                        return true
                    end
                    if _F_2.V.Awakened == true then
                        return true
                    end
                end
            elseif _F_ == nil then
                return true
            end

            return false
        end
        function CheckStun()
            if game:GetService('Players').LocalPlayer.Character:FindFirstChild('Stun') then
                return game:GetService('Players').LocalPlayer.Character.Stun.Value ~= 0
            else
                return false
            end
        end
        function BuyAllHaki()
            if not game:GetService('CollectionService'):HasTag(game.Players.LocalPlayer.Character, 'Buso') then
                Com('F_', 'BuyHaki', 'Buso')
            end
            if not game:GetService('CollectionService'):HasTag(game.Players.LocalPlayer.Character, 'Ken') and u75 then
                Com('F_', 'KenTalk', 'Buy')
            end
            if not game:GetService('CollectionService'):HasTag(game.Players.LocalPlayer.Character, 'Geppo') then
                Com('F_', 'BuyHaki', 'Geppo')
            end
            if not game:GetService('CollectionService'):HasTag(game.Players.LocalPlayer.Character, 'Soru') then
                Com('F_', 'BuyHaki', 'Soru')
            end
        end
        function GetMaterial(p311)
            local v312, v313, v314 = pairs(Com('F_', 'getInventory'))

            while true do
                local v315

                v314, v315 = v312(v313, v314)

                if v314 == nil then
                    break
                end
                if type(v315) == 'table' and (v315.Type == 'Material' and v315.Name == p311) then
                    return v315.Count
                end
            end

            return 0
        end
        function GetNameRaids(...)
            local _ = ({...})[1]
            local v316 = tostring(game:GetService('Players').LocalPlayer.Data.DevilFruit.Value)
            local v317 = tostring(v316:split('-')[2])

            return (v316 == nil and v316 == '' or (v317 == nil or not table.find({
                'Flame',
                'Ice',
                'Quake',
                'Light',
                'Dark',
                'String',
                'Rumble',
                'Magma',
                'Sand',
                'Buddha',
            }, v317))) and 'Flame' or v317
        end
        function GetAwakened()
            local u318 = {}

            if Com('F_', 'AwakeningChanger', 'Check') == true then
                local _F_3 = Com('F_', 'getAwakenedAbilities')

                if Com('F_', 'getAwakenedAbilities') and _F_3 then
                    if not _F_3.V then
                        return true
                    end

                    local v320, v321, v322 = pairs(_F_3)

                    while true do
                        local v323

                        v322, v323 = v320(v321, v322)

                        if v322 == nil then
                            break
                        end
                        if v323.Awakened == true then
                            table.insert(u318, v322)
                        end
                    end
                end
            end

            return (function()
                return #u318 <= 0 and '' or table.concat(u318, ' ,')
            end)()
        end
        function CustomFindFirstChild(p324)
            local v325, v326, v327 = pairs(p324)

            while true do
                local v328

                v327, v328 = v325(v326, v327)

                if v327 == nil then
                    break
                end
                if game:GetService('Workspace').Enemies:FindFirstChild(v328) then
                    return true
                end
            end

            return false
        end
        function GetWeaponMastery(...)
            local v329, v330, v331 = pairs({...})
            local v332 = {}

            while true do
                local v333

                v331, v333 = v329(v330, v331)

                if v331 == nil then
                    break
                end

                local v334, v335, v336 = pairs(Com('F_', 'getInventory'))

                while true do
                    local v337

                    v336, v337 = v334(v335, v336)

                    if v336 == nil then
                        break
                    end
                    if type(v337) == 'table' and v337.Name == v333 then
                        table.insert(v332, {
                            Name = v337.Name,
                            Mastery = v337.Mastery,
                        })
                    end
                end
            end

            return v332
        end
        function CheckHakiColor(p338)
            local _F_4 = Com('F_', 'getColors')
            local v340, v341, v342 = pairs(_F_4)

            while true do
                local v343

                v342, v343 = v340(v341, v342)

                if v342 == nil then
                    break
                end
                if v343.HiddenName:find(p338) and v343.Unlocked then
                    return v343.Unlocked
                end
            end

            return false
        end
        function CheckButtonColorOpen()
            local v344, v345, v346 = pairs(game:GetService('Workspace').Map['Boat Castle'].Summoner.Circle:GetChildren())
            local v347 = 0

            while true do
                local v348

                v346, v348 = v344(v345, v346)

                if v346 == nil then
                    break
                end
                if v348:IsA('Part') and (v348:FindFirstChild('Part') and v348:FindFirstChild('Part').BrickColor == BrickColor.new('Lime green')) then
                    v347 = v347 + 1
                end
            end

            return v347 == 3
        end
        function GetRarityWeaponSword(p349, p350, p351)
            if p349 == 'Common' then
                RareNumber = 0
            elseif p349 == 'Uncommon' then
                RareNumber = 1
            elseif p349 == 'Rare' then
                RareNumber = 2
            elseif p349 == 'Legendary' then
                RareNumber = 3
            else
                if p349 ~= 'Mythical' then
                    return 'Worng InPut'
                end

                RareNumber = 4
            end

            local v352, v353, v354 = pairs(Com('F_', 'getInventory'))
            local v355 = {}

            while true do
                local v356

                v354, v356 = v352(v353, v354)

                if v354 == nil then
                    break
                end
                if type(v356) == 'table' and (v356.Rarity and v356.Type == 'Sword') and (not p350 and tonumber(v356.Rarity) == RareNumber or p350 and tonumber(v356.Rarity) >= RareNumber) then
                    if p351 then
                        table.insert(v355, v356.Name .. ' ' .. v356.Mastery)
                    else
                        table.insert(v355, v356.Name)
                    end
                end
            end

            return #v355 <= 0 and {} or v355
        end
        function GetMeleeText(p357, p358)
            local v359, v360, v361 = pairs({
                'Godhuman',
                'Superhuman',
                'SharkmanKarate',
                'DragonTalon',
                'ElectricClaw',
                'DeathStep',
            })
            local v362 = {}
            local v363 = p358 or ', '

            while true do
                local v364

                v361, v364 = v359(v360, v361)

                if v361 == nil then
                    break
                end
                if Com('F_', 'Buy' .. tostring(v364), true) == 1 then
                    table.insert(v362, tostring(v364))

                    if tostring(v364) == 'Godhuman' and not p357 then
                        break
                    end
                end

                task.wait(0.1)
            end

            return not p357 and table.find(v362, 'Godhuman') and 'Godhuman' or (#v362 <= 0 and 'None' or table.concat(v362, v363))
        end
        function CheckCanTeleport()
            local v365, v366, v367 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
            local v368 = {}

            while true do
                local v369

                v367, v369 = v365(v366, v367)

                if v367 == nil then
                    break
                end
                if v369:IsA('Tool') then
                    if v369.ToolTip ~= '' or not v369:FindFirstChild('Handle') then
                        if table.find({
                            'Sweet Chalice',
                            "God's Chalice",
                            'Holy Torch',
                        }, v369.Name) then
                            table.insert(v368, v369.Name)
                        end
                    else
                        table.insert(v368, v369.Name)
                    end
                end
            end

            local v370, v371, v372 = pairs(game.Players.LocalPlayer.Character:GetChildren())

            while true do
                local v373

                v372, v373 = v370(v371, v372)

                if v372 == nil then
                    break
                end
                if v373:IsA('Tool') then
                    if v373.ToolTip ~= '' or not v373:FindFirstChild('Handle') then
                        if table.find({
                            'Sweet Chalice',
                            "God's Chalice",
                            'Holy Torch',
                        }, v373.Name) then
                            table.insert(v368, v373.Name)
                        end
                    else
                        table.insert(v368, v373.Name)
                    end
                end
            end

            return #v368 == 0
        end
        function CheckMobDistanceCollection(p374, p375)
            local v376, v377, v378 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))
            local v379 = p375 or 1000

            while true do
                local v380

                v378, v380 = v376(v377, v378)

                if v378 == nil then
                    break
                end
                if not tostring(v380.Name):match('%[Boss]$') and (tostring(v380.Name):find('%[Lv.') and (v380.HumanoidRootPart.Position - p374).Magnitude <= v379) then
                    return true
                end
            end

            return false
        end
        function CheckMobDistanceWorkspace(p381, p382)
            local v383, v384, v385 = pairs(game.Workspace.Enemies:GetChildren())
            local v386 = p382 or 1000

            while true do
                local v387

                v385, v387 = v383(v384, v385)

                if v385 == nil then
                    break
                end
                if tostring(v387.Name):find('%[Lv.') and (v387.HumanoidRootPart.Position - p381).Magnitude <= v386 then
                    return true
                end
            end

            return false
        end
        function CheckNotNotifyHazeESP()
            local v388, v389, v390 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))

            while true do
                local v391

                v390, v391 = v388(v389, v390)

                if v390 == nil then
                    break
                end
                if v391:FindFirstChild('HazeESP') then
                    return true
                end
            end

            local v392, v393, v394 = pairs(game.Workspace.Enemies:GetChildren())

            while true do
                local v395

                v394, v395 = v392(v393, v394)

                if v394 == nil then
                    break
                end
                if v395:FindFirstChild('HazeESP') then
                    return true
                end
            end

            local v396, v397, v398 = pairs(game:GetService('ReplicatedStorage'):GetChildren())

            while true do
                local v399

                v398, v399 = v396(v397, v398)

                if v398 == nil then
                    break
                end
                if v399:FindFirstChild('HazeESP') then
                    return true
                end
            end

            return false
        end
        function CheckNotifyComplete()
            local v400, v401, v402 = pairs(game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('Notifications'):GetChildren())

            while true do
                local u403

                v402, u403 = v400(v401, v402)

                if v402 == nil then
                    break
                end
                if u403.Name == 'NotificationTemplate' and string.lower(u403.Text):find(string.lower('!&gt;')) then
                    pcall(function()
                        u403:Destroy()
                    end)

                    return true
                end
            end

            return false
        end
        function CDKCheckAllIn1(p404)
            local v405

            if game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('GoodScroll') then
                v405 = Com('F_', 'CDKQuest', 'Progress', 'Good')
            elseif game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('EvilScroll') then
                v405 = Com('F_', 'CDKQuest', 'Progress', 'Evil')
            else
                v405 = Com('F_', 'CDKQuest', 'Progress')
            end
            if v405.Opened then
                if v405.Good >= 4 then
                    if v405.Evil < 4 then
                        Com('F_', 'CDKQuest', 'StartTrial', 'Evil')
                    end
                else
                    Com('F_', 'CDKQuest', 'StartTrial', 'Good')
                end
                if game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('GoodScroll') then
                    v405 = Com('F_', 'CDKQuest', 'Progress', 'Good')
                elseif game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('EvilScroll') then
                    v405 = Com('F_', 'CDKQuest', 'Progress', 'Evil')
                else
                    v405 = Com('F_', 'CDKQuest', 'Progress')
                end
            end
            if p404 == 'done' then
                return v405.Good == 4 and (v405.Evil == 4 and v405.Finished == true)
            end
            if p404 == 'kill boss' then
                local v406

                if v405.Good ~= 4 or v405.Evil ~= 4 then
                    v406 = false
                else
                    v406 = not v405.Finished
                end

                return v406
            end
            if p404 == 'hell' then
                return v405.Good == -2 and (v405.Finished == false and v405.Evil == -5)
            end
            if p404 == 'Haze' then
                return v405.Good == -2 and (v405.Finished == false and v405.Evil == -4)
            end
            if p404 == 'die' then
                return v405.Good == -2 and (v405.Finished == false and v405.Evil == -3)
            end
            if p404 == 'Heaven' then
                return v405.Good == -5 and (v405.Finished == false and v405.Evil == -2)
            end
            if p404 == 'pirate' then
                return v405.Good == -4 and (v405.Finished == false and v405.Evil == -2)
            end
            if p404 == 'boat' then
                return v405.Good == -3 and (v405.Finished == false and v405.Evil == -2)
            end

            print('BOOm')

            return false
        end

        local u407 = {
            Dai = false,
            Jer = false,
            Faji = false,
        }

        function RaceAllIn1()
            if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Human' and (game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Mink' and game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Fishman') then
                return false
            end

            local _F_5 = Com('F_', 'Wenlocktoad', '1')

            if _F_5 == 0 then
                Com('F_', 'Wenlocktoad', '2')

                _F_5 = Com('F_', 'Wenlocktoad', '1')
            end
            if _F_5 == 2 then
                Com('F_', 'Wenlocktoad', '3')
            elseif _F_5 == 1 then
                if game:GetService('Players').LocalPlayer.Data.Race.Value == 'Mink' then
                    return 'DoMinkRace'
                end
                if game:GetService('Players').LocalPlayer.Data.Race.Value ~= 'Human' then
                    if game:GetService('Players').LocalPlayer.Data.Race.Value == 'Fishman' then
                        return 'DoFishmanRace'
                    end
                else
                    if havemob('Diamond [Lv. 750] [Boss]') and u407.Dai == false then
                        return 'DoDiamond'
                    end
                    if havemob('Jeremy [Lv. 850] [Boss]') and u407.Jer == false then
                        return 'DoJeremy'
                    end
                    if havemob('Fajita [Lv. 925] [Boss]') and u407.Faji == false then
                        return 'DoFajita'
                    end
                end
            end

            return false
        end
        function GetGenshinImg()
            local _Body = u63({
                Url = 'https://danbooru.donmai.us/posts/random.json?tags=genshin_impact%20score:%3E=60%20rating:general',
                Method = 'GET',
            }).Body

            gettableimg = game:GetService('HttpService'):JSONDecode(_Body).file_url

            if gettableimg == nil then
                GetGenshinImg()
            end

            return gettableimg or 'https://cdn.donmai.us/original/e8/6d/e86d7d4b452a470933dd4d709fb8dc1b.jpg'
        end

        local u410 = false

        toTarget = LPH_JIT_MAX(function(...)
            local v411 = {...}
            local v412 = v411[1]
            local u413 = nil

            if type(v412) ~= 'vector' then
                if type(v412) ~= 'userdata' then
                    if type(v412) == 'number' then
                        u413 = CFrame.new(unpack(v411))
                    end
                else
                    u413 = v412
                end
            else
                u413 = CFrame.new(v412)
            end

            DieWait()

            local _Magnitude4 = (u413.Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude
            local v415, v416, v417 = pairs(u79)
            local v418 = false
            local v419 = nil

            while true do
                local v420, v421 = v415(v416, v417)

                if v420 == nil then
                    break
                end

                v417 = v420

                local v422 = v421 + Vector3.new(1, 60, 0)
                local _Magnitude5 = (v422 - u413.Position).Magnitude

                if _Magnitude5 < _Magnitude4 then
                    v419 = v422
                    _Magnitude4 = _Magnitude5
                    v418 = true
                end
            end

            if u410 ~= false then
                local _Magnitude6 = (u413.Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude

                if _Magnitude6 < 300 then
                    Speed = 345
                elseif _Magnitude6 < 500 then
                    Speed = 385
                elseif _Magnitude6 < 1000 then
                    Speed = 355
                elseif _Magnitude6 >= 1000 then
                    Speed = 335
                end

                local _TweenService = game:service('TweenService')
                local u426 = TweenInfo.new((u413.Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude / Speed, Enum.EasingStyle.Linear)
                local _, _ = pcall(function()
                    local v427 = {CFrame = u413}

                    tween = _TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, u426, v427)

                    tween:Play()
                end)

                return {
                    Stop = function(_)
                        return tween:Cancel()
                    end,
                    Wait = function(_)
                        return tween.Completed:Wait()
                    end,
                }
            else
                u410 = true

                local v428, v429, _ = GetIsLandNer(u413)

                if not CheckCanTeleport() or (not v418 or (v419 - u413.Position).Magnitude <= 5000) and (v418 ~= false or (game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position - u413.Position).Magnitude <= 5000) or not v428 then
                    if v418 == true then
                        if tween then
                            tween:Cancel()
                        end

                        task.wait()
                        Com('F_', 'requestEntrance', v419)

                        if tween then
                            tween:Cancel()
                        end

                        task.wait(0.2)
                    end
                end
                if tween then
                    tween:Cancel()
                    task.wait(0.2)
                end

                while true do
                    task.wait()
                    game.Players.LocalPlayer.Character:PivotTo(u413)
                    task.wait(0.01)

                    local _Humanoid = game:GetService('Players').LocalPlayer.Character:FindFirstChild('Humanoid')

                    if _Humanoid then
                        _Humanoid:ChangeState(15)
                    end

                    repeat
                        task.wait(0.1)
                        game.Players.LocalPlayer.Character:PivotTo(u413)
                    until game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid').Health > 0

                    task.wait(0.3)

                    if game:GetService('Players').LocalPlayer.Data:FindFirstChild('LastSpawnPoint').Value == tostring(v429) then
                        task.wait(0.2)

                        u410 = false
                    end
                end
            end
        end)

        local v431 = loadstring(game:HttpGet('https://raw.githubusercontent.com/SixZensED/Scripts/main/Luxury%20V2/Libraryv2.lua'))()

        print('--[[Get UI]]--')
        print('--[[Loaded UI]]--')

        local v432 = v431.create()
        local u433 = '\u{2705}'
        local u434 = '\u{274c}'
        local v435 = v432.tab({
            Logo = tostring('16796144919'),
            Title = 'Main',
            Desc = 'Farm Main Tabs',
        })
        local u436 = v435.page({
            Type = 1,
            Title = 'Status',
        }).Label({
            Title = 'Trash Hub V2',
        })
        local v437 = v435.page({
            Type = 1,
            Title = 'Info',
        })

        v437.Label({
            Title = 'World : ' .. (function()
                if u75 then
                    return 1
                end
                if u76 then
                    return 2
                end
                if u77 then
                    return 3
                end
            end)(),
        })
        v437.Label({
            Title = 'Name : ' .. _LocalPlayer.Name,
        })

        local u438 = v437.Label({
            Title = 'Level : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Level').Value,
        })
        local u439 = v437.Label({
            Title = 'Fragments : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Fragments').Value,
        })
        local u440 = v437.Label({
            Title = 'Race : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Race').Value,
        })
        local u441 = v437.Label({
            Title = 'Evo Race : ' .. (function()
                return inmyself('Awakening') and 4 or (Com('F_', 'Wenlocktoad', '1') ~= -2 and (Com('F_', 'Alchemist', '1') ~= -2 and 1 or 2) or 3)
            end)() .. '/4',
        })
        local u442 = v437.Label({
            Title = 'Devil Fruit : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('DevilFruit').Value,
        })
        local u443 = v437.Label({
            Title = 'Fruit Mastery : ' .. game:GetService('Players').LocalPlayer:WaitForChild('Data').DevilFruit.Value,
        })
        local u444 = v437.Label({
            Title = 'Awaken : ' .. GetAwakened(),
        })
        local v445 = v435.page({
            Type = 1,
            Title = 'Quest Status',
        })
        local u446 = v445.Label({
            Title = 'Saber Quest : ' .. u434,
        })

        v445.Label({
            Title = 'Sea 2 Quest : ' .. (function()
                if Com('F_', 'DressrosaQuestProgress', 'Dressrosa') then
                    if tonumber(Com('F_', 'DressrosaQuestProgress', 'Dressrosa')) ~= 0 then
                        return u434
                    else
                        return u433
                    end
                else
                    return u434
                end
            end)(),
        })

        local u447 = v445.Label({
            Title = 'Bartilo Quest : ' .. (function()
                if Com('F_', 'BartiloQuestProgress', 'Bartilo') then
                    if tonumber(Com('F_', 'BartiloQuestProgress', 'Bartilo')) ~= 3 then
                        return u434
                    else
                        return u433
                    end
                else
                    return u434
                end
            end)(),
        })

        v445.Label({
            Title = 'Sea 3 Quest : ' .. (function()
                if Com('F_', 'ZQuestProgress', 'Check') then
                    if tonumber(Com('F_', 'ZQuestProgress', 'Check')) ~= 1 then
                        return u434
                    else
                        return u433
                    end
                else
                    return u434
                end
            end)(),
        })

        local v448 = v435.page({
            Type = 1,
            Title = 'Accessory Status',
        })
        local u449 = v448.Label({
            Title = 'Dark Coat : ' .. u434,
        })
        local u450 = v448.Label({
            Title = 'Holy Crown : ' .. u434,
        })
        local u451 = v448.Label({
            Title = 'Pale Scarf : ' .. u434,
        })
        local u452 = v448.Label({
            Title = 'Valkyrie Helmet : ' .. u434,
        })
        local v453 = v435.page({
            Type = 2,
            Title = 'Fighting Status',
        })
        local u454 = v453.Label({
            Title = 'Godhuman : ' .. u434,
        })
        local u455 = v453.Label({
            Title = 'Superhuman : ' .. u434,
        })
        local u456 = v453.Label({
            Title = 'SharkmanKarate : ' .. u434,
        })
        local u457 = v453.Label({
            Title = 'DragonTalon : ' .. u434,
        })
        local u458 = v453.Label({
            Title = 'ElectricClaw : ' .. u434,
        })
        local u459 = v453.Label({
            Title = 'DeathStep : ' .. u434,
        })
        local v460 = v435.page({
            Type = 2,
            Title = 'Sword Status',
        })
        local u461 = v460.Label({
            Title = 'Pole V1 : ' .. u434,
        })
        local u462 = v460.Label({
            Title = 'Pole V2 : ' .. u434,
        })
        local u463 = v460.Label({
            Title = 'Rengoku : ' .. u434,
        })
        local u464 = v460.Label({
            Title = 'Shisui : ' .. u434,
        })
        local u465 = v460.Label({
            Title = 'Saddi : ' .. u434,
        })
        local u466 = v460.Label({
            Title = 'Wando : ' .. u434,
        })
        local u467 = v460.Label({
            Title = 'True Triple Katana : ' .. u434,
        })
        local u468 = v460.Label({
            Title = 'Yama : ' .. u434,
        })
        local u469 = v460.Label({
            Title = 'Tushita : ' .. u434,
        })
        local u470 = v460.Label({
            Title = 'Canvander : ' .. u434,
        })
        local u471 = v460.Label({
            Title = 'Spikey Trident : ' .. u434,
        })
        local u472 = v460.Label({
            Title = 'Dark Dagger : ' .. u434,
        })
        local u473 = v460.Label({
            Title = 'Buddy Sword : ' .. u434,
        })
        local u474 = v460.Label({
            Title = 'Hallow Scythe : ' .. u434,
        })
        local u475 = v460.Label({
            Title = 'Cursed Dual Katana : ' .. u434,
        })
        local v476 = v435.page({
            Type = 2,
            Title = 'Gun Status',
        })
        local u477 = v476.Label({
            Title = 'Kabucha : ' .. u434,
        })
        local u478 = v476.Label({
            Title = 'Acidum Rifle : ' .. u434,
        })
        local u479 = v476.Label({
            Title = 'Serpent Bow : ' .. u434,
        })
        local u480 = v476.Label({
            Title = 'Soul Guitar : ' .. u434,
        })

        function RefreshStatus()
            local v481, v482, v483 = pairs(Com('F_', 'getInventory'))

            while true do
                local v484

                v483, v484 = v481(v482, v483)

                if v483 == nil then
                    break
                end
                if type(v484) == 'table' then
                    if v484.Name == 'Saber' then
                        local v485 = u446

                        if string.find(v485:Update().Text, u434) then
                            u446:Update().Text = u446:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Pole (1st Form)' then
                        local v486 = u461

                        if string.find(v486:Update().Text, u434) then
                            u461:Update().Text = u461:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Pole (2nd Form)' then
                        local v487 = u462

                        if string.find(v487:Update().Text, u434) then
                            u462:Update().Text = u462:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Rengoku' then
                        local v488 = u463

                        if string.find(v488:Update().Text, u434) then
                            u463:Update().Text = u463:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Shisui' then
                        local v489 = u464

                        if string.find(v489:Update().Text, u434) then
                            u464:Update().Text = u464:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Saddi' then
                        local v490 = u465

                        if string.find(v490:Update().Text, u434) then
                            u465:Update().Text = u465:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Wando' then
                        local v491 = u466

                        if string.find(v491:Update().Text, u434) then
                            u466:Update().Text = u466:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'True Triple Katana' then
                        local v492 = u467

                        if string.find(v492:Update().Text, u434) then
                            u467:Update().Text = u467:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Yama' then
                        local v493 = u468

                        if string.find(v493:Update().Text, u434) then
                            u468:Update().Text = u468:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Tushita' then
                        local v494 = u469

                        if string.find(v494:Update().Text, u434) then
                            u469:Update().Text = u469:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Canvander' then
                        local v495 = u470

                        if string.find(v495:Update().Text, u434) then
                            u470:Update().Text = u470:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Spikey Trident' then
                        local v496 = u471

                        if string.find(v496:Update().Text, u434) then
                            u471:Update().Text = u471:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Dark Dagger' then
                        local v497 = u472

                        if string.find(v497:Update().Text, u434) then
                            u472:Update().Text = u472:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Hallow Scythe' then
                        local v498 = u474

                        if string.find(v498:Update().Text, u434) then
                            u474:Update().Text = u474:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Buddy Sword' then
                        local v499 = u473

                        if string.find(v499:Update().Text, u434) then
                            u473:Update().Text = u473:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Cursed Dual Katana' then
                        local v500 = u475

                        if string.find(v500:Update().Text, u434) then
                            u475:Update().Text = u475:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Kabucha' then
                        local v501 = u477

                        if string.find(v501:Update().Text, u434) then
                            u477:Update().Text = u477:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Acidum Rifle' then
                        local v502 = u478

                        if string.find(v502:Update().Text, u434) then
                            u478:Update().Text = u478:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Serpent Bow' then
                        local v503 = u479

                        if string.find(v503:Update().Text, u434) then
                            u479:Update().Text = u479:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Soul Guitar' then
                        local v504 = u480

                        if string.find(v504:Update().Text, u434) then
                            u480:Update().Text = u480:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Dark Coat' then
                        local v505 = u449

                        if string.find(v505:Update().Text, u434) then
                            u449:Update().Text = u449:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Holy Crown' then
                        local v506 = u450

                        if string.find(v506:Update().Text, u434) then
                            u450:Update().Text = u450:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Pale Scarf' then
                        local v507 = u451

                        if string.find(v507:Update().Text, u434) then
                            u451:Update().Text = u451:Update().Text:gsub(u434, u433)
                        end
                    end
                    if v484.Name == 'Valkyrie Helm' then
                        local v508 = u452

                        if string.find(v508:Update().Text, u434) then
                            u452:Update().Text = u452:Update().Text:gsub(u434, u433)
                        end
                    end
                end
            end

            if GodhumanDone then
                local v509 = u454

                if string.find(v509:Update().Text, u434) then
                    u454:Update().Text = u454:Update().Text:gsub(u434, u433)
                end
            end
            if u39 then
                local v510 = u455

                if string.find(v510:Update().Text, u434) then
                    u455:Update().Text = u455:Update().Text:gsub(u434, u433)
                end
            end
            if u38 then
                local v511 = u456

                if string.find(v511:Update().Text, u434) then
                    u456:Update().Text = u456:Update().Text:gsub(u434, u433)
                end
            end
            if u41 then
                local v512 = u457

                if string.find(v512:Update().Text, u434) then
                    u457:Update().Text = u457:Update().Text:gsub(u434, u433)
                end
            end
            if u40 then
                local v513 = u458

                if string.find(v513:Update().Text, u434) then
                    u458:Update().Text = u458:Update().Text:gsub(u434, u433)
                end
            end
            if u37 then
                local v514 = u459

                if string.find(v514:Update().Text, u434) then
                    u459:Update().Text = u459:Update().Text:gsub(u434, u433)
                end
            end

            u438:Update().Text = 'Level : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Level').Value
            u439:Update().Text = 'Fragments : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Fragments').Value
            u440:Update().Text = 'Race : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('Race').Value
            u441:Update().Text = 'Evo Race : ' .. (function()
                return Com('F_', 'Wenlocktoad', '1') ~= -2 and (Com('F_', 'Alchemist', '1') ~= -2 and 1 or 2) or 3
            end)() .. '/3'
            u443:Update().Text = 'Fruit Mas : ' .. game:GetService('Players').LocalPlayer:WaitForChild('Data').DevilFruit.Value
            u442:Update().Text = 'Fruit : ' .. game:GetService('Players').LocalPlayer.Data:FindFirstChild('DevilFruit').Value
            u444:Update().Text = 'Awaken : ' .. GetAwakened()
            u447:Update().Text = 'Bartilo Quest : ' .. (function()
                if Com('F_', 'BartiloQuestProgress', 'Bartilo') then
                    if tonumber(Com('F_', 'BartiloQuestProgress', 'Bartilo')) ~= 3 then
                        return u434
                    else
                        return u433
                    end
                else
                    return u434
                end
            end)()
        end
        function ShowDoingStatus(p515)
            task.spawn(function()
                if u23 == false then
                    u23 = true

                    local v516 = u436

                    if not string.find(v516:Update().Text, p515) then
                        local v517 = 'Doing Status : ' .. p515

                        for v518 = 1, #v517 do
                            u436:Update().Text = string.sub(v517, 1, v518)

                            task.wait(0.025)
                        end
                    end

                    u23 = false
                end
            end)
        end

        pcall(RefreshStatus)
        task.spawn(function()
            while task.wait() do
                if game.Players.LocalPlayer:FindFirstChild('Backpack') and game.Players.LocalPlayer.Character then
                    pcall(RefreshStatus)
                    task.wait(math.random(3, 10))
                end
            end
        end)

        function havemob(p519)
            return game.Workspace.Enemies:FindFirstChild(p519) or game.ReplicatedStorage:FindFirstChild(p519)
        end
        function CheckMobRainBowHaki()
            local _F_6 = Com('F_', 'HornedMan')
            local v521 = not (tostring(_F_6):find('Stone') and havemob('Stone [Lv. 1550] [Boss]')) and (not (tostring(_F_6):find('Island Empress') and havemob('Island Empress [Lv. 1675] [Boss]') or tostring(_F_6):find('Kilo Admiral') and havemob('Kilo Admiral [Lv. 1750] [Boss]]')) and (not (tostring(_F_6):find('Captain Elephant') and havemob('Captain Elephant [Lv. 1875] [Boss]')) and tostring(_F_6):find('Beautiful Pirate')))

            if v521 then
                v521 = havemob('Beautiful Pirate [Lv. 1950] [Boss]')
            end

            return v521
        end

        pcall(function()
            local v522, v523, v524 = pairs(game.Workspace:GetDescendants())

            while true do
                local v525

                v524, v525 = v522(v523, v524)

                if v524 == nil then
                    break
                end
                if v525.Name == 'Lava' then
                    v525:Destroy()
                end
            end
        end)
        spawn(function()
            while task.wait() do
                TeleportType = math.random(1, 5)

                task.wait(0.3)
            end
        end)
        spawn(function()
            while task.wait() do
                TypeSeabeast = 0

                task.wait(1)

                TypeSeabeast = 1

                task.wait(1)
            end
        end)
        LPH_NO_VIRTUALIZE(function()
            local v526 = getrawmetatable(game)
            local ___index = v526.__index

            setreadonly(v526, false)

            v526.__index = newcclosure(function(...)
                local v528 = {...}

                if StartKaiTun then
                    if SpamSkillSea then
                        if v528[1] == u64 and (v528[2] == 'Hit' and not checkcaller()) then
                            return CFrame.new(PosKillSea)
                        end
                    elseif UseSkillMasteryDevilFruit then
                        if v528[1] == u64 and (v528[2] == 'Hit' and not checkcaller()) then
                            return CFrame.new(PositionSkillMasteryDevilFruit)
                        end
                    elseif u75 and (v528[1] == u64 and (v528[2] == 'Hit' and (not checkcaller() and (inmyself('Slingshot') and UsefastattackPlayers == false)))) and u436:Update().Text == 'Doing Status : Skip Farm Level' then
                        return CFrame.new(PositionSling)
                    end
                end

                return ___index(unpack(v528))
            end)
        end)()

        local _F_7 = Com('F_', 'GetFruits')

        Table_DevilFruitSniper = {}

        local v530, v531, v532 = pairs(_F_7)
        local u533 = u475
        local u534 = u466
        local u535 = u464
        local u536 = u465
        local u537 = u473
        local u538 = u463
        local u539 = u436
        local u540 = u407
        local u541 = u446
        local u542 = u461
        local u543 = u469
        local u544 = u480
        local u545 = u470
        local u546 = u468
        local u547 = u433
        local u548 = u434
        local u549 = u471
        local u550 = u8
        local u567 = {
            WebHookSend = function(_, p551)
                local v565 = {
                    {
                        title = ':sushi: **Saturn Webhooks Status**',
                        color = tonumber(16777215),
                        fields = {
                            {
                                name = 'User Info',
                                value = string.format('Name: %s\nBeli: %s\nFragments: %s\nWorld: %s\nRace: %s\nBounty/Honor: %s', tostring(game.Players.LocalPlayer.Name), Abbreviate(game:GetService('Players').LocalPlayer.Data:FindFirstChild('Beli').Value), Abbreviate(game:GetService('Players').LocalPlayer.Data:FindFirstChild('Fragments').Value), (function()
                                    if u75 then
                                        return 1
                                    end
                                    if u76 then
                                        return 2
                                    end
                                    if u77 then
                                        return 3
                                    end
                                end)(), game:GetService('Players').LocalPlayer.Data:FindFirstChild('Race').Value, Abbreviate(game:GetService('Players').LocalPlayer.leaderstats['Bounty/Honor'].Value)),
                                inline = true,
                            },
                            {
                                name = '\u{3164}',
                                value = tostring('\u{3164}'),
                                inline = true,
                            },
                            {
                                name = 'Fruit Info',
                                value = string.format('Fruit: %s\nFruit Mastery: %s\nFruit Awake: %s', game:GetService('Players').LocalPlayer.Data:FindFirstChild('DevilFruit').Value, (function()
                                    local v552 = inmyself(tostring(game:GetService('Players').LocalPlayer:WaitForChild('Data').DevilFruit.Value))

                                    if v552 then
                                        return v552:WaitForChild('Level').Value
                                    end
                                end)(), GetAwakened()),
                                inline = true,
                            },
                            {
                                name = 'Melee',
                                value = '```yml\n' .. GetMeleeText(true, '\n') .. '```',
                                inline = true,
                            },
                            {
                                name = 'Fruit Inventory',
                                value = '```diff\n' .. table.concat((function()
                                    local v553, v554, v555 = pairs(Com('F_', 'getInventory'))
                                    local v556 = {}

                                    while true do
                                        local v557

                                        v555, v557 = v553(v554, v555)

                                        if v555 == nil then
                                            break
                                        end
                                        if v557.Type == 'Blox Fruit' then
                                            table.insert(v556, (function(p558)
                                                return p558.Rarity < 4 and (p558.Rarity < 3 and '* ' or '+ ') or '- '
                                            end)(v557) .. v557.Name)
                                        end
                                    end

                                    return v556
                                end)(), '\n') .. '```',
                                inline = true,
                            },
                            {
                                name = 'Item',
                                value = '```diff\n' .. table.concat((function()
                                    local v559, v560, v561 = pairs(Com('F_', 'getInventory'))
                                    local v562 = {}

                                    while true do
                                        local v563

                                        v561, v563 = v559(v560, v561)

                                        if v561 == nil then
                                            break
                                        end
                                        if v563.Type ~= 'Blox Fruit' and v563.Type ~= 'Material' then
                                            table.insert(v562, (function(p564)
                                                return p564.Rarity < 4 and (p564.Rarity < 3 and '* ' or '+ ') or '- '
                                            end)(v563) .. v563.Name)
                                        end
                                    end

                                    return v562
                                end)(), '\n') .. '```',
                                inline = true,
                            },
                            {
                                name = '\u{3164}',
                                value = tostring('\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}\u{3164}'),
                                inline = false,
                            },
                        },
                    },
                }
                local v566 = TagUser and _G.DiscordId and {
                    username = 'Saturn Hub Log',
                    avatar_url = 'https://cdn.discordapp.com/attachments/1512996812196417593/1517742853470552084/8911f0a5a9f8f58a597dfbc0e0831107.png?ex=6a3763ae&is=6a36122e&hm=6b37c2a05817d55811ae5c58cafb9c6ea0e211b42419afba039978afb7ad0562&',
                    content = ('<@!%s>'):format(_G.DiscordId),
                    embeds = v565,
                } or {
                    username = 'Saturn Hub Log',
                    avatar_url = 'https://cdn.discordapp.com/attachments/1512996812196417593/1517742853470552084/8911f0a5a9f8f58a597dfbc0e0831107.png?ex=6a3763ae&is=6a36122e&hm=6b37c2a05817d55811ae5c58cafb9c6ea0e211b42419afba039978afb7ad0562&',
                    embeds = v565,
                }

                return u63({
                    Url = p551,
                    Method = 'POST',
                    Headers = {
                        ['Content-Type'] = 'application/json',
                    },
                    Body = game:GetService('HttpService'):JSONEncode(v566),
                })
            end,
        }

        while true do
            local v568

            v532, v568 = v530(v531, v532)

            if v532 == nil then
                break
            end

            table.insert(Table_DevilFruitSniper, v568.Name)
        end

        game:GetService('Players').LocalPlayer.Idled:connect(function()
            game:GetService('VirtualUser'):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService('VirtualUser'):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)

        local u569 = tostring(math.random(10000000, 99999999))
        local v570 = getfenv()
        local u571 = v570.sethiddenproperty or v570.set_hidden_property or (v570.set_hidden_prop or v570.sethiddenprop)

        spawn(LPH_NO_VIRTUALIZE(function()
            game:GetService('RunService').Stepped:Connect(function()
                local _Humanoid2 = game.Players.LocalPlayer.Character:WaitForChild('Humanoid')
                local _HumanoidRootPart2 = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')

                if setscriptable then
                    setscriptable(game.Players.LocalPlayer, 'SimulationRadius', true)
                end
                if u571 then
                    u571(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                end
                if StartKaiTun and not AntiSit then
                    local v574, v575, v576 = pairs(game:GetService('ReplicatedStorage'):GetChildren())

                    while true do
                        local v577

                        v576, v577 = v574(v575, v576)

                        if v576 == nil then
                            break
                        end
                        if v577:IsA('Model') and (v577:GetModelCFrame().Position - _HumanoidRootPart2.Position).Magnitude <= 500 then
                            v577.Parent = game:GetService('Workspace').Enemies
                        end
                    end

                    if _Humanoid2:GetState() == Enum.HumanoidStateType.Seated or _Humanoid2.Health <= 0 then
                        _Humanoid2.Jump = true
                        _Humanoid2.Sit = false

                        if _HumanoidRootPart2:FindFirstChild('NoClip' .. u569) then
                            _HumanoidRootPart2:FindFirstChild('NoClip' .. u569):Destroy()
                        end
                    end
                    if _Humanoid2.Sit ~= false or _Humanoid2.Health <= 0 then
                        _Humanoid2.Sit = false
                    else
                        local v578, v579, v580 = pairs(game.Players.LocalPlayer.Character:GetDescendants())

                        while true do
                            local v581

                            v580, v581 = v578(v579, v580)

                            if v580 == nil then
                                break
                            end
                            if v581:IsA('BasePart') then
                                v581.CanCollide = false
                            end
                        end
                    end
                    if not _HumanoidRootPart2:FindFirstChild('NoClip' .. u569) and _Humanoid2.Sit == false then
                        local _BodyVelocity = Instance.new('BodyVelocity')

                        _BodyVelocity.Parent = _HumanoidRootPart2
                        _BodyVelocity.Name = 'NoClip' .. u569
                        _BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        _BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                elseif _HumanoidRootPart2:FindFirstChild('NoClip' .. u569) then
                    _HumanoidRootPart2:FindFirstChild('NoClip' .. u569):Destroy()
                end
            end)
        end))

        local _Players = game:GetService('Players')
        local _Workspace = game:GetService('Workspace')
        local _ReplicatedStorage = game:GetService('ReplicatedStorage')

        game:GetService('RunService')

        local _LocalPlayer3 = _Players.LocalPlayer
        local v587 = require(_LocalPlayer3.PlayerScripts:WaitForChild('CombatFramework'))
        local v588 = require(_ReplicatedStorage.Util.CameraShaker)
        local u589 = getupvalues(v587)[2]
        local v590 = require(_Players.LocalPlayer.PlayerScripts.CombatFramework.RigController)
        local _ = getupvalues(v590)[2]

        require(_ReplicatedStorage.CombatFramework.RigLib)
        v588:Stop()

        getAllBladeHits = LPH_NO_VIRTUALIZE(function(p591)
            local v592 = _LocalPlayer3
            local v593 = game:GetService('Workspace').Enemies:GetChildren()
            local v594, v595, v596 = pairs(v593)
            local v597 = {}

            while true do
                local v598

                v596, v598 = v594(v595, v596)

                if v596 == nil then
                    break
                end

                local _Humanoid3 = v598:FindFirstChildOfClass('Humanoid')

                if _Humanoid3 and (_Humanoid3.RootPart and (_Humanoid3.Health > 0 and v592:DistanceFromCharacter(_Humanoid3.RootPart.Position) < p591 + 5)) then
                    table.insert(v597, _Humanoid3.RootPart)
                end
            end

            return v597
        end)
        getAllBladeHitsPlayers = LPH_NO_VIRTUALIZE(function(p600)
            local v601 = _LocalPlayer3
            local v602 = game:GetService('Workspace').Characters:GetChildren()
            local v603, v604, v605 = pairs(v602)
            local v606 = {}

            while true do
                local v607

                v605, v607 = v603(v604, v605)

                if v605 == nil then
                    break
                end

                local _Humanoid4 = v607:FindFirstChildOfClass('Humanoid')

                if v607.Name ~= _LocalPlayer3.Name and (_Humanoid4 and (_Humanoid4.RootPart and (_Humanoid4.Health > 0 and v601:DistanceFromCharacter(_Humanoid4.RootPart.Position) < p600 + 5))) then
                    table.insert(v606, _Humanoid4.RootPart)
                end
            end

            return v606
        end)
        game:GetService('ReplicatedStorage').Assets.GUI:WaitForChild('DamageCounter').Enabled = false

        local _RigControllerEvent = _ReplicatedStorage.RigControllerEvent
        local _Animation = Instance.new('Animation')
        local u611 = 0
        local u612 = 0
        local u613 = 1000
        local u614 = 0.0325678
        local u615 = 0

        CancelCoolDown = LPH_NO_VIRTUALIZE(function()
            local _activeController = u589.activeController

            if _activeController and _activeController.equipped then
                u611 = tick() + (u614 or 0.288) + u615 / u613 * 0.3

                _RigControllerEvent:FireServer('weaponChange', _activeController.currentWeaponModel.Name)

                u615 = u615 + 1

                task.delay((u614 or 0.288) + (u615 + 0.4 / u613) * 0.3, function()
                    u615 = u615 - 1
                end)
            end
        end)
        AttackFunction = LPH_NO_VIRTUALIZE(function(p617)
            local _activeController2 = u589.activeController

            if _activeController2 and _activeController2.equipped then
                local v619 = {}

                if p617 == 1 then
                    v619 = getAllBladeHits(60)
                elseif p617 == 2 then
                    v619 = getAllBladeHitsPlayers(65)
                else
                    local v620, v621, v622 = pairs(getAllBladeHits(55))

                    while true do
                        local v623

                        v622, v623 = v620(v621, v622)

                        if v622 == nil then
                            break
                        end

                        table.insert(v619, v623)
                    end

                    local v624, v625, v626 = pairs(getAllBladeHitsPlayers(55))

                    while true do
                        local v627

                        v626, v627 = v624(v625, v626)

                        if v626 == nil then
                            break
                        end

                        table.insert(v619, v627)
                    end
                end
                if #v619 > 0 then
                    pcall(task.spawn, _activeController2.attack, _activeController2)

                    if u611 < tick() then
                        CancelCoolDown()
                    end
                    if tick() - u612 > 0.5 then
                        _activeController2.timeToNextAttack = 0
                        _activeController2.hitboxMagnitude = 60

                        pcall(task.spawn, _activeController2.attack, _activeController2)

                        u612 = tick()
                    end

                    local v628 = _activeController2.anims.basic[3]

                    _Animation.AnimationId = v628 or _activeController2.anims.basic[2]

                    local u629 = _activeController2.humanoid:LoadAnimation(_Animation)

                    u629:Play(0.01, 0.01, 0.01)
                    _RigControllerEvent:FireServer('hit', v619, v628 and 3 or 2, '')
                    task.delay(0.01, function()
                        u629:Stop()
                    end)
                end
            end
        end)

        LPH_NO_VIRTUALIZE(function()
            task.spawn(function()
                while game:GetService('RunService').Stepped:Wait() do
                    local _activeController3 = u589.activeController

                    if _activeController3 and (_activeController3.equipped and not CheckStun()) then
                        if Usefastattack and getgenv().Configs.Main.FastAttack then
                            task.spawn(function()
                                pcall(task.spawn, AttackFunction, 1)
                            end)
                        elseif UsefastattackPlayers and getgenv().Configs.Main.FastAttack then
                            task.spawn(function()
                                pcall(task.spawn, AttackFunction, 2)
                            end)
                        elseif (Usefastattack or UsefastattackPlayers) and getgenv().Configs.Main.FastAttack == false then
                            if _activeController3.hitboxMagnitude ~= 55 then
                                _activeController3.hitboxMagnitude = 55
                            end

                            pcall(task.spawn, _activeController3.attack, _activeController3)
                        end
                    end
                end
            end)
        end)()

        function toAroundTarget(p631)
            if TeleportType ~= 1 then
                if TeleportType ~= 2 then
                    if TeleportType ~= 3 then
                        if TeleportType ~= 4 then
                            if TeleportType ~= 5 then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(0, 30, 1)
                            else
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(-30, 1, 0)
                            end
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(30, 1, 0)
                        end
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(1, 1, -30)
                    end
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(0, 1, 30)
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p631 * CFrame.new(0, 30, 1)
            end
        end
        function CheckNight()
            return tonumber(game:GetService('Lighting').ClockTime) >= 18 and tonumber(game:GetService('Lighting').ClockTime) <= 23.999999999 or tonumber(game:GetService('Lighting').ClockTime) >= 0 and tonumber(game:GetService('Lighting').ClockTime) < 5
        end

        local function u636()
            local v632, v633, v634 = pairs(game:GetService('Workspace').Boats:GetChildren())

            while true do
                local v635

                v634, v635 = v632(v633, v634)

                if v634 == nil then
                    break
                end
                if v635:FindFirstChild('Owner') and tostring(v635.Owner.Value) == game.Players.LocalPlayer.Name then
                    return v635:FindFirstChildOfClass('VehicleSeat')
                end
            end

            return false
        end
        local function u641()
            local v637, v638, v639 = pairs(game.Workspace.SeaBeasts:GetChildren())

            while true do
                local v640

                v639, v640 = v637(v638, v639)

                if v639 == nil then
                    break
                end
                if v640:FindFirstChild('HumanoidRootPart') then
                    return v640
                end
            end

            return false
        end

        function CheckPirateBoat()
            local v642, v643, v644 = pairs(game.Workspace.Enemies:GetChildren())

            while true do
                local v645

                v644, v645 = v642(v643, v644)

                if v644 == nil then
                    break
                end
                if v645.Name == 'PirateBasic' or v645.Name == 'PirateBrigade' then
                    return true
                end
            end

            return false
        end
        function CheckMaterial(p646)
            if u75 then
                if p646 == 'Magma Ore' then
                    MaterialMob = {
                        'Military Soldier [Lv. 300]',
                        'Military Spy [Lv. 325]',
                    }
                    CFrameMonM = {
                        CFrame.new(-5455.29296875, 41.13956069946289, 8464.63671875),
                        CFrame.new(-5783.017578125, 119.99700927734375, 8776.46484375),
                    }
                elseif p646 == 'Leather' or p646 == 'Scrap Metal' then
                    MaterialMob = {
                        'Brute [Lv. 45]',
                        'Pirate [Lv. 35]',
                    }
                    CFrameMonM = {
                        Frame.new(-1145, 15, 4350),
                    }
                elseif p646 == 'Angel Wings' then
                    MaterialMob = {
                        "God's Guard [Lv. 450]",
                    }
                    CFrameMonM = {
                        CFrame.new(-4698, 845, -1912),
                    }
                elseif p646 == 'Fish Tail' then
                    MaterialMob = {
                        'Fishman Warrior [Lv. 375]',
                        'Fishman Commando [Lv. 400]',
                    }
                    CFrameMonM = {
                        CFrame.new(61891.4609375, 18.508621215820313, 1489.7476806640625),
                        CFrame.new(61891.4609375, 18.508621215820313, 1489.7476806640625),
                        CFrame.new(60927.4765625, 18.508621215820313, 1558.352294921875),
                        CFrame.new(60927.4765625, 18.508621215820313, 1558.352294921875),
                    }
                end
            end
            if u76 then
                if p646 == 'Magma Ore' then
                    MaterialMob = {
                        'Magma Ninja [Lv. 1175]',
                    }
                    CFrameMonM = {
                        CFrame.new(-5428, 78, -5959),
                    }
                elseif p646 == 'Scrap Metal' then
                    MaterialMob = {
                        'Swan Pirate [Lv. 775]',
                    }
                    CFrameMonM = {
                        CFrame.new(878, 122, 1235),
                    }
                elseif p646 == 'Radioactive Material' then
                    MaterialMob = {
                        'Factory Staff [Lv. 800]',
                    }
                    CFrameMonM = {
                        CFrame.new(644.6807250976563, 72.98555755615234, 99.28926849365234),
                        CFrame.new(-112.70913696289063, 149.4581756591797, -265.8367614746094),
                    }
                elseif p646 == 'Vampire Fang' then
                    MaterialMob = {
                        'Vampire [Lv. 975]',
                    }
                    CFrameMonM = {
                        CFrame.new(-6033, 7, -1317),
                    }
                elseif p646 == 'Mystic Droplet' then
                    MaterialMob = {
                        'Water Fighter [Lv. 1450]',
                        'Sea Soldier [Lv. 1425]',
                    }
                    CFrameMonM = {
                        CFrame.new(-3360.7841796875, 283.960205078125, -10533.2021484375),
                        CFrame.new(-3541.21044921875, 291.1770935058594, -10315.7109375),
                        CFrame.new(-3380.38232421875, 26.98096466064453, -9802.15625),
                        CFrame.new(-2743.450439453125, 82.7505874633789, -9815.638671875),
                    }
                end
            end
            if u77 then
                if p646 == 'Mini Tusk' then
                    MaterialMob = {
                        'Mythological Pirate [Lv. 1850]',
                    }
                    CFrameMonM = {
                        CFrame.new(-13545, 470, -6917),
                    }
                elseif p646 == 'Scrap Metal' then
                    MaterialMob = {
                        'Jungle Pirate [Lv. 1900]',
                    }
                    CFrameMonM = {
                        CFrame.new(-12290.34375, 331.7640686035156, -10476.703125),
                        CFrame.new(-11836.0517578125, 331.7640686035156, -10582.94140625),
                    }
                elseif p646 == 'Dragon Scale' then
                    MaterialMob = {
                        'Dragon Crew Archer [Lv. 1600]',
                        'Dragon Crew Warrior [Lv. 1575]',
                    }
                    CFrameMonM = {
                        CFrame.new(6583.35595703125, 378.4302978515625, 59.373531341552734),
                        CFrame.new(6452.26953125, 51.5220832824707, -1016.1766967773438),
                        CFrame.new(6210.6875, 51.54628372192383, -1472.1185302734375),
                    }
                elseif p646 == 'Conjured Cocoa' then
                    MaterialMob = {
                        'Cocoa Warrior [Lv. 2300]',
                        'Chocolate Bar Battler [Lv. 2325]',
                        'Sweet Thief [Lv. 2350]',
                        'Candy Rebel [Lv. 2375]',
                    }
                    CFrameMonM = {
                        CFrame.new(51.04587173461914, 55.005882263183594, -12310.1484375),
                        CFrame.new(588.1917724609375, 77.18791198730469, -12463.6884765625),
                        CFrame.new(128.77529907226563, 77.24769592285156, -12878.697265625),
                    }
                elseif p646 == 'Demonic Wisp' then
                    MaterialMob = {
                        'Demonic Soul [Lv. 2025]',
                    }
                    CFrameMonM = {
                        CFrame.new(-9507, 172, 6158),
                    }
                elseif p646 == 'Fish Tail' then
                    MaterialMob = {
                        'Fishman Raider [Lv. 1775]',
                        'Fishman Captain [Lv. 1800]',
                    }
                    CFrameMonM = {
                        CFrame.new(-10993, 332, -8940),
                    }
                elseif p646 == 'Gunpowder' then
                    MaterialMob = {
                        'Pistol Billionaire [Lv. 1525]',
                    }
                    CFrameMonM = {
                        CFrame.new(-469, 74, 5904),
                    }
                end
            end
        end

        CheckQuest = LPH_JIT_MAX(function()
            local _Value = game.Players.LocalPlayer.Data.Level.Value

            if u75 then
                if _Value == 1 or _Value <= 9 then
                    LevelFarm = 1
                    Monster = 'Bandit [Lv. 5]'
                    NameQuest = 'BanditQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Bandit'
                    CFrameMyMon = CFrame.new(1145, 17, 1634)
                    CFrameQuest = CFrame.new(1060, 17, 1547)
                    VectorQuest = Vector3.new(1060, 17, 1547)
                elseif _Value == 10 or _Value <= 14 then
                    LevelFarm = 2
                    Monster = 'Monkey [Lv. 14]'
                    NameQuest = 'JungleQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Monkey'
                    CFrameMyMon = CFrame.new(-1496, 39, 35)
                    CFrameQuest = CFrame.new(-1602, 37, 152)
                    VectorQuest = Vector3.new(-1602, 37, 152)
                elseif _Value == 15 or _Value <= 29 then
                    LevelFarm = 3
                    Monster = 'Gorilla [Lv. 20]'
                    NameQuest = 'JungleQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Gorilla'
                    CFrameMyMon = CFrame.new(-1237, 6, -486)
                    CFrameQuest = CFrame.new(-1602, 37, 152)
                    VectorQuest = Vector3.new(-1602, 37, 152)
                elseif _Value == 30 or _Value <= 39 then
                    LevelFarm = 4
                    Monster = 'Pirate [Lv. 35]'
                    NameQuest = 'BuggyQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Pirate'
                    CFrameMyMon = CFrame.new(-1115, 14, 3938)
                    CFrameQuest = CFrame.new(-1140, 5, 3828)
                    VectorQuest = Vector3.new(-1140, 5, 3828)
                elseif _Value == 40 or _Value <= 59 then
                    LevelFarm = 5
                    Monster = 'Brute [Lv. 45]'
                    NameQuest = 'BuggyQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Brute'
                    CFrameMyMon = CFrame.new(-1145, 15, 4350)
                    VectorMon = Vector3.new(-1146, 15, 4350)
                    CFrameQuest = CFrame.new(-1140, 5, 3828)
                    VectorQuest = Vector3.new(-1140, 5, 3828)
                elseif _Value == 60 or _Value <= 74 then
                    LevelFarm = 6
                    Monster = 'Desert Bandit [Lv. 60]'
                    NameQuest = 'DesertQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Desert Bandit'
                    CFrameMyMon = CFrame.new(932, 7, 4484)
                    CFrameQuest = CFrame.new(897, 7, 4388)
                    VectorQuest = Vector3.new(897, 7, 4388)
                elseif _Value == 75 or _Value <= 89 then
                    LevelFarm = 7
                    Monster = 'Desert Officer [Lv. 70]'
                    NameQuest = 'DesertQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Desert Officer'
                    CFrameMyMon = CFrame.new(1572, 10, 4373)
                    VectorMon = Vector3.new(1572, 10, 4373)
                    CFrameQuest = CFrame.new(897, 7, 4388)
                    VectorQuest = Vector3.new(897, 7, 4388)
                elseif _Value == 90 or _Value <= 99 then
                    LevelFarm = 8
                    Monster = 'Snow Bandit [Lv. 90]'
                    NameQuest = 'SnowQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Snow Bandits'
                    CFrameMyMon = CFrame.new(1289, 150, -1442)
                    VectorMon = Vector3.new(1289, 106, -1442)
                    CFrameQuest = CFrame.new(1386, 87, -1297)
                    VectorQuest = Vector3.new(1386, 87, -1297)
                elseif _Value == 100 or _Value <= 119 then
                    LevelFarm = 9
                    Monster = 'Snowman [Lv. 100]'
                    NameQuest = 'SnowQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Snowman'
                    CFrameMyMon = CFrame.new(1289, 150, -1442)
                    VectorMon = Vector3.new(1289, 106, -1442)
                    CFrameQuest = CFrame.new(1386, 87, -1297)
                    VectorQuest = Vector3.new(1386, 87, -1297)
                elseif _Value == 120 or _Value <= 149 then
                    LevelFarm = 10
                    Monster = 'Chief Petty Officer [Lv. 120]'
                    NameQuest = 'MarineQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Chief Petty Officer'
                    CFrameMyMon = CFrame.new(-4855, 23, 4308)
                    VectorMon = Vector3.new(-4855, 23, 4308)
                    CFrameQuest = CFrame.new(-5036, 29, 4325)
                    VectorQuest = Vector3.new(-5036, 29, 4325)
                elseif _Value == 150 or _Value <= 174 then
                    LevelFarm = 11
                    Monster = 'Sky Bandit [Lv. 150]'
                    NameQuest = 'SkyQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Sky Bandit'
                    CFrameMyMon = CFrame.new(-4981, 278, -2830)
                    VectorMon = Vector3.new(-4981, 278, -2830)
                    CFrameQuest = CFrame.new(-4842, 718, -2623)
                    VectorQuest = Vector3.new(-4842, 718, -2623)
                elseif _Value == 175 or _Value <= 189 then
                    LevelFarm = 12
                    Monster = 'Dark Master [Lv. 175]'
                    NameQuest = 'SkyQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Dark Master'
                    CFrameMyMon = CFrame.new(-5250, 389, -2272)
                    VectorMon = Vector3.new(-5250, 389, -2272)
                    CFrameQuest = CFrame.new(-4842, 718, -2623)
                    VectorQuest = Vector3.new(-4842, 718, -2623)
                elseif _Value == 190 or _Value <= 209 then
                    LevelFarm = 13
                    Monster = 'Prisoner [Lv. 190]'
                    NameQuest = 'PrisonerQuest'
                    LevelQuest = 1
                    NameCheckQuest = '8 Prisoners'
                    CFrameMyMon = CFrame.new(5411, 96, 690)
                    VectorMon = Vector3.new(5411, 96, 690)
                    CFrameQuest = CFrame.new(5308, 2, 474)
                    VectorQuest = Vector3.new(5308, 2, 474)
                elseif _Value == 210 or _Value <= 249 then
                    LevelFarm = 14
                    Monster = 'Dangerous Prisoner [Lv. 210]'
                    NameQuest = 'PrisonerQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Dangerous Prisoner'
                    CFrameMyMon = CFrame.new(5411, 96, 690)
                    VectorMon = Vector3.new(5411, 96, 690)
                    CFrameQuest = CFrame.new(5308, 2, 474)
                    VectorQuest = Vector3.new(5308, 2, 474)
                elseif _Value == 250 or _Value <= 274 then
                    LevelFarm = 15
                    Monster = 'Toga Warrior [Lv. 250]'
                    NameQuest = 'ColosseumQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Toga Warrior'
                    CFrameMyMon = CFrame.new(-1641.4344482421875, 7.415142059326172, -2864.462646484375)
                    CFrameQuest = CFrame.new(-1576, 8, -2985)
                    VectorQuest = Vector3.new(-1576, 8, -2985)
                elseif _Value == 275 or _Value <= 299 then
                    LevelFarm = 16
                    Monster = 'Gladiator [Lv. 275]'
                    NameQuest = 'ColosseumQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Gladiato'
                    CFrameMyMon = CFrame.new(-1385.5233154296875, 7.468349456787109, -3163.066650390625)
                    VectorMon = Vector3.new(-1278, 8, -3240)
                    CFrameQuest = CFrame.new(-1576, 8, -2985)
                    VectorQuest = Vector3.new(-1576, 8, -2985)
                elseif _Value == 300 or _Value <= 329 then
                    LevelFarm = 17
                    Monster = 'Military Soldier [Lv. 300]'
                    NameQuest = 'MagmaQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Military Soldier'
                    CFrameMyMon = CFrame.new(-5408, 11, 8447)
                    VectorMon = Vector3.new(-5408, 11, 8447)
                    CFrameQuest = CFrame.new(-5316, 12, 8517)
                    VectorQuest = Vector3.new(-5316, 12, 8517)
                elseif _Value == 330 or _Value <= 374 then
                    LevelFarm = 18
                    Monster = 'Military Spy [Lv. 325]'
                    NameQuest = 'MagmaQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Military Spy'
                    CFrameMyMon = CFrame.new(-5815, 84, 8820)
                    VectorMon = Vector3.new(-5815, 84, 8820)
                    CFrameQuest = CFrame.new(-5316, 12, 8517)
                    VectorQuest = Vector3.new(-5316, 12, 8517)
                elseif _Value == 375 or _Value <= 399 then
                    LevelFarm = 19
                    Monster = 'Fishman Warrior [Lv. 375]'
                    NameQuest = 'FishmanQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Fishman Warrior'
                    CFrameMyMon = CFrame.new(60859, 19, 1501)
                    VectorMon = Vector3.new(60859, 19, 1501)
                    CFrameQuest = CFrame.new(61123, 19, 1569)
                    VectorQuest = Vector3.new(61123, 19, 1569)
                elseif _Value == 400 or _Value <= 449 then
                    LevelFarm = 20
                    Monster = 'Fishman Commando [Lv. 400]'
                    NameQuest = 'FishmanQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Fishman Commando'
                    CFrameMyMon = CFrame.new(61891, 19, 1470)
                    VectorMon = Vector3.new(61891, 19, 1470)
                    CFrameQuest = CFrame.new(61123, 19, 1569)
                    VectorQuest = Vector3.new(61123, 19, 1569)
                elseif _Value == 450 or _Value <= 474 then
                    LevelFarm = 21
                    Monster = "God's Guard [Lv. 450]"
                    NameQuest = 'SkyExp1Quest'
                    LevelQuest = 1
                    NameCheckQuest = "God's Guards"
                    CFrameMyMon = CFrame.new(-4698, 845, -1912)
                    VectorMon = Vector3.new(-4698, 845, -1912)
                    CFrameQuest = CFrame.new(-4722, 845, -1954)
                    VectorQuest = Vector3.new(-4722, 846, -1954)
                elseif _Value == 475 or _Value <= 524 then
                    LevelFarm = 22
                    Monster = 'Shanda [Lv. 475]'
                    NameQuest = 'SkyExp1Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Shandas'
                    CFrameMyMon = CFrame.new(-7685, 5567, -502)
                    VectorMon = Vector3.new(-7685, 5567, -502)
                    CFrameQuest = CFrame.new(-7862, 5546, -380)
                    VectorQuest = Vector3.new(-7862, 5546, -380)
                elseif _Value == 525 or _Value <= 549 then
                    LevelFarm = 23
                    Monster = 'Royal Squad [Lv. 525]'
                    NameQuest = 'SkyExp2Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Royal Squad'
                    CFrameMyMon = CFrame.new(-7670, 5607, -1460)
                    VectorMon = Vector3.new(-7670, 5607, -1460)
                    CFrameQuest = CFrame.new(-7904, 5636, -1412)
                    VectorQuest = Vector3.new(-7904, 5636, -1412)
                elseif _Value == 550 or _Value <= 624 then
                    LevelFarm = 24
                    Monster = 'Royal Soldier [Lv. 550]'
                    NameQuest = 'SkyExp2Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Royal Soldier'
                    CFrameMyMon = CFrame.new(-7828, 5607, -1744)
                    VectorMon = Vector3.new(-7828, 5607, -1744)
                    CFrameQuest = CFrame.new(-7904, 5636, -1412)
                    VectorQuest = Vector3.new(-7904, 5636, -1412)
                elseif _Value == 625 or _Value <= 649 then
                    LevelFarm = 25
                    Monster = 'Galley Pirate [Lv. 625]'
                    NameQuest = 'FountainQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Galley Pirate'
                    CFrameMyMon = CFrame.new(5589, 45, 3996)
                    VectorMon = Vector3.new(5589, 45, 3996)
                    CFrameQuest = CFrame.new(5256, 39, 4050)
                    VectorQuest = Vector3.new(5256, 39, 4050)
                elseif _Value >= 650 then
                    LevelFarm = 26
                    Monster = 'Galley Captain [Lv. 650]'
                    NameQuest = 'FountainQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Galley Captain'
                    CFrameMyMon = CFrame.new(5649, 39, 4936)
                    VectorMon = Vector3.new(5649, 39, 4936)
                    CFrameQuest = CFrame.new(5256, 39, 4050)
                    VectorQuest = Vector3.new(5256, 39, 4050)
                end
            end
            if u76 then
                if _Value == 700 or _Value <= 724 then
                    LevelFarm = 1
                    Monster = 'Raider [Lv. 700]'
                    NameQuest = 'Area1Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Raider'
                    CFrameQuest = CFrame.new(-425, 73, 1837)
                    VectorQuest = Vector3.new(-425, 73, 1837)
                    CFrameMyMon = CFrame.new(-746, 39, 2390)
                    VectorMon = Vector3.new(-746, 39, 2389)
                elseif _Value == 725 or _Value <= 774 then
                    LevelFarm = 2
                    Monster = 'Mercenary [Lv. 725]'
                    NameQuest = 'Area1Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Mercenary'
                    CFrameQuest = CFrame.new(-425, 73, 1837)
                    VectorQuest = Vector3.new(-425, 73, 1837)
                    CFrameMyMon = CFrame.new(-874, 141, 1312)
                    VectorMon = Vector3.new(-874, 141, 1312)
                elseif _Value == 775 or _Value <= 799 then
                    LevelFarm = 3
                    Monster = 'Swan Pirate [Lv. 775]'
                    NameQuest = 'Area2Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Swan Pirate'
                    CFrameQuest = CFrame.new(634, 73, 918)
                    VectorQuest = Vector3.new(634, 73, 918)
                    CFrameMyMon = CFrame.new(878, 122, 1235)
                    VectorMon = Vector3.new(878, 122, 1235)
                elseif _Value == 800 or _Value <= 874 then
                    LevelFarm = 4
                    Monster = 'Factory Staff [Lv. 800]'
                    NameQuest = 'Area2Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Factory Staff'
                    CFrameQuest = CFrame.new(634, 73, 918)
                    VectorQuest = Vector3.new(634, 73, 918)
                    CFrameMyMon = CFrame.new(295, 73, -56)
                    VectorMon = Vector3.new(295, 73, -56)
                elseif _Value == 875 or _Value <= 899 then
                    LevelFarm = 5
                    Monster = 'Marine Lieutenant [Lv. 875]'
                    NameQuest = 'MarineQuest3'
                    LevelQuest = 1
                    NameCheckQuest = 'Marine Lieutenant'
                    CFrameMyMon = CFrame.new(-2806, 73, -3038)
                    VectorMon = Vector3.new(-2806, 73, -3038)
                    CFrameQuest = CFrame.new(-2443, 73, -3219)
                    VectorQuest = Vector3.new(-2443, 73, -3219)
                elseif _Value == 900 or _Value <= 949 then
                    LevelFarm = 6
                    Monster = 'Marine Captain [Lv. 900]'
                    NameQuest = 'MarineQuest3'
                    LevelQuest = 2
                    NameCheckQuest = 'Marine Captain'
                    CFrameMyMon = CFrame.new(-1869, 73, -3320)
                    VectorMon = Vector3.new(-1869, 73, -3320)
                    CFrameQuest = CFrame.new(-2443, 73, -3219)
                    VectorQuest = Vector3.new(-2443, 73, -3219)
                elseif _Value == 950 or _Value <= 974 then
                    LevelFarm = 7
                    Monster = 'Zombie [Lv. 950]'
                    NameQuest = 'ZombieQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Zombie'
                    CFrameMyMon = CFrame.new(-5736, 126, -728)
                    VectorMon = Vector3.new(-5736, 126, -728)
                    CFrameQuest = CFrame.new(-5494, 49, -795)
                    VectorQuest = Vector3.new(-5494, 49, -794)
                elseif _Value == 975 or _Value <= 999 then
                    LevelFarm = 8
                    Monster = 'Vampire [Lv. 975]'
                    NameQuest = 'ZombieQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Vampire'
                    CFrameMyMon = CFrame.new(-6033, 7, -1317)
                    VectorMon = Vector3.new(-6033, 7, -1317)
                    CFrameQuest = CFrame.new(-5494, 49, -795)
                    VectorQuest = Vector3.new(-5494, 49, -795)
                elseif _Value == 1000 or _Value <= 1049 then
                    LevelFarm = 9
                    Monster = 'Snow Trooper [Lv. 1000]'
                    NameQuest = 'SnowMountainQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Snow Trooper'
                    CFrameMyMon = CFrame.new(478, 402, -5362)
                    VectorMon = Vector3.new(478, 402, -5362)
                    CFrameQuest = CFrame.new(605, 402, -5371)
                    VectorQuest = Vector3.new(605, 402, -5371)
                elseif _Value == 1050 or _Value <= 1099 then
                    LevelFarm = 10
                    Monster = 'Winter Warrior [Lv. 1050]'
                    NameQuest = 'SnowMountainQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Winter Warrior'
                    CFrameMyMon = CFrame.new(1157, 430, -5188)
                    VectorMon = Vector3.new(1157, 430, -5188)
                    CFrameQuest = CFrame.new(605, 402, -5371)
                    VectorQuest = Vector3.new(605, 402, -5371)
                elseif _Value == 1100 or _Value <= 1124 then
                    LevelFarm = 11
                    Monster = 'Lab Subordinate [Lv. 1100]'
                    NameQuest = 'IceSideQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Lab Subordinate'
                    CFrameMyMon = CFrame.new(-5782, 42, -4484)
                    VectorMon = Vector3.new(-5782, 42, -4484)
                    CFrameQuest = CFrame.new(-6060, 16, -4905)
                    VectorQuest = Vector3.new(-6060, 16, -4905)
                elseif _Value == 1125 or _Value <= 1174 then
                    LevelFarm = 12
                    Monster = 'Horned Warrior [Lv. 1125]'
                    NameQuest = 'IceSideQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Horned Warrior'
                    CFrameMyMon = CFrame.new(-6406, 24, -5805)
                    VectorMon = Vector3.new(-6406, 24, -5805)
                    CFrameQuest = CFrame.new(-6060, 16, -4905)
                    VectorQuest = Vector3.new(-6060, 16, -4905)
                elseif _Value == 1175 or _Value <= 1199 then
                    LevelFarm = 13
                    Monster = 'Magma Ninja [Lv. 1175]'
                    NameQuest = 'FireSideQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Magma Ninja'
                    CFrameMyMon = CFrame.new(-5428, 78, -5959)
                    VectorMon = Vector3.new(-5428, 78, -5959)
                    CFrameQuest = CFrame.new(-5430, 16, -5295)
                    VectorQuest = Vector3.new(-5430, 16, -5296)
                elseif _Value == 1200 or _Value <= 1249 then
                    LevelFarm = 14
                    Monster = 'Lava Pirate [Lv. 1200]'
                    NameQuest = 'FireSideQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Lava Pirate'
                    CFrameMyMon = CFrame.new(-5270, 42, -4800)
                    VectorMon = Vector3.new(-5270, 42, -4800)
                    CFrameQuest = CFrame.new(-5430, 16, -5295)
                    VectorQuest = Vector3.new(-5430, 16, -5296)
                elseif _Value == 1250 or _Value <= 1274 then
                    LevelFarm = 15
                    Monster = 'Ship Deckhand [Lv. 1250]'
                    NameQuest = 'ShipQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Ship Deckhand'
                    CFrameMyMon = CFrame.new(1198, 126, 33031)
                    VectorMon = Vector3.new(1198, 126, 33031)
                    CFrameQuest = CFrame.new(1038, 125, 32913)
                    VectorQuest = Vector3.new(1038, 125, 32913)
                elseif _Value == 1275 or _Value <= 1299 then
                    LevelFarm = 16
                    Monster = 'Ship Engineer [Lv. 1275]'
                    NameQuest = 'ShipQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Ship Engineer'
                    CFrameMyMon = CFrame.new(918, 44, 32787)
                    VectorMon = Vector3.new(918, 44, 32787)
                    CFrameQuest = CFrame.new(1038, 125, 32913)
                    VectorQuest = Vector3.new(1038, 125, 32913)
                elseif _Value == 1300 or _Value <= 1324 then
                    LevelFarm = 17
                    Monster = 'Ship Steward [Lv. 1300]'
                    NameQuest = 'ShipQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Ship Steward'
                    CFrameMyMon = CFrame.new(915, 130, 33419)
                    VectorMon = Vector3.new(915, 130, 33419)
                    CFrameQuest = CFrame.new(969, 125, 33245)
                    VectorQuest = Vector3.new(969, 125, 33245)
                elseif _Value == 1325 or _Value <= 1349 then
                    LevelFarm = 18
                    Monster = 'Ship Officer [Lv. 1325]'
                    NameQuest = 'ShipQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Ship Officer'
                    CFrameMyMon = CFrame.new(916, 181, 33335)
                    VectorMon = Vector3.new(916, 181, 33335)
                    CFrameQuest = CFrame.new(969, 125, 33245)
                    VectorQuest = Vector3.new(969, 125, 33245)
                elseif _Value == 1350 or _Value <= 1374 then
                    LevelFarm = 19
                    Monster = 'Arctic Warrior [Lv. 1350]'
                    NameQuest = 'FrostQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Arctic Warrior'
                    CFrameMyMon = CFrame.new(6038, 29, -6231)
                    VectorMon = Vector3.new(6038, 29, -6231)
                    VectorQuest = Vector3.new(5669, 28, -6482)
                    CFrameQuest = CFrame.new(5669, 28, -6482)
                elseif _Value == 1375 or _Value <= 1424 then
                    LevelFarm = 20
                    Monster = 'Snow Lurker [Lv. 1375]'
                    NameQuest = 'FrostQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Snow Lurker'
                    CFrameMyMon = CFrame.new(5560, 42, -6826)
                    VectorMon = Vector3.new(5560, 42, -6826)
                    VectorQuest = Vector3.new(5669, 28, -6482)
                    CFrameQuest = CFrame.new(5669, 28, -6482)
                elseif _Value == 1425 or _Value <= 1449 then
                    LevelFarm = 21
                    Monster = 'Sea Soldier [Lv. 1425]'
                    NameQuest = 'ForgottenQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Sea Soldier'
                    CFrameMyMon = CFrame.new(-3022, 16, -9722)
                    VectorMon = Vector3.new(-3022, 16, -9722)
                    CFrameQuest = CFrame.new(-3054, 237, -10148)
                    VectorQuest = Vector3.new(-3054, 237, -10148)
                elseif _Value >= 1450 then
                    LevelFarm = 22
                    Monster = 'Water Fighter [Lv. 1450]'
                    NameQuest = 'ForgottenQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Water Fighter'
                    CFrameMyMon = CFrame.new(-3385, 239, -10542)
                    VectorMon = Vector3.new(-3385, 239, -10542)
                    CFrameQuest = CFrame.new(-3054, 237, -10148)
                    VectorQuest = Vector3.new(-3054, 237, -10148)
                end
            end
            if u77 then
                if _Value == 1500 or _Value <= 1524 then
                    LevelFarm = 1
                    Monster = 'Pirate Millionaire [Lv. 1500]'
                    NameQuest = 'PiratePortQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Pirate Millionaire'
                    CFrameMyMon = CFrame.new(-373, 75, 5550)
                    VectorMon = Vector3.new(-373, 75, 5550)
                    CFrameQuest = CFrame.new(-288, 44, 5576)
                    VectorQuest = Vector3.new(-288, 44, 5576)
                elseif _Value == 1525 or _Value <= 1574 then
                    LevelFarm = 2
                    Monster = 'Pistol Billionaire [Lv. 1525]'
                    NameQuest = 'PiratePortQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Pistol Billionaire'
                    CFrameMyMon = CFrame.new(-469, 74, 5904)
                    VectorMon = Vector3.new(-469, 74, 5904)
                    CFrameQuest = CFrame.new(-288, 44, 5576)
                    VectorQuest = Vector3.new(-288, 44, 5576)
                elseif _Value == 1575 or _Value <= 1599 then
                    LevelFarm = 3
                    Monster = 'Dragon Crew Warrior [Lv. 1575]'
                    NameQuest = 'AmazonQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Dragon Crew Warrior'
                    CFrameMyMon = CFrame.new(6339, 52, -1213)
                    VectorMon = Vector3.new(6338, 52, -1213)
                    CFrameQuest = CFrame.new(5835, 52, -1105)
                    VectorQuest = Vector3.new(5835, 52, -1105)
                elseif _Value == 1600 or _Value <= 1624 then
                    LevelFarm = 4
                    Monster = 'Dragon Crew Archer [Lv. 1600]'
                    NameQuest = 'AmazonQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Dragon Crew Archer'
                    CFrameMyMon = CFrame.new(6594, 383, 139)
                    VectorMon = Vector3.new(6594, 383, 139)
                    CFrameQuest = CFrame.new(5835, 52, -1105)
                    VectorQuest = Vector3.new(5835, 52, -1105)
                elseif _Value == 1625 or _Value <= 1649 then
                    LevelFarm = 5
                    Monster = 'Female Islander [Lv. 1625]'
                    NameQuest = 'AmazonQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Female Islander'
                    CFrameMyMon = CFrame.new(5308, 819, 1047)
                    VectorMon = Vector3.new(5308, 819, 1047)
                    CFrameQuest = CFrame.new(5443, 602, 751)
                    VectorQuest = Vector3.new(5443, 602, 751)
                elseif _Value == 1650 or _Value <= 1699 then
                    LevelFarm = 6
                    Monster = 'Giant Islander [Lv. 1650]'
                    NameQuest = 'AmazonQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Giant Islanders'
                    CFrameMyMon = CFrame.new(4951, 602, -68)
                    VectorMon = Vector3.new(4951, 602, -68)
                    CFrameQuest = CFrame.new(5443, 602, 751)
                    VectorQuest = Vector3.new(5443, 602, 751)
                elseif _Value == 1700 or _Value <= 1724 then
                    LevelFarm = 7
                    Monster = 'Marine Commodore [Lv. 1700]'
                    NameQuest = 'MarineTreeIsland'
                    LevelQuest = 1
                    NameCheckQuest = 'Marine Commodore'
                    CFrameMyMon = CFrame.new(2447, 73, -7470)
                    VectorMon = Vector3.new(2447, 73, -7470)
                    CFrameQuest = CFrame.new(2180, 29, -6737)
                    VectorQuest = Vector3.new(2180, 29, -6737)
                elseif _Value == 1725 or _Value <= 1774 then
                    LevelFarm = 8
                    Monster = 'Marine Rear Admiral [Lv. 1725]'
                    NameQuest = 'MarineTreeIsland'
                    LevelQuest = 2
                    NameCheckQuest = 'Marine Rear Admiral'
                    CFrameMyMon = CFrame.new(3671, 161, -6932)
                    VectorMon = Vector3.new(3671, 161, -6932)
                    CFrameQuest = CFrame.new(2180, 29, -6737)
                    VectorQuest = Vector3.new(2180, 29, -6737)
                elseif _Value == 1775 or _Value <= 1800 then
                    LevelFarm = 9
                    Monster = 'Fishman Raider [Lv. 1775]'
                    NameQuest = 'DeepForestIsland3'
                    LevelQuest = 1
                    NameCheckQuest = 'Fishman Raider'
                    CFrameMyMon = CFrame.new(-10560, 332, -8466)
                    VectorMon = Vector3.new(-10560, 332, -8466)
                    CFrameQuest = CFrame.new(-10584, 332, -8758)
                    VectorQuest = Vector3.new(-10584, 332, -8758)
                elseif _Value == 1800 or _Value <= 1824 then
                    LevelFarm = 10
                    Monster = 'Fishman Captain [Lv. 1800]'
                    NameQuest = 'DeepForestIsland3'
                    LevelQuest = 2
                    NameCheckQuest = 'Fishman Captain'
                    CFrameMyMon = CFrame.new(-10993, 332, -8940)
                    VectorMon = Vector3.new(-10993, 332, -8940)
                    CFrameQuest = CFrame.new(-10584, 332, -8758)
                    VectorQuest = Vector3.new(-10584, 332, -8758)
                elseif _Value == 1825 or _Value <= 1849 then
                    LevelFarm = 11
                    Monster = 'Forest Pirate [Lv. 1825]'
                    NameQuest = 'DeepForestIsland'
                    LevelQuest = 1
                    NameCheckQuest = 'Forest Pirate'
                    CFrameMyMon = CFrame.new(-13479, 333, -7905)
                    VectorMon = Vector3.new(-13479, 333, -7905)
                    CFrameQuest = CFrame.new(-13232, 333, -7627)
                    VectorQuest = Vector3.new(-13232, 333, -7627)
                elseif _Value == 1850 or _Value <= 1899 then
                    LevelFarm = 12
                    Monster = 'Mythological Pirate [Lv. 1850]'
                    NameQuest = 'DeepForestIsland'
                    LevelQuest = 2
                    NameCheckQuest = 'Mythological Pirate'
                    CFrameMyMon = CFrame.new(-13545, 470, -6917)
                    VectorMon = Vector3.new(-13545, 470, -6917)
                    CFrameQuest = CFrame.new(-13232, 333, -7627)
                    VectorQuest = Vector3.new(-13232, 333, -7627)
                elseif _Value == 1900 or _Value <= 1924 then
                    LevelFarm = 13
                    Monster = 'Jungle Pirate [Lv. 1900]'
                    NameQuest = 'DeepForestIsland2'
                    LevelQuest = 1
                    NameCheckQuest = 'Jungle Pirate'
                    CFrameMyMon = CFrame.new(-12107, 332, -10549)
                    VectorMon = Vector3.new(-12106, 332, -10549)
                    CFrameQuest = CFrame.new(-12684, 391, -9902)
                    VectorQuest = Vector3.new(-12684, 391, -9902)
                elseif _Value == 1925 or _Value <= 1974 then
                    LevelFarm = 14
                    Monster = 'Musketeer Pirate [Lv. 1925]'
                    NameQuest = 'DeepForestIsland2'
                    LevelQuest = 2
                    NameCheckQuest = 'Musketeer Pirate'
                    CFrameMyMon = CFrame.new(-13286, 392, -9769)
                    VectorMon = Vector3.new(-13286, 392, -9768)
                    CFrameQuest = CFrame.new(-12684, 391, -9902)
                    VectorQuest = Vector3.new(-12684, 391, -9902)
                elseif _Value == 1975 or _Value <= 1999 then
                    LevelFarm = 15
                    Monster = 'Reborn Skeleton [Lv. 1975]'
                    NameQuest = 'HauntedQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Reborn Skeleton'
                    CFrameMyMon = CFrame.new(-8760, 142, 6039)
                    VectorMon = Vector3.new(-8760, 142, 6039)
                    CFrameQuest = CFrame.new(-9482, 142, 5567)
                    VectorQuest = Vector3.new(-9482, 142, 5567)
                elseif _Value == 2000 or _Value <= 2024 then
                    LevelFarm = 16
                    Monster = 'Living Zombie [Lv. 2000]'
                    NameQuest = 'HauntedQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Living Zombie'
                    CFrameMyMon = CFrame.new(-10144, 140, 5932)
                    VectorMon = Vector3.new(-10144, 140, 5932)
                    CFrameQuest = CFrame.new(-9482, 142, 5567)
                    VectorQuest = Vector3.new(-9482, 142, 5567)
                elseif _Value == 2025 or _Value <= 2049 then
                    LevelFarm = 17
                    Monster = 'Demonic Soul [Lv. 2025]'
                    NameQuest = 'HauntedQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Demonic Soul'
                    CFrameMyMon = CFrame.new(-9507, 172, 6158)
                    VectorMon = Vector3.new(-9506, 172, 6158)
                    CFrameQuest = CFrame.new(-9513, 172, 6079)
                    VectorQuest = Vector3.new(-9513, 172, 6079)
                elseif _Value == 2050 or _Value <= 2074 then
                    LevelFarm = 18
                    Monster = 'Posessed Mummy [Lv. 2050]'
                    NameQuest = 'HauntedQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Posessed Mummy'
                    CFrameMyMon = CFrame.new(-9577, 6, 6223)
                    VectorMon = Vector3.new(-9577, 6, 6223)
                    CFrameQuest = CFrame.new(-9513, 172, 6079)
                    VectorQuest = Vector3.new(-9513, 172, 6079)
                elseif _Value == 2075 or _Value <= 2099 then
                    LevelFarm = 19
                    Monster = 'Peanut Scout [Lv. 2075]'
                    NameQuest = 'NutsIslandQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Peanut Scout'
                    CFrameMyMon = CFrame.new(-2124, 123, -10435)
                    VectorMon = Vector3.new(-2124, 123, -10435)
                    CFrameQuest = CFrame.new(-2104, 38, -10192)
                    VectorQuest = Vector3.new(-2104, 38, -10192)
                elseif _Value == 2100 or _Value <= 2124 then
                    LevelFarm = 20
                    Monster = 'Peanut President [Lv. 2100]'
                    NameQuest = 'NutsIslandQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Peanut President'
                    CFrameMyMon = CFrame.new(-2124, 123, -10435)
                    VectorMon = Vector3.new(-2124, 123, -10435)
                    CFrameQuest = CFrame.new(-2104, 38, -10192)
                    VectorQuest = Vector3.new(-2104, 38, -10192)
                elseif _Value == 2125 or _Value <= 2149 then
                    LevelFarm = 21
                    Monster = 'Ice Cream Chef [Lv. 2125]'
                    NameQuest = 'IceCreamIslandQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Ice Cream Chef'
                    CFrameMyMon = CFrame.new(-641, 127, -11062)
                    VectorMon = Vector3.new(-641, 127, -11062)
                    CFrameQuest = CFrame.new(-822, 66, -10965)
                    VectorQuest = Vector3.new(-822, 66, -10965)
                elseif _Value == 2150 or _Value <= 2199 then
                    LevelFarm = 22
                    Monster = 'Ice Cream Commander [Lv. 2150]'
                    NameQuest = 'IceCreamIslandQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Ice Cream Commander'
                    CFrameMyMon = CFrame.new(-641, 127, -11062)
                    VectorMon = Vector3.new(-641, 127, -11062)
                    CFrameQuest = CFrame.new(-822, 66, -10965)
                    VectorQuest = Vector3.new(-822, 66, -10965)
                elseif _Value == 2200 or _Value <= 2224 then
                    LevelFarm = 23
                    Monster = 'Cookie Crafter [Lv. 2200]'
                    NameQuest = 'CakeQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Cookie Crafter'
                    CFrameMyMon = CFrame.new(-2365, 38, -12099)
                    VectorMon = Vector3.new(-2365, 38, -12099)
                    CFrameQuest = CFrame.new(-2020, 38, -12025)
                    VectorQuest = Vector3.new(-2020, 38, -12025)
                elseif _Value == 2225 or _Value <= 2249 then
                    LevelFarm = 24
                    Monster = 'Cake Guard [Lv. 2225]'
                    NameQuest = 'CakeQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Cake Guard'
                    CFrameMyMon = CFrame.new(-1651, 38, -12308)
                    VectorMon = Vector3.new(-1651, 38, -12308)
                    CFrameQuest = CFrame.new(-2020, 38, -12025)
                    VectorQuest = Vector3.new(-2020, 38, -12025)
                elseif _Value == 2250 or _Value <= 2274 then
                    LevelFarm = 25
                    Monster = 'Baking Staff [Lv. 2250]'
                    NameQuest = 'CakeQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Baking Staff'
                    CFrameMyMon = CFrame.new(-1870, 38, -12938)
                    VectorMon = Vector3.new(-1870, 38, -12938)
                    CFrameQuest = CFrame.new(-1926, 38, -12850)
                    VectorQuest = Vector3.new(-1926, 38, -12850)
                elseif _Value == 2275 or _Value <= 2300 then
                    LevelFarm = 26
                    Monster = 'Head Baker [Lv. 2275]'
                    NameQuest = 'CakeQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Head Baker'
                    CFrameMyMon = CFrame.new(-1926, 88, -12850)
                    VectorMon = CFrame.new(-1870, 38, -12938)
                    CFrameQuest = CFrame.new(-1926, 38, -12850)
                    VectorQuest = Vector3.new(-1926, 38, -12850)
                elseif _Value == 2300 or _Value <= 2324 then
                    LevelFarm = 27
                    Monster = 'Cocoa Warrior [Lv. 2300]'
                    NameQuest = 'ChocQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Cocoa Warrior'
                    CFrameMyMon = CFrame.new(79.4172134399414, 73.42101287841797, -12310.0205078125)
                    CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
                elseif _Value == 2325 or _Value <= 2349 then
                    LevelFarm = 28
                    Monster = 'Chocolate Bar Battler [Lv. 2325]'
                    NameQuest = 'ChocQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Chocolate Bar Battler'
                    CFrameMyMon = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
                    CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
                elseif _Value == 2350 or _Value <= 2374 then
                    LevelFarm = 29
                    Monster = 'Sweet Thief [Lv. 2350]'
                    NameQuest = 'ChocQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Sweet Thief'
                    CFrameMyMon = CFrame.new(71.89511108398438, 77.21478271484375, -12632.435546875)
                    CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
                elseif _Value == 2375 or _Value <= 2399 then
                    LevelFarm = 30
                    Monster = 'Candy Rebel [Lv. 2375]'
                    NameQuest = 'ChocQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Candy Rebel'
                    CFrameMyMon = CFrame.new(134.3748016357422, 77.21473693847656, -12882.1650390625)
                    CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
                elseif _Value == 2400 or _Value <= 2424 then
                    LevelFarm = 31
                    Monster = 'Candy Pirate [Lv. 2400]'
                    NameQuest = 'CandyQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Candy Pirate'
                    CFrameMyMon = CFrame.new(-1271.6993408203125, 139.93331909179688, -14354.8515625)
                    CFrameQuest = CFrame.new(-1147.6552734375, 17.82676887512207, -14447.7099609375)
                elseif _Value == 2425 or _Value <= 2449 then
                    LevelFarm = 32
                    Monster = 'Snow Demon [Lv. 2425]'
                    NameQuest = 'CandyQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Snow Demon'
                    CFrameMyMon = CFrame.new(-850.6035766601563, 14.933446884155273, -14326.2763671875)
                    CFrameQuest = CFrame.new(-1149.328, 13.5759039, -14445.6143, -0.156446099, 0, -0.987686574, 0, 1, 0, 0.987686574, 0, -0.156446099)
                elseif _Value == 2450 or _Value <= 2474 then
                    LevelFarm = 33
                    Monster = 'Isle Outlaw [Lv. 2450]'
                    NameQuest = 'TikiQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Isle Outlaw'
                    CFrameMyMon = CFrame.new(-16277.9599609375, 94.06755828857422, -168.73194885253906)
                    CFrameQuest = CFrame.new(-16545.927734375, 55.68635559082031, -173.01036071777344)
                elseif _Value == 2475 or _Value <= 2499 then
                    LevelFarm = 34
                    Monster = 'Island Boy [Lv. 2475]'
                    NameQuest = 'TikiQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Island Boy'
                    CFrameMyMon = CFrame.new(-16749.416015625, 125.9124755859375, -272.1277770996094)
                    CFrameQuest = CFrame.new(-16545.927734375, 55.68635559082031, -173.01036071777344)
                elseif _Value == 2500 or _Value <= 2524 then
                    LevelFarm = 35
                    Monster = 'Sun-kissed Warrior [Lv. 2500]'
                    NameQuest = 'TikiQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'kissed Warrior'
                    CFrameMyMon = CFrame.new(-16277.009765625, 68.78734588623047, 1041.3009033203125)
                    CFrameQuest = CFrame.new(-16538.888671875, 55.68632888793945, 1051.730712890625)
                elseif _Value >= 2525 then
                    LevelFarm = 36
                    Monster = 'Isle Champion [Lv. 2525]'
                    NameQuest = 'TikiQuest2'
                    LevelQuest = 2
                    NameCheckQuest = 'Isle Champion'
                    CFrameMyMon = CFrame.new(-16743.2421875, 137.21322631835938, 1148.2789306640625)
                    CFrameQuest = CFrame.new(-16538.888671875, 55.68632888793945, 1051.730712890625)
                end
            end

            CFrameMon = CheckEnemySpawn(Monster) or CFrameMyMon
        end)
        CheckOldQuest = LPH_JIT_MAX(function(p648)
            if u75 then
                if p648 == 1 then
                    Monster = 'Bandit [Lv. 5]'
                    NameQuest = 'BanditQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Bandit'
                    CFrameMyMon = CFrame.new(1145, 17, 1634)
                    VectorMon = Vector3.new(1145, 17, 1634)
                    CFrameQuest = CFrame.new(1060, 17, 1547)
                    VectorQuest = Vector3.new(1060, 17, 1547)
                elseif p648 == 2 then
                    Monster = 'Monkey [Lv. 14]'
                    NameQuest = 'JungleQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Monkey'
                    CFrameMyMon = CFrame.new(-1496, 39, 35)
                    VectorMon = Vector3.new(-1496, 39, 35)
                    CFrameQuest = CFrame.new(-1602, 37, 152)
                    VectorQuest = Vector3.new(-1602, 37, 152)
                elseif p648 == 3 then
                    Monster = 'Gorilla [Lv. 20]'
                    NameQuest = 'JungleQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Gorilla'
                    CFrameMyMon = CFrame.new(-1237, 6, -486)
                    VectorMon = Vector3.new(-1237, 7, -486)
                    CFrameQuest = CFrame.new(-1602, 37, 152)
                    VectorQuest = Vector3.new(-1602, 37, 152)
                elseif p648 == 4 then
                    Monster = 'Pirate [Lv. 35]'
                    NameQuest = 'BuggyQuest1'
                    LevelQuest = 1
                    NameCheckQuest = 'Pirate'
                    CFrameMyMon = CFrame.new(-1115, 14, 3938)
                    VectorMon = Vector3.new(-1115, 14, 3938)
                    CFrameQuest = CFrame.new(-1140, 5, 3828)
                    VectorQuest = Vector3.new(-1140, 5, 3828)
                elseif p648 == 5 then
                    Monster = 'Brute [Lv. 45]'
                    NameQuest = 'BuggyQuest1'
                    LevelQuest = 2
                    NameCheckQuest = 'Brute'
                    CFrameMyMon = CFrame.new(-1145, 15, 4350)
                    VectorMon = Vector3.new(-1146, 15, 4350)
                    CFrameQuest = CFrame.new(-1140, 5, 3828)
                    VectorQuest = Vector3.new(-1140, 5, 3828)
                elseif p648 == 6 then
                    Monster = 'Desert Bandit [Lv. 60]'
                    NameQuest = 'DesertQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Desert Bandit'
                    CFrameMyMon = CFrame.new(932, 7, 4484)
                    VectorMon = Vector3.new(932, 7, 4484)
                    CFrameQuest = CFrame.new(897, 7, 4388)
                    VectorQuest = Vector3.new(897, 7, 4388)
                elseif p648 == 7 then
                    Monster = 'Desert Officer [Lv. 70]'
                    NameQuest = 'DesertQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Desert Officer'
                    CFrameMyMon = CFrame.new(1572, 10, 4373)
                    VectorMon = Vector3.new(1572, 10, 4373)
                    CFrameQuest = CFrame.new(897, 7, 4388)
                    VectorQuest = Vector3.new(897, 7, 4388)
                elseif p648 == 8 then
                    Monster = 'Snow Bandit [Lv. 90]'
                    NameQuest = 'SnowQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Snow Bandits'
                    CFrameMyMon = CFrame.new(1289, 150, -1442)
                    VectorMon = Vector3.new(1289, 106, -1442)
                    CFrameQuest = CFrame.new(1386, 87, -1297)
                    VectorQuest = Vector3.new(1386, 87, -1297)
                elseif p648 == 9 then
                    Monster = 'Snowman [Lv. 100]'
                    NameQuest = 'SnowQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Snowman'
                    CFrameMyMon = CFrame.new(1289, 150, -1442)
                    VectorMon = Vector3.new(1289, 106, -1442)
                    CFrameQuest = CFrame.new(1386, 87, -1297)
                    VectorQuest = Vector3.new(1386, 87, -1297)
                elseif p648 == 10 then
                    Monster = 'Chief Petty Officer [Lv. 120]'
                    NameQuest = 'MarineQuest2'
                    LevelQuest = 1
                    NameCheckQuest = 'Chief Petty Officer'
                    CFrameMyMon = CFrame.new(-4855, 23, 4308)
                    VectorMon = Vector3.new(-4855, 23, 4308)
                    CFrameQuest = CFrame.new(-5036, 29, 4325)
                    VectorQuest = Vector3.new(-5036, 29, 4325)
                elseif p648 == 11 then
                    Monster = 'Sky Bandit [Lv. 150]'
                    NameQuest = 'SkyQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Sky Bandit'
                    CFrameMyMon = CFrame.new(-4981, 278, -2830)
                    VectorMon = Vector3.new(-4981, 278, -2830)
                    CFrameQuest = CFrame.new(-4842, 718, -2623)
                    VectorQuest = Vector3.new(-4842, 718, -2623)
                elseif p648 == 12 then
                    Monster = 'Dark Master [Lv. 175]'
                    NameQuest = 'SkyQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Dark Master'
                    CFrameMyMon = CFrame.new(-5250, 389, -2272)
                    VectorMon = Vector3.new(-5250, 389, -2272)
                    CFrameQuest = CFrame.new(-4842, 718, -2623)
                    VectorQuest = Vector3.new(-4842, 718, -2623)
                elseif p648 == 13 then
                    Monster = 'Prisoner [Lv. 190]'
                    NameQuest = 'PrisonerQuest'
                    LevelQuest = 1
                    NameCheckQuest = '8 Prisoner'
                    CFrameMyMon = CFrame.new(5411, 96, 690)
                    VectorMon = Vector3.new(5411, 96, 690)
                    CFrameQuest = CFrame.new(5308, 2, 474)
                    VectorQuest = Vector3.new(5308, 2, 474)
                elseif p648 == 14 then
                    Monster = 'Dangerous Prisoner [Lv. 210]'
                    NameQuest = 'PrisonerQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Dangerous Prisoner'
                    CFrameMyMon = CFrame.new(5411, 96, 690)
                    VectorMon = Vector3.new(5411, 96, 690)
                    CFrameQuest = CFrame.new(5308, 2, 474)
                    VectorQuest = Vector3.new(5308, 2, 474)
                elseif p648 == 15 then
                    Monster = 'Toga Warrior [Lv. 250]'
                    NameQuest = 'ColosseumQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Toga Warrior'
                    CFrameMyMon = CFrame.new(-1641.4344482421875, 7.415142059326172, -2864.462646484375)
                    VectorMon = Vector3.new(-1770, 8, -2777)
                    CFrameQuest = CFrame.new(-1576, 8, -2985)
                    VectorQuest = Vector3.new(-1576, 8, -2985)
                elseif p648 == 16 then
                    Monster = 'Gladiator [Lv. 275]'
                    NameQuest = 'ColosseumQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Gladiato'
                    CFrameMyMon = CFrame.new(-1385.5233154296875, 7.468349456787109, -3163.066650390625)
                    VectorMon = Vector3.new(-1278, 8, -3240)
                    CFrameQuest = CFrame.new(-1576, 8, -2985)
                    VectorQuest = Vector3.new(-1576, 8, -2985)
                elseif p648 == 17 then
                    Monster = 'Military Soldier [Lv. 300]'
                    NameQuest = 'MagmaQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Military Soldier'
                    CFrameMyMon = CFrame.new(-5408, 11, 8447)
                    VectorMon = Vector3.new(-5408, 11, 8447)
                    CFrameQuest = CFrame.new(-5316, 12, 8517)
                    VectorQuest = Vector3.new(-5316, 12, 8517)
                elseif p648 == 18 then
                    Monster = 'Military Spy [Lv. 325]'
                    NameQuest = 'MagmaQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Military Spy'
                    CFrameMyMon = CFrame.new(-5815, 84, 8820)
                    VectorMon = Vector3.new(-5815, 84, 8820)
                    CFrameQuest = CFrame.new(-5316, 12, 8517)
                    VectorQuest = Vector3.new(-5316, 12, 8517)
                elseif p648 == 19 then
                    Monster = 'Fishman Warrior [Lv. 375]'
                    NameQuest = 'FishmanQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Fishman Warrior'
                    CFrameMyMon = CFrame.new(60859, 19, 1501)
                    VectorMon = Vector3.new(60859, 19, 1501)
                    CFrameQuest = CFrame.new(61123, 19, 1569)
                    VectorQuest = Vector3.new(61123, 19, 1569)
                elseif p648 == 20 then
                    Monster = 'Fishman Commando [Lv. 400]'
                    NameQuest = 'FishmanQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Fishman Commando'
                    CFrameMyMon = CFrame.new(61891, 19, 1470)
                    VectorMon = Vector3.new(61891, 19, 1470)
                    CFrameQuest = CFrame.new(61123, 19, 1569)
                    VectorQuest = Vector3.new(61123, 19, 1569)
                elseif p648 == 21 then
                    Monster = "God's Guard [Lv. 450]"
                    NameQuest = 'SkyExp1Quest'
                    LevelQuest = 1
                    NameCheckQuest = "God's Guards"
                    CFrameMyMon = CFrame.new(-4698, 845, -1912)
                    VectorMon = Vector3.new(-4698, 845, -1912)
                    CFrameQuest = CFrame.new(-4722, 845, -1954)
                    VectorQuest = Vector3.new(-4722, 846, -1954)
                elseif p648 == 22 then
                    Monster = 'Shanda [Lv. 475]'
                    NameQuest = 'SkyExp1Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Shandas'
                    CFrameMyMon = CFrame.new(-7685, 5567, -502)
                    VectorMon = Vector3.new(-7685, 5567, -502)
                    CFrameQuest = CFrame.new(-7862, 5546, -380)
                    VectorQuest = Vector3.new(-7862, 5546, -380)
                elseif p648 == 23 then
                    Monster = 'Royal Squad [Lv. 525]'
                    NameQuest = 'SkyExp2Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Royal Squad'
                    CFrameMyMon = CFrame.new(-7670, 5607, -1460)
                    VectorMon = Vector3.new(-7670, 5607, -1460)
                    CFrameQuest = CFrame.new(-7904, 5636, -1412)
                    VectorQuest = Vector3.new(-7904, 5636, -1412)
                elseif p648 == 24 then
                    Monster = 'Royal Soldier [Lv. 550]'
                    NameQuest = 'SkyExp2Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Royal Soldier'
                    CFrameMyMon = CFrame.new(-7828, 5607, -1744)
                    VectorMon = Vector3.new(-7828, 5607, -1744)
                    CFrameQuest = CFrame.new(-7904, 5636, -1412)
                    VectorQuest = Vector3.new(-7904, 5636, -1412)
                elseif p648 == 25 then
                    Monster = 'Galley Pirate [Lv. 625]'
                    NameQuest = 'FountainQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Galley Pirate'
                    CFrameMyMon = CFrame.new(5589, 45, 3996)
                    VectorMon = Vector3.new(5589, 45, 3996)
                    CFrameQuest = CFrame.new(5256, 39, 4050)
                    VectorQuest = Vector3.new(5256, 39, 4050)
                elseif p648 == 26 then
                    Monster = 'Galley Captain [Lv. 650]'
                    NameQuest = 'FountainQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Galley Captain'
                    CFrameMyMon = CFrame.new(5649, 39, 4936)
                    VectorMon = Vector3.new(5649, 39, 4936)
                    CFrameQuest = CFrame.new(5256, 39, 4050)
                    VectorQuest = Vector3.new(5256, 39, 4050)
                end
            end
            if u76 then
                if p648 == 1 then
                    Monster = 'Raider [Lv. 700]'
                    NameQuest = 'Area1Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Raider'
                    CFrameQuest = CFrame.new(-425, 73, 1837)
                    VectorQuest = Vector3.new(-425, 73, 1837)
                    CFrameMyMon = CFrame.new(-746, 39, 2390)
                    VectorMon = Vector3.new(-746, 39, 2389)
                elseif p648 == 2 then
                    Monster = 'Mercenary [Lv. 725]'
                    NameQuest = 'Area1Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Mercenary'
                    CFrameQuest = CFrame.new(-425, 73, 1837)
                    VectorQuest = Vector3.new(-425, 73, 1837)
                    CFrameMyMon = CFrame.new(-874, 141, 1312)
                    VectorMon = Vector3.new(-874, 141, 1312)
                elseif p648 == 3 then
                    Monster = 'Swan Pirate [Lv. 775]'
                    NameQuest = 'Area2Quest'
                    LevelQuest = 1
                    NameCheckQuest = 'Swan Pirate'
                    CFrameQuest = CFrame.new(634, 73, 918)
                    VectorQuest = Vector3.new(634, 73, 918)
                    CFrameMyMon = CFrame.new(878, 122, 1235)
                    VectorMon = Vector3.new(878, 122, 1235)
                elseif p648 == 4 then
                    Monster = 'Factory Staff [Lv. 800]'
                    NameQuest = 'Area2Quest'
                    LevelQuest = 2
                    NameCheckQuest = 'Factory Staff'
                    CFrameQuest = CFrame.new(634, 73, 918)
                    VectorQuest = Vector3.new(634, 73, 918)
                    CFrameMyMon = CFrame.new(295, 73, -56)
                    VectorMon = Vector3.new(295, 73, -56)
                elseif p648 == 5 then
                    Monster = 'Marine Lieutenant [Lv. 875]'
                    NameQuest = 'MarineQuest3'
                    LevelQuest = 1
                    NameCheckQuest = 'Marine Lieutenant'
                    CFrameMyMon = CFrame.new(-2806, 73, -3038)
                    VectorMon = Vector3.new(-2806, 73, -3038)
                    CFrameQuest = CFrame.new(-2443, 73, -3219)
                    VectorQuest = Vector3.new(-2443, 73, -3219)
                elseif p648 == 6 then
                    Monster = 'Marine Captain [Lv. 900]'
                    NameQuest = 'MarineQuest3'
                    LevelQuest = 2
                    NameCheckQuest = 'Marine Captain'
                    CFrameMyMon = CFrame.new(-1869, 73, -3320)
                    VectorMon = Vector3.new(-1869, 73, -3320)
                    CFrameQuest = CFrame.new(-2443, 73, -3219)
                    VectorQuest = Vector3.new(-2443, 73, -3219)
                elseif p648 == 7 then
                    Monster = 'Zombie [Lv. 950]'
                    NameQuest = 'ZombieQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Zombie'
                    CFrameMyMon = CFrame.new(-5736, 126, -728)
                    VectorMon = Vector3.new(-5736, 126, -728)
                    CFrameQuest = CFrame.new(-5494, 49, -795)
                    VectorQuest = Vector3.new(-5494, 49, -794)
                elseif p648 == 8 then
                    Monster = 'Vampire [Lv. 975]'
                    NameQuest = 'ZombieQuest'
                    LevelQuest = 2
                    NameCheckQuest = 'Vampire'
                    CFrameMyMon = CFrame.new(-6033, 7, -1317)
                    VectorMon = Vector3.new(-6033, 7, -1317)
                    CFrameQuest = CFrame.new(-5494, 49, -795)
                    VectorQuest = Vector3.new(-5494, 49, -795)
                elseif p648 ~= 9 then
                    if p648 ~= 10 then
                        if p648 ~= 11 then
                            if p648 ~= 12 then
                                if p648 ~= 13 then
                                    if p648 ~= 14 then
                                        if p648 ~= 15 then
                                            if p648 ~= 16 then
                                                if p648 ~= 17 then
                                                    if p648 ~= 18 then
                                                        if p648 ~= 19 then
                                                            if p648 ~= 20 then
                                                                if p648 ~= 21 then
                                                                    if p648 == 22 then
                                                                        Monster = 'Water Fighter [Lv. 1450]'
                                                                        NameQuest = 'ForgottenQuest'
                                                                        LevelQuest = 2
                                                                        NameCheckQuest = 'Water Fighter'
                                                                        CFrameMyMon = CFrame.new(-3385, 239, -10542)
                                                                        VectorMon = Vector3.new(-3385, 239, -10542)
                                                                        CFrameQuest = CFrame.new(-3054, 237, -10148)
                                                                        VectorQuest = Vector3.new(-3054, 237, -10148)
                                                                    end
                                                                else
                                                                    Monster = 'Sea Soldier [Lv. 1425]'
                                                                    NameQuest = 'ForgottenQuest'
                                                                    LevelQuest = 1
                                                                    NameCheckQuest = 'Sea Soldier'
                                                                    CFrameMyMon = CFrame.new(-3022, 16, -9722)
                                                                    VectorMon = Vector3.new(-3022, 16, -9722)
                                                                    CFrameQuest = CFrame.new(-3054, 237, -10148)
                                                                    VectorQuest = Vector3.new(-3054, 237, -10148)
                                                                end
                                                            else
                                                                Monster = 'Snow Lurker [Lv. 1375]'
                                                                NameQuest = 'FrostQuest'
                                                                LevelQuest = 2
                                                                NameCheckQuest = 'Snow Lurker'
                                                                CFrameMyMon = CFrame.new(5560, 42, -6826)
                                                                VectorMon = Vector3.new(5560, 42, -6826)
                                                                VectorQuest = Vector3.new(5669, 28, -6482)
                                                                CFrameQuest = CFrame.new(5669, 28, -6482)
                                                            end
                                                        else
                                                            Monster = 'Arctic Warrior [Lv. 1350]'
                                                            NameQuest = 'FrostQuest'
                                                            LevelQuest = 1
                                                            NameCheckQuest = 'Arctic Warrior'
                                                            CFrameMyMon = CFrame.new(6038, 29, -6231)
                                                            VectorMon = Vector3.new(6038, 29, -6231)
                                                            VectorQuest = Vector3.new(5669, 28, -6482)
                                                            CFrameQuest = CFrame.new(5669, 28, -6482)
                                                        end
                                                    else
                                                        Monster = 'Ship Officer [Lv. 1325]'
                                                        NameQuest = 'ShipQuest2'
                                                        LevelQuest = 2
                                                        NameCheckQuest = 'Ship Officer'
                                                        CFrameMyMon = CFrame.new(916, 181, 33335)
                                                        VectorMon = Vector3.new(916, 181, 33335)
                                                        CFrameQuest = CFrame.new(969, 125, 33245)
                                                        VectorQuest = Vector3.new(969, 125, 33245)
                                                    end
                                                else
                                                    Monster = 'Ship Steward [Lv. 1300]'
                                                    NameQuest = 'ShipQuest2'
                                                    LevelQuest = 1
                                                    NameCheckQuest = 'Ship Steward'
                                                    CFrameMyMon = CFrame.new(915, 130, 33419)
                                                    VectorMon = Vector3.new(915, 130, 33419)
                                                    CFrameQuest = CFrame.new(969, 125, 33245)
                                                    VectorQuest = Vector3.new(969, 125, 33245)
                                                end
                                            else
                                                Monster = 'Ship Engineer [Lv. 1275]'
                                                NameQuest = 'ShipQuest1'
                                                LevelQuest = 2
                                                NameCheckQuest = 'Ship Engineer'
                                                CFrameMyMon = CFrame.new(918, 44, 32787)
                                                VectorMon = Vector3.new(918, 44, 32787)
                                                CFrameQuest = CFrame.new(1038, 125, 32913)
                                                VectorQuest = Vector3.new(1038, 125, 32913)
                                            end
                                        else
                                            Monster = 'Ship Deckhand [Lv. 1250]'
                                            NameQuest = 'ShipQuest1'
                                            LevelQuest = 1
                                            NameCheckQuest = 'Ship Deckhand'
                                            CFrameMyMon = CFrame.new(1198, 126, 33031)
                                            VectorMon = Vector3.new(1198, 126, 33031)
                                            CFrameQuest = CFrame.new(1038, 125, 32913)
                                            VectorQuest = Vector3.new(1038, 125, 32913)
                                        end
                                    else
                                        Monster = 'Lava Pirate [Lv. 1200]'
                                        NameQuest = 'FireSideQuest'
                                        LevelQuest = 2
                                        NameCheckQuest = 'Lava Pirate'
                                        CFrameMyMon = CFrame.new(-5270, 42, -4800)
                                        VectorMon = Vector3.new(-5270, 42, -4800)
                                        CFrameQuest = CFrame.new(-5430, 16, -5295)
                                        VectorQuest = Vector3.new(-5430, 16, -5296)
                                    end
                                else
                                    Monster = 'Magma Ninja [Lv. 1175]'
                                    NameQuest = 'FireSideQuest'
                                    LevelQuest = 1
                                    NameCheckQuest = 'Magma Ninja'
                                    CFrameMyMon = CFrame.new(-5428, 78, -5959)
                                    VectorMon = Vector3.new(-5428, 78, -5959)
                                    CFrameQuest = CFrame.new(-5430, 16, -5295)
                                    VectorQuest = Vector3.new(-5430, 16, -5296)
                                end
                            else
                                Monster = 'Horned Warrior [Lv. 1125]'
                                NameQuest = 'IceSideQuest'
                                LevelQuest = 2
                                NameCheckQuest = 'Horned Warrior'
                                CFrameMyMon = CFrame.new(-6406, 24, -5805)
                                VectorMon = Vector3.new(-6406, 24, -5805)
                                CFrameQuest = CFrame.new(-6060, 16, -4905)
                                VectorQuest = Vector3.new(-6060, 16, -4905)
                            end
                        else
                            Monster = 'Lab Subordinate [Lv. 1100]'
                            NameQuest = 'IceSideQuest'
                            LevelQuest = 1
                            NameCheckQuest = 'Lab Subordinate'
                            CFrameMyMon = CFrame.new(-5782, 42, -4484)
                            VectorMon = Vector3.new(-5782, 42, -4484)
                            CFrameQuest = CFrame.new(-6060, 16, -4905)
                            VectorQuest = Vector3.new(-6060, 16, -4905)
                        end
                    else
                        Monster = 'Winter Warrior [Lv. 1050]'
                        NameQuest = 'SnowMountainQuest'
                        LevelQuest = 2
                        NameCheckQuest = 'Winter Warrior'
                        CFrameMyMon = CFrame.new(1157, 430, -5188)
                        VectorMon = Vector3.new(1157, 430, -5188)
                        CFrameQuest = CFrame.new(605, 402, -5371)
                        VectorQuest = Vector3.new(605, 402, -5371)
                    end
                else
                    Monster = 'Snow Trooper [Lv. 1000]'
                    NameQuest = 'SnowMountainQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Snow Trooper'
                    CFrameMyMon = CFrame.new(478, 402, -5362)
                    VectorMon = Vector3.new(478, 402, -5362)
                    CFrameQuest = CFrame.new(605, 402, -5371)
                    VectorQuest = Vector3.new(605, 402, -5371)
                end
            end
            if u77 then
                if p648 ~= 1 then
                    if p648 ~= 2 then
                        if p648 ~= 3 then
                            if p648 ~= 4 then
                                if p648 ~= 5 then
                                    if p648 ~= 6 then
                                        if p648 ~= 7 then
                                            if p648 ~= 8 then
                                                if p648 ~= 9 then
                                                    if p648 ~= 10 then
                                                        if p648 ~= 11 then
                                                            if p648 ~= 12 then
                                                                if p648 ~= 13 then
                                                                    if p648 ~= 14 then
                                                                        if p648 ~= 15 then
                                                                            if p648 ~= 16 then
                                                                                if p648 ~= 17 then
                                                                                    if p648 ~= 18 then
                                                                                        if p648 ~= 19 then
                                                                                            if p648 ~= 20 then
                                                                                                if p648 ~= 21 then
                                                                                                    if p648 ~= 22 then
                                                                                                        if p648 ~= 23 then
                                                                                                            if p648 ~= 24 then
                                                                                                                if p648 ~= 25 then
                                                                                                                    if p648 ~= 26 then
                                                                                                                        if p648 ~= 27 then
                                                                                                                            if p648 ~= 28 then
                                                                                                                                if p648 ~= 29 then
                                                                                                                                    if p648 ~= 30 then
                                                                                                                                        if p648 ~= 31 then
                                                                                                                                            if p648 ~= 32 then
                                                                                                                                                if p648 ~= 33 then
                                                                                                                                                    if p648 ~= 34 then
                                                                                                                                                        if p648 ~= 35 then
                                                                                                                                                            if p648 == 36 then
                                                                                                                                                                Monster = 'Isle Champion [Lv. 2525]'
                                                                                                                                                                NameQuest = 'TikiQuest2'
                                                                                                                                                                LevelQuest = 2
                                                                                                                                                                NameCheckQuest = 'Isle Champion'
                                                                                                                                                                CFrameMyMon = CFrame.new(-16743.2421875, 137.21322631835938, 1148.2789306640625)
                                                                                                                                                                CFrameQuest = CFrame.new(-16538.888671875, 55.68632888793945, 1051.730712890625)
                                                                                                                                                            end
                                                                                                                                                        else
                                                                                                                                                            Monster = 'Sun-kissed Warrior [Lv. 2500]'
                                                                                                                                                            NameQuest = 'TikiQuest2'
                                                                                                                                                            LevelQuest = 1
                                                                                                                                                            NameCheckQuest = 'kissed Warrior'
                                                                                                                                                            CFrameMyMon = CFrame.new(-16277.009765625, 68.78734588623047, 1041.3009033203125)
                                                                                                                                                            CFrameQuest = CFrame.new(-16538.888671875, 55.68632888793945, 1051.730712890625)
                                                                                                                                                        end
                                                                                                                                                    else
                                                                                                                                                        Monster = 'Island Boy [Lv. 2475]'
                                                                                                                                                        NameQuest = 'TikiQuest1'
                                                                                                                                                        LevelQuest = 2
                                                                                                                                                        NameCheckQuest = 'Island Boy'
                                                                                                                                                        CFrameMyMon = CFrame.new(-16749.416015625, 125.9124755859375, -272.1277770996094)
                                                                                                                                                        CFrameQuest = CFrame.new(-16545.927734375, 55.68635559082031, -173.01036071777344)
                                                                                                                                                    end
                                                                                                                                                else
                                                                                                                                                    Monster = 'Isle Outlaw [Lv. 2450]'
                                                                                                                                                    NameQuest = 'TikiQuest1'
                                                                                                                                                    LevelQuest = 1
                                                                                                                                                    NameCheckQuest = 'Isle Outlaw'
                                                                                                                                                    CFrameMyMon = CFrame.new(-16277.9599609375, 94.06755828857422, -168.73194885253906)
                                                                                                                                                    CFrameQuest = CFrame.new(-16545.927734375, 55.68635559082031, -173.01036071777344)
                                                                                                                                                end
                                                                                                                                            else
                                                                                                                                                Monster = 'Snow Demon [Lv. 2425]'
                                                                                                                                                NameQuest = 'CandyQuest1'
                                                                                                                                                LevelQuest = 2
                                                                                                                                                NameCheckQuest = 'Snow Demon'
                                                                                                                                                CFrameMyMon = CFrame.new(-844.35546875, 138.32464599609375, -14496.455078125)
                                                                                                                                                CFrameQuest = CFrame.new(-1147.6552734375, 17.82676887512207, -14447.7099609375)
                                                                                                                                            end
                                                                                                                                        else
                                                                                                                                            Monster = 'Candy Pirate [Lv. 2400]'
                                                                                                                                            NameQuest = 'CandyQuest1'
                                                                                                                                            LevelQuest = 1
                                                                                                                                            NameCheckQuest = 'Candy Pirate'
                                                                                                                                            CFrameMyMon = CFrame.new(-1271.6993408203125, 139.93331909179688, -14354.8515625)
                                                                                                                                            CFrameQuest = CFrame.new(-1147.6552734375, 17.82676887512207, -14447.7099609375)
                                                                                                                                        end
                                                                                                                                    else
                                                                                                                                        Monster = 'Candy Rebel [Lv. 2375]'
                                                                                                                                        NameQuest = 'ChocQuest2'
                                                                                                                                        LevelQuest = 2
                                                                                                                                        NameCheckQuest = 'Candy Rebel'
                                                                                                                                        CFrameMyMon = CFrame.new(134.3748016357422, 77.21473693847656, -12882.1650390625)
                                                                                                                                        CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
                                                                                                                                    end
                                                                                                                                else
                                                                                                                                    Monster = 'Sweet Thief [Lv. 2350]'
                                                                                                                                    NameQuest = 'ChocQuest2'
                                                                                                                                    LevelQuest = 1
                                                                                                                                    NameCheckQuest = 'Sweet Thief'
                                                                                                                                    CFrameMyMon = CFrame.new(71.89511108398438, 77.21478271484375, -12632.435546875)
                                                                                                                                    CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
                                                                                                                                end
                                                                                                                            else
                                                                                                                                Monster = 'Chocolate Bar Battler [Lv. 2325]'
                                                                                                                                NameQuest = 'ChocQuest1'
                                                                                                                                LevelQuest = 2
                                                                                                                                NameCheckQuest = 'Chocolate Bar Battler'
                                                                                                                                CFrameMyMon = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
                                                                                                                                CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
                                                                                                                            end
                                                                                                                        else
                                                                                                                            Monster = 'Cocoa Warrior [Lv. 2300]'
                                                                                                                            NameQuest = 'ChocQuest1'
                                                                                                                            LevelQuest = 1
                                                                                                                            NameCheckQuest = 'Cocoa Warrior'
                                                                                                                            CFrameMyMon = CFrame.new(79.4172134399414, 73.42101287841797, -12310.0205078125)
                                                                                                                            CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
                                                                                                                        end
                                                                                                                    else
                                                                                                                        Monster = 'Head Baker [Lv. 2275]'
                                                                                                                        NameQuest = 'CakeQuest2'
                                                                                                                        LevelQuest = 2
                                                                                                                        NameCheckQuest = 'Head Baker'
                                                                                                                        CFrameMyMon = CFrame.new(-1926, 88, -12850)
                                                                                                                        VectorMon = CFrame.new(-1870, 38, -12938)
                                                                                                                        CFrameQuest = CFrame.new(-1926, 38, -12850)
                                                                                                                        VectorQuest = Vector3.new(-1926, 38, -12850)
                                                                                                                    end
                                                                                                                else
                                                                                                                    Monster = 'Baking Staff [Lv. 2250]'
                                                                                                                    NameQuest = 'CakeQuest2'
                                                                                                                    LevelQuest = 1
                                                                                                                    NameCheckQuest = 'Baking Staff'
                                                                                                                    CFrameMyMon = CFrame.new(-1870, 38, -12938)
                                                                                                                    VectorMon = Vector3.new(-1870, 38, -12938)
                                                                                                                    CFrameQuest = CFrame.new(-1926, 38, -12850)
                                                                                                                    VectorQuest = Vector3.new(-1926, 38, -12850)
                                                                                                                end
                                                                                                            else
                                                                                                                Monster = 'Cake Guard [Lv. 2225]'
                                                                                                                NameQuest = 'CakeQuest1'
                                                                                                                LevelQuest = 2
                                                                                                                NameCheckQuest = 'Cake Guard'
                                                                                                                CFrameMyMon = CFrame.new(-1651, 38, -12308)
                                                                                                                VectorMon = Vector3.new(-1651, 38, -12308)
                                                                                                                CFrameQuest = CFrame.new(-2020, 38, -12025)
                                                                                                                VectorQuest = Vector3.new(-2020, 38, -12025)
                                                                                                            end
                                                                                                        else
                                                                                                            Monster = 'Cookie Crafter [Lv. 2200]'
                                                                                                            NameQuest = 'CakeQuest1'
                                                                                                            LevelQuest = 1
                                                                                                            NameCheckQuest = 'Cookie Crafter'
                                                                                                            CFrameMyMon = CFrame.new(-2365, 38, -12099)
                                                                                                            VectorMon = Vector3.new(-2365, 38, -12099)
                                                                                                            CFrameQuest = CFrame.new(-2020, 38, -12025)
                                                                                                            VectorQuest = Vector3.new(-2020, 38, -12025)
                                                                                                        end
                                                                                                    else
                                                                                                        Monster = 'Ice Cream Commander [Lv. 2150]'
                                                                                                        NameQuest = 'IceCreamIslandQuest'
                                                                                                        LevelQuest = 2
                                                                                                        NameCheckQuest = 'Ice Cream Commander'
                                                                                                        CFrameMyMon = CFrame.new(-641, 127, -11062)
                                                                                                        VectorMon = Vector3.new(-641, 127, -11062)
                                                                                                        CFrameQuest = CFrame.new(-822, 66, -10965)
                                                                                                        VectorQuest = Vector3.new(-822, 66, -10965)
                                                                                                    end
                                                                                                else
                                                                                                    Monster = 'Ice Cream Chef [Lv. 2125]'
                                                                                                    NameQuest = 'IceCreamIslandQuest'
                                                                                                    LevelQuest = 1
                                                                                                    NameCheckQuest = 'Ice Cream Chef'
                                                                                                    CFrameMyMon = CFrame.new(-641, 127, -11062)
                                                                                                    VectorMon = Vector3.new(-641, 127, -11062)
                                                                                                    CFrameQuest = CFrame.new(-822, 66, -10965)
                                                                                                    VectorQuest = Vector3.new(-822, 66, -10965)
                                                                                                end
                                                                                            else
                                                                                                Monster = 'Peanut President [Lv. 2100]'
                                                                                                NameQuest = 'NutsIslandQuest'
                                                                                                LevelQuest = 2
                                                                                                NameCheckQuest = 'Peanut President'
                                                                                                CFrameMyMon = CFrame.new(-2124, 123, -10435)
                                                                                                VectorMon = Vector3.new(-2124, 123, -10435)
                                                                                                CFrameQuest = CFrame.new(-2104, 38, -10192)
                                                                                                VectorQuest = Vector3.new(-2104, 38, -10192)
                                                                                            end
                                                                                        else
                                                                                            Monster = 'Peanut Scout [Lv. 2075]'
                                                                                            NameQuest = 'NutsIslandQuest'
                                                                                            LevelQuest = 1
                                                                                            NameCheckQuest = 'Peanut Scout'
                                                                                            CFrameMyMon = CFrame.new(-2124, 123, -10435)
                                                                                            VectorMon = Vector3.new(-2124, 123, -10435)
                                                                                            CFrameQuest = CFrame.new(-2104, 38, -10192)
                                                                                            VectorQuest = Vector3.new(-2104, 38, -10192)
                                                                                        end
                                                                                    else
                                                                                        Monster = 'Posessed Mummy [Lv. 2050]'
                                                                                        NameQuest = 'HauntedQuest2'
                                                                                        LevelQuest = 2
                                                                                        NameCheckQuest = 'Posessed Mummy'
                                                                                        CFrameMyMon = CFrame.new(-9577, 6, 6223)
                                                                                        VectorMon = Vector3.new(-9577, 6, 6223)
                                                                                        CFrameQuest = CFrame.new(-9513, 172, 6079)
                                                                                        VectorQuest = Vector3.new(-9513, 172, 6079)
                                                                                    end
                                                                                else
                                                                                    Monster = 'Demonic Soul [Lv. 2025]'
                                                                                    NameQuest = 'HauntedQuest2'
                                                                                    LevelQuest = 1
                                                                                    NameCheckQuest = 'Demonic Soul'
                                                                                    CFrameMyMon = CFrame.new(-9507, 172, 6158)
                                                                                    VectorMon = Vector3.new(-9506, 172, 6158)
                                                                                    CFrameQuest = CFrame.new(-9513, 172, 6079)
                                                                                    VectorQuest = Vector3.new(-9513, 172, 6079)
                                                                                end
                                                                            else
                                                                                Monster = 'Living Zombie [Lv. 2000]'
                                                                                NameQuest = 'HauntedQuest1'
                                                                                LevelQuest = 2
                                                                                NameCheckQuest = 'Living Zombie'
                                                                                CFrameMyMon = CFrame.new(-10144, 140, 5932)
                                                                                VectorMon = Vector3.new(-10144, 140, 5932)
                                                                                CFrameQuest = CFrame.new(-9482, 142, 5567)
                                                                                VectorQuest = Vector3.new(-9482, 142, 5567)
                                                                            end
                                                                        else
                                                                            Monster = 'Reborn Skeleton [Lv. 1975]'
                                                                            NameQuest = 'HauntedQuest1'
                                                                            LevelQuest = 1
                                                                            NameCheckQuest = 'Reborn Skeleton'
                                                                            CFrameMyMon = CFrame.new(-8760, 142, 6039)
                                                                            VectorMon = Vector3.new(-8760, 142, 6039)
                                                                            CFrameQuest = CFrame.new(-9482, 142, 5567)
                                                                            VectorQuest = Vector3.new(-9482, 142, 5567)
                                                                        end
                                                                    else
                                                                        Monster = 'Musketeer Pirate [Lv. 1925]'
                                                                        NameQuest = 'DeepForestIsland2'
                                                                        LevelQuest = 2
                                                                        NameCheckQuest = 'Musketeer Pirate'
                                                                        CFrameMyMon = CFrame.new(-13286, 392, -9769)
                                                                        VectorMon = Vector3.new(-13286, 392, -9768)
                                                                        CFrameQuest = CFrame.new(-12684, 391, -9902)
                                                                        VectorQuest = Vector3.new(-12684, 391, -9902)
                                                                    end
                                                                else
                                                                    Monster = 'Jungle Pirate [Lv. 1900]'
                                                                    NameQuest = 'DeepForestIsland2'
                                                                    LevelQuest = 1
                                                                    NameCheckQuest = 'Jungle Pirate'
                                                                    CFrameMyMon = CFrame.new(-12107, 332, -10549)
                                                                    VectorMon = Vector3.new(-12106, 332, -10549)
                                                                    CFrameQuest = CFrame.new(-12684, 391, -9902)
                                                                    VectorQuest = Vector3.new(-12684, 391, -9902)
                                                                end
                                                            else
                                                                Monster = 'Mythological Pirate [Lv. 1850]'
                                                                NameQuest = 'DeepForestIsland'
                                                                LevelQuest = 2
                                                                NameCheckQuest = 'Mythological Pirate'
                                                                CFrameMyMon = CFrame.new(-13545, 470, -6917)
                                                                VectorMon = Vector3.new(-13545, 470, -6917)
                                                                CFrameQuest = CFrame.new(-13232, 333, -7627)
                                                                VectorQuest = Vector3.new(-13232, 333, -7627)
                                                            end
                                                        else
                                                            Monster = 'Forest Pirate [Lv. 1825]'
                                                            NameQuest = 'DeepForestIsland'
                                                            LevelQuest = 1
                                                            NameCheckQuest = 'Forest Pirate'
                                                            CFrameMyMon = CFrame.new(-13479, 333, -7905)
                                                            VectorMon = Vector3.new(-13479, 333, -7905)
                                                            CFrameQuest = CFrame.new(-13232, 333, -7627)
                                                            VectorQuest = Vector3.new(-13232, 333, -7627)
                                                        end
                                                    else
                                                        Monster = 'Fishman Captain [Lv. 1800]'
                                                        NameQuest = 'DeepForestIsland3'
                                                        LevelQuest = 2
                                                        NameCheckQuest = 'Fishman Captain'
                                                        CFrameMyMon = CFrame.new(-10993, 332, -8940)
                                                        VectorMon = Vector3.new(-10993, 332, -8940)
                                                        CFrameQuest = CFrame.new(-10584, 332, -8758)
                                                        VectorQuest = Vector3.new(-10584, 332, -8758)
                                                    end
                                                else
                                                    Monster = 'Fishman Raider [Lv. 1775]'
                                                    NameQuest = 'DeepForestIsland3'
                                                    LevelQuest = 1
                                                    NameCheckQuest = 'Fishman Raider'
                                                    CFrameMyMon = CFrame.new(-10560, 332, -8466)
                                                    VectorMon = Vector3.new(-10560, 332, -8466)
                                                    CFrameQuest = CFrame.new(-10584, 332, -8758)
                                                    VectorQuest = Vector3.new(-10584, 332, -8758)
                                                end
                                            else
                                                Monster = 'Marine Rear Admiral [Lv. 1725]'
                                                NameQuest = 'MarineTreeIsland'
                                                LevelQuest = 2
                                                NameCheckQuest = 'Marine Rear Admiral'
                                                CFrameMyMon = CFrame.new(3671, 161, -6932)
                                                VectorMon = Vector3.new(3671, 161, -6932)
                                                CFrameQuest = CFrame.new(2180, 29, -6737)
                                                VectorQuest = Vector3.new(2180, 29, -6737)
                                            end
                                        else
                                            Monster = 'Marine Commodore [Lv. 1700]'
                                            NameQuest = 'MarineTreeIsland'
                                            LevelQuest = 1
                                            NameCheckQuest = 'Marine Commodore'
                                            CFrameMyMon = CFrame.new(2447, 73, -7470)
                                            VectorMon = Vector3.new(2447, 73, -7470)
                                            CFrameQuest = CFrame.new(2180, 29, -6737)
                                            VectorQuest = Vector3.new(2180, 29, -6737)
                                        end
                                    else
                                        Monster = 'Giant Islander [Lv. 1650]'
                                        NameQuest = 'AmazonQuest2'
                                        LevelQuest = 2
                                        NameCheckQuest = 'Giant Islanders'
                                        CFrameMyMon = CFrame.new(4951, 602, -68)
                                        VectorMon = Vector3.new(4951, 602, -68)
                                        CFrameQuest = CFrame.new(5443, 602, 751)
                                        VectorQuest = Vector3.new(5443, 602, 751)
                                    end
                                else
                                    Monster = 'Female Islander [Lv. 1625]'
                                    NameQuest = 'AmazonQuest2'
                                    LevelQuest = 1
                                    NameCheckQuest = 'Female'
                                    CFrameMyMon = CFrame.new(5308, 819, 1047)
                                    VectorMon = Vector3.new(5308, 819, 1047)
                                    CFrameQuest = CFrame.new(5443, 602, 751)
                                    VectorQuest = Vector3.new(5443, 602, 751)
                                end
                            else
                                Monster = 'Dragon Crew Archer [Lv. 1600]'
                                NameQuest = 'AmazonQuest'
                                LevelQuest = 2
                                NameCheckQuest = 'Archer'
                                CFrameMyMon = CFrame.new(6594, 383, 139)
                                VectorMon = Vector3.new(6594, 383, 139)
                                CFrameQuest = CFrame.new(5835, 52, -1105)
                                VectorQuest = Vector3.new(5835, 52, -1105)
                            end
                        else
                            Monster = 'Dragon Crew Warrior [Lv. 1575]'
                            NameQuest = 'AmazonQuest'
                            LevelQuest = 1
                            NameCheckQuest = 'Warrior'
                            CFrameMyMon = CFrame.new(6339, 52, -1213)
                            VectorMon = Vector3.new(6338, 52, -1213)
                            CFrameQuest = CFrame.new(5835, 52, -1105)
                            VectorQuest = Vector3.new(5835, 52, -1105)
                        end
                    else
                        Monster = 'Pistol Billionaire [Lv. 1525]'
                        NameQuest = 'PiratePortQuest'
                        LevelQuest = 2
                        NameCheckQuest = 'Pistol'
                        CFrameMyMon = CFrame.new(-469, 74, 5904)
                        VectorMon = Vector3.new(-469, 74, 5904)
                        CFrameQuest = CFrame.new(-288, 44, 5576)
                        VectorQuest = Vector3.new(-288, 44, 5576)
                    end
                else
                    Monster = 'Pirate Millionaire [Lv. 1500]'
                    NameQuest = 'PiratePortQuest'
                    LevelQuest = 1
                    NameCheckQuest = 'Pirate'
                    CFrameMyMon = CFrame.new(-373, 75, 5550)
                    VectorMon = Vector3.new(-373, 75, 5550)
                    CFrameQuest = CFrame.new(-288, 44, 5576)
                    VectorQuest = Vector3.new(-288, 44, 5576)
                end
            end

            CFrameMon = CheckEnemySpawn(Monster) or CFrameMyMon
        end)

        function CheckQuestBoss(p649)
            local _Value2 = game.Players.LocalPlayer.Data.Level.Value

            if u75 then
                if 20 <= _Value2 and (p649 == 'JungleQuest' and havemob('The Gorilla King [Lv. 25] [Boss]')) then
                    Bosses = 'The Gorilla King [Lv. 25] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'King'
                    CFrameBoss = CFrame.new(-1196.4288330078125, 6.791248798370361, -448.4755554199219)
                elseif 55 <= _Value2 and (p649 == 'BuggyQuest1' and havemob('Bobby [Lv. 55] [Boss]')) then
                    Bosses = 'Bobby [Lv. 55] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Bobby'
                    CFrameBoss = CFrame.new(-1097.8865966796875, 27.307741165161133, 4051.182373046875)
                elseif 105 <= _Value2 and (p649 == 'SnowQuest' and havemob('Yeti [Lv. 110] [Boss]')) then
                    Bosses = 'Yeti [Lv. 110] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Yeti'
                    CFrameBoss = CFrame.new(1202.99462890625, 143.6376495361328, -1550.9326171875)
                elseif 130 <= _Value2 and (p649 == 'MarineQuest2' and havemob('Vice Admiral [Lv. 130] [Boss]')) then
                    Bosses = 'Vice Admiral [Lv. 130] [Boss]'
                    LevelQuestBoss = 2
                    NameCheckQuestBoss = 'Vice'
                    CFrameBoss = CFrame.new(-5087.49267578125, 98.71009826660156, 4406.0498046875)
                elseif 220 <= _Value2 and (p649 == 'PrisonerQuest' and havemob('Warden [Lv. 220] [Boss]')) then
                    Bosses = 'Warden [Lv. 220] [Boss]'
                    LevelQuestBoss = 1
                    NameCheckQuestBoss = 't Warden'
                    NameQuest = 'ImpelQuest'
                    CFrameQuest = CFrame.new(5190.45703125, 2.5952436923980713, 688.2589111328125)
                    CFrameBoss = CFrame.new(5184.12744140625, 57.404136657714844, 829.398681640625)
                elseif 230 <= _Value2 and (p649 == 'PrisonerQuest' and havemob('Chief Warden [Lv. 230] [Boss]')) then
                    Bosses = 'Chief Warden [Lv. 230] [Boss]'
                    LevelQuestBoss = 2
                    NameCheckQuestBoss = 'Chief'
                    NameQuest = 'ImpelQuest'
                    CFrameQuest = CFrame.new(5190.45703125, 2.5952436923980713, 688.2589111328125)
                    CFrameBoss = CFrame.new(5184.12744140625, 57.404136657714844, 829.398681640625)
                elseif 230 <= _Value2 and (p649 == 'PrisonerQuest' and havemob('Swan [Lv. 240] [Boss]')) then
                    Bosses = 'Swan [Lv. 240] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Swan'
                    NameQuest = 'ImpelQuest'
                    CFrameQuest = CFrame.new(5190.45703125, 2.5952436923980713, 688.2589111328125)
                    CFrameBoss = CFrame.new(5184.12744140625, 57.404136657714844, 829.398681640625)
                elseif 350 <= _Value2 and (p649 == 'MagmaQuest' and havemob('Magma Admiral [Lv. 350] [Boss]')) then
                    Bosses = 'Magma Admiral [Lv. 350] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Admiral'
                    CFrameBoss = CFrame.new(-5682.41064453125, 16.40520668029785, 8751.5849609375)
                elseif 425 <= _Value2 and (p649 == 'FishmanQuest' and havemob('Fishman Lord [Lv. 425] [Boss]')) then
                    Bosses = 'Fishman Lord [Lv. 425] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Lord'
                    CFrameBoss = CFrame.new(61347.0078125, 30.053680419921875, 1125.32177734375)
                elseif 500 <= _Value2 and (p649 == 'SkyExp1Quest' and havemob('Wysper [Lv. 500] [Boss]')) then
                    Bosses = 'Wysper [Lv. 500] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Wysper'
                    CFrameBoss = CFrame.new(-7811.53271484375, 5585.1279296875, -652.8221435546875)
                elseif 575 <= _Value2 and (p649 == 'SkyExp2Quest' and havemob('Thunder God [Lv. 575] [Boss]')) then
                    Bosses = 'Thunder God [Lv. 575] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Thunder'
                    CFrameBoss = CFrame.new(-7795.9287109375, 5605.951171875, -2231.444580078125)
                elseif 675 <= _Value2 and (p649 == 'FountainQuest' and havemob('Cyborg [Lv. 675] [Boss]')) then
                    Bosses = 'Cyborg [Lv. 675] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Cyborg'
                    CFrameBoss = CFrame.new(6026.85498046875, 56.75627136230469, 3911.870849609375)
                else
                    Bosses = ''
                end
            elseif u76 then
                if 750 <= _Value2 and (p649 == 'Area1Quest' and havemob('Diamond [Lv. 750] [Boss]')) then
                    Bosses = 'Diamond [Lv. 750] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Diamond'
                    CFrameBoss = CFrame.new(-1768.1483154296875, 315.549560546875, -61.178192138671875)
                elseif 850 <= _Value2 and (p649 == 'Area2Quest' and havemob('Jeremy [Lv. 850] [Boss]')) then
                    Bosses = 'Jeremy [Lv. 850] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Jeremy'
                    CFrameBoss = CFrame.new(2035.4229736328125, 447.9889221191406, 712.2064819335938)
                elseif 925 <= _Value2 and (p649 == 'MarineQuest3' and havemob('Fajita [Lv. 925] [Boss]')) then
                    Bosses = 'Fajita [Lv. 925] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Fajita'
                    CFrameBoss = CFrame.new(-2123.315673828125, 89.35710144042969, -4079.322021484375)
                elseif 1150 <= _Value2 and (p649 == 'IceSideQuest' and havemob('Smoke Admiral [Lv. 1150] [Boss]')) then
                    Bosses = 'Smoke Admiral [Lv. 1150] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Smoke Admiral'
                    CFrameBoss = CFrame.new(-5106.25146484375, 22.789506912231445, -5341.25146484375)
                elseif 1400 <= _Value2 and (p649 == 'FrostQuest' and havemob('Awakened Ice Admiral [Lv. 1400] [Boss]')) then
                    Bosses = 'Awakened Ice Admiral [Lv. 1400] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Awakened Ice Admiral'
                    CFrameBoss = CFrame.new(6407.33935546875, 339.2467041015625, -6892.52099609375)
                elseif 1475 <= _Value2 and (p649 == 'ForgottenQuest' and havemob('Tide Keeper [Lv. 1475] [Boss]')) then
                    Bosses = 'Tide Keeper [Lv. 1475] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Tide Keeper'
                    CFrameBoss = CFrame.new(-3570.1865234375, 123.32894897460938, -11555.9072265625)
                else
                    Bosses = ''
                end
            elseif u77 then
                if 1550 <= _Value2 and (p649 == 'PiratePortQuest' and havemob('Stone [Lv. 1550] [Boss]')) then
                    Bosses = 'Stone [Lv. 1550] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Stone'
                    CFrameBoss = CFrame.new(-1141.4222412109375, 96.33948516845703, 6993.21337890625)
                elseif 1675 <= _Value2 and (p649 == 'AmazonQuest2' and havemob('Island Empress [Lv. 1675] [Boss]')) then
                    Bosses = 'Island Empress [Lv. 1675] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Island Empress'
                    CFrameBoss = CFrame.new(5567.677734375, 650.8583374023438, 195.727783203125)
                elseif 1750 <= _Value2 and (p649 == 'MarineTreeIsland' and havemob('Kilo Admiral [Lv. 1750] [Boss]')) then
                    Bosses = 'Kilo Admiral [Lv. 1750] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Kilo Admiral'
                    CFrameBoss = CFrame.new(2915.359375, 455.9102783203125, -7375.900390625)
                elseif 1875 <= _Value2 and (p649 == 'DeepForestIsland' and havemob('Captain Elephant [Lv. 1875] [Boss]')) then
                    Bosses = 'Captain Elephant [Lv. 1875] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Elephant'
                    CFrameBoss = CFrame.new(-13351.3642578125, 404.9483642578125, -8570.650390625)
                elseif 1950 <= _Value2 and (p649 == 'DeepForestIsland2' and havemob('Beautiful Pirate [Lv. 1950] [Boss]')) then
                    Bosses = 'Beautiful Pirate [Lv. 1950] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Beautiful'
                    CFrameBoss = CFrame.new(5314.58203125, 21.594484329223633, -125.94227600097656)
                elseif 2175 <= _Value2 and (p649 == 'IceCreamIslandQuest' and havemob('Cake Queen [Lv. 2175] [Boss]')) then
                    Bosses = 'Cake Queen [Lv. 2175] [Boss]'
                    LevelQuestBoss = 3
                    NameCheckQuestBoss = 'Cake Queen'
                    CFrameBoss = CFrame.new(-717.3067016601563, 380.62359619140625, -11006.7158203125)
                else
                    Bosses = ''
                end
            end
        end

        CheckGoodMob = LPH_JIT_MAX(function(p651, p652)
            local _Magnitude7 = (p651.Position - p652).Magnitude
            local v654, v655, v656 = pairs(u79)
            local v657 = false
            local v658 = nil

            while true do
                local v659

                v656, v659 = v654(v655, v656)

                if v656 == nil then
                    break
                end

                local v660 = v659 + Vector3.new(1, 60, 0)
                local _Magnitude8 = (v660 - p651.Position).Magnitude

                if _Magnitude8 < _Magnitude7 then
                    v658 = v660
                    _Magnitude7 = _Magnitude8
                    v657 = true
                end
            end

            return v657, v658
        end)

        CheckQuest()
        LPH_NO_VIRTUALIZE(function()
            task.spawn(function()
                while true do
                    pcall(function()
                        local v662, v663, v664 = pairs(game:GetService('Workspace')._WorldOrigin:FindFirstChild('EnemySpawns'):GetChildren())

                        while true do
                            local v665

                            v664, v665 = v662(v663, v664)

                            if v664 == nil then
                                break
                            end
                            if not tablefoundforu(u29, v665.CFrame) then
                                table.insert(u29, {
                                    Name = v665.Name,
                                    CFrame = v665.CFrame,
                                })
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end)()

        if not isfile('BF_Kick_Log.txt') then
            writefile('BF_Kick_Log.txt', '-- Saturn Kick Log --')
        end
        if u75 then
            AutoPole = getgenv().Configs.FirstSea.AutoPole
            AutoSaber = getgenv().Configs.FirstSea.AutoSaber
            AutoSea2 = getgenv().Configs.FirstSea.AutoSecondSea
        elseif u76 then
            alliesfruit = getgenv().Configs.SecondSea.AlliesFruit
            AutoRengoku = getgenv().Configs.SecondSea.AutoRengoku
            AutoBartilo = getgenv().Configs.SecondSea.AutoBartiloQuest
            AutoCursedCaptain = getgenv().Configs.SecondSea.AutoCursedCaptain
            AutoQuestFlower = getgenv().Configs.SecondSea.AutoQuestFlower
            AutoV3Race = getgenv().Configs.SecondSea.AutoRaceV3
            AutoDarkbeard = getgenv().Configs.SecondSea.AutoDarkbeard
            AutoFactory = getgenv().Configs.SecondSea.AutoFactory
            AutoSoulGuitar = getgenv().Configs.SecondSea.AutoSoulGuitar
            AutoSea3 = getgenv().Configs.SecondSea.AutoThirdSea
        elseif u77 then
            AutoHallowScythe = getgenv().Configs.ThirdSea.AutoHallowScythe
            AutoBuddySword = getgenv().Configs.ThirdSea.AutoBuddySword
            AutoDoughKing = getgenv().Configs.ThirdSea.AutoDoughKing
            AutoSpikeyTrident = getgenv().Configs.ThirdSea.AutoSpikeyTrident
            AutoTushita = getgenv().Configs.ThirdSea.AutoTushita
            AutoEliteHunter = getgenv().Configs.ThirdSea.AutoEliteHunter
            AutoRipIndra = getgenv().Configs.ThirdSea.AutoDarkDagger
            AutoYama = getgenv().Configs.ThirdSea.AutoYama
            AutoCanvander = getgenv().Configs.ThirdSea.AutoCanvander
            AutoSoulGuitar = getgenv().Configs.ThirdSea.AutoSoulGuitar
            SkipGetItemSoulInSea2 = getgenv().Configs.ThirdSea.SkipGetItemGuitar
            AutoRainbowHaki = getgenv().Configs.ThirdSea.AutoRainbowHaki
            AutoCDK = getgenv().Configs.ThirdSea.AutoCursedDualKatana
        end

        StartKaiTun = getgenv().Configs.Main.Start
        SkipFarmLevel = getgenv().Configs.Main.SkipFarm
        HopCantKill = getgenv().Configs.Main.HopIfCantKill
        AutoFastMode = getgenv().Configs.Fps.FpsBoost
        BlockAllHop = getgenv().Configs.Main.BlockAllHop
        SelectRedeemCodeLevel = getgenv().Configs.Settings.SelectRedeemCodeLevel or u50
        RateFruitRaids = getgenv().Configs.Settings.SelectRateFruitRaid or 5000001
        LimitRaidsFrag = getgenv().Configs.Settings.LimitFragmentsRaids or 100000
        AutoGodhuman = getgenv().Configs.FightingStyle.AutoGodHuman
        AutoSuperhuman = getgenv().Configs.FightingStyle.AutoSuperhuman
        AutoDeathStep = getgenv().Configs.FightingStyle.AutoDeathStep
        AutoSharkmanKarate = getgenv().Configs.FightingStyle.AutoSharkmanKarate
        AutoElectricClaw = getgenv().Configs.FightingStyle.AutoElectricClaw
        AutoDargonTalon = getgenv().Configs.FightingStyle.AutoDargonTalon
        AutoFarmMasteryDevilFruit = getgenv().Configs.Mastery.AutoDFMastery
        AutoFarmMasterySword = getgenv().Configs.Mastery.AutoSwordMastery
        SwordFarmRarity = getgenv().Configs.Mastery.SelectRaritySword
        SelectMainDevilFruitSniper = getgenv().Configs.FruitsSettings.SelectMainDF
        SelectSubDevilFruitSinper = getgenv().Configs.FruitsSettings.SelectSubDF
        EatFruitInventroy = getgenv().Configs.FruitsSettings.AllowEatDFInventory
        StartSniper = getgenv().Configs.FruitsSettings.StartSniper
        SelectLockFPS = getgenv().Configs.Fps.LockFPS or 25
        LockFPSNow = getgenv().Configs.Fps.LockFPSNow
        WhiteScreen = getgenv().Configs.Fps.WhiteScreen

        function HaveThisFruitSell(p666)
            local v667, v668, v669 = pairs(Com('F_', 'GetFruits', false))

            while true do
                local v670

                v669, v670 = v667(v668, v669)

                if v669 == nil then
                    break
                end
                if v670.OnSale == true and tablefound(p666, v670.Name) then
                    return 'OneSell', v670.Name
                end
            end

            local v671, v672, v673 = pairs(Com('F_', 'getInventory'))

            while true do
                local v674

                v673, v674 = v671(v672, v673)

                if v673 == nil then
                    break
                end
                if tablefound(p666, v674.Name) then
                    return 'Inven', v674.Name
                end
            end

            local v675, v676, v677 = pairs(p666)

            while true do
                local v678

                v677, v678 = v675(v676, v677)

                if v677 == nil then
                    break
                end

                local v679 = tostring(v678:split('-')[2]) .. ' Fruit'

                if inmyself(v679) then
                    return 'Inmy', v679
                end
            end

            return false
        end

        if StartSniper == true then
            StopRaidsPls = false
        end

        spawn(function()
            while task.wait(1) and StartSniper do
                DieWait()

                local _Value3 = game:GetService('Players').LocalPlayer:WaitForChild('Data').DevilFruit.Value
                local v681, v682 = HaveThisFruitSell(SelectMainDevilFruitSniper)
                local v683, v684 = HaveThisFruitSell(SelectSubDevilFruitSinper)

                if tablefound(SelectMainDevilFruitSniper, _Value3) then
                    StartSniper = false

                    break
                end
                if v681 then
                    if v681 == 'Inmy' then
                        local v685 = inmyself(v682) and inmyself(v682)

                        if v685 then
                            StartKaiTun = false

                            EquipWeapon(v682)

                            local _Eat = v685.EatRemote:InvokeServer('Eat')

                            StartKaiTun = true

                            if _Eat == true then
                                task.wait(4)

                                if tablefound(SelectMainDevilFruitSniper, _Value3) then
                                    StopRaidsPls = false
                                    StartSniper = false

                                    break
                                end
                            end
                        end
                    elseif v681 == 'OneSell' then
                        Com('F_', 'PurchaseRawFruit', v682)
                    elseif v681 == 'Inven' then
                        StopRaidsPls = true

                        Com('F_', 'LoadFruit', v682)
                        task.wait(0.5)
                    end
                elseif tablefound(SelectSubDevilFruitSinper, _Value3) then
                    StopRaidsPls = false

                    task.wait(2)
                elseif v683 then
                    if v683 == 'Inmy' then
                        local v687 = inmyself(v684) and inmyself(v684)

                        if v687 then
                            StartKaiTun = false

                            EquipWeapon(v684)
                            v687.EatRemote:InvokeServer('Eat')

                            StartKaiTun = true

                            task.wait(3)

                            StopRaidsPls = false
                        end
                    elseif v683 == 'OneSell' then
                        Com('F_', 'PurchaseRawFruit', v684)
                    elseif v683 == 'Inven' then
                        StopRaidsPls = true

                        Com('F_', 'LoadFruit', v684)
                        task.wait(0.5)
                    end
                end
            end
        end)
        spawn(function()
            while task.wait() and getgenv().Configs.Webhook.StartWebhook do
                if getgenv().Configs.Webhook.WebhookMode ~= 'Send Every 10 min' then
                    local v688, v689 = pcall(function()
                        return game.Players.localPlayer.Data.Level.Value
                    end)

                    if v688 and u50 <= tonumber(v689) then
                        DataSend = u567:WebHookSend(getgenv().Configs.Webhook.WebhookURL)

                        if DataSend.StatusCode ~= 204 then
                            warn('Send Webhook Error')

                            getgenv().Configs.Webhook.StartWebhook = false

                            break
                        end
                        if getgenv().Configs.Webhook.WebhookMode ~= 'Send On Level Max And Every 10 min' then
                            getgenv().Configs.Webhook.StartWebhook = false

                            break
                        end

                        local _WebhookMode = getgenv().Configs.Webhook.WebhookMode
                        local v691 = 0

                        repeat
                            task.wait(1)

                            v691 = v691 + 1
                        until v691 >= 600 or (getgenv().Configs.Webhook.WebhookMode ~= _WebhookMode or not getgenv().Configs.Webhook.StartWebhook)

                        task.wait()
                    end
                else
                    DataSend = u567:WebHookSend(getgenv().Configs.Webhook.WebhookURL)

                    if DataSend.StatusCode ~= 204 then
                        warn('Send Webhook Error')

                        getgenv().Configs.Webhook.StartWebhook = false

                        break
                    end

                    local _WebhookMode2 = getgenv().Configs.Webhook.WebhookMode
                    local v693 = 0

                    repeat
                        task.wait(1)

                        v693 = v693 + 1
                    until v693 >= 600 or (getgenv().Configs.Webhook.WebhookMode ~= _WebhookMode2 or not getgenv().Configs.Webhook.StartWebhook)

                    task.wait()
                end
            end
        end)
        spawn(function()
            repeat
                task.wait()
            until LoadingScriptSuccess

            if LockFPSNow then
                setfpscap(SelectLockFPS)
            else
                setfpscap(200)
            end
        end)

        local _UserInputService = game:GetService('UserInputService')
        local _RunService = game:GetService('RunService')

        spawn(function()
            if WhiteScreen then
                _RunService:Set3dRenderingEnabled(false)
            else
                _RunService:Set3dRenderingEnabled(true)
            end

            _UserInputService.InputBegan:Connect(function(p696, p697)
                if not p697 then
                    if p696.KeyCode == Enum.KeyCode.L then
                        WhiteScreen = not WhiteScreen

                        _RunService:Set3dRenderingEnabled(not WhiteScreen)
                    end
                end
            end)
        end)

        function AutoKaiTunOldWorld(p698, p699, p700, _)
            if AutoPole and 200 <= p700 then
            end
            if AutoSaber and (200 <= p700 and game.Workspace.Map.Jungle.Final.Part.CanCollide == false) then
                local v701 = u541

                if not (string.find(v701:Update().Text, u548) and (game.ReplicatedStorage:FindFirstChild('Saber Expert [Lv. 200] [Boss]') or game.Workspace.Enemies:FindFirstChild('Saber Expert [Lv. 200] [Boss]'))) then
                end

                ShowDoingStatus('Kill Saber')

                if not game.Workspace.Enemies:FindFirstChild('Saber Expert [Lv. 200] [Boss]') then
                    if game.ReplicatedStorage:FindFirstChild('Saber Expert [Lv. 200] [Boss]') then
                        local v702 = CFrame.new(-1458.89502, 29.8870335, -50.633564)

                        if (v702.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if (v702.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                                if Questtween then
                                    Questtween:Stop()
                                end

                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v702
                            end
                        else
                            Questtween = toTarget(v702)
                        end

                        Com('F_', 'SetSpawnPoint')
                    end
                end

                local v703, v704, v705 = pairs(game.Workspace.Enemies:GetChildren())

                while true do
                    local v706

                    v705, v706 = v703(v704, v705)

                    if v705 == nil then
                    end
                    if not StartKaiTun or (v706.Name ~= 'Saber Expert [Lv. 200] [Boss]' or (not v706:FindFirstChild('HumanoidRootPart') or (not v706:FindFirstChild('Humanoid') or v706.Humanoid.Health <= 0))) then
                    end
                    if true then
                        task.wait()

                        if (v706.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if (v706.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                                if Farmtween then
                                    Farmtween:Stop()
                                end

                                EquipWeapon()

                                Usefastattack = true

                                if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                                    Com('F_', 'Buso')
                                end

                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v706.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                            end
                        else
                            Farmtween = toTarget(v706.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                        end
                    end
                    if StartKaiTun and (v706.Parent and v706.Humanoid.Health > 0) then
                    end

                    BuyAllHaki()

                    Usefastattack = false

                    pcall(RefreshStatus)
                end
            end
            if AutoSaber and (200 <= p700 and game.Workspace.Map.Jungle.Final.Part.CanCollide == true) then
            end
            if AutoSea2 and 700 <= p700 then
            end
            if SkipFarmLevel and (10 <= p700 and p700 <= 40) then
            end
            if SkipFarmLevel and (41 <= p700 and p700 <= 75) then
            end
            if (function()
                local v707, v708, v709 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v710

                    v709, v710 = v707(v708, v709)

                    if v709 == nil then
                        break
                    end
                    if v710:IsA('Tool') and string.find(v710.Name, 'Fruit') then
                        return true
                    end
                end

                return false
            end)() then
                local v711, v712, v713 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v714

                    v713, v714 = v711(v712, v713)

                    if v713 == nil then
                        break
                    end
                    if v714:IsA('Tool') and (string.find(v714.Name, 'Fruit') and StartKaiTun) then
                        if FruitTarget then
                            FruitTarget:Stop()
                        end

                        repeat
                            task.wait(0.1)

                            FruitTarget = toTarget(v714.Handle.CFrame)
                        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v714.Handle.Position).Magnitude <= 8 or not (StartKaiTun and v714.Parent)

                        task.wait(0.5)
                        StoreMyFruit()
                    end
                end
            end

            local v715, v716, v717 = pairs(game:GetService('Players'):GetChildren())
            local v718 = {}

            while true do
                local v719

                v717, v719 = v715(v716, v717)

                if v717 == nil then
                    break
                end
                if v719:FindFirstChild('Data') and (v719.Character and (v719 ~= game.Players.LocalPlayer and v719.Data.Level.Value >= 25)) and ((v719.Data.Level.Value or p700) >= p700 - 70 and (v719.Data.Level.Value or p700) <= p700 + 70) then
                    table.insert(v718, v719.Name)
                end
            end

            if not havesling and game.Players.LocalPlayer.Data.Beli.Value >= 5000 then
                Com('F_', 'BuyItem', 'Slingshot')
                task.wait(0.2)

                if #GetWeaponMastery('Slingshot') > 0 then
                    havesling = true
                end
            end
            if not (string.find(p698.Text, NameCheckQuest) or p699.Container.QuestReward.Title.Text:match('50,000,000 Exp.')) then
                Com('F_', 'AbandonQuest')
            end
            if p699.Visible == false then
                if u53 >= 30 and u27 == false then
                    u27 = true

                    task.delay(300, function()
                        u53 = 0
                        u27 = false
                    end)
                end
                if p700 < 40 or (not SkipFarmLevel or (#v718 == 0 or (u53 >= 30 or not havesling))) then
                    if HopCantKill and u53 >= 30 then
                        u171:NormalTeleport()

                        return
                    end
                else
                    if tostring(Com('F_', 'PlayerHunter')):find('We heard some') then
                        u53 = u53 + 1

                        return
                    end

                    task.wait(0.1)

                    if tostring(Com('F_', 'PlayerHunter')):find('We heard some') then
                        u53 = u53 + 1

                        return
                    end
                end

                Usefastattack = false
                StartMagnetFarmLevel = false

                if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest

                        task.wait(0.95)
                        Com('F_', 'StartQuest', NameQuest, LevelQuest)
                        Com('F_', 'SetSpawnPoint')
                    end
                else
                    Questtween = toTarget(CFrameQuest)
                end
            end
            if p699.Visible ~= true then
                return
            end
            if p699.Container.QuestReward.Title.Text:match('50,000,000 Exp.') then
                ShowDoingStatus('Skip Farm Level')

                local v720, v721, v722 = pairs(game:GetService('Players'):GetChildren())

                while true do
                    local u723

                    v722, u723 = v720(v721, v722)

                    if v722 == nil then
                        break
                    end
                    if u723:FindFirstChild('Data') and u723.Character and string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, (function()
                        return not u723 and 'NIL' or u723.Name
                    end)()) then
                        if u723.Data.Level.Value < 25 or ((u723.Data.Level.Value or p700) < p700 - 70 or (u723.Data.Level.Value or p700) > p700 + 70) then
                            UsefastattackPlayers = false

                            task.wait()
                            Com('F_', 'AbandonQuest')
                        elseif StartKaiTun and SkipFarmLevel and (u723.Name == p698.Text:split(' ')[2] and (u723.Character:FindFirstChild('HumanoidRootPart') and (u723.Character:FindFirstChild('Humanoid') and u723.Character.Humanoid.Health > 0))) then
                            while true do
                                task.wait()

                                if game:GetService('Players').LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                                    Com('F_', 'EnablePvp')
                                end
                                if u723.Character:FindFirstChild('HumanoidRootPart') and (u723.Character:FindFirstChild('Humanoid') and (u723.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150) then
                                    FarmtoTarget = toTarget(u723.Character.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                                elseif u723.Character:FindFirstChild('HumanoidRootPart') and (u723.Character:FindFirstChild('Humanoid') and (u723.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150) then
                                    if FarmtoTarget then
                                        FarmtoTarget:Stop()
                                    end
                                    if havesling and UsefastattackPlayers == false and (game:GetService('Players').LocalPlayer.PlayerGui.Main.InCombat.Visible == false and not inmyself('Slingshot')) then
                                        PositionSling = u723.Character.HumanoidRootPart.Position

                                        if not inmyself('Slingshot') then
                                            Com('F_', 'LoadItem', 'Slingshot')

                                            return
                                        end
                                        if game.Players.LocalPlayer.Backpack:FindFirstChild('Slingshot') then
                                            game.Players.LocalPlayer.Backpack:FindFirstChild('Slingshot').Parent = game.Players.LocalPlayer.Character
                                        end

                                        task.wait()
                                        _VirtualUser:CaptureController()
                                        _VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService('Workspace').Camera.CFrame)
                                    else
                                        EquipWeapon()
                                    end

                                    u723.Character.HumanoidRootPart.Size = Vector3.new(30, 30, 30)

                                    if UsefastattackPlayers ~= true then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = u723.Character.HumanoidRootPart.CFrame + u723.Character.HumanoidRootPart.CFrame.LookVector * -20
                                    else
                                        toAroundTarget(u723.Character.HumanoidRootPart.CFrame)
                                    end
                                    if u25 == false then
                                        u25 = true

                                        task.delay(2.5, function()
                                            EquipWeapon()
                                            task.wait()

                                            UsefastattackPlayers = true
                                            u25 = false
                                        end)
                                    end
                                    if (function()
                                        local v724, v725, v726 = pairs(game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('Notifications'):GetChildren())

                                        while true do
                                            local u727

                                            v726, u727 = v724(v725, v726)

                                            if v726 == nil then
                                                break
                                            end
                                            if u727.Name == 'NotificationTemplate' and string.lower(u727.Text):find('can') then
                                                pcall(function()
                                                    u727:Destroy()
                                                end)

                                                return true
                                            end
                                        end

                                        return false
                                    end)() then
                                        break
                                    end
                                end
                                if not (u723 or StartKaiTun) or (not string.find(game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, (function()
                                    return not u723 and 'NIL' or u723.Name
                                end)()) or (u723.Character.Humanoid.Health <= 0 or (not u723.Character or p699.Visible == false))) then
                                    break
                                end
                            end

                            UsefastattackPlayers = false

                            spawn(function()
                                task.wait(2.62)

                                UsefastattackPlayers = false
                            end)
                        end
                    end
                end
            end

            ShowDoingStatus('Auto Farm')

            if not game:GetService('Workspace').Enemies:FindFirstChild(Monster) then
                StartMagnetFarmLevel = false
                Usefastattack = false

                if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Modstween then
                            Modstween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon

                        task.wait(0.314285714286)
                    end
                else
                    Modstween = toTarget(CFrameMon)
                end
            end

            local v728, v729, v730 = pairs(game:GetService('Workspace').Enemies:GetChildren())
            local v731 = {
                CFrame.new(-7682.611328125, 5567.037109375, -497.36492919921875),
                CFrame.new(-7630.34375, 5637.08056640625, -1425.1163330078125),
                CFrame.new(-7862.18310546875, 5662.13720703125, -1705.7489013671875),
            }

            if not (game:GetService('Workspace').Enemies:FindFirstChild('Shanda [Lv. 475]') or (game:GetService('Workspace').Enemies:FindFirstChild('Royal Squad [Lv. 525]') or game:GetService('Workspace').Enemies:FindFirstChild('Royal Soldier [Lv. 550]'))) then
                Usefastattack = false
                StartMagnetFarmLevelSkip = false

                local v732, v733, v734 = pairs(v731)

                while true do
                    local v735

                    v734, v735 = v732(v733, v734)

                    if v734 == nil then
                        break
                    end
                    if SkipFarmLevel and StartKaiTun and not (game:GetService('Workspace').Enemies:FindFirstChild('Shanda [Lv. 475]') or (game:GetService('Workspace').Enemies:FindFirstChild('Royal Squad [Lv. 525]') or game:GetService('Workspace').Enemies:FindFirstChild('Royal Soldier [Lv. 550]'))) then
                        while SkipFarmLevel and StartKaiTun and not (game:GetService('Workspace').Enemies:FindFirstChild('Shanda [Lv. 475]') or (game:GetService('Workspace').Enemies:FindFirstChild('Royal Squad [Lv. 525]') or game:GetService('Workspace').Enemies:FindFirstChild('Royal Soldier [Lv. 550]'))) do
                            task.wait()

                            Modstween = toTarget(v735)

                            if (v735.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                                if Modstween then
                                    Modstween:Stop()
                                end

                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v735

                                break
                            end

                            task.wait(0.2)
                        end

                        task.wait(0.1)
                    end
                end

                if Modstween then
                    Modstween:Stop()
                end
            end

            local v736, v737, v738 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            if true then
                task.wait()

                if (v740.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v740.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v740.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v740.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v740.Parent and v740.Humanoid.Health > 0) then
            else
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v739, v740 = v754(v755, v739)

            if v739 == nil then
            end
            if StartKaiTun and (v740.Name == 'Thunder God [Lv. 575] [Boss]' and (v740:FindFirstChild('HumanoidRootPart') and (v740:FindFirstChild('Humanoid') and v740.Humanoid.Health > 0))) then
            else
            end

            local v741

            v738, v741 = v736(v737, v738)

            if v738 == nil then
            end
            if not SkipFarmLevel or (not StartKaiTun or (not table.find({
                'Shanda [Lv. 475]',
                'Royal Squad [Lv. 525]',
                'Royal Soldier [Lv. 550]',
            }, v741.Name) or (not v741:FindFirstChild('HumanoidRootPart') or (not v741:FindFirstChild('Humanoid') or v741.Humanoid.Health <= 0)))) then
            end
            if true then
                task.wait()

                if v741:FindFirstChild('HumanoidRootPart') and (v741:FindFirstChild('Humanoid') and (v741.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150) then
                    FarmtoTarget = toTarget(v741.HumanoidRootPart.Position, v741.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                elseif v741:FindFirstChild('HumanoidRootPart') and (v741:FindFirstChild('Humanoid') and (v741.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150) then
                    if FarmtoTarget then
                        FarmtoTarget:Stop()
                    end

                    Usefastattack = true

                    EquipWeapon()

                    StartMagnetFarmLevelSkip = true

                    if game.Players.LocalPlayer.Character:FindFirstChild('Black Leg') and game.Players.LocalPlayer.Character:FindFirstChild('Black Leg').Level.Value >= 150 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                    end

                    toAroundTarget(v741.HumanoidRootPart.CFrame)
                end
            end
            if (game:GetService('Workspace').Enemies:FindFirstChild('Shanda [Lv. 475]') or (game:GetService('Workspace').Enemies:FindFirstChild('Royal Squad [Lv. 525]') or game:GetService('Workspace').Enemies:FindFirstChild('Royal Soldier [Lv. 550]'))) and ((SkipFarmLevel or StartKaiTun) and (v741.Humanoid.Health > 0 and v741.Parent)) then
            else
            end
            if string.find(p698.Text, NameCheckQuest) then
            end

            Com('F_', 'AbandonQuest')
            task.wait()

            if v742:FindFirstChild('HumanoidRootPart') and v742:FindFirstChild('Humanoid') then
                if (v742.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v742.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if FarmtoTarget then
                            FarmtoTarget:Stop()
                        end

                        Usefastattack = true

                        EquipWeapon()

                        StartMagnetFarmLevel = true
                        PosMon = v742.HumanoidRootPart.CFrame

                        toAroundTarget(v742.HumanoidRootPart.CFrame)
                    end
                else
                    FarmtoTarget = toTarget(v742.HumanoidRootPart.Position, v742.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                end
            end
            if game:GetService('Workspace').Enemies:FindFirstChild(Monster) and (StartKaiTun and (string.find(p698.Text, NameCheckQuest) and (v742.Humanoid.Health > 0 and (v742.Parent and p699.Visible ~= false)))) then
            end

            Usefastattack = false
            StartMagnetFarmLevel = false

            if p699.Visible == false then
                break
            end

            local v742

            v730, v742 = v728(v729, v730)

            if v730 == nil then
            end
            if StartKaiTun and (v742.Name == Monster and (v742:FindFirstChild('HumanoidRootPart') and (v742:FindFirstChild('Humanoid') and v742.Humanoid.Health > 0))) then
            else
            end

            Usefastattack = false
            StartMagnetFarmLevelSkip = false

            ShowDoingStatus('Doing Quest Saber')

            if game.Workspace.Map.Jungle.QuestPlates.Door.CanCollide ~= false then
                local v743, v744, v745 = pairs(game:GetService('Workspace').Map.Jungle.QuestPlates:GetChildren())

                while true do
                    local v746

                    v745, v746 = v743(v744, v745)

                    if v745 == nil then
                        break
                    end
                    if v746:IsA('Model') then
                        task.wait()

                        if v746.Button.BrickColor ~= BrickColor.new('Camo') and StartKaiTun then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v746:FindFirstChild('Button').CFrame

                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v746:FindFirstChild('Button'), 0)
                            task.wait(0.1)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v746:FindFirstChild('Button'), 1)
                            task.wait(0.2)
                        end
                    end
                end

                task.wait(0.5)
            end
            if game.Workspace.Map.Desert.Burn.Part.CanCollide ~= false then
                if inmyself('Torch') then
                    if tween then
                        tween:Cancel()
                    end

                    EquipWeapon('Torch')
                    task.wait(0.5)

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1114.87708, 4.9214654, 4349.8501, -0.612586915, -9.68697833e-8, 0.790403247, -1.2634203000000002e-7, 1, 2.4638446e-8, -0.790403247, -8.47679615e-8, -0.612586915)

                    task.wait(8.14285714286)
                elseif not inmyself('Torch') then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 0.0000342372805, -0.258850515, 0.965917408)
                end
            end
            if Com('F_', 'ProQuestProgress', 'SickMan') ~= 0 then
                Com('F_', 'ProQuestProgress', 'GetCup')
                task.wait(0.5)
                EquipWeapon('Cup')
                task.wait(0.5)
                Com('F_', 'ProQuestProgress', 'FillCup', inmyself('Cup'))
                task.wait()
                Com('F_', 'ProQuestProgress', 'SickMan')
            end
            if Com('F_', 'ProQuestProgress', 'RichSon') ~= 0 then
                if Com('F_', 'ProQuestProgress', 'RichSon') ~= 1 then
                    Com('F_', 'ProQuestProgress', 'RichSon')
                else
                    EquipWeapon('Relic')
                    task.wait(0.5)

                    if game.ReplicatedStorage:FindFirstChild('Saber Expert [Lv. 200] [Boss]') or game.Workspace.Enemies:FindFirstChild('Saber Expert [Lv. 200] [Boss]') then
                        if (CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if (CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                                if Questtween then
                                    Questtween:Stop()
                                end

                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494)
                            end
                        else
                            Questtween = toTarget(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494))
                        end
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, -5.79995607e-8, -0.481375456, 6.30572643e-8, 0.876514494)
                    end
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Mob Leader [Lv. 120] [Boss]') then
                if (CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-8, 0.371961564, -7.61816636e-8, 1, 4.44474857e-8, -0.371961564, 1.29216433e-8, -0.928248107)
                    end
                else
                    Questtween = toTarget(CFrame.new(-2848.59399, 7.4272871, 5342.44043))
                end
            end

            local v747, v748, v749 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if (v751.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v751.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v751.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v751.HumanoidRootPart.CFrame)
                end
            end
            if v751.Parent and (v751.Humanoid.Health > 0 and StartKaiTun ~= false) then
            else
            end

            Usefastattack = false
            a = 1

            repeat
                task.wait()

                a = a + 1

                Com('F_', 'TravelDressrosa')
            until a == 20 or StartKaiTun == false

            local v750, v751 = v762(v763, v750)

            if v750 == nil then
            end
            if StartKaiTun and (v751:IsA('Model') and (v751:FindFirstChild('Humanoid') and (v751:FindFirstChild('HumanoidRootPart') and (v751.Humanoid.Health > 0 and v751.Name == 'Ice Admiral [Lv. 700] [Boss]')))) then
            else
            end

            local v752 = u542

            if not (string.find(v752:Update().Text, u548) and (game.ReplicatedStorage:FindFirstChild('Thunder God [Lv. 575] [Boss]') or game.Workspace.Enemies:FindFirstChild('Thunder God [Lv. 575] [Boss]'))) then
            end

            ShowDoingStatus('Kill Tunder God')

            if not game.Workspace.Enemies:FindFirstChild('Thunder God [Lv. 575] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Thunder God [Lv. 575] [Boss]') then
                    local v753 = CFrame.new(-7917.53613, 5616.61377, -2277.78564)

                    if (v753.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v753.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v753
                        end
                    else
                        Questtween = toTarget(v753)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v754, v755

            v754, v755, v739 = pairs(game.Workspace.Enemies:GetChildren())

            local v756 = CFrame.new(-4713.13134765625, 845.2769775390625, -1859.4736328125)

            if not game:GetService('Workspace').Enemies:FindFirstChild("God's Guard [Lv. 450]") then
                Usefastattack = false
                StartMagnetFarmLevelSkip = false
                Modstween = toTarget(v756.Position, v756)

                if (v756.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Modstween then
                        Modstween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v756
                end

                task.wait()
            end

            local v757, v758, v759 = pairs(game:GetService('Workspace').Enemies:GetChildren())
            local v760

            v759, v760 = v757(v758, v759)

            if v759 == nil then
            end
            if SkipFarmLevel and (StartKaiTun and (v760.Name == "God's Guard [Lv. 450]" and (v760:FindFirstChild('HumanoidRootPart') and (v760:FindFirstChild('Humanoid') and v760.Humanoid.Health > 0)))) then
            else
            end
            if true then
                task.wait()

                if v760:FindFirstChild('HumanoidRootPart') and (v760:FindFirstChild('Humanoid') and (v760.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150) then
                    FarmtoTarget = toTarget(v760.HumanoidRootPart.Position, v760.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                elseif v760:FindFirstChild('HumanoidRootPart') and (v760:FindFirstChild('Humanoid') and (v760.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150) then
                    if FarmtoTarget then
                        FarmtoTarget:Stop()
                    end

                    Usefastattack = true

                    EquipWeapon()

                    StartMagnetFarmLevelSkip = true

                    if game.Players.LocalPlayer.Character:FindFirstChild('Black Leg') and game.Players.LocalPlayer.Character:FindFirstChild('Black Leg').Level.Value >= 150 then
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                    end

                    toAroundTarget(v760.HumanoidRootPart.CFrame)
                end
            end
            if game:GetService('Workspace').Enemies:FindFirstChild("God's Guard [Lv. 450]") and (SkipFarmLevel or StartKaiTun) and (v760.Humanoid.Health > 0 and v760.Parent) then
            else
            end

            Usefastattack = false
            StartMagnetFarmLevelSkip = false

            local v761 = u541

            if not string.find(v761:Update().Text, u547) and AutoSaber then
            end

            ShowDoingStatus('Doing Quest Sea 2')

            if Com('F_', 'DressrosaQuestProgress', 'Dressrosa') == 0 then
                Com('F_', 'TravelDressrosa')
            end
            if game.Workspace.Map.Ice.Door.CanCollide ~= false or game.Workspace.Map.Ice.Door.Transparency ~= 1 then
                if inmyself('Key') then
                    EquipWeapon('Key')
                    task.wait(0.1)

                    if (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if DoorNewWorldTween then
                                DoorNewWorldTween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1347.7124, 37.3751602, -1325.6488)

                            task.wait(0.3)
                        end
                    else
                        DoorNewWorldTween = toTarget(CFrame.new(1347.7124, 37.3751602, -1325.6488))
                    end
                elseif not inmyself('Key') then
                    Com('F_', 'DressrosaQuestProgress', 'Detective')
                    task.wait(0.3)
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Ice Admiral [Lv. 700] [Boss]') then
                DoorNewWorldTween = toTarget(CFrame.new(1382.562255859375, 26.999441146850586, -1458.77783203125))

                Com('F_', 'TravelDressrosa')
            end
            if DoorNewWorldTween then
                DoorNewWorldTween:Stop()
            end

            local v762, v763

            v762, v763, v750 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if (v764.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v764.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v764.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v764.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v764.Parent and v764.Humanoid.Health > 0) then
            end

            Usefastattack = false

            local v764

            v749, v764 = v747(v748, v749)

            if v749 == nil then
            end
            if StartKaiTun and (v764:IsA('Model') and (v764:FindFirstChild('Humanoid') and (v764:FindFirstChild('HumanoidRootPart') and (v764.Humanoid.Health > 0 and v764.Name == 'Mob Leader [Lv. 120] [Boss]')))) then
            else
            end
        end
        function AutoKaiTunNewWorld(p765, p766, p767, p768)
            if not AutoDeathStep or (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or Com('F_', 'BuyDeathStep', true) == 1) or not game:GetService('Workspace').Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') then
                local v769 = u538

                if not string.find(v769:Update().Text, u548) then
                end
            end
            if not (game.ReplicatedStorage:FindFirstChild('Awakened Ice Admiral [Lv. 1400] [Boss]') or game.Workspace.Enemies:FindFirstChild('Awakened Ice Admiral [Lv. 1400] [Boss]')) then
            end

            ShowDoingStatus('Kill Awaken Ice')

            if not game.Workspace.Enemies:FindFirstChild('Awakened Ice Admiral [Lv. 1400] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Awakened Ice Admiral [Lv. 1400] [Boss]') then
                    local v770 = CFrame.new(6407.33936, 340.223785, -6892.521)

                    if (v770.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v770.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v770
                        end
                    else
                        Questtween = toTarget(v770)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v771, v772, v773 = pairs(game.Workspace.Enemies:GetChildren())
            local v774

            v773, v774 = v771(v772, v773)

            if v773 == nil then
            end
            if StartKaiTun and (v774.Name == 'Awakened Ice Admiral [Lv. 1400] [Boss]' and (v774:FindFirstChild('HumanoidRootPart') and (v774:FindFirstChild('Humanoid') and v774.Humanoid.Health > 0))) then
            else
            end

            task.wait()

            if v776:FindFirstChild('HumanoidRootPart') then
                if (v776.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v776.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon(SelectToolWeapon)

                        PosMon = v776.HumanoidRootPart.CFrame
                        Usefastattack = true
                        StartMagnetEctoplasm = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v776.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Usefastattack = false
                    Farmtween = toTarget(v776.HumanoidRootPart.CFrame * CFrame.new(1, 20, 0))
                    StartMagnetEctoplasm = false
                end
            end
            if StartKaiTun ~= false and (v776.Parent and v776.Humanoid.Health > 0) then
            end

            Usefastattack = false
            StartMagnetEctoplasm = false

            local v775, v776 = v828(v829, v775)

            if v775 == nil then
            end
            if StartKaiTun and (string.find(v776.Name, 'Ship') and v776:FindFirstChild('HumanoidRootPart')) then
            else
            end
            if true then
                task.wait()

                if (v778.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v778.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v778.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v778.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v778.Parent and v778.Humanoid.Health > 0) then
            end

            Usefastattack = false

            local v777, v778 = v837(v838, v777)

            if v777 == nil then
            end
            if StartKaiTun and (v778.Name == 'Don Swan [Lv. 1000] [Boss]' and (v778:FindFirstChild('HumanoidRootPart') and (v778:FindFirstChild('Humanoid') and v778.Humanoid.Health > 0))) then
            else
            end
            if string.find(p765.Text, NameCheckQuest) then
            end

            Com('F_', 'AbandonQuest')
            task.wait()

            if v780:FindFirstChild('HumanoidRootPart') and v780:FindFirstChild('Humanoid') then
                if (v780.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v780.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if FarmtoTarget then
                            FarmtoTarget:Stop()
                        end

                        Usefastattack = true

                        EquipWeapon()

                        StartMagnetFarmLevel = true
                        PosMon = v780.HumanoidRootPart.CFrame

                        toAroundTarget(v780.HumanoidRootPart.CFrame)
                    end
                else
                    FarmtoTarget = toTarget(v780.HumanoidRootPart.Position, v780.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                end
            end
            if game:GetService('Workspace').Enemies:FindFirstChild(Monster) and (StartKaiTun and (string.find(p765.Text, NameCheckQuest) and (v780.Humanoid.Health > 0 and (v780.Parent and p766.Visible ~= false)))) then
            end

            Usefastattack = false
            StartMagnetFarmLevel = false

            local v779, v780 = v863(v864, v779)

            if v779 == nil then
            end
            if StartKaiTun and (v780.Name == Monster and (v780:FindFirstChild('HumanoidRootPart') and (v780:FindFirstChild('Humanoid') and v780.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v774.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v774.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v774.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v774.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v774.Parent and v774.Humanoid.Health > 0) then
            else
            end

            Usefastattack = false

            if not AutoSharkmanKarate or (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or (Com('F_', 'BuySharkmanKarate', true) == 1 or tonumber(Com('F_', 'BuySharkmanKarate', true)) == 0)) or not (game.ReplicatedStorage:FindFirstChild('Tide Keeper [Lv. 1475] [Boss]') or game.Workspace.Enemies:FindFirstChild('Tide Keeper [Lv. 1475] [Boss]')) then
            end

            ShowDoingStatus('Kill Tide Keeper')

            if not game.Workspace.Enemies:FindFirstChild('Tide Keeper [Lv. 1475] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Tide Keeper [Lv. 1475] [Boss]') then
                    local v781 = CFrame.new(-3570.18652, 123.328949, -11555.9072)

                    if (v781.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v781.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v781
                        end
                    else
                        Questtween = toTarget(v781)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v782, v783, v784 = pairs(game.Workspace.Enemies:GetChildren())
            local v785

            v784, v785 = v782(v783, v784)

            if v784 == nil then
            end
            if StartKaiTun and (v785.Name == 'Tide Keeper [Lv. 1475] [Boss]' and (v785:FindFirstChild('HumanoidRootPart') and (v785:FindFirstChild('Humanoid') and v785.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v785.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v785.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v785.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v785.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v785.Parent and v785.Humanoid.Health > 0) then
            else
            end

            Usefastattack = false

            if not AutoCursedCaptain or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or not (game.ReplicatedStorage:FindFirstChild('Cursed Captain [Lv. 1325] [Raid Boss]') or game.Workspace.Enemies:FindFirstChild('Cursed Captain [Lv. 1325] [Raid Boss]')) then
            end

            ShowDoingStatus('Kill Cursed Captain')

            if not game.Workspace.Enemies:FindFirstChild('Cursed Captain [Lv. 1325] [Raid Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Cursed Captain [Lv. 1325] [Raid Boss]') then
                    local v786 = CFrame.new(916.928589, 181.092773, 33422)

                    if (v786.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v786.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v786
                        end
                    else
                        Questtween = toTarget(v786)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v787, v788, v789 = pairs(game.Workspace.Enemies:GetChildren())

            if (AutoDarkbeard or AutoSoulGuitar) and (game.ReplicatedStorage:FindFirstChild('Darkbeard [Lv. 1000] [Raid Boss]') or game.Workspace.Enemies:FindFirstChild('Darkbeard [Lv. 1000] [Raid Boss]')) then
            end
            if (AutoDarkbeard or AutoSoulGuitar) and inmyself('Fist of Darkness') then
                ShowDoingStatus('Use Fist of Darkness')
                EquipWeapon('Fist of Darkness')
                toTarget(CFrame.new(3777.35693, 14.675993, -3499.71313, 0.189889491, -1.57955e-8, -0.981805444, 3.88659807e-8, 1, -8.57120686e-9, 0.981805444, -3.65312509e-8, 0.189889491))
                task.wait(1)
            end
            if inmyself('Red Key') and not game:GetService('Workspace').Map.CakeLoaf:FindFirstChild('RedDoor') then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2712.4619140625, 64.36634826660156, -12892.9345703125)

                Com('F_', 'CakeScientist', 'Check')
                task.wait(0.2)
                Com('F_', 'RaidsNpc', 'Check')
                task.wait(0.2)
            end
            if not AutoFactory or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or not (game.Workspace.Enemies:FindFirstChild('Core') or game:GetService('ReplicatedStorage'):FindFirstChild('Core')) then
            end

            ShowDoingStatus('Do Factory')

            if game:GetService('ReplicatedStorage'):FindFirstChild('Core') and game:GetService('ReplicatedStorage'):FindFirstChild('Core'):FindFirstChild('Humanoid') then
                GOtween = toTarget(CFrame.new(448.46756, 199.356781, -441.389252).Position, CFrame.new(448.46756, 199.356781, -441.389252))

                if (CFrame.new(448.46756, 199.356781, -441.389252).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if GOtween then
                        GOtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Core') then
            end

            local v790, v791, v792 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            if true then
                task.wait()

                if (v794.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v794.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        StartMagnetSwan = true
                        PosMon = v794.HumanoidRootPart.CFrame

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v794.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v794.HumanoidRootPart.CFrame)
                end
            end
            if v794.Parent and (v794.Humanoid.Health > 0 and (StartKaiTun ~= false and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible ~= false)) then
            end

            Usefastattack = false
            StartMagnetSwan = false

            local v793, v794 = v799(v800, v793)

            if v793 == nil then
            end
            if v794.Name ~= 'Swan Pirate [Lv. 775]' or (not v794:FindFirstChild('HumanoidRootPart') or (not v794:FindFirstChild('Humanoid') or v794.Humanoid.Health <= 0)) then
            else
            end

            ShowDoingStatus('Kill Darkbeard')

            if not game.Workspace.Enemies:FindFirstChild('Darkbeard [Lv. 1000] [Raid Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Darkbeard [Lv. 1000] [Raid Boss]') then
                    local v795 = CFrame.new(3876.00366, 24.6882591, -3820.21777)

                    if (v795.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v795.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v795
                        end
                    else
                        Questtween = toTarget(v795)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v796, v797, v798 = pairs(game.Workspace.Enemies:GetChildren())

            if 850 > p767 or (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or not AutoBartilo) or Com('F_', 'BartiloQuestProgress', 'Bartilo') ~= 0 and (Com('F_', 'BartiloQuestProgress', 'Bartilo') ~= 1 or not (game.Workspace.Enemies:FindFirstChild('Jeremy [Lv. 850] [Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Jeremy [Lv. 850] [Boss]'))) and Com('F_', 'BartiloQuestProgress', 'Bartilo') ~= 2 then
            end

            ShowDoingStatus('Do Bartilo Quest')

            if Com('F_', 'BartiloQuestProgress', 'Bartilo') ~= 0 then
            end
            if not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Swan Pirates') or (not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, '50') or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible ~= true) then
                Bartilotween = toTarget(CFrame.new(-456.28952, 73.0200958, 299.895966))

                if (CFrame.new(-456.28952, 73.0200958, 299.895966).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Bartilotween then
                        Bartilotween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-456.28952, 73.0200958, 299.895966)

                    Com('F_', 'StartQuest', 'BartiloQuest', 1)
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Swan Pirate [Lv. 775]') then
                StartMagnetSwan = false
                Questtween = toTarget(CFrame.new(1057.92761, 137.614319, 1242.08069))

                if (CFrame.new(1057.92761, 137.614319, 1242.08069).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1057.92761, 137.614319, 1242.08069)
                end
            end

            local v799, v800

            v799, v800, v793 = pairs(game.Workspace.Enemies:GetChildren())

            if Com('F_', 'BartiloQuestProgress', 'Bartilo') ~= 1 then
                if Com('F_', 'BartiloQuestProgress', 'Bartilo') == 2 then
                    if (CFrame.new(-1836, 30, 1714).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (CFrame.new(-1836, 30, 1714).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Bartilotween then
                                Bartilotween:Stop()
                            end

                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836, 11, 1714)

                            task.wait(0.5)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)

                            task.wait(1)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
                        end
                    else
                        Bartilotween = toTarget(CFrame.new(-1836, 30, 1714))
                    end
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Jeremy [Lv. 850] [Boss]') then
                Bartilotween = toTarget(CFrame.new(2099.88159, 448.931, 648.997375))

                if (CFrame.new(2099.88159, 448.931, 648.997375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Bartilotween then
                        Bartilotween:Stop()
                    end

                    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2099.88159, 448.931, 648.997375)
                end
            end

            local v801, v802, v803 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if (v893.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
                    if (v893.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon(SelectToolWeapon)

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v893.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v893.HumanoidRootPart.Position, v893.HumanoidRootPart.CFrame)
                end
            end
            if v893.Parent and (v893.Humanoid.Health > 0 and AutoEvoRace3 ~= false) then
            else
                Usefastattack = false

                if not v893.Parent or v893.Humanoid.Health <= 0 then
                    if v867 == 'DoDiamond' then
                        u540.Dai = true
                    elseif v867 == 'DoJeremy' then
                        u540.Jer = true
                    elseif v867 == 'DoFajita' then
                        u540.Faji = true
                    end
                end
            end
            if true then
                task.wait()

                if (v805.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v805.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v805.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v805.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v805.Parent and Com('F_', 'ZQuestProgress').KilledIndraBoss ~= true) then
            end

            Usefastattack = false

            while task.wait(1) do
                Com('F_', 'TravelZou')
            end

            local v804, v805 = v865(v866, v804)

            if v804 == nil then
            end
            if StartKaiTun and (v805.Name == 'rip_indra [Lv. 1500] [Boss]' and (v805:FindFirstChild('HumanoidRootPart') and (v805:FindFirstChild('Humanoid') and v805.Humanoid.Health > 0))) then
            else
            end

            task.wait()

            if not v906:FindFirstChild('Humanoid') then
                return
            end

            v906.Humanoid.Health = 0

            if StartKaiTun and (v906.Humanoid.Health > 0 and v906.Parent) then
            else
            end
            if 850 <= p767 and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and (AutoQuestFlower and (game.Players.LocalPlayer.Data.Beli.Value >= 500000 and (inmyself('Flower 1') and (inmyself('Flower 2') and inmyself('Flower 3')))))) then
                Com('F_', 'Alchemist', '1')
                Com('F_', 'Alchemist', '2')

                if (CFrame.new(-2777.6001, 72.9661407, -3571.42285).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(-2777.6001, 72.9661407, -3571.42285).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2777.6001, 72.9661407, -3571.42285)

                        Com('F_', 'Alchemist', '3')
                    end
                else
                    Farmtween = toTarget(CFrame.new(-2777.6001, 72.9661407, -3571.42285).Position, CFrame.new(-2777.6001, 72.9661407, -3571.42285))
                end
            end
            if 850 <= p767 and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and (AutoQuestFlower and (game.Players.LocalPlayer.Data.Beli.Value >= 500000 and (tonumber(Com('F_', 'BartiloQuestProgress', 'Bartilo')) == 3 and Com('F_', 'Alchemist', '1') ~= -2)))) and (workspace.Flower2.Transparency ~= 1 and not inmyself('Flower 2') or not (inmyself('Flower 2') and inmyself('Flower 3'))) then
            end
            if AutoV3Race and (1000 <= p767 and (Com('F_', 'Alchemist', '1') == -2 and (Com('F_', 'Wenlocktoad', '1') ~= -2 and (game.Players.LocalPlayer.Data.Beli.Value >= 2000000 and RaceAllIn1())))) then
            end
            if game:GetService('Workspace').Map.IceCastle:FindFirstChild('RengokuChest') and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false then
                local v806 = u538

                if not (string.find(v806:Update().Text, u548) and (inmyself('Hidden Key') and AutoRengoku)) then
                end

                ShowDoingStatus('Use Hidden Key')
                EquipWeapon('Hidden Key')

                if (CFrame.new(6571.81885, 296.689758, -6966.76514).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(6571.81885, 296.689758, -6966.76514).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6571.81885, 296.689758, -6966.76514, 0.825126112, 8.412257e-10, 0.564948559, -2.42370835e-8, 1, 3.39100339e-8, -0.564948559, -4.16727595e-8, 0.825126112)

                        pcall(RefreshStatus)
                    end
                else
                    Farmtween = toTarget(CFrame.new(6571.81885, 296.689758, -6966.76514))
                end
            end
            if game:GetService('Workspace').Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') and (inmyself('Library Key') and (AutoDeathStep and (u76 and Com('F_', 'OpenLibrary', true) ~= true))) then
                ShowDoingStatus('Use Library Key')
                EquipWeapon('Library Key')
                task.wait(0.1)
                Com('F_', 'OpenLibrary')
            end
            if p767 < 1500 or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false then
            end

            local v807 = u538

            if not (string.find(v807:Update().Text, u548) and AutoRengoku) then
            end

            ShowDoingStatus('Do Rengoku')

            if not game.Workspace.Enemies:FindFirstChild('Snow Lurker [Lv. 1375]') then
                StartMagnetSnowLurker = false

                if (CFrame.new(5518.00684, 60.5559731, -6828.80518).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(5518.00684, 60.5559731, -6828.80518).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5518.00684, 60.5559731, -6828.80518, -0.650781393, -3.64292951e-8, 0.759265184, -4.07668654e-9, 1, 4.44854642e-8, -0.759265184, 2.58550248e-8, -0.650781393)
                    end
                else
                    Farmtween = toTarget(CFrame.new(5518.00684, 60.5559731, -6828.80518))
                end
            end

            local v808, v809, v810 = pairs(game.Workspace.Enemies:GetChildren())

            if p767 < 1500 or (not AutoSea3 or (SkipGetItemSoulInSea2 or (not AutoSoulGuitar or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false))) then
            end

            local v811 = u544

            if not string.find(v811:Update().Text, u548) or (GetMaterial('Dark Fragment') >= 1 or not (function()
                local v812, v813, v814 = pairs(game.Workspace:GetDescendants())

                while true do
                    local v815

                    v814, v815 = v812(v813, v814)

                    if v814 == nil then
                        break
                    end
                    if v815.Name:match('Chest') and v815:IsA('BasePart') then
                        return true
                    end
                end

                return false
            end)()) and GetMaterial('Ectoplasm') >= 300 then
            end

            ShowDoingStatus('Do Soul Guitar')

            if GetMaterial('Ectoplasm') >= 300 then
                if GetMaterial('Dark Fragment') < 1 and (function()
                    local v816, v817, v818 = pairs(game.Workspace:GetDescendants())

                    while true do
                        local v819

                        v818, v819 = v816(v817, v818)

                        if v818 == nil then
                            break
                        end
                        if v819.Name:match('Chest') and v819:IsA('BasePart') then
                            return true
                        end
                    end

                    return false
                end)() then
                    local v820, v821, v822 = pairs(game.Workspace:GetDescendants())

                    while true do
                        local v823

                        v822, v823 = v820(v821, v822)

                        if v822 == nil then
                            break
                        end
                        if v823.Name:match('Chest') and (v823:IsA('BasePart') and StartKaiTun) then
                            if ChestTarget then
                                ChestTarget:Stop()
                            end
                            if inmyself('Fist of Darkness') then
                                break
                            end

                            repeat
                                task.wait()

                                ChestTarget = toTarget(v823.CFrame)

                                task.wait(0.2)
                            until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v823.Position).Magnitude <= 10 or not (StartKaiTun and v823.Parent)

                            if not StartKaiTun then
                                if tween then
                                    tween:Cancel()
                                end

                                break
                            end

                            task.wait(5)
                        end
                    end
                end
            end
            if not (function()
                local v824, v825, v826 = pairs(game.Workspace.Enemies:GetChildren())

                while true do
                    local v827

                    v826, v827 = v824(v825, v826)

                    if v826 == nil then
                        break
                    end
                    if string.find(v827.Name, 'Ship') and v827:FindFirstChild('HumanoidRootPart') then
                        return true
                    end
                end

                return false
            end)() then
                if (CFrame.new(920.14447, 129.581833, 33442.168).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(920.14447, 129.581833, 33442.168).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(920.14447, 129.581833, 33442.168, -0.999913812, 0, -0.0131403487, 0, 1, 0, 0.0131403487, 0, -0.999913812)
                    end
                else
                    Farmtween = toTarget(CFrame.new(920.14447, 129.581833, 33442.168).Position, CFrame.new(920.14447, 129.581833, 33442.168))
                end
            end

            local v828, v829

            v828, v829, v775 = pairs(game.Workspace.Enemies:GetChildren())

            if p767 < 1500 or not AutoSea3 or (Com('F_', 'GetUnlockables').FlamingoAccess == true or not HaveFruitToSea3(alliesfruit)) and Com('F_', 'GetUnlockables').FlamingoAccess ~= true or (game:GetService('Workspace').Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') and AutoDeathStep or tonumber(Com('F_', 'BuySharkmanKarate', true)) ~= 1 and (tonumber(Com('F_', 'BuySharkmanKarate', true)) ~= 0 and AutoSharkmanKarate)) then
            end
            if Com('F_', 'GetUnlockables').FlamingoAccess ~= true then
                ShowDoingStatus('Find Fruit Sea 3')

                HaveDevilFruitSea3 = false

                local _huge = math.huge
                local v831, v832, v833 = pairs(Com('F_', 'getInventoryFruits'))
                local v834 = ''

                while true do
                    local v835

                    v833, v835 = v831(v832, v833)

                    if v833 == nil or not v835.Price then
                        break
                    end
                    if v835.Price >= 1000000 and (not table.find(alliesfruit, v835.Name) and v835.Price < _huge) then
                        _huge = v835.Price or math.huge
                        v834 = v835.Name
                        HaveDevilFruitSea3 = true
                    end
                end

                if HaveDevilFruitSea3 then
                    Com('F_', 'LoadFruit', v834)
                    task.wait(0.5)

                    for v836 = 1, 3 do
                        Com('F_', 'TalkTrevor', tostring(v836))
                    end
                end
            end

            ShowDoingStatus('Do Sea 3')

            if Com('F_', 'ZQuestProgress', 'Check') == 0 then
            end
            if Com('F_', 'ZQuestProgress', 'Check') == 1 then
                Com('F_', 'TravelZou')
            end
            if not (game.Workspace.Enemies:FindFirstChild('Don Swan [Lv. 1000] [Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Don Swan [Lv. 1000] [Boss]')) then
                u171:NormalTeleport()
            end
            if not game.Workspace.Enemies:FindFirstChild('Don Swan [Lv. 1000] [Boss]') then
                if (CFrame.new(2288.802, 15.1870775, 863.034607).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(2288.802, 15.1870775, 863.034607).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2288.802, 15.1870775, 863.034607)
                    end
                else
                    Questtween = toTarget(CFrame.new(2288.802, 15.1870775, 863.034607))
                end

                Com('F_', 'SetSpawnPoint')
            end

            local v837, v838

            v837, v838, v777 = pairs(game.Workspace.Enemies:GetChildren())

            if not RaidsDoughNow or (game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough' or (Com('F_', 'CakeScientist', 'Check') ~= true or CheckAwaken())) or not HaveFruitToSea3(alliesfruit) and (p768.HaveFruitInMySelf ~= true or p768.Price < 1000000) and (not inmyself('Special Microchip') and (not CheckIsland() and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true)) or (havemob('rip_indra True Form [Lv. 5000] [Raid Boss]') or (StopRaidsPls or p767 < 1100)) then
            end

            ShowDoingStatus('Doing Raids Dough')

            if tween then
                tween:Cancel()
            end
            if not (inmyself('Special Microchip') or CheckIsland()) then
                GoIsland = false

                local _huge2 = math.huge
                local v840 = ''

                if p768.HaveFruitInMySelf ~= true or p768.Price < 1000000 or (game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value >= 5000 or p768.HaveFruitInStore ~= false) then
                    if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 4000 then
                        local v841, v842, v843 = pairs(Com('F_', 'getInventoryFruits'))

                        while true do
                            local v844

                            v843, v844 = v841(v842, v843)

                            if v843 == nil or not v844.Price then
                                break
                            end
                            if v844.Price < RateFruitRaids and v844.Price < _huge2 then
                                _huge2 = v844.Price
                                v840 = v844.Name
                            end
                        end

                        if v840 ~= '' then
                            Com('F_', 'LoadFruit', v840)
                        end

                        Com('F_', 'RaidsNpc', 'Select', 'Flame')
                    else
                        local v845, v846, v847 = pairs(Com('F_', 'getInventoryFruits'))

                        while true do
                            local v848

                            v847, v848 = v845(v846, v847)

                            if v847 == nil or not v848.Price then
                                break
                            end
                            if v848.Price >= 1000000 and (not table.find(alliesfruit, v848.Name) and v848.Price < _huge2) then
                                _huge2 = v848.Price
                                v840 = v848.Name
                            end
                        end

                        if v840 ~= '' then
                            Com('F_', 'LoadFruit', v840)
                        end

                        Com('F_', 'RaidsNpc', 'Select', 'Dough')
                    end
                else
                    StoreMyFruit()
                end

                Com('F_', 'Awakener', 'Check')
                Com('F_', 'Awakener', 'Awaken')
            end
            if inmyself('Special Microchip') and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and CheckIsland() == false) then
                if u76 then
                    fireclickdetector(_Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif u77 then
                    fireclickdetector(_Workspace.Map['Boat Castle'].RaidSummon2.Button.Main.ClickDetector)
                end

                task.wait(17)
            end
            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true then
            end
            if (p768.HaveFruitInMySelf ~= true or p768.HaveFruitInStore ~= true) and (not (RaidsNow and CheckRateFruit(RateFruitRaids)) and (not inmyself('Special Microchip') and (not CheckIsland() and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true))) or (p767 < 1100 or StopRaidsPls) then
            end
            if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value > (LimitRaidsFrag or 100000) and (p768.HaveFruitInMySelf == true and game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough') then
                game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                return
            end

            ShowDoingStatus('Doing Raids')

            if tween then
                tween:Cancel()
            end
            if not (inmyself('Special Microchip') or CheckIsland()) then
                GoIsland = false

                if game.Players.LocalPlayer.Data.DevilFruit.Value == 'Dough-Dough' and not (CheckAwaken() or RaidsNow) then
                    if Com('F_', 'CakeScientist', 'Check') ~= true or p768.HaveFruitInMySelf ~= false or game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 1000 then
                        if Com('F_', 'CakeScientist', 'Check') ~= true or (p768.HaveFruitInMySelf ~= true or p768.Price < 1000000) then
                            Com('F_', 'RaidsNpc', 'Select', GetNameRaids())
                        else
                            Com('F_', 'RaidsNpc', 'Select', 'Dough')
                        end
                    else
                        Com('F_', 'RaidsNpc', 'Select', 'Dough')
                    end

                    return
                end
                if RaidsNow then
                    local _huge3 = math.huge
                    local v850, v851, v852 = pairs(Com('F_', 'getInventoryFruits'))
                    local v853 = ''

                    while true do
                        local v854

                        v852, v854 = v850(v851, v852)

                        if v852 == nil then
                            break
                        end
                        if v854.Price < RateFruitRaids and v854.Price < _huge3 then
                            _huge3 = v854.Price
                            v853 = v854.Name
                        end
                    end

                    if v853 ~= '' then
                        Com('F_', 'LoadFruit', v853)
                    end
                end

                Com('F_', 'RaidsNpc', 'Select', GetNameRaids())
                Com('F_', 'Awakener', 'Check')
                Com('F_', 'Awakener', 'Awaken')
            end
            if inmyself('Special Microchip') and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and CheckIsland() == false) then
                if u76 then
                    fireclickdetector(_Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif u77 then
                    fireclickdetector(_Workspace.Map['Boat Castle'].RaidSummon2.Button.Main.ClickDetector)
                end

                task.wait(17)
            end
            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true then
            end
            if (function()
                local v855, v856, v857 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v858

                    v857, v858 = v855(v856, v857)

                    if v857 == nil then
                        break
                    end
                    if v858:IsA('Tool') and string.find(v858.Name, 'Fruit') then
                        return true
                    end
                end

                return false
            end)() then
                local v859, v860, v861 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v862

                    v861, v862 = v859(v860, v861)

                    if v861 == nil then
                        break
                    end
                    if v862:IsA('Tool') and (string.find(v862.Name, 'Fruit') and StartKaiTun) then
                        if FruitTarget then
                            FruitTarget:Stop()
                        end

                        repeat
                            task.wait(0.1)

                            FruitTarget = toTarget(v862.Handle.CFrame)
                        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v862.Handle.Position).Magnitude <= 8 or not (StartKaiTun and v862.Parent)

                        task.wait(0.5)
                        StoreMyFruit()
                    end
                end
            end

            ShowDoingStatus('Auto Farm')

            if not string.find(p765.Text, NameCheckQuest) then
                Com('F_', 'AbandonQuest')
            end
            if p766.Visible == false then
                Usefastattack = false
                StartMagnetFarmLevel = false

                if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest

                        task.wait(0.95)
                        Com('F_', 'StartQuest', NameQuest, LevelQuest)
                        Com('F_', 'SetSpawnPoint')
                    end
                else
                    Questtween = toTarget(CFrameQuest)
                end
            end
            if p766.Visible ~= true then
                return
            end
            if not game:GetService('Workspace').Enemies:FindFirstChild(Monster) then
                StartMagnetFarmLevel = false
                Usefastattack = false

                if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Modstween then
                            Modstween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon

                        task.wait(0.314285714286)
                    end
                else
                    Modstween = toTarget(CFrameMon)
                end
            end

            local v863, v864

            v863, v864, v779 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            if not game.Workspace.Enemies:FindFirstChild('rip_indra [Lv. 1500] [Boss]') then
                Com('F_', 'ZQuestProgress', 'Check')
                task.wait()
                Com('F_', 'ZQuestProgress', 'Begin')
            end

            local v865, v866

            v865, v866, v804 = pairs(game.Workspace.Enemies:GetChildren())

            local v867 = RaceAllIn1()

            if v867 == 'DoMinkRace' then
                if (function()
                    local v868, v869, v870 = pairs(game.Workspace:GetDescendants())

                    while true do
                        local v871

                        v870, v871 = v868(v869, v870)

                        if v870 == nil then
                            break
                        end
                        if v871.Name:match('Chest') and v871:IsA('BasePart') then
                            return true
                        end
                    end

                    return false
                end)() then
                    local v872, v873, v874 = pairs(game.Workspace:GetDescendants())

                    while true do
                        local v875

                        v874, v875 = v872(v873, v874)

                        if v874 == nil then
                            break
                        end
                        if v875.Name:match('Chest') and (v875:IsA('BasePart') and StartKaiTun) then
                            if ChestTarget then
                                ChestTarget:Stop()
                            end

                            repeat
                                task.wait()

                                ChestTarget = toTarget(v875.CFrame)

                                task.wait(0.2)
                            until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v875.Position).Magnitude <= 10 or not (StartKaiTun and v875.Parent)

                            if not StartKaiTun then
                                if tween then
                                    tween:Cancel()
                                end

                                break
                            end

                            task.wait(5)
                        end
                    end
                end
            end
            if v867 == 'DoFishmanRace' then
                local v876 = u636()

                if v876 and v876.Parent.Humanoid.Value <= 0 then
                    game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                    task.wait()

                    AntiSit = false

                    v876.Parent:Destroy()
                    task.wait(0.2)
                end
                if game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') and game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit == true or (u641() or CheckPirateBoat()) then
                    if u641() then
                        xpcall(function()
                            AntiSit = false
                            game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                            local v877, v878, v879 = pairs(game.Workspace.SeaBeasts:GetChildren())

                            while true do
                                local v880

                                v879, v880 = v877(v878, v879)

                                if v879 == nil then
                                    return
                                end
                                if not StartKaiTun or (not v880:FindFirstChild('HumanoidRootPart') or v880.Health.Value <= 0) then
                                end
                                if true then
                                    task.wait()

                                    local _CFrame = v880:FindFirstChild('HumanoidRootPart').CFrame

                                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(_CFrame.X, 10, _CFrame.Z)).magnitude <= 150 then
                                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(_CFrame.X, 10, _CFrame.Z)).magnitude <= 150 then
                                            if Farmtween then
                                                Farmtween:Stop()
                                            end
                                            if TypeSeabeast ~= 0 then
                                                PosKillSea = Vector3.new(_CFrame.X, 60, _CFrame.Z)
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_CFrame.X, 70, _CFrame.Z)
                                            else
                                                PosKillSea = Vector3.new(_CFrame.X, 80, _CFrame.Z)
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_CFrame.X, 10, _CFrame.Z)
                                            end

                                            SpamSkillSea = true
                                        end
                                    else
                                        Farmtween = toTarget(CFrame.new(_CFrame.X, 10, _CFrame.Z))
                                    end
                                end
                                if StartKaiTun and (v880.Parent and (v880:FindFirstChild('HumanoidRootPart') and v880.Health.Value ~= 0)) then
                                end

                                SpamSkillSea = false
                                AntiSit = false
                            end
                        end, function(...)
                            print(...)
                        end)
                    elseif CheckPirateBoat() then
                        xpcall(function()
                            AntiSit = false
                            game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit = false

                            local v882, v883, v884 = pairs(game.Workspace.Enemies:GetChildren())

                            while true do
                                local v885

                                v884, v885 = v882(v883, v884)

                                if v884 == nil then
                                    return
                                end
                                if StartKaiTun and (v885.Name == 'PirateBasic' or v885.Name == 'PirateBrigade') and (v885:FindFirstChildOfClass('VehicleSeat') and v885.Health.Value > 0) then
                                    if true then
                                        task.wait()

                                        local _CFrame2 = v885:FindFirstChildOfClass('VehicleSeat').CFrame

                                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(_CFrame2.X, 30, _CFrame2.Z)).magnitude <= 150 then
                                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(_CFrame2.X, 30, _CFrame2.Z)).magnitude <= 150 then
                                                if Farmtween then
                                                    Farmtween:Stop()
                                                end

                                                PosKillSea = _CFrame2.Position
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _CFrame2 * CFrame.new(0, 10, 1)
                                                SpamSkillSea = true
                                            end
                                        else
                                            Farmtween = toTarget(CFrame.new(_CFrame2.X, 30, _CFrame2.Z))
                                        end
                                    end
                                    if StartKaiTun and (v885.Parent and (v885:FindFirstChildOfClass('VehicleSeat') and v885.Health.Value ~= 0)) then
                                    end

                                    SpamSkillSea = false
                                    AntiSit = false
                                end
                            end
                        end, function(...)
                            print(...)
                        end)
                    elseif game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        AntiSit = true
                        SpamSkillSea = false

                        game:service('VirtualInputManager'):SendKeyEvent(true, 'W', false, game)
                        task.wait(0.5)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'W', false, game)
                        task.wait(1)
                        game:service('VirtualInputManager'):SendKeyEvent(true, 'S', false, game)
                        task.wait(0.5)
                        game:service('VirtualInputManager'):SendKeyEvent(false, 'S', false, game)
                        task.wait(1)
                    end
                elseif v876 and (game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') and (game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit == false and (u76 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(38.905670166015625, -0.4971587657928467, 5150.13623046875)).Magnitude > 30))) or u77 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(163.8607940673828, -0.4971587657928467, 3242.834716796875)).Magnitude > 30 then
                    AntiSit = false
                    SpamSkillSea = false

                    local v887 = nil

                    if u76 then
                        v887 = toTarget(CFrame.new(38.905670166015625, -0.4971587657928467, 5150.13623046875))
                    elseif u77 then
                        v887 = toTarget(CFrame.new(163.8607940673828, -0.4971587657928467, 3242.834716796875))
                    end

                    v887:Wait()
                    task.wait(2)
                elseif v876 and (game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') and game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Sit == false) then
                    AntiSit = true
                    SpamSkillSea = false
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)

                    task.wait(0.1)
                    v876:Sit(game.Players.LocalPlayer.Character:WaitForChild('Humanoid'))
                elseif not v876 then
                    Com('F_', 'BuyBoat', 'PirateBasic')
                    task.wait(1)
                end
            end
            if v867 ~= 'DoFajita' and (v867 ~= 'DoJeremy' and v867 ~= 'DoDiamond') then
            end

            local v888 = v867 == 'DoDiamond' and 'Diamond [Lv. 750] [Boss]' or (v867 == 'DoJeremy' and 'Jeremy [Lv. 850] [Boss]' or (v867 == 'DoFajita' and 'Fajita [Lv. 925] [Boss]' or ''))

            if not game.Workspace.Enemies:FindFirstChild(v888) then
                Usefastattack = false

                local v889 = havemob(v888)

                if not v889 then
                    return
                end

                KillBossTar = toTarget(v889.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0))
            end
            if KillBossTar then
                KillBossTar:Stop()
            end

            local v890, v891, v892 = pairs(game.Workspace.Enemies:GetChildren())
            local v893

            v892, v893 = v890(v891, v892)

            if v892 == nil then
            end
            if AutoEvoRace3 and (v893.Name == v888 and (v893:FindFirstChild('HumanoidRootPart') and v893.Humanoid.Health >= 0)) then
            else
            end

            ShowDoingStatus('Do Flower Quest')
            Com('F_', 'Alchemist', '1')
            Com('F_', 'Alchemist', '2')

            if not game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 1') and workspace.Flower1.Transparency ~= 1 then
                if (workspace.Flower1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (workspace.Flower1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Flower1.CFrame
                    end
                else
                    Farmtween = toTarget(workspace.Flower1.Position, workspace.Flower1.CFrame)
                end
            end
            if not game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 2') and workspace.Flower2.Transparency ~= 1 then
                if (workspace.Flower2.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (workspace.Flower2.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Flower2.CFrame
                    end
                else
                    Farmtween = toTarget(workspace.Flower2.Position, workspace.Flower2.CFrame)
                end
            end
            if game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 3') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Swan Pirate [Lv. 775]') then
                StartMagnetSwan = false

                if (CFrame.new(1057.92761, 137.614319, 1242.08069).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(1057.92761, 137.614319, 1242.08069).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1057.92761, 137.614319, 1242.08069)
                    end
                else
                    Farmtween = toTarget(CFrame.new(1057.92761, 137.614319, 1242.08069).Position, CFrame.new(1057.92761, 137.614319, 1242.08069))
                end
            end

            local v894, v895, v896 = pairs(game.Workspace.Enemies:GetChildren())
            local v897

            v789, v897 = v787(v788, v789)

            if v789 == nil then
            end
            if StartKaiTun and (v897.Name == 'Cursed Captain [Lv. 1325] [Raid Boss]' and (v897:FindFirstChild('HumanoidRootPart') and (v897:FindFirstChild('Humanoid') and v897.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v897.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v897.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v897.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v897.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v897.Parent and v897.Humanoid.Health > 0) then
            else
            end

            Usefastattack = false

            if true then
                task.wait()

                if (v898.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v898.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v898.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v898.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v898.Parent and v898.Humanoid.Health > 0) then
            end

            Usefastattack = false

            local v898

            v798, v898 = v796(v797, v798)

            if v798 == nil then
            end
            if StartKaiTun and (v898.Name == 'Darkbeard [Lv. 1000] [Raid Boss]' and (v898:FindFirstChild('HumanoidRootPart') and (v898:FindFirstChild('Humanoid') and v898.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait(0.1)

                if (v899.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v899.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v899.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v899.HumanoidRootPart.Position, v899.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v899.Humanoid.Health > 0 and v899.Parent) then
            end

            Usefastattack = false

            local v899

            v792, v899 = v790(v791, v792)

            if v792 == nil then
            end
            if StartKaiTun and (v899.Name == 'Core' and (v899:FindFirstChild('Humanoid') and v899.Humanoid.Health > 0)) then
            else
            end
            if true then
                task.wait()

                if (v900.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v900.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v900.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v900.HumanoidRootPart.CFrame)
                end
            end
            if v900.Parent and (v900.Humanoid.Health > 0 and StartKaiTun ~= false) then
            end

            Usefastattack = false

            local v900

            v803, v900 = v801(v802, v803)

            if v803 == nil then
            end
            if v900.Name ~= 'Jeremy [Lv. 850] [Boss]' or (not v900:FindFirstChild('HumanoidRootPart') or (not v900:FindFirstChild('Humanoid') or v900.Humanoid.Health <= 0)) then
            else
            end
            if true then
                task.wait()

                if (v901.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v901.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        StartMagnetSwan = true
                        PosMon = v901.HumanoidRootPart.CFrame

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v901.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v901.HumanoidRootPart.Position, v901.HumanoidRootPart.CFrame)
                end
            end
            if v901.Parent and (v901.Humanoid.Health > 0 and StartKaiTun ~= false) and not game.Players.LocalPlayer.Backpack:FindFirstChild('Flower 3') then
            end

            StartMagnetSwan = false
            Usefastattack = false

            local v901

            v896, v901 = v894(v895, v896)

            if v896 == nil then
            end
            if StartKaiTun and (v901.Name == 'Swan Pirate [Lv. 775]' and (v901:FindFirstChild('Humanoid') and v901.Humanoid.Health >= 0)) then
            else
            end
            if true then
                task.wait()

                if (v902.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v902.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        PosMon = v902.HumanoidRootPart.CFrame

                        EquipWeapon()

                        Usefastattack = true
                        StartMagnetSnowLurker = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v902.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v902.HumanoidRootPart.CFrame)
                    StartMagnetSnowLurker = false
                end
            end
            if not game.Players.LocalPlayer.Backpack:FindFirstChild('Hidden Key') and (StartKaiTun ~= false and (v902.Parent and v902.Humanoid.Health > 0)) then
            end

            StartMagnetSnowLurker = false
            Usefastattack = false

            local v902

            v810, v902 = v808(v809, v810)

            if v810 == nil then
            end
            if StartKaiTun and (v902.Name == 'Snow Lurker [Lv. 1375]' and (v902:FindFirstChild('Humanoid') and (v902:FindFirstChild('HumanoidRootPart') and v902.Humanoid.Health > 0))) then
            else
            end

            Com('F_', 'Awakener', 'Check')
            Com('F_', 'Awakener', 'Awaken')

            if StartKaiTun == false or (not game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false) then
                task.wait(5)

                for _ = 1, 5 do
                    Com('F_', 'Awakener', 'Check')
                    Com('F_', 'Awakener', 'Awaken')
                    task.wait(0.5)
                end
            end
            if false then
            end

            task.wait()

            if game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2') or game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1')))) then
                GoIsland = false

                NextIsland()

                if GoIsland ~= false then
                    if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Farmtween then
                                Farmtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
                        end
                    else
                        Farmtween = toTarget(ToIslandCFrame)
                    end
                else
                    task.wait(0.1)
                end
            end

            local v903, v904, v905 = pairs(game.Workspace.Enemies:GetChildren())
            local v906

            v905, v906 = v903(v904, v905)

            if v905 == nil then
            end
            if StartKaiTun and (v906:FindFirstChild('Humanoid') and v906:FindFirstChild('HumanoidRootPart')) and (v906.HumanoidRootPart.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
            else
            end

            task.wait()

            if not v910:FindFirstChild('Humanoid') then
                return
            end

            v910.Humanoid.Health = 0

            if StartKaiTun and (v910.Humanoid.Health > 0 and v910.Parent) then
            else
            end

            Com('F_', 'Awakener', 'Check')
            Com('F_', 'Awakener', 'Awaken')

            if StartKaiTun == false or (not game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false) then
                task.wait(5)

                for _ = 1, 5 do
                    Com('F_', 'Awakener', 'Check')
                    Com('F_', 'Awakener', 'Awaken')
                    task.wait(0.5)
                end
            end
            if false then
            end

            task.wait()

            if game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2') or game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1')))) then
                GoIsland = false

                NextIsland()

                if GoIsland ~= false then
                    if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Farmtween then
                                Farmtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
                        end
                    else
                        Farmtween = toTarget(ToIslandCFrame)
                    end
                else
                    task.wait(0.1)
                end
            end

            local v907, v908, v909 = pairs(game.Workspace.Enemies:GetChildren())
            local v910

            v909, v910 = v907(v908, v909)

            if v909 == nil then
            end
            if StartKaiTun and (v910:FindFirstChild('Humanoid') and v910:FindFirstChild('HumanoidRootPart')) and (v910.HumanoidRootPart.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
            else
            end
        end
        function AutoKaiTunThreeWorld(p911, p912, p913, p914)
            if inmyself('Fire Essence') and Com('F_', 'BuyDragonTalon', true) == 3 then
                Com('F_', 'BuyDragonTalon')
            end
            if AutoHallowScythe and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and inmyself('Hallow Essence')) then
                Questtween = toTarget(game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.CFrame)

                if (game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.CFrame
                end
            end
            if AutoCDK and 2200 <= p913 then
            end
            if not CheckMobDistanceCollection(Vector3.new(-5545.8134765625, 313.7655944824219, -2978.4912109375), 1000) then
            end

            local v915, v916, v917 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))

            while true do
                local v918

                v917, v918 = v915(v916, v917)

                if v917 == nil then
                end
                if not StartKaiTun or (tostring(v918.Name):match('%[Boss]$') or (not tostring(v918.Name):find('%[Lv.') or (not v918:FindFirstChild('HumanoidRootPart') or (v918.HumanoidRootPart.Position - Vector3.new(-5545.8134765625, 313.7655944824219, -2978.4912109375)).Magnitude > 1000))) then
                end
                if true then
                    task.wait()

                    if (v918.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v918.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Farmtween then
                                Farmtween:Stop()
                            end

                            Usefastattack = true
                            PosCursedDualKatana = v918.HumanoidRootPart.CFrame

                            EquipWeapon()

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v918.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                            MagnetPirateCas = true
                        end
                    else
                        Farmtween = toTarget(v918.HumanoidRootPart.Position, v918.HumanoidRootPart.CFrame)
                        Usefastattack = false
                    end
                end
                if StartKaiTun and (v918.Parent and v918.Humanoid.Health > 0) then
                end

                Usefastattack = false
                MagnetPirateCas = false
            end

            if true then
                task.wait()

                if (v920.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v920.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        PosMon = v920.HumanoidRootPart.CFrame
                        StartMagnetHaze = true

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v920.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v920.HumanoidRootPart.CFrame * CFrame.new(1, 20, 0))
                    Usefastattack = false
                end
            end
            if StartKaiTun and (v920.Humanoid.Health > 0 and v920.Parent) then
            end

            Usefastattack = false
            StartMagnetHaze = false

            local v919, v920 = v1058(v1059, v919)

            if v919 == nil then
            end
            if v920:FindFirstChild('HazeESP') and (StartKaiTun and (v920:FindFirstChild('Humanoid') and v920:FindFirstChild('HumanoidRootPart'))) then
            else
            end
            if true then
                task.wait()

                if (u926.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (u926.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        spawn(function()
                            NoDupeMob = 0.1

                            local v921, v922, v923 = pairs(game.Workspace.Enemies:GetChildren())

                            while true do
                                local v924

                                v923, v924 = v921(v922, v923)

                                if v923 == nil then
                                    break
                                end
                                if InMyNetWork(u926.HumanoidRootPart) and v924.Name == u926.Name and (u926:FindFirstChild('Humanoid') and u926:FindFirstChild('HumanoidRootPart')) then
                                    v924.HumanoidRootPart.CFrame = u926.HumanoidRootPart.CFrame * CFrame.new(NoDupeMob, 0, 0)
                                    v924.HumanoidRootPart.CanCollide = false
                                    v924.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                                    NoDupeMob = NoDupeMob + 0.2
                                end
                            end
                        end)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = u926.HumanoidRootPart.CFrame * CFrame.new(1, 30, 1)

                        EquipWeapon()

                        Usefastattack = true
                    end
                else
                    Farmtween = toTarget(u926.HumanoidRootPart.CFrame * CFrame.new(1, 20, 0))
                    Usefastattack = false
                end
            end
            if StartKaiTun and (game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health ~= 0 and (u926.Humanoid.Health ~= 0 and u926.Parent)) then
            end

            Usefastattack = false

            local v925, u926 = v1050(v1051, v925)

            if v925 == nil then
            end
            if StartKaiTun and (u926:FindFirstChild('Humanoid') and (u926:FindFirstChild('HumanoidRootPart') and u926.Humanoid.Health > 0)) then
            else
            end
            if true then
                task.wait()

                if (v928.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v928.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        Usefastattack = true
                        PosCursedDualKatana = v928.HumanoidRootPart.CFrame

                        EquipWeapon()

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v928.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v928.HumanoidRootPart.Position, v928.HumanoidRootPart.CFrame)
                    Usefastattack = false
                end
            end
            if StartKaiTun and (v928.Parent and v928.Humanoid.Health > 0) then
            end

            Usefastattack = false

            local v927, v928 = v1060(v1061, v927)

            if v927 == nil then
            end
            if StartKaiTun and (not tostring(v928.Name):match('%[Boss]$') and (tostring(v928.Name):find('%[Lv.') and (v928:FindFirstChild('HumanoidRootPart') and (v928.HumanoidRootPart.Position - Vector3.new(-5545.8134765625, 313.7655944824219, -2978.4912109375)).Magnitude <= 1000))) then
            else
            end
            if true then
                task.wait()

                if (v930.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v930.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v930.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v930.HumanoidRootPart.Position, v930.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v930.Parent and (v930.Humanoid.Health > 0 and p912.Visible ~= false)) then
            end

            Usefastattack = false

            local v929, v930 = v1030(v1031, v929)

            if v929 == nil then
            end
            if StartKaiTun and (v930.Name == 'Island Empress [Lv. 1675] [Boss]' and (v930:FindFirstChild('Humanoid') and (v930:FindFirstChild('HumanoidRootPart') and v930.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v932.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v932.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        v932.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                        Usefastattack = true

                        toAroundTarget(v932.HumanoidRootPart.CFrame)
                    end
                else
                    Farmtween = toTarget(v932.HumanoidRootPart.Position, v932.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v932.Parent and v932.Humanoid.Health > 0) and not game:GetService('ReplicatedStorage'):FindFirstChild('Dough King [Lv. 2300] [Raid Boss]') then
            end

            Usefastattack = false

            local v931, v932 = v944(v945, v931)

            if v931 == nil then
            end
            if StartKaiTun and (v932.Name == 'Dough King [Lv. 2300] [Raid Boss]' and (v932:FindFirstChild('HumanoidRootPart') and (v932:FindFirstChild('Humanoid') and v932.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v934.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v934.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v934.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v934.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                end
            end
            if StartKaiTun and (v934.Parent and v934.Humanoid.Health > 0) then
            end

            Usefastattack = false

            local v933, v934 = v987(v988, v933)

            if v933 == nil then
            end
            if StartKaiTun and (string.find(v934.Name, 'Diablo') or (string.find(v934.Name, 'Urban') or string.find(v934.Name, 'Deandre'))) and (v934:FindFirstChild('Humanoid') and (v934:FindFirstChild('HumanoidRootPart') and v934.Humanoid.Health > 0)) then
            else
            end
            if true then
                task.wait()

                if (v936.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v936.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v936.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v936.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v936.Parent and v936.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v935, v936 = v976(v977, v935)

            if v935 == nil then
            end
            if StartKaiTun and (v936.Name == 'Beautiful Pirate [Lv. 1950] [Boss]' and (v936:FindFirstChild('HumanoidRootPart') and (v936:FindFirstChild('Humanoid') and v936.Humanoid.Health > 0))) then
            else
            end

            task.wait()

            if not v1086:FindFirstChild('Humanoid') then
                return
            end

            v1086.Humanoid.Health = 0

            if StartKaiTun and (v1086.Humanoid.Health > 0 and v1086.Parent) then
            else
            end
            if not AutoRainbowHaki or (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or (tostring(Com('F_', 'HornedMan')) == '1' or not CheckMobRainBowHaki())) then
            end

            ShowDoingStatus('Do Rainbow haki')
            Com('F_', 'HornedMan', 'Bet')

            if not string.find(p911.Text, 'Stone') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Stone [Lv. 1550] [Boss]') then
                if (CFrame.new(-1134, 40, 6877).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if (CFrame.new(-1134, 40, 6877).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if HakiRainbowTween then
                            HakiRainbowTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1134, 40, 6877)
                    end
                else
                    HakiRainbowTween = toTarget(CFrame.new(-1134, 40, 6877).Position, CFrame.new(-1134, 40, 6877))
                end
            end

            local v937, v938, v939 = pairs(game.Workspace.Enemies:GetChildren())

            if not AutoHallowScythe or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or not (game:GetService('Workspace').Enemies:FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]')) then
            end

            ShowDoingStatus('Kill Soul Reaper')

            if not game.Workspace.Enemies:FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]') then
                    local v940 = CFrame.new(-9515.62109, 315.925537, 6691.12012)

                    if (v940.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v940.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v940
                        end
                    else
                        Questtween = toTarget(v940)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v941, v942, v943 = pairs(game.Workspace.Enemies:GetChildren())

            if (not AutoDoughKing or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false or not game.Workspace:FindFirstChild('Enemies'):FindFirstChild('Dough King [Lv. 2300] [Raid Boss]')) and not game:GetService('ReplicatedStorage'):FindFirstChild('Dough King [Lv. 2300] [Raid Boss]') then
            end

            ShowDoingStatus('Kill Dough King')

            if not game:GetService('Workspace').Enemies:FindFirstChild('Dough King [Lv. 2300] [Raid Boss]') then
                if game:GetService('Workspace').Map.CakeLoaf.BigMirror.Other.Transparency == 0 then
                    Usefastattack = false
                    Questtween = toTarget(CFrame.new(-2151.82153, 149.315704, -12404.9053).Position, CFrame.new(-2151.82153, 149.315704, -12404.9053))

                    if (CFrame.new(-2151.82153, 149.315704, -12404.9053).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2151.82153, 149.315704, -12404.9053)

                        task.wait(2)
                    end
                end
            end

            local v944, v945

            v944, v945, v931 = pairs(game.Workspace.Enemies:GetChildren())

            if not AutoBuddySword or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false then
            end

            local v946 = u537

            if not (string.find(v946:Update().Text, u548) and (game:GetService('Workspace').Enemies:FindFirstChild('Cake Queen [Lv. 2175] [Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Cake Queen [Lv. 2175] [Boss]'))) then
            end

            ShowDoingStatus('Kill Cake Queen')

            if not game.Workspace.Enemies:FindFirstChild('Cake Queen [Lv. 2175] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Cake Queen [Lv. 2175] [Boss]') then
                    local v947 = CFrame.new(-821, 66, -10965)

                    if (v947.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v947.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v947
                        end
                    else
                        Questtween = toTarget(v947)
                    end

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v948, v949, v950 = pairs(game.Workspace.Enemies:GetChildren())

            if not AutoSpikeyTrident or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false then
            end

            local v951 = u549

            if not (string.find(v951:Update().Text, u548) and havemob('Cake Prince [Lv. 2300] [Raid Boss]')) then
            end

            ShowDoingStatus('Kill Cake Prince')

            if not game.Workspace.Enemies:FindFirstChild('Cake Prince [Lv. 2300] [Raid Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Cake Prince [Lv. 2300] [Raid Boss]') and game:GetService('Workspace').Map.CakeLoaf.BigMirror.Other.Transparency == 0 then
                    Usefastattack = false
                    Questtween = toTarget(CFrame.new(-2151.82153, 149.315704, -12404.9053).Position, CFrame.new(-2151.82153, 149.315704, -12404.9053))

                    if (CFrame.new(-2151.82153, 149.315704, -12404.9053).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2151.82153, 149.315704, -12404.9053)

                        task.wait(0.1)
                    end
                end
            end

            local v952, v953, v954 = pairs(game.Workspace.Enemies:GetChildren())

            if not AutoTushita or (p913 < 2000 or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false) then
            end

            local v955 = u543

            if not string.find(v955:Update().Text, u548) or not (CheckHakiColor('Winter Sky') and (CheckHakiColor('Pure Red') and (CheckHakiColor('Snow White') and inmyself("God's Chalice"))) or inmyself('Holy Torch')) and ((game:GetService('Workspace').Map.Turtle:FindFirstChild('TushitaGate') or not havemob('Longma [Lv. 2000] [Boss]')) and not (havemob('rip_indra True Form [Lv. 5000] [Raid Boss]') or CheckButtonColorOpen() and inmyself("God's Chalice"))) then
            end

            ShowDoingStatus('Do Tushita')

            if not havemob('Longma [Lv. 2000] [Boss]') or game:GetService('Workspace').Map.Turtle:FindFirstChild('TushitaGate') then
                if inmyself('Holy Torch') then
                    task.wait(0.25)
                    EquipWeapon('Holy Torch')
                    task.wait(0.2)

                    for v956 = 1, 5 do
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Turtle.QuestTorches['Torch' .. tostring(v956)].CFrame

                        task.wait(0.2)
                    end
                elseif inmyself("God's Chalice") and CheckButtonColorOpen() then
                    EquipWeapon("God's Chalice")

                    ChaliceTween = toTarget(CFrame.new(-5560.27295, 313.915466, -2663.89795))

                    ChaliceTween:Wait()
                    task.wait(0.5)

                    ChaliceTween = toTarget(CFrame.new(5148.03613, 162.352493, 910.548218))

                    ChaliceTween:Wait()
                    task.wait(0.3)
                elseif inmyself("God's Chalice") and not CheckButtonColorOpen() or CheckHakiColor('Winter Sky') and (CheckHakiColor('Pure Red') and CheckHakiColor('Snow White')) then
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Winter Sky')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-5420.16602, 1084.9657, -2666.8208, 0.390717864, 0, 0.92051065, 0, 1, 0, -0.92051065, 0, 0.390717864))

                    ChaliceTween:Wait()
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Pure Red')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-5414.41357, 309.865753, -2212.45776, 0.374604106, 0, -0.92718488, 0, 1, 0, 0.92718488, 0, 0.374604106))

                    ChaliceTween:Wait()
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Snow White')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-4971.47559, 331.565765, -3720.02954, -0.92051065, 0, 0.390717506, 0, 1, 0, -0.390717506, 0, -0.92051065))

                    ChaliceTween:Wait()
                end
            end
            if not game.Workspace.Enemies:FindFirstChild('Longma [Lv. 2000] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Longma [Lv. 2000] [Boss]') then
                    local v957 = CFrame.new(-10248.3936, 353.79129, -9306.34473)

                    if (v957.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v957.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v957
                        end
                    else
                        Questtween = toTarget(v957)
                    end

                    Usefastattack = false
                end
            end
            if RipTween then
                RipTween:Stop()
            end

            local v958, v959, v960 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            if true then
                task.wait()

                if (v962.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v962.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        Usefastattack = true
                        PosMon = v962.HumanoidRootPart.CFrame

                        EquipWeapon(SelectToolWeapon)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v962.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        MagnetFarmCakePrince = true

                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('CakePrinceSpawner', true)
                        game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('CakePrinceSpawner')
                    end
                else
                    Farmtween = toTarget(v962.HumanoidRootPart.Position, v962.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v962.Parent and v962.Humanoid.Health > 0) then
            end

            Usefastattack = false
            MagnetFarmCakePrince = false

            local v961, v962 = v978(v979, v961)

            if v961 == nil then
            end
            if StartKaiTun and (v962.Name == 'Cookie Crafter [Lv. 2200]' or (v962.Name == 'Cake Guard [Lv. 2225]' or (v962.Name == 'Baking Staff [Lv. 2250]' or v962.Name == 'Head Baker [Lv. 2275]'))) and (v962:FindFirstChild('HumanoidRootPart') and (v962:FindFirstChild('Humanoid') and v962.Humanoid.Health > 0)) then
            else
            end
            if true then
                task.wait()

                if (v964.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v964.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v964.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v964.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v964.Parent and v964.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v963, v964 = v1027(v1028, v963)

            if v963 == nil then
            end
            if StartKaiTun and (v964.Name == 'rip_indra True Form [Lv. 5000] [Raid Boss]' and (v964:FindFirstChild('HumanoidRootPart') and (v964:FindFirstChild('Humanoid') and v964.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v966.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v966.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        MagnetFarmSoulGuitar = true

                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        v966.HumanoidRootPart.CFrame = CFrame.new(-10139.9404296875, 138.6524658203125, 5963.72216796875)
                        v966.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10139.9404296875, 168.6524658203125, 5983.72216796875)

                        task.wait(0.2)

                        Usefastattack = true
                    end
                else
                    Farmtween = toTarget(v966.HumanoidRootPart.Position, v966.HumanoidRootPart.CFrame)
                    MagnetFarmSoulGuitar = true
                end
            end
            if StartKaiTun and (v966.Parent and (v966.Humanoid.Health > 0 and havemob('Living Zombie [Lv. 2000]'))) then
            end

            Usefastattack = false
            MagnetFarmSoulGuitar = false

            local v965, v966 = v990(v991, v965)

            if v965 == nil then
            end
            if StartKaiTun and (v966.Name == 'Living Zombie [Lv. 2000]' and (v966:FindFirstChild('HumanoidRootPart') and (v966:FindFirstChild('Humanoid') and v966.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (u972.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (u972.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        spawn(function()
                            NoDupeMob = 0.1

                            local v967, v968, v969 = pairs(game.Workspace.Enemies:GetChildren())

                            while true do
                                local v970

                                v969, v970 = v967(v968, v969)

                                if v969 == nil then
                                    break
                                end
                                if InMyNetWork(u972.HumanoidRootPart) and v970.Name == u972.Name and (u972:FindFirstChild('Humanoid') and u972:FindFirstChild('HumanoidRootPart')) then
                                    v970.HumanoidRootPart.CFrame = u972.HumanoidRootPart.CFrame * CFrame.new(NoDupeMob, 0, 0)
                                    v970.HumanoidRootPart.CanCollide = false
                                    v970.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                                    NoDupeMob = NoDupeMob + 0.2
                                end
                            end
                        end)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = u972.HumanoidRootPart.CFrame * CFrame.new(1, 30, 1)

                        EquipWeapon()

                        Usefastattack = true
                    end
                else
                    Farmtween = toTarget(u972.HumanoidRootPart.Position, u972.HumanoidRootPart.CFrame)
                    Usefastattack = false
                end
            end
            if StartKaiTun and (game.Players.LocalPlayer.Character:WaitForChild('Humanoid').Health ~= 0 and (u972.Humanoid.Health ~= 0 and u972.Parent)) then
            end

            Usefastattack = false

            task.wait()

            local v971, u972 = v1072(v1073, v971)

            if v971 == nil then
            end
            if StartKaiTun and (u972:FindFirstChild('Humanoid') and (u972:FindFirstChild('HumanoidRootPart') and u972.Humanoid.Health > 0)) then
            else
            end
            if (AutoEliteHunter or (AutoTushita or (game.Players.LocalPlayer.Data.DevilFruit.Value == 'Dough-Dough' or AutoCDK))) and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and (game.Workspace.Enemies:FindFirstChild('Deandre [Lv. 1750]') or (game.Workspace.Enemies:FindFirstChild('Urban [Lv. 1750]') or (game.Workspace.Enemies:FindFirstChild('Diablo [Lv. 1750]') or (game.ReplicatedStorage:FindFirstChild('Deandre [Lv. 1750]') or (game.ReplicatedStorage:FindFirstChild('Urban [Lv. 1750]') or game.ReplicatedStorage:FindFirstChild('Diablo [Lv. 1750]')))))) then
            end
            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and (p913 < 2000 and (inmyself("God's Chalice") or inmyself('Sweet Chalice'))) and GetMaterial('Mirror Fractal') < 1 then
            end
            if AutoRipIndra and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and (game.Workspace.Enemies:FindFirstChild('rip_indra True Form [Lv. 5000] [Raid Boss]') or (game.ReplicatedStorage:FindFirstChild('rip_indra True Form [Lv. 5000] [Raid Boss]') or inmyself("God's Chalice") and (CheckButtonColorOpen() or CheckHakiColor('Winter Sky') and (CheckHakiColor('Pure Red') and CheckHakiColor('Snow White'))))) then
            end
            if (AutoYama or AutoCDK) and Com('F_', 'EliteHunter', 'Progress') >= 30 then
                local v973 = u546

                if not string.find(v973:Update().Text, u548) then
                end

                ShowDoingStatus('Do Yama')
                fireclickdetector(game.Workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
                pcall(RefreshStatus)
            end
            if not AutoCanvander or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= false then
            end

            local v974 = u545

            if not (string.find(v974:Update().Text, u548) and (game:GetService('Workspace').Enemies:FindFirstChild('Beautiful Pirate [Lv. 1950] [Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Beautiful Pirate [Lv. 1950] [Boss]'))) then
            end

            ShowDoingStatus('Kill Beautiful Pirate')

            if not game.Workspace.Enemies:FindFirstChild('Beautiful Pirate [Lv. 1950] [Boss]') then
                if game.ReplicatedStorage:FindFirstChild('Beautiful Pirate [Lv. 1950] [Boss]') then
                    local v975 = CFrame.new(5182, 23, -20)

                    Questtween = toTarget(v975)

                    Com('F_', 'SetSpawnPoint')
                end
            end

            local v976, v977

            v976, v977, v935 = pairs(game.Workspace.Enemies:GetChildren())

            if not inmyself('Sweet Chalice') then
            end

            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('CakePrinceSpawner', true)
            game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer('CakePrinceSpawner')

            if not (game:GetService('Workspace').Enemies:FindFirstChild('Cookie Crafter [Lv. 2200]') or (game:GetService('Workspace').Enemies:FindFirstChild('Cake Guard [Lv. 2225]') or (game:GetService('Workspace').Enemies:FindFirstChild('Baking Staff [Lv. 2250]') or game:GetService('Workspace').Enemies:FindFirstChild('Head Baker [Lv. 2275]')))) then
                MagnetFarmCakePrince = false
                Usefastattack = false
                Questtween = toTarget(CFrame.new(-2077, 252, -12373).Position, CFrame.new(-2077, 252, -12373))

                if (CFrame.new(-2077, 252, -12373).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2077, 252, -12373)
                end
            end

            local v978, v979

            v978, v979, v961 = pairs(game.Workspace.Enemies:GetChildren())

            if inmyself("God's Chalice") and GetMaterial('Conjured Cocoa') >= 10 then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer('SweetChaliceNpc')
                task.wait(0.2)
            end
            if not (game:GetService('Workspace').Enemies:FindFirstChild('Candy Rebel [Lv. 2375]') or (game:GetService('Workspace').Enemies:FindFirstChild('Sweet Thief [Lv. 2350]') or (game:GetService('Workspace').Enemies:FindFirstChild('Chocolate Bar Battler [Lv. 2325]') or game:GetService('Workspace').Enemies:FindFirstChild('Cocoa Warrior [Lv. 2300]')))) then
                MagnetFarmCoco = false
                Usefastattack = false
                Questtween = toTarget(CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625))

                if (CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
                end
            end

            local v980, v981, v982 = pairs(game.Workspace.Enemies:GetChildren())

            ShowDoingStatus('Kill Elite')

            if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                Com('F_', 'EliteHunter')
            end
            if not (string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Diablo') or (string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Urban') or string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, 'Deandre'))) then
                Com('F_', 'EliteHunter')
            end

            local v983, v984, v985 = pairs(game:GetService('ReplicatedStorage'):GetChildren())

            while true do
                local v986

                v985, v986 = v983(v984, v985)

                if v985 == nil then
                    break
                end
                if string.find(v986.Name, 'Diablo') or (string.find(v986.Name, 'Urban') or string.find(v986.Name, 'Deandre')) then
                    TushitaTween = toTarget(v986.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

                    if (v986.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if TushitaTween then
                            TushitaTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v986.HumanoidRootPart.CFrame
                    end
                end
            end

            local v987, v988

            v987, v988, v933 = pairs(game.Workspace.Enemies:GetChildren())

            if p913 < 2300 or not AutoSoulGuitar then
            end

            local v989 = u544

            if not string.find(v989:Update().Text, u548) or (Com('F_', 'GuitarPuzzleProgress', 'Check') == nil or Com('F_', 'GuitarPuzzleProgress', 'Check').Pipes ~= false) and (Com('F_', 'GuitarPuzzleProgress', 'Check') ~= nil or (game:GetService('Lighting'):GetAttribute('MoonPhase') ~= 5 or not CheckNight())) then
            end

            ShowDoingStatus('Do Soul Guitar')

            CheckGuitar = Com('F_', 'GuitarPuzzleProgress', 'Check')

            if CheckGuitar == nil then
                GuitarTween = toTarget(CFrame.new(-8654.7158203125, 141.83416748046875, 6169.04150390625))

                GuitarTween:Wait()
                Com('F_', 'gravestoneEvent', 2, true)
            end
            if CheckGuitar.Swamp ~= false then
                if CheckGuitar.Gravestones ~= false then
                    if CheckGuitar.Ghost ~= false then
                        if CheckGuitar.Trophies ~= false then
                            if CheckGuitar.Pipes == false then
                                Com('F_', 'GuitarPuzzleProgress', 'Pipes')
                            end
                        else
                            Com('F_', 'GuitarPuzzleProgress', 'Trophies')
                        end
                    else
                        Com('F_', 'GuitarPuzzleProgress', 'Ghost')
                    end
                else
                    Com('F_', 'GuitarPuzzleProgress', 'Gravestones')
                end

                task.wait(1)

                MagnetFarmSoulGuitar = false
            end
            if game:GetService('Workspace').Map['Haunted Castle']:FindFirstChild('SwampWater').Color ~= Color3.fromRGB(117, 0, 0) then
            end
            if not game:GetService('Workspace').Enemies:FindFirstChild('Living Zombie [Lv. 2000]') then
                Usefastattack = false
                MagnetFarmSoulGuitar = false
                Questtween = toTarget(CFrame.new(-10139.9404296875, 148.6524658203125, 5963.72216796875))

                if (CFrame.new(-10139.9404296875, 148.6524658203125, 5963.72216796875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10139.9404296875, 148.6524658203125, 5963.72216796875)

                    task.wait(1)
                end

                task.wait(3)
            end

            local v990, v991

            v990, v991, v965 = pairs(game.Workspace.Enemies:GetChildren())

            if not RaidsDoughNow or (game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough' or (Com('F_', 'CakeScientist', 'Check') ~= true or CheckAwaken())) or not HaveFruitToSea3(alliesfruit) and (p914.HaveFruitInMySelf ~= true or p914.Price < 1000000) and (not inmyself('Special Microchip') and (not CheckIsland() and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true)) or (havemob('rip_indra True Form [Lv. 5000] [Raid Boss]') or (StopRaidsPls or p913 < 1100)) then
            end

            ShowDoingStatus('Doing Raids Dough')

            if tween then
                tween:Cancel()
            end
            if not (inmyself('Special Microchip') or CheckIsland()) then
                GoIsland = false

                local _huge4 = math.huge
                local v993 = ''

                if p914.HaveFruitInMySelf ~= true or p914.Price < 1000000 or (game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value >= 5000 or p914.HaveFruitInStore ~= false) then
                    if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 4000 then
                        local v994, v995, v996 = pairs(Com('F_', 'getInventoryFruits'))

                        while true do
                            local v997, v998 = v994(v995, v996)

                            if v997 == nil then
                                break
                            end

                            v996 = v997

                            if not v998.Price then
                                break
                            end
                            if v998.Price < RateFruitRaids and v998.Price < _huge4 then
                                _huge4 = v998.Price
                                v993 = v998.Name
                            end
                        end

                        if v993 ~= '' then
                            Com('F_', 'LoadFruit', v993)
                        end

                        Com('F_', 'RaidsNpc', 'Select', 'Flame')
                    else
                        local v999, v1000, v1001 = pairs(Com('F_', 'getInventoryFruits'))

                        while true do
                            local v1002, v1003 = v999(v1000, v1001)

                            if v1002 == nil then
                                break
                            end

                            v1001 = v1002

                            if not v1003.Price then
                                break
                            end
                            if v1003.Price >= 1000000 and (not table.find(alliesfruit, v1003.Name) and v1003.Price < _huge4) then
                                _huge4 = v1003.Price
                                v993 = v1003.Name
                            end
                        end

                        if v993 ~= '' then
                            Com('F_', 'LoadFruit', v993)
                        end

                        Com('F_', 'RaidsNpc', 'Select', 'Dough')
                    end
                else
                    StoreMyFruit()
                end

                Com('F_', 'Awakener', 'Check')
                Com('F_', 'Awakener', 'Awaken')
            end
            if inmyself('Special Microchip') and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and CheckIsland() == false) then
                if u76 then
                    fireclickdetector(_Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif u77 then
                    fireclickdetector(_Workspace.Map['Boat Castle'].RaidSummon2.Button.Main.ClickDetector)
                end

                task.wait(17)
            end
            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true then
            end

            task.wait()

            if v1005:FindFirstChild('HumanoidRootPart') and v1005:FindFirstChild('Humanoid') then
                if (v1005.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1005.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if FarmtoTarget then
                            FarmtoTarget:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        StartMagnetFarmLevel = true
                        PosMon = v1005.HumanoidRootPart.CFrame

                        toAroundTarget(v1005.HumanoidRootPart.CFrame)
                    end
                else
                    FarmtoTarget = toTarget(v1005.HumanoidRootPart.Position, v1005.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))
                end
            end
            if game:GetService('Workspace').Enemies:FindFirstChild(Monster) and (StartKaiTun and (string.find(p911.Text, NameCheckQuest) and (v1005.Humanoid.Health > 0 and (v1005.Parent and p912.Visible ~= false)))) then
            end

            Usefastattack = false
            StartMagnetFarmLevel = false

            local v1004, v1005 = v1024(v1025, v1004)

            if v1004 == nil then
            end
            if StartKaiTun and (v1005.Name == Monster and (v1005:FindFirstChild('HumanoidRootPart') and (v1005:FindFirstChild('Humanoid') and v1005.Humanoid.Health > 0))) then
            else
            end
            if string.find(p911.Text, NameCheckQuest) then
            end

            Com('F_', 'AbandonQuest')

            if havemob('rip_indra True Form [Lv. 5000] [Raid Boss]') or (p914.HaveFruitInMySelf ~= true or p914.HaveFruitInStore ~= true) and (not (RaidsNow and CheckRateFruit(RateFruitRaids)) and (not inmyself('Special Microchip') and (not CheckIsland() and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true))) or (p913 < 1100 or StopRaidsPls) then
            end
            if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value > (LimitRaidsFrag or 100000) and (p914.HaveFruitInMySelf == true and game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough') then
                game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                return
            end

            ShowDoingStatus('Doing Raids')

            if tween then
                tween:Cancel()
            end
            if not (inmyself('Special Microchip') or CheckIsland()) then
                GoIsland = false

                if game.Players.LocalPlayer.Data.DevilFruit.Value == 'Dough-Dough' and not (CheckAwaken() or RaidsNow) then
                    if Com('F_', 'CakeScientist', 'Check') ~= true or p914.HaveFruitInMySelf ~= false or game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 1000 then
                        if Com('F_', 'CakeScientist', 'Check') ~= true or (p914.HaveFruitInMySelf ~= true or p914.Price < 1000000) then
                            Com('F_', 'RaidsNpc', 'Select', GetNameRaids())
                        else
                            Com('F_', 'RaidsNpc', 'Select', 'Dough')
                        end
                    else
                        Com('F_', 'RaidsNpc', 'Select', 'Dough')
                    end

                    return
                end
                if RaidsNow then
                    local _huge5 = math.huge
                    local v1007, v1008, v1009 = pairs(Com('F_', 'getInventoryFruits'))
                    local v1010 = ''

                    while true do
                        local v1011, v1012 = v1007(v1008, v1009)

                        if v1011 == nil then
                            break
                        end

                        v1009 = v1011

                        if not v1012.Price then
                            break
                        end
                        if v1012.Price < RateFruitRaids and v1012.Price < _huge5 then
                            _huge5 = v1012.Price
                            v1010 = v1012.Name
                        end
                    end

                    if v1010 ~= '' then
                        Com('F_', 'LoadFruit', v1010)
                    end
                end

                Com('F_', 'RaidsNpc', 'Select', GetNameRaids(p914))
                Com('F_', 'Awakener', 'Check')
                Com('F_', 'Awakener', 'Awaken')
            end
            if inmyself('Special Microchip') and (game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and CheckIsland() == false) then
                if u76 then
                    fireclickdetector(_Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif u77 then
                    fireclickdetector(_Workspace.Map['Boat Castle'].RaidSummon2.Button.Main.ClickDetector)
                end

                task.wait(17)
            end
            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true then
            end
            if (function()
                local v1013, v1014, v1015 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v1016

                    v1015, v1016 = v1013(v1014, v1015)

                    if v1015 == nil then
                        break
                    end
                    if v1016:IsA('Tool') and string.find(v1016.Name, 'Fruit') then
                        return true
                    end
                end

                return false
            end)() then
                local v1017, v1018, v1019 = pairs(game:GetService('Workspace'):GetChildren())

                while true do
                    local v1020

                    v1019, v1020 = v1017(v1018, v1019)

                    if v1019 == nil then
                        break
                    end
                    if v1020:IsA('Tool') and (string.find(v1020.Name, 'Fruit') and StartKaiTun) then
                        if FruitTarget then
                            FruitTarget:Stop()
                        end

                        repeat
                            task.wait(0.1)

                            FruitTarget = toTarget(v1020.Handle.CFrame)
                        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v1020.Handle.Position).Magnitude <= 8 or not (StartKaiTun and v1020.Parent)

                        task.wait(0.5)
                        StoreMyFruit()
                    end
                end
            end
            if u50 > p913 then
            end

            ShowDoingStatus('Auto Farm Mastery')

            if not (game:GetService('Workspace').Enemies:FindFirstChild('Reborn Skeleton [Lv. 1975]') or (game:GetService('Workspace').Enemies:FindFirstChild('Living Zombie [Lv. 2000]') or (game:GetService('Workspace').Enemies:FindFirstChild('Demonic Soul [Lv. 2025]') or game:GetService('Workspace').Enemies:FindFirstChild('Posessed Mummy [Lv. 2050]')))) then
                StartMagnetFarmLevelMax = false
                Usefastattack = false

                if (CFrame.new(-9506, 172, 6101).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrame.new(-9506, 172, 6101).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Modstween then
                            Modstween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9506, 172, 6101)
                    end
                else
                    Modstween = toTarget(CFrame.new(-9506, 172, 6101))
                end
            end

            local v1021, v1022, v1023 = pairs(game.Workspace.Enemies:GetChildren())

            ShowDoingStatus('Auto Farm')

            if not string.find(p911.Text, NameCheckQuest) then
                Com('F_', 'AbandonQuest')
            end
            if p912.Visible == false then
                Usefastattack = false
                StartMagnetFarmLevel = false

                if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest

                        task.wait(0.95)
                        Com('F_', 'StartQuest', NameQuest, LevelQuest)
                        Com('F_', 'SetSpawnPoint')
                    end
                else
                    Questtween = toTarget(CFrameQuest)
                end
            end
            if p912.Visible ~= true then
                return
            end
            if not game:GetService('Workspace').Enemies:FindFirstChild(Monster) then
                StartMagnetFarmLevel = false
                Usefastattack = false

                if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Modstween then
                            Modstween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon

                        task.wait(0.314285714286)
                    end
                else
                    Modstween = toTarget(CFrameMon)
                end
            end

            local v1024, v1025

            v1024, v1025, v1004 = pairs(game:GetService('Workspace').Enemies:GetChildren())

            ShowDoingStatus('Kill rip_indra')

            if not game.Workspace.Enemies:FindFirstChild('rip_indra True Form [Lv. 5000] [Raid Boss]') then
                if game.ReplicatedStorage:FindFirstChild('rip_indra True Form [Lv. 5000] [Raid Boss]') then
                    local v1026 = CFrame.new(-5359, 424, -2735)

                    if (v1026.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (v1026.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Questtween then
                                Questtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1026
                        end
                    else
                        Questtween = toTarget(v1026)
                    end

                    Com('F_', 'SetSpawnPoint')
                elseif inmyself("God's Chalice") and CheckButtonColorOpen() then
                    EquipWeapon("God's Chalice")

                    ChaliceTween = toTarget(CFrame.new(-5560.27295, 313.915466, -2663.89795))

                    ChaliceTween:Wait()
                    task.wait(0.5)
                    EquipWeapon("God's Chalice")
                    task.wait(0.2)
                elseif inmyself("God's Chalice") and (not CheckButtonColorOpen() or CheckHakiColor('Winter Sky') and (CheckHakiColor('Pure Red') and CheckHakiColor('Snow White'))) then
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Winter Sky')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-5420.16602, 1084.9657, -2666.8208, 0.390717864, 0, 0.92051065, 0, 1, 0, -0.92051065, 0, 0.390717864))

                    ChaliceTween:Wait()
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Pure Red')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-5414.41357, 309.865753, -2212.45776, 0.374604106, 0, -0.92718488, 0, 1, 0, 0.92718488, 0, 0.374604106))

                    ChaliceTween:Wait()
                    task.wait(0.25)
                    Com('F_', 'activateColor', 'Snow White')
                    task.wait(0.25)

                    ChaliceTween = toTarget(CFrame.new(-4971.47559, 331.565765, -3720.02954, -0.92051065, 0, 0.390717506, 0, 1, 0, -0.390717506, 0, -0.92051065))

                    ChaliceTween:Wait()
                end
            end

            local v1027, v1028

            v1027, v1028, v963 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if v1029:FindFirstChild('HumanoidRootPart') and (v1029:FindFirstChild('Humanoid') and (v1029.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150) then
                    Farmtween = toTarget(v1029.HumanoidRootPart.Position, v1029.HumanoidRootPart.CFrame)
                elseif v1029:FindFirstChild('HumanoidRootPart') and (v1029:FindFirstChild('Humanoid') and (v1029.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150) then
                    EquipWeapon()

                    if Farmtween then
                        Farmtween:Stop()
                    end

                    Usefastattack = true
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1029.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                end
            end
            if StartKaiTun and (v1029.Parent and v1029.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v1029

            v960, v1029 = v958(v959, v960)

            if v960 == nil then
            end
            if StartKaiTun and (v1029.Name == 'Longma [Lv. 2000] [Boss]' and (v1029:FindFirstChild('HumanoidRootPart') and (v1029:FindFirstChild('Humanoid') and v1029.Humanoid.Health > 0))) then
            else
            end
            if not string.find(p911.Text, 'Island Empress') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Island Empress [Lv. 1675] [Boss]') then
                if (CFrame.new(5614, 603, 339).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if (CFrame.new(5614, 603, 339).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if HakiRainbowTween then
                            HakiRainbowTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5614, 603, 339)
                    end
                else
                    HakiRainbowTween = toTarget(CFrame.new(5614, 603, 339).Position, CFrame.new(5614, 603, 339))
                end
            end

            local v1030, v1031

            v1030, v1031, v929 = pairs(game.Workspace.Enemies:GetChildren())

            if not string.find(p911.Text, 'Kilo Admiral') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Kilo Admiral [Lv. 1750] [Boss]') then
                if (CFrame.new(2879, 433, -7090).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if (CFrame.new(2879, 433, -7090).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if HakiRainbowTween then
                            HakiRainbowTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2879, 433, -7090)
                    end
                else
                    HakiRainbowTween = toTarget(CFrame.new(2879, 433, -7090).Position, CFrame.new(2879, 433, -7090))
                end
            end

            local v1032, v1033, v1034 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if (v1036.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v1036.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1036.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v1036.HumanoidRootPart.Position, v1036.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v1036.Parent and (v1036.Humanoid.Health > 0 and p912.Visible ~= false)) then
            end

            Usefastattack = false

            local v1035, v1036 = v1040(v1041, v1035)

            if v1035 == nil then
            end
            if StartKaiTun and (v1036.Name == 'Beautiful Pirate [Lv. 1950] [Boss]' and (v1036:FindFirstChild('Humanoid') and (v1036:FindFirstChild('HumanoidRootPart') and v1036.Humanoid.Health > 0))) then
            else
            end
            if not string.find(p911.Text, 'Captain Elephant') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Captain Elephant [Lv. 1875] [Boss]') then
                if (CFrame.new(-13348, 406, -8574).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if (CFrame.new(-13348, 406, -8574).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if HakiRainbowTween then
                            HakiRainbowTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13348, 406, -8574)
                    end
                else
                    HakiRainbowTween = toTarget(CFrame.new(-13348, 406, -8574).Position, CFrame.new(-13348, 406, -8574))
                end
            end

            local v1037, v1038, v1039 = pairs(game.Workspace.Enemies:GetChildren())

            if not string.find(p911.Text, 'Beautiful Pirate') then
            end
            if not game.Workspace.Enemies:FindFirstChild('Beautiful Pirate [Lv. 1950] [Boss]') then
                if (CFrame.new(5206, 23, -80).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if (CFrame.new(5206, 23, -80).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if HakiRainbowTween then
                            HakiRainbowTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5206, 23, -80)
                    end
                else
                    HakiRainbowTween = toTarget(CFrame.new(5206, 23, -80).Position, CFrame.new(5206, 23, -80))
                end
            end

            local v1040, v1041

            v1040, v1041, v1035 = pairs(game.Workspace.Enemies:GetChildren())

            local v1042 = u533

            if not string.find(v1042:Update().Text, u548) then
            end

            local v1043 = u543

            if not string.find(v1043:Update().Text, u547) then
            end

            local v1044 = u546

            if not string.find(v1044:Update().Text, u547) or (GetMasteryWeaponOnline('Yama') < 350 or (GetMasteryWeaponOnline('Tushita') < 350 or CDKCheckAllIn1('done') ~= false)) or (CDKCheckAllIn1('pirate') ~= true or CheckMobDistanceCollection(Vector3.new(-5545.8134765625, 313.7655944824219, -2978.4912109375), 1000) ~= true) and (CDKCheckAllIn1('Heaven') ~= true or not havemob('Cake Queen [Lv. 2175] [Boss]')) and (not game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension') or tostring(game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension'):FindFirstChild('ActivePlayers').Value.Value) ~= game.Players.LocalPlayer.Name) and ((CDKCheckAllIn1('hell') ~= true or not havemob('Soul Reaper [Lv. 2100] [Raid Boss]') and (GetMaterial('Bones') < 50 or (({
                Com('F_', 'Bones', 'Check'),
            })[3] or 0) <= 0) and (not game:GetService('Workspace').Map:FindFirstChild('HellDimension') or tostring(game:GetService('Workspace').Map:FindFirstChild('HellDimension'):FindFirstChild('ActivePlayers').Value.Value) ~= game.Players.LocalPlayer.Name)) and (CDKCheckAllIn1('die') ~= true and (CDKCheckAllIn1('Haze') ~= true and (CDKCheckAllIn1('kill boss') ~= true and CDKCheckAllIn1('boat') ~= true)))) then
            end

            ShowDoingStatus('Do CDK')

            local v1045

            if game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('GoodScroll') then
                v1045 = Com('F_', 'CDKQuest', 'Progress', 'Good')
            else
                v1045 = Com('F_', 'CDKQuest', 'Progress', 'Evil')
            end
            if v1045.Good == 4 and (v1045.Evil == 4 and v1045.Finished == true) then
            end
            if v1045.Good == 4 and (v1045.Evil == 4 and not v1045.Finished) then
            end
            if v1045.Good == -2 and (v1045.Finished == false and v1045.Evil == -5) then
            end
            if v1045.Good == -2 and (v1045.Finished == false and v1045.Evil == -4) then
            end
            if v1045.Good == -2 and (v1045.Finished == false and v1045.Evil == -3) then
                if game.Workspace.Enemies:FindFirstChild('Mythological Pirate [Lv. 1850]') then
                    DieMobTween = toTarget(CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625))

                    if (CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if DieMobTween then
                            DieMobTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625)
                    end

                    local v1046, v1047, v1048 = pairs(game.Workspace.Enemies:GetChildren())

                    while true do
                        local v1049

                        v1048, v1049 = v1046(v1047, v1048)

                        if v1048 == nil then
                            break
                        end
                        if StartKaiTun and (v1049.Name == 'Mythological Pirate [Lv. 1850]' and (v1049:FindFirstChild('Humanoid') and (v1049:FindFirstChild('HumanoidRootPart') and (v1049.Humanoid.Health > 0 and InMyNetWork(v1049.HumanoidRootPart))))) then
                            v1049.HumanoidRootPart.CFrame = CFrame.new(-13449.36328125, 469.58416748046875, -6865.7822265625)
                            v1049.HumanoidRootPart.CanCollide = false
                        end
                    end
                else
                    DieMobTween = toTarget(CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625))

                    if (CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if DieMobTween then
                            DieMobTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13452.5224609375, 469.584228515625, -6870.68603515625)
                    end
                end
            end
            if v1045.Good ~= -5 or (v1045.Finished ~= false or v1045.Evil ~= -2) then
            end
            if game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension') and (game:GetService('Workspace').Map.HeavenlyDimension:FindFirstChild('Exit') and game:GetService('Workspace').Map.HeavenlyDimension:FindFirstChild('Exit').Color ~= Color3.fromRGB(0, 0, 0)) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HeavenlyDimension:FindFirstChild('Exit').CFrame
            end
            if not game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension') or tostring(game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension'):FindFirstChild('ActivePlayers').Value.Value) ~= game.Players.LocalPlayer.Name then
            end
            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Heavenly Dimension').Position).Magnitude > 500 then
                TorchTween = toTarget(CFrame.new(-22709.6426, 5298.98584, 3886.63745, -1.1920929000000002e-7, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929000000002e-7))
            end
            if TorchTween then
                TorchTween:Stop()
            end
            if not CheckMobDistanceWorkspace(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Heavenly Dimension').Position, 500) then
                if game:GetService('Workspace').Map.HeavenlyDimension.Torch1:FindFirstChild('ProximityPrompt').Enabled ~= true then
                    if game:GetService('Workspace').Map.HeavenlyDimension.Torch2:FindFirstChild('ProximityPrompt').Enabled ~= true then
                        if game:GetService('Workspace').Map.HeavenlyDimension.Torch3:FindFirstChild('ProximityPrompt').Enabled == true then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HeavenlyDimension.Torch3.CFrame

                            task.wait(0.5)
                            fireproximityprompt(game:GetService('Workspace').Map.HeavenlyDimension.Torch3.ProximityPrompt, 4)
                            task.wait(0.2)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                        end
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HeavenlyDimension.Torch2.CFrame

                        task.wait(0.5)
                        fireproximityprompt(game:GetService('Workspace').Map.HeavenlyDimension.Torch2.ProximityPrompt, 4)
                        task.wait(0.2)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                    end
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HeavenlyDimension.Torch1.CFrame

                    task.wait(0.5)
                    fireproximityprompt(game:GetService('Workspace').Map.HeavenlyDimension.Torch1.ProximityPrompt, 4)
                    task.wait(0.2)

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                end
            end

            local v1050, v1051

            v1050, v1051, v925 = pairs(game.Workspace.Enemies:GetChildren())

            if not CheckNotNotifyHazeESP() then
                StartMagnetHaze = false

                local v1052 = {}

                Usefastattack = false

                if game:GetService('Lighting').LightingLayers.Haze.Intensity.Value == 0 then
                    task.wait(0.2)
                    Com('F_', 'CDKQuest', 'StartTrial', 'Evil')

                    if game:GetService('Lighting').LightingLayers.Haze.Intensity.Value == 0 then
                        task.wait(0.2)
                        Com('F_', 'CDKQuest', 'StartTrial', 'Evil')

                        if game:GetService('Lighting').LightingLayers.Haze.Intensity.Value == 0 then
                            u171:NormalTeleport()
                        end
                    end
                end

                local v1053, v1054, v1055 = pairs(game:GetService('Workspace')._WorldOrigin:FindFirstChild('EnemySpawns'):GetChildren())

                while true do
                    local v1056, v1057 = v1053(v1054, v1055)

                    if v1056 == nil then
                        break
                    end

                    v1055 = v1056

                    if StartKaiTun and not (CheckNotNotifyHazeESP() or table.find(v1052, v1057.Name)) then
                        repeat
                            task.wait()

                            Usefastattack = false
                            Totartween = toTarget(v1057.CFrame * CFrame.new(1, 30, 0))
                        until (v1057.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 or (not StartKaiTun or CheckNotNotifyHazeESP())

                        u31 = u31 + 1

                        if Totartween then
                            Totartween:Stop()
                        end

                        table.insert(v1052, v1057.Name)

                        if CheckNotNotifyHazeESP() then
                            break
                        end

                        print(u31)
                    end
                end

                if u31 >= 100 then
                    u171:NormalTeleport()
                end
            end

            local v1058, v1059

            v1058, v1059, v919 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))

            if v1045.Good ~= -4 or (v1045.Finished ~= false or v1045.Evil ~= -2) then
                if v1045.Good ~= -3 or (v1045.Finished ~= false or v1045.Evil ~= -2) then
                    if v1045.Good >= 4 then
                        if v1045.Evil < 4 then
                            Com('F_', 'CDKQuest', 'StartTrial', 'Evil')
                        end
                    else
                        Com('F_', 'CDKQuest', 'StartTrial', 'Good')
                    end
                else
                    CDKBoat = toTarget(CFrame.new(-6124.43115234375, 16.420757293701172, -2249.501953125))

                    CDKBoat:Wait()
                    Com('F_', 'CDKQuest', 'BoatQuest', game:GetService('Workspace').NPCs:FindFirstChild('Luxury Boat Dealer'))
                    task.wait(0.1)

                    CDKBoat = toTarget(CFrame.new(3234.458740234375, 9.432062149047852, 1597.3251953125))

                    CDKBoat:Wait()
                    Com('F_', 'CDKQuest', 'BoatQuest', game:GetService('Workspace').NPCs:FindFirstChild('Luxury Boat Dealer'))
                    task.wait(0.1)

                    CDKBoat = toTarget(CFrame.new(-9549.9443359375, 21.104869842529297, 4684.04931640625))

                    CDKBoat:Wait()
                    Com('F_', 'CDKQuest', 'BoatQuest', game:GetService('Workspace').NPCs:FindFirstChild('Luxury Boat Dealer'))
                    task.wait(0.1)
                end
            end
            if not CheckMobDistanceCollection(Vector3.new(-5545.8134765625, 313.7655944824219, -2978.4912109375), 1000) then
                if not StartKaiTun or u550 ~= false then
                    Usefastattack = false
                    Questtween = toTarget(CFrame.new(-5544.12109375, 379.99822998046875, -2962.108642578125).Position, CFrame.new(-5544.12109375, 379.99822998046875, -2962.108642578125))

                    if (CFrame.new(-9506.14648, 172.130661, 6101.79053).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Questtween then
                            Questtween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5544.12109375, 379.99822998046875, -2962.108642578125)
                    end

                    task.wait(1)
                end
            end

            local v1060, v1061

            v1060, v1061, v927 = pairs(game:GetService('CollectionService'):GetTagged('ActiveRig'))

            if not (inmyself('Yama') or inmyself('Tushita')) then
                Com('F_', 'StoreItem', tostring(GetFightingStyle('Sword')), inmyself(GetFightingStyle('Sword')))
                task.wait(1)
                Com('F_', 'LoadItem', tostring('Tushita'))
                task.wait(1)
            end
            if not (game.Workspace.Enemies:FindFirstChild('Cursed Skeleton Boss [Lv. 2025] [Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Cursed Skeleton Boss [Lv. 2025] [Boss]')) then
                if game:GetService('Workspace').Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled ~= false then
                    KillBossTween = toTarget(CFrame.new(-12361.7060546875, 603.3547973632813, -6550.5341796875))

                    if (CFrame.new(-12361.7060546875, 603.3547973632813, -6550.5341796875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        if KillBossTween then
                            KillBossTween:Stop()
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12361.7060546875, 603.3547973632813, -6550.5341796875)

                        task.wait(2)
                        fireproximityprompt(game:GetService('Workspace').Map.Turtle.Cursed.Pedestal3.ProximityPrompt, 0)
                        print('F2')
                    end
                elseif (game:GetService('Workspace').Map.Turtle.Cursed.BossDoor.Position - Vector3.new(-12346, 582.058, -6551.01)).Magnitude <= 3 then
                    KillBossTween = toTarget(CFrame.new(-12278.8193359375, 598.8648071289063, -6551.98876953125))

                    KillBossTween:Wait()
                    Com('F_', 'CDKQuest', 'StartTrial', 'Boss')

                    KillBossTween = toTarget(CFrame.new(-12361.7060546875, 603.3547973632813, -6550.5341796875))

                    KillBossTween:Wait()
                end
            end
            if KillBossTween then
                KillBossTween:Stop()
            end

            local v1062, v1063, v1064 = pairs(game.Workspace.Enemies:GetChildren())

            if true then
                task.wait()

                if (v1065.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v1065.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1065.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v1065.HumanoidRootPart.Position, v1065.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v1065.Parent and (v1065.Humanoid.Health > 0 and p912.Visible ~= false)) then
            end

            Usefastattack = false

            local v1065

            v1034, v1065 = v1032(v1033, v1034)

            if v1034 == nil then
            end
            if StartKaiTun and (v1065.Name == 'Kilo Admiral [Lv. 1750] [Boss]' and (v1065:FindFirstChild('Humanoid') and (v1065:FindFirstChild('HumanoidRootPart') and v1065.Humanoid.Health > 0))) then
            else
            end
            if not (game:GetService('ReplicatedStorage'):FindFirstChild('Cake Queen [Lv. 2175] [Boss]') or game.Workspace.Enemies:FindFirstChild('Cake Queen [Lv. 2175] [Boss]')) then
                BuddySwordsTween = toTarget(CFrame.new(-821, 66, -10965).Position, CFrame.new(-821, 66, -10965))

                if (CFrame.new(-821, 66, -10965).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if BuddySwordsTween then
                        BuddySwordsTween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-821, 66, -10965)
                end

                task.wait(1)
            end

            Com('F_', 'CDKQuest', 'Progress')

            if not game.Workspace.Enemies:FindFirstChild('Cake Queen [Lv. 2175] [Boss]') then
                BuddySwordsTween = toTarget(CFrame.new(-821, 66, -10965).Position, CFrame.new(-821, 66, -10965))

                if (CFrame.new(-821, 66, -10965).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                    if BuddySwordsTween then
                        BuddySwordsTween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-821, 66, -10965)
                end
            end

            local v1066, v1067, v1068 = pairs(game.Workspace.Enemies:GetChildren())

            if game:GetService('Workspace').Map:FindFirstChild('HellDimension') and (game:GetService('Workspace').Map.HellDimension:FindFirstChild('Exit') and game:GetService('Workspace').Map.HellDimension:FindFirstChild('Exit').Color ~= Color3.fromRGB(0, 0, 0)) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HellDimension:FindFirstChild('Exit').CFrame
            end
            if game:GetService('Workspace').Map:FindFirstChild('HellDimension') and tostring(game:GetService('Workspace').Map:FindFirstChild('HellDimension'):FindFirstChild('ActivePlayers').Value.Value) == game.Players.LocalPlayer.Name then
            end
            if game.Players.LocalPlayer.Backpack:FindFirstChild('Hallow Essence') then
                Questtween = toTarget(game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.Position, game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.CFrame)

                if (game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map['Haunted Castle'].Summoner.Detection.CFrame
                end
            end
            if not (game:GetService('Workspace').Enemies:FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]') or game:GetService('ReplicatedStorage'):FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]')) or game:GetService('Workspace').Map:FindFirstChild('HellDimension') then
                Com('F_', 'Bones', 'Buy', 1, 1)
            end
            if not game:GetService('Workspace').Enemies:FindFirstChild('Soul Reaper [Lv. 2100] [Raid Boss]') then
                Questtween = toTarget(CFrame.new(-9521, 316, 6684).Position, CFrame.new(-9521, 316, 6684))

                if (CFrame.new(-9521, 316, 6684).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if Questtween then
                        Questtween:Stop()
                    end

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9521, 316, 6684)
                end
            end

            local v1069, v1070, v1071 = pairs(game.Workspace.Enemies:GetChildren())

            if Questtween then
                Questtween:Stop()
            end
            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Hell Dimension').Position).Magnitude > 500 then
                TorchTween = toTarget(CFrame.new(-22737.6426, 5169.98535, 2234.63379, -1.1920929000000002e-7, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929000000002e-7))
            end
            if TorchTween then
                TorchTween:Stop()
            end
            if not CheckMobDistanceWorkspace(game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Hell Dimension').Position, 500) then
                if game:GetService('Workspace').Map.HellDimension.Torch1:FindFirstChild('ProximityPrompt').Enabled ~= true then
                    if game:GetService('Workspace').Map.HellDimension.Torch2:FindFirstChild('ProximityPrompt').Enabled ~= true then
                        if game:GetService('Workspace').Map.HellDimension.Torch3:FindFirstChild('ProximityPrompt').Enabled == true then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HellDimension.Torch3.CFrame

                            task.wait(0.5)
                            fireproximityprompt(game:GetService('Workspace').Map.HellDimension.Torch3.ProximityPrompt, 4)
                            task.wait(0.2)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                        end
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HellDimension.Torch2.CFrame

                        task.wait(0.5)
                        fireproximityprompt(game:GetService('Workspace').Map.HellDimension.Torch2.ProximityPrompt, 4)
                        task.wait(0.2)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                    end
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Workspace').Map.HellDimension.Torch1.CFrame

                    task.wait(0.5)
                    fireproximityprompt(game:GetService('Workspace').Map.HellDimension.Torch1.ProximityPrompt, 4)
                    task.wait(0.2)

                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(1, 50, 0)
                end
            end

            local v1072, v1073

            v1072, v1073, v971 = pairs(game.Workspace.Enemies:GetChildren())

            task.wait()

            Farmtween = toTarget(v1074.HumanoidRootPart.Position, v1074.HumanoidRootPart.CFrame)

            if (v1074.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                if Farmtween then
                    Farmtween:Stop()
                end

                EquipWeapon(GetFightingStyle('Sword'))

                Usefastattack = true
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1074.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
            end
            if StartKaiTun and (v1074.Humanoid.Health > 0 and v1074.Parent) then
            end

            Usefastattack = false

            local v1074

            v1064, v1074 = v1062(v1063, v1064)

            if v1064 == nil then
            end
            if StartKaiTun and (v1074.Name == 'Cursed Skeleton Boss [Lv. 2025] [Boss]' and (v1074:FindFirstChild('Humanoid') and (v1074:FindFirstChild('HumanoidRootPart') and v1074.Humanoid.Health > 0))) then
            else
            end

            task.wait(5)

            local v1075

            v1071, v1075 = v1069(v1070, v1071)

            if v1071 == nil then
                task.wait(5)
            end
            if not StartKaiTun or (v1075.Name ~= 'Soul Reaper [Lv. 2100] [Raid Boss]' or (not v1075:FindFirstChild('HumanoidRootPart') or (not v1075:FindFirstChild('Humanoid') or v1075.Humanoid.Health <= 0))) then
            end
            if true then
                task.wait()

                if (v1075.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1075.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1075.HumanoidRootPart.CFrame * CFrame.new(3, 1, 0)
                    end
                else
                    Farmtween = toTarget(v1075.HumanoidRootPart.Position, v1075.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (not game:GetService('Workspace').Map:FindFirstChild('HellDimension') or tostring(game:GetService('Workspace').Map:FindFirstChild('HellDimension'):FindFirstChild('ActivePlayers').Value.Value) ~= game.Players.LocalPlayer.Name) then
            else
            end

            task.wait()

            Farmtween = toTarget(v1076.HumanoidRootPart.Position, v1076.HumanoidRootPart.CFrame)

            if (v1076.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                if Farmtween then
                    Farmtween:Stop()
                end

                EquipWeapon()

                Usefastattack = true

                toAroundTarget(v1076.HumanoidRootPart.CFrame)
            end
            if StartKaiTun and (v1076.Humanoid.Health > 0 and v1076.Parent) and (not game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension') or tostring(game:GetService('Workspace').Map:FindFirstChild('HeavenlyDimension'):FindFirstChild('ActivePlayers').Value.Value) ~= game.Players.LocalPlayer.Name) then
            end

            Usefastattack = false

            task.wait(5)

            local v1076

            v1068, v1076 = v1066(v1067, v1068)

            if v1068 == nil then
            end
            if StartKaiTun and (v1076.Name == 'Cake Queen [Lv. 2175] [Boss]' and (v1076:FindFirstChild('Humanoid') and (v1076:FindFirstChild('HumanoidRootPart') and v1076.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1077.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v1077.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1077.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v1077.HumanoidRootPart.Position, v1077.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v1077.Parent and (v1077.Humanoid.Health > 0 and p912.Visible ~= false)) then
            end

            Usefastattack = false

            local v1077

            v939, v1077 = v937(v938, v939)

            if v939 == nil then
            end
            if StartKaiTun and (v1077.Name == 'Stone [Lv. 1550] [Boss]' and (v1077:FindFirstChild('Humanoid') and (v1077:FindFirstChild('HumanoidRootPart') and v1077.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1078.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                    if (v1078.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1078.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                    end
                else
                    Farmtween = toTarget(v1078.HumanoidRootPart.Position, v1078.HumanoidRootPart.CFrame)
                end
            end
            if StartKaiTun and (v1078.Parent and (v1078.Humanoid.Health > 0 and p912.Visible ~= false)) then
            end

            Usefastattack = false

            local v1078

            v1039, v1078 = v1037(v1038, v1039)

            if v1039 == nil then
            end
            if StartKaiTun and (v1078.Name == 'Captain Elephant [Lv. 1875] [Boss]' and (v1078:FindFirstChild('Humanoid') and (v1078:FindFirstChild('HumanoidRootPart') and v1078.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1079.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1079.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1079.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v1079.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v1079.Parent and v1079.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v1079

            v943, v1079 = v941(v942, v943)

            if v943 == nil then
            end
            if StartKaiTun and (v1079.Name == 'Soul Reaper [Lv. 2100] [Raid Boss]' and (v1079:FindFirstChild('HumanoidRootPart') and (v1079:FindFirstChild('Humanoid') and v1079.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1080.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1080.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1080.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v1080.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v1080.Parent and v1080.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v1080

            v950, v1080 = v948(v949, v950)

            if v950 == nil then
            end
            if StartKaiTun and (v1080.Name == 'Cake Queen [Lv. 2175] [Boss]' and (v1080:FindFirstChild('HumanoidRootPart') and (v1080:FindFirstChild('Humanoid') and v1080.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1081.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1081.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        EquipWeapon()

                        Usefastattack = true

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1081.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
                    end
                else
                    Farmtween = toTarget(v1081.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10))
                end
            end
            if StartKaiTun and (v1081.Parent and v1081.Humanoid.Health > 0) then
            end

            Usefastattack = false

            pcall(RefreshStatus)

            local v1081

            v954, v1081 = v952(v953, v954)

            if v954 == nil then
            end
            if StartKaiTun and (v1081.Name == 'Cake Prince [Lv. 2300] [Raid Boss]' and (v1081:FindFirstChild('HumanoidRootPart') and (v1081:FindFirstChild('Humanoid') and v1081.Humanoid.Health > 0))) then
            else
            end
            if true then
                task.wait()

                if (v1082.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1082.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        Usefastattack = true
                        PosMon = v1082.HumanoidRootPart.CFrame

                        EquipWeapon(SelectToolWeapon)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1082.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        MagnetFarmCoco = true
                    end
                else
                    Farmtween = toTarget(v1082.HumanoidRootPart.Position, v1082.HumanoidRootPart.CFrame)
                    Usefastattack = false
                end
            end
            if StartKaiTun and (v1082.Parent and v1082.Humanoid.Health > 0) then
            end

            Usefastattack = false
            MagnetFarmCoco = false

            local v1082

            v982, v1082 = v980(v981, v982)

            if v982 == nil then
            end
            if StartKaiTun and (v1082.Name == 'Candy Rebel [Lv. 2375]' or (v1082.Name == 'Sweet Thief [Lv. 2350]' or (v1082.Name == 'Chocolate Bar Battler [Lv. 2325]' or v1082.Name == 'Cocoa Warrior [Lv. 2300]'))) and (v1082:FindFirstChild('HumanoidRootPart') and (v1082:FindFirstChild('Humanoid') and v1082.Humanoid.Health > 0)) then
            else
            end

            Com('F_', 'Awakener', 'Check')
            Com('F_', 'Awakener', 'Awaken')

            if StartKaiTun == false or (not game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false) then
                task.wait(5)

                for _ = 1, 5 do
                    Com('F_', 'Awakener', 'Check')
                    Com('F_', 'Awakener', 'Awaken')
                    task.wait(0.5)
                end
            end
            if false then
            end

            task.wait()

            if game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2') or game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1')))) then
                GoIsland = false

                NextIsland()

                if GoIsland ~= false then
                    if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Farmtween then
                                Farmtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
                        end
                    else
                        Farmtween = toTarget(ToIslandCFrame)
                    end
                else
                    task.wait(0.1)
                end
            end

            local v1083, v1084, v1085 = pairs(game.Workspace.Enemies:GetChildren())
            local v1086

            v1085, v1086 = v1083(v1084, v1085)

            if v1085 == nil then
            end
            if StartKaiTun and (v1086:FindFirstChild('Humanoid') and v1086:FindFirstChild('HumanoidRootPart')) and (v1086.HumanoidRootPart.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
            else
            end

            task.wait()

            if not v1090:FindFirstChild('Humanoid') then
                return
            end

            v1090.Humanoid.Health = 0

            if StartKaiTun and (v1090.Humanoid.Health > 0 and v1090.Parent) then
            else
            end

            Com('F_', 'Awakener', 'Check')
            Com('F_', 'Awakener', 'Awaken')

            if StartKaiTun == false or (not game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1') or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false) then
                task.wait(5)

                for _ = 1, 5 do
                    Com('F_', 'Awakener', 'Check')
                    Com('F_', 'Awakener', 'Awaken')
                    task.wait(0.5)
                end
            end
            if false then
            end

            task.wait()

            if game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 5') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 4') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 3') or (game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 2') or game:GetService('Workspace')._WorldOrigin.Locations:FindFirstChild('Island 1')))) then
                GoIsland = false

                NextIsland()

                if GoIsland ~= false then
                    if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                            if Farmtween then
                                Farmtween:Stop()
                            end

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
                        end
                    else
                        Farmtween = toTarget(ToIslandCFrame)
                    end
                else
                    task.wait(0.1)
                end
            end

            local v1087, v1088, v1089 = pairs(game.Workspace.Enemies:GetChildren())
            local v1090

            v1089, v1090 = v1087(v1088, v1089)

            if v1089 == nil then
            end
            if StartKaiTun and (v1090:FindFirstChild('Humanoid') and v1090:FindFirstChild('HumanoidRootPart')) and (v1090.HumanoidRootPart.Position - game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
            else
            end
            if true then
                task.wait()

                if (v1095.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                    if (v1095.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                        if Farmtween then
                            Farmtween:Stop()
                        end

                        PosMon = v1095.HumanoidRootPart.CFrame
                        StartMagnetFarmLevelMax = true

                        if u48 ~= 'Blox Fruit' then
                            EquipWeapon()

                            Usefastattack = true

                            toAroundTarget(v1095.HumanoidRootPart.CFrame)
                        else
                            HealthMin = v1095.Humanoid.MaxHealth * 30 / 100

                            if v1095.Humanoid.Health > HealthMin or (not v1095:FindFirstChild('HumanoidRootPart') or (not v1095:FindFirstChild('Humanoid') or v1095.Humanoid.Health <= 0)) then
                                UseSkillMasteryDevilFruit = false

                                EquipWeapon()

                                Usefastattack = true
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1095.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            else
                                Usefastattack = false

                                EquipWeapon(game.Players.LocalPlayer.Data.DevilFruit.Value)
                                toAroundTarget(v1095.HumanoidRootPart.CFrame)

                                if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool') then
                                    PositionSkillMasteryDevilFruit = v1095.HumanoidRootPart.Position
                                    UseSkillMasteryDevilFruit = true

                                    if game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                                        MasteryDevilFruit = require(game:GetService('Players').LocalPlayer.Character[game.Players.LocalPlayer.Data.DevilFruit.Value].Data)
                                        DevilFruitMastery = game:GetService('Players').LocalPlayer.Character[game.Players.LocalPlayer.Data.DevilFruit.Value].Level.Value
                                    elseif game:GetService('Players').LocalPlayer.Backpack:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                                        MasteryDevilFruit = require(game:GetService('Players').LocalPlayer.Backpack[game.Players.LocalPlayer.Data.DevilFruit.Value].Data)
                                        DevilFruitMastery = game:GetService('Players').LocalPlayer.Backpack[game.Players.LocalPlayer.Data.DevilFruit.Value].Level.Value
                                    end
                                    if game.Players.LocalPlayer.Character:FindFirstChild('IceSword') or game.Players.LocalPlayer.Character:FindFirstChild('LightSword') then
                                        _VirtualUser:CaptureController()
                                        _VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService('Workspace').Camera.CFrame)
                                    end
                                    if getgenv().Configs.Mastery.SettingsSkill and (type(getgenv().Configs.Mastery.SettingsSkill) == 'table' and #getgenv().Configs.Mastery.SettingsSkill > 0) then
                                        local v1091, v1092, v1093 = pairs(getgenv().Configs.Mastery.SettingsSkill)

                                        while true do
                                            local v1094

                                            v1093, v1094 = v1091(v1092, v1093)

                                            if v1093 == nil then
                                                break
                                            end
                                            if v1094:FindFirstChild('HumanoidRootPart') and (v1094:FindFirstChild('Humanoid') and (v1094.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl[string.upper(v1093)])) then
                                                game:service('VirtualInputManager'):SendKeyEvent(true, string.upper(v1093), false, game)
                                                task.wait(v1094)
                                                game:service('VirtualInputManager'):SendKeyEvent(false, string.upper(v1093), false, game)
                                            end

                                            task.wait(0.1)
                                        end
                                    elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild('Dragon-Dragon') then
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                                            task.wait(3)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                                        end
                                    elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild('Human-Human: Buddha') then
                                        if not v1095:FindFirstChild('HumanoidRootPart') or (not v1095:FindFirstChild('Humanoid') or (v1095.Humanoid.Health <= 0 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Size ~= Vector3.new(7.6, 7.676, 3.686) or DevilFruitMastery < MasteryDevilFruit.Lvl.Z))) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                                        end
                                        if SkillX and (v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X))) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                                        end
                                        if SkillC and (v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C))) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                                        end
                                    elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild('Dough-Dough') then
                                        game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = v1095.HumanoidRootPart.Position

                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                                            task.wait(5)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                                        end
                                    elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild('Control-Control') then
                                        if game:GetService('Lighting'):FindFirstChild('OpeGlobe') and game:GetService('Lighting'):FindFirstChild('OpeGlobe').TintColor == Color3.fromRGB(164, 189, 255) then
                                            if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and v1095.Humanoid.Health > 0) then
                                                game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                                                task.wait(0.5)
                                                game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                                            end
                                            if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C)) then
                                                game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                                                task.wait(0.1)
                                                game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                                            end
                                            if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V)) then
                                                game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                                                task.wait(0.1)
                                                game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                                            end
                                        else
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                                            task.wait(2)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                                        end
                                    elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                                        game:GetService('Players').LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = v1095.HumanoidRootPart.Position

                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'Z', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'Z', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'X', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'X', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'C', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'C', false, game)
                                        end
                                        if v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and (v1095.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V)) then
                                            game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                                            task.wait(0.1)
                                            game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    Farmtween = toTarget(v1095.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                    Usefastattack = false
                end
            end
            if StartKaiTun and (v1095.Parent and v1095.Humanoid.Health > 0) then
            end

            Usefastattack = false
            StartMagnetFarmLevelMax = false

            local v1095

            v1023, v1095 = v1021(v1022, v1023)

            if v1023 == nil then
            end
            if StartKaiTun and (v1095.Name == 'Reborn Skeleton [Lv. 1975]' or (v1095.Name == 'Living Zombie [Lv. 2000]' or (v1095.Name == 'Demonic Soul [Lv. 2025]' or v1095.Name == 'Posessed Mummy [Lv. 2050]'))) and (v1095:FindFirstChild('HumanoidRootPart') and (v1095:FindFirstChild('Humanoid') and v1095.Humanoid.Health > 0)) then
            else
            end
        end

        local u1096 = {
            'Godhuman',
            'Superhuman',
            'SharkmanKarate',
            'DragonTalon',
            'ElectricClaw',
            'DeathStep',
        }

        task.spawn(LPH_NO_VIRTUALIZE(function()
            local v1097, v1098, v1099 = pairs(u1096)

            while true do
                local v1100

                v1099, v1100 = v1097(v1098, v1099)

                if v1099 == nil then
                    break
                end
                if tonumber(Com('F_', 'Buy' .. v1100, true)) == 1 then
                    table.insert(u49, tostring(v1100))

                    if v1100 == 'Godhuman' then
                        u37 = true
                        u38 = true
                        u39 = true
                        u40 = true
                        u41 = true

                        break
                    end
                    if v1100 == 'SharkmanKarate' then
                        u34 = true
                    elseif v1100 == 'DragonTalon' then
                        u36 = true
                    elseif v1100 == 'ElectricClaw' then
                        u35 = true
                    elseif v1100 == 'DeathStep' then
                        u33 = true
                    end
                end

                task.wait()
            end
        end))
        task.spawn(LPH_NO_VIRTUALIZE(function()
            local v1101, v1102, v1103 = pairs(u49)

            while true do
                local v1104

                v1103, v1104 = v1101(v1102, v1103)

                if v1103 == nil then
                    break
                end

                Com('F_', 'Buy' .. v1104)
                task.wait(0.01)

                if v1104 == 'Godhuman' then
                    if inmyself('Godhuman') then
                        local _Godhuman = CheckMasteryWeapon('Godhuman', 500)

                        if _Godhuman == 'true' or _Godhuman == 'UpTo' then
                            GodhumanDone = true
                        end
                    end
                elseif v1104 == 'Superhuman' then
                    if inmyself('Superhuman') then
                        local _Superhuman = CheckMasteryWeapon('Superhuman', 400)

                        if _Superhuman == 'true' or _Superhuman == 'UpTo' then
                            u39 = true
                            u38 = true
                        end
                    end
                elseif v1104 == 'SharkmanKarate' then
                    if inmyself('Sharkman Karate') then
                        local _SharkmanKarate = CheckMasteryWeapon('Sharkman Karate', 400)

                        if _SharkmanKarate == 'true' or _SharkmanKarate == 'UpTo' then
                            u38 = true
                        end
                    end
                elseif v1104 == 'DragonTalon' then
                    if inmyself('Dragon Talon') then
                        local _DragonTalon = CheckMasteryWeapon('Dragon Talon', 400)

                        if _DragonTalon == 'true' or _DragonTalon == 'UpTo' then
                            u41 = true
                        end
                    end
                elseif v1104 == 'ElectricClaw' then
                    if inmyself('Electric Claw') then
                        local _ElectricClaw = CheckMasteryWeapon('Electric Claw', 400)

                        if _ElectricClaw == 'true' or _ElectricClaw == 'UpTo' then
                            u40 = true
                        end
                    end
                elseif v1104 == 'DeathStep' and inmyself('Death Step') then
                    local _DeathStep = CheckMasteryWeapon('Death Step', 400)

                    if _DeathStep == 'true' or _DeathStep == 'UpTo' then
                        u37 = true
                    end
                end
            end
        end))
        task.spawn(LPH_JIT_MAX(function()
            while task.wait() do
                if StartKaiTun then
                    xpcall(function()
                        DieWait()

                        if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                            Com('F_', 'Buso')
                        end

                        local v1111 = 0.1

                        if (GodhumanDone or not AutoGodhuman) and ((u37 or not AutoDeathStep) and ((u38 or not AutoSharkmanKarate) and ((u39 or not AutoSuperhuman) and ((u40 or not AutoElectricClaw) and (u41 or not AutoDargonTalon))))) then
                            local _F_8 = Com('F_', 'getInventory')
                            local v1113, v1114, v1115 = pairs(_F_8)
                            local v1116 = {}

                            while true do
                                local v1117

                                v1115, v1117 = v1113(v1114, v1115)

                                if v1115 == nil then
                                    break
                                end
                                if type(v1117) == 'table' and (v1117.Type == 'Sword' and (v1117.Name == 'Yama' or v1117.Name == 'Tushita')) and v1117.Mastery < 350 then
                                    table.insert(v1116, {
                                        Name = v1117.Name,
                                        MaxMastery = 351,
                                    })
                                end
                            end

                            local v1118, v1119, v1120 = pairs(SwordFarmRarity)

                            while true do
                                local v1121

                                v1120, v1121 = v1118(v1119, v1120)

                                if v1120 == nil then
                                    break
                                end

                                local v1122, v1123, v1124 = pairs(_F_8)

                                while true do
                                    local v1125

                                    v1124, v1125 = v1122(v1123, v1124)

                                    if v1124 == nil then
                                        break
                                    end
                                    if type(v1125) == 'table' and (v1125.Type == 'Sword' and (v1125.Name ~= 'Yama' and (v1125.Name ~= 'Tushita' and (v1125.Mastery < v1125.MasteryRequirements.X and v1125.Rarity == u239(v1121))))) then
                                        local _X = v1125.MasteryRequirements.X

                                        table.insert(v1116, {
                                            Name = v1125.Name,
                                            MaxMastery = _X or 400,
                                        })
                                    end
                                end
                            end

                            if RaidsDoughNow == true and CheckAwaken() then
                                RaidsDoughNow = false
                            end
                            if AutoFarmMasteryDevilFruit and not MasteryDevilFruitDone then
                                local v1127 = inmyself(tostring(game:GetService('Players').LocalPlayer:WaitForChild('Data').DevilFruit.Value))

                                if v1127 then
                                    if v1127:WaitForChild('Level').Value < (tonumber(require(v1127:WaitForChild('Data')).Lvl.V) or (tonumber(require(v1127:WaitForChild('Data')).Cap) or 350)) then
                                        u48 = 'Blox Fruit'
                                    else
                                        MasteryDevilFruitDone = true
                                    end
                                end
                            end
                            if AutoFarmMasterySword and #v1116 > 0 and u539:Update().Text ~= 'Doing Status : Do CDK' then
                                while#v1116 > 0 and (u539:Update().Text ~= 'Doing Status : Do CDK' and AutoFarmMasterySword) do
                                    task.wait()

                                    local v1128, v1129, v1130 = pairs(v1116)

                                    while true do
                                        local v1131

                                        v1130, v1131 = v1128(v1129, v1130)

                                        if v1130 == nil then
                                            break
                                        end
                                        if u539:Update().Text ~= 'Doing Status : Do CDK' and AutoFarmMasterySword then
                                            u48 = 'Sword'

                                            while u539:Update().Text ~= 'Doing Status : Do CDK' and AutoFarmMasterySword do
                                                task.wait()

                                                local _Name = v1131.Name
                                                local _MaxMastery = v1131.MaxMastery

                                                if inmyself(_Name) then
                                                    if inmyself(_Name) then
                                                        local v1134, v1135 = pcall(function()
                                                            return CheckMasteryWeapon(_Name, _MaxMastery)
                                                        end)

                                                        if not v1134 then
                                                            return
                                                        end
                                                        if v1135 == 'true' or v1135 == 'UpTo' then
                                                            print('DONE ' .. v1131.Name)

                                                            break
                                                        end
                                                    end
                                                else
                                                    task.wait()
                                                    Com('F_', 'StoreItem', tostring(GetFightingStyle('Sword')), inmyself(GetFightingStyle('Sword')))
                                                    task.wait(0.5)
                                                    Com('F_', 'LoadItem', tostring(_Name))
                                                end

                                                task.wait(3)
                                            end
                                        end
                                    end
                                end
                            end

                            local v1136 = u533

                            if string.find(v1136:Update().Text, u548) and AutoCDK then
                                local v1137 = u543

                                if string.find(v1137:Update().Text, u548) then
                                end

                                local v1138 = u546

                                if string.find(v1138:Update().Text, u548) then
                                end

                                local v1139 = u543

                                if not string.find(v1139:Update().Text, u547) then
                                end

                                local v1140 = u546

                                if string.find(v1140:Update().Text, u547) then
                                end
                            end
                            if CheckAwaken() ~= false then
                                u48 = 'Melee'
                            elseif game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough' then
                                RaidsNow = true
                            else
                                RaidsDoughNow = true
                            end
                            if not inmyself('Godhuman') then
                                Com('F_', 'BuyGodhuman')
                            end

                            task.wait(0.5)
                        elseif GodhumanDone or not (u37 and (u38 and (u39 and (u40 and (u41 and AutoGodhuman))))) then
                            if (u33 or not (AutoDeathStep or AutoGodhuman)) and ((u34 or not (AutoSharkmanKarate or AutoGodhuman)) and ((u35 or not (AutoElectricClaw or AutoGodhuman)) and (u36 or not (AutoDargonTalon or AutoGodhuman)))) then
                                u48 = 'Melee'

                                if u37 or not (AutoDeathStep or AutoGodhuman) then
                                    if u38 or not (AutoSharkmanKarate or AutoGodhuman) then
                                        if u39 or not (AutoSuperhuman or AutoGodhuman) then
                                            if u40 or not (AutoElectricClaw or AutoGodhuman) then
                                                if not u41 and (AutoDargonTalon or AutoGodhuman) then
                                                    if inmyself('Dragon Talon') then
                                                        local _DragonTalon2 = CheckMasteryWeapon('Dragon Talon', 400)

                                                        if _DragonTalon2 == 'true' or _DragonTalon2 == 'UpTo' then
                                                            u41 = true
                                                        end
                                                    elseif Com('F_', 'BuyDragonTalon', true) ~= 3 then
                                                        if not inmyself('Dragon Talon') then
                                                            if Com('F_', 'BuyDragonTalon') ~= 1 then
                                                                if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 5000 then
                                                                    RaidsNow = true
                                                                end
                                                            else
                                                                RaidsNow = false
                                                                v1111 = 0
                                                            end
                                                        end
                                                    elseif u77 then
                                                        Com('F_', 'Bones', 'Buy', 1, 1)
                                                    end
                                                end
                                            elseif inmyself('Electric Claw') then
                                                local _ElectricClaw2 = CheckMasteryWeapon('Electric Claw', 400)

                                                if _ElectricClaw2 == 'true' or _ElectricClaw2 == 'UpTo' then
                                                    u40 = true
                                                end
                                            elseif not inmyself('Electric Claw') then
                                                if Com('F_', 'BuyElectricClaw', true) ~= 4 or not u77 then
                                                    if Com('F_', 'BuyElectricClaw') ~= 1 then
                                                        if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 5000 then
                                                            RaidsNow = true
                                                        end
                                                    else
                                                        RaidsNow = false
                                                        v1111 = 0
                                                    end
                                                elseif Com('F_', 'BuyElectricClaw', 'Start') == nil then
                                                    if tween then
                                                        tween:Cancel()
                                                    end

                                                    game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12548, 337, -7481)
                                                end
                                            end
                                        elseif inmyself('Superhuman') then
                                            local _Superhuman2 = CheckMasteryWeapon('Superhuman', 400)

                                            if _Superhuman2 == 'true' or _Superhuman2 == 'UpTo' then
                                                u39 = true
                                            end
                                        elseif not inmyself('Superhuman') and Com('F_', 'BuySuperhuman') == 1 then
                                            RaidsNow = false
                                            v1111 = 0
                                        end
                                    elseif inmyself('Sharkman Karate') then
                                        local _SharkmanKarate2 = CheckMasteryWeapon('Sharkman Karate', 400)

                                        if _SharkmanKarate2 == 'true' or _SharkmanKarate2 == 'UpTo' then
                                            u38 = true
                                        end
                                    elseif not inmyself('Sharkman Karate') then
                                        if Com('F_', 'BuySharkmanKarate') ~= 1 then
                                            if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 5000 then
                                                RaidsNow = true
                                            end
                                        else
                                            RaidsNow = false
                                            v1111 = 0
                                        end
                                    end
                                elseif inmyself('Death Step') then
                                    local _DeathStep2 = CheckMasteryWeapon('Death Step', 400)

                                    if _DeathStep2 == 'true' or _DeathStep2 == 'UpTo' then
                                        u37 = true
                                    end
                                elseif not inmyself('Death Step') then
                                    if Com('F_', 'BuyDeathStep') ~= 1 then
                                        if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 5000 then
                                            RaidsNow = true
                                        end
                                    else
                                        RaidsNow = false
                                        v1111 = 0
                                    end
                                end
                            elseif not (u33 and (u34 and (u35 and u36))) then
                                if u33 or not (AutoDeathStep or (AutoSuperhuman or AutoGodhuman)) then
                                    if u34 or not (AutoSharkmanKarate or (AutoSuperhuman or AutoGodhuman)) then
                                        if u35 or not (AutoElectricClaw or (AutoSuperhuman or AutoGodhuman)) then
                                            if not u36 and (AutoDargonTalon or (AutoSuperhuman or AutoGodhuman)) then
                                                if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value >= 1500 or tonumber(Com('F_', 'BlackbeardReward', 'DragonClaw', '1')) == 1 then
                                                    RaidsNow = false

                                                    if inmyself('Dragon Claw') then
                                                        if inmyself('Dragon Claw') then
                                                            local _DragonClaw = CheckMasteryWeapon('Dragon Claw', 400)

                                                            if _DragonClaw == 'true' or _DragonClaw == 'UpTo' then
                                                                u36 = true
                                                            end
                                                        end
                                                    elseif Com('F_', 'BlackbeardReward', 'DragonClaw', '2') == 1 then
                                                        task.wait()

                                                        v1111 = 0
                                                    end
                                                else
                                                    RaidsNow = true
                                                end
                                            end
                                        elseif inmyself('Electro') then
                                            if inmyself('Electro') then
                                                local _Electro = CheckMasteryWeapon('Electro', 400)

                                                if _Electro == 'true' or _Electro == 'UpTo' then
                                                    u35 = true
                                                end
                                            end
                                        elseif Com('F_', 'BuyElectro') == 1 then
                                            task.wait()

                                            v1111 = 0
                                        end
                                    elseif inmyself('Fishman Karate') then
                                        if inmyself('Fishman Karate') then
                                            local _FishmanKarate = CheckMasteryWeapon('Fishman Karate', 400)

                                            if _FishmanKarate == 'true' or _FishmanKarate == 'UpTo' then
                                                u34 = true
                                            end
                                        end
                                    elseif Com('F_', 'BuyFishmanKarate') == 1 then
                                        task.wait()

                                        v1111 = 0
                                    end
                                elseif inmyself('Black Leg') then
                                    if inmyself('Black Leg') then
                                        local _BlackLeg = CheckMasteryWeapon('Black Leg', 400)

                                        if _BlackLeg == 'true' or _BlackLeg == 'UpTo' then
                                            u33 = true
                                        end
                                    end
                                elseif Com('F_', 'BuyBlackLeg') == 1 then
                                    task.wait()

                                    v1111 = 0
                                end
                            end
                        else
                            u48 = 'Melee'

                            if inmyself('Godhuman') then
                                local _Godhuman2 = CheckMasteryWeapon('Godhuman', 500)

                                if _Godhuman2 == 'true' or _Godhuman2 == 'UpTo' then
                                    GodhumanDone = true
                                end
                            elseif not inmyself('Godhuman') then
                                if Com('F_', 'BuyGodhuman', true) ~= 1 then
                                    if GetMaterial('Fish Tail') < 20 then
                                        if u75 then
                                            StartGodhumanMat = true
                                            FarmThisMaterial = 'Fish Tail'
                                        else
                                            Com('F_', 'TravelMain')
                                        end
                                    elseif GetMaterial('Magma Ore') < 20 then
                                        if u75 then
                                            StartGodhumanMat = true
                                            FarmThisMaterial = 'Magma Ore'
                                        else
                                            Com('F_', 'TravelMain')
                                        end
                                    elseif GetMaterial('Dragon Scale') < 10 then
                                        if u77 then
                                            StartGodhumanMat = true
                                            FarmThisMaterial = 'Dragon Scale'
                                        else
                                            Com('F_', 'TravelZou')
                                        end
                                    elseif GetMaterial('Mystic Droplet') < 10 then
                                        if u76 then
                                            StartGodhumanMat = true
                                            FarmThisMaterial = 'Mystic Droplet'
                                        else
                                            Com('F_', 'TravelDressrosa')
                                        end
                                    else
                                        StartGodhumanMat = false

                                        if u77 then
                                            if u77 then
                                                if Com('F_', 'BuyGodhuman') ~= 1 then
                                                    if game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 5000 then
                                                        RaidsNow = true
                                                    end
                                                else
                                                    task.wait()

                                                    RaidsNow = false
                                                    v1111 = 0
                                                end
                                            end
                                        else
                                            Com('F_', 'TravelZou')
                                        end
                                    end
                                else
                                    Com('F_', 'BuyGodhuman')
                                end
                            end
                        end
                        if v1111 > 0 then
                            task.wait(v1111)
                        end
                    end, function(...)
                        print('ERROR : ' ..  ...)
                    end)
                end
            end
        end))

        local v1151 = 0

        while task.wait(1) and not GodhumanDone do
            if _G.Emulator then
                if v1151 >= 15 then
                    break
                end
            elseif v1151 >= 7 then
                break
            end

            v1151 = v1151 + 1
        end

        LPH_JIT(function()
            spawn(function()
                game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('Notifications').Enabled = false

                game:GetService('Players').LocalPlayer.PlayerGui:FindFirstChild('Notifications').ChildAdded:connect(function(p1152)
                    task.wait(0.05)

                    if StartKaiTun and string.lower(p1152.Text):find(string.lower('!&gt;')) then
                        u51 = not u51
                    end
                end)
            end)
            spawn(function()
                while task.wait() do
                    if StartKaiTun then
                        xpcall(function()
                            DieWait()
                            CheckQuest()
                            task.wait()

                            if u51 == true and (LevelFarm and tonumber(LevelFarm - 1) ~= 0) then
                                CheckOldQuest(tonumber(LevelFarm - 1))
                            end

                            task.wait(0.01)
                            CheckQuestBoss(NameQuest)
                            task.wait(0.01)

                            if Bosses == '' or havemob(Bosses).Humanoid.Health <= 0 then
                                if u51 then
                                    local v1153, v1154 = CheckGoodMob(CFrameQuest, game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position)

                                    if v1153 and (v1154 - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude > 3000 or v1153 == false and (game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position - CFrameQuest.Position).Magnitude > 3000 then
                                        local v1155, v1156 = CheckGoodMob(game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame, CFrameQuest.Position)

                                        if v1155 and (v1156 - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude > 3000 or v1155 == false and (game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position - CFrameQuest.Position).Magnitude > 3000 then
                                            u51 = false

                                            task.wait()
                                            CheckQuest()
                                        end
                                    end
                                end
                            else
                                Monster = Bosses
                                LevelQuest = LevelQuestBoss
                                NameCheckQuest = NameCheckQuestBoss
                                CFrameMon = CFrameBoss
                            end

                            local _Title = game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
                            local _Quest = game:GetService('Players').LocalPlayer.PlayerGui.Main.Quest
                            local _Value4 = game.Players.LocalPlayer.Data.Level.Value
                            local v1160 = CheckAllMyDF()

                            if not StartGodhumanMat then
                                if u75 then
                                    AutoKaiTunOldWorld(_Title, _Quest, _Value4, v1160)
                                elseif _Value4 >= 1000 and (v1160.HaveFruitInMySelf == true and (v1160.HaveFruitInStore == true and v1160.Price >= 1000000) or v1160.Price >= 1000000 and v1160.Price <= 2500000) and Com('F_', 'GetUnlockables').FlamingoAccess == nil then
                                    ShowDoingStatus('Open Flamingo Room')

                                    for v1161 = 1, 3 do
                                        Com('F_', 'TalkTrevor', tostring(v1161))
                                    end

                                    task.wait(0.1)
                                elseif u76 then
                                    AutoKaiTunNewWorld(_Title, _Quest, _Value4, v1160)
                                elseif u77 then
                                    AutoKaiTunThreeWorld(_Title, _Quest, _Value4, v1160)
                                end

                                return
                            end

                            ShowDoingStatus('Do Godhuman')
                            CheckMaterial(FarmThisMaterial)

                            if not CustomFindFirstChild(MaterialMob) then
                                Usefastattack = false

                                local v1162, v1163, v1164 = pairs(CFrameMonM)

                                while true do
                                    local v1165

                                    v1164, v1165 = v1162(v1163, v1164)

                                    if v1164 == nil then
                                        break
                                    end
                                    if StartGodhumanMat and (StartKaiTun and not CustomFindFirstChild(MaterialMob)) then
                                        while StartGodhumanMat and (StartKaiTun and not CustomFindFirstChild(MaterialMob)) do
                                            task.wait()

                                            Modstween = toTarget(v1165)

                                            if (v1165.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 150 then
                                                if Modstween then
                                                    Modstween:Stop()
                                                end

                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1165

                                                break
                                            end

                                            task.wait(0.2)
                                        end
                                    end

                                    task.wait(0.1)
                                end
                            end

                            local v1166, v1167, v1168 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                            while true do
                                local u1169

                                v1168, u1169 = v1166(v1167, v1168)

                                if v1168 == nil then
                                end
                                if not StartGodhumanMat or (not table.find(MaterialMob, u1169.Name) or (not u1169:FindFirstChild('HumanoidRootPart') or (not u1169:FindFirstChild('Humanoid') or u1169.Humanoid.Health <= 0))) then
                                end

                                task.wait()

                                FarmtoTarget = toTarget(u1169.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1))

                                if u1169:FindFirstChild('HumanoidRootPart') and (u1169:FindFirstChild('Humanoid') and (u1169.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100) then
                                    if FarmtoTarget then
                                        FarmtoTarget:Stop()
                                    end

                                    Usefastattack = true

                                    EquipWeapon()
                                    spawn(function()
                                        local v1170, v1171, v1172 = pairs(game:GetService('Workspace').Enemies:GetChildren())

                                        while true do
                                            local u1173

                                            v1172, u1173 = v1170(v1171, v1172)

                                            if v1172 == nil then
                                                break
                                            end
                                            if u1173.Name == u1169.Name then
                                                spawn(function()
                                                    if InMyNetWork(u1173.HumanoidRootPart) then
                                                        u1173.HumanoidRootPart.CFrame = u1169.HumanoidRootPart.CFrame
                                                        u1173.Humanoid.JumpPower = 0
                                                        u1173.Humanoid.WalkSpeed = 0
                                                        u1173.HumanoidRootPart.CanCollide = false

                                                        u1173.Humanoid:ChangeState(14)
                                                        u1173.Humanoid:ChangeState(11)

                                                        u1173.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                                                    else
                                                        u1173.HumanoidRootPart.CFrame = u1169.HumanoidRootPart.CFrame
                                                        u1173.Humanoid.JumpPower = 0
                                                        u1173.Humanoid.WalkSpeed = 0
                                                        u1173.HumanoidRootPart.CanCollide = false

                                                        u1173.Humanoid:ChangeState(14)
                                                        u1173.Humanoid:ChangeState(11)

                                                        u1173.HumanoidRootPart.Size = Vector3.new(55, 55, 55)
                                                    end
                                                end)
                                            end
                                        end
                                    end)

                                    if game.Players.LocalPlayer.Character:FindFirstChild('Black Leg') and game.Players.LocalPlayer.Character:FindFirstChild('Black Leg').Level.Value >= 150 then
                                        game:service('VirtualInputManager'):SendKeyEvent(true, 'V', false, game)
                                        game:service('VirtualInputManager'):SendKeyEvent(false, 'V', false, game)
                                    end

                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = u1169.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
                                end
                                if CustomFindFirstChild(MaterialMob) and (StartGodhumanMat and (u1169.Humanoid.Health > 0 and u1169.Parent)) then
                                end

                                Usefastattack = false
                            end
                        end, function(...)
                            print('ERROR : ' ..  ...)
                        end)
                    end
                end
            end)
        end)()
        LPH_JIT_MAX(function()
            spawn(function()
                while task.wait(1) do
                    if StartKaiTun then
                        xpcall(function()
                            local _Value5 = game.Players.LocalPlayer.Data.Level.Value
                            local v1175 = CheckAllMyDF()

                            if game.Players.LocalPlayer.Data.Points.Value > 0 then
                                local _Value6 = game:GetService('Players').LocalPlayer.Data.Stats.Melee.Level.Value
                                local _Value7 = game:GetService('Players').LocalPlayer.Data.Stats.Defense.Level.Value
                                local _ = game:GetService('Players').LocalPlayer.Data.Stats.Sword.Level.Value
                                local _Value8 = game:GetService('Players').LocalPlayer.Data.Stats['Demon Fruit'].Level.Value

                                if _G['This Function For You ;c'] then
                                    if _Value6 >= u50 then
                                        if _Value7 >= u50 then
                                            Com('F_', 'AddPoint', 'Demon Fruit', u50)
                                        else
                                            Com('F_', 'AddPoint', 'Defense', u50 - _Value7)
                                        end
                                    else
                                        Com('F_', 'AddPoint', 'Melee', u50 - _Value6)
                                    end
                                elseif _Value6 >= u50 then
                                    if _Value7 >= u50 then
                                        if _Value8 >= u50 / 2 then
                                            Com('F_', 'AddPoint', 'Sword', u50)
                                        else
                                            Com('F_', 'AddPoint', 'Demon Fruit', u50 / 2 - _Value8)
                                        end
                                    else
                                        Com('F_', 'AddPoint', 'Defense', u50 - _Value7)
                                    end
                                else
                                    Com('F_', 'AddPoint', 'Melee', u50 - _Value6)
                                end
                            end
                            if u47 == false and game.Players.LocalPlayer.Data.Level.Value >= SelectRedeemCodeLevel then
                                function UseCode(p1179)
                                    game:GetService('ReplicatedStorage').Remotes.Redeem:InvokeServer(p1179)
                                end

                                UseCode('Enyo_is_Pro')
                                UseCode('Magicbus')
                                UseCode('JCWK')
                                UseCode('Starcodeheo')
                                UseCode('Bluxxy')
                                UseCode('fudd10_v2')
                                UseCode('3BVISITS')
                                UseCode('FUDD10')
                                UseCode('BIGNEWS')
                                UseCode('Sub2OfficialNoobie')
                                UseCode('SUB2GAMERROBOT_EXP1')
                                UseCode('StrawHatMaine')
                                UseCode('SUB2NOOBMASTER123')
                                UseCode('Sub2Daigrock')
                                UseCode('Axiore')
                                UseCode('TantaiGaming')
                                UseCode('STRAWHATMAINE')
                                UseCode('kittgaming')
                                UseCode('Enyu_is_Pro')
                                UseCode('Sub2Fer999')
                                UseCode('THEGREATACE')
                                UseCode('GAMERROBOT_YT')
                                UseCode('SECRET_ADMIN')
                                task.wait(1)

                                if u45 == 2 then
                                    print('REDEEM DONE')

                                    u47 = true
                                end

                                u45 = u45 + 1
                            end

                            BuyAllHaki()

                            if u77 and 2200 <= _Value5 and game:GetService('Workspace').Map.Turtle.Cursed:FindFirstChild('Breakable') then
                                Com('F_', 'CDKQuest', 'OpenDoor')
                                Com('F_', 'CDKQuest', 'OpenDoor', true)
                            end
                            if not game.Players.LocalPlayer.Character:FindFirstChild('HasBuso') then
                                Com('F_', 'Buso')
                            end
                            if _CollectionService:HasTag(game.Players.LocalPlayer.Character, 'Ken') and not (game:GetService('Players').LocalPlayer:FindFirstChild('PlayerGui') and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild('ImageLabel')) then
                                task.wait(1)
                                game:service('VirtualUser'):CaptureController()
                                game:service('VirtualUser'):SetKeyDown('0x65')
                                task.wait(2)
                                game:service('VirtualUser'):SetKeyUp('0x65')
                            end
                            if game:GetService('Workspace').NPCs:FindFirstChild('Mysterious Entity') then
                                Com('F_', 'Awakener', 'Check')
                                Com('F_', 'Awakener', 'Awaken')
                            end
                            if not u75 then
                                if game.Players.LocalPlayer.Data.DevilFruit.Value ~= 'Dough-Dough' or (HaveDevilFruitSea3 or CheckAwaken()) then
                                    if not HaveDevilFruitSea3 and game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value <= (LimitRaidsFrag or 100000) then
                                        Com('F_', 'RaidsNpc', 'Select', GetNameRaids())
                                    end
                                elseif Com('F_', 'CakeScientist', 'Check') ~= true or v1175.HaveFruitInMySelf ~= false or game.Players.LocalPlayer:WaitForChild('Data'):WaitForChild('Fragments').Value < 1000 then
                                    if Com('F_', 'CakeScientist', 'Check') ~= true or (v1175.HaveFruitInMySelf ~= true or v1175.Price < 1000000) then
                                        Com('F_', 'RaidsNpc', 'Select', GetNameRaids())
                                    else
                                        Com('F_', 'RaidsNpc', 'Select', 'Dough')
                                    end
                                else
                                    Com('F_', 'RaidsNpc', 'Select', 'Dough')
                                end
                            end
                            if not (u75 or u46) and game:GetService('Players').localPlayer.Data.Fragments.Value >= 1500 then
                                cod_kbc = Com('F_', 'BlackbeardReward', 'Slingshot', '2')

                                if tostring(cod_kbc) == '2' then
                                    u46 = true
                                end
                            end
                            if not u75 then
                                local v1180 = u535

                                if string.find(v1180:Update().Text, u548) then
                                    local v1181 = u536

                                    if string.find(v1181:Update().Text, u548) then
                                        local v1182 = u534

                                        if string.find(v1182:Update().Text, u548) then
                                            for v1183 = 1, 3 do
                                                Com('F_', 'LegendarySwordDealer', tostring(v1183))
                                            end
                                        end
                                    end
                                end
                            end
                            if not (u75 or CheckHakiColor('Winter Sky') and (CheckHakiColor('Pure Red') and CheckHakiColor('Snow White'))) and tablefound({
                                'Winter Sky',
                                'Pure Red',
                                'Snow White',
                            }, Com('F_', 'ColorsDealer', '1')) then
                                for v1184 = 1, 3 do
                                    Com('F_', 'ColorsDealer', tostring(v1184))
                                end
                            end
                            if u76 then
                                local v1185 = u535

                                if string.find(v1185:Update().Text, u547) then
                                    local v1186 = u536

                                    if string.find(v1186:Update().Text, u547) then
                                        local v1187 = u534

                                        if string.find(v1187:Update().Text, u547) then
                                            Com('F_', 'MysteriousMan', '2')
                                        end
                                    end
                                end
                            end
                            if Com('F_', 'GuitarPuzzleProgress', 'Check') ~= nil and Com('F_', 'GuitarPuzzleProgress', 'Check').Pipes == true then
                                local v1188 = u544

                                if string.find(v1188:Update().Text, u548) and u77 then
                                    Com('F_', 'soulGuitarBuy')
                                end
                            end
                            if not (HaveDevilFruitSea3 or RaidsNow) then
                                spawn(function()
                                    if u24 == false then
                                        u24 = true

                                        Com('F_', 'Cousin', 'Buy')
                                        task.wait(0.1)
                                        StoreMyFruit()
                                        task.wait(90)

                                        u24 = false
                                    end
                                end)
                            end
                            if AutoFastMode and not UseFastModeAuto then
                                pcall(FastModeF)

                                UseFastModeAuto = true

                                task.wait(1)
                            end
                            if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == true then
                                task.wait(0.5)

                                if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == true then
                                    task.wait(0.2)

                                    if not CheckIsland() then
                                        game:GetService('Players').LocalPlayer.Character:WaitForChild('UpperTorso'):Destroy()
                                    end
                                end
                            end
                            if u77 and (inmyself("God's Chalice") and not (CheckButtonColorOpen() or u54)) then
                                u54 = true

                                spawn(function()
                                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('i have cup can anyone do haki quest for me', 'All')
                                    task.wait(4)
                                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer("i'll spawn rip indra", 'All')
                                    task.wait(35)

                                    u54 = false
                                end)
                            end
                            if u77 then
                                local v1189 = tonumber(({
                                    Com('F_', 'Bones', 'Check'),
                                })[3] or 0)

                                if v1189 > 0 then
                                    for _ = 1, v1189 do
                                        Com('F_', 'Bones', 'Buy', 1, 1)
                                        task.wait(0.1)
                                    end
                                end
                            end
                            if (tostring(code_mib) ~= '2' or (tostring(code_biz) ~= '2' or tostring(code_GjoM) ~= '2')) and u76 then
                                AllEcto = Com('F_', 'Ectoplasm', 'Check') or 0

                                if tonumber(AllEcto) >= 100 then
                                    code_mib = Com('F_', unpack({
                                        'Ectoplasm',
                                        'Buy',
                                        3,
                                    }))
                                end
                                if tostring(code_mib) == '2' and tonumber(AllEcto) >= 25 then
                                    code_biz = Com('F_', unpack({
                                        'Ectoplasm',
                                        'Buy',
                                        1,
                                    }))
                                end
                                if tostring(code_biz) == '2' and tonumber(AllEcto) >= 50 then
                                    code_GjoM = Com('F_', unpack({
                                        'Ectoplasm',
                                        'Buy',
                                        2,
                                    }))
                                end
                            end
                        end, function(...)
                            print('ERROR EE : ' ..  ...)
                        end)
                    end
                end
            end)
        end)()
        game.CoreGui.DescendantAdded:Connect(function()
            task.wait(2)
            pcall(function()
                if game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild('ErrorPrompt') and game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild('ErrorPrompt').TitleFrame.ErrorTitle.Text == 'Disconnected' then
                    while task.wait() do
                        if not JustOne then
                            appendfile('BF_Kick_Log.txt', '\n' .. tostring(os.date()) .. ' : ' .. game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild('ErrorPrompt').MessageArea.ErrorFrame.ErrorMessage.Text:split('\n')[1])

                            JustOne = true
                        end

                        u171:Rejoin()
                        task.wait(5)
                    end
                end
            end)
        end)
        LPH_NO_VIRTUALIZE(function()
            spawn(function()
                while task.wait() do
                    if StartKaiTun and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false then
                        local v1190 = 0
                        local v1191 = Usefastattack

                        task.wait(0.5)

                        if 0 + 0.5 >= 900 then
                            game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                            v1190 = v1190 + 1
                        end
                        if v1190 >= 5 then
                            u171:Rejoin()
                        end
                        if StartKaiTun and (Usefastattack ~= not v1191 and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true) then
                            break
                        end
                    end
                end
            end)
            spawn(function()
                while task.wait() do
                    pcall(function()
                        u32 = false

                        local v1192, v1193, v1194 = pairs(game.Workspace.Characters:GetChildren())

                        while true do
                            local v1195

                            v1194, v1195 = v1192(v1193, v1194)

                            if v1194 == nil then
                                break
                            end
                            if (game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position - v1195.HumanoidRootPart.Position).Magnitude < 750 and v1195.Name ~= game.Players.LocalPlayer.Name then
                                u32 = true

                                break
                            end
                        end
                    end)
                end
            end)
            spawn(function()
                while task.wait() do
                    if StartKaiTun and (CheckCanTeleport() and u32 == true) then
                        task.wait(0.5)

                        if 0 + 0.5 >= 500 then
                            local v1196 = u543

                            if string.find(v1196:Update().Text, u547) and u77 or not u77 then
                                u171:TeleportFast()
                            else
                                u171:NormalTeleport()
                            end
                        end
                        if StartKaiTun and (u32 ~= false and CheckCanTeleport()) then
                            break
                        end
                    end
                end
            end)
            spawn(function()
                repeat
                    if not task.wait() then
                        return
                    end
                until StartKaiTun and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false

                local v1197 = CheckCanTeleport()
                local v1198 = 0
                local v1199 = 0

                task.wait(0.5)

                v1198 = v1198 + 0.5

                if v1198 >= 1200 then
                    game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                    v1199 = v1199 + 1
                    v1198 = 800
                end
                if v1199 >= 2 then
                    u171:NormalTeleport()
                end
                if StartKaiTun and (CheckCanTeleport() ~= not v1197 and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible ~= true) then
                end
            end)
            spawn(function()
                while task.wait() do
                    if StartKaiTun and u539:Update().Text == 'Doing Status : Auto Farm' then
                        local v1200 = 0
                        local v1201 = u51

                        task.wait(0.5)

                        if 0 + 0.5 >= 600 then
                            game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                            u52 = true
                            u51 = false
                            u26 = false

                            task.delay(0.1, function()
                                u52 = false
                            end)

                            v1200 = v1200 + 1
                        end
                        if v1200 >= 5 then
                            u171:Rejoin()
                        end
                        if StartKaiTun and u51 ~= not v1201 then
                            break
                        end
                    end
                end
            end)
            spawn(function()
                repeat
                    if not task.wait() then
                        return
                    end
                until StartKaiTun

                local _Position = game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position
                local v1203 = 0

                task.wait(0.5)

                v1203 = v1203 + 0.5

                if v1203 >= 600 then
                    game:GetService('Players').LocalPlayer.Character:WaitForChild('Humanoid'):ChangeState(15)

                    v1203 = 300
                end
                if StartKaiTun and (_Position - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude <= 8 then
                else
                end
            end)
        end)()
        LPH_JIT_MAX(function()
            task.spawn(function()
                while task.wait() do
                    pcall(function()
                        if StartMagnetHaze or (MagnetPirateCas or (MagnetFarmCakePrince or (MagnetFarmCoco or (StartMagnetFarmLevel or (StartMagnetSwan or (StartMagnetSnowLurker or (MagnetFarmSoulGuitar or (StartMagnetFarmLevelMax or (StartMagnetEctoplasm or StartMagnetFarmLevelSkip))))))))) then
                            local v1204, v1205, v1206 = pairs(game.Workspace.Enemies:GetChildren())

                            while true do
                                local v1207

                                v1206, v1207 = v1204(v1205, v1206)

                                if v1206 == nil then
                                    break
                                end
                                if not string.find(v1207.Name, 'Boss') and ((v1207.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 255 and v1207.HumanoidRootPart) then
                                    v1207.HumanoidRootPart.CFrame = PosMon
                                    v1207.Humanoid.JumpPower = 0
                                    v1207.Humanoid.WalkSpeed = 0
                                    v1207.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                    v1207.HumanoidRootPart.Transparency = 1
                                    v1207.HumanoidRootPart.CanCollide = false
                                    v1207.Head.CanCollide = false

                                    if v1207.Humanoid:FindFirstChild('Animator') then
                                        v1207.Humanoid.Animator:Destroy()
                                    end

                                    v1207.Humanoid:ChangeState(4)
                                end
                            end
                        end
                    end)
                end
            end)
        end)()
        spawn(function()
            while task.wait() and StartKaiTun do
                if SpamSkillSea then
                    local v1208, v1209, v1210 = pairs({
                        'Melee',
                        'Sword',
                        'DevilFruit',
                        'Gun',
                    })
                    local v1211 = {}

                    while true do
                        local v1212

                        v1210, v1212 = v1208(v1209, v1210)

                        if v1210 == nil then
                            break
                        end

                        local v1213 = v1212 == 'DevilFruit' and 'Blox Fruit' or v1212
                        local v1214, v1215, v1216 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())

                        while true do
                            local v1217

                            v1216, v1217 = v1214(v1215, v1216)

                            if v1216 == nil then
                                break
                            end
                            if v1217:IsA('Tool') and v1217.ToolTip == v1213 then
                                table.insert(v1211, v1217.Name)
                            end
                        end

                        local v1218, v1219, v1220 = pairs(game.Players.LocalPlayer.Character:GetChildren())

                        while true do
                            local v1221

                            v1220, v1221 = v1218(v1219, v1220)

                            if v1220 == nil then
                                break
                            end
                            if v1221:IsA('Tool') and v1221.ToolTip == v1213 then
                                table.insert(v1211, v1221.Name)
                            end
                        end
                    end

                    local v1222, v1223, v1224 = pairs(v1211)

                    while true do
                        local v1225

                        v1224, v1225 = v1222(v1223, v1224)

                        if v1224 == nil then
                            break
                        end

                        repeat
                            task.wait()
                            EquipWeapon(v1225)
                        until game.Players.LocalPlayer.Character:FindFirstChild(v1225)

                        task.wait()

                        local u1226 = require(game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool'):FindFirstChild('Data') or game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool'):FindFirstChildOfClass('ModuleScript'))
                        local v1227, v1228, v1229 = pairs({
                            'Z',
                            'X',
                            'C',
                        })

                        while true do
                            local u1230

                            v1229, u1230 = v1227(v1228, v1229)

                            if v1229 == nil then
                                break
                            end

                            pcall(function()
                                if u1226.Lvl[u1230] <= game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool'):WaitForChild('Level').Value and (u1230 ~= nil and (u1230 and #u1230 == 1)) then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, tostring(u1230), false, game)
                                    task.wait(0.1)
                                    game:service('VirtualInputManager'):SendKeyEvent(false, tostring(u1230), false, game)
                                    task.wait()
                                end
                            end)
                        end

                        task.wait(0.1)
                    end
                end
            end
        end)

        LoadingScriptSuccess = true

        print('Loading Script Success')

        return
    end
end
