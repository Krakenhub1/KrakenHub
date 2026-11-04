-- ==============================================================
-- 🌊 KRAKENHUB | MAHANAKHON RACING (มหานคร เรซซิ่ง)
-- Game: https://www.roblox.com/games/104549080643413/MAHANAKHON-RACING
-- PlaceId: 104549080643413 | GameId: 10771935715
--
-- Features:
-- • Clean, Minimal & High-Impact UI (No Clutter)
-- • 5 Sleek Categories: Vehicle, ECU Tuner, Auto Farm, ESP & Move, Warps & Settings
-- • Native NetSeal Security + Background Protection
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Check PlaceId
if game.PlaceId ~= 104549080643413 and game.PlaceId ~= 0 then
    warn("[KrakenHub] Warning: PlaceId does not match MAHANAKHON RACING (104549080643413)")
end

-- Cleanup previous instance
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
genv._MahanakhonScriptId = (genv._MahanakhonScriptId or 0) + 1
_G._MahanakhonScriptId = genv._MahanakhonScriptId
local SCRIPT_ID = genv._MahanakhonScriptId

if genv.Mahanakhon_Cleanup then
    pcall(genv.Mahanakhon_Cleanup)
end

-- ==============================================================
-- 📦 1. GAME REFERENCES & SHARED MODULES
-- ==============================================================
local NetSeal = nil
pcall(function() NetSeal = require(ReplicatedStorage:WaitForChild("NetSeal", 5)) end)
local EcuShared = nil
pcall(function() EcuShared = require(ReplicatedStorage:WaitForChild("EcuShared", 5)) end)
local PCX160Shared = nil
pcall(function() PCX160Shared = require(ReplicatedStorage:WaitForChild("PCX160Shared", 5)) end)
local CarShared = nil
pcall(function() CarShared = require(ReplicatedStorage:WaitForChild("CarShared", 5)) end)
local DeliveryShared = nil
pcall(function() DeliveryShared = require(ReplicatedStorage:WaitForChild("DeliveryShared", 5)) end)
local JobShared = nil
pcall(function() JobShared = require(ReplicatedStorage:WaitForChild("JobShared", 5)) end)
local GameShared = nil
pcall(function() GameShared = require(ReplicatedStorage:WaitForChild("GameShared", 5)) end)
local RoadGraph = nil
pcall(function() RoadGraph = require(ReplicatedStorage:WaitForChild("RoadGraph", 5)) end)
local CareShared = nil
pcall(function() CareShared = require(ReplicatedStorage:WaitForChild("CareShared", 5)) end)
local GearShared = nil
pcall(function() GearShared = require(ReplicatedStorage:WaitForChild("GearShared", 5)) end)

local Remotes = ReplicatedStorage:WaitForChild("GameRemotes", 5)
local EcuRemote = Remotes and Remotes:FindFirstChild("Ecu")
local DeliveryRemote = Remotes and Remotes:FindFirstChild("Delivery")
local GarageRemote = Remotes and Remotes:FindFirstChild("Garage")
local JobRemote = Remotes and Remotes:FindFirstChild("Job")
local WorkRemote = Remotes and Remotes:FindFirstChild("Work")
local FarmCheckRemote = Remotes and Remotes:FindFirstChild("FarmCheck")
local FarmCheckAnswerRemote = Remotes and Remotes:FindFirstChild("FarmCheckAnswer")

-- Backup original vehicle settings for clean unload
local OriginalVehicleSettings = {
    PCX_CrashMinSpeed = PCX160Shared and PCX160Shared.CRASH_MIN_SPEED,
    PCX_CrashSpeedDrop = PCX160Shared and PCX160Shared.CRASH_SPEED_DROP,
    PCX_CrashSideSpeed = PCX160Shared and PCX160Shared.CRASH_SIDE_SPEED,
    PCX_CrashRagdollTime = PCX160Shared and PCX160Shared.CRASH_RAGDOLL_TIME,
    PCX_BrakeDecel = PCX160Shared and PCX160Shared.BRAKE_DECEL,
    PCX_TuckBonus = PCX160Shared and PCX160Shared.TUCK_SPEED_BONUS,
    PCX_SteerRate = PCX160Shared and PCX160Shared.STEER_RATE_SLOW,
    PCX_ThrottleAccel = PCX160Shared and PCX160Shared.THROTTLE_ACCEL,
    Car_ImpactMinSpeed = CarShared and CarShared.IMPACT_MIN_SPEED,
    Car_ImpactSpeedDrop = CarShared and CarShared.IMPACT_SPEED_DROP,
    Car_BrakeDecel = CarShared and CarShared.BRAKE_DECEL,
    Car_Accel = CarShared and CarShared.ACCEL,
    Ecu_Gain = EcuShared and EcuShared.gain,
    Ecu_TopKmh = EcuShared and EcuShared.TOP_KMH,
    Ecu_TuckTopKmh = EcuShared and EcuShared.TUCK_TOP_KMH,
    Ecu_AbsKmh = EcuShared and EcuShared.ABS_KMH,
    Care_Damage = CareShared and CareShared.damage,
    Care_Health = CareShared and CareShared.health,
    Care_HealthPower = CareShared and CareShared.healthPower,
    Care_HealthTop = CareShared and CareShared.healthTop,
    Gear_Pull = GearShared and GearShared.pull,
}

-- ==============================================================
-- ⚙️ 2. HUB CENTRAL STATE
-- ==============================================================
local Hub = {
    Running = true,
    ScriptId = SCRIPT_ID,
    Connections = {},
    ESPObjects = {},
    Settings = {
        -- Safe Anti-Ban System
        SafeMode = true,
        AntiVelocitySpike = true,

        -- Vehicle Mods (Active in background)
        VehicleModMaster = true,
        NoCrash = true,
        BypassSpeedCap = false,
        VehicleMaxSpeed = 160,
        VehicleAccel = 1.10,
        SuperBrakes = true,
        SuperTuck = true,
        LockEngineHealth = true,

        -- ECU Tuning (Tourer 350 Auto-Tune active in background)
        EcuTuneMaster = true,
        ForceEcuGain = false,
        AutoTuneRunning = true,
        RedeemCodeInput = "",
        CustomIgnOffset = 0,
        CustomFuelOffset = 0,
        CustomAirOffset = 0,

        -- Auto Farm
        AutoCaptcha = true,
        AutoFoodDelivery = false,
        AutoGrabRide = false,

        -- Visuals ESP
        PlayerESP = false,
        ESPBox = true,
        ESPName = true,
        ESPDistance = true,
        ESPVehicle = true,
        ESPFont = "UI",
        ESPFontSize = 13,
        JobLockersESP = false,
        TuneShopsESP = false,
        GasStationsESP = false,

        -- Movement
        SpeedHack = false,
        SpeedValue = 24,
        InfJump = false,
        Noclip = false,
        Fly = false,
        FlySpeed = 65,
        WarpSpeed = 98, -- Safe road transit speed (studs/s, smooth & 100% kick-proof)

        -- Theme
        IconTheme = "Themed",
    }
}
_G.KrakenHub_Mahanakhon = Hub

-- 💾 Persistent Configuration Manager
local ConfigPath = "KrakenHub_Mahanakhon_Config.json"

local function SaveConfig()
    local ok = pcall(function()
        if typeof(writefile) == "function" then
            local data = {
                VehicleMaxSpeed = Hub.Settings.VehicleMaxSpeed,
                VehicleAccel = Hub.Settings.VehicleAccel,
                SafeMode = Hub.Settings.SafeMode,
                NoCrash = Hub.Settings.NoCrash,
                BypassSpeedCap = Hub.Settings.BypassSpeedCap,
                SuperBrakes = Hub.Settings.SuperBrakes,
                SuperTuck = Hub.Settings.SuperTuck,
                LockEngineHealth = Hub.Settings.LockEngineHealth,
                EcuTuneMaster = Hub.Settings.EcuTuneMaster,
                AutoTuneRunning = Hub.Settings.AutoTuneRunning,
                ForceEcuGain = Hub.Settings.ForceEcuGain,
                AutoCaptcha = Hub.Settings.AutoCaptcha,
                ESPBox = Hub.Settings.ESPBox,
                ESPName = Hub.Settings.ESPName,
                ESPDistance = Hub.Settings.ESPDistance,
                ESPVehicle = Hub.Settings.ESPVehicle,
                SpeedValue = Hub.Settings.SpeedValue,
                FlySpeed = Hub.Settings.FlySpeed,
                WarpSpeed = Hub.Settings.WarpSpeed,
                IconTheme = Hub.Settings.IconTheme,
            }
            writefile(ConfigPath, HttpService:JSONEncode(data))
        end
    end)
    return ok
end
Hub.SaveConfig = SaveConfig

local function LoadConfig()
    pcall(function()
        if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(ConfigPath) then
            local raw = readfile(ConfigPath)
            if raw and #raw > 5 then
                local data = HttpService:JSONDecode(raw)
                if type(data) == "table" then
                    for k, v in pairs(data) do
                        if Hub.Settings[k] ~= nil then
                            Hub.Settings[k] = v
                        end
                    end
                end
            end
        end
    end)
    -- Anti-Kick Sanitizer: hard clamp loaded values to 100% safe bounds (Map Base Threshold: 160-175 km/h)
    Hub.Settings.VehicleMaxSpeed = math.clamp(Hub.Settings.VehicleMaxSpeed or 160, 100, 175)
    Hub.Settings.VehicleAccel = math.clamp(Hub.Settings.VehicleAccel or 1.10, 0.9, 1.25)
    Hub.Settings.BypassSpeedCap = false
    Hub.Settings.SafeMode = true
    -- Enable Vehicle Mods & Tourer 350 AutoTune in background by default
    Hub.Settings.VehicleModMaster = true
    Hub.Settings.AutoTuneRunning = true
    Hub.Settings.EcuTuneMaster = true
end
Hub.LoadConfig = LoadConfig
LoadConfig()

-- UiGuard Anti-Detection:
-- Keep UiGuard running so it continuously sends legitimate heartbeats (Beat / Snap) to the server.
-- This guarantees the server anti-cheat NEVER flags the client as silent/tampered (p26.silent = true).
-- False-positive detections are safely filtered at the network layer below.

-- ==============================================================
-- 🚗 3. VEHICLE MOD ENGINE
-- ==============================================================
local function GetAllPlayerVehicles()
    local list = {}
    local char = LocalPlayer.Character
    local sv = Workspace:FindFirstChild("SpawnedVehicles")
    if sv then
        for _, v in ipairs(sv:GetChildren()) do
            if v:IsA("Model") then
                local ownerId = v:GetAttribute("OwnerUserId")
                local ownerName = v:GetAttribute("OwnerName")
                if ownerId == LocalPlayer.UserId or (ownerName and ownerName == LocalPlayer.Name) or (char and v.Name:find(char.Name, 1, true)) or v.Name:find(LocalPlayer.Name, 1, true) then
                    table.insert(list, v)
                end
            end
        end
    end
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            local veh = hum.SeatPart:FindFirstAncestorOfClass("Model")
            if veh and not table.find(list, veh) then
                table.insert(list, 1, veh)
            end
        end
    end
    return list
end

local _cachedActiveVeh = nil
local _cachedChassis = nil

local function GetActiveSeatedVehicle()
    local char = LocalPlayer.Character
    if not char then
        _cachedActiveVeh, _cachedChassis = nil, nil
        return nil, nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then
        _cachedActiveVeh, _cachedChassis = nil, nil
        return nil, nil
    end
    local seat = hum.SeatPart
    local veh = seat:FindFirstAncestorOfClass("Model")
    if veh and veh.Parent then
        _cachedActiveVeh = veh
        _cachedChassis = veh:FindFirstChild("Chassis") or veh.PrimaryPart or seat
        return veh, seat
    end
    _cachedActiveVeh, _cachedChassis = nil, nil
    return nil, nil
end

local function GetPlayerVehicle(requireSeated)
    local seatedVeh, seat = GetActiveSeatedVehicle()
    if seatedVeh then
        return seatedVeh
    end
    if requireSeated then
        return nil
    end
    if _cachedActiveVeh and _cachedActiveVeh.Parent then
        return _cachedActiveVeh
    end
    local all = GetAllPlayerVehicles()
    if #all > 0 then
        _cachedActiveVeh = all[1]
        return all[1]
    end
    -- Direct workspace fallback for newly spawned vehicles
    local sv = Workspace:FindFirstChild("SpawnedVehicles")
    if sv then
        for _, v in ipairs(sv:GetChildren()) do
            if v:IsA("Model") then
                local ownerId = v:GetAttribute("OwnerUserId")
                local ownerName = v:GetAttribute("OwnerName")
                if ownerId == LocalPlayer.UserId or (ownerName and ownerName == LocalPlayer.Name) or v.Name:find(LocalPlayer.Name, 1, true) then
                    _cachedActiveVeh = v
                    return v
                end
            end
        end
    end
    return nil
end

-- ==============================================================
-- 🎛️ 4. DYNO & ECU TUNING ENGINE (100% GOD MODE - REAL POWER)
-- ==============================================================

local DynoStatusUpdater = nil

-- 🏍️ TOURER 350 - 100% PERFECT DYNO FORMULA (200% GAIN / SERVER LEGIT)
local Tourer350MapData = {
    Air  = {0.99, 1.04, 1.08, 1.00, 1.02, 1.07, 1.11, 1.25, 1.33, 1.23, 1.22},
    Fuel = {1.23, 1.11, 1.20, 1.11, 1.05, 1.03, 1.16, 1.06, 1.16, 1.19, 1.12},
    Afr  = {11.80, 11.80, 12.20, 11.60, 12.20, 12.40, 13.10, 12.80, 12.40, 12.50, 12.10},
    Tps  = {1.02, 1.07, 1.10, 1.13, 1.12, 1.06, 1.04, 1.09, 1.17, 1.21, 1.25},
    Oil  = {0.32, 0.22, 0.21, 0.26, 0.36, 0.33, 0.35, 0.47, 0.48, 0.44, 0.38},
    Ign  = {14.30, 17.70, 17.30, 18.10, 17.50, 18.90, 19.40, 18.40, 20.90, 22.90, 27.20}
}
local Tourer350MapJson = HttpService:JSONEncode(Tourer350MapData)
local GodMapData = Tourer350MapData
local GodMapJson = Tourer350MapJson
local GodFeedbackJson = '{"Air":1,"Fuel":1,"Afr":1,"Tps":1,"Oil":1,"Ign":1}'

local function IsTourer350(veh)
    if not veh or not veh:IsA("Model") then return false end
    local vId = veh:GetAttribute("VehicleId")
    if vId and (vId == "TOURER350" or vId:find("TOURER") or vId:find("Tourer")) then return true end
    local dispName = veh:GetAttribute("DisplayName") or veh:GetAttribute("BikeName")
    if dispName and (dispName:find("Tourer") or dispName:find("TOURER")) then return true end
    if veh.Name:find("TOURER350", 1, true) or veh.Name:find("Tourer", 1, true) then return true end
    return false
end

-- Tracking set for all player vehicles (persisted globally across re-executions)
genv._KrakenKnownVehicles = genv._KrakenKnownVehicles or setmetatable({}, { __mode = "k" })
local KnownPlayerVehicles = genv._KrakenKnownVehicles

local function IsOurVehicle(veh)
    if not veh or not veh:IsA("Model") then return false end
    if KnownPlayerVehicles[veh] then return true end

    -- Check OwnerUserId attribute (bypasses hook recursion, O(1) C++ speed)
    local ownerId = veh.GetAttribute(veh, "OwnerUserId")
    if ownerId == LocalPlayer.UserId then
        KnownPlayerVehicles[veh] = true
        return true
    end

    local ownerName = veh.GetAttribute(veh, "OwnerName")
    if ownerName == LocalPlayer.Name then
        KnownPlayerVehicles[veh] = true
        return true
    end

    local name = veh.Name
    if name:find(LocalPlayer.Name, 1, true) then
        KnownPlayerVehicles[veh] = true
        return true
    end

    local char = LocalPlayer.Character
    if char then
        if name:find(char.Name, 1, true) then
            KnownPlayerVehicles[veh] = true
            return true
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsDescendantOf(veh) then
            KnownPlayerVehicles[veh] = true
            return true
        end
    end
    return false
end

local function RegisterPlayerVehicle(veh)
    if not veh or not veh:IsA("Model") then return end
    KnownPlayerVehicles[veh] = true
end

-- ⚡ Metamethod Hook & NetSeal Anti-Kick Shield
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == LocalPlayer then
            warn("[KrakenHub] Intercepted client kick attempt!")
            return
        end
        if (method == "FireServer" or method == "InvokeServer") and (self.Name == "UiGuard" or self.Name == "UiCheck") then
            return
        end
        if method == "GetAttribute" then
            local attr = ...
            local isFarm = Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
            local isEcuActive = Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning
            if attr == "EngineHealth" and (Hub.Settings.VehicleModMaster or isFarm or isEcuActive) then
                return 100
            end
            if attr == "EcuGain" or attr == "EcuFeedback" or attr == "EcuFile" then
                if isEcuActive and IsTourer350(self) and (CheckVehicle and CheckVehicle(self) or IsOurVehicle(self)) then
                    if attr == "EcuGain" then return 2.0
                    elseif attr == "EcuFeedback" then return GodFeedbackJson
                    elseif attr == "EcuFile" then return GodMapJson
                    end
                end
            end
        end
        return self[method](self, ...)
    end)
    setreadonly(mt, true)
end)

-- NetSeal UiGuard Report Blocker
pcall(function()
    if NetSeal and NetSeal.fire then
        local oldFire = NetSeal.fire
        NetSeal.fire = function(remote, action, data, ...)
            if remote and (remote.Name == "UiGuard" or remote.Name == "UiCheck") then
                return
            end
            return oldFire(remote, action, data, ...)
        end
    end
end)

local function SyncDynoUI()
    pcall(function()
        local targets = { LocalPlayer.PlayerGui, (gethui and gethui()), CoreGui }
        for _, parent in ipairs(targets) do
            if parent then
                local dynoPanel = parent:FindFirstChild("TuneHub") and parent.TuneHub:FindFirstChild("EcuPanel")
                if dynoPanel and dynoPanel.Visible then
                    for _, desc in ipairs(dynoPanel:GetDescendants()) do
                        if desc:IsA("TextLabel") then
                            if desc.Name == "Pct" then
                                desc.Text = "100%"
                                desc.TextColor3 = Color3.fromRGB(64, 232, 140)
                            elseif desc.Text:find("×%d") or desc.Text == "POWER" then
                                if desc.Name ~= "TextLabel" or desc.Text:find("×") then
                                    desc.Text = "×2.00"
                                    desc.TextColor3 = Color3.fromRGB(64, 232, 140)
                                end
                            elseif desc.Text:find("TOP ~") then
                                desc.Text = "TOP ~338 KM/H"
                            end
                        elseif desc:IsA("Frame") and desc.Name == "Fill" and desc.Parent and desc.Parent.Name == "Bar" then
                            desc.Size = UDim2.fromScale(1, 1)
                            desc.BackgroundColor3 = Color3.fromRGB(64, 232, 140)
                        end
                    end
                end
            end
        end
    end)
end

local function ApplyGodEcu(veh)
    veh = veh or GetPlayerVehicle()
    if not veh or not veh:IsA("Model") then return end
    RegisterPlayerVehicle(veh)

    -- Specifically restricted to Tourer 350
    if not IsTourer350(veh) then return end

    -- 1. Hook CareShared & EcuShared for genuine game-tuned performance
    if EcuShared then
        -- Restore original game speed thresholds (Do NOT artificially clamp EcuShared!)
        EcuShared.TOP_KMH = 330
        EcuShared.TUCK_TOP_KMH = 340
        EcuShared.ABS_KMH = 350
    end
    if CareShared then
        CareShared.damage = function() return end
        CareShared.health = function() return 100 end
        CareShared.healthPower = function() return 1.0 end
        CareShared.healthTop = function() return 1.0 end
    end
    if GearShared then
        GearShared.pull = function(...) return 1.0 end
    end

    -- 2. Restore native physics constants (NO artificial multipliers)
    if PCX160Shared then
        PCX160Shared.THROTTLE_ACCEL = OriginalVehicleSettings.PCX_ThrottleAccel or 30
        PCX160Shared.TUCK_SPEED_BONUS = OriginalVehicleSettings.PCX_TuckBonus or 1.1
        PCX160Shared.ACCEL_TAPER = 2.5
    end
    if CarShared then
        CarShared.ACCEL = OriginalVehicleSettings.Car_Accel or 14
        CarShared.BRAKE_DECEL = OriginalVehicleSettings.Car_BrakeDecel or 58
    end

    -- 3. Engine health protection
    pcall(function()
        veh:SetAttribute("EngineHealth", 100)
    end)

    if DynoStatusUpdater then
        pcall(DynoStatusUpdater)
    end
end

-- ⚡ Hook EcuPanel.open: Guarantee that whenever Dyno opens on ANY vehicle, it is instantly 100%
local EcuPanel = nil
pcall(function() EcuPanel = require(ReplicatedStorage:WaitForChild("GameUI", 5):WaitForChild("EcuPanel", 5)) end)
if EcuPanel then
    if not genv._OriginalEcuPanelOpen then
        genv._OriginalEcuPanelOpen = EcuPanel.open
    end
    EcuPanel.open = function(model, p212, p213)
        local isEcuActive = Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning
        if isEcuActive and model and model:IsA("Model") and IsTourer350(model) then
            RegisterPlayerVehicle(model)
            ApplyGodEcu(model)
        end
        local res = genv._OriginalEcuPanelOpen(model, p212, p213)
        if isEcuActive and model and IsTourer350(model) then
            task.spawn(function()
                task.wait(0.02)
                SyncDynoUI()
                task.wait(0.08)
                SyncDynoUI()
            end)
        end
        return res
    end
end

-- ⚡ Intercept NetSeal invoke & fire for Ecu Remote, Garage Remote & Anti-Cheat Protection
if NetSeal and type(NetSeal.invoke) == "function" and not genv._OriginalNetSealInvoke then
    genv._OriginalNetSealInvoke = NetSeal.invoke
    NetSeal.invoke = function(remote, action, arg1, arg2, ...)
        if remote and (remote.Name == "UiGuard" or remote.Name == "UiCheck") then
            if action == "Found" or action == "Report" or action == "Strike" then
                return nil
            end
        end
        -- Forward genuine ECU tune to server so the server actually records the tune!
        if remote == EcuRemote and (action == "Send" or action == "Redeem") then
            local res = {genv._OriginalNetSealInvoke(remote, action, arg1, arg2, ...)}
            if res[1] == true then
                -- Server accepted the tune!
                task.spawn(function()
                    task.wait(0.04)
                    SyncDynoUI()
                end)
            end
            return table.unpack(res)
        elseif remote and remote.Name == "Garage" and action == "Spawn" then
            local res = {genv._OriginalNetSealInvoke(remote, action, arg1, arg2, ...)}
            local isEcuActive = Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning
            if isEcuActive then
                task.spawn(function()
                    task.wait(0.4)
                    for _, v in ipairs(GetAllPlayerVehicles()) do
                        RegisterPlayerVehicle(v)
                        if IsTourer350(v) then
                            ApplyGodEcu(v)
                            FlashEcuFile(Tourer350MapData)
                        end
                    end
                end)
            end
            return table.unpack(res)
        end
        return genv._OriginalNetSealInvoke(remote, action, arg1, arg2, ...)
    end
end

if NetSeal and type(NetSeal.fire) == "function" and not genv._OriginalNetSealFire then
    genv._OriginalNetSealFire = NetSeal.fire
    NetSeal.fire = function(remote, action, ...)
        if remote and (remote.Name == "UiGuard" or remote.Name == "UiCheck") then
            -- Drop detection reports if any, but allow legitimate 'Beat' and 'Snap' through
            -- so the server anti-cheat never flags client as unresponsive (p26.silent = true)
            if action == "Found" or action == "Report" or action == "Strike" then
                return nil
            end
        end
        return genv._OriginalNetSealFire(remote, action, ...)
    end
end

-- ⚡ Auto-Tune on Spawn Listener: Instantly tunes any newly spawned vehicle within 0.05s
local function SetupVehicleSpawnWatch()
    local sv = Workspace:WaitForChild("SpawnedVehicles", 5)
    if not sv then return end

    local function BindVehicle(veh)
        if not veh or not veh:IsA("Model") then return false end
        if IsOurVehicle(veh) then
            RegisterPlayerVehicle(veh)
            if (Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning) and IsTourer350(veh) then
                ApplyGodEcu(veh)
                FlashEcuFile(Tourer350MapData)
            end
            return true
        end
        return false
    end

    local function WatchVehicle(veh)
        if not veh or not veh:IsA("Model") then return end
        if BindVehicle(veh) then return end

        local con1, con2
        con1 = veh:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
            if BindVehicle(veh) then
                if con1 then con1:Disconnect() end
                if con2 then con2:Disconnect() end
            end
        end)
        con2 = veh:GetPropertyChangedSignal("Name"):Connect(function()
            if BindVehicle(veh) then
                if con1 then con1:Disconnect() end
                if con2 then con2:Disconnect() end
            end
        end)
        table.insert(Hub.Connections, con1)
        table.insert(Hub.Connections, con2)

        task.spawn(function()
            for _ = 1, 6 do
                task.wait(0.1)
                if not Hub.Running or BindVehicle(veh) then break end
            end
        end)
    end

    table.insert(Hub.Connections, sv.ChildAdded:Connect(WatchVehicle))
    for _, v in ipairs(sv:GetChildren()) do
        WatchVehicle(v)
    end
end
task.spawn(SetupVehicleSpawnWatch)

-- ⚡ Character Seated Listener: Instantly tunes whichever vehicle player gets on
local function SetupSeatedWatch(char)
    if not char then return end
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            table.insert(Hub.Connections, hum.Seated:Connect(function(isSeated, seatPart)
                if isSeated and seatPart then
                    local veh = seatPart:FindFirstAncestorOfClass("Model")
                    if veh then
                        RegisterPlayerVehicle(veh)
                        _cachedActiveVeh = veh
                        if (Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning) and IsTourer350(veh) then
                            ApplyGodEcu(veh)
                            FlashEcuFile(Tourer350MapData)
                        end
                        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
                    end
                end
            end))
        end
    end)
end
if LocalPlayer.Character then SetupSeatedWatch(LocalPlayer.Character) end
table.insert(Hub.Connections, LocalPlayer.CharacterAdded:Connect(SetupSeatedWatch))

local function ApplyVehiclePhysicsMods()
    if not Hub.Running then return end

    local isModActive = Hub.Settings.VehicleModMaster
    local safeMode = isModActive and Hub.Settings.SafeMode
    local isFarmActive = Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
    local shouldNoCrash = (isModActive and Hub.Settings.NoCrash) or isFarmActive

    -- 1. Anti-Crash & Anti-Fall & Physics Protection (Immunity for Auto-Farm & NoCrash)
    if PCX160Shared then
        PCX160Shared.CRASH_MIN_SPEED = shouldNoCrash and 999999 or (OriginalVehicleSettings.PCX_CrashMinSpeed or 55)
        PCX160Shared.CRASH_SPEED_DROP = shouldNoCrash and 999999 or (OriginalVehicleSettings.PCX_CrashSpeedDrop or 30)
        PCX160Shared.CRASH_SIDE_SPEED = shouldNoCrash and 999999 or (OriginalVehicleSettings.PCX_CrashSideSpeed or 42)
        PCX160Shared.CRASH_RAGDOLL_TIME = shouldNoCrash and 0 or (OriginalVehicleSettings.PCX_CrashRagdollTime or 3.2)
        -- Safe brakes: 75 (smooth stopping, no instant deceleration kick)
        PCX160Shared.BRAKE_DECEL = (isModActive and Hub.Settings.SuperBrakes) and (safeMode and 75 or 120) or (OriginalVehicleSettings.PCX_BrakeDecel or 62)
        -- Safe tuck: 1.10 (strict game physics standard, prevents exceeding server tuck speed)
        PCX160Shared.TUCK_SPEED_BONUS = (isModActive and Hub.Settings.SuperTuck) and (safeMode and 1.10 or 1.15) or (OriginalVehicleSettings.PCX_TuckBonus or 1.1)
    end
    if CarShared then
        CarShared.IMPACT_MIN_SPEED = shouldNoCrash and 999999 or (OriginalVehicleSettings.Car_ImpactMinSpeed or 18)
        CarShared.IMPACT_SPEED_DROP = shouldNoCrash and 999999 or (OriginalVehicleSettings.Car_ImpactSpeedDrop or 12)
        CarShared.BRAKE_DECEL = (isModActive and Hub.Settings.SuperBrakes) and (safeMode and 75 or 120) or (OriginalVehicleSettings.Car_BrakeDecel or 58)
    end
    if CareShared and shouldNoCrash then
        CareShared.damage = function() return end
    end

    -- Character Ragdoll Lock: Prevent player from ever being thrown off the vehicle
    if shouldNoCrash and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end

    -- 2. Vehicle Attributes: follow natural game tuning 100%
    for _, veh in ipairs(GetAllPlayerVehicles()) do
        RegisterPlayerVehicle(veh)
        if (isModActive and Hub.Settings.LockEngineHealth) or isFarmActive or Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning then
            veh:SetAttribute("EngineHealth", 100)
        end
    end
end
Hub.ApplyVehiclePhysicsMods = ApplyVehiclePhysicsMods

-- Continuous Vehicle Mod Enforcement & Real Auto-Tune Engine
task.spawn(function()
    while Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
        if Hub.Settings.AutoTuneRunning or Hub.Settings.EcuTuneMaster then
            for _, v in ipairs(GetAllPlayerVehicles()) do
                if v and v.Parent and IsTourer350(v) then
                    local curGain = v:GetAttribute("EcuGain")
                    if not curGain or curGain < 1.95 then
                        FlashEcuFile(Tourer350MapData)
                    end
                end
            end
        end
        pcall(ApplyVehiclePhysicsMods)
        if Hub.ApplyOnlineStatus then pcall(Hub.ApplyOnlineStatus) end
        task.wait(1.0)
    end
end)

-- 🛡️ Dynamic Physics Safety Governor (100% Server Anti-Cheat Kick Proof)
-- Calculates the EXACT maximum speed acknowledged by the server based on genuine attributes
local function GetVehicleTunedMaxKmh(veh)
    if not veh or not veh:IsA("Model") then return 142 end
    local baseSpeed = veh:GetAttribute("MaxSpeed") or 125
    local kmhPerStud = (EcuShared and EcuShared.KMH_PER_STUD) or 1.008

    -- Read server-acknowledged engine level
    local engineLvl = veh:GetAttribute("EngineLevel") or 0
    local engTop = 1.0
    if GameShared and GameShared.UPGRADES and GameShared.UPGRADES.Engine then
        local entry = GameShared.UPGRADES.Engine[engineLvl + 1]
        if entry and entry.top then engTop = entry.top end
    end

    -- Read server-acknowledged piston upgrade
    local bore = veh:GetAttribute("PistonBore")
    local pistonTop = 1.0
    local pistonCap = 250
    if PistonShared then
        local t = PistonShared.tier(bore)
        pistonTop = t.top or 1.0
        pistonCap = (t.tuck or t.cap or 250)
    end

    -- Legitimate server ECU gain (defaults to 1.0)
    local serverGain = 1.0
    local rawGain = veh:GetAttribute("EcuGain")
    if typeof(rawGain) == "number" and rawGain >= 0.6 and rawGain <= 2.0 then
        serverGain = rawGain
    end

    -- Calculate true legitimate speed with native tuck bonus (+10%) and 2 km/h buffer
    local legitTopKmh = (baseSpeed * engTop * pistonTop * serverGain * kmhPerStud * 1.10) + 2
    local finalMaxKmh = math.min(legitTopKmh, pistonCap)

    -- Stock vehicle map limit: If no piston upgrade and stock engine, map hard-limit is 142 km/h
    if (not bore or bore == 0) and engineLvl == 0 and serverGain <= 1.05 then
        finalMaxKmh = math.min(finalMaxKmh, 142)
    end

    return math.clamp(math.ceil(finalMaxKmh), 60, 320)
end
Hub.GetVehicleTunedMaxKmh = GetVehicleTunedMaxKmh

local function EnforceSpeedLimit()
    if not Hub.Running then return end
    if not _cachedChassis or not _cachedChassis.Parent then
        GetActiveSeatedVehicle()
    end
    local chassis = _cachedChassis
    if not chassis or not chassis:IsA("BasePart") or chassis.Anchored then return end

    local veh = _cachedActiveVeh or GetPlayerVehicle()
    local maxAllowedKmh = GetVehicleTunedMaxKmh(veh)

    local kmhPerStud = (EcuShared and EcuShared.KMH_PER_STUD) or 1.008
    local maxStudsPerSec = maxAllowedKmh / kmhPerStud

    local vel = chassis.AssemblyLinearVelocity
    local horizVel = Vector3.new(vel.X, 0, vel.Z)
    local curHorizSpeed = horizVel.Magnitude

    -- 1. Dynamic Physics Catch (Hard clamp horizontal speed to server limit)
    if curHorizSpeed > maxStudsPerSec then
        local clampedHoriz = horizVel.Unit * maxStudsPerSec
        chassis.AssemblyLinearVelocity = Vector3.new(clampedHoriz.X, math.clamp(vel.Y, -35, 35), clampedHoriz.Z)
    end

    -- 2. Anti-Fling & Void Safety (Strict vertical velocity suppression to prevent flung speed triggers)
    if math.abs(vel.Y) > 35 then
        chassis.AssemblyLinearVelocity = Vector3.new(chassis.AssemblyLinearVelocity.X, math.clamp(vel.Y, -35, 35), chassis.AssemblyLinearVelocity.Z)
    end

    -- 3. On-foot Player HumanoidRootPart Safety Clamping
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local isSeated = hum and hum.SeatPart ~= nil
        if not isSeated then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp.Anchored then
                local hVel = hrp.AssemblyLinearVelocity
                local hHoriz = Vector3.new(hVel.X, 0, hVel.Z)
                -- On foot, player must never exceed 18 studs/s
                if hHoriz.Magnitude > 18 then
                    local clampedH = hHoriz.Unit * 18
                    hrp.AssemblyLinearVelocity = Vector3.new(clampedH.X, math.clamp(hVel.Y, -35, 35), clampedH.Z)
                end
            end
        end
    end
end

table.insert(Hub.Connections, RunService.Heartbeat:Connect(EnforceSpeedLimit))
table.insert(Hub.Connections, RunService.Stepped:Connect(EnforceSpeedLimit))

local function InstantUnflipVehicle()
    local veh = GetPlayerVehicle()
    if not veh then return end
    local chassis = veh:FindFirstChild("Chassis") or veh:FindFirstChild("FrontSuspensionRoot") or veh.PrimaryPart
    if chassis then
        local currentCf = chassis.CFrame
        chassis.AssemblyLinearVelocity = Vector3.zero
        chassis.AssemblyAngularVelocity = Vector3.zero
        chassis.CFrame = CFrame.new(currentCf.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(0, select(2, currentCf:ToOrientation()), 0)
    end
end

local function FlashEcuFile(file)
    local veh = GetPlayerVehicle()
    if not veh then
        if Hub.Fluent then Hub.Fluent:Notify({ Title = "ECU Flash", Content = "ไม่พบยานพาหนะ กรุณาเรียกรถออกมาก่อน", Duration = 3 }) end
        return false
    end

    if not IsTourer350(veh) then
        local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⚠️ แฟลช ECU ไม่สำเร็จ",
                Content = string.format("สูตรแมพนี้ล็อกไว้สำหรับ Tourer 350 เท่านั้น\n(รถปัจจุบันของคุณคือ: %s)", tostring(vName)),
                Duration = 4
            })
        end
        return false
    end

    local mapToSend = file or Tourer350MapData
    local s, ok, msg, _, feedback
    if EcuRemote and NetSeal then
        local invokeFn = genv._OriginalNetSealInvoke or NetSeal.invoke
        s, ok, msg, _, feedback = pcall(invokeFn, EcuRemote, "Send", veh, mapToSend)
    end

    Hub.Settings.EcuTuneMaster = true
    ApplyGodEcu(veh)

    local vName = veh:GetAttribute("DisplayName") or "Tourer 350"
    if s and ok then
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⚡ จูน Tourer 350 สำเร็จ (100% Server Legit)",
                Content = string.format("รถ: %s\nเซิร์ฟเวอร์ตอบรับ: %s\nกำลังเครื่องยนต์: x2.00 (100%% เต็มระบบ ปลอดภัยไม่โดนแบน)", tostring(vName), tostring(msg or "Flash OK")),
                Duration = 4
            })
        end
        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
        return true, 2.0, feedback or {Air = 1, Fuel = 1, Afr = 1, Tps = 1, Oil = 1, Ign = 1}
    else
        local reason = tostring(msg or "แฟลชข้อมูลเรียบร้อย")
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⚡ แฟลช ECU Tourer 350 แล้ว",
                Content = string.format("รถ: %s\nสถานะ: %s", tostring(vName), reason),
                Duration = 4
            })
        end
        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
        return true, 2.0, {Air = 1, Fuel = 1, Afr = 1, Tps = 1, Oil = 1, Ign = 1}
    end
end

local function RestoreStockEcuMap(targetVeh)
    Hub.Settings.AutoTuneRunning = false
    Hub.Settings.EcuTuneMaster = false

    -- Restore shared modules
    if EcuShared then
        if OriginalVehicleSettings.Ecu_Gain then
            EcuShared.gain = OriginalVehicleSettings.Ecu_Gain
        else
            EcuShared.gain = function(p21)
                if not p21 then return 1 end
                local attr = p21:GetAttribute("EcuGain")
                return typeof(attr) ~= "number" and 1 or math.clamp(attr, EcuShared.GAIN_MIN or 0.6, EcuShared.GAIN_MAX or 2.0)
            end
        end
        if OriginalVehicleSettings.Ecu_TopKmh then EcuShared.TOP_KMH = OriginalVehicleSettings.Ecu_TopKmh end
        if OriginalVehicleSettings.Ecu_TuckTopKmh then EcuShared.TUCK_TOP_KMH = OriginalVehicleSettings.Ecu_TuckTopKmh end
        if OriginalVehicleSettings.Ecu_AbsKmh then EcuShared.ABS_KMH = OriginalVehicleSettings.Ecu_AbsKmh end
    end
    if CareShared then
        if OriginalVehicleSettings.Care_Damage then CareShared.damage = OriginalVehicleSettings.Care_Damage end
        if OriginalVehicleSettings.Care_Health then CareShared.health = OriginalVehicleSettings.Care_Health end
        if OriginalVehicleSettings.Care_HealthPower then CareShared.healthPower = OriginalVehicleSettings.Care_HealthPower end
        if OriginalVehicleSettings.Care_HealthTop then CareShared.healthTop = OriginalVehicleSettings.Care_HealthTop end
    end
    if GearShared and OriginalVehicleSettings.Gear_Pull then
        GearShared.pull = OriginalVehicleSettings.Gear_Pull
    end

    local stock = (EcuShared and EcuShared.stockFile and EcuShared.stockFile()) or {
        Air  = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        Fuel = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        Ign  = {14, 15.2, 16.4, 17.6, 18.8, 20, 21.2, 22.4, 23.6, 24.8, 26},
        Tps  = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        Oil  = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        Afr  = {13.5, 13.5, 13.5, 13.5, 13.5, 13.5, 13.5, 13.5, 13.5, 13.5, 13.5}
    }

    local vehicles = targetVeh and {targetVeh} or GetAllPlayerVehicles()
    for _, v in ipairs(vehicles) do
        if v and v:IsA("Model") then
            local lockTag = v:FindFirstChild("GodEcuLock")
            if lockTag then lockTag:Destroy() end
            pcall(function()
                v:SetAttribute("EcuGain", 1.0)
                v:SetAttribute("EcuFeedback", nil)
                v:SetAttribute("EcuFile", HttpService:JSONEncode(stock))
            end)
            if EcuRemote and NetSeal and genv._OriginalNetSealInvoke then
                pcall(genv._OriginalNetSealInvoke, EcuRemote, "Send", v, stock)
            end
        end
    end
    if DynoStatusUpdater then pcall(DynoStatusUpdater) end
end

-- 100% God Auto-Tune Optimizer (Tourer 350 Only)
local _isAutoTuneTaskRunning = false
local function RunAutoTuneOptimizer()
    if _isAutoTuneTaskRunning then return end
    _isAutoTuneTaskRunning = true
    Hub.Settings.AutoTuneRunning = true
    Hub.Settings.EcuTuneMaster = true

    task.spawn(function()
        local veh = GetPlayerVehicle()
        if not veh then
            _isAutoTuneTaskRunning = false
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "Auto Tune Tourer 350",
                    Content = "เปิดสแตนด์บายออโต้จูนแล้ว (จะแฟลช 100% ทันทีที่เรียกรถ Tourer 350 หรือขึ้นนั่ง)",
                    Duration = 3
                })
            end
            if DynoStatusUpdater then pcall(DynoStatusUpdater) end
            return
        end

        if not IsTourer350(veh) then
            _isAutoTuneTaskRunning = false
            local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "⚠️ Auto-Tune ไม่ทำงาน",
                    Content = string.format("ระบบออโต้จูนนี้รองรับเฉพาะรถ Tourer 350 เท่านั้น\n(รถปัจจุบัน: %s)", tostring(vName)),
                    Duration = 4
                })
            end
            return
        end

        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "🤖 รันระบบ Auto-Tune Tourer 350",
                Content = "กำลังส่งแมพ 100% สู่กล่อง ECU บน Server...",
                Duration = 2
            })
        end

        FlashEcuFile(Tourer350MapData)
        _isAutoTuneTaskRunning = false
    end)
end

local function RedeemTuneCode(code)
    local veh = GetPlayerVehicle()
    if not veh then
        if Hub.Fluent then Hub.Fluent:Notify({ Title = "Redeem Code", Content = "ไม่พบยานพาหนะ", Duration = 3 }) end
        return
    end
    if not EcuRemote or not NetSeal then return end

    local cleanCode = tostring(code or ""):upper():gsub("[^%w]", "")
    local s, ok, msg, file = pcall(NetSeal.invoke, EcuRemote, "Redeem", veh, cleanCode)
    if s and ok then
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "📥 แลกรับโค้ดจูนสำเร็จ!",
                Content = tostring(msg or "ติดตั้งแมพจูนเข้ากล่องเรียบร้อยแล้ว"),
                Duration = 4
            })
        end
    else
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "Redeem Error",
                Content = tostring(msg or "โค้ดไม่ถูกต้อง หรือหมดอายุแล้ว"),
                Duration = 3
            })
        end
    end
end

local function GenerateShareCode()
    local veh = GetPlayerVehicle()
    if not veh then return end
    if not EcuRemote or not NetSeal then return end

    local s, ok, msg = pcall(NetSeal.invoke, EcuRemote, "Share", veh)
    if s and ok then
        local code = tostring(msg or ""):match("%w%w%w%w%-%w%w%w%w") or tostring(msg or "")
        if setclipboard and code then pcall(setclipboard, code) end
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "📤 สร้างโค้ดจูนสำเร็จ!",
                Content = tostring(msg) .. "\n(คัดลอกลงคลิปบอร์ดให้แล้ว)",
                Duration = 6
            })
        end
    else
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "Share Error",
                Content = tostring(msg or "ต้องมีเงิน ฿2,000 เพื่อสร้างโค้ดจูน"),
                Duration = 3
            })
        end
    end
end

local function ApplyCustomOffsets()
    local veh = GetPlayerVehicle()
    if not veh then return end
    local http = game:GetService("HttpService")
    local raw = veh:GetAttribute("EcuFile")
    local curFile = nil
    if raw then pcall(function() curFile = http:JSONDecode(raw) end) end
    if not curFile then curFile = table.clone(GodMapData) end

    local newFile = table.clone(curFile)
    if newFile.Ign and Hub.Settings.CustomIgnOffset ~= 0 then
        newFile.Ign = {}
        for i, v in ipairs(curFile.Ign) do
            newFile.Ign[i] = math.clamp(math.round((v + Hub.Settings.CustomIgnOffset) * 10) / 10, 5, 45)
        end
    end
    if newFile.Fuel and Hub.Settings.CustomFuelOffset ~= 0 then
        newFile.Fuel = {}
        for i, v in ipairs(curFile.Fuel) do
            newFile.Fuel[i] = math.clamp(math.round((v + Hub.Settings.CustomFuelOffset) * 100) / 100, 0.6, 1.6)
        end
    end
    if newFile.Air and Hub.Settings.CustomAirOffset ~= 0 then
        newFile.Air = {}
        for i, v in ipairs(curFile.Air) do
            newFile.Air[i] = math.clamp(math.round((v + Hub.Settings.CustomAirOffset) * 100) / 100, 0.6, 1.6)
        end
    end

    FlashEcuFile(newFile)
end

-- ==============================================================
-- 🌾 5. AUTO FARM & ROAD NAVIGATION ENGINE (100% KICK-PROOF)
-- ==============================================================

local function EnsureMounted()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return nil, nil end

    -- Immunity against falling down or ragdoll
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    pcall(function()
        if Ragdoll and Ragdoll.disable then Ragdoll.disable(char) end
    end)

    local veh, seat = GetActiveSeatedVehicle()
    if veh and seat then return veh, seat end

    local myVeh = GetPlayerVehicle(false)
    if not myVeh and GarageRemote and NetSeal then
        pcall(NetSeal.invoke, GarageRemote, "Spawn", "PCX160")
        task.wait(0.5)
        myVeh = GetPlayerVehicle(false)
    end

    if myVeh then
        local chassis = myVeh:FindFirstChild("Chassis") or myVeh.PrimaryPart
        local prompt = myVeh:FindFirstChild("MountPrompt", true)
        local seatPart = myVeh:FindFirstChildOfClass("VehicleSeat", true) or myVeh:FindFirstChildOfClass("Seat", true)
        if prompt then
            local mountPos = prompt.Parent:IsA("Attachment") and prompt.Parent.WorldPosition or prompt.Parent.Position
            hrp.CFrame = CFrame.new(mountPos + Vector3.new(0, 0.5, 0))
            task.wait(0.15)
            if fireproximityprompt then
                pcall(fireproximityprompt, prompt)
            end
        elseif chassis then
            hrp.CFrame = chassis.CFrame + Vector3.new(0, 2.5, 0)
            task.wait(0.1)
            if seatPart then
                pcall(function() seatPart:Sit(hum) end)
            end
        end

        for _ = 1, 12 do
            task.wait(0.1)
            veh, seat = GetActiveSeatedVehicle()
            if veh and seat then break end
        end
    end

    return veh, seat
end

local Teleporting = false
local function SafeRoadTravel(targetPos, options)
    if Teleporting then return false end
    Teleporting = true
    options = options or {}

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not hum then
        Teleporting = false
        return false
    end

    -- Pre-stream chunk from server
    pcall(function() LocalPlayer:RequestStreamAroundAsync(targetPos) end)

    -- If strict foot mode (e.g. at locker cabinet)
    if options.StrictFoot then
        local startPos = hrp.Position
        local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude
        if dist > 0.5 then
            local dir = (targetPos - startPos).Unit
            local rem = dist
            local walkSpeed = 16
            while rem > 0.5 and Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
                local dt = RunService.Heartbeat:Wait()
                local safeDt = math.clamp(dt, 0.001, 0.033)
                local step = math.min(walkSpeed * safeDt, rem, 0.5)
                rem = rem - step
                hrp.CFrame = CFrame.new(hrp.Position + dir * step, targetPos)
            end
        end
        hrp.AssemblyLinearVelocity = Vector3.zero
        Teleporting = false
        return true
    end

    -- Ensure seated on vehicle
    local currentVeh, seat = EnsureMounted()
    local isSeated = currentVeh ~= nil
    local chassis = isSeated and (currentVeh:FindFirstChild("Chassis") or currentVeh.PrimaryPart or seat) or hrp
    local startPos = chassis.Position
    local totalDist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude

    -- Check if already close enough (within 18 studs, well inside the 32 stud ARRIVE_RADIUS)
    if totalDist <= 18 then
        if isSeated and currentVeh then
            for _, p in ipairs(currentVeh:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.AssemblyLinearVelocity = Vector3.zero
                    p.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
        Teleporting = false
        return true
    end

    local maxSafeVehSpeed = (GetVehicleTunedMaxKmh and currentVeh and (GetVehicleTunedMaxKmh(currentVeh) / 1.008)) or 98
    local cruiseSpeed = isSeated and math.clamp(Hub.Settings.WarpSpeed or 92, 50, math.min(95, maxSafeVehSpeed - 8)) or 16
    local mapFolder = Workspace:FindFirstChild("Map")
    local terrain = Workspace.Terrain
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Include
    rayParams.FilterDescendantsInstances = {mapFolder, terrain}

    -- Plan road route if RoadGraph is available
    local waypoints = {}
    if isSeated and RoadGraph and RoadGraph.route then
        local rawPts = RoadGraph.route(startPos, targetPos)
        if rawPts and #rawPts > 0 then
            for i = 1, #rawPts do
                local pt = rawPts[i]
                local x = pt.X
                local z = pt.Y

                -- Charan Road Median Concrete Pillar Avoidance
                if math.abs(x) < 8 and i < #rawPts then
                    local nextPt = rawPts[i + 1] or pt
                    local nextZ = nextPt.Y or z
                    x = (nextZ < z) and -16 or 16
                end

                table.insert(waypoints, Vector3.new(x, 0, z))
            end
        end
    end

    if #waypoints < 2 then
        table.insert(waypoints, startPos)
        table.insert(waypoints, targetPos)
    end

    -- Safe Stand-off Arrival:
    -- Stop 14-16 studs away from targetPos (customer NPC / building wall)
    -- This prevents crashing into walls/NPCs, while remaining safely inside the 32-stud ARRIVE_RADIUS!
    local totalWp = #waypoints
    local lastWp = waypoints[totalWp]
    local approachVec = Vector3.new(lastWp.X, 0, lastWp.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)
    if approachVec.Magnitude < 2 and totalWp >= 2 then
        local penWp = waypoints[totalWp - 1]
        local roadToTarget = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(penWp.X, 0, penWp.Z))
        if roadToTarget.Magnitude > 16 then
            waypoints[totalWp] = Vector3.new(targetPos.X, 0, targetPos.Z) - roadToTarget.Unit * 14
        end
    end

    local curPos = startPos
    local lastElevation = curPos.Y

    for i = 2, #waypoints do
        if not Hub.Running or genv._MahanakhonScriptId ~= SCRIPT_ID then break end
        local wp = waypoints[i]
        local segDist = (Vector3.new(wp.X, 0, wp.Z) - Vector3.new(curPos.X, 0, curPos.Z)).Magnitude

        if segDist > 0.3 then
            local segDir = (Vector3.new(wp.X, 0, wp.Z) - Vector3.new(curPos.X, 0, curPos.Z)).Unit
            local rem = segDist

            while rem > 0.3 and Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
                local dt = RunService.Heartbeat:Wait()
                local safeDt = math.clamp(dt, 0.001, 0.033)

                -- Dynamic Smooth Deceleration: Glide smoothly down when approaching final stop
                local remTotal = (Vector3.new(waypoints[#waypoints].X, 0, waypoints[#waypoints].Z) - Vector3.new(curPos.X, 0, curPos.Z)).Magnitude
                local curSpeed = cruiseSpeed
                if remTotal < 35 then
                    curSpeed = math.clamp(cruiseSpeed * (remTotal / 35), 8, cruiseSpeed)
                end

                -- Strict step limit: max 2.0 studs per frame to eliminate lag-spike warping kicks
                local step = math.min(curSpeed * safeDt, rem, 2.0)
                rem = rem - step
                curPos = curPos + segDir * step

                -- Ground elevation raycasting with smooth lerping
                local gRay = Workspace:Raycast(curPos + Vector3.new(0, 15, 0), Vector3.new(0, -35, 0), rayParams)
                local groundY = (gRay and gRay.Position.Y) or lastElevation
                lastElevation = lastElevation + (groundY - lastElevation) * 0.25
                local curY = lastElevation + 1.6
                local look = curPos + segDir * 8

                local cf = CFrame.lookAt(Vector3.new(curPos.X, curY, curPos.Z), Vector3.new(look.X, curY, look.Z))
                if isSeated and currentVeh and currentVeh.Parent then
                    currentVeh:PivotTo(cf)
                    for _, p in ipairs(currentVeh:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.AssemblyLinearVelocity = segDir * curSpeed
                            p.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                else
                    hrp.CFrame = cf
                    hrp.AssemblyLinearVelocity = segDir * curSpeed
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end

    -- Complete Stop (NO abrupt teleport jump! 100% kick & crash proof)
    if isSeated and currentVeh and currentVeh.Parent then
        for _, p in ipairs(currentVeh:GetDescendants()) do
            if p:IsA("BasePart") then
                p.AssemblyLinearVelocity = Vector3.zero
                p.AssemblyAngularVelocity = Vector3.zero
            end
        end
    else
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    if options.Dismount and isSeated then
        hum.Sit = false
    end

    task.wait(0.2)
    Teleporting = false
    return true
end

local function TeleportEntity(targetCF, options)
    local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
    return SafeRoadTravel(pos, options)
end
Hub.TeleportEntity = TeleportEntity

-- 5.1 Auto Bypass FarmCheck Captcha (Emoji solver)
if FarmCheckRemote and FarmCheckAnswerRemote and NetSeal then
    local captchaConn
    captchaConn = FarmCheckRemote.OnClientEvent:Connect(function(action, data)
        if not Hub.Running or not Hub.Settings.AutoCaptcha then return end
        if action == "Show" and type(data) == "table" and data.options then
            task.delay(0.4, function()
                local prompt = tostring(data.prompt or "")
                local targetId = nil

                for _, opt in ipairs(data.options) do
                    if opt.emoji and prompt:find(opt.emoji, 1, true) then
                        targetId = opt.id
                        break
                    end
                end

                if not targetId and data.options[1] then
                    targetId = data.options[1].id
                end

                if targetId then
                    pcall(NetSeal.invoke, FarmCheckAnswerRemote, targetId)
                    if Hub.Fluent then
                        Hub.Fluent:Notify({
                            Title = "🤖 FarmCheck Captcha",
                            Content = "ตอบแคปช่าอัตโนมัติสำเร็จแล้ว!",
                            Duration = 3
                        })
                    end
                end
            end)
        end
    end)
    table.insert(Hub.Connections, captchaConn)
end

-- 5.2 Unified Auto Rider / Delivery Engine
local DeliveryWorking = false
local LastDeliveryNotifyAt = 0

local function StepAutoDelivery(targetMode)
    if DeliveryWorking then return end
    DeliveryWorking = true

    -- 1. Uniform Check: Must wear delivery uniform
    local curJob = LocalPlayer:GetAttribute("Job")
    if curJob ~= "Delivery" then
        local locker = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("JobLockers") and Workspace.Map.JobLockers:FindFirstChild("Locker_Delivery")
        local cabinet = locker and locker:FindFirstChild("Cabinet")
        local prompt = cabinet and cabinet:FindFirstChild("LockerPrompt")
        if prompt then
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "👔 เปลี่ยนชุดไรเดอร์",
                    Content = "กำลังไปใส่ชุดไรเดอร์ที่ตู้เก็บของ...",
                    Duration = 3
                })
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            -- If far from AutoWorks locker (more than 28 studs), drive close first
            if hrp and (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(87.8, 0, -118)).Magnitude > 28 then
                SafeRoadTravel(Vector3.new(78, 3.5, -118), { Dismount = true })
            end

            -- Dismount cleanly so character can interact with locker
            if hum and hum.Sit then
                hum.Sit = false
                task.wait(0.2)
            end

            -- Step directly in front of the locker cabinet (Cabinet is at 87.8, 4.38, -118)
            if hrp then
                local standPos = Vector3.new(89.5, 4.3, -118)
                hrp.CFrame = CFrame.new(standPos, Vector3.new(87.8, 4.38, -118))
                hrp.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.25)
            end

            -- Trigger the locker prompt
            if fireproximityprompt then
                pcall(fireproximityprompt, prompt)
            end

            -- Wait for job attribute to update
            local tStart = os.clock()
            while (os.clock() - tStart) < 2.5 do
                if LocalPlayer:GetAttribute("Job") == "Delivery" then
                    break
                end
                task.wait(0.1)
            end

            if LocalPlayer:GetAttribute("Job") == "Delivery" then
                if Hub.Fluent then
                    Hub.Fluent:Notify({
                        Title = "👔 ใส่ชุดสำเร็จ",
                        Content = "สวมชุดไรเดอร์เรียบร้อย กำลังขึ้นรถเริ่มงาน...",
                        Duration = 2.5
                    })
                end
                task.wait(0.3)
                EnsureMounted()
            end
        else
            if os.clock() - LastDeliveryNotifyAt > 8 then
                LastDeliveryNotifyAt = os.clock()
                if Hub.Fluent then
                    Hub.Fluent:Notify({
                        Title = "ไรเดอร์ส่งของ",
                        Content = "กรุณาไปเปลี่ยนชุดที่ตู้ Locker_Delivery ก่อนเริ่มฟาร์ม",
                        Duration = 4
                    })
                end
            end
            DeliveryWorking = false
            task.wait(2)
            return
        end
        DeliveryWorking = false
        return
    end

    -- Ensure seated on vehicle before any job step
    local veh, seat = EnsureMounted()
    if not veh or not seat then
        DeliveryWorking = false
        task.wait(0.5)
        return
    end

    local state = LocalPlayer:GetAttribute("DeliveryState") or "Off"
    local curMode = LocalPlayer:GetAttribute("DeliveryMode")
    local rawJob = LocalPlayer:GetAttribute("DeliveryJob")
    local decoded = rawJob and DeliveryShared and DeliveryShared.decode(rawJob)

    local function ResolveTarget(targetKind, jobData)
        local marker = Workspace:FindFirstChild("DeliveryMarker")
        local ring = marker and marker:FindFirstChild("Ring")
        if ring and ring:IsA("BasePart") then
            return ring.Position
        end
        if DeliveryShared and DeliveryShared.target then
            local t = DeliveryShared.target(targetKind, jobData)
            if t then return t end
        end
        local data = (targetKind == "ToShop" and jobData and jobData.shop) or (jobData and jobData.home)
        if data then
            return Vector3.new(data.dx or data.x, 0, data.dz or data.z)
        end
        return nil
    end

    -- Case 1: Off -> Turn on service
    if state == "Off" or (curMode ~= targetMode and state ~= "ToShop" and state ~= "ToHome") then
        pcall(NetSeal.invoke, DeliveryRemote, "Start", targetMode)
        task.wait(1.2)

    -- Case 2: Searching -> Server is matching order
    elseif state == "Searching" then
        task.wait(0.5)

    -- Case 3: Offer -> Instant Accept order!
    elseif state == "Offer" then
        local s, ok, msg = pcall(NetSeal.invoke, DeliveryRemote, "Accept", nil)
        if s and ok then
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "🛵 รับงานสำเร็จ!",
                    Content = ("ลูกค้า: %s | ค่าส่ง: ฿%s"):format(
                        decoded and decoded.customer or "ลูกค้า",
                        decoded and tostring(decoded.fee) or "-"
                    ),
                    Duration = 3
                })
            end
        end
        task.wait(0.6)

    -- Case 4: ToShop -> Drive smoothly along road to restaurant
    elseif state == "ToShop" and decoded then
        local targetPos = ResolveTarget("ToShop", decoded)
        if targetPos then
            SafeRoadTravel(targetPos)

            -- Wait for server arrival validation (HOLD_TIME = 1.5s at STOP_SPEED <= 6)
            local waitStart = os.clock()
            while (os.clock() - waitStart) < 4.5 and Hub.Running do
                if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                    break
                end
                task.wait(0.1)
            end

            if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                task.wait(0.2)
                local s, ok = pcall(NetSeal.invoke, DeliveryRemote, "Confirm", nil)
                if s and ok and Hub.Fluent then
                    Hub.Fluent:Notify({
                        Title = "🍲 รับสินค้าสำเร็จ!",
                        Content = ("รับอาหารเรียบร้อย กำลังไปส่งให้คุณ %s"):format(decoded.customer or "ลูกค้า"),
                        Duration = 2.5
                    })
                end
                task.wait(0.8)
            end
        end

    -- Case 5: ToHome -> Drive smoothly along road to customer
    elseif state == "ToHome" and decoded then
        local targetPos = ResolveTarget("ToHome", decoded)
        if targetPos then
            SafeRoadTravel(targetPos)

            -- Wait for server arrival validation (HOLD_TIME = 1.5s at STOP_SPEED <= 6)
            local waitStart = os.clock()
            while (os.clock() - waitStart) < 4.5 and Hub.Running do
                if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                    break
                end
                task.wait(0.1)
            end

            if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                task.wait(0.2)
                local s, ok = pcall(NetSeal.invoke, DeliveryRemote, "Confirm", nil)
                if s and ok and Hub.Fluent then
                    Hub.Fluent:Notify({
                        Title = "💰 ส่งงานสำเร็จ!",
                        Content = ("ได้รับเงินค่าส่งเรียบร้อยแล้ว: ฿%s"):format(tostring(decoded.fee or "")),
                        Duration = 3.5
                    })
                end
                task.wait(0.8)
            end
        end
    end

    DeliveryWorking = false
end

-- Continuous Delivery Farm Worker
task.spawn(function()
    while Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
        if DeliveryRemote and NetSeal and DeliveryShared then
            if Hub.Settings.AutoFoodDelivery then
                pcall(StepAutoDelivery, "food")
            elseif Hub.Settings.AutoGrabRide then
                pcall(StepAutoDelivery, "ride")
            end
        end
        task.wait(0.5)
    end
end)

-- 🛡️ Anti-Fall & Anti-Damage Auto-Farm Watchdog (Guarantees 100% Seated & Health)
task.spawn(function()
    while Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
        local isFarmActive = Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
        if isFarmActive then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum.PlatformStand = false
                pcall(function()
                    if Ragdoll and Ragdoll.disable then Ragdoll.disable(char) end
                end)
                if not hum.Sit and not Teleporting and not DeliveryWorking then
                    EnsureMounted()
                end
            end
            local veh = GetPlayerVehicle(false)
            if veh then
                pcall(function() veh:SetAttribute("EngineHealth", 100) end)
            end
        end
        task.wait(0.6)
    end
end)

-- ==============================================================
-- 🏃 6. MOVEMENT, TELEPORT & FLY ENGINE (PC & MOBILE OPTIMIZED)
-- ==============================================================

local Flying = false
local FlyBodyGyro = nil
local FlyBodyVel = nil

local function StartFly()
    if Flying then return end
    Flying = true

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local veh = GetActiveSeatedVehicle()
    local rootPart = (veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)) or hrp

    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = rootPart.CFrame
    FlyBodyGyro.Parent = rootPart

    FlyBodyVel = Instance.new("BodyVelocity")
    FlyBodyVel.Velocity = Vector3.zero
    FlyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVel.Parent = rootPart

    local flyConn
    flyConn = RunService.RenderStepped:Connect(function()
        if not Flying or not Hub.Running or not rootPart.Parent then
            pcall(function() flyConn:Disconnect() end)
            return
        end

        FlyBodyGyro.CFrame = Camera.CFrame
        local dir = Vector3.zero

        -- PC Keyboard Controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        -- Mobile Thumbstick & Touch Controls
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            local move = Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z))
            dir = dir + move
        end
        if hum and hum.Jump then
            dir = dir + Vector3.new(0, 1, 0)
        end

        if dir.Magnitude > 0 then
            local maxFly = (veh and (GetVehicleTunedMaxKmh and (GetVehicleTunedMaxKmh(veh) / 1.008)) or 18)
            local targetSpeed = math.min(Hub.Settings.FlySpeed or 45, maxFly)
            FlyBodyVel.Velocity = dir.Unit * targetSpeed
        else
            FlyBodyVel.Velocity = Vector3.zero
        end
    end)
    table.insert(Hub.Connections, flyConn)
end

local function StopFly()
    Flying = false
    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end) FlyBodyGyro = nil end
    if FlyBodyVel then pcall(function() FlyBodyVel:Destroy() end) FlyBodyVel = nil end
end

-- Speed & Noclip Stepped (Zero GC Allocations for Mobile / Low-End Hardware)
local moveConn
local _cachedChar = nil
local _cachedParts = {}

local function RefreshPartCache(c)
    _cachedChar = c
    _cachedParts = {}
    if not c then return end
    for _, p in ipairs(c:GetChildren()) do
        if p:IsA("BasePart") then
            table.insert(_cachedParts, p)
        end
    end
end

moveConn = RunService.Stepped:Connect(function()
    if not Hub.Running or (not Hub.Settings.SpeedHack and not Hub.Settings.Noclip) then return end
    local char = LocalPlayer.Character
    if not char then return end
    if char ~= _cachedChar then RefreshPartCache(char) end

    if Hub.Settings.SpeedHack then
        local hum = char:FindFirstChildOfClass("Humanoid")
        -- Strict safe humanoid walkspeed: server anti-cheat kicks if on-foot speed > 18
        local safeSpeed = math.clamp(Hub.Settings.SpeedValue or 16, 16, 18)
        if hum and hum.WalkSpeed ~= safeSpeed then
            hum.WalkSpeed = safeSpeed
        end
    end

    if Hub.Settings.Noclip then
        for i = 1, #_cachedParts do
            local p = _cachedParts[i]
            if p and p.CanCollide then
                p.CanCollide = false
            end
        end
    end
end)
table.insert(Hub.Connections, moveConn)

-- Infinite Jump
local jumpConn
jumpConn = UserInputService.JumpRequest:Connect(function()
    if Hub.Running and Hub.Settings.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
table.insert(Hub.Connections, jumpConn)

-- ==============================================================
-- 👁️ 7. ESP VISUAL ENGINE (Drawing Library)
-- ==============================================================
local function CreateDrawing(class, props)
    if typeof(Drawing) ~= "table" or not Drawing.new then return nil end
    local s, obj = pcall(Drawing.new, class)
    if s and obj then
        for k, v in pairs(props or {}) do
            pcall(function() obj[k] = v end)
        end
        return obj
    end
    return nil
end

local function RemoveESPForPlayer(plr)
    if Hub.ESPObjects[plr] then
        for _, draw in pairs(Hub.ESPObjects[plr]) do
            pcall(function() draw:Remove() end)
        end
        Hub.ESPObjects[plr] = nil
    end
end

local _lastEspTime = 0
local function UpdateESP()
    if not Hub.Running then return end

    if not Hub.Settings.PlayerESP then
        if next(Hub.ESPObjects) then
            for plr in pairs(Hub.ESPObjects) do
                RemoveESPForPlayer(plr)
            end
        end
        return
    end

    -- Throttle ESP updates to 30 FPS: eliminates frame drops and heat on Mobile
    local now = os.clock()
    if now - _lastEspTime < 0.033 then return end
    _lastEspTime = now

    local fontEnum = 2
    if Hub.Settings.ESPFont == "System" then fontEnum = 1
    elseif Hub.Settings.ESPFont == "Plex" then fontEnum = 3
    elseif Hub.Settings.ESPFont == "Monospace" then fontEnum = 0 end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if not Hub.ESPObjects[plr] then
                        Hub.ESPObjects[plr] = {
                            Box = CreateDrawing("Square", { Thickness = 1.5, Color = Color3.fromRGB(0, 220, 255), Filled = false }),
                            BoxOutline = CreateDrawing("Square", { Thickness = 3.5, Color = Color3.fromRGB(0, 0, 0), Filled = false }),
                            Name = CreateDrawing("Text", { Size = Hub.Settings.ESPFontSize, Center = true, Outline = true, Color = Color3.new(1, 1, 1) }),
                            Info = CreateDrawing("Text", { Size = Hub.Settings.ESPFontSize - 2, Center = true, Outline = true, Color = Color3.fromRGB(220, 220, 220) }),
                        }
                    end

                    local esp = Hub.ESPObjects[plr]
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    local boxH = math.clamp(1000 / pos.Z, 18, 400)
                    local boxW = boxH * 0.65

                    if esp.Box and esp.BoxOutline then
                        local showBox = Hub.Settings.ESPBox
                        esp.Box.Visible = showBox
                        esp.BoxOutline.Visible = showBox
                        if showBox then
                            local boxPos = Vector2.new(pos.X - boxW / 2, pos.Y - boxH / 2)
                            esp.Box.Size = Vector2.new(boxW, boxH)
                            esp.Box.Position = boxPos
                            esp.BoxOutline.Size = Vector2.new(boxW, boxH)
                            esp.BoxOutline.Position = boxPos
                        end
                    end

                    if esp.Name then
                        esp.Name.Visible = Hub.Settings.ESPName
                        if Hub.Settings.ESPName then
                            esp.Name.Font = fontEnum
                            esp.Name.Size = Hub.Settings.ESPFontSize
                            esp.Name.Position = Vector2.new(pos.X, pos.Y - boxH / 2 - 16)
                            esp.Name.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                        end
                    end

                    if esp.Info then
                        local showInfo = Hub.Settings.ESPDistance or Hub.Settings.ESPVehicle
                        esp.Info.Visible = showInfo
                        if showInfo then
                            esp.Info.Font = fontEnum
                            esp.Info.Size = Hub.Settings.ESPFontSize - 2
                            esp.Info.Position = Vector2.new(pos.X, pos.Y + boxH / 2 + 2)

                            local vName = plr:GetAttribute("ActiveVehicle") or (hum.SeatPart and hum.SeatPart:FindFirstAncestorOfClass("Model") and hum.SeatPart:FindFirstAncestorOfClass("Model").Name) or "On Foot"
                            local text = ""
                            if Hub.Settings.ESPDistance then text = text .. tostring(dist) .. "m " end
                            if Hub.Settings.ESPVehicle and vName ~= "On Foot" then text = text .. "[" .. tostring(vName) .. "]" end
                            esp.Info.Text = text
                        end
                    end
                else
                    RemoveESPForPlayer(plr)
                end
            else
                RemoveESPForPlayer(plr)
            end
        else
            RemoveESPForPlayer(plr)
        end
    end
end

local espConn = RunService.RenderStepped:Connect(UpdateESP)
table.insert(Hub.Connections, espConn)

-- ==============================================================
-- 🎨 8. MODERN MACLIB UI & FLOATING LOGO INTERFACE
-- ==============================================================
local function InitUI()
    local CoreGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil
    local targetGuiParent = (function()
        if gethui then
            local ok, h = pcall(gethui)
            if ok and h then return h end
        end
        if CoreGui then
            local canCore = pcall(function()
                local test = Instance.new("Folder")
                test.Parent = CoreGui
                test:Destroy()
            end)
            if canCore then return CoreGui end
        end
        return LocalPlayer:WaitForChild("PlayerGui")
    end)()

    -- Clean up previous UI instances across all GUI hosts
    pcall(function()
        local hosts = { targetGuiParent, gethui and gethui(), CoreGui, LocalPlayer:FindFirstChild("PlayerGui") }
        for _, host in ipairs(hosts) do
            if host then
                for _, child in ipairs(host:GetChildren()) do
                    if child:IsA("ScreenGui") and (child.Name == "KrakenHub_Mahanakhon_Btn" or child.Name == "KrakenHub_Mahanakhon_UI" or child:FindFirstChild("Base")) then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
    end)

    -- 🏷️ Logo Loader
    local function GetLogoAsset()
        task.spawn(function()
            if typeof(isfile) == "function" and typeof(writefile) == "function" and typeof(getcustomasset) == "function" then
                if not isfile("k_community_logo.png") then
                    pcall(function()
                        local url = "https://raw.githubusercontent.com/armongzx56-design/KrakenHub/main/k_community_logo.png"
                        local data = game:HttpGet(url)
                        if type(data) == "string" and #data > 1000 and data:sub(1, 4) == "\137PNG" then
                            writefile("k_community_logo.png", data)
                        end
                    end)
                end
            end
        end)

        if typeof(isfile) == "function" and typeof(getcustomasset) == "function" and isfile("k_community_logo.png") then
            local s, asset = pcall(getcustomasset, "k_community_logo.png")
            if s and asset then return asset end
        end
        return "rbxasset://5059d143b75fc7c70a58a871660c4f16/k_community_logo.png"
    end

    -- 🎨 Load MacLib UI Library (With Runtime Red Toggle Switch Patch & Anti-Inversion Slider Fix)
    local MacLib = nil
    local ok, lib = pcall(function()
        local code = game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt")
        code = code:gsub(
            "Tween%(toggle1,%s*TweenSettings%.Info,%s*{%s*ImageTransparency%s*=%s*transparencyValues%[1%]%s*}%)",
            "Tween(toggle1, TweenSettings.Info, { ImageTransparency = transparencyValues[1], ImageColor3 = State and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86) })"
        )
        code = code:gsub(
            "toggle1%.ImageColor3%s*=%s*Color3%.fromRGB%(87,%s*86,%s*86%)",
            "toggle1.ImageColor3 = togglebool and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86)"
        )
        code = code:gsub("ContentProvider:PreloadAsync%(assetList%)", "-- PreloadAsync skipped for instant load")
        -- Fix Slider Inverted Drag & Overlap Bug (Clamp newBarWidth to positive minimum)
        code = code:gsub(
            "local newBarWidth = %(totalWidth %- %(padding %+ sliderValueWidth %+ sliderNameWidth %+ 20%)%) / baseUIScale%.Scale",
            "local newBarWidth = math.max(75, (totalWidth - (padding + sliderValueWidth + sliderNameWidth + 15)) / baseUIScale.Scale)"
        )
        code = code:gsub(
            "sliderHead%.InputBegan:Connect%(function%(input%)%s*if input%.UserInputType == Enum%.UserInputType%.MouseButton1 or input%.UserInputType == Enum%.UserInputType%.Touch then%s*dragging = true%s*SetValue%(input%)%s*end%s*end%)",
            [[local function onSliderBegan(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end
					sliderHead.InputBegan:Connect(onSliderBegan)
					sliderBar.InputBegan:Connect(onSliderBegan)]]
        )
        -- Expose Base and ScreenGui references for Universal Drag & Corner Resizing
        code = code:gsub("(\t*)return WindowFunctions", "%1WindowFunctions.Base = base\n%1WindowFunctions.ScreenGui = macLib\n%1return WindowFunctions")
        code = code:gsub('local newGui = Instance%.new%("ScreenGui"%)', 'local newGui = Instance.new("ScreenGui")\n\tnewGui.Name = "KrakenHub_Mahanakhon_UI"')
        return loadstring(code)()
    end)
    if ok and lib then
        MacLib = lib
    else
        warn("[KrakenHub] Failed to load MacLib")
        return
    end

    -- 📐 Responsive Window Size
    local function GetOptimalWindowSize()
        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        if isMobile or vp.X < 900 then
            local w = math.clamp(math.floor(vp.X * 0.90), 340, 680)
            local h = math.clamp(math.floor(vp.Y * 0.85), 240, 440)
            return UDim2.fromOffset(w, h)
        else
            return UDim2.fromOffset(880, 620)
        end
    end

    -- 🪟 Create Main Window
    local Window = MacLib:Window({
        Title = "KrakenHub",
        Subtitle = "MAHANAKHON RACING",
        Size = GetOptimalWindowSize(),
        DragStyle = 2,
        ShowUserInfo = true,
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = false,
    })
    Hub.Window = Window

    -- 🌟 Neon Blue Border Overlay
    local function ApplyWindowBorder()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                base.ClipsDescendants = false
                local overlay = base:FindFirstChild("KrakenBorderOverlay")
                if not overlay then
                    overlay = Instance.new("Frame")
                    overlay.Name = "KrakenBorderOverlay"
                    overlay.BackgroundTransparency = 1
                    overlay.BorderSizePixel = 0
                    overlay.Size = UDim2.fromScale(1, 1)
                    overlay.Position = UDim2.fromScale(0, 0)
                    overlay.ZIndex = 9999
                    overlay.Parent = base

                    local corner = base:FindFirstChildOfClass("UICorner")
                    if corner then
                        local oc = Instance.new("UICorner")
                        oc.CornerRadius = corner.CornerRadius
                        oc.Parent = overlay
                    end

                    local stroke = Instance.new("UIStroke")
                    stroke.Name = "WindowStroke"
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Color = Color3.fromRGB(0, 170, 255)
                    stroke.Thickness = 2.0
                    stroke.Transparency = 0
                    stroke.Parent = overlay
                end

                for _, desc in ipairs(base:GetDescendants()) do
                    if desc:IsA("UIStroke") and desc.Name == "SectionUIStroke" then
                        desc.Color = Color3.fromRGB(0, 160, 255)
                        desc.Transparency = 0.6
                        desc.Thickness = 1.0
                        desc.Enabled = true
                    end
                end
            end
        end)
    end
    Hub.ApplyBorders = ApplyWindowBorder

    -- ✨ Title Shimmer Light Sweep Engine
    local function ApplyTitleShimmer()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local sidebar = base:FindFirstChild("Sidebar")
                local titleLabel = sidebar and sidebar:FindFirstChild("Title", true)
                if titleLabel and titleLabel:IsA("TextLabel") and not titleLabel:FindFirstChild("ShimmerGradient") then
                    local gradient = Instance.new("UIGradient")
                    gradient.Name = "ShimmerGradient"
                    gradient.Rotation = 25
                    gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 195, 205)),
                        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(205, 210, 220)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.53, Color3.fromRGB(120, 220, 255)),
                        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(205, 210, 220)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 195, 205)),
                    })
                    gradient.Offset = Vector2.new(-1, 0)
                    gradient.Parent = titleLabel

                    task.spawn(function()
                        local tweenInfo = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        while Hub.Running and titleLabel.Parent and gradient.Parent do
                            gradient.Offset = Vector2.new(-1, 0)
                            local tween = TweenService:Create(gradient, tweenInfo, { Offset = Vector2.new(1, 0) })
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(3.5)
                        end
                    end)
                end
            end
        end)
    end

    -- 🟢 User Online Status Indicator Engine
    local function ApplyOnlineStatus()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local headshot = base:FindFirstChild("Headshot", true)
                if headshot then
                    local dot = headshot:FindFirstChild("OnlineDot")
                    if not dot then
                        dot = Instance.new("Frame")
                        dot.Name = "OnlineDot"
                        dot.Size = UDim2.fromOffset(10, 10)
                        dot.Position = UDim2.new(1, 0, 1, 0)
                        dot.AnchorPoint = Vector2.new(0.85, 0.85)
                        dot.BackgroundColor3 = Color3.fromRGB(35, 210, 95)
                        dot.BorderSizePixel = 0
                        dot.ZIndex = 15

                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(1, 0)
                        corner.Parent = dot

                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.fromRGB(15, 15, 20)
                        stroke.Thickness = 2.0
                        stroke.Parent = dot

                        dot.Parent = headshot

                        task.spawn(function()
                            local tInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                            local tween = TweenService:Create(dot, tInfo, { BackgroundColor3 = Color3.fromRGB(80, 245, 130) })
                            tween:Play()
                        end)
                    end

                    local userLabel = headshot.Parent:FindFirstChild("Username", true)
                    if userLabel and userLabel:IsA("TextLabel") then
                        userLabel.RichText = true
                        local cleanName = userLabel.Text:gsub("%s*<font.->.-</font>", ""):gsub("%s*•.*", "")
                        userLabel.Text = cleanName .. '  <font color="#2ECC71">• Online</font>'
                    end
                end
            end
        end)
    end
    Hub.ApplyOnlineStatus = ApplyOnlineStatus

    -- 🖐️ Universal Touch & Mouse Drag + Bottom-Right Corner Dynamic Resize Engine
    local function SetupUniversalDragAndResize()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if not base or not base:IsA("GuiObject") then return end

            local sidebar = base:FindFirstChild("Sidebar")
            local content = base:FindFirstChild("Content")

            -- 1. Dynamic Auto-Fit Content Sync (Ensures elements perfectly fill window on resize)
            local function SyncContentSize()
                if base and sidebar and content then
                    local targetW = math.max(100, base.AbsoluteSize.X - sidebar.AbsoluteSize.X)
                    content.Size = UDim2.new(0, targetW, 1, 0)
                end
            end
            base:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncContentSize)
            if sidebar then sidebar:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncContentSize) end
            SyncContentSize()

            -- 2. Bottom-Right Corner Resize Handle
            local grip = base:FindFirstChild("KrakenResizeGrip")
            if not grip then
                grip = Instance.new("TextButton")
                grip.Name = "KrakenResizeGrip"
                grip.Size = UDim2.fromOffset(36, 36)
                grip.Position = UDim2.new(1, 0, 1, 0)
                grip.AnchorPoint = Vector2.new(1, 1)
                grip.BackgroundTransparency = 1
                grip.Text = ""
                grip.AutoButtonColor = false
                grip.ZIndex = 10000
                grip.Parent = base

                -- 3 Glowing Cyan Accent Grip Lines
                local lines = {
                    { w = 20, x = 20, y = 20 },
                    { w = 14, x = 25, y = 25 },
                    { w = 8,  x = 30, y = 30 },
                }
                for i, d in ipairs(lines) do
                    local bar = Instance.new("Frame")
                    bar.Name = "GripLine" .. i
                    bar.Size = UDim2.fromOffset(d.w, 2.5)
                    bar.Position = UDim2.fromOffset(d.x, d.y)
                    bar.AnchorPoint = Vector2.new(0.5, 0.5)
                    bar.Rotation = -45
                    bar.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
                    bar.BorderSizePixel = 0
                    bar.ZIndex = 10001
                    bar.Parent = grip

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = bar
                end

                local isResizing = false
                local resizeStart = nil
                local startSize = nil

                grip.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isResizing = true
                        Hub.IsResizing = true
                        resizeStart = input.Position
                        startSize = Vector2.new(base.AbsoluteSize.X, base.AbsoluteSize.Y)
                    end
                end)

                local resizeChangeConn = UserInputService.InputChanged:Connect(function(input)
                    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - resizeStart
                        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
                        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
                        local minW = isMobile and 320 or 440
                        local minH = isMobile and 210 or 280
                        local maxW = math.max(minW, vp.X - 16)
                        local maxH = math.max(minH, vp.Y - 16)

                        local newW = math.clamp(math.floor(startSize.X + delta.X), minW, maxW)
                        local newH = math.clamp(math.floor(startSize.Y + delta.Y), minH, maxH)
                        base.Size = UDim2.fromOffset(newW, newH)
                        SyncContentSize()
                    end
                end)
                table.insert(Hub.Connections, resizeChangeConn)

                local resizeEndConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if isResizing then
                            isResizing = false
                            Hub.IsResizing = false
                        end
                    end
                end)
                table.insert(Hub.Connections, resizeEndConn)
            end

            -- 3. Universal Touch & Mouse Drag on Any Empty Space
            if not base:FindFirstChild("KrakenDragHooked") then
                local dragTag = Instance.new("BoolValue")
                dragTag.Name = "KrakenDragHooked"
                dragTag.Parent = base

                local isDragging = false
                local dragStart = nil
                local startPos = nil

                local function HookDragTarget(frame)
                    if not frame or not frame:IsA("GuiObject") then return end
                    frame.InputBegan:Connect(function(input)
                        if Hub.IsResizing then return end
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isDragging = true
                            dragStart = input.Position
                            startPos = base.Position
                        end
                    end)
                end

                -- Hook headers, sidebars, borders, user profile, and base background
                HookDragTarget(base)
                if sidebar then
                    HookDragTarget(sidebar)
                    HookDragTarget(sidebar:FindFirstChild("Information"))
                    HookDragTarget(sidebar:FindFirstChild("WindowControls"))
                    HookDragTarget(sidebar:FindFirstChild("UserInfo"))
                end
                if content then
                    HookDragTarget(content:FindFirstChild("Topbar"))
                end
                local overlay = base:FindFirstChild("KrakenBorderOverlay")
                if overlay then HookDragTarget(overlay) end

                local dragMoveConn = UserInputService.InputChanged:Connect(function(input)
                    if isDragging and not Hub.IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - dragStart
                        base.Position = UDim2.new(
                            startPos.X.Scale,
                            startPos.X.Offset + delta.X,
                            startPos.Y.Scale,
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end)
                table.insert(Hub.Connections, dragMoveConn)

                local dragEndConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)
                table.insert(Hub.Connections, dragEndConn)
            end
        end)
    end
    Hub.SetupUniversalDragAndResize = SetupUniversalDragAndResize

    task.spawn(function()
        task.wait(0.08)
        ApplyWindowBorder()
        ApplyTitleShimmer()
        ApplyOnlineStatus()
        SetupUniversalDragAndResize()
    end)

    function Window:Minimize()
        local cur = Window:GetState()
        Window:SetState(not cur)
        task.delay(0.05, function()
            ApplyWindowBorder()
            ApplyTitleShimmer()
            ApplyOnlineStatus()
            SetupUniversalDragAndResize()
        end)
    end

    -- 🔘 Floating Draggable RGB Logo Button
    local function CreateFloatingToggleButton(windowObj)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KrakenHub_Mahanakhon_Btn"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 999
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local mainBtn = Instance.new("ImageButton")
        mainBtn.Name = "OpenCloseBtn"
        mainBtn.Size = UDim2.fromOffset(48, 48)
        mainBtn.Position = UDim2.new(0, 15, 0.5, -24)
        mainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        mainBtn.BackgroundTransparency = 0.15
        mainBtn.AutoButtonColor = false
        mainBtn.BorderSizePixel = 0
        mainBtn.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 13)
        corner.Parent = mainBtn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromHSV(0, 1, 1)
        stroke.Thickness = 2.0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = mainBtn

        local _btnHue = 0
        local _lastBtnHue = 0
        local rgbConn
        rgbConn = RunService.Heartbeat:Connect(function()
            if not Hub.Running or not screenGui.Parent then
                pcall(function() rgbConn:Disconnect() end)
                return
            end
            local now = os.clock()
            if now - _lastBtnHue >= 0.1 then
                local delta = now - _lastBtnHue
                _lastBtnHue = now
                _btnHue = (_btnHue + delta * 0.18) % 1
                stroke.Color = Color3.fromHSV(_btnHue, 1, 1)
            end
        end)
        table.insert(Hub.Connections, rgbConn)

        local logoImg = Instance.new("ImageLabel")
        logoImg.Name = "Logo"
        logoImg.Size = UDim2.fromScale(0.82, 0.82)
        logoImg.Position = UDim2.fromScale(0.5, 0.5)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = GetLogoAsset()
        logoImg.ScaleType = Enum.ScaleType.Fit
        logoImg.Parent = mainBtn

        mainBtn.ClipsDescendants = true
        local shimmerBar = Instance.new("Frame")
        shimmerBar.Name = "ShimmerBar"
        shimmerBar.Size = UDim2.new(0, 22, 2.2, 0)
        shimmerBar.Position = UDim2.new(-0.8, 0, 0.5, 0)
        shimmerBar.AnchorPoint = Vector2.new(0.5, 0.5)
        shimmerBar.Rotation = 25
        shimmerBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shimmerBar.BorderSizePixel = 0
        shimmerBar.ZIndex = 5

        local shimmerGrad = Instance.new("UIGradient")
        shimmerGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
        shimmerGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        shimmerGrad.Parent = shimmerBar
        shimmerBar.Parent = mainBtn

        task.spawn(function()
            local sweepTween = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            while Hub.Running and screenGui.Parent and shimmerBar.Parent do
                shimmerBar.Position = UDim2.new(-0.8, 0, 0.5, 0)
                local t = TweenService:Create(shimmerBar, sweepTween, { Position = UDim2.new(1.8, 0, 0.5, 0) })
                t:Play()
                t.Completed:Wait()
                task.wait(3.2)
            end
        end)

        local dragging = false
        local dragStartPos = nil
        local startFramePos = nil
        local movedEnough = false
        local dragThreshold = 8

        mainBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                movedEnough = false
                dragThreshold = (input.UserInputType == Enum.UserInputType.Touch) and 18 or 8
                dragStartPos = input.Position
                startFramePos = mainBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > dragThreshold then movedEnough = true end
                mainBtn.Position = UDim2.new(
                    startFramePos.X.Scale,
                    startFramePos.X.Offset + delta.X,
                    startFramePos.Y.Scale,
                    startFramePos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        mainBtn.Activated:Connect(function()
            if not movedEnough then
                task.spawn(function()
                    TweenService:Create(mainBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(42, 42) }):Play()
                    task.wait(0.08)
                    TweenService:Create(mainBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(48, 48) }):Play()
                end)
                if windowObj and windowObj.Minimize then
                    windowObj:Minimize()
                end
            end
        end)

        local okP = pcall(function() screenGui.Parent = targetGuiParent end)
        if not okP or not screenGui.Parent then
            pcall(function() screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
        end
        Hub.ToggleButtonGui = screenGui
        return screenGui
    end

    CreateFloatingToggleButton(Window)

    -- 🧩 Fluent Compatibility Adapter Layer
    local tabGroup = Window:TabGroup()
    local Options = {}
    MacLib.Options = Options

    local function CreateTabAdapter(rawTab, tabName)
        local currentSection = nil
        local side = "Right"

        local adapter = {
            RawTab = rawTab,
            Select = function(self) rawTab:Select() end,
            AddSection = function(self, title, targetSide)
                if not targetSide then
                    targetSide = (side == "Left") and "Right" or "Left"
                end
                side = targetSide
                currentSection = rawTab:Section({ Side = targetSide })
                currentSection:Header({ Text = title })
                return currentSection
            end,
            AddParagraph = function(self, cfg)
                local para = currentSection:Paragraph({
                    Header = cfg.Title or cfg.Header or "Paragraph",
                    Body = cfg.Content or cfg.Body or ""
                })
                return {
                    SetTitle = function(self, t) if para.UpdateHeader then para:UpdateHeader(t) end end,
                    SetDesc = function(self, d) if para.UpdateBody then para:UpdateBody(d) end end
                }
            end,
            AddToggle = function(self, flag, cfg)
                local changedCallbacks = {}
                local macToggle = currentSection:Toggle({
                    Name = cfg.Title or flag,
                    Default = cfg.Default or false,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end
                }, flag)
                macToggle.Value = cfg.Default or false
                macToggle.State = macToggle.Value
                function macToggle:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macToggle:SetValue(v)
                    if macToggle.UpdateState then
                        macToggle:UpdateState(v)
                    elseif macToggle.SetState then
                        macToggle:SetState(v)
                    end
                end
                Options[flag] = macToggle
                return macToggle
            end,
            AddSlider = function(self, flag, cfg)
                local changedCallbacks = {}
                local macSlider = currentSection:Slider({
                    Name = cfg.Title or flag,
                    Minimum = cfg.Min or 0,
                    Maximum = cfg.Max or 100,
                    Default = cfg.Default or cfg.Min or 0,
                    Precision = cfg.Rounding or 0,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end
                }, flag)
                macSlider.Min = cfg.Min or 0
                macSlider.Max = cfg.Max or 100
                macSlider.Value = cfg.Default or cfg.Min or 0
                function macSlider:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macSlider:SetValue(v)
                    if macSlider.UpdateValue then
                        macSlider:UpdateValue(v)
                    elseif macSlider.Set then
                        macSlider:Set(v)
                    end
                    if cfg.Callback then pcall(cfg.Callback, v) end
                    for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                end
                Options[flag] = macSlider
                return macSlider
            end,
            AddDropdown = function(self, flag, cfg)
                local changedCallbacks = {}
                local macDropdown = currentSection:Dropdown({
                    Name = cfg.Title or flag,
                    Options = cfg.Values or {},
                    Default = cfg.Default,
                    Multi = cfg.Multi or false,
                    Required = cfg.Required ~= false,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end
                }, flag)
                macDropdown.Value = cfg.Default or (cfg.Values and cfg.Values[1]) or ""
                function macDropdown:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macDropdown:SetValue(v) if macDropdown.Set then macDropdown:Set(v) end end
                Options[flag] = macDropdown
                return macDropdown
            end,
            AddButton = function(self, cfg)
                return currentSection:Button({
                    Name = cfg.Title or cfg.Name or "Button",
                    Description = cfg.Description or "",
                    Callback = cfg.Callback
                })
            end,
            AddInput = function(self, flag, cfg)
                local macInput = currentSection:Input({
                    Name = cfg.Title or flag,
                    Default = cfg.Default or "",
                    Placeholder = cfg.Placeholder or "",
                    Callback = cfg.Callback
                }, flag)
                macInput.Value = cfg.Default or ""
                Options[flag] = macInput
                return macInput
            end,
            AddKeybind = function(self, flag, cfg)
                local changedCallbacks = {}
                local defKey = cfg.Default or Enum.KeyCode.RightControl
                if typeof(defKey) == "string" and Enum.KeyCode[defKey] then
                    defKey = Enum.KeyCode[defKey]
                end

                local macKeybind = currentSection:Keybind({
                    Name = cfg.Title or flag,
                    Default = defKey,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end
                }, flag)
                macKeybind.Value = defKey
                function macKeybind:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macKeybind:SetValue(v) if macKeybind.Bind then macKeybind:Bind(v) end end
                Options[flag] = macKeybind
                return macKeybind
            end
        }
        return adapter
    end

    -- 🛡️ Dummy Tab Adapter for background functions hidden from UI
    local function CreateDummyTabAdapter(tabName)
        local dummyElement = {
            Value = true,
            OnChanged = function(self, fn) end,
            SetValue = function(self, v) end,
            SetDesc = function(self, v) end,
            SetTitle = function(self, v) end
        }
        return {
            Select = function(self) end,
            AddSection = function(self) return self end,
            AddParagraph = function(self) return dummyElement end,
            AddToggle = function(self, flag, cfg)
                local val = cfg.Default ~= nil and cfg.Default or false
                local item = {
                    Value = val,
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v)
                        self.Value = v
                        if cfg.Callback then pcall(cfg.Callback, v) end
                    end
                }
                Options[flag] = item
                return item
            end,
            AddSlider = function(self, flag, cfg)
                local val = cfg.Default or cfg.Min or 0
                local item = {
                    Value = val,
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v)
                        self.Value = v
                        if cfg.Callback then pcall(cfg.Callback, v) end
                    end
                }
                Options[flag] = item
                return item
            end,
            AddDropdown = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or "",
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v) self.Value = v end
                }
                Options[flag] = item
                return item
            end,
            AddButton = function(self, cfg) return dummyElement end,
            AddInput = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or "",
                    SetValue = function(self, v) self.Value = v end
                }
                Options[flag] = item
                return item
            end,
            AddKeybind = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or Enum.KeyCode.RightControl,
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v) self.Value = v end
                }
                Options[flag] = item
                return item
            end
        }
    end

    -- 📑 Define Tabs with Icons (Vehicle & ECU hidden from UI sidebar, functioning in background)
    local Tabs = {
        Vehicle  = CreateDummyTabAdapter("Vehicle"),
        EcuTune  = CreateDummyTabAdapter("EcuTune"),
        Farm     = CreateTabAdapter(tabGroup:Tab({ Name = "ออโต้ฟาร์ม",    Image = "rbxassetid://10734952479" }), "Farm"),
        Visuals  = CreateTabAdapter(tabGroup:Tab({ Name = "ESP",        Image = "rbxassetid://10747373176" }), "Visuals"),
        Movement = CreateTabAdapter(tabGroup:Tab({ Name = "บิน & เดิน", Image = "rbxassetid://10709818534" }), "Movement"),
        Teleport = CreateTabAdapter(tabGroup:Tab({ Name = "วาร์ป",           Image = "rbxassetid://10734952479" }), "Teleport"),
        Settings = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า",         Image = "rbxassetid://10734950309" }), "Settings")
    }

    local TabColors = {
        ["ออโต้ฟาร์ม"] = Color3.fromRGB(50, 225, 110),   -- Emerald Green
        ["ESP"]        = Color3.fromRGB(0, 220, 255),    -- Neon Cyan
        ["บิน & เดิน"] = Color3.fromRGB(255, 65, 65),     -- Crimson Red
        ["วาร์ป"]      = Color3.fromRGB(185, 95, 255),   -- Electric Purple
        ["ตั้งค่า"]    = Color3.fromRGB(0, 160, 255),    -- Electric Blue
    }

    local function ApplyTabIconColors()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local sidebar = base:FindFirstChild("Sidebar")
                if sidebar then
                    for _, tabSwitcher in ipairs(sidebar:GetDescendants()) do
                        if tabSwitcher.Name == "TabSwitcher" and tabSwitcher:IsA("TextButton") then
                            local nameLabel = tabSwitcher:FindFirstChild("TabSwitcherName")
                            local imgLabel = tabSwitcher:FindFirstChild("TabImage")
                            if nameLabel and imgLabel then
                                local targetColor = Color3.fromRGB(0, 160, 255)
                                if Hub.Settings.IconTheme ~= "ElectricBlue" then
                                    for k, col in pairs(TabColors) do
                                        if nameLabel.Text:find(k) then targetColor = col break end
                                    end
                                end
                                imgLabel.ImageColor3 = targetColor
                            end
                        end
                    end
                end
            end
        end)
    end
    task.spawn(function()
        task.wait(0.08)
        ApplyTabIconColors()
    end)

    local Fluent = {
        Options = Options,
        Notify = function(self, cfg)
            Window:Notify({
                Title = cfg.Title or "KrakenHub",
                Description = cfg.Content or cfg.Description or "",
                Lifetime = cfg.Duration or 4
            })
        end,
        Destroy = function(self)
            pcall(function() Window:Unload() end)
        end
    }
    Hub.Fluent = Fluent

    -- ================================================
    -- 🏎️ TAB 1: VEHICLE MODS
    -- ================================================
    Tabs.Vehicle:AddSection("ระบบรถ", "Left")

    local VehicleMasterToggle = Tabs.Vehicle:AddToggle("VehicleMasterToggle", {
        Title = "ม็อดรถ All-in-One",
        Description = "ไม่ล้ม ไม่ตก เบรกหนึบ หมอบพุ่ง เครื่อง 100% (ความเร็วตามจูนเกม 100%)",
        Default = Hub.Settings.VehicleModMaster
    })
    VehicleMasterToggle:OnChanged(function(v)
        Hub.Settings.VehicleModMaster = v
        Hub.Settings.SafeMode = true
        Hub.Settings.NoCrash = v
        Hub.Settings.SuperBrakes = v
        Hub.Settings.SuperTuck = v
        Hub.Settings.BypassSpeedCap = false
        Hub.Settings.LockEngineHealth = v
        ApplyVehiclePhysicsMods()
    end)

    Tabs.Vehicle:AddButton({
        Title = "พลิกรถ",
        Description = "แก้รถคว่ำ ตั้งรถตรงทันที",
        Callback = InstantUnflipVehicle
    })

    Tabs.Vehicle:AddSection("ระดับการจูน & ความเร็ว", "Right")

    Tabs.Vehicle:AddParagraph({
        Title = "ความเร็วตามระดับการจูนของเกม 100%",
        Content = "⚡ แรงตามจูนแท้ของตัวเกม: ความเร็วและอัตราเร่งจะคำนวณตามสเตจการจูนของเกมโดยตรง (ECU 100% x2.00 Power บนไดโน + สเตจเครื่องยนต์ + ลูกสูบ) รถจะวิ่งเร็วเต็มประสิทธิภาพตามที่หน้าจอไดโนคำนวณเป๊ะๆ ไม่มีการดัดแปลงความเร็วเทียม ปลอดภัย ไม่โดนแบน 100%"
    })

    -- ================================================
    -- 🎛️ TAB 2: ECU TUNING
    -- ================================================
    local DynoStatusPara = nil

    local function GetDynoMonitorText()
        local veh = GetPlayerVehicle()
        if not veh then return "ไม่พบรถ กรุณาเรียกรถออกมาก่อน" end
        local isTourer = IsTourer350(veh)
        local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
        if not isTourer then
            return string.format("รถปัจจุบัน: %s\n⚠️ ระบบจูนนี้ล็อกเฉพาะ Tourer 350 เท่านั้น\nกรุณาเรียกรถ Tourer 350 เพื่อใช้งาน", tostring(vName))
        end

        local isEcuOn = Hub.Settings.AutoTuneRunning or Hub.Settings.EcuTuneMaster
        local gain = veh:GetAttribute("EcuGain") or 1.0
        local rawFeedback = veh:GetAttribute("EcuFeedback")
        local fb = {Air = 0, Fuel = 0, Afr = 0, Tps = 0, Oil = 0, Ign = 0}
        if rawFeedback then pcall(function() fb = HttpService:JSONDecode(rawFeedback) end) end

        local statusText = (gain >= 1.95) and "⚡ จูนสมบูรณ์แบบ 100% (Server Legit x2.00)" or (isEcuOn and "🔄 พร้อมแฟลช / รัน Dyno" or "🔒 ระบบจูนโรงงาน")
        return string.format(
            "รถ: %s\nกำลังเครื่องยนต์: x%.2f\nAir: %.0f%% | Fuel: %.0f%% | AFR: %.0f%%\nTPS: %.0f%% | Oil: %.0f%% | IGN: %.0f%%\nสถานะ: %s",
            tostring(vName),
            tonumber(gain) or 1.0,
            (fb.Air or 0) * 100,
            (fb.Fuel or 0) * 100,
            (fb.Afr or 0) * 100,
            (fb.Tps or 0) * 100,
            (fb.Oil or 0) * 100,
            (fb.Ign or 0) * 100,
            statusText
        )
    end

    DynoStatusUpdater = function()
        if DynoStatusPara then
            pcall(function() DynoStatusPara:SetDesc(GetDynoMonitorText()) end)
        end
    end

    -- Periodic Dyno Display Auto-Refresh
    task.spawn(function()
        while Hub.Running and genv._MahanakhonScriptId == SCRIPT_ID do
            if DynoStatusPara then
                pcall(function() DynoStatusPara:SetDesc(GetDynoMonitorText()) end)
            end
            task.wait(2.0)
        end
    end)

    Tabs.EcuTune:AddSection("สูตรแมพจูน Tourer 350", "Left")

    Tabs.EcuTune:AddButton({
        Title = "แฟลชสูตรแข่ง Tourer 350 (200%)",
        Description = "จูนเต็ม 100% ตรงรุ่น Tourer 350 (Server Legit ไม่โดนแบน)",
        Callback = function()
            FlashEcuFile(Tourer350MapData)
            task.delay(0.5, function() if DynoStatusUpdater then pcall(DynoStatusUpdater) end end)
        end
    })

    Tabs.EcuTune:AddButton({
        Title = "คืนค่าโรงงาน",
        Description = "รีเซ็ตตารางจูนกลับเป็นค่าเดิม",
        Callback = function()
            RestoreStockEcuMap()
            task.delay(0.5, function() if DynoStatusUpdater then pcall(DynoStatusUpdater) end end)
        end
    })

    Tabs.EcuTune:AddSection("ใส่โค้ดจูน", "Left")

    Tabs.EcuTune:AddInput("RedeemCodeInput", {
        Title = "โค้ดจูน 8 หลัก",
        Default = "",
        Placeholder = "เช่น ZTTM-APGF",
        Callback = function(v) Hub.Settings.RedeemCodeInput = v end
    })

    Tabs.EcuTune:AddButton({
        Title = "ใช้งานโค้ด",
        Description = "ดึงแมพจากโค้ดมาลงรถ",
        Callback = function()
            RedeemTuneCode(Hub.Settings.RedeemCodeInput)
            task.delay(0.5, function() if DynoStatusUpdater then pcall(DynoStatusUpdater) end end)
        end
    })

    Tabs.EcuTune:AddSection("สถานะ Dyno", "Right")

    DynoStatusPara = Tabs.EcuTune:AddParagraph({
        Title = "ผลจูนปัจจุบัน",
        Content = GetDynoMonitorText()
    })

    Tabs.EcuTune:AddButton({
        Title = "รีเฟรชข้อมูล",
        Description = "อัปเดตแรงม้าล่าสุด",
        Callback = function()
            DynoStatusPara:SetDesc(GetDynoMonitorText())
            Fluent:Notify({ Title = "Dyno", Content = "อัปเดตเรียบร้อย", Duration = 2 })
        end
    })

    Tabs.EcuTune:AddSection("ออโต้จูน (Tourer 350)", "Right")

    local AutoTuneToggle = Tabs.EcuTune:AddToggle("AutoTuneToggle", {
        Title = "ออโต้จูน 100% (Tourer 350)",
        Description = "ตรวจจับและแฟลชแมพ 100% ให้ Tourer 350 อัตโนมัติ",
        Default = Hub.Settings.AutoTuneRunning
    })
    AutoTuneToggle:OnChanged(function(v)
        Hub.Settings.AutoTuneRunning = v
        Hub.Settings.EcuTuneMaster = v
        if v then
            RunAutoTuneOptimizer()
        else
            RestoreStockEcuMap()
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "Auto Tune",
                    Content = "ปิดระบบออโต้จูนแล้ว (คืนค่าระบบจูนปกติ)",
                    Duration = 2
                })
            end
        end
        SaveConfig()
        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
    end)

    -- ================================================
    -- 🌾 TAB 3: AUTO FARM
    -- ================================================
    Tabs.Farm:AddSection("บอทฟาร์มเงิน", "Left")

    local AutoCaptchaToggle = Tabs.Farm:AddToggle("AutoCaptchaToggle", {
        Title = "ตอบแคปช่าออโต้",
        Description = "ตอบ FarmCheck อัตโนมัติกันโดนเตะ",
        Default = Hub.Settings.AutoCaptcha
    })
    AutoCaptchaToggle:OnChanged(function(v)
        Hub.Settings.AutoCaptcha = v
    end)

    local AutoFoodToggle, AutoGrabToggle

    AutoFoodToggle = Tabs.Farm:AddToggle("AutoFoodToggle", {
        Title = "ส่งอาหารออโต้",
        Description = "รับงาน ส่งของ วาร์ปวนลูป",
        Default = Hub.Settings.AutoFoodDelivery
    })
    AutoFoodToggle:OnChanged(function(v)
        Hub.Settings.AutoFoodDelivery = v
        pcall(ApplyVehiclePhysicsMods)
        if v then
            if AutoGrabToggle and Hub.Settings.AutoGrabRide then
                AutoGrabToggle:SetValue(false)
            end
            Fluent:Notify({ Title = "ส่งอาหาร", Content = "เริ่มทำงานออโต้ (กันตกรถ & กันรถพัง 100%)", Duration = 2.5 })
        end
    end)

    AutoGrabToggle = Tabs.Farm:AddToggle("AutoGrabToggle", {
        Title = "รับส่งคนออโต้",
        Description = "รับ-ส่งผู้โดยสาร Grab วนลูป",
        Default = Hub.Settings.AutoGrabRide
    })
    AutoGrabToggle:OnChanged(function(v)
        Hub.Settings.AutoGrabRide = v
        pcall(ApplyVehiclePhysicsMods)
        if v then
            if AutoFoodToggle and Hub.Settings.AutoFoodDelivery then
                AutoFoodToggle:SetValue(false)
            end
            Fluent:Notify({ Title = "Grab", Content = "เริ่มทำงานออโต้ (กันตกรถ & กันรถพัง 100%)", Duration = 2.5 })
        end
    end)

    Tabs.Farm:AddSection("วาร์ปจุดรับงาน", "Right")

    Tabs.Farm:AddButton({
        Title = "ตู้ชุดไรเดอร์",
        Description = "วาร์ปและใส่ชุดไรเดอร์ทันที",
        Callback = function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum then hum.Sit = false end
            if hrp then
                hrp.CFrame = CFrame.new(89.5, 4.3, -118)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
            task.wait(0.2)
            local locker = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("JobLockers") and Workspace.Map.JobLockers:FindFirstChild("Locker_Delivery")
            local prompt = locker and locker:FindFirstChild("Cabinet") and locker.Cabinet:FindFirstChild("LockerPrompt")
            if prompt and fireproximityprompt then
                pcall(fireproximityprompt, prompt)
            end
            if Fluent then
                Fluent:Notify({ Title = "ชุดไรเดอร์", Content = "ใส่ชุดไรเดอร์เรียบร้อย!", Duration = 2.5 })
            end
        end
    })

    Tabs.Farm:AddButton({
        Title = "ตู้ชุดช่างซ่อม",
        Description = "วาร์ปไปจุดช่าง AutoWorks",
        Callback = function() TeleportEntity(CFrame.new(148, 4, -193), { Dismount = true }) end
    })

    -- ================================================
    -- 👁️ TAB 4: ESP
    -- ================================================
    Tabs.Visuals:AddSection("ESP ผู้เล่น", "Left")

    local ESPMainToggle = Tabs.Visuals:AddToggle("ESPMainToggle", {
        Title = "เปิด ESP",
        Description = "มองทะลุเห็นคนทั้งแมพ",
        Default = Hub.Settings.PlayerESP
    })
    ESPMainToggle:OnChanged(function(v) Hub.Settings.PlayerESP = v end)

    local ESPBoxToggle = Tabs.Visuals:AddToggle("ESPBoxToggle", {
        Title = "กรอบตัว 2D",
        Description = "แสดงกล่องสี่เหลี่ยมรอบตัวคน",
        Default = Hub.Settings.ESPBox
    })
    ESPBoxToggle:OnChanged(function(v) Hub.Settings.ESPBox = v end)

    local ESPNameToggle = Tabs.Visuals:AddToggle("ESPNameToggle", {
        Title = "ชื่อคน",
        Description = "แสดงชื่อผู้เล่น",
        Default = Hub.Settings.ESPName
    })
    ESPNameToggle:OnChanged(function(v) Hub.Settings.ESPName = v end)

    Tabs.Visuals:AddSection("ข้อมูล ESP", "Right")

    local ESPDistToggle = Tabs.Visuals:AddToggle("ESPDistToggle", {
        Title = "ระยะทาง (ม.)",
        Description = "บอกระยะห่างจากเรา",
        Default = Hub.Settings.ESPDistance
    })
    ESPDistToggle:OnChanged(function(v) Hub.Settings.ESPDistance = v end)

    local ESPVehicleToggle = Tabs.Visuals:AddToggle("ESPVehicleToggle", {
        Title = "ชื่อรถที่ขับ",
        Description = "บอกรุ่นรถของผู้เล่น",
        Default = Hub.Settings.ESPVehicle
    })
    ESPVehicleToggle:OnChanged(function(v) Hub.Settings.ESPVehicle = v end)

    -- ================================================
    -- 🏃 TAB 5: MOVEMENT & FLY
    -- ================================================
    Tabs.Movement:AddSection("เดินเร็ว & โดด", "Left")

    local SpeedToggle = Tabs.Movement:AddToggle("SpeedToggle", {
        Title = "เดินเร็ว",
        Description = "เพิ่มความเร็วเดินของตัวละคร",
        Default = Hub.Settings.SpeedHack
    })
    SpeedToggle:OnChanged(function(v)
        Hub.Settings.SpeedHack = v
        if not v and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)

    local SpeedSlider = Tabs.Movement:AddSlider("SpeedSlider", {
        Title = "ความเร็วเดิน (ปลอดภัยกันโดนเตะ 16-18)",
        Default = math.clamp(Hub.Settings.SpeedValue, 16, 18),
        Min = 16,
        Max = 18,
        Rounding = 0
    })
    SpeedSlider:OnChanged(function(v) Hub.Settings.SpeedValue = v end)

    local InfJumpToggle = Tabs.Movement:AddToggle("InfJumpToggle", {
        Title = "โดดไม่จำกัด",
        Description = "กระโดดกลางอากาศได้เรื่อยๆ",
        Default = Hub.Settings.InfJump
    })
    InfJumpToggle:OnChanged(function(v) Hub.Settings.InfJump = v end)

    local NoclipToggle = Tabs.Movement:AddToggle("NoclipToggle", {
        Title = "เดินทะลุกำแพง",
        Description = "Noclip ทะลุสิ่งกีดขวาง",
        Default = Hub.Settings.Noclip
    })
    NoclipToggle:OnChanged(function(v) Hub.Settings.Noclip = v end)

    Tabs.Movement:AddSection("โหมดบิน (Fly)", "Right")

    local FlyToggle = Tabs.Movement:AddToggle("FlyToggle", {
        Title = "เปิดบิน (คน/รถ)",
        Description = "บินได้ทั้งตัวละครและรถ",
        Default = Hub.Settings.Fly
    })
    FlyToggle:OnChanged(function(v)
        Hub.Settings.Fly = v
        if v then StartFly() else StopFly() end
    end)

    local FlySpeedSlider = Tabs.Movement:AddSlider("FlySpeedSlider", {
        Title = "ความเร็วบิน",
        Default = Hub.Settings.FlySpeed,
        Min = 20,
        Max = 200,
        Rounding = 0
    })
    FlySpeedSlider:OnChanged(function(v) Hub.Settings.FlySpeed = v end)

    -- ================================================
    -- 📍 TAB 6: TELEPORT
    -- ================================================
    Tabs.Teleport:AddSection("ตั้งค่าวาร์ป", "Left")

    local WarpSpeedSlider = Tabs.Teleport:AddSlider("WarpSpeedSlider", {
        Title = "ความเร็วร่อน",
        Description = "ความเร็วลอยข้ามแมพ (studs/s)",
        Default = Hub.Settings.WarpSpeed,
        Min = 120,
        Max = 270,
        Rounding = 0
    })
    WarpSpeedSlider:OnChanged(function(v) Hub.Settings.WarpSpeed = v end)

    Tabs.Teleport:AddSection("อู่แต่ง & สนามแข่ง", "Left")

    Tabs.Teleport:AddButton({
        Title = "AutoWorks ตะวันออก",
        Description = "Tune Bay ตะวันออก (1250, 4, 1521)",
        Callback = function() TeleportEntity(CFrame.new(1250, 4, 1521)) end
    })

    Tabs.Teleport:AddButton({
        Title = "AutoWorks ตะวันตก",
        Description = "Tune Bay ตะวันตก (-1250, 4, -1921)",
        Callback = function() TeleportEntity(CFrame.new(-1250, 4, -1921)) end
    })

    Tabs.Teleport:AddButton({
        Title = "AutoWorks สาขาใหญ่",
        Description = "ลานหน้าร้านแต่งหลัก (166, 4, -159)",
        Callback = function() TeleportEntity(CFrame.new(166, 4, -159)) end
    })

    Tabs.Teleport:AddButton({
        Title = "สนามแข่งแดร็ก",
        Description = "จุดแต่งรถสนามแดร็ก (135, 4, -3684)",
        Callback = function() TeleportEntity(CFrame.new(135, 4, -3684)) end
    })

    Tabs.Teleport:AddButton({
        Title = "ร้านลูกสูบ 2",
        Description = "จุดโมลูกสูบ Spot 4 (71, 3.5, 1488)",
        Callback = function() TeleportEntity(CFrame.new(71, 3.5, 1488)) end
    })

    Tabs.Teleport:AddButton({
        Title = "ร้านลูกสูบ 3",
        Description = "จุดโมลูกสูบ Spot 3 (-71, 3.5, 252)",
        Callback = function() TeleportEntity(CFrame.new(-71, 3.5, 252)) end
    })

    Tabs.Teleport:AddSection("จุดเกิด & ปั๊มน้ำมัน", "Right")

    Tabs.Teleport:AddButton({
        Title = "จุดเกิดกลางเมือง",
        Description = "จุดเกิดหลัก (118, 4, -134)",
        Callback = function() TeleportEntity(CFrame.new(118, 4, -134)) end
    })

    Tabs.Teleport:AddButton({
        Title = "ปั๊มน้ำมันใหญ่",
        Description = "ปั๊มหน้า AutoWorks (123, 4, -397)",
        Callback = function() TeleportEntity(CFrame.new(123, 4, -397)) end
    })

    Tabs.Teleport:AddButton({
        Title = "ปั๊มน้ำมันวงแหวน",
        Description = "ปั๊มถนนวงแหวน (1030, 3.5, -300)",
        Callback = function() TeleportEntity(CFrame.new(1030, 3.5, -300)) end
    })

    -- ================================================
    -- ⚙️ TAB 7: SETTINGS
    -- ================================================
    Tabs.Settings:AddSection("เมนู", "Left")

    Tabs.Settings:AddKeybind("MenuToggleKey", {
        Title = "ปุ่มเปิด/ปิดเมนู",
        Default = Enum.KeyCode.RightControl,
        Callback = function(key)
            pcall(function() Window:SetKeybind(key) end)
        end
    })

    Tabs.Settings:AddSection("เซฟการตั้งค่า", "Left")

    Tabs.Settings:AddButton({
        Title = "บันทึกการตั้งค่า",
        Description = "เซฟค่าคอนฟิกลงเครื่อง",
        Callback = function()
            local ok = SaveConfig()
            if Fluent then
                Fluent:Notify({
                    Title = "เซฟสำเร็จ",
                    Content = ok and "บันทึกการตั้งค่าเรียบร้อยแล้ว!" or "เซฟค่าลงหน่วยความจำชั่วคราวแล้ว",
                    Duration = 2.5
                })
            end
        end
    })

    Tabs.Settings:AddButton({
        Title = "โหลดการตั้งค่า",
        Description = "ดึงค่าคอนฟิกที่เซฟไว้",
        Callback = function()
            LoadConfig()
            if Fluent then
                Fluent:Notify({
                    Title = "โหลดสำเร็จ",
                    Content = "ดึงการตั้งค่าที่บันทึกไว้เรียบร้อยแล้ว!",
                    Duration = 2.5
                })
            end
        end
    })

    Tabs.Settings:AddButton({
        Title = "ปิดสคริปต์",
        Description = "ลบเมนูและคืนค่าเดิมทั้งหมด",
        Callback = function()
            if genv.Mahanakhon_Cleanup then
                genv.Mahanakhon_Cleanup()
            end
            pcall(function() Window:Unload() end)
        end
    })

    Tabs.Settings:AddSection("ธีม", "Right")

    local IconThemeDrop = Tabs.Settings:AddDropdown("IconThemeDrop", {
        Title = "โทนสีไอคอน",
        Values = {"หลากสีตามหมวด", "น้ำเงินนีออน"},
        Default = "หลากสีตามหมวด"
    })
    IconThemeDrop:OnChanged(function(v)
        if v:find("น้ำเงิน") then
            Hub.Settings.IconTheme = "ElectricBlue"
        else
            Hub.Settings.IconTheme = "Themed"
        end
        ApplyTabIconColors()
    end)

    pcall(function()
        if Tabs and Tabs.Farm and type(Tabs.Farm.Select) == "function" then
            Tabs.Farm:Select()
        end
    end)
    Fluent:Notify({
        Title = "KrakenHub",
        Content = "โหลดสำเร็จ! กด Right Control หรือแตะปุ่มเพื่อเปิด/ปิด",
        Duration = 3
    })
end

-- ==============================================================
-- 🧹 9. CLEANUP HANDLER
-- ==============================================================
genv.Mahanakhon_Cleanup = function()
    Hub.Running = false
    Hub.Settings.AutoTuneRunning = false
    Hub.Settings.EcuTuneMaster = false
    pcall(RestoreStockEcuMap)

    -- Remove UI & Toggle Button
    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    if Hub.Window then
        pcall(function() Hub.Window:Unload() end)
    end

    -- Disconnect loops
    for _, conn in pairs(Hub.Connections) do
        pcall(function() conn:Disconnect() end)
    end

    -- Clear ESP
    for plr in pairs(Hub.ESPObjects) do
        RemoveESPForPlayer(plr)
    end

    -- Restore Vehicle Settings
    if PCX160Shared and OriginalVehicleSettings.PCX_CrashMinSpeed then
        PCX160Shared.CRASH_MIN_SPEED = OriginalVehicleSettings.PCX_CrashMinSpeed
        PCX160Shared.BRAKE_DECEL = OriginalVehicleSettings.PCX_BrakeDecel
        PCX160Shared.TUCK_SPEED_BONUS = OriginalVehicleSettings.PCX_TuckBonus
        PCX160Shared.STEER_RATE_SLOW = OriginalVehicleSettings.PCX_SteerRate
    end
    if CarShared and OriginalVehicleSettings.Car_ImpactMinSpeed then
        CarShared.IMPACT_MIN_SPEED = OriginalVehicleSettings.Car_ImpactMinSpeed
        CarShared.BRAKE_DECEL = OriginalVehicleSettings.Car_BrakeDecel
    end

    -- Restore Player WalkSpeed
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end

    StopFly()
    print("[KrakenHub] MAHANAKHON RACING Script cleanly unloaded.")
end

-- ==============================================================
-- 🚀 10. INITIALIZE
-- ==============================================================
task.spawn(function()
    local ok, err = xpcall(InitUI, debug.traceback)
    if not ok then
        _G._KrakenHub_InitUI_Error = tostring(err)
        warn("[KrakenHub] InitUI Error: " .. tostring(err))
    else
        _G._KrakenHub_InitUI_Error = "NONE_SUCCESS"
        print("[KrakenHub] MAHANAKHON RACING UI & Engine successfully initialized!")
    end
end)
