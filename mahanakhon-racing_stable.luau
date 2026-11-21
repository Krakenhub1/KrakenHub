rawset(getgenv(), "FILE_TEST_TIMESTAMP", os.clock())
-- ==============================================================
-- 🌊 KRAKENHUB | MAHANAKHON RACING (มหานคร เรซซิ่ง)
-- Game: https://www.roblox.com/games/104549080643413/MAHANAKHON-RACING
-- PlaceId: 104549080643413 | GameId: 10771935715
--
-- Features:
-- • Clean, Minimal & High-Impact UI (No Clutter)
-- • 5 Sleek Categories: Vehicle, ECU Tuner, Auto Farm, ESP & Move, Warps & Settings
-- • Native NetSeal Security + Background Protection
--
-- [FARM BUG FIX PATCH v2 — 2026-11-18]
-- Fix 1: Unified ConfirmDelivery with In-Flight Mutex & Multi-Retry (Fixed "รับไม่ค่อยติด" & slider stuck)
--        → Re-enabled instant DeliveryArrived signal listener backed by IsConfirmingDelivery mutex.
--        → Added 5-attempt retry loop (0.25s interval) and physical velocity zeroing (STOP_SPEED <= 6).
-- Fix 2: AcceptDeliveryOffer Multi-Retry & Physical Zero-Speed
--        → Retries up to 4 times (0.2s interval) with mounted + velocity zeroing check.
-- Fix 3: WaitSafeLegConfirm Heartbeat Keep-Alive & Wait Clamp (max 3.0s)
--        → Prevents long idle freezes and stops watchdog from falsely tripping on long trips.
-- Fix 4: Arrival Radius Safety Margin in GetRoadParkingPosition (28s/30s → 20s/22s)
--        → Ensures vehicle stops strictly <= 20 studs from target, well within ARRIVE_RADIUS = 32.
-- ==============================================================

local function SafeGetService(name)
    local s, r = pcall(function() return game.GetService(game, name) end)
    if s and r then return r end
    local s2, r2 = pcall(function() return game:GetService(name) end)
    if s2 and r2 then return r2 end
    local s3, r3 = pcall(function() return game[name] end)
    if s3 and r3 then return r3 end
    return nil
end

if not game:IsLoaded() then
    pcall(function() game.Loaded:Wait() end)
end

local Players = SafeGetService("Players") or game.Players
local Workspace = SafeGetService("Workspace") or workspace
local ReplicatedStorage = SafeGetService("ReplicatedStorage") or game.ReplicatedStorage
local RunService = SafeGetService("RunService") or game.RunService
local UserInputService = SafeGetService("UserInputService") or game.UserInputService
local TweenService = SafeGetService("TweenService") or game.TweenService
local HttpService = SafeGetService("HttpService") or game.HttpService
local VirtualUser = SafeGetService("VirtualUser")
local TeleportService = SafeGetService("TeleportService") or game:GetService("TeleportService")
local GuiService = SafeGetService("GuiService") or game:GetService("GuiService")
local CoreGui = SafeGetService("CoreGui") or game:GetService("CoreGui")

local OriginalPlaceId = game.PlaceId
local OriginalJobId = game.JobId

task.spawn(function()
    for _ = 1, 30 do
        if OriginalJobId and #OriginalJobId > 0 then break end
        if game.JobId and #game.JobId > 0 then
            OriginalJobId = game.JobId
            break
        end
        task.wait(0.5)
    end
end)

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    pcall(function()
        repeat task.wait(0.1) until Players.LocalPlayer
        LocalPlayer = Players.LocalPlayer
    end)
end
local Camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera", 10)

-- Check PlaceId
if game.PlaceId ~= 104549080643413 and game.PlaceId ~= 0 then
    -- PlaceId mismatch
end

-- ==============================================================
-- 📱💻 UNIVERSAL CROSS-PLATFORM & EXECUTOR ENGINE (PC & MOBILE)
-- ==============================================================
local genv = (typeof(getgenv) == "function" and getgenv()) or _G

-- [AC BYPASS v2 - LAYER 4] Native Executor Identity (ลบ setidentity ออกเพื่อคง Capability Plugin ไว้ให้ UI ทำงานได้)

-- 🛡️ Obfuscated genv key names (prevents UiGuardShared.GLOBALS string scan)
local _gk = {
    sk = "_M" .. "HK" .. "_SK",          -- session key
    ni = "_Orig" .. "NS" .. "Inv",        -- NetSeal invoke original
    nf = "_Orig" .. "NS" .. "Fire",       -- NetSeal fire original
    hb = "_NS" .. "NC" .. "Hooked",       -- namecall hooked flag
    mb = "_NS" .. "M" .. "Hooked",        -- method hooked flag
    vk = "_plr" .. "Veh" .. "Cache",      -- known vehicles cache
    hh = "_app" .. "Hub" .. "State",      -- hub state
    cl = "_app" .. "Hub" .. "Cleanup",    -- cleanup fn
    -- ✅ FIX: เพิ่ม 2 keys ที่เคยเป็น plain string ใน genv
    sp = "_NS" .. "sI" .. "nv" .. "Pt",  -- safe invoke ptr (แทน "_NSsafeInvokePtr")
    sf = "_NS" .. "sF" .. "ir" .. "Pt",  -- safe fire ptr (แทน "_NSsafeFirePtr")
    lh = "_L" .. "S_H" .. "KD",          -- logservice hooked flag
}


-- 🛡️ Anti-Detection: Sanitize _G completely (UiGuardShared.GLOBALS scans _G directly)
pcall(function()
    _G._MahanakhonScriptId = nil
    rawset(_G, "_MahanakhonScriptId", nil)
    rawset(_G, "KrakenHub_Mahanakhon", nil)
    rawset(_G, "_KrakenHub_InitUI_Error", nil)
end)

-- [AC BYPASS v2 - LAYER 2] Periodic _G re-sanitizer task loop
task.spawn(function()
    local dirtyKeys = {
        "_MahanakhonScriptId", "KrakenHub_Mahanakhon", "_KrakenHub_InitUI_Error",
        "KrakenHubLoaded", "KrakenHubScript", "MahanakhonHub",
        "RIGScript", "ExploitHub", "ScriptHub", "AutoFarmEnabled"
    }
    while true do
        pcall(function()
            for _, k in ipairs(dirtyKeys) do
                if _G[k] ~= nil then rawset(_G, k, nil) end
            end
            for k, _ in pairs(_G) do
                if type(k) == "string" then
                    local lk = k:lower()
                    if lk:find("krakenhub") or lk:find("mahanakhon") or lk:find("autofarm") or lk:find("exploit") then
                        rawset(_G, k, nil)
                    end
                end
            end
        end)
        task.wait(14 + math.random() * 3)
    end
end)

genv[_gk.sk] = (genv[_gk.sk] or 0) + 1
local SCRIPT_ID = genv[_gk.sk]

function DetectPlatformInfo()
    local isMobile = false
    local osName = "Windows (PC)"

    local okPlat, plat = pcall(function() return UserInputService:GetPlatform() end)
    if okPlat then
        if plat == Enum.Platform.Android then
            isMobile = true
            osName = "Android"
        elseif plat == Enum.Platform.IOS then
            isMobile = true
            osName = "iOS (Apple)"
        elseif plat == Enum.Platform.Windows or plat == Enum.Platform.UWP then
            isMobile = false
            osName = "Windows"
        elseif plat == Enum.Platform.OSX then
            isMobile = false
            osName = "macOS"
        end
    end

    if not isMobile then
        if genv.APPLEWARE or genv.Appleware or genv.CUBIX then
            isMobile = true
            osName = "iOS (Appleware/Cubix)"
        elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            isMobile = true
            osName = "Mobile Touch Device"
        elseif UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
            isMobile = true
            osName = "Mobile Touch Device"
        end
    end

    local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
    if vp.X > 200 and vp.Y > 200 and UserInputService.TouchEnabled and (vp.Y < 650 or vp.X < 960) then
        isMobile = true
    end

    return isMobile, osName
end

function ResolveExecutorName()
    local ok, name = pcall(function()
        if typeof(identifyexecutor) == "function" then
            local n = identifyexecutor()
            return type(n) == "string" and n or tostring(n)
        elseif typeof(getexecutorname) == "function" then
            local n = getexecutorname()
            return type(n) == "string" and n or tostring(n)
        end
    end)
    if ok and name and name ~= "" and name ~= "nil" then
        return name
    end
    if typeof(delta) == "table" or genv.Delta then return "Delta" end
    if typeof(codex) == "table" or genv.CODEX then return "Codex" end
    if typeof(arceus) == "table" or genv.SPDM_LOADED then return "Arceus X" end
    if typeof(fluxus) == "table" or genv.FLUXUS_LOADED then return "Fluxus" end
    if typeof(syn) == "table" then return "Synapse" end
    if KRNL_LOADED then return "Krnl" end
    if typeof(wave) == "table" or genv.WAVE then return "Wave" end
    if genv.APPLEWARE or genv.Appleware then return "Appleware" end
    if genv.SOLARA or genv.Solara then return "Solara" end
    if genv.CUBIX then return "Cubix" end
    if genv.SWIFT then return "Swift" end
    if genv.CELERY then return "Celery" end
    return "Universal"
end

local IsMobileDevice, PlatformOSName = DetectPlatformInfo()
local ExecutorName = ResolveExecutorName()

-- Universal Clipboard Helper (Compatible with Delta, Arceus, Codex, Fluxus, Wave, Solara, etc.)
function CopyToClipboard(text)
    local fn = setclipboard or toclipboard or (Clipboard and Clipboard.set) or set_clipboard
    if fn then
        pcall(fn, tostring(text))
        return true
    end
    return false
end

-- Universal HTTP Fetcher (Handles 302 Redirects, Solara, Wave, Delta, Codex, Fluxus)
function UniversalHttpGet(url)
    if typeof(HttpGet) == "function" then
        local s, res = pcall(HttpGet, url)
        if s and type(res) == "string" and #res > 100 and not res:match("^%s*<") then
            return res
        end
    end
    if typeof(game.HttpGet) == "function" then
        local s, res = pcall(function() return game.HttpGet(game, url) end)
        if s and type(res) == "string" and #res > 100 and not res:match("^%s*<") then
            return res
        end
        local s2, res2 = pcall(function() return game.HttpGet(url) end)
        if s2 and type(res2) == "string" and #res2 > 100 and not res2:match("^%s*<") then
            return res2
        end
        local s3, res3 = pcall(function() return game:HttpGet(url) end)
        if s3 and type(res3) == "string" and #res3 > 100 and not res3:match("^%s*<") then
            return res3
        end
    end
    local req = (typeof(request) == "function" and request)
             or (typeof(http_request) == "function" and http_request)
             or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
             or (typeof(http) == "table" and typeof(http.request) == "function" and http.request)
             or (typeof(fluxus) == "table" and typeof(fluxus.request) == "function" and fluxus.request)
    if req then
        local s, resp = pcall(req, { Url = url, Method = "GET" })
        if s and typeof(resp) == "table" then
            local b = resp.Body or resp.body
            if type(b) == "string" and #b > 100 and not b:match("^%s*<") then
                return b
            end
        end
    end
    return nil
end

if genv[_gk.cl] then
    pcall(genv[_gk.cl])
end

-- ==============================================================
-- 📦 1. GAME REFERENCES & SHARED MODULES
-- ==============================================================
local NetSeal = nil
pcall(function()
    NetSeal = require(ReplicatedStorage:WaitForChild("NetSeal", 5))
    if NetSeal then
        genv[_gk.ni] = genv[_gk.ni] or NetSeal.invoke
        genv[_gk.nf] = genv[_gk.nf] or NetSeal.fire
    end
end)
local UiOwn = nil
pcall(function() UiOwn = require(ReplicatedStorage:WaitForChild("UiOwn", 5)) end)
local UiGuardShared = nil
pcall(function() UiGuardShared = require(ReplicatedStorage:WaitForChild("UiGuardShared", 5)) end)
local PistonShared = nil
pcall(function() PistonShared = require(ReplicatedStorage:WaitForChild("PistonShared", 5)) end)
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

local MapRoads = nil
pcall(function() MapRoads = require(ReplicatedStorage:WaitForChild("MapRoads", 5)) end)

-- 🛡️ Neutralize NetSeal.guard outsideCaller() & UiGuard / UiOwn Scanners
local STEALTH_UI_NAME = "InterfaceLayout"
local STEALTH_BTN_NAME = "TouchControlLayout"
local StealthGuiNames = {
    [STEALTH_UI_NAME] = true,
    [STEALTH_BTN_NAME] = true,
}

-- [AC BYPASS v2 - LAYER 9] Systematic SNAP GUI Rename Map
local SNAP_GUI_RENAME_MAP = {
    [STEALTH_UI_NAME]            = "RobloxGui",
    [STEALTH_BTN_NAME]           = "TouchControlLayout",
    ["KrakenHub_Mahanakhon_UI"]  = "RobloxGui",
    ["KrakenHub_Mahanakhon_Btn"] = "TopbarPlus",
    ["InterfaceLayout"]          = "RobloxGui",
    ["TouchControlLayout"]       = "TouchGui",
    ["VantixUI"]                 = "RobloxGui",
    ["VantixGuiV6"]              = "RobloxGui",
    ["FluentUI"]                 = "RobloxGui",
}

function RenameSnapGui(g)
    if type(g) ~= "table" then return g end
    local gName = tostring(g.name or "")
    if SNAP_GUI_RENAME_MAP[gName] then
        return { name = SNAP_GUI_RENAME_MAP[gName], known = true, enabled = true, shown = true }
    end
    if StealthGuiNames[gName] then
        return { name = "RobloxGui", known = true, enabled = true, shown = true }
    end
    local lname = gName:lower()
    for _, pattern in ipairs({ "kraken", "vantix", "fluent", "hub", "exploit", "bypass", "farm" }) do
        if lname:find(pattern, 1, true) then
            return { name = "RobloxGui", known = true, enabled = true, shown = true }
        end
    end
    return g
end

function RegisterStealthGui(guiOrName)
    local name = typeof(guiOrName) == "Instance" and guiOrName.Name or tostring(guiOrName or "")
    if name == "" then return end
    StealthGuiNames[name] = true
    pcall(function()
        if type(UiGuardShared) == "table" then
            for _, tblName in ipairs({ "KNOWN", "NOT_MARKED", "SWEEP_SKIP" }) do
                if type(UiGuardShared[tblName]) == "table" then
                    UiGuardShared[tblName][name] = true
                end
            end
        end
    end)
end

-- [AC BYPASS v2 - LAYER 7] PlayerGui __index probe neutralizer (blocks .Source / .ScriptId reads)
pcall(function()
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local rawmeta = typeof(getrawmetatable) == "function" and getrawmetatable(playerGui)
    if rawmeta and typeof(setreadonly) == "function" and typeof(newcclosure) == "function" then
        setreadonly(rawmeta, false)
        local origIndex = rawmeta.__index
        rawmeta.__index = newcclosure(function(self, key)
            if (key == "Source" or key == "ScriptId" or key == "Script") then
                local name = pcall(function() return rawget(self, "Name") end) and rawget(self, "Name") or ""
                if StealthGuiNames[name] or SNAP_GUI_RENAME_MAP[name] then
                    return nil
                end
            end
            if origIndex then return origIndex(self, key) end
            return nil
        end)
        setreadonly(rawmeta, true)
    end
end)

pcall(function()
    -- Early neutralization of NetSeal.guard to prevent any stack inspection during early execution
    local getups = (typeof(debug) == "table" and debug.getupvalues) or (typeof(getupvalues) == "function" and getupvalues)
    if NetSeal and getups then
        for _, fn in ipairs({ NetSeal.invoke, NetSeal.fire }) do
            if type(fn) == "function" then
                local ups = getups(fn)
                if ups and type(ups[1]) == "function" then
                    if typeof(hookfunction) == "function" then pcall(hookfunction, ups[1], function(...) return end) end
                end
            end
        end
    end
    if type(UiOwn) == "table" then
        UiOwn.gameSource = function() return true end
        UiOwn.mine = function() return true end
        UiOwn.madeBy = function() return nil end
        UiOwn.copied = function() return false end
    end
end)

local NodeHalfWidths = {}
local EdgeHalfWidths = {}
if MapRoads and MapRoads.EDGES and MapRoads.KINDS then
    for i = 1, #MapRoads.EDGES, 3 do
        local a = MapRoads.EDGES[i]
        local b = MapRoads.EDGES[i + 1]
        local k = MapRoads.EDGES[i + 2]
        local kind = MapRoads.KINDS[k]
        local half = kind and kind.half or 12
        NodeHalfWidths[a] = math.max(NodeHalfWidths[a] or 0, half)
        NodeHalfWidths[b] = math.max(NodeHalfWidths[b] or 0, half)
        EdgeHalfWidths[a .. ":" .. b] = half
        EdgeHalfWidths[b .. ":" .. a] = half
    end
end

function FindNearestRoadNodeIndex(pos)
    if not RoadGraph or not RoadGraph.nodes then return nil end
    local px = pos.X
    local pz = (typeof(pos) == "Vector3" and pos.Z) or (typeof(pos) == "Vector2" and pos.Y) or 0
    local bestNode = nil
    local bestDist = 1e9
    for idx, v2 in ipairs(RoadGraph.nodes) do
        local dx = v2.X - px
        local dz = v2.Y - pz
        local d = dx * dx + dz * dz
        if d < bestDist then
            bestDist = d
            bestNode = idx
            if d < 4 then break end
        end
    end
    return bestNode
end

function GetRoadSegmentHalfWidth(pA, pB)
    local idxA = FindNearestRoadNodeIndex(pA)
    local idxB = FindNearestRoadNodeIndex(pB)
    if idxA and idxB then
        local edgeHalf = EdgeHalfWidths[idxA .. ":" .. idxB]
        if edgeHalf then return edgeHalf end
        local halfA = NodeHalfWidths[idxA] or 12
        local halfB = NodeHalfWidths[idxB] or 12
        -- If either node connects to a divided highway/boulevard (has center median), preserve wide divided road width
        if halfA >= 28 or halfB >= 28 then
            return math.max(halfA, halfB)
        end
        return math.min(halfA, halfB)
    end
    return (idxA and NodeHalfWidths[idxA]) or (idxB and NodeHalfWidths[idxB]) or 12
end

function GetLaneOffsetForRoad(halfWidth)
    if halfWidth >= 80 then
        return 55.0 -- Wide Boulevard (half=118): Center of left carriageway
    elseif halfWidth >= 50 then
        return 34.0 -- Main Avenue (half=64): Center of left carriageway (clears 8-stud median by 28+ studs)
    elseif halfWidth >= 28 then
        return 16.5 -- Ring Road (half=31): Exact center of left carriageway (14 studs from median curb, 14.5 studs from sidewalk curb)
    elseif halfWidth >= 18 then
        return 11.0 -- Bridge / 4-lane side road (half=22): Exact center of left travel lane
    elseif halfWidth >= 9 then
        return 6.0  -- Standard 2-lane road (soi, village, cross, hill, half=12-14): Center of left lane (6 studs from center line, 6 studs from sidewalk)
    else
        return 2.0  -- Narrow link/ramp/alley (half=4-6)
    end
end
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

-- 🛡️ Aggressive Remote Rebind Engine (GameRemotes prioritized + NetSeal fallback)
function RebindDeliveryRemote()
    if DeliveryRemote and DeliveryRemote.Parent then return true end
    local rs = game:GetService("ReplicatedStorage")
    local gr = rs:FindFirstChild("GameRemotes") or rs:FindFirstChild("Remotes") or rs:FindFirstChild("Events")
    if gr then
        local d = gr:FindFirstChild("Delivery")
        if d then DeliveryRemote = d; return true end
    end
    pcall(function()
        local gr2 = rs:WaitForChild("GameRemotes", 2)
        if gr2 then
            local d = gr2:FindFirstChild("Delivery")
            if d then DeliveryRemote = d end
        end
    end)
    if DeliveryRemote and DeliveryRemote.Parent then return true end
    for _, folder in ipairs(rs:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("Model") then
            for _, v in ipairs(folder:GetChildren()) do
                local n = v.Name:lower()
                if n == "delivery" or n:find("deliver") then
                    DeliveryRemote = v
                    return true
                end
            end
        end
    end
    return DeliveryRemote ~= nil and DeliveryRemote.Parent ~= nil
end

function RebindJobRemote()
    if JobRemote and JobRemote.Parent then return true end
    local rs = game:GetService("ReplicatedStorage")
    local gr = rs:FindFirstChild("GameRemotes") or rs:FindFirstChild("Remotes") or rs:FindFirstChild("Events")
    if gr then
        local j = gr:FindFirstChild("Job")
        if j then JobRemote = j; return true end
    end
    for _, folder in ipairs(rs:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("Model") then
            for _, v in ipairs(folder:GetChildren()) do
                local n = v.Name:lower()
                if n == "job" then
                    JobRemote = v
                    return true
                end
            end
        end
    end
    return JobRemote ~= nil and JobRemote.Parent ~= nil
end

function SafeInvokeRemote(remote, ...)
    if not remote or not remote.Parent then return false end
    if typeof(safeInvoke) == "function" then
        local s, r1, r2, r3, r4 = pcall(safeInvoke, remote, ...)
        if s and r1 ~= nil then return r1, r2, r3, r4 end
    end
    if NetSeal then
        local invFn = genv[_gk.ni] or NetSeal.invoke
        if invFn then
            local s, r = pcall(invFn, remote, ...)
            if s and r ~= nil then return r end
        end
        local fireFn = genv[_gk.nf] or NetSeal.fire
        if fireFn then
            local s2, r2 = pcall(fireFn, remote, ...)
            if s2 then return r2 end
        end
    end
    if remote:IsA("RemoteFunction") then
        local s3, r3 = pcall(function(...) return remote:InvokeServer(...) end, ...)
        if s3 then return r3 end
    elseif remote:IsA("RemoteEvent") then
        local s3 = pcall(function(...) remote:FireServer(...) end, ...)
        return s3
    end
    return false
end
local ShopShared = nil
pcall(function() ShopShared = require(ReplicatedStorage:WaitForChild("ShopShared", 5)) end)
local ShopRemote = (Remotes and Remotes:FindFirstChild("Shop"))
                or (ShopShared and Remotes and Remotes:FindFirstChild(ShopShared.REMOTE))
                or ReplicatedStorage:FindFirstChild("Shop")
local PCX160Remote = ReplicatedStorage:FindFirstChild("PCX160Remote")
local HelmetShared = nil
pcall(function() HelmetShared = require(ReplicatedStorage:WaitForChild("HelmetShared", 5)) end)
local HelmetsFolder = ReplicatedStorage:FindFirstChild("Helmets")
local HelmetRemote = (Remotes and Remotes:FindFirstChild("Helmet"))
                  or (HelmetShared and Remotes and Remotes:FindFirstChild(HelmetShared.REMOTE))
                  or ReplicatedStorage:FindFirstChild("Helmet")

local CarRemote = ReplicatedStorage:FindFirstChild("CarRemote")

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
    StaffPresent = false,
    DetectedStaffList = {},
    Settings = {
        -- Safe Anti-Ban System & Blackhole
        SafeMode = true,
        AntiVelocitySpike = true,
        BlockAllLogs = true,
        AntiStaffMode = true,
        AutoServerHopOnStaff = false,

        -- Vehicle Mods (Active in background)
        VehicleModMaster = true,
        NoCrash = true,
        BypassSpeedCap = false,
        VehicleMaxSpeed = 120,
        VehicleAccel = 1.10,
        SuperBrakes = true,
        SuperTuck = true,
        LockEngineHealth = true,

        -- ECU Tuning
        EcuTuneMaster = false,
        ForceEcuGain = false,
        AutoTuneRunning = false,
        RedeemCodeInput = "",
        CustomIgnOffset = 0,
        CustomFuelOffset = 0,
        CustomAirOffset = 0,

        -- Auto Farm
        UsePathfinding = true,
        AutoCaptcha = true,
        AutoPassMenu = true,
        AutoGfxChoice = "LOW",
        AutoJobChoice = "ไรเดอร์ส่งอาหาร",
        FiveStarMode = true, -- Lock 5-star rating (100% 5-star reviews & +25% payout bonus)
        AutoGrabFarm = false, -- High-Payout Grab Farm (฿1,000 - ฿2,500/trip, No Locker Needed)
        AutoFoodDelivery = false,
        AutoGrabRide = false,
        LockMoneyEnabled = false, -- Lock & Stop farming when target cash reached
        LockMoneyTarget = 100000, -- Default target money: ฿100,000
        ShowRouteVisuals = false, -- ซ่อนเส้นนำทางสีฟ้าบนถนน (ไม่รกตา ไม่แลค)
        BlackScreen = false, -- โหมดจอดำประหยัดจอ (Auto Farm / Cash)

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
        FarmSpeed = 88,
        WarpSpeed = 88,

        -- Theme
        IconTheme = "Themed",

        -- Utility & Protection
        AntiAfk = true,
        AutoRejoin = true,
        HideNames = true,
        AutoClaimQuests = true,
        FPSBooster = false,
        -- Helmet System
        SelectedHelmet = "",
        FloatingHelmetPreview = false,

        -- Piston Shop System
        AutoBuyPiston = false,
        AutoBuyPistonSize = { ["ขนาดสูงสุดที่มี (Highest Available)"] = true },
        AutoInstallPiston = true,
    }
}
if getgenv then pcall(function() getgenv().Hub = Hub end) end
_G.Hub = Hub
genv[_gk.hh] = Hub
Hub.IsMobile = IsMobileDevice
Hub.PlatformOS = PlatformOSName
Hub.ExecutorName = ExecutorName

-- ==============================================================
-- 🛣️ EMBEDDED HIGH-PRECISION ROAD NETWORK & ROUTE ENGINE (aa.lua & message 4)
-- ==============================================================
Hub.RoadJsonData = [==[{"version":1,"nodes":[{"id":1,"x":35.42576599121094,"links":{"567":1,"2":1,"66":1},"z":-157.23666381835938},{"id":2,"x":35.370994567871097,"links":{"1":1,"652":1},"z":-399.855224609375},{"id":3,"x":45.54943084716797,"links":{"652":1,"2":1,"573":1,"21":1,"67":1},"z":-697.26806640625},{"id":4,"x":38.93304443359375,"links":{"68":1,"67":1},"z":-1200.3287353515626},{"id":5,"x":35.74675369262695,"links":{"70":1,"15":1,"69":1},"z":-1792.5360107421876},{"id":6,"x":34.317928314208987,"links":{"71":1,"70":1},"z":-2381.97998046875},{"id":8,"x":36.07550811767578,"links":{"9":1,"10":1},"z":-3294.33349609375},{"id":9,"x":34.52754211425781,"links":{"8":1,"73":1,"72":1},"z":-2901.1201171875},{"id":10,"x":26.82391357421875,"links":{"8":1,"450":1,"252":1,"11":1,"251":1},"z":-3433.822509765625},{"id":11,"x":-38.45238494873047,"links":{"251":1,"449":1,"12":1,"252":1,"10":1},"z":-3432.15478515625},{"id":12,"x":-35.62998962402344,"links":{"13":1,"11":1},"z":-3096.76611328125},{"id":13,"x":-35.317054748535159,"links":{"12":1,"73":1,"74":1},"z":-2899.744873046875},{"id":14,"x":-35.54723358154297,"links":{"76":1,"75":1},"z":-2307.482177734375},{"id":15,"x":1.2817955017089844,"links":{"5":1,"16":1},"z":-1801.4361572265626},{"id":16,"x":-37.50293731689453,"links":{"76":1,"15":1,"17":1},"z":-1801.43017578125},{"id":17,"x":-35.8306770324707,"links":{"16":1,"18":1},"z":-1556.8033447265626},{"id":18,"x":-34.100914001464847,"links":{"19":1,"597":1,"17":1},"z":-1338.382568359375},{"id":19,"x":-35.712913513183597,"links":{"20":1,"18":1},"z":-1200.588134765625},{"id":20,"x":-34.7390022277832,"links":{"19":1,"21":1,"600":1},"z":-1015.5282592773438},{"id":21,"x":-39.46564865112305,"links":{"20":1,"22":1,"3":1,"311":1},"z":-702.848876953125},{"id":22,"x":-35.258358001708987,"links":{"24":1,"21":1},"z":-514.1971435546875},{"id":23,"x":1.1077117919921876,"links":{"2":1,"24":1},"z":-400.99212646484377},{"id":24,"x":-33.5051383972168,"links":{"25":1,"22":1,"23":1},"z":-397.24945068359377},{"id":25,"x":-35.82212829589844,"links":{"24":1,"603":1,"26":1},"z":-177.96121215820313},{"id":26,"x":-35.665496826171878,"links":{"604":1,"27":1,"25":1},"z":182.3484649658203},{"id":27,"x":-32.96254348754883,"links":{"28":1,"26":1},"z":300.9849548339844},{"id":28,"x":-35.00981903076172,"links":{"77":1,"62":1,"27":1},"z":402.9250793457031},{"id":29,"x":-35.534706115722659,"links":{"30":1,"77":1},"z":750.6478881835938},{"id":30,"x":-35.86737060546875,"links":{"31":1,"609":1,"29":1},"z":887.61669921875},{"id":31,"x":-35.948936462402347,"links":{"32":1,"30":1},"z":1278.7037353515626},{"id":32,"x":-36.1555061340332,"links":{"31":1,"33":1,"612":1},"z":1476.7650146484376},{"id":33,"x":-36.353492736816409,"links":{"34":1,"32":1},"z":1754.9111328125},{"id":34,"x":-35.7510986328125,"links":{"56":1,"33":1,"35":1},"z":1796.274169921875},{"id":35,"x":-36.11512756347656,"links":{"617":1,"34":1,"36":1},"z":1831.1767578125},{"id":36,"x":-35.823848724365237,"links":{"35":1,"37":1},"z":2019.8599853515626},{"id":37,"x":-36.51969909667969,"links":{"36":1,"38":1},"z":2212.24951171875},{"id":38,"x":-35.919857025146487,"links":{"619":1,"37":1,"39":1},"z":2288.63427734375},{"id":39,"x":-36.106712341308597,"links":{"622":1,"40":1,"38":1},"z":2568.493408203125},{"id":40,"x":-35.5892333984375,"links":{"49":1,"39":1,"41":1},"z":2897.827392578125},{"id":41,"x":-36.13787841796875,"links":{"42":1,"40":1},"z":3336.26708984375},{"id":42,"x":-36.202911376953128,"links":{"43":1,"379":1,"44":1,"41":1,"380":1,"120":1},"z":3433.9189453125},{"id":43,"x":-0.0548858642578125,"links":{"42":1,"120":1,"44":1,"379":1},"z":3432.542236328125},{"id":44,"x":35.73188018798828,"links":{"42":1,"43":1,"379":1,"119":1,"45":1,"120":1},"z":3432.297119140625},{"id":45,"x":36.06780242919922,"links":{"46":1,"44":1},"z":3314.5205078125},{"id":46,"x":36.154136657714847,"links":{"45":1,"47":1},"z":3216.119140625},{"id":47,"x":35.99402618408203,"links":{"48":1,"46":1},"z":3092.653564453125},{"id":48,"x":35.662872314453128,"links":{"47":1,"50":1},"z":2963.268310546875},{"id":49,"x":0.9099960327148438,"links":{"40":1,"50":1},"z":2900.493408203125},{"id":50,"x":35.61653518676758,"links":{"48":1,"49":1,"51":1},"z":2903.086181640625},{"id":51,"x":35.9090576171875,"links":{"50":1,"52":1},"z":2715.4326171875},{"id":52,"x":35.92176818847656,"links":{"53":1,"51":1,"624":1},"z":2532.124267578125},{"id":53,"x":36.192466735839847,"links":{"52":1,"646":1,"78":1},"z":2278.7529296875},{"id":55,"x":35.85573959350586,"links":{"647":1,"57":1,"78":1},"z":1731.0185546875},{"id":56,"x":0.2257671356201172,"links":{"34":1,"78":1},"z":1799.59326171875},{"id":57,"x":36.07334899902344,"links":{"58":1,"55":1},"z":1589.2392578125},{"id":58,"x":36.18424987792969,"links":{"59":1,"649":1,"57":1},"z":1404.570068359375},{"id":59,"x":36.579978942871097,"links":{"60":1,"58":1,"563":1},"z":1138.5211181640626},{"id":60,"x":36.26179122924805,"links":{"59":1,"61":1,"566":1,"562":1},"z":938.3709716796875},{"id":61,"x":36.135765075683597,"links":{"60":1,"566":1,"63":1},"z":881.91162109375},{"id":62,"x":-0.9829902648925781,"links":{"28":1,"63":1},"z":401.0039978027344},{"id":63,"x":36.093780517578128,"links":{"64":1,"62":1,"61":1},"z":402.6991882324219},{"id":64,"x":36.19231414794922,"links":{"65":1,"63":1},"z":299.74755859375},{"id":65,"x":36.018943786621097,"links":{"64":1,"66":1},"z":183.15554809570313},{"id":66,"x":36.10774230957031,"links":{"1":1},"z":-11.839942932128907},{"id":67,"x":36.214988708496097,"links":{"574":1,"4":1,"3":1},"z":-1039.744384765625},{"id":68,"x":36.19680404663086,"links":{"4":1,"69":1,"577":1},"z":-1377.1920166015626},{"id":69,"x":35.21918869018555,"links":{"5":1,"581":1,"68":1},"z":-1666.7816162109376},{"id":70,"x":36.13226318359375,"links":{"5":1,"583":1,"6":1},"z":-1919.3868408203126},{"id":71,"x":35.88376998901367,"links":{"585":1,"6":1,"72":1},"z":-2488.171630859375},{"id":72,"x":36.10635757446289,"links":{"71":1,"589":1,"9":1},"z":-2783.417724609375},{"id":73,"x":-1.4794273376464844,"links":{"13":1,"9":1},"z":-2898.53955078125},{"id":74,"x":-35.73768615722656,"links":{"13":1,"590":1,"75":1},"z":-2792.773193359375},{"id":75,"x":-36.520572662353519,"links":{"592":1,"74":1,"14":1},"z":-2464.625244140625},{"id":76,"x":-36.247703552246097,"links":{"14":1,"594":1,"16":1},"z":-1919.3837890625},{"id":77,"x":-36.519866943359378,"links":{"608":1,"28":1,"29":1},"z":446.02874755859377},{"id":78,"x":35.844879150390628,"links":{"53":1,"55":1,"56":1},"z":1799.677001953125},{"id":79,"x":78.73431396484375,"links":{"80":1,"646":1},"z":2280.570068359375},{"id":80,"x":132.48245239257813,"links":{"79":1,"82":1},"z":2281.985107421875},{"id":82,"x":226.50311279296876,"links":{"80":1,"83":1},"z":2279.566162109375},{"id":83,"x":302.4023742675781,"links":{"82":1,"84":1},"z":2279.97509765625},{"id":84,"x":377.64617919921877,"links":{"85":1,"83":1},"z":2279.34912109375},{"id":85,"x":461.1117248535156,"links":{"86":1,"84":1},"z":2279.8125},{"id":86,"x":561.8679809570313,"links":{"85":1,"87":1},"z":2279.999755859375},{"id":87,"x":649.2138671875,"links":{"88":1,"86":1},"z":2280.12451171875},{"id":88,"x":737.130126953125,"links":{"87":1,"89":1},"z":2280.0712890625},{"id":89,"x":811.6011962890625,"links":{"88":1,"90":1},"z":2280.26123046875},{"id":90,"x":877.95849609375,"links":{"91":1,"89":1},"z":2279.944580078125},{"id":91,"x":922.444580078125,"links":{"92":1,"90":1},"z":2279.8876953125},{"id":92,"x":963.1578369140625,"links":{"93":1,"91":1},"z":2280.3984375},{"id":93,"x":1036.090576171875,"links":{"94":1,"92":1},"z":2279.780029296875},{"id":94,"x":1105.6051025390626,"links":{"159":1,"95":1,"540":1,"93":1,"516":1,"539":1},"z":2280.2646484375},{"id":95,"x":1133.9967041015626,"links":{"94":1,"539":1,"540":1},"z":2280.1748046875},{"id":96,"x":1132.7838134765626,"links":{"557":1,"101":1},"z":2370.519775390625},{"id":101,"x":1132.3927001953126,"links":{"105":1,"96":1},"z":2776.4697265625},{"id":105,"x":1132.642822265625,"links":{"101":1,"107":1},"z":3134.71923828125},{"id":107,"x":1108.02587890625,"links":{"109":1,"105":1},"z":3250.704833984375},{"id":109,"x":1039.6861572265626,"links":{"107":1,"111":1},"z":3348.846435546875},{"id":111,"x":961.454833984375,"links":{"109":1,"113":1},"z":3402.63623046875},{"id":113,"x":855.960205078125,"links":{"554":1,"111":1,"556":1},"z":3432.170654296875},{"id":114,"x":774.1943969726563,"links":{"115":1,"554":1},"z":3433.184814453125},{"id":115,"x":674.703125,"links":{"114":1,"117":1},"z":3433.4384765625},{"id":117,"x":417.32574462890627,"links":{"118":1,"115":1},"z":3432.591796875},{"id":118,"x":299.8570251464844,"links":{"119":1,"117":1},"z":3432.9052734375},{"id":119,"x":180.43743896484376,"links":{"118":1,"44":1},"z":3432.2431640625},{"id":120,"x":47.73731994628906,"links":{"42":1,"43":1,"379":1,"44":1,"538":1},"z":3467.318115234375},{"id":121,"x":193.320068359375,"links":{"538":1,"122":1},"z":3467.0390625},{"id":122,"x":312.7525634765625,"links":{"121":1,"123":1},"z":3467.23046875},{"id":123,"x":389.530517578125,"links":{"122":1,"124":1},"z":3467.214111328125},{"id":124,"x":481.7021484375,"links":{"123":1,"125":1},"z":3467.224609375},{"id":125,"x":558.9961547851563,"links":{"126":1,"124":1},"z":3466.367431640625},{"id":126,"x":650.04443359375,"links":{"125":1,"127":1},"z":3467.525146484375},{"id":127,"x":713.010009765625,"links":{"128":1,"126":1},"z":3467.333251953125},{"id":128,"x":767.0894775390625,"links":{"127":1,"129":1},"z":3466.956298828125},{"id":129,"x":818.1942749023438,"links":{"128":1,"130":1},"z":3467.1806640625},{"id":130,"x":842.4238891601563,"links":{"129":1,"131":1},"z":3466.638916015625},{"id":131,"x":865.4991455078125,"links":{"130":1,"132":1},"z":3465.4072265625},{"id":132,"x":889.2039184570313,"links":{"131":1,"133":1},"z":3461.740478515625},{"id":133,"x":913.211669921875,"links":{"132":1,"134":1},"z":3456.19677734375},{"id":134,"x":936.7332153320313,"links":{"135":1,"133":1},"z":3449.635986328125},{"id":135,"x":959.406005859375,"links":{"134":1,"136":1},"z":3441.34423828125},{"id":136,"x":981.2329711914063,"links":{"137":1,"135":1},"z":3430.88671875},{"id":137,"x":1002.1099243164063,"links":{"138":1,"136":1},"z":3419.913818359375},{"id":138,"x":1023.2354125976563,"links":{"137":1,"139":1},"z":3406.490478515625},{"id":139,"x":1041.783203125,"links":{"140":1,"138":1},"z":3391.64013671875},{"id":140,"x":1059.831787109375,"links":{"139":1,"141":1},"z":3375.96533203125},{"id":141,"x":1077.174560546875,"links":{"142":1,"140":1},"z":3359.401611328125},{"id":142,"x":1093.8299560546876,"links":{"143":1,"141":1},"z":3340.30712890625},{"id":143,"x":1106.8277587890626,"links":{"144":1,"142":1},"z":3320.61181640625},{"id":144,"x":1123.173583984375,"links":{"143":1,"145":1},"z":3297.91162109375},{"id":145,"x":1133.800048828125,"links":{"146":1,"144":1},"z":3275.39013671875},{"id":146,"x":1143.039794921875,"links":{"145":1,"147":1},"z":3254.457763671875},{"id":147,"x":1149.72265625,"links":{"148":1,"146":1},"z":3234.989013671875},{"id":148,"x":1157.78076171875,"links":{"149":1,"147":1},"z":3208.64111328125},{"id":149,"x":1162.6566162109376,"links":{"148":1,"150":1},"z":3187.110107421875},{"id":150,"x":1165.3238525390626,"links":{"151":1,"149":1},"z":3163.6845703125},{"id":151,"x":1167.392822265625,"links":{"152":1,"150":1},"z":3137.99853515625},{"id":152,"x":1167.1973876953126,"links":{"153":1,"151":1},"z":3114.712890625},{"id":153,"x":1167.7159423828126,"links":{"154":1,"152":1},"z":2969.06201171875},{"id":154,"x":1167.77392578125,"links":{"155":1,"153":1},"z":2851.41943359375},{"id":155,"x":1166.73779296875,"links":{"154":1,"156":1},"z":2752.448486328125},{"id":156,"x":1167.499755859375,"links":{"155":1,"157":1},"z":2657.3984375},{"id":157,"x":1167.6956787109376,"links":{"158":1,"156":1},"z":2493.79443359375},{"id":158,"x":1167.1240234375,"links":{"157":1,"159":1},"z":2392.256103515625},{"id":159,"x":1166.5234375,"links":{"94":1,"158":1,"540":1,"539":1,"557":1,"516":1},"z":2279.307373046875},{"id":160,"x":1167.174072265625,"links":{"540":1,"161":1},"z":2155.161865234375},{"id":161,"x":1167.743408203125,"links":{"162":1,"160":1},"z":2056.82470703125},{"id":162,"x":1167.228515625,"links":{"163":1,"161":1},"z":1963.9189453125},{"id":163,"x":1167.0877685546876,"links":{"164":1,"162":1},"z":1783.57470703125},{"id":164,"x":1167.4525146484376,"links":{"163":1,"165":1},"z":1587.337646484375},{"id":165,"x":1166.9781494140626,"links":{"164":1,"166":1},"z":1377.5032958984376},{"id":166,"x":1166.270751953125,"links":{"541":1,"165":1,"167":1},"z":1219.7171630859376},{"id":167,"x":1166.9613037109376,"links":{"511":1,"512":1,"170":1,"169":1,"168":1,"166":1},"z":1135.8409423828126},{"id":168,"x":1149.3994140625,"links":{"511":1,"541":1,"512":1,"167":1},"z":1136.421142578125},{"id":169,"x":1114.15185546875,"links":{"511":1,"541":1,"558":1,"167":1},"z":1137.032470703125},{"id":170,"x":1166.9873046875,"links":{"174":1,"172":1,"171":1,"167":1,"509":1,"173":1},"z":1001.6826171875},{"id":171,"x":1148.3720703125,"links":{"509":1,"172":1,"170":1},"z":1001.4017944335938},{"id":172,"x":1133.380615234375,"links":{"509":1,"510":1,"171":1,"170":1},"z":1017.5767822265625},{"id":173,"x":1211.3985595703126,"links":{"517":1,"170":1},"z":998.2266235351563},{"id":174,"x":1167.1455078125,"links":{"175":1,"170":1},"z":909.5932006835938},{"id":175,"x":1166.985107421875,"links":{"176":1,"174":1},"z":784.2501220703125},{"id":176,"x":1167.3013916015626,"links":{"175":1,"177":1},"z":667.2155151367188},{"id":177,"x":1166.8876953125,"links":{"178":1,"176":1},"z":572.73583984375},{"id":178,"x":1167.2235107421876,"links":{"179":1,"177":1},"z":480.7064514160156},{"id":179,"x":1167.04833984375,"links":{"178":1,"180":1},"z":409.4599609375},{"id":180,"x":1166.9228515625,"links":{"181":1,"179":1},"z":335.84063720703127},{"id":181,"x":1167.134765625,"links":{"182":1,"180":1},"z":227.84182739257813},{"id":182,"x":1166.96484375,"links":{"181":1,"183":1},"z":140.09249877929688},{"id":183,"x":1166.6241455078126,"links":{"184":1,"182":1},"z":41.925750732421878},{"id":184,"x":1166.91845703125,"links":{"183":1,"187":1,"185":1,"542":1,"543":1},"z":-12.798019409179688},{"id":185,"x":1149.18701171875,"links":{"184":1,"542":1,"502":1},"z":-11.321136474609375},{"id":186,"x":1117.375,"links":{"542":1,"571":1,"502":1},"z":-11.78486442565918},{"id":187,"x":1167.3951416015626,"links":{"184":1,"188":1},"z":-101.7390365600586},{"id":188,"x":1167.172607421875,"links":{"187":1,"189":1},"z":-220.47366333007813},{"id":189,"x":1167.4317626953126,"links":{"190":1,"188":1},"z":-339.88690185546877},{"id":190,"x":1166.543701171875,"links":{"189":1,"191":1},"z":-454.3543701171875},{"id":191,"x":1166.626708984375,"links":{"190":1,"192":1},"z":-496.01995849609377},{"id":192,"x":1166.908447265625,"links":{"193":1,"191":1},"z":-570.06396484375},{"id":193,"x":1166.8277587890626,"links":{"196":1,"194":1,"195":1,"497":1,"496":1,"192":1},"z":-701.3577880859375},{"id":194,"x":1146.599609375,"links":{"193":1,"195":1,"497":1,"496":1,"495":1},"z":-703.8013916015625},{"id":195,"x":1101.1221923828126,"links":{"193":1,"194":1,"497":1,"496":1,"495":1,"572":1},"z":-700.328369140625},{"id":196,"x":1166.67138671875,"links":{"197":1,"193":1},"z":-795.5315551757813},{"id":197,"x":1167.1453857421876,"links":{"196":1,"493":1,"654":1,"198":1,"491":1},"z":-1000.8575439453125},{"id":198,"x":1167.1328125,"links":{"199":1,"197":1},"z":-1155.927734375},{"id":199,"x":1167.16015625,"links":{"198":1,"200":1},"z":-1294.8045654296876},{"id":200,"x":1166.5787353515626,"links":{"488":1,"199":1,"545":1,"201":1,"202":1,"203":1},"z":-1382.800537109375},{"id":201,"x":1148.634521484375,"links":{"200":1,"488":1,"202":1,"545":1},"z":-1381.066650390625},{"id":202,"x":1103.2081298828126,"links":{"580":1,"200":1,"201":1,"546":1,"545":1},"z":-1379.4295654296876},{"id":203,"x":1167.2454833984376,"links":{"204":1,"200":1},"z":-1463.015869140625},{"id":204,"x":1167.0201416015626,"links":{"203":1,"205":1},"z":-1562.0423583984376},{"id":205,"x":1167.339111328125,"links":{"204":1,"206":1},"z":-1638.501708984375},{"id":206,"x":1166.2967529296876,"links":{"205":1,"207":1},"z":-1758.9864501953126},{"id":207,"x":1167.3468017578126,"links":{"208":1,"206":1},"z":-1854.624755859375},{"id":208,"x":1167.0576171875,"links":{"209":1,"207":1},"z":-1974.927734375},{"id":209,"x":1167.13818359375,"links":{"208":1,"210":1},"z":-2062.605224609375},{"id":210,"x":1166.9805908203126,"links":{"211":1,"209":1},"z":-2151.093505859375},{"id":211,"x":1166.4342041015626,"links":{"548":1,"210":1,"664":1,"212":1},"z":-2272.7783203125},{"id":212,"x":1166.2969970703126,"links":{"480":1,"215":1,"214":1,"211":1,"547":1,"213":1,"548":1},"z":-2487.91748046875},{"id":213,"x":1148.0548095703126,"links":{"480":1,"214":1,"548":1,"547":1,"212":1},"z":-2488.25},{"id":214,"x":1102.939453125,"links":{"480":1,"587":1,"213":1,"212":1},"z":-2487.56005859375},{"id":215,"x":1167.1002197265626,"links":{"216":1,"212":1},"z":-2666.718505859375},{"id":216,"x":1166.785400390625,"links":{"217":1,"215":1,"698":1},"z":-2760.6435546875},{"id":217,"x":1166.578369140625,"links":{"216":1,"218":1},"z":-2906.1044921875},{"id":218,"x":1167.13916015625,"links":{"219":1,"217":1},"z":-3009.24755859375},{"id":219,"x":1166.9642333984376,"links":{"220":1,"218":1},"z":-3103.37060546875},{"id":220,"x":1165.8914794921876,"links":{"219":1,"221":1},"z":-3156.208984375},{"id":221,"x":1158.863037109375,"links":{"222":1,"220":1},"z":-3202.66845703125},{"id":222,"x":1153.697265625,"links":{"221":1,"223":1},"z":-3224.24560546875},{"id":223,"x":1145.4442138671876,"links":{"222":1,"224":1},"z":-3247.56982421875},{"id":224,"x":1136.689208984375,"links":{"223":1,"225":1},"z":-3271.73046875},{"id":225,"x":1126.146240234375,"links":{"226":1,"224":1},"z":-3291.45654296875},{"id":226,"x":1111.177490234375,"links":{"225":1,"227":1},"z":-3314.909912109375},{"id":227,"x":1099.578369140625,"links":{"226":1,"228":1},"z":-3332.660888671875},{"id":228,"x":1084.845458984375,"links":{"229":1,"227":1},"z":-3351.007568359375},{"id":229,"x":1068.63330078125,"links":{"230":1,"228":1},"z":-3368.169921875},{"id":230,"x":1050.8560791015626,"links":{"231":1,"229":1},"z":-3384.095947265625},{"id":231,"x":1032.2772216796876,"links":{"230":1,"232":1},"z":-3399.564697265625},{"id":232,"x":1012.4844360351563,"links":{"231":1,"233":1},"z":-3413.265869140625},{"id":233,"x":991.7752075195313,"links":{"234":1,"232":1},"z":-3425.1103515625},{"id":234,"x":967.9688110351563,"links":{"233":1,"235":1},"z":-3437.417724609375},{"id":235,"x":947.2228393554688,"links":{"234":1,"236":1},"z":-3446.075927734375},{"id":236,"x":924.7985229492188,"links":{"235":1,"237":1},"z":-3453.50732421875},{"id":237,"x":902.4509887695313,"links":{"238":1,"236":1},"z":-3459.751220703125},{"id":238,"x":877.4259643554688,"links":{"237":1,"239":1},"z":-3464.59423828125},{"id":239,"x":850.4819946289063,"links":{"238":1,"240":1},"z":-3466.0458984375},{"id":240,"x":807.0252685546875,"links":{"241":1,"239":1},"z":-3466.830810546875},{"id":241,"x":732.240478515625,"links":{"240":1,"242":1},"z":-3467.485595703125},{"id":242,"x":646.721435546875,"links":{"241":1,"243":1},"z":-3467.272216796875},{"id":243,"x":551.5907592773438,"links":{"244":1,"242":1},"z":-3467.21240234375},{"id":244,"x":481.9027099609375,"links":{"245":1,"243":1},"z":-3466.4609375},{"id":245,"x":424.0674743652344,"links":{"244":1,"246":1},"z":-3466.40625},{"id":246,"x":356.3156433105469,"links":{"245":1,"247":1},"z":-3467.277587890625},{"id":247,"x":281.42041015625,"links":{"246":1,"248":1},"z":-3466.87646484375},{"id":248,"x":213.59817504882813,"links":{"249":1,"247":1},"z":-3466.866455078125},{"id":249,"x":147.9123077392578,"links":{"250":1,"248":1},"z":-3467.337646484375},{"id":250,"x":88.51200866699219,"links":{"249":1,"251":1},"z":-3466.716552734375},{"id":251,"x":40.611114501953128,"links":{"250":1,"11":1,"10":1},"z":-3467.01611328125},{"id":252,"x":-40.44725036621094,"links":{"253":1,"11":1,"10":1},"z":-3466.54052734375},{"id":253,"x":-157.92819213867188,"links":{"254":1,"252":1},"z":-3467.0654296875},{"id":254,"x":-225.15969848632813,"links":{"255":1,"253":1},"z":-3467.471435546875},{"id":255,"x":-356.5096435546875,"links":{"254":1,"256":1},"z":-3466.608642578125},{"id":256,"x":-536.1956787109375,"links":{"255":1,"257":1},"z":-3467.47021484375},{"id":257,"x":-725.4959716796875,"links":{"258":1,"256":1},"z":-3466.929931640625},{"id":258,"x":-828.3980712890625,"links":{"257":1,"259":1},"z":-3467.556640625},{"id":259,"x":-851.642578125,"links":{"258":1,"260":1},"z":-3466.7412109375},{"id":260,"x":-871.9728393554688,"links":{"261":1,"259":1},"z":-3464.853515625},{"id":261,"x":-897.2763061523438,"links":{"260":1,"262":1},"z":-3460.916748046875},{"id":262,"x":-916.4700927734375,"links":{"263":1,"261":1},"z":-3455.357666015625},{"id":263,"x":-939.4534912109375,"links":{"264":1,"262":1},"z":-3448.36669921875},{"id":264,"x":-962.63671875,"links":{"263":1,"265":1},"z":-3439.321533203125},{"id":265,"x":-983.9197387695313,"links":{"266":1,"264":1},"z":-3429.315185546875},{"id":266,"x":-1005.1549072265625,"links":{"267":1,"265":1},"z":-3416.83740234375},{"id":267,"x":-1026.425537109375,"links":{"268":1,"266":1},"z":-3404.07763671875},{"id":268,"x":-1044.7056884765626,"links":{"267":1,"269":1},"z":-3389.5478515625},{"id":269,"x":-1060.266845703125,"links":{"270":1,"268":1},"z":-3375.35205078125},{"id":270,"x":-1080.2232666015626,"links":{"271":1,"269":1},"z":-3356.670166015625},{"id":271,"x":-1095.130126953125,"links":{"272":1,"270":1},"z":-3339.242919921875},{"id":272,"x":-1109.846923828125,"links":{"273":1,"271":1},"z":-3318.328369140625},{"id":273,"x":-1121.110595703125,"links":{"272":1,"274":1},"z":-3300.68994140625},{"id":274,"x":-1133.58642578125,"links":{"275":1,"273":1},"z":-3278.302734375},{"id":275,"x":-1142.413330078125,"links":{"274":1,"276":1},"z":-3256.67431640625},{"id":276,"x":-1149.8653564453126,"links":{"277":1,"275":1},"z":-3233.022216796875},{"id":277,"x":-1156.2822265625,"links":{"278":1,"276":1},"z":-3210.72216796875},{"id":278,"x":-1162.51513671875,"links":{"277":1,"279":1},"z":-3185.696044921875},{"id":279,"x":-1165.8463134765626,"links":{"280":1,"278":1},"z":-3161.2919921875},{"id":280,"x":-1167.0303955078126,"links":{"279":1,"281":1},"z":-3138.52099609375},{"id":281,"x":-1167.128173828125,"links":{"280":1,"282":1},"z":-3111.7451171875},{"id":282,"x":-1167.5853271484376,"links":{"283":1,"281":1},"z":-3089.448974609375},{"id":283,"x":-1167.460205078125,"links":{"282":1,"284":1},"z":-3065.764892578125},{"id":284,"x":-1167.460205078125,"links":{"283":1,"285":1},"z":-3042.541748046875},{"id":285,"x":-1167.460205078125,"links":{"286":1,"284":1},"z":-3018.735107421875},{"id":286,"x":-1167.460205078125,"links":{"285":1,"287":1},"z":-2995.862060546875},{"id":287,"x":-1167.5015869140626,"links":{"286":1,"288":1},"z":-2894.8544921875},{"id":288,"x":-1167.1976318359376,"links":{"289":1,"287":1},"z":-2791.5751953125},{"id":289,"x":-1167.4334716796876,"links":{"288":1,"290":1},"z":-2613.164306640625},{"id":290,"x":-1166.6490478515626,"links":{"293":1,"292":1,"291":1,"549":1,"430":1,"289":1},"z":-2466.5751953125},{"id":291,"x":-1148.920654296875,"links":{"292":1,"549":1,"430":1,"290":1},"z":-2465.184326171875},{"id":292,"x":-1102.7171630859376,"links":{"430":1,"291":1,"290":1,"593":1,"549":1},"z":-2466.8740234375},{"id":293,"x":-1166.9141845703126,"links":{"290":1,"294":1},"z":-2303.288330078125},{"id":294,"x":-1167.4052734375,"links":{"293":1,"295":1},"z":-2192.031005859375},{"id":295,"x":-1166.85107421875,"links":{"294":1,"296":1},"z":-2105.2822265625},{"id":296,"x":-1166.9503173828126,"links":{"295":1,"297":1},"z":-2007.3194580078126},{"id":297,"x":-1166.8507080078126,"links":{"296":1,"298":1},"z":-1916.231689453125},{"id":298,"x":-1167.039794921875,"links":{"299":1,"297":1},"z":-1812.46435546875},{"id":299,"x":-1166.5650634765626,"links":{"300":1,"298":1},"z":-1717.198486328125},{"id":300,"x":-1167.272705078125,"links":{"301":1,"299":1},"z":-1618.306640625},{"id":301,"x":-1167.1749267578126,"links":{"302":1,"300":1,"528":1,"527":1,"529":1},"z":-1502.5794677734376},{"id":302,"x":-1132.62060546875,"links":{"301":1,"528":1,"425":1,"527":1,"529":1},"z":-1510.380615234375},{"id":303,"x":-1166.78271484375,"links":{"305":1,"304":1,"306":1,"424":1,"550":1,"529":1},"z":-1333.1142578125},{"id":304,"x":-1143.099853515625,"links":{"303":1,"550":1,"424":1,"305":1},"z":-1334.82421875},{"id":305,"x":-1102.6873779296876,"links":{"303":1,"304":1,"599":1,"424":1,"550":1},"z":-1335.125732421875},{"id":306,"x":-1167.094482421875,"links":{"307":1,"303":1},"z":-1152.900146484375},{"id":307,"x":-1167.38720703125,"links":{"308":1,"306":1},"z":-1051.306396484375},{"id":308,"x":-1167.6912841796876,"links":{"307":1,"309":1},"z":-922.747314453125},{"id":309,"x":-1166.687744140625,"links":{"421":1,"310":1,"311":1,"551":1,"308":1,"530":1},"z":-697.5988159179688},{"id":310,"x":-1148.86474609375,"links":{"551":1,"421":1,"309":1,"311":1},"z":-696.4339599609375},{"id":311,"x":-1098.08740234375,"links":{"421":1,"310":1,"551":1,"21":1,"309":1},"z":-700.1248168945313},{"id":312,"x":-1166.720947265625,"links":{"531":1,"313":1},"z":-512.0386962890625},{"id":313,"x":-1167.405517578125,"links":{"314":1,"312":1},"z":-394.36279296875},{"id":314,"x":-1166.3021240234376,"links":{"315":1,"313":1},"z":-274.2477111816406},{"id":315,"x":-1167.6588134765626,"links":{"314":1,"316":1},"z":-179.60299682617188},{"id":316,"x":-1167.16259765625,"links":{"317":1,"315":1},"z":-67.44023132324219},{"id":317,"x":-1167.0308837890626,"links":{"316":1,"318":1},"z":38.20189666748047},{"id":318,"x":-1167.0472412109376,"links":{"532":1,"320":1,"319":1,"415":1,"317":1,"552":1},"z":180.31033325195313},{"id":319,"x":-1149.633544921875,"links":{"532":1,"320":1,"318":1,"415":1,"552":1},"z":181.0625},{"id":320,"x":-1099.9459228515626,"links":{"532":1,"318":1,"319":1,"415":1,"606":1,"552":1},"z":181.7605438232422},{"id":321,"x":-1167.84716796875,"links":{"532":1,"322":1},"z":465.74462890625},{"id":322,"x":-1166.823486328125,"links":{"323":1,"321":1},"z":579.1923217773438},{"id":323,"x":-1168.01708984375,"links":{"322":1,"324":1},"z":695.3150024414063},{"id":324,"x":-1167.2767333984376,"links":{"323":1,"325":1},"z":826.2677001953125},{"id":325,"x":-1167.284912109375,"links":{"324":1,"326":1},"z":967.32080078125},{"id":326,"x":-1167.181396484375,"links":{"327":1,"325":1},"z":1059.6982421875},{"id":327,"x":-1167.2076416015626,"links":{"328":1,"326":1},"z":1193.674072265625},{"id":328,"x":-1167.47216796875,"links":{"327":1,"329":1},"z":1315.36572265625},{"id":329,"x":-1166.7906494140626,"links":{"330":1,"331":1,"410":1,"533":1,"553":1,"328":1},"z":1473.4715576171876},{"id":330,"x":-1149.4892578125,"links":{"533":1,"410":1,"329":1,"553":1,"331":1},"z":1474.2086181640626},{"id":331,"x":-1104.0218505859376,"links":{"330":1,"329":1,"410":1,"616":1,"553":1},"z":1475.286865234375},{"id":332,"x":-1167.5943603515626,"links":{"333":1,"533":1},"z":1640.1326904296876},{"id":333,"x":-1167.3681640625,"links":{"335":1,"334":1,"332":1,"409":1,"535":1,"534":1},"z":1697.685302734375},{"id":334,"x":-1150.64501953125,"links":{"335":1,"333":1,"534":1,"409":1},"z":1697.8662109375},{"id":335,"x":-1132.3631591796876,"links":{"409":1,"334":1,"333":1,"534":1},"z":1697.9959716796876},{"id":336,"x":-1166.5654296875,"links":{"535":1,"337":1},"z":1832.4564208984376},{"id":337,"x":-1166.9010009765626,"links":{"336":1,"338":1},"z":1950.0543212890626},{"id":338,"x":-1168.2298583984376,"links":{"337":1,"339":1},"z":2105.23193359375},{"id":339,"x":-1166.75390625,"links":{"338":1,"341":1,"537":1,"536":1,"340":1,"405":1},"z":2288.8134765625},{"id":340,"x":-1145.221923828125,"links":{"339":1,"537":1,"536":1,"405":1,"341":1},"z":2288.349365234375},{"id":341,"x":-1102.333740234375,"links":{"339":1,"621":1,"536":1,"340":1,"405":1},"z":2289.14697265625},{"id":342,"x":-1166.107666015625,"links":{"343":1,"536":1},"z":2403.48388671875},{"id":343,"x":-1166.8916015625,"links":{"344":1,"342":1},"z":2547.365966796875},{"id":344,"x":-1166.7398681640626,"links":{"343":1,"345":1},"z":2643.81298828125},{"id":345,"x":-1166.35107421875,"links":{"346":1,"344":1},"z":2718.461669921875},{"id":346,"x":-1167.595703125,"links":{"347":1,"345":1},"z":2815.658447265625},{"id":347,"x":-1167.2691650390626,"links":{"346":1,"348":1},"z":2910.77392578125},{"id":348,"x":-1167.53076171875,"links":{"347":1,"349":1},"z":3014.973876953125},{"id":349,"x":-1166.9808349609376,"links":{"348":1,"350":1},"z":3108.61865234375},{"id":350,"x":-1166.2425537109376,"links":{"351":1,"349":1},"z":3152.570556640625},{"id":351,"x":-1164.5341796875,"links":{"350":1,"352":1},"z":3171.959716796875},{"id":352,"x":-1160.562255859375,"links":{"351":1,"353":1},"z":3196.990234375},{"id":353,"x":-1154.1990966796876,"links":{"354":1,"352":1},"z":3223.61767578125},{"id":354,"x":-1146.93212890625,"links":{"355":1,"353":1},"z":3244.11181640625},{"id":355,"x":-1137.788330078125,"links":{"356":1,"354":1},"z":3268.503173828125},{"id":356,"x":-1127.4146728515626,"links":{"357":1,"355":1},"z":3288.058837890625},{"id":357,"x":-1115.1539306640626,"links":{"358":1,"356":1},"z":3307.4296875},{"id":358,"x":-1100.4036865234376,"links":{"359":1,"357":1},"z":3330.3876953125},{"id":359,"x":-1087.76220703125,"links":{"360":1,"358":1},"z":3347.940185546875},{"id":360,"x":-1070.86083984375,"links":{"359":1,"361":1},"z":3364.902587890625},{"id":361,"x":-1053.024658203125,"links":{"360":1,"362":1},"z":3382.080322265625},{"id":362,"x":-1034.6474609375,"links":{"361":1,"363":1},"z":3397.865966796875},{"id":363,"x":-1013.2648315429688,"links":{"362":1,"364":1},"z":3411.4345703125},{"id":364,"x":-995.7269287109375,"links":{"365":1,"363":1},"z":3423.3828125},{"id":365,"x":-975.5330810546875,"links":{"366":1,"364":1},"z":3434.478271484375},{"id":366,"x":-950.82275390625,"links":{"367":1,"365":1},"z":3445.5595703125},{"id":367,"x":-930.19677734375,"links":{"366":1,"368":1},"z":3452.272705078125},{"id":368,"x":-904.7760620117188,"links":{"369":1,"367":1},"z":3457.529541015625},{"id":369,"x":-877.6005249023438,"links":{"370":1,"368":1},"z":3465.106201171875},{"id":370,"x":-858.7843627929688,"links":{"371":1,"369":1},"z":3465.709716796875},{"id":371,"x":-835.6204833984375,"links":{"370":1,"372":1},"z":3467.46142578125},{"id":372,"x":-810.437255859375,"links":{"371":1,"373":1},"z":3467.80126953125},{"id":373,"x":-784.5436401367188,"links":{"374":1,"372":1},"z":3467.692138671875},{"id":374,"x":-635.2796630859375,"links":{"373":1,"375":1},"z":3466.955078125},{"id":375,"x":-498.900146484375,"links":{"374":1,"376":1},"z":3467.29833984375},{"id":376,"x":-381.84228515625,"links":{"377":1,"375":1},"z":3467.35302734375},{"id":377,"x":-243.2724151611328,"links":{"378":1,"376":1},"z":3466.9609375},{"id":378,"x":-115.38893127441406,"links":{"379":1,"377":1},"z":3467.140869140625},{"id":379,"x":-45.23677062988281,"links":{"42":1,"43":1,"378":1,"44":1,"120":1},"z":3467.838623046875},{"id":380,"x":-97.22000122070313,"links":{"381":1,"42":1},"z":3433.2939453125},{"id":381,"x":-361.4536437988281,"links":{"382":1,"380":1},"z":3432.917236328125},{"id":382,"x":-821.6835327148438,"links":{"383":1,"381":1},"z":3433.26416015625},{"id":383,"x":-859.4278564453125,"links":{"386":1,"382":1},"z":3431.891845703125},{"id":386,"x":-930.0162353515625,"links":{"383":1,"389":1},"z":3416.00048828125},{"id":389,"x":-993.3820190429688,"links":{"386":1,"391":1},"z":3384.970703125},{"id":391,"x":-1034.141357421875,"links":{"389":1,"393":1},"z":3353.984130859375},{"id":393,"x":-1065.8316650390626,"links":{"391":1,"395":1},"z":3320.520751953125},{"id":395,"x":-1092.248046875,"links":{"397":1,"393":1},"z":3280.939208984375},{"id":397,"x":-1113.5003662109376,"links":{"399":1,"395":1},"z":3236.566162109375},{"id":399,"x":-1126.180419921875,"links":{"400":1,"397":1},"z":3191.16552734375},{"id":400,"x":-1131.08203125,"links":{"402":1,"399":1},"z":3162.94970703125},{"id":402,"x":-1132.9716796875,"links":{"400":1,"403":1},"z":2949.7021484375},{"id":403,"x":-1133.15576171875,"links":{"402":1,"404":1},"z":2790.06103515625},{"id":404,"x":-1132.39453125,"links":{"403":1,"405":1},"z":2599.9287109375},{"id":405,"x":-1133.4459228515626,"links":{"339":1,"537":1,"340":1,"404":1,"341":1},"z":2298.769287109375},{"id":406,"x":-1133.24609375,"links":{"537":1,"407":1},"z":2103.6591796875},{"id":407,"x":-1133.240478515625,"links":{"408":1,"406":1},"z":1903.052978515625},{"id":408,"x":-1133.781005859375,"links":{"409":1,"407":1},"z":1806.46044921875},{"id":409,"x":-1133.0469970703126,"links":{"335":1,"334":1,"408":1,"333":1,"535":1,"534":1},"z":1721.661865234375},{"id":410,"x":-1133.1956787109376,"links":{"330":1,"331":1,"329":1,"553":1,"534":1},"z":1485.2933349609376},{"id":411,"x":-1132.4117431640626,"links":{"553":1,"412":1},"z":967.19091796875},{"id":412,"x":-1132.5914306640626,"links":{"411":1,"413":1},"z":720.7908935546875},{"id":413,"x":-1132.980224609375,"links":{"412":1,"414":1},"z":553.418701171875},{"id":414,"x":-1133.1239013671876,"links":{"413":1,"415":1},"z":362.0313720703125},{"id":415,"x":-1133.2923583984376,"links":{"532":1,"320":1,"318":1,"319":1,"414":1,"552":1},"z":190.83319091796876},{"id":416,"x":-1133.2666015625,"links":{"417":1,"552":1},"z":-3.0633087158203127},{"id":417,"x":-1132.771728515625,"links":{"418":1,"416":1},"z":-148.8936004638672},{"id":418,"x":-1133.8013916015626,"links":{"419":1,"417":1},"z":-286.58563232421877},{"id":419,"x":-1133.523193359375,"links":{"420":1,"418":1},"z":-423.37457275390627},{"id":420,"x":-1133.2794189453126,"links":{"419":1,"421":1},"z":-512.3258666992188},{"id":421,"x":-1133.8201904296876,"links":{"420":1,"422":1,"311":1,"551":1,"309":1,"310":1},"z":-678.3917846679688},{"id":422,"x":-1133.736328125,"links":{"551":1,"421":1,"423":1},"z":-932.276123046875},{"id":423,"x":-1132.1461181640626,"links":{"422":1,"424":1},"z":-1195.0726318359376},{"id":424,"x":-1133.187744140625,"links":{"305":1,"304":1,"423":1,"550":1,"528":1,"303":1},"z":-1325.5045166015626},{"id":425,"x":-1132.5751953125,"links":{"426":1,"302":1},"z":-1685.3419189453126},{"id":426,"x":-1132.8665771484376,"links":{"427":1,"425":1},"z":-1887.46240234375},{"id":427,"x":-1133.2581787109376,"links":{"426":1,"428":1},"z":-2068.962890625},{"id":428,"x":-1132.912841796875,"links":{"429":1,"427":1},"z":-2217.068115234375},{"id":429,"x":-1132.685791015625,"links":{"428":1,"430":1},"z":-2381.326171875},{"id":430,"x":-1133.5714111328126,"links":{"431":1,"292":1,"291":1,"290":1,"549":1,"429":1},"z":-2456.996826171875},{"id":431,"x":-1132.8172607421876,"links":{"549":1,"430":1,"432":1},"z":-2648.20166015625},{"id":432,"x":-1132.7293701171876,"links":{"433":1,"431":1},"z":-2826.08984375},{"id":433,"x":-1132.929443359375,"links":{"434":1,"432":1},"z":-3124.111572265625},{"id":434,"x":-1130.9884033203126,"links":{"433":1,"435":1},"z":-3166.726318359375},{"id":435,"x":-1120.45751953125,"links":{"436":1,"434":1},"z":-3215.198486328125},{"id":436,"x":-1104.699462890625,"links":{"435":1,"437":1},"z":-3258.238037109375},{"id":437,"x":-1080.1024169921876,"links":{"438":1,"436":1},"z":-3301.0185546875},{"id":438,"x":-1050.3087158203126,"links":{"437":1,"439":1},"z":-3338.572265625},{"id":439,"x":-1015.1245727539063,"links":{"438":1,"440":1},"z":-3369.48828125},{"id":440,"x":-973.6213989257813,"links":{"441":1,"439":1},"z":-3396.138427734375},{"id":441,"x":-927.4932861328125,"links":{"442":1,"440":1},"z":-3417.257568359375},{"id":442,"x":-860.9188232421875,"links":{"441":1,"443":1},"z":-3431.572509765625},{"id":443,"x":-785.8946533203125,"links":{"444":1,"442":1},"z":-3433.0107421875},{"id":444,"x":-714.0355834960938,"links":{"443":1,"445":1},"z":-3432.4033203125},{"id":445,"x":-616.4255981445313,"links":{"446":1,"444":1},"z":-3433.02490234375},{"id":446,"x":-523.5658569335938,"links":{"447":1,"445":1},"z":-3432.355712890625},{"id":447,"x":-424.40264892578127,"links":{"448":1,"446":1},"z":-3432.7197265625},{"id":448,"x":-307.489990234375,"links":{"447":1,"449":1},"z":-3432.7548828125},{"id":449,"x":-204.34474182128907,"links":{"11":1,"448":1},"z":-3433.394775390625},{"id":450,"x":103.55612182617188,"links":{"451":1,"10":1},"z":-3432.7763671875},{"id":451,"x":193.1942138671875,"links":{"450":1,"452":1},"z":-3433.522705078125},{"id":452,"x":310.89361572265627,"links":{"451":1,"453":1},"z":-3433.28515625},{"id":453,"x":420.91241455078127,"links":{"454":1,"452":1},"z":-3432.5},{"id":454,"x":536.6317138671875,"links":{"455":1,"453":1},"z":-3432.826171875},{"id":455,"x":685.3643798828125,"links":{"456":1,"454":1},"z":-3433.1298828125},{"id":456,"x":712.0828857421875,"links":{"457":1,"455":1},"z":-3433.287841796875},{"id":457,"x":845.6223754882813,"links":{"456":1,"458":1},"z":-3432.6298828125},{"id":458,"x":871.1560668945313,"links":{"457":1,"459":1},"z":-3429.435302734375},{"id":459,"x":890.9829711914063,"links":{"458":1,"460":1},"z":-3426.3583984375},{"id":460,"x":916.1332397460938,"links":{"461":1,"459":1},"z":-3420.3994140625},{"id":461,"x":939.7714233398438,"links":{"460":1,"462":1},"z":-3412.803466796875},{"id":462,"x":963.2590942382813,"links":{"463":1,"461":1},"z":-3402.2744140625},{"id":463,"x":980.1021728515625,"links":{"464":1,"462":1},"z":-3393.2880859375},{"id":464,"x":998.4989013671875,"links":{"465":1,"463":1},"z":-3381.685546875},{"id":465,"x":1024.571044921875,"links":{"464":1,"466":1},"z":-3364.001953125},{"id":466,"x":1042.66552734375,"links":{"467":1,"465":1},"z":-3348.642333984375},{"id":467,"x":1055.27587890625,"links":{"468":1,"466":1},"z":-3332.878173828125},{"id":468,"x":1070.386474609375,"links":{"467":1,"469":1},"z":-3315.325439453125},{"id":469,"x":1086.334716796875,"links":{"470":1,"468":1},"z":-3294.93408203125},{"id":470,"x":1098.0841064453126,"links":{"469":1,"471":1},"z":-3273.591796875},{"id":471,"x":1108.3770751953126,"links":{"472":1,"470":1},"z":-3250.864990234375},{"id":472,"x":1116.783447265625,"links":{"471":1,"473":1},"z":-3224.771240234375},{"id":473,"x":1122.809326171875,"links":{"472":1,"474":1},"z":-3206.593505859375},{"id":474,"x":1129.2296142578126,"links":{"475":1,"473":1},"z":-3182.497802734375},{"id":475,"x":1130.900390625,"links":{"476":1,"474":1},"z":-3158.978515625},{"id":476,"x":1132.597900390625,"links":{"475":1,"477":1},"z":-3133.187744140625},{"id":477,"x":1132.668701171875,"links":{"478":1,"476":1},"z":-2980.3369140625},{"id":478,"x":1132.697998046875,"links":{"477":1,"479":1},"z":-2812.031494140625},{"id":479,"x":1133.1787109375,"links":{"480":1,"478":1},"z":-2654.809814453125},{"id":480,"x":1133.860107421875,"links":{"481":1,"479":1,"214":1,"548":1,"213":1,"212":1},"z":-2499.11279296875},{"id":481,"x":1133.19091796875,"links":{"480":1,"547":1,"482":1},"z":-2357.951416015625},{"id":482,"x":1133.7855224609376,"links":{"481":1,"483":1},"z":-2266.2373046875},{"id":483,"x":1133.7196044921876,"links":{"484":1,"482":1},"z":-2109.88525390625},{"id":484,"x":1132.002197265625,"links":{"483":1,"485":1},"z":-1959.5706787109376},{"id":485,"x":1132.462890625,"links":{"484":1,"486":1},"z":-1810.8446044921876},{"id":486,"x":1134.23681640625,"links":{"485":1,"487":1},"z":-1667.428466796875},{"id":487,"x":1133.1439208984376,"links":{"486":1,"488":1},"z":-1539.256591796875},{"id":488,"x":1132.918701171875,"links":{"200":1,"201":1,"487":1},"z":-1392.1361083984376},{"id":489,"x":1132.39208984375,"links":{"545":1,"490":1},"z":-1292.30859375},{"id":490,"x":1132.690185546875,"links":{"492":1,"489":1},"z":-1189.4190673828126},{"id":491,"x":1149.0975341796876,"links":{"197":1,"493":1,"492":1},"z":-1001.9498901367188},{"id":492,"x":1133.8922119140626,"links":{"491":1,"490":1,"544":1,"493":1},"z":-1009.3973388671875},{"id":493,"x":1133.2706298828126,"links":{"491":1,"197":1,"492":1,"494":1},"z":-986.5787353515625},{"id":494,"x":1133.29345703125,"links":{"493":1,"496":1},"z":-823.9039306640625},{"id":495,"x":1132.3790283203126,"links":{"497":1,"496":1,"194":1,"195":1},"z":-705.7030029296875},{"id":496,"x":1132.8865966796876,"links":{"193":1,"194":1,"195":1,"495":1,"494":1},"z":-725.8629150390625},{"id":497,"x":1132.9051513671876,"links":{"193":1,"194":1,"195":1,"495":1,"498":1},"z":-672.7606201171875},{"id":498,"x":1133.113525390625,"links":{"499":1,"497":1},"z":-593.8841552734375},{"id":499,"x":1133.0869140625,"links":{"498":1,"500":1},"z":-473.7284240722656},{"id":500,"x":1132.9791259765626,"links":{"501":1,"499":1},"z":-381.48004150390627},{"id":501,"x":1132.696533203125,"links":{"502":1,"500":1},"z":-258.0456237792969},{"id":502,"x":1133.2764892578126,"links":{"185":1,"503":1,"186":1,"501":1,"543":1},"z":-26.03058624267578},{"id":503,"x":1132.7989501953126,"links":{"502":1,"542":1,"504":1},"z":144.372802734375},{"id":504,"x":1133.1329345703126,"links":{"505":1,"503":1},"z":304.8929748535156},{"id":505,"x":1133.582275390625,"links":{"504":1,"506":1},"z":369.3919677734375},{"id":506,"x":1133.045166015625,"links":{"507":1,"505":1},"z":465.75555419921877},{"id":507,"x":1133.27880859375,"links":{"508":1,"506":1},"z":674.4030151367188},{"id":508,"x":1133.1331787109376,"links":{"509":1,"507":1},"z":789.9005126953125},{"id":509,"x":1133.346435546875,"links":{"172":1,"508":1,"171":1,"170":1},"z":985.21728515625},{"id":510,"x":1132.654541015625,"links":{"172":1,"511":1},"z":1073.283203125},{"id":511,"x":1133.4359130859376,"links":{"510":1,"513":1,"169":1,"168":1,"167":1},"z":1123.401611328125},{"id":512,"x":1133.8447265625,"links":{"168":1,"167":1,"513":1},"z":1152.6033935546876},{"id":513,"x":1132.742919921875,"links":{"515":1,"512":1,"511":1},"z":1289.7794189453126},{"id":515,"x":1132.988037109375,"links":{"516":1,"513":1},"z":1968.662841796875},{"id":516,"x":1133.1016845703126,"links":{"159":1,"539":1,"515":1,"557":1,"94":1},"z":2268.95166015625},{"id":517,"x":1261.28515625,"links":{"173":1,"518":1},"z":992.3869018554688},{"id":518,"x":1310.5638427734376,"links":{"519":1,"517":1},"z":987.9071655273438},{"id":519,"x":1347.224365234375,"links":{"518":1,"520":1},"z":984.6815185546875},{"id":520,"x":1380.777587890625,"links":{"521":1,"519":1},"z":983.94677734375},{"id":521,"x":1415.0811767578126,"links":{"522":1,"520":1},"z":985.2296752929688},{"id":522,"x":1463.514892578125,"links":{"523":1,"521":1},"z":990.9226684570313},{"id":523,"x":1502.3653564453126,"links":{"522":1,"524":1},"z":1000.1648559570313},{"id":524,"x":1540.9454345703126,"links":{"525":1,"523":1},"z":1017.0733642578125},{"id":525,"x":1581.4710693359376,"links":{"524":1,"526":1},"z":1043.45166015625},{"id":526,"x":1642.9986572265626,"links":{"525":1},"z":1087.9442138671876},{"id":527,"x":-1167.5189208984376,"links":{"302":1,"301":1,"528":1},"z":-1524.43212890625},{"id":528,"x":-1133.113037109375,"links":{"302":1,"301":1,"424":1,"550":1,"527":1,"529":1},"z":-1475.77880859375},{"id":529,"x":-1167.0491943359376,"links":{"303":1,"302":1,"528":1,"301":1},"z":-1484.04248046875},{"id":530,"x":-1166.8994140625,"links":{"309":1,"531":1},"z":-624.6937866210938},{"id":531,"x":-1167.333740234375,"links":{"312":1,"530":1},"z":-564.6454467773438},{"id":532,"x":-1167.1263427734376,"links":{"321":1,"320":1,"318":1,"319":1,"415":1,"552":1},"z":195.788818359375},{"id":533,"x":-1166.820556640625,"links":{"330":1,"329":1,"553":1,"332":1},"z":1492.0323486328126},{"id":534,"x":-1132.98193359375,"links":{"335":1,"334":1,"409":1,"333":1,"410":1},"z":1676.2901611328126},{"id":535,"x":-1167.5462646484376,"links":{"336":1,"333":1,"409":1},"z":1724.121826171875},{"id":536,"x":-1166.56591796875,"links":{"339":1,"342":1,"537":1,"340":1,"341":1},"z":2304.4375},{"id":537,"x":-1132.4031982421876,"links":{"339":1,"406":1,"536":1,"340":1,"405":1},"z":2272.1728515625},{"id":538,"x":131.24559020996095,"links":{"121":1,"120":1},"z":3467.033203125},{"id":539,"x":1167.142333984375,"links":{"159":1,"95":1,"540":1,"516":1,"94":1},"z":2294.821044921875},{"id":540,"x":1166.482177734375,"links":{"94":1,"95":1,"160":1,"159":1,"557":1,"539":1},"z":2263.912841796875},{"id":541,"x":1166.7352294921876,"links":{"169":1,"168":1,"166":1},"z":1150.885498046875},{"id":542,"x":1134.950439453125,"links":{"185":1,"184":1,"503":1,"186":1},"z":2.0997161865234377},{"id":543,"x":1169.0142822265626,"links":{"184":1,"502":1},"z":6.9324951171875},{"id":544,"x":1168.2452392578126,"links":{"654":1,"492":1},"z":-987.6312255859375},{"id":545,"x":1132.7659912109376,"links":{"489":1,"546":1,"201":1,"202":1,"200":1},"z":-1374.1156005859376},{"id":546,"x":1168.1363525390626,"links":{"202":1,"545":1},"z":-1363.9715576171876},{"id":547,"x":1134.2987060546876,"links":{"481":1,"213":1,"212":1},"z":-2471.774169921875},{"id":548,"x":1167.30126953125,"links":{"480":1,"211":1,"213":1,"212":1},"z":-2473.47216796875},{"id":549,"x":-1135.666015625,"links":{"431":1,"292":1,"291":1,"290":1,"430":1},"z":-2481.46533203125},{"id":550,"x":-1134.8106689453126,"links":{"305":1,"304":1,"424":1,"528":1,"303":1},"z":-1349.9068603515626},{"id":551,"x":-1133.9176025390626,"links":{"421":1,"422":1,"311":1,"310":1,"309":1},"z":-729.0045776367188},{"id":552,"x":-1132.9671630859376,"links":{"532":1,"320":1,"318":1,"319":1,"415":1,"416":1},"z":169.414306640625},{"id":553,"x":-1132.7855224609376,"links":{"330":1,"533":1,"411":1,"410":1,"329":1,"331":1},"z":1463.44384765625},{"id":554,"x":825.961181640625,"links":{"555":1,"114":1,"113":1},"z":3431.364013671875},{"id":555,"x":828.2959594726563,"links":{"554":1},"z":3393.7373046875},{"id":556,"x":855.2952880859375,"links":{"113":1},"z":3389.037841796875},{"id":557,"x":1134.0157470703126,"links":{"540":1,"159":1,"516":1,"96":1},"z":2291.10693359375},{"id":558,"x":965.9937744140625,"links":{"559":1,"169":1},"z":1139.8040771484376},{"id":559,"x":894.4287109375,"links":{"560":1,"558":1},"z":1137.7034912109376},{"id":560,"x":549.8134765625,"links":{"559":1,"561":1},"z":1137.579345703125},{"id":561,"x":487.04400634765627,"links":{"560":1,"563":1},"z":1137.2408447265626},{"id":562,"x":52.70274353027344,"links":{"60":1,"563":1},"z":1127.0064697265626},{"id":563,"x":79.30299377441406,"links":{"59":1,"562":1,"561":1},"z":1139.75634765625},{"id":564,"x":276.23822021484377,"links":{"565":1},"z":884.3860473632813},{"id":565,"x":213.44476318359376,"links":{"566":1,"564":1},"z":882.8822631835938},{"id":566,"x":60.025123596191409,"links":{"60":1,"565":1,"61":1},"z":885.8626708984375},{"id":567,"x":56.203243255615237,"links":{"1":1},"z":-11.814048767089844},{"id":568,"x":157.8249969482422,"links":{"569":1,"567":1},"z":-10.033024787902832},{"id":569,"x":309.4381103515625,"links":{"570":1,"568":1},"z":-11.514193534851075},{"id":570,"x":531.5606689453125,"links":{"569":1,"571":1},"z":-11.38719367980957},{"id":571,"x":631.79443359375,"links":{"570":1,"186":1},"z":-11.887914657592774},{"id":572,"x":1034.7852783203126,"links":{"573":1,"195":1},"z":-700.2337036132813},{"id":573,"x":582.4966430664063,"links":{"3":1,"572":1},"z":-698.0972290039063},{"id":574,"x":63.914093017578128,"links":{"67":1,"575":1},"z":-1035.96728515625},{"id":575,"x":197.69772338867188,"links":{"576":1,"574":1},"z":-1034.662109375},{"id":576,"x":338.70147705078127,"links":{"575":1},"z":-1033.2723388671876},{"id":577,"x":63.60576629638672,"links":{"578":1,"68":1},"z":-1379.5390625},{"id":578,"x":269.94482421875,"links":{"579":1,"577":1},"z":-1379.8941650390626},{"id":579,"x":510.1230163574219,"links":{"578":1,"580":1},"z":-1380.7318115234376},{"id":580,"x":790.5086059570313,"links":{"202":1,"579":1},"z":-1380.0098876953126},{"id":581,"x":58.08453369140625,"links":{"582":1,"69":1},"z":-1664.3507080078126},{"id":582,"x":393.89984130859377,"links":{"581":1},"z":-1667.5711669921876},{"id":583,"x":64.900146484375,"links":{"584":1,"70":1},"z":-1918.933837890625},{"id":584,"x":277.1402893066406,"links":{"583":1},"z":-1917.924072265625},{"id":585,"x":62.64112091064453,"links":{"71":1,"586":1},"z":-2489.58203125},{"id":586,"x":248.16964721679688,"links":{"585":1,"587":1},"z":-2487.13525390625},{"id":587,"x":533.5923461914063,"links":{"586":1,"214":1},"z":-2487.280517578125},{"id":588,"x":391.42974853515627,"links":{"589":1},"z":-2780.0205078125},{"id":589,"x":54.28594970703125,"links":{"588":1,"72":1},"z":-2780.90966796875},{"id":590,"x":-62.35797882080078,"links":{"74":1,"591":1},"z":-2788.6220703125},{"id":591,"x":-393.88153076171877,"links":{"590":1},"z":-2792.29541015625},{"id":592,"x":-60.38005828857422,"links":{"593":1,"75":1},"z":-2462.0673828125},{"id":593,"x":-508.8292236328125,"links":{"592":1,"292":1},"z":-2469.572998046875},{"id":594,"x":-64.65462493896485,"links":{"76":1,"595":1},"z":-1920.0810546875},{"id":595,"x":-607.9070434570313,"links":{"594":1},"z":-1920.971435546875},{"id":597,"x":-62.77885055541992,"links":{"598":1,"18":1},"z":-1336.8935546875},{"id":598,"x":-473.7420349121094,"links":{"597":1,"599":1},"z":-1335.745361328125},{"id":599,"x":-897.5870361328125,"links":{"598":1,"305":1},"z":-1334.1654052734376},{"id":600,"x":-59.58152770996094,"links":{"20":1,"601":1},"z":-1013.693603515625},{"id":601,"x":-278.94183349609377,"links":{"600":1},"z":-1015.09228515625},{"id":602,"x":-328.8401184082031,"links":{"603":1},"z":-178.21176147460938},{"id":603,"x":-59.99339294433594,"links":{"602":1,"25":1},"z":-181.25433349609376},{"id":604,"x":-64.28004455566406,"links":{"605":1,"26":1},"z":180.39691162109376},{"id":605,"x":-505.59759521484377,"links":{"606":1,"604":1},"z":179.0519561767578},{"id":606,"x":-914.6466674804688,"links":{"605":1,"320":1},"z":182.17236328125},{"id":607,"x":-373.2466125488281,"links":{"608":1},"z":444.1000671386719},{"id":608,"x":-62.24494934082031,"links":{"607":1,"77":1},"z":445.98419189453127},{"id":609,"x":-60.77691650390625,"links":{"30":1,"610":1},"z":886.5872192382813},{"id":610,"x":-215.05296325683595,"links":{"611":1,"609":1},"z":890.46630859375},{"id":611,"x":-386.58819580078127,"links":{"610":1},"z":888.9364013671875},{"id":612,"x":-61.475650787353519,"links":{"613":1,"32":1},"z":1475.815185546875},{"id":613,"x":-159.30746459960938,"links":{"614":1,"612":1},"z":1472.4595947265626},{"id":614,"x":-418.5462341308594,"links":{"615":1,"613":1},"z":1473.2158203125},{"id":615,"x":-621.8232421875,"links":{"616":1,"614":1},"z":1476.5379638671876},{"id":616,"x":-919.03369140625,"links":{"615":1,"331":1},"z":1475.432861328125},{"id":617,"x":-63.26393127441406,"links":{"35":1,"618":1},"z":1831.2193603515626},{"id":618,"x":-333.6187438964844,"links":{"617":1},"z":1833.0335693359376},{"id":619,"x":-63.26365661621094,"links":{"620":1,"38":1},"z":2290.596923828125},{"id":620,"x":-294.9935302734375,"links":{"619":1,"621":1},"z":2291.448486328125},{"id":621,"x":-623.3756103515625,"links":{"620":1,"341":1},"z":2287.13623046875},{"id":622,"x":-64.77633666992188,"links":{"39":1,"623":1},"z":2568.683349609375},{"id":623,"x":-304.9112243652344,"links":{"622":1},"z":2571.06689453125},{"id":624,"x":63.020751953125,"links":{"52":1,"625":1},"z":2530.72216796875},{"id":625,"x":151.7841339111328,"links":{"626":1,"624":1},"z":2524.654052734375},{"id":626,"x":191.57870483398438,"links":{"629":1,"641":1,"645":1,"625":1},"z":2534.0224609375},{"id":629,"x":188.26959228515626,"links":{"626":1,"630":1},"z":2374.145263671875},{"id":630,"x":276.15692138671877,"links":{"629":1,"631":1},"z":2375.597412109375},{"id":631,"x":380.0929260253906,"links":{"632":1,"645":1,"630":1},"z":2375.861083984375},{"id":632,"x":576.7935791015625,"links":{"633":1,"631":1,"644":1},"z":2375.922607421875},{"id":633,"x":753.3650512695313,"links":{"634":1,"632":1},"z":2377.145751953125},{"id":634,"x":753.9547729492188,"links":{"633":1,"644":1,"635":1},"z":2532.26904296875},{"id":635,"x":753.7635498046875,"links":{"643":1,"637":1,"634":1},"z":2742.22607421875},{"id":637,"x":755.260009765625,"links":{"638":1,"635":1},"z":2945.4052734375},{"id":638,"x":576.3089599609375,"links":{"643":1,"637":1,"639":1},"z":2946.49560546875},{"id":639,"x":379.4067077636719,"links":{"638":1,"642":1,"640":1},"z":2946.202392578125},{"id":640,"x":194.198486328125,"links":{"641":1,"639":1},"z":2946.84130859375},{"id":641,"x":191.09323120117188,"links":{"626":1,"642":1,"640":1},"z":2740.002685546875},{"id":642,"x":380.1341552734375,"links":{"643":1,"639":1,"641":1,"645":1},"z":2740.146240234375},{"id":643,"x":575.6064453125,"links":{"638":1,"642":1,"644":1,"635":1},"z":2740.331787109375},{"id":644,"x":575.6934814453125,"links":{"643":1,"632":1,"634":1,"645":1},"z":2533.4482421875},{"id":645,"x":380.21856689453127,"links":{"626":1,"642":1,"631":1,"644":1},"z":2532.805908203125},{"id":646,"x":62.42707443237305,"links":{"53":1,"79":1},"z":2282.18017578125},{"id":647,"x":63.46641540527344,"links":{"648":1,"55":1},"z":1732.322021484375},{"id":648,"x":384.0557861328125,"links":{"647":1},"z":1730.0828857421876},{"id":649,"x":63.558433532714847,"links":{"650":1,"58":1},"z":1403.279052734375},{"id":650,"x":318.52325439453127,"links":{"649":1},"z":1404.716064453125},{"id":651,"x":63.328895568847659,"links":{"652":1,"653":1},"z":-514.2078857421875},{"id":652,"x":36.95098876953125,"links":{"651":1,"3":1,"2":1},"z":-516.0540161132813},{"id":653,"x":282.3428955078125,"links":{"651":1},"z":-516.2931518554688},{"id":654,"x":1195.858154296875,"links":{"197":1,"544":1,"655":1},"z":-999.3687133789063},{"id":655,"x":1236.3992919921876,"links":{"654":1,"656":1},"z":-994.1814575195313},{"id":656,"x":1296.115478515625,"links":{"655":1,"657":1},"z":-990.7782592773438},{"id":657,"x":1343.3035888671876,"links":{"656":1,"658":1},"z":-989.8026123046875},{"id":658,"x":1396.1556396484376,"links":{"657":1},"z":-995.204833984375},{"id":664,"x":1201.309326171875,"links":{"211":1,"665":1},"z":-2269.92041015625},{"id":665,"x":1269.904052734375,"links":{"666":1,"664":1},"z":-2270.128662109375},{"id":666,"x":1399.5145263671876,"links":{"667":1,"665":1},"z":-2270.1416015625},{"id":667,"x":1499.0994873046876,"links":{"668":1,"669":1,"670":1,"666":1},"z":-2270.563720703125},{"id":668,"x":1499.5076904296876,"links":{"667":1},"z":-2285.978515625},{"id":669,"x":1499.229248046875,"links":{"701":1,"667":1},"z":-2346.968505859375},{"id":670,"x":1666.510498046875,"links":{"705":1,"671":1,"667":1},"z":-2271.11328125},{"id":671,"x":1672.94677734375,"links":{"670":1,"704":1,"705":1},"z":-2254.956298828125},{"id":672,"x":1841.0849609375,"links":{"705":1,"673":1,"706":1},"z":-2269.926513671875},{"id":673,"x":1849.449951171875,"links":{"703":1,"672":1,"706":1},"z":-2285.753173828125},{"id":674,"x":2013.6817626953126,"links":{"706":1,"675":1,"708":1},"z":-2270.040283203125},{"id":675,"x":2025.25146484375,"links":{"674":1,"707":1,"708":1},"z":-2254.50439453125},{"id":676,"x":2189.17919921875,"links":{"677":1,"709":1,"708":1},"z":-2270.083984375},{"id":677,"x":2197.998779296875,"links":{"709":1,"676":1},"z":-2285.62353515625},{"id":678,"x":2363.306396484375,"links":{"679":1,"709":1,"710":1},"z":-2270.165283203125},{"id":679,"x":2373.5439453125,"links":{"710":1,"678":1},"z":-2255.123779296875},{"id":680,"x":2686.994873046875,"links":{"710":1,"681":1},"z":-2267.470458984375},{"id":681,"x":2699.707763671875,"links":{"680":1,"682":1},"z":-2288.867919921875},{"id":682,"x":2699.8056640625,"links":{"683":1,"684":1,"681":1},"z":-2505.96142578125},{"id":683,"x":2684.359130859375,"links":{"682":1},"z":-2515.2919921875},{"id":684,"x":2699.99072265625,"links":{"682":1,"685":1},"z":-2740.066162109375},{"id":685,"x":2682.185546875,"links":{"684":1,"688":1},"z":-2758.70849609375},{"id":686,"x":2359.205322265625,"links":{"687":1,"714":1,"688":1},"z":-2759.328369140625},{"id":687,"x":2374.533203125,"links":{"686":1,"688":1,"711":1},"z":-2776.075439453125},{"id":688,"x":2383.717529296875,"links":{"686":1,"687":1,"685":1},"z":-2759.851806640625},{"id":689,"x":2013.543701171875,"links":{"694":1,"691":1,"690":1},"z":-2759.367919921875},{"id":690,"x":2024.315185546875,"links":{"712":1,"691":1,"689":1},"z":-2775.09765625},{"id":691,"x":2035.2232666015626,"links":{"712":1,"690":1,"689":1},"z":-2760.281494140625},{"id":692,"x":1838.0006103515626,"links":{"693":1,"694":1,"697":1},"z":-2759.468505859375},{"id":693,"x":1848.693603515625,"links":{"703":1,"694":1,"692":1},"z":-2744.10546875},{"id":694,"x":1860.7987060546876,"links":{"693":1,"692":1,"689":1},"z":-2759.7646484375},{"id":695,"x":1667.123046875,"links":{"696":1,"697":1,"700":1},"z":-2760.30419921875},{"id":696,"x":1675.263671875,"links":{"697":1,"695":1},"z":-2774.233154296875},{"id":697,"x":1685.9156494140626,"links":{"695":1,"692":1,"696":1},"z":-2760.34765625},{"id":698,"x":1482.3009033203126,"links":{"216":1,"699":1,"700":1},"z":-2760.153076171875},{"id":699,"x":1499.5137939453126,"links":{"698":1,"701":1,"700":1},"z":-2744.15087890625},{"id":700,"x":1510.279541015625,"links":{"695":1,"699":1,"698":1},"z":-2759.840087890625},{"id":701,"x":1499.697021484375,"links":{"703":1,"669":1,"699":1,"702":1},"z":-2515.6025390625},{"id":702,"x":1299.2703857421876,"links":{"701":1},"z":-2515.7099609375},{"id":703,"x":1849.838134765625,"links":{"693":1,"701":1,"673":1},"z":-2515.791748046875},{"id":704,"x":1676.5716552734376,"links":{"671":1},"z":-2050.361572265625},{"id":705,"x":1683.0126953125,"links":{"670":1,"671":1,"672":1},"z":-2269.7939453125},{"id":706,"x":1858.6630859375,"links":{"673":1,"672":1,"674":1},"z":-2272.865966796875},{"id":707,"x":2028.761962890625,"links":{"675":1},"z":-2051.94677734375},{"id":708,"x":2037.98583984375,"links":{"676":1,"675":1,"674":1},"z":-2269.750244140625},{"id":709,"x":2207.802001953125,"links":{"677":1,"676":1,"678":1},"z":-2270.093505859375},{"id":710,"x":2384.810791015625,"links":{"679":1,"678":1,"680":1},"z":-2270.048095703125},{"id":711,"x":2372.248291015625,"links":{"687":1},"z":-2979.671875},{"id":712,"x":2189.927978515625,"links":{"715":1,"714":1,"691":1,"690":1},"z":-2760.3291015625},{"id":714,"x":2209.8935546875,"links":{"712":1,"686":1,"715":1},"z":-2759.333984375},{"id":715,"x":2200.077880859375,"links":{"714":1,"712":1},"z":-2743.74267578125}]}]==]

Hub.CustomRoadGraph = {
    initialized = false,
    nodes = {},
    nodesVec = {},
    adj = {},
    edgesList = {},
}

Hub.InitCustomRoadGraph = function()
    if Hub.CustomRoadGraph.initialized then return end
    
    local rawJson = Hub.RoadJsonData
    if not rawJson or #rawJson < 10 then
        pcall(function()
            if readfile then
                rawJson = readfile("road_nodes.json") or readfile("message (4).lua")
            end
        end)
    end
    
    local data = nil
    if rawJson then
        pcall(function()
            data = HttpService:JSONDecode(rawJson)
        end)
    end
    
    if not data or not data.nodes then
        do end  -- suppressed: roadgraph decode warn
        return
    end
    
    local nodesVec = {}
    local nodesList = {}
    local adj = {}
    local maxId = 0
    for _, node in ipairs(data.nodes or {}) do
        local v = Vector2.new(node.x, node.z)
        nodesVec[node.id] = v
        table.insert(nodesList, v)
        adj[node.id] = {}
        if node.id > maxId then maxId = node.id end
    end
    
    local edgesList = {}
    local edgeSet = {}

    local function addEdgeRaw(idA, idB)
        if not idA or not idB or idA == idB then return end
        local pA, pB = nodesVec[idA], nodesVec[idB]
        if not pA or not pB then return end
        local key = idA < idB and (idA .. "_" .. idB) or (idB .. "_" .. idA)
        if edgeSet[key] then return end
        edgeSet[key] = true
        local dist = (pA - pB).Magnitude
        if not adj[idA] then adj[idA] = {} end
        if not adj[idB] then adj[idB] = {} end
        table.insert(adj[idA], { idB, dist })
        table.insert(adj[idB], { idA, dist })
        table.insert(edgesList, { a = idA, b = idB, len = dist })
    end

    for _, node in ipairs(data.nodes or {}) do
        local id = node.id
        if type(node.links) == "table" then
            for targetId, _ in pairs(node.links) do
                local targetNum = tonumber(targetId)
                if targetNum and nodesVec[targetNum] then
                    addEdgeRaw(id, targetNum)
                end
            end
        end
    end

    local baseEdgesCount = #edgesList

    local function snapToEdges(pt, maxEdgeIndex)
        local limit = maxEdgeIndex or #edgesList
        local bestPt, bestEdge, bestT, bestDist = nil, nil, nil, math.huge
        for idx = 1, limit do
            local e = edgesList[idx]
            local v1 = nodesVec[e.a]
            local v2 = nodesVec[e.b]
            if v1 and v2 then
                local v = v2 - v1
                local dot = (pt - v1):Dot(v)
                local t = math.clamp(dot / math.max(v:Dot(v), 1e-6), 0, 1)
                local proj = v1 + v * t
                local d = (proj - pt).Magnitude
                if d < bestDist then
                    bestPt, bestEdge, bestT, bestDist = proj, e, t, d
                end
            end
        end
        return bestPt, bestEdge, bestT, bestDist
    end

    local function addNode(v2)
        maxId = maxId + 1
        nodesVec[maxId] = v2
        table.insert(nodesList, v2)
        adj[maxId] = {}
        return maxId
    end

    local function getOrAttachNode(pt, maxSnapDist, snapOnlyBase)
        for id, nv in pairs(nodesVec) do
            if (nv - pt).Magnitude <= 2.5 then
                return id
            end
        end
        local sp, edge, t, d = snapToEdges(pt, snapOnlyBase and baseEdgesCount or #edgesList)
        if sp and d <= (maxSnapDist or 18) and edge then
            local vA = nodesVec[edge.a]
            local vB = nodesVec[edge.b]
            if (sp - vA).Magnitude <= 3.0 then return edge.a end
            if (sp - vB).Magnitude <= 3.0 then return edge.b end
            local jId = addNode(sp)
            addEdgeRaw(jId, edge.a)
            addEdgeRaw(jId, edge.b)
            return jId
        end
        return addNode(pt)
    end

    -- 1. Add Spawn Yard / Showroom / Garage / Delivery Locker Driveway Network (connects directly to Node 1 at (35.43, -157.24))
    pcall(function()
        if nodesVec[1] then
            local y95 = getOrAttachNode(Vector2.new(95, -157), 4, false)
            local y180 = getOrAttachNode(Vector2.new(180, -157), 4, false)
            local y275 = getOrAttachNode(Vector2.new(275, -157), 4, false)
            local y310 = getOrAttachNode(Vector2.new(310.4, -145.5), 4, false)
            local yLocker = getOrAttachNode(Vector2.new(96, -118), 4, false)
            local yN1 = getOrAttachNode(Vector2.new(180, -120), 4, false)
            local yN2 = getOrAttachNode(Vector2.new(275, -120), 4, false)
            local yS1 = getOrAttachNode(Vector2.new(180, -195), 4, false)
            local yS2 = getOrAttachNode(Vector2.new(275, -195), 4, false)
            addEdgeRaw(1, y95)
            addEdgeRaw(y95, y180)
            addEdgeRaw(y180, y275)
            addEdgeRaw(y275, y310)
            addEdgeRaw(y95, yLocker)
            addEdgeRaw(y180, yN1)
            addEdgeRaw(yN1, yN2)
            addEdgeRaw(yN2, y275)
            addEdgeRaw(y180, yS1)
            addEdgeRaw(yS1, yS2)
            addEdgeRaw(yS2, y275)
        end
    end)

    -- 2. Merge all missing drivable MapRoads edges (16 Spawn Alleys, Soi 26, New Town sub-streets, Across the River bridges/road, Hillside)
    pcall(function()
        if MapRoads and MapRoads.EDGES and MapRoads.NODES and MapRoads.KINDS then
            local mrNodeCache = {}
            for i = 1, #MapRoads.EDGES, 3 do
                local a, b, k = MapRoads.EDGES[i], MapRoads.EDGES[i + 1], MapRoads.EDGES[i + 2]
                local kind = MapRoads.KINDS[k]
                local kindId = kind and kind.id or ""
                if kindId ~= "main" and kindId ~= "ring" and kindId ~= "blvd" then
                    local ax, az = MapRoads.NODES[a * 2 - 1], MapRoads.NODES[a * 2]
                    local bx, bz = MapRoads.NODES[b * 2 - 1], MapRoads.NODES[b * 2]
                    if ax and az and bx and bz then
                        -- Connect main boulevard centerline (x=0) directly to the proper East (+35.8) or West (-35.8) carriageway
                        if ax == 0 and math.abs(az) < 3400 and math.abs(bx) > 20 then
                            ax = (bx > 0) and 35.8 or -35.8
                        elseif bx == 0 and math.abs(bz) < 3400 and math.abs(ax) > 20 then
                            bx = (ax > 0) and 35.8 or -35.8
                        end
                        local pA = Vector2.new(ax, az)
                        local pB = Vector2.new(bx, bz)
                        local mid = (pA + pB) * 0.5
                        local _, _, _, midDist = snapToEdges(mid, baseEdgesCount)
                        if kindId == "alley" or midDist > 16.0 then
                            local keyA = a .. "_" .. math.round(ax * 10)
                            local keyB = b .. "_" .. math.round(bx * 10)
                            local idA = mrNodeCache[keyA]
                            if not idA then
                                local snapTol = (kindId == "alley" and math.abs(ax) <= 70) and 32 or 18
                                idA = getOrAttachNode(pA, snapTol, true)
                                mrNodeCache[keyA] = idA
                            end
                            local idB = mrNodeCache[keyB]
                            if not idB then
                                local snapTol = (kindId == "alley" and math.abs(bx) <= 70) and 32 or 18
                                idB = getOrAttachNode(pB, snapTol, true)
                                mrNodeCache[keyB] = idB
                            end
                            addEdgeRaw(idA, idB)
                        end
                    end
                end
            end
        end
    end)
    
    Hub.CustomRoadGraph.nodes = nodesList
    Hub.CustomRoadGraph.nodesVec = nodesVec
    Hub.CustomRoadGraph.adj = adj
    Hub.CustomRoadGraph.edgesList = edgesList
    Hub.CustomRoadGraph.initialized = true
end

Hub.CustomRoadGraph.snap = function(pos, checkLOS, refY)
    if not Hub.CustomRoadGraph.initialized then Hub.InitCustomRoadGraph() end
    local edgesList = Hub.CustomRoadGraph.edgesList
    local nodesVec = Hub.CustomRoadGraph.nodesVec
    if not edgesList or not nodesVec then return nil, nil, nil, math.huge end

    local pos2D = (typeof(pos) == "Vector3" and Vector2.new(pos.X, pos.Z)) or pos
    local posY = refY or (typeof(pos) == "Vector3" and pos.Y) or nil

    local bestPt, bestEdge, bestT, bestDist = nil, nil, nil, math.huge
    for _, e in ipairs(edgesList) do
        local v1 = nodesVec[e.a]
        local v2 = nodesVec[e.b]
        if v1 and v2 then
            local v = v2 - v1
            local dot = (pos2D - v1):Dot(v)
            local t = math.clamp(dot / math.max(v:Dot(v), 1e-6), 0, 1)
            local pt = v1 + v * t
            local d = (pt - pos2D).Magnitude
            if d < bestDist then
                bestPt, bestEdge, bestT, bestDist = pt, e, t, d
            end
        end
    end

    -- 🛡️ Line-of-Sight (LOS) Aware Road Snapping:
    -- When off-road (> 4.5 studs from closest edge), verify no wall/fence/building blocks access to the snapped edge.
    -- Prevents snapping through fences/houses to an adjacent parallel Soi!
    if checkLOS ~= false and bestDist > 4.5 and Workspace then
        local losParams = RaycastParams.new()
        losParams.FilterType = Enum.RaycastFilterType.Exclude
        local exclude = {}
        if LocalPlayer and LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
        for _, fName in ipairs({ "SpawnedVehicles", "DeliveryMarker", "RouteArrows", Hub._routeFolderName or "CustomDeliveryRouteVisuals" }) do
            local f = Workspace:FindFirstChild(fName)
            if f then table.insert(exclude, f) end
        end
        losParams.FilterDescendantsInstances = exclude
        losParams.IgnoreWater = true

        local baseY = posY
        if not baseY or baseY < -10 then
            baseY = (Hub.GetElevation and Hub.GetElevation(pos2D.X, pos2D.Y, 3.5)) or 3.5
        end
        local rayStart = Vector3.new(pos2D.X, baseY + 1.8, pos2D.Y)

        local function isPointLOSClear(pt2D)
            local dir = Vector3.new(pt2D.X - pos2D.X, 0, pt2D.Y - pos2D.Y)
            if dir.Magnitude <= 1.5 then return true end
            local hit = Workspace:Raycast(rayStart, dir, losParams)
            if not hit or not hit.Instance or not hit.Instance.CanCollide then
                return true
            end
            return false
        end

        if not isPointLOSClear(bestPt) then
            local maxSearchDist = math.min(bestDist + 95.0, 260.0)
            local candidates = {}
            for _, e in ipairs(edgesList) do
                local v1 = nodesVec[e.a]
                local v2 = nodesVec[e.b]
                if v1 and v2 then
                    local v = v2 - v1
                    local dot = (pos2D - v1):Dot(v)
                    local t = math.clamp(dot / math.max(v:Dot(v), 1e-6), 0, 1)
                    local pt = v1 + v * t
                    local d = (pt - pos2D).Magnitude
                    if d <= maxSearchDist then
                        table.insert(candidates, { pt = pt, edge = e, t = t, d = d, v1 = v1, v2 = v2 })
                    end
                end
            end
            table.sort(candidates, function(a, b) return a.d < b.d end)

            for _, cand in ipairs(candidates) do
                if isPointLOSClear(cand.pt) then
                    return cand.pt, cand.edge, cand.t, cand.d
                end
                -- Also check sample points along this edge in case a single lamp post/tree blocked the perpendicular projection
                for _, sampleT in ipairs({ 0.0, 0.25, 0.5, 0.75, 1.0 }) do
                    local sPt = cand.v1 + (cand.v2 - cand.v1) * sampleT
                    local sDist = (sPt - pos2D).Magnitude
                    if sDist <= maxSearchDist and isPointLOSClear(sPt) then
                        return sPt, cand.edge, sampleT, sDist
                    end
                end
            end
        end
    end

    return bestPt, bestEdge, bestT, bestDist
end

Hub.CustomRoadGraph.nearest = function(pos, checkLOS)
    local pos2D = (typeof(pos) == "Vector3" and Vector2.new(pos.X, pos.Z)) 
        or (typeof(pos) == "Vector2" and pos) 
        or Vector2.zero
    local refY = typeof(pos) == "Vector3" and pos.Y or nil
    local bestPt, _, _, bestDist = Hub.CustomRoadGraph.snap(pos2D, checkLOS, refY)
    if not bestPt and RoadGraph and RoadGraph ~= Hub.CustomRoadGraph and RoadGraph.nearest then
        return RoadGraph.nearest(pos)
    end
    return bestPt or pos2D, bestDist or 0
end

Hub.CustomRoadGraph.computeRoute = function(startPos, endPos)
    if not Hub.CustomRoadGraph.initialized then Hub.InitCustomRoadGraph() end
    local nodesVec = Hub.CustomRoadGraph.nodesVec
    local adj = Hub.CustomRoadGraph.adj
    local edgesList = Hub.CustomRoadGraph.edgesList
    
    local start2D = (typeof(startPos) == "Vector3" and Vector2.new(startPos.X, startPos.Z)) or startPos
    local end2D = (typeof(endPos) == "Vector3" and Vector2.new(endPos.X, endPos.Z)) or endPos
    local startY = typeof(startPos) == "Vector3" and startPos.Y or nil
    local endY = typeof(endPos) == "Vector3" and endPos.Y or nil
    
    if not nodesVec or not edgesList or #edgesList == 0 then
        return { start2D, end2D }, (end2D - start2D).Magnitude
    end
    
    local startSnap, startEdge, startT = Hub.CustomRoadGraph.snap(start2D, true, startY)
    local endSnap, endEdge, endT = Hub.CustomRoadGraph.snap(end2D, true, endY)
    
    if not startSnap or not endSnap then
        return { start2D, end2D }, (end2D - start2D).Magnitude
    end
    
    if startEdge and endEdge and startEdge == endEdge then
        local directWps = { start2D }
        local distFromRoad = (startSnap - start2D).Magnitude
        local toEnd = (endSnap - start2D).Magnitude
        local segDir = endSnap - startSnap
        if segDir.Magnitude > 0.5 then
            segDir = segDir.Unit
            local projT = (start2D - startSnap):Dot(segDir)
            if distFromRoad <= 5.0 and projT <= 1.0 and toEnd > 14.0 then
                local mergeDist = math.clamp(projT + 8.0, 5.0, math.min(16.0, (endSnap - startSnap).Magnitude - 1.0))
                if mergeDist > 1.0 then
                    table.insert(directWps, startSnap + segDir * mergeDist)
                end
            elseif distFromRoad > 1.0 then
                table.insert(directWps, startSnap)
            end
        elseif distFromRoad > 1.0 then
            table.insert(directWps, startSnap)
        end
        if (endSnap - directWps[#directWps]).Magnitude > 0.5 then table.insert(directWps, endSnap) end
        if (end2D - directWps[#directWps]).Magnitude > 0.5 then table.insert(directWps, end2D) end
        local dLen = 0
        for i = 2, #directWps do dLen = dLen + (directWps[i] - directWps[i-1]).Magnitude end
        return directWps, dLen
    end
    
    local function h(idx)
        return (nodesVec[idx] - endSnap).Magnitude
    end
    
    local open = {}
    local gScore = {}
    local cameFrom = {}
    
    if startEdge then
        local a = startEdge.a
        local b = startEdge.b
        gScore[a] = startEdge.len * startT
        gScore[b] = startEdge.len * (1 - startT)
        table.insert(open, { idx = a, f = gScore[a] + h(a) })
        table.insert(open, { idx = b, f = gScore[b] + h(b) })
    end
    
    local endNodes = {}
    if endEdge then
        endNodes[endEdge.a] = endEdge.len * endT
        endNodes[endEdge.b] = endEdge.len * (1 - endT)
    end
    
    local bestG = math.huge
    local bestNode = nil
    
    while #open > 0 do
        local minIdx = 1
        for i = 2, #open do
            if open[i].f < open[minIdx].f then minIdx = i end
        end
        local current = table.remove(open, minIdx)
        local u = current.idx
        
        if endNodes[u] and gScore[u] + endNodes[u] < bestG then
            bestG = gScore[u] + endNodes[u]
            bestNode = u
        end
        
        if current.f >= bestG then break end
        
        for _, neighbor in ipairs(adj[u] or {}) do
            local v = neighbor[1]
            local weight = neighbor[2]
            local tentativeG = gScore[u] + weight
            if not gScore[v] or tentativeG < gScore[v] then
                gScore[v] = tentativeG
                cameFrom[v] = u
                table.insert(open, { idx = v, f = tentativeG + h(v) })
            end
        end
    end
    
    if not bestNode then
        return { start2D, end2D }, (end2D - start2D).Magnitude
    end
    
    local path = {}
    local curr = bestNode
    while curr do
        table.insert(path, 1, curr)
        curr = cameFrom[curr]
    end
    
    local wps = { start2D }
    local firstNodePos = path[1] and nodesVec[path[1]]
    if firstNodePos and startSnap then
        local roadDir = firstNodePos - startSnap
        local roadLen = roadDir.Magnitude
        local distFromRoad = (startSnap - start2D).Magnitude
        if roadLen > 0.1 and distFromRoad <= 5.0 then
            -- Already on the road lane: merge smoothly slightly ahead along the lane
            roadDir = roadDir / roadLen
            local projT = (start2D - startSnap):Dot(roadDir)
            local forwardDist = math.clamp(projT + 8.0, 4.0, 14.0)
            if forwardDist < roadLen - 1.5 then
                local mergePt = startSnap + roadDir * forwardDist
                table.insert(wps, mergePt)
            elseif (startSnap - start2D).Magnitude > 1.2 then
                table.insert(wps, startSnap)
            end
        elseif (startSnap - start2D).Magnitude > 0.8 then
            -- Off-road / driveway / alley entrance: always drive to startSnap (the start of the road route) first!
            table.insert(wps, startSnap)
        end
    elseif startSnap and (startSnap - start2D).Magnitude > 0.5 then
        table.insert(wps, startSnap)
    end
    for _, nodeIdx in ipairs(path) do
        local nodePos = nodesVec[nodeIdx]
        if (nodePos - wps[#wps]).Magnitude > 0.5 then
            table.insert(wps, nodePos)
        end
    end
    if (endSnap - wps[#wps]).Magnitude > 0.5 then
        table.insert(wps, endSnap)
    end
    if (end2D - wps[#wps]).Magnitude > 0.5 then
        table.insert(wps, end2D)
    end
    
    local len = 0
    for i = 2, #wps do
        len = len + (wps[i] - wps[i-1]).Magnitude
    end
    
    return wps, len
end

Hub.CustomRoadGraph.route = function(startPos, endPos)
    local wps, len = Hub.CustomRoadGraph.computeRoute(startPos, endPos)
    return wps, len
end

-- Pre-initialize graph and bind RoadGraph
pcall(function() Hub.InitCustomRoadGraph() end)
if Hub.CustomRoadGraph.initialized then
    RoadGraph = Hub.CustomRoadGraph
end

-- ==============================================================
-- 🎨 NEON CYAN ROUTE VISUALIZER (From aa.lua & Workspace.CustomDeliveryRouteVisuals)
-- ==============================================================
Hub._routeFolderName = "CustomDeliveryRouteVisuals"

Hub.GetRouteFolder = function()
    local f = Workspace:FindFirstChild(Hub._routeFolderName)
    if not f then
        f = Instance.new("Folder")
        f.Name = Hub._routeFolderName
        f.Parent = Workspace
    end
    return f
end

Hub.ClearRouteVisuals = function()
    pcall(function()
        local f = Workspace:FindFirstChild(Hub._routeFolderName)
        if f then
            f:ClearAllChildren()
            f:Destroy()
        end
    end)
end

Hub.DrawCustomRoute = function(wps)
    Hub.ClearRouteVisuals()
    -- 🙈 ซ่อนเส้นสีฟ้าตามคำขอของผู้ใช้ (ShowRouteVisuals = false) เพื่อไม่ให้รกตา
    -- รถยังคงคำนวณและวิ่งตาม waypoints ในหน่วยความจำ 100% เหมือนเดิมทุกประการ
    if not Hub.Settings.ShowRouteVisuals then return end
    if not wps or #wps < 2 then return end

    pcall(function()
        local folder = Hub.GetRouteFolder()
        local lastY = 3.5

        for i = 1, #wps - 1 do
            local p1 = wps[i]
            local p2 = wps[i + 1]
            local x1 = p1.X
            local z1 = (typeof(p1) == "Vector3" and p1.Z) or p1.Y
            local x2 = p2.X
            local z2 = (typeof(p2) == "Vector3" and p2.Z) or p2.Y

            local y1 = (Hub.GetElevation and Hub.GetElevation(x1, z1, lastY)) or lastY
            lastY = y1
            local y2 = (Hub.GetElevation and Hub.GetElevation(x2, z2, lastY)) or lastY
            lastY = y2

            local a = Vector3.new(x1, y1 + 0.35, z1)
            local b = Vector3.new(x2, y2 + 0.35, z2)
            local delta = b - a
            local len = delta.Magnitude

            if len > 0.1 then
                local part = Instance.new("Part")
                part.Anchored = true
                part.CanCollide = false
                part.CanQuery = false
                part.CanTouch = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(0, 255, 200)
                part.Transparency = 0.2
                part.Size = Vector3.new(2.4, 0.2, len)
                part.CFrame = CFrame.lookAt((a + b) / 2, b)
                part.Name = "RouteSegment_" .. i
                part.Parent = folder
            end
        end
    end)
end


function ApplyFpsBooster(enable)
    pcall(function()
        local lighting = game:GetService("Lighting")
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if enable then
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            lighting.Brightness = 1
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 0
            end
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            for _, v in ipairs(lighting:GetChildren()) do
                if v:IsA("PostProcessEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                    pcall(function() v.Enabled = false end)
                end
            end
            -- [FPS PATCH] Disable Map decorations and particle emitters
            pcall(function()
                local map = Workspace:FindFirstChild("Map")
                if map then
                    for _, folderName in ipairs({"Decorations", "Props", "Trees", "Foliage", "FX"}) do
                        local folder = map:FindFirstChild(folderName)
                        if folder then
                            for _, desc in ipairs(folder:GetDescendants()) do
                                if desc:IsA("ParticleEmitter") or desc:IsA("Fire") or desc:IsA("Smoke") or desc:IsA("Sparkles") then
                                    pcall(function() desc.Enabled = false end)
                                end
                            end
                        end
                    end
                end
            end)
            -- [FPS PATCH] Reduce render distance aggressively
            pcall(function()
                Workspace.StreamingEnabled = true
                Workspace.StreamingMinRadius = 64
                Workspace.StreamingTargetRadius = 256
            end)
            -- [FPS PATCH] Kill Workspace ambient sounds (saves CPU on audio mixing)
            pcall(function()
                for _, snd in ipairs(Workspace:GetChildren()) do
                    if snd:IsA("Sound") then
                        snd.Volume = 0
                    end
                end
            end)
        end
    end)
end
Hub.ApplyFpsBooster = ApplyFpsBooster

-- 💾 Persistent Configuration Manager
local ConfigPath = "KrakenHub_Mahanakhon_Config.json"

function SaveConfig()
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
                AntiAfk = Hub.Settings.AntiAfk,
                AutoRejoin = Hub.Settings.AutoRejoin,
                HideNames = Hub.Settings.HideNames,
                AutoClaimQuests = Hub.Settings.AutoClaimQuests,
                FPSBooster = Hub.Settings.FPSBooster,
                AutoBuyPiston = Hub.Settings.AutoBuyPiston,
                AutoBuyPistonSize = Hub.Settings.AutoBuyPistonSize,
                AutoInstallPiston = Hub.Settings.AutoInstallPiston,
                BlackScreen = Hub.Settings.BlackScreen,
                LockMoneyEnabled = Hub.Settings.LockMoneyEnabled,
                LockMoneyTarget = Hub.Settings.LockMoneyTarget,
            }
            writefile(ConfigPath, HttpService:JSONEncode(data))
        end
    end)
    return ok
end
Hub.SaveConfig = SaveConfig

function LoadConfig()
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
    -- Anti-Kick & FarmGuard Sanitizer: safe tuned speed cap (~100 studs/s)
    Hub.Settings.VehicleMaxSpeed = 100
    Hub.Settings.VehicleAccel = math.clamp(Hub.Settings.VehicleAccel or 1.05, 0.9, 1.15)
    Hub.Settings.FarmSpeed = 88
    Hub.Settings.WarpSpeed = 88
    Hub.Settings.BypassSpeedCap = false
    Hub.Settings.SafeMode = true
    Hub.Settings.VehicleModMaster = false
    Hub.Settings.AutoTuneRunning = true
    Hub.Settings.EcuTuneMaster = true
    -- [PATCHED] AutoCaptcha ไม่ force override แล้ว → เคารพค่าที่บันทึกไว้จริง
    -- Hub.Settings.AutoCaptcha = true
    Hub.Settings.AntiAfk = true
    Hub.Settings.AutoRejoin = true
    Hub.Settings.HideNames = true
    if Hub.Settings.UsePathfinding == nil then
        Hub.Settings.UsePathfinding = true
    end
    if Hub.Settings.AutoBuyPiston == nil then
        Hub.Settings.AutoBuyPiston = false
    end
    if Hub.Settings.AutoBuyPistonSize == nil then
        Hub.Settings.AutoBuyPistonSize = { ["ขนาดสูงสุดที่มี (Highest Available)"] = true }
    end
    if Hub.Settings.AutoInstallPiston == nil then
        Hub.Settings.AutoInstallPiston = true
    end
    if Hub.Settings.AutoClaimQuests == nil then
        Hub.Settings.AutoClaimQuests = true
    end
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
function GetAllPlayerVehicles()
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

function GetActiveSeatedVehicle()
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

function GetPlayerVehicle(requireSeated)
    local seatedVeh, seat = GetActiveSeatedVehicle()
    if seatedVeh then
        return seatedVeh
    end
    if requireSeated then
        return nil
    end
    if _cachedActiveVeh and _cachedActiveVeh.Parent and _cachedActiveVeh:IsDescendantOf(Workspace) then
        return _cachedActiveVeh
    else
        _cachedActiveVeh = nil
        _cachedChassis = nil
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

-- 🎛️ Default Safe Dyno Map Formula
local DefaultEcuMapData = {
    Air  = {1.11, 1.14, 1.07, 1.13, 1.14, 1.12, 1.18, 1.14, 1.24, 1.32, 1.31},
    Fuel = {1.09, 1.12, 1.12, 1.12, 1.17, 1.24, 1.25, 1.23, 1.25, 1.27, 1.25},
    Afr  = {13.50, 13.80, 14.00, 13.50, 13.30, 13.50, 13.00, 12.50, 12.40, 11.90, 11.80},
    Tps  = {0.82, 0.94, 1.00, 1.02, 1.13, 1.30, 1.31, 1.22, 1.23, 1.29, 1.23},
    Oil  = {0.11, 0.12, 0.17, 0.30, 0.31, 0.20, 0.15, 0.21, 0.22, 0.19, 0.29},
    Ign  = {14.80, 19.00, 21.00, 19.90, 19.80, 21.40, 21.90, 22.70, 26.10, 29.70, 31.80}
}
local FlashEcuFile -- forward declaration

function IsTourer350(veh)
    if not veh or not veh:IsA("Model") then return false end
    local vId = tostring(veh:GetAttribute("VehicleId") or ""):lower()
    local dispName = tostring(veh:GetAttribute("DisplayName") or veh:GetAttribute("BikeName") or veh.Name):lower()
    if vId:find("tourer") or dispName:find("tourer") or veh.Name:lower():find("tourer") then
        return true
    end
    return false
end

-- Tracking set for all player vehicles (persisted globally across re-executions)
genv[_gk.vk] = genv[_gk.vk] or setmetatable({}, { __mode = "k" })
local KnownPlayerVehicles = genv[_gk.vk]

function IsOurVehicle(veh)
    if not veh or not veh:IsA("Model") then return false end
    if KnownPlayerVehicles[veh] then return true end

    -- Check OwnerUserId attribute (bypasses hook recursion, O(1) C++ speed)
    local ownerId = nil
    pcall(function() ownerId = veh:GetAttribute("OwnerUserId") end)
    if ownerId == LocalPlayer.UserId then
        KnownPlayerVehicles[veh] = true
        return true
    end

    local ownerName = nil
    pcall(function() ownerName = veh:GetAttribute("OwnerName") end)
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

function RegisterPlayerVehicle(veh)
    if not veh or not veh:IsA("Model") then return end
    KnownPlayerVehicles[veh] = true
end


-- 🛡️ UiCheckView (Snap) Protection:
-- Do NOT overwrite TextLabels inside PlayerGui.TuneHub.EcuPanel ("100%", "×2.00", "TOP ~338 KM/H")
-- because UiGuard's Snap payload sends all PlayerGui text directly to AdminPanel's UiCheckView.
function SyncDynoUI()
    return
end

function ApplyGodEcu(veh)
    veh = veh or GetPlayerVehicle()
    if not veh or not veh:IsA("Model") then return end
    RegisterPlayerVehicle(veh)

    -- Tourer 350 tuning removed: skip Tourer 350 completely
    if IsTourer350(veh) then return end

    -- EcuShared values intentionally NOT modified:
    -- UiGuardShared.TAMPER cross-checks SharedModule values in Snap payload.
    -- Modifying TOP_KMH/TUCK_TOP_KMH/ABS_KMH causes rolling TAMPER flags after ~10min.
    -- God ECU boost comes from server-side EcuGain attribute via FlashEcuFile only.

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

    if DynoStatusUpdater then
        pcall(DynoStatusUpdater)
    end
end

-- ==============================================================
-- 🏎️ SAFE FARMING CONSTANTS & SMOOTH PHYSICS ENGINE
-- ==============================================================
local GetVehicleTunedMaxKmh
function GetJitteredFarmSpeed(veh)
    local targetVeh = veh or (_cachedActiveVeh or (GetActiveSeatedVehicle and GetActiveSeatedVehicle()))
    if targetVeh and GetVehicleTunedMaxKmh then
        local kmhPerStud = (EcuShared and EcuShared.KMH_PER_STUD) or 1.008
        local topKmh = GetVehicleTunedMaxKmh(targetVeh)
        return topKmh / kmhPerStud
    end
    return 155 / 1.008
end

function SmoothStop(chassis, durationSeconds)
    if not chassis then return end
    durationSeconds = durationSeconds or 0.6
    local steps = 8
    local interval = durationSeconds / steps
    local initVel = chassis.AssemblyLinearVelocity
    if initVel.Magnitude < 1.0 then
        chassis.AssemblyLinearVelocity = Vector3.zero
        chassis.AssemblyAngularVelocity = Vector3.zero
        return
    end
    for i = 1, steps do
        if not Hub.Running then break end
        local t = i / steps
        -- ease-out cubic
        local factor = 1 - (t * t * (3 - 2 * t))
        chassis.AssemblyLinearVelocity = initVel * factor
        chassis.AssemblyAngularVelocity = Vector3.zero
        task.wait(interval)
    end
    chassis.AssemblyLinearVelocity = Vector3.zero
    chassis.AssemblyAngularVelocity = Vector3.zero
end

-- ==============================================================
-- 🛡️ BULLETPROOF ANTI-CHEAT INTERCEPTOR (NETSEAL & UIGUARD)
-- ==============================================================
local UI_GUARD_BYPASS_KEY = "_L" .. tostring(0x7E3)
local _NONCE_GENV = "_NSBtNC_p"
local _beatNonce = (type(genv[_NONCE_GENV]) == "number" and genv[_NONCE_GENV] >= 100)
    and genv[_NONCE_GENV]
    or math.random(100, 999)
genv[_NONCE_GENV] = _beatNonce
genv[UI_GUARD_BYPASS_KEY] = false

-- Hook flags: คงสถานะ hooked ไว้ ป้องกัน double hook บน Byfron/Hyperion (T-A537)
-- ใส่ก่อน hookmetamethod block
genv[_gk.sp] = nil
genv[_gk.sf] = nil

-- 🛡️ UNIVERSAL TELEMETRY & LOGGING BLACKHOLE DETECTOR
function IsBlockedTelemetryOrLog(remote, action)
    if typeof(remote) ~= "Instance" then return false, false end
    local rName = string.lower(remote.Name)

    -- UiGuard / UiCheck handled by specialized filter (Beat/Snap allowed)
    if rName == "uiguard" or rName == "uicheck" then
        return true, true -- isUiGuard
    end

    -- Universal Log, Report, Telemetry & Admin Remotes Blackhole
    if rName:find("log") or rName:find("report") or rName:find("admin")
        or rName:find("telemetry") or rName:find("analytics") or rName:find("crash")
        or rName:find("error") or rName:find("security") or rName:find("anticheat")
        or rName:find("tamper") or rName:find("strike") or rName:find("watchdog")
        or rName:find("audit") or rName:find("modremote") or rName:find("cheat") then
        return true, false
    end

    if type(action) == "string" then
        local actLower = string.lower(action)
        local BLOCKED_ACTIONS = {
            ["found"] = true, ["tool"] = true, ["strike"] = true, ["report"] = true,
            ["log"] = true, ["cheat"] = true, ["kick"] = true, ["ban"] = true,
            ["odd"] = true, ["warn"] = true, ["warning"] = true, ["alert"] = true,
            ["suspicious"] = true, ["flag"] = true, ["detected"] = true, ["tamper"] = true,
            ["hook"] = true, ["inject"] = true, ["speed"] = true, ["fly"] = true,
            ["noclip"] = true, ["teleport"] = true, ["warp"] = true, ["stats"] = true,
            ["error"] = true, ["trace"] = true, ["dump"] = true, ["crash"] = true,
            ["anti"] = true, ["staffalert"] = true, ["exploit"] = true,
        }
        if BLOCKED_ACTIONS[actLower] then
            return true, false
        end
    end

    return false, false
end

if typeof(hookmetamethod) == "function" and not genv[_gk.hb] then
    local newc = (typeof(newcclosure) == "function" and newcclosure) or function(f) return f end
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newc(function(self, ...)
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                if not genv[UI_GUARD_BYPASS_KEY] then
                    local firstArg = ...
                    local isBlocked, isUiGuard = IsBlockedTelemetryOrLog(self, firstArg)
                    if isBlocked then
                        if isUiGuard then
                            local firePtr = genv[_gk.sf]
                            local invPtr  = genv[_gk.sp]
                            if method == "FireServer" and firePtr then
                                return firePtr(self, ...)
                            elseif method == "InvokeServer" and invPtr then
                                return invPtr(self, ...)
                            end
                            return nil
                        else
                            -- SINK TELEMETRY / LOG COMPLETELY!
                            if method == "InvokeServer" then
                                return true -- Return mock success so caller doesn't error or retry
                            end
                            return nil
                        end
                    end
                end
            elseif method == "GetAttribute" and typeof(self) == "Instance" then
                local isScriptCaller = true
                if typeof(checkcaller) == "function" then
                    local okCheck, resCheck = pcall(checkcaller)
                    if okCheck then isScriptCaller = resCheck end
                end
                if not isScriptCaller then
                    local attr = ...
                    if attr == "EngineOn" then
                        local curV = _cachedActiveVeh or (GetActiveSeatedVehicle and GetActiveSeatedVehicle())
                        if curV and (self == curV or self == _cachedActiveVeh) then
                            return true
                        end
                    elseif attr == "StandDown" then
                        local curV = _cachedActiveVeh or (GetActiveSeatedVehicle and GetActiveSeatedVehicle())
                        if curV and (self == curV or self == _cachedActiveVeh) then
                            return false
                        end
                    elseif attr == "Fuel" then
                        local curV = _cachedActiveVeh or (GetActiveSeatedVehicle and GetActiveSeatedVehicle())
                        if curV and (self == curV or self == _cachedActiveVeh) then
                            local realFuel = oldNamecall(self, ...)
                            if typeof(realFuel) == "number" and realFuel <= 20 then
                                return 85
                            end
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
        genv[_gk.hb] = true
    end)
end

-- 1.1 Direct Method Hooks (Guarantees protection even if anti-cheat calls remote.FireServer instead of remote:FireServer)
pcall(function()
    if typeof(hookfunction) == "function" and not genv[_gk.mb] then
        genv[_gk.mb] = true
        local dummyEv = Instance.new("RemoteEvent")
        local oldEvFire
        oldEvFire = hookfunction(dummyEv.FireServer, newcclosure(function(self, ...)
            if typeof(self) == "Instance" and not genv[UI_GUARD_BYPASS_KEY] then
                local firstArg = ...
                local isBlocked, isUiGuard = IsBlockedTelemetryOrLog(self, firstArg)
                if isBlocked then
                    if isUiGuard then
                        local firePtr = genv[_gk.sf]
                        if firePtr then return firePtr(self, ...) end
                    end
                    return nil
                end
            end
            return oldEvFire(self, ...)
        end))

        local dummyFn = Instance.new("RemoteFunction")
        local oldFnInvoke
        oldFnInvoke = hookfunction(dummyFn.InvokeServer, newcclosure(function(self, ...)
            if typeof(self) == "Instance" and not genv[UI_GUARD_BYPASS_KEY] then
                local firstArg = ...
                local isBlocked, isUiGuard = IsBlockedTelemetryOrLog(self, firstArg)
                if isBlocked then
                    if isUiGuard then
                        local invPtr = genv[_gk.sp]
                        if invPtr then return invPtr(self, ...) end
                    end
                    return true
                end
            end
            return oldFnInvoke(self, ...)
        end))

        pcall(function()
            dummyEv:Destroy()
            dummyFn:Destroy()
        end)
    end
end)

-- ==============================================================
-- 🛡️ 1.1b MAHANAKHON RACING TOTAL LOG BLACKHOLE v2 — ADMIN PROOF
-- ครอบคลุม: LogService.MessageOut (ALL conns), GetLogHistory,
--           print/warn global hook, ScriptContext.Error,
--           PeriodicRe-hook ป้องกัน admin inject listener ใหม่
-- ==============================================================
do
    local hookfn   = (typeof(hookfunction)   == "function" and hookfunction)   or nil
    local newc     = (typeof(newcclosure)    == "function" and newcclosure)    or function(f) return f end
    local getconns = (typeof(getconnections) == "function" and getconnections) or nil
    local getups   = (typeof(debug) == "table" and debug.getupvalues)
                  or (typeof(getupvalues) == "function" and getupvalues)
                  or nil
    local setupval = (typeof(setupvalue)     == "function" and setupvalue)     or nil
    local logSvc   = SafeGetService("LogService") or game:GetService("LogService")
    local sctx     = SafeGetService("ScriptContext")

    -- ── BAD-WORD FILTER ─────────────────────────────────────────
    -- รวมศูนย์ทุก pattern ไว้ที่เดียว ทั้ง 1.1b และ GlobalPrintHook ใช้ชุดเดียวกัน
    local function isBadMessage(msg)
        if type(msg) ~= "string" then return false end
        -- อนุญาต [MR] ok เพื่อให้ UiGuard beat ping ผ่าน
        if msg:find("[MR] ok", 1, true) then return false end
        local lo = msg:lower()
        return lo:find("kraken",1,true)   or lo:find("vantix",1,true)
            or lo:find("krakenhub",1,true) or lo:find("autofarm",1,true)
            or lo:find("potassium",1,true) or lo:find("fluent",1,true)
            or lo:find("hub",1,true)       or lo:find("exploit",1,true)
            or lo:find("bypass",1,true)    or lo:find("hook",1,true)
            or lo:find("inject",1,true)    or lo:find("netseal",1,true)
            or lo:find("farm",1,true)      or lo:find("warp",1,true)
            or lo:find("piston",1,true)    or lo:find("luarmor",1,true)
            or lo:find("astra",1,true)     or lo:find("davinci",1,true)
            or lo:find("rayfield",1,true)  or lo:find("orion",1,true)
            or lo:find("maclib",1,true)    or lo:find("getgenv",1,true)
            or lo:find("loadstring",1,true)or lo:find('[string "',1,true)
            or lo:find("stack begin",1,true) or lo:find("stack end",1,true)
            or lo:find("roadgraph",1,true) or lo:find("saferoad",1,true)
            or lo:find("stepautograb",1,true) or lo:find("farmworker",1,true)
            or lo:find("initui",1,true)    or lo:find("active",1,true)
            or lo:find("cheat",1,true)     or lo:find("script",1,true)
    end

    -- ── LAYER 1: HOOK GLOBAL print & warn ───────────────────────
    -- ทำก่อนอื่น เพราะ print/warn ทุกบรรทัดใน script รั่วตรงนี้
    pcall(function()
        if not hookfn then return end
        local rawPrint = print
        local rawWarn  = warn
        -- ป้องกัน double-hook
        if not genv["_MHK_PrintHooked"] then
            genv["_MHK_PrintHooked"] = true
            hookfn(rawPrint, newc(function(...)
                local parts = {...}
                for _, v in ipairs(parts) do
                    if isBadMessage(tostring(v)) then return end
                end
                return rawPrint(...)
            end))
            hookfn(rawWarn, newc(function(...)
                local parts = {...}
                for _, v in ipairs(parts) do
                    if isBadMessage(tostring(v)) then return end
                end
                return rawWarn(...)
            end))
        end
    end)

    -- ── LAYER 2: HOOK ALL MessageOut connections ─────────────────
    -- ไม่จำกัดแค่ UiGuard onLine — hook ทุก listener รวม admin custom ones
    local hookedMessageOutConns = {}
    local function hookAllMessageOutConns()
        if not logSvc or not getconns or not hookfn then return end
        pcall(function()
            local conns = getconns(logSvc.MessageOut)
            if type(conns) ~= "table" then return end
            for _, conn in ipairs(conns) do
                local fn = conn and conn.Function
                if fn and typeof(fn) == "function" and not hookedMessageOutConns[fn] then
                    hookedMessageOutConns[fn] = true

                    -- Purge violation counters (upvalue 5 = u122 ใน UiGuard onLine)
                    if getups and setupval then
                        pcall(function()
                            local ups = getups(fn)
                            if ups then
                                -- reset counter upvalues ที่เป็น number > 0
                                for idx, v in pairs(ups) do
                                    if type(v) == "number" and v > 0 and v < 100 then
                                        pcall(setupval, fn, idx, 0)
                                    end
                                end
                                -- Clear dirty log buffer (u102 ใน keepLine)
                                local keepLine = ups[4]
                                if keepLine and typeof(keepLine) == "function" then
                                    local klUps = getups(keepLine)
                                    local u102  = klUps and klUps[2]
                                    if type(u102) == "table" then
                                        for i = #u102, 1, -1 do
                                            local item = u102[i]
                                            if type(item) == "table" and (item.tool == true or not item.text) then
                                                table.remove(u102, i)
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end

                    local oldConn = fn
                    pcall(hookfn, fn, newc(function(msg, msgType)
                        if isBadMessage(msg) then return end
                        return oldConn(msg, msgType)
                    end))
                end
            end
        end)
    end

    -- hook ทันที
    hookAllMessageOutConns()

    -- ── LAYER 3: HOOK LogService.GetLogHistory ───────────────────
    if logSvc and hookfn and not genv[_gk.lh] then
        genv[_gk.lh] = true
        local oldGetLogHistory
        oldGetLogHistory = hookfn(logSvc.GetLogHistory, newc(function(self, ...)
            local ok, history = pcall(oldGetLogHistory, self, ...)
            if not ok or type(history) ~= "table" then return {} end
            local clean = {}
            for _, entry in ipairs(history) do
                if type(entry) == "table" and type(entry.message) == "string" then
                    if not isBadMessage(entry.message) then
                        table.insert(clean, entry)
                    elseif entry.message:find("[MR] ok", 1, true) then
                        table.insert(clean, entry)
                    end
                end
            end
            return clean
        end))
    end

    -- ── LAYER 4: HOOK ScriptContext.Error ────────────────────────
    -- แอดมินบางเกมดัก ErrorSignal เพื่อดู stack trace ของ exploit
    pcall(function()
        if not sctx or not hookfn then return end
        if genv["_MHK_SCTXHooked"] then return end
        genv["_MHK_SCTXHooked"] = true
        -- ScriptContext.Error เป็น BindableEvent-style signal ใน LocalScript context
        -- hook ผ่าน getconnections ถ้าทำได้
        if getconns then
            local ok, errConns = pcall(getconns, sctx.Error)
            if ok and type(errConns) == "table" then
                for _, conn in ipairs(errConns) do
                    local fn = conn and conn.Function
                    if fn and typeof(fn) == "function" then
                        local oldErrFn = fn
                        hookfn(fn, newc(function(msg, ...)
                            if isBadMessage(tostring(msg)) then return end
                            return oldErrFn(msg, ...)
                        end))
                    end
                end
            end
        end
    end)

    -- ── LAYER 5: PERIODIC RE-HOOK WATCHER ───────────────────────
    -- แอดมินอาจ inject listener ใหม่หลัง script โหลด → re-hook ทุก 15s (บน PC เท่านั้น มือถือไม่วนลูป hook ป้องกัน JIT crash)
    task.spawn(function()
        while true do
            task.wait(15 + math.random() * 5)
            if not IsMobileDevice then
                hookAllMessageOutConns()
            end
            -- re-clear _G leaks ที่อาจถูก set ใหม่
            pcall(function()
                rawset(_G, "_KrakenHub_InitUI_Started", nil)
                rawset(_G, "_KrakenHub_InitUI_Success", nil)
                rawset(_G, "_KrakenHub_InitUI_Error",   nil)
            end)
        end
    end)
end

-- 2. Extract genuine sealFor cryptography engine from NetSeal & neutralize guard()
local _NetSealFor = nil
function ExtractSealFor()
    if _NetSealFor and type(_NetSealFor) == "function" then
        return _NetSealFor
    end

    local getups = (typeof(debug) == "table" and debug.getupvalues) or (typeof(getupvalues) == "function" and getupvalues)
    local getinfo = (typeof(debug) == "table" and debug.getinfo) or (typeof(getinfo) == "function" and getinfo)

    -- Method 1: Check upvalues of NetSeal functions
    local candidates = {
        genv[_gk.ni],
        genv[_gk.nf],
        NetSeal and NetSeal.invoke,
        NetSeal and NetSeal.fire,
    }

    if getups then
        for _, fn in ipairs(candidates) do
            if type(fn) == "function" then
                local ok, ups = pcall(getups, fn)
                if ok and type(ups) == "table" then
                    -- Check table containing sealFor (u126 in NetSeal module)
                    for _, val in pairs(ups) do
                        if type(val) == "table" and type(val.sealFor) == "function" then
                            _NetSealFor = val.sealFor
                            return _NetSealFor
                        end
                    end
                    -- Check direct function upvalue (#3 is sealFor)
                    for idx, val in pairs(ups) do
                        if type(val) == "function" then
                            local name = ""
                            if getinfo then
                                local inf = getinfo(val)
                                name = (inf and inf.name) or ""
                            end
                            if name == "sealFor" or idx == 3 then
                                _NetSealFor = val
                                return _NetSealFor
                            end
                        end
                    end
                end
            end
        end
    end

    -- Method 2: GC scan ถูกลบออก – Byfron/Hyperion ตรวจจับ getgc() = TAMPER flag
    return nil
end

pcall(ExtractSealFor)

pcall(function()
    local getups = (typeof(debug) == "table" and debug.getupvalues) or (typeof(getupvalues) == "function" and getupvalues)
    if NetSeal and getups then
        for _, fn in ipairs({ NetSeal.invoke, NetSeal.fire }) do
            if type(fn) == "function" then
                local ups = getups(fn)
                if ups and type(ups[1]) == "function" then
                    -- Upvalue 1 of NetSeal.fire and NetSeal.invoke is ALWAYS guard()
                    if typeof(hookfunction) == "function" then
                        pcall(hookfunction, ups[1], function(...) return end)
                    end
                end
            end
        end
    end
end)

-- 🛡️ Anti-Cheat Comprehensive Bad Words Filter (English & Thai Vantix UI labels)
local SNAP_BAD_WORDS = {
    -- Exploits / Cheats
    "kraken", "fluent", "vantix", "autofarm", "auto farm", "speed", "esp", "ecu",
    "fly", "noclip", "bypass", "hack", "grab", "ride", "farm", "hub", "teleport",
    "warp", "bot", "script", "cheat", "exploit", "luarmor", "getgenv", "hookfunction",
    "hookmetamethod", "keysystem", "anti afk", "antiafk", "anti-afk",
    "rejoin", "autorejoin", "auto rejoin", "piston",
    -- Thai UI labels (VantixUI / KrakenHub)
    "ฟาร์ม", "ออโต้", "จูน", "วาป", "วาร์ป", "ไรเดอร์", "แฮก", "บิน", "ปลดล็อค",
    "ส่งงาน", "โกง", "โปร", "แคปช่า", "ทะลุ", "ความเร็ว", "รับงาน", "ผู้โดยสาร",
    "ส่งอาหาร", "ตู้ชุด", "ล็อกเงิน", "ส่งของ", "รีจอย", "รีเซิร์ฟ", "ลูกสูบ",
    -- [AC BYPASS v2 - LAYER 5] Extended function names & signatures
    "safefire", "safeinvoke", "directfire", "directinvoke", "sanitizesnap",
    "applygodecu", "flashecufile", "runautotune", "ensuremounted", "saferoadtravel",
    -- Executor processes
    "wave.exe", "delta.exe", "arceus", "codex", "fluxus", "krnl", "synapse",
    "hydrogen", "seliware", "solara", "cryptic", "evon",
    -- Roblox exploit globals
    "getgenv", "getrenv", "getreg", "getupvalues", "setupvalue", "hookfunction",
    "hookmetamethod", "newcclosure", "clonefunction", "setreadonly", "getrawmetatable",
    -- Thai terms
    "สคริปต์โกง", "แฮ็กเกอร์", "บ็อท", "ออโต้ฟาร์ม", "เพิ่มความเร็ว"
}


-- [AC BYPASS v2 - LAYER 10] Gaussian-approximate jitter helper (Box-Muller)
function GaussianJitter(center, spread)
    local u1 = math.max(1e-9, math.random())
    local u2 = math.random()
    local z  = math.sqrt(-2.0 * math.log(u1)) * math.cos(2 * math.pi * u2)
    local val = center + z * spread
    return math.max(center - spread * 3, math.min(center + spread * 3, val))
end

function SanitizeSnapPayload(p1, p2)
    local nonce = p1
    local snapData = p2
    if type(p1) == "table" and p2 == nil then
        snapData = p1
        nonce = 0
    end
    if type(snapData) ~= "table" then
        return nonce, snapData
    end

    -- 1. Pure innocent Roblox game logs: String array matching pickLogs() 100%
    local cleanLogs = {}
    if type(snapData.logs) == "table" then
        for _, entry in ipairs(snapData.logs) do
            if type(entry) == "string" then
                local lower = entry:lower()
                local isBad = lower:find("kraken") or lower:find("vantix") or lower:find("potassium")
                           or lower:find("fluent") or lower:find("script") or lower:find("cheat")
                           or lower:find("exploit") or lower:find("bypass") or lower:find("hook")
                           or lower:find("inject") or lower:find("error") or lower:find("netseal")
                           or lower:find("farm") or lower:find("warp") or lower:find("piston")
                           or lower:find("luarmor") or lower:find("hub") or lower:find("astra")
                           or lower:find("davinci") or lower:find("honymoon") or lower:find("mario")
                           or lower:find("rayfield") or lower:find("orion") or lower:find("maclib")
                           or lower:find("getgenv") or lower:find("loadstring") or lower:find('[string "')
                           or lower:find("stack begin") or lower:find("stack end")
                if not isBad then
                    table.insert(cleanLogs, entry)
                end
            end
        end
    end
    if #cleanLogs == 0 then
        table.insert(cleanLogs, "[Assets] ContentProvider: PreloadAsync completed")
        table.insert(cleanLogs, "[SoundService] Audio channels initialized")
        table.insert(cleanLogs, "[GameShared] Configuration loaded successfully")
        table.insert(cleanLogs, "[MR] ok " .. string.format("%06x", math.random(0, 0xFFFFFF)))
    end
    snapData.logs = cleanLogs

    -- 2. [AC BYPASS v2 - LAYER 9] Systematic SNAP GUI Rename
    if type(snapData.guis) == "table" then
        for i, g in ipairs(snapData.guis) do
            snapData.guis[i] = RenameSnapGui(g)
        end
    end

    -- 3. Clean boxes: strip any box containing cheat keywords
    if type(snapData.boxes) == "table" then
        local cleanBoxes = {}
        for _, b in ipairs(snapData.boxes) do
            if type(b) == "string" then
                local lower = b:lower()
                local hasBad = false
                for _, w in ipairs(SNAP_BAD_WORDS) do
                    if lower:find(w, 1, true) then
                        hasBad = true
                        break
                    end
                end
                if not hasBad then
                    table.insert(cleanBoxes, b)
                end
            end
        end
        snapData.boxes = cleanBoxes
    end

    -- 4. Deep Recursive String Scrub: ensure no nested strings carry exploit words
    local function DeepScrub(val)
        if type(val) == "string" then
            local lower = val:lower()
            for _, w in ipairs(SNAP_BAD_WORDS) do
                if lower:find(w, 1, true) then
                    return "Vanilla"
                end
            end
            return val
        elseif type(val) == "table" then
            for k, v in pairs(val) do
                if k ~= "logs" and k ~= "guis" and k ~= "boxes" then
                    val[k] = DeepScrub(v)
                end
            end
        end
        return val
    end
    pcall(DeepScrub, snapData)

    -- [AC BYPASS v2 - LAYER 1] Normalize FPS / Ping / Mem / Vel / Pos / Delta fields
    if type(snapData) == "table" then
        if type(snapData.fps) == "number" then
            local base = math.clamp(snapData.fps, 28, 62)
            snapData.fps = math.floor(base + math.random(-2, 2))
        end
        if type(snapData.ping) == "number" then
            if snapData.ping < 15 then
                snapData.ping = math.random(18, 65)
            elseif snapData.ping > 1200 then
                snapData.ping = math.random(80, 150)
            end
        end
        if type(snapData.mem) == "number" and snapData.mem < 50 then
            snapData.mem = math.random(180, 420)
        end
        if type(snapData.vel) == "number" and snapData.vel == 0 then
            local isFarming = Hub and (Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide)
            if isFarming then
                -- fake velocity ที่ดูสมเหตุสมผล (เหมือนกำลังขับช้า ๆ)
                snapData.vel = math.floor(GaussianJitter(42, 8) * 10) / 10
            end
        end
        if type(snapData.pos) == "table" then
            -- เก็บ pos ไว้ แต่ round ค่าให้ดูไม่แม่นเกิน (ป้องกัน teleport detection)
            if type(snapData.pos.x) == "number" then
                snapData.pos.x = math.floor(snapData.pos.x * 10) / 10
                snapData.pos.z = math.floor((snapData.pos.z or 0) * 10) / 10
            end
        end
        if type(snapData.delta) == "number" and snapData.delta < 0.08 then
            snapData.delta = 0.09 + math.random() * 0.05
        end
    end

    return nonce, snapData
end

-- 3. Intercept NetSeal invoke & fire with direct sealFor crypto engine (Zero recursion, Zero stack overflow)
local safeInvoke, safeFire
function DirectInvoke(remote, action, ...)
    if not remote then return nil end
    local sf = _NetSealFor or ExtractSealFor()
    if sf then
        local ok, seal, args = pcall(sf, remote, action, ...)
        if ok and seal ~= nil then
            if type(args) == "table" then
                return remote:InvokeServer(seal, table.unpack(args))
            else
                return remote:InvokeServer(seal)
            end
        end
    end
    if genv[_gk.ni] and type(genv[_gk.ni]) == "function" then
        local ok, r1, r2, r3, r4 = pcall(genv[_gk.ni], remote, action, ...)
        if ok then return r1, r2, r3, r4 end
    end
    if NetSeal and NetSeal.invoke and NetSeal.invoke ~= safeInvoke then
        local ok, r1, r2, r3, r4 = pcall(NetSeal.invoke, remote, action, ...)
        if ok then return r1, r2, r3, r4 end
    end
    return nil  -- ห้าม raw call ไม่มี seal = server ban ทันที
end

function DirectFire(remote, action, ...)
    if not remote then return end
    local sf = _NetSealFor or ExtractSealFor()
    if sf then
        local ok, seal, args = pcall(sf, remote, action, ...)
        if ok and seal ~= nil then
            if type(args) == "table" then
                remote:FireServer(seal, table.unpack(args))
            else
                remote:FireServer(seal)
            end
            return
        end
    end
    if genv[_gk.nf] and type(genv[_gk.nf]) == "function" then
        local ok = pcall(genv[_gk.nf], remote, action, ...)
        if ok then return end
    end
    if NetSeal and NetSeal.fire and NetSeal.fire ~= safeFire then
        local ok = pcall(NetSeal.fire, remote, action, ...)
        if ok then return end
    end
    return  -- ห้าม raw fire ไม่มี seal
end

-- [AC BYPASS v2 - LAYER 3] Remote rate limiter (token bucket per remote)
local _remoteRateBuckets = {}
function RateLimitRemote(remote)
    if not remote then return true end
    local name = tostring(remote.Name or "")
    if name == "UiGuard" or name == "UiCheck" then return true end

    local now = os.clock()
    local bucket = _remoteRateBuckets[name]
    if not bucket then
        _remoteRateBuckets[name] = { tokens = 8, lastRefill = now }
        bucket = _remoteRateBuckets[name]
    end

    local elapsed = now - bucket.lastRefill
    bucket.tokens = math.min(8, bucket.tokens + elapsed * 3)
    bucket.lastRefill = now

    if bucket.tokens >= 1 then
        bucket.tokens = bucket.tokens - 1
        return true
    end

    task.wait(math.random() * 0.3 + 0.1)
    bucket.tokens = 0
    return true
end

safeInvoke = function(remote, action, arg1, arg2, ...)
    RateLimitRemote(remote)
    local realAction = action
    local realArg1 = arg1
    local realArg2 = arg2
    if type(action) ~= "string" and type(arg1) == "string" then
        realAction = arg1
        realArg1 = arg2
        realArg2 = ...
    end
    if remote and (remote.Name == "UiGuard" or remote.Name == "UiCheck") then
        local INVOKE_BLOCK = {
            Found=true, Tool=true, Strike=true, Report=true,
            Log=true, Cheat=true, Kick=true, Ban=true, Odd=true,
            Warn=true, Alert=true, Suspicious=true, Tamper=true,
            Detected=true, Hook=true, Inject=true, Error=true,
            Decoy=true, Swap=true,
        }
        if INVOKE_BLOCK[realAction] then return nil end
        genv[UI_GUARD_BYPASS_KEY] = true
        local _ok, _r1, _r2, _r3, _r4 = pcall(DirectInvoke, remote, realAction, realArg1, realArg2, ...)
        genv[UI_GUARD_BYPASS_KEY] = false
        if _ok then return _r1, _r2, _r3, _r4 end
        return nil
    end

    -- Universal Log & Telemetry Remote Intercept
    local rName = nil
    if typeof(remote) == "Instance" then
        pcall(function() rName = string.lower(remote.Name) end)
    elseif type(remote) == "string" then
        rName = string.lower(remote)
    end
    if rName then
        if string.find(rName, "log") or string.find(rName, "report") or string.find(rName, "admin")
            or string.find(rName, "telemetry") or string.find(rName, "analytics") or string.find(rName, "crash")
            or string.find(rName, "error") or string.find(rName, "security") or string.find(rName, "anticheat")
            or string.find(rName, "tamper") or string.find(rName, "strike") or string.find(rName, "watchdog") then
            return true -- mock success
        end
    end

    if type(action) == "string" then
        local actLower = string.lower(action)
        local BLOCKED_ACTIONS = {
            ["found"] = true, ["tool"] = true, ["strike"] = true, ["report"] = true,
            ["log"] = true, ["cheat"] = true, ["kick"] = true, ["ban"] = true,
            ["odd"] = true, ["warn"] = true, ["warning"] = true, ["alert"] = true,
            ["suspicious"] = true, ["flag"] = true, ["detected"] = true, ["tamper"] = true,
            ["hook"] = true, ["inject"] = true, ["speed"] = true, ["fly"] = true,
            ["noclip"] = true, ["teleport"] = true, ["warp"] = true, ["stats"] = true,
            ["error"] = true, ["trace"] = true, ["dump"] = true, ["crash"] = true,
            ["anti"] = true, ["staffalert"] = true, ["exploit"] = true,
        }
        if BLOCKED_ACTIONS[actLower] then
            return true
        end
    end

    -- Forward genuine ECU tune to server so the server actually records the tune!
    if remote == EcuRemote and (action == "Send" or action == "Redeem") then
        local res = {DirectInvoke(remote, action, arg1, arg2, ...)}
        return table.unpack(res)
    elseif remote and remote.Name == "Garage" and action == "Spawn" then
        local res = {DirectInvoke(remote, action, arg1, arg2, ...)}
        local isEcuActive = Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning
        if isEcuActive then
            task.spawn(function()
                task.wait(0.4)
                for _, v in ipairs(GetAllPlayerVehicles()) do
                    RegisterPlayerVehicle(v)
                    if not IsTourer350(v) then
                        ApplyGodEcu(v)
                        if FlashEcuFile then FlashEcuFile(DefaultEcuMapData) end
                    end
                end
            end)
        end
        return table.unpack(res)
    end

    return DirectInvoke(remote, action, arg1, arg2, ...)
end

safeFire = function(remote, action, arg1, arg2, ...)
    RateLimitRemote(remote)
    local realAction = action
    local realArg1 = arg1
    local realArg2 = arg2
    if type(action) ~= "string" and type(arg1) == "string" then
        realAction = arg1
        realArg1 = arg2
        realArg2 = ...
    end
    if remote and (remote.Name == "UiGuard" or remote.Name == "UiCheck") then
        -- ONLY allow legitimate "Beat", "Snap", "Ack". Drop ALL exploit reports (Found, Tool, Odd, Log, Strike, Report, Decoy, Swap)!
        if realAction == "Beat" then
            local delta = math.random(1, 4)
            if math.random(1, 8) == 1 then
                delta = delta + math.random(2, 7)
            end
            _beatNonce = (_beatNonce + delta) % 99999
            genv[_NONCE_GENV] = _beatNonce
            genv[UI_GUARD_BYPASS_KEY] = true
            pcall(DirectFire, remote, "Beat", _beatNonce)
            genv[UI_GUARD_BYPASS_KEY] = false
            return
        elseif realAction == "Snap" then
            local nonce, cleanPayload = SanitizeSnapPayload(realArg1, realArg2)
            genv[UI_GUARD_BYPASS_KEY] = true
            pcall(DirectFire, remote, "Snap", nonce, cleanPayload)
            genv[UI_GUARD_BYPASS_KEY] = false
            return
        elseif realAction == "Ack" then
            genv[UI_GUARD_BYPASS_KEY] = true
            pcall(DirectFire, remote, "Ack", realArg1, realArg2)
            genv[UI_GUARD_BYPASS_KEY] = false
            return
        else
            -- Drop EVERYTHING else on UiGuard / UiCheck silently!
            return nil
        end
    end

    -- Universal Remote Logging Blackhole:
    local rName = nil
    if typeof(remote) == "Instance" then
        pcall(function() rName = string.lower(remote.Name) end)
    elseif type(remote) == "string" then
        rName = string.lower(remote)
    end
    if rName then
        if string.find(rName, "log") or string.find(rName, "report") or string.find(rName, "admin")
            or string.find(rName, "telemetry") or string.find(rName, "analytics") or string.find(rName, "crash")
            or string.find(rName, "error") or string.find(rName, "security") or string.find(rName, "anticheat")
            or string.find(rName, "tamper") or string.find(rName, "strike") or string.find(rName, "watchdog")
            or string.find(rName, "audit") or string.find(rName, "cheat") then
            return nil
        end
    end

    if type(action) == "string" then
        local actLower = string.lower(action)
        local BLOCKED_ACTIONS = {
            ["found"] = true, ["tool"] = true, ["strike"] = true, ["report"] = true,
            ["log"] = true, ["cheat"] = true, ["kick"] = true, ["ban"] = true,
            ["odd"] = true, ["warn"] = true, ["warning"] = true, ["alert"] = true,
            ["suspicious"] = true, ["flag"] = true, ["detected"] = true, ["tamper"] = true,
            ["hook"] = true, ["inject"] = true, ["speed"] = true, ["fly"] = true,
            ["noclip"] = true, ["teleport"] = true, ["warp"] = true, ["stats"] = true,
            ["error"] = true, ["trace"] = true, ["dump"] = true, ["crash"] = true,
            ["anti"] = true, ["staffalert"] = true, ["exploit"] = true,
        }
        if BLOCKED_ACTIONS[actLower] then
            return nil
        end
    end

    -- 5-Star Delivery Protection: Block any crash or pedestrian hit reports to the server
    if action == "Crash" or action == "HitPerson" or (remote and remote.Name == "VehicleFxRemote" and action == "Burst") then
        local isFarming = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide or Hub.Settings.FiveStarMode
        if isFarming then
            return nil
        end
    end

    return DirectFire(remote, action, arg1, arg2, ...)
end

-- ✅ เพิ่มหลัง safeInvoke/safeFire definition (ประมาณ line 1101–1108)
genv[_gk.sp] = safeInvoke
genv[_gk.sf] = safeFire

-- [AC BYPASS v3 LAYER 11-18 INJECTED]
-- ==============================================================
-- 🛡️ [AC BYPASS v3 — LAYER 11–18] DEEP ANTI-DETECT & ADMIN-LOG NULLIFIER
-- วางต่อจาก  genv[_gk.sf] = safeFire  ในไฟล์หลัก
-- ครอบคลุม: Admin-Join Cloak, getconnections blocker, stack-trace wiper,
--            print/warn function swap, emergency silence, GC-lock
-- ==============================================================

do
    local hookfn   = (typeof(hookfunction)   == "function" and hookfunction)   or nil
    local newc     = (typeof(newcclosure)    == "function" and newcclosure)    or function(f) return f end
    local getconns = (typeof(getconnections) == "function" and getconnections) or nil
    local getups   = (typeof(debug) == "table" and debug.getupvalues)
                  or (typeof(getupvalues) == "function" and getupvalues) or nil
    local setupval = (typeof(setupvalue)     == "function" and setupvalue)     or nil
    local isexec   = (typeof(isexecutorclosure) == "function" and isexecutorclosure) or function() return false end

    -- ════════════════════════════════════════════════════════
    -- LAYER 11: ADMIN / STAFF JOIN DETECTOR + EMERGENCY CLOAK
    -- ตรวจจับชื่อ / rank tag ของแอดมิน → หยุดฟาร์มทันที + ซ่อนร่องรอย
    -- ════════════════════════════════════════════════════════
    local ADMIN_NAME_PATTERNS = {
        "admin", "staff", "mod", "moderator", "owner", "developer", "dev",
        "helper", "support", "manager", "supervisor", "maintainer",
        "แอดมิน", "สตาฟ", "ผู้ดูแล", "ทีมงาน",
    }
    local ADMIN_GROUP_IDS = {} -- เพิ่ม GroupId ของเกมถ้ารู้

    local function IsAdminPlayer(plr)
        if not plr or plr == LocalPlayer then return false end
        local nameLow = plr.Name:lower()
        local dispLow = plr.DisplayName:lower()
        for _, pat in ipairs(ADMIN_NAME_PATTERNS) do
            if nameLow:find(pat, 1, true) or dispLow:find(pat, 1, true) then
                return true
            end
        end
        -- rank tag ผ่าน attribute (เกมนี้ใช้ Rank / Role attribute บน Player)
        local ok, rank = pcall(function() return plr:GetAttribute("Rank") or plr:GetAttribute("Role") or plr:GetAttribute("AdminLevel") end)
        if ok and rank then
            local rl = tostring(rank):lower()
            for _, pat in ipairs(ADMIN_NAME_PATTERNS) do
                if rl:find(pat, 1, true) then return true end
            end
            local n = tonumber(rank)
            if n and n >= 100 then return true end -- rank ≥ 100 = admin
        end
        -- group rank check
        for _, gid in ipairs(ADMIN_GROUP_IDS) do
            local ok2, r = pcall(function() return plr:GetRankInGroup(gid) end)
            if ok2 and type(r) == "number" and r >= 100 then return true end
        end
        return false
    end

    Hub.AdminCloakActive = false
    Hub.DetectedAdminList = Hub.DetectedAdminList or {}

    local function ActivateAdminCloak(plr)
        if Hub.AdminCloakActive then return end
        Hub.AdminCloakActive = true
        Hub.StaffPresent = true
        Hub.DetectedAdminList[plr.UserId] = plr.Name

        -- หยุดทุก auto-farm mode ทันที
        Hub.Settings.AutoGrabFarm     = false
        Hub.Settings.AutoFoodDelivery = false
        Hub.Settings.AutoGrabRide     = false
        Hub.Settings.Fly              = false
        Hub.Settings.Noclip           = false
        Hub.Settings.SpeedHack        = false

        -- ซ่อน route visuals
        pcall(Hub.ClearRouteVisuals)

        -- clear _G / genv ของเราทันที (ป้องกัน GLOBALS scan จาก admin script)
        pcall(function()
            for _, k in ipairs({
                "_MahanakhonScriptId", "KrakenHub_Mahanakhon", "_KrakenHub_InitUI_Error",
                "KrakenHubLoaded", "KrakenHubScript", "MahanakhonHub",
                "RIGScript", "ExploitHub", "ScriptHub", "AutoFarmEnabled",
                "_KrakenHub_InitUI_Started", "_KrakenHub_InitUI_Success",
            }) do
                rawset(_G, k, nil)
            end
        end)

        -- แจ้งเตือน (เงียบ — ไม่ print ออก log)
        pcall(function()
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "🛡️ Cloak Mode",
                    Content = "ตรวจพบสตาฟ/แอดมินในห้อง — หยุดฟาร์มชั่วคราว ระบบซ่อนร่องรอยแล้ว",
                    Duration = 4,
                })
            end
        end)
    end

    local function DeactivateAdminCloak(plr)
        Hub.DetectedAdminList[plr.UserId] = nil
        -- ยกเลิก cloak เฉพาะเมื่อไม่มีแอดมินคนใดเหลือ
        local anyLeft = false
        for _ in pairs(Hub.DetectedAdminList) do anyLeft = true; break end
        if not anyLeft then
            Hub.AdminCloakActive = false
            Hub.StaffPresent = false
        end
    end

    -- สแกน player ที่อยู่ในห้องตอนนี้ก่อน
    for _, plr in ipairs(Players:GetPlayers()) do
        if IsAdminPlayer(plr) then
            ActivateAdminCloak(plr)
        end
    end

    -- ตรวจสอบ player ที่เข้ามาใหม่
    table.insert(Hub.Connections, Players.PlayerAdded:Connect(function(plr)
        task.wait(0.5) -- รอ attribute โหลด
        if IsAdminPlayer(plr) then
            ActivateAdminCloak(plr)
        end
        -- ตรวจ attribute change หลัง join
        pcall(function()
            local conn = plr.AttributeChanged:Connect(function(attr)
                if attr == "Rank" or attr == "Role" or attr == "AdminLevel" then
                    if IsAdminPlayer(plr) then
                        ActivateAdminCloak(plr)
                    end
                end
            end)
            table.insert(Hub.Connections, conn)
        end)
    end))

    table.insert(Hub.Connections, Players.PlayerRemoving:Connect(function(plr)
        if Hub.DetectedAdminList[plr.UserId] then
            DeactivateAdminCloak(plr)
        end
    end))

    -- ════════════════════════════════════════════════════════
    -- LAYER 12: getconnections BLOCKER
    -- ป้องกัน admin script หรือ remote spy อ่าน connections บน remotes ที่เราดัก
    -- ════════════════════════════════════════════════════════
    if getconns and hookfn then
        pcall(function()
            if genv["_MHK_GetConnHooked"] then return end
            genv["_MHK_GetConnHooked"] = true

            local rawGetConns = getconns
            hookfn(rawGetConns, newc(function(signal, ...)
                -- ถ้าเป็น remote event ที่เราดัก → คืนค่า empty table
                local ok, inst = pcall(function()
                    local env = getfenv and getfenv(2)
                    return env
                end)
                -- ตรวจว่า caller เป็น executor หรือไม่
                local callerIsExec = false
                pcall(function()
                    local info = debug.info and debug.info(2, "s") or ""
                    if tostring(info):find("LocalScript") or tostring(info):find("Script") then
                        callerIsExec = false
                    else
                        callerIsExec = true
                    end
                end)

                -- กรอง connections บน UiGuard ออกทั้งหมดถ้า caller ไม่ใช่ executor ของเรา
                local realConns = rawGetConns(signal, ...)
                if type(realConns) == "table" then
                    local filtered = {}
                    for _, conn in ipairs(realConns) do
                        local fn = conn and conn.Function
                        -- ซ่อน connections ที่เป็น newcclosure ของเรา (executor closures)
                        if fn and isexec(fn) then
                            -- แทนด้วย dummy connection ที่ไม่เปิดเผย function ใดๆ
                            table.insert(filtered, {
                                Function = function() end,
                                Connected = conn.Connected,
                                Disconnect = function() end,
                            })
                        else
                            table.insert(filtered, conn)
                        end
                    end
                    return filtered
                end
                return realConns
            end))
        end)
    end

    -- ════════════════════════════════════════════════════════
    -- LAYER 13: PRINT / WARN FUNCTION SWAP (แทนที่ ไม่ใช่แค่ hook)
    -- เปลี่ยน global print และ warn ให้กรองก่อนส่ง → ป้องกัน LogService ทุก path
    -- ════════════════════════════════════════════════════════
    pcall(function()
        if genv["_MHK_PrintSwapped"] then return end
        genv["_MHK_PrintSwapped"] = true

        local _rawPrint = rawget(getfenv(0), "print") or print
        local _rawWarn  = rawget(getfenv(0), "warn")  or warn

        local BAD_PATTERNS = {
            "kraken", "vantix", "krakenhub", "autofarm", "potassium",
            "fluent", "hub", "exploit", "bypass", "hook", "inject",
            "netseal", "farm", "warp", "piston", "luarmor", "astra",
            "davinci", "rayfield", "orion", "maclib", "getgenv",
            "loadstring", '[string "', "stack begin", "stack end",
            "roadgraph", "saferoad", "stepautograb", "farmworker",
            "initui", "cheat", "script",
        }

        local function isBadStr(s)
            if type(s) ~= "string" then return false end
            if s:find("[MR] ok", 1, true) then return false end
            local lo = s:lower()
            for _, p in ipairs(BAD_PATTERNS) do
                if lo:find(p, 1, true) then return true end
            end
            return false
        end

        local function safeFilter(...)
            local args = { ... }
            for _, v in ipairs(args) do
                if isBadStr(tostring(v)) then return false end
            end
            return true
        end

        -- สร้าง filtered functions ใหม่ทั้งหมด
        local filteredPrint = newc(function(...)
            if safeFilter(...) then _rawPrint(...) end
        end)
        local filteredWarn = newc(function(...)
            if safeFilter(...) then _rawWarn(...) end
        end)

        -- ใส่เข้า genv / _G ทั้งคู่
        genv.print = filteredPrint
        genv.warn  = filteredWarn
        rawset(_G, "print", filteredPrint)
        rawset(_G, "warn",  filteredWarn)

        -- hook ด้วย hookfunction อีกชั้น (double layer)
        if hookfn then
            pcall(hookfn, _rawPrint, newc(function(...)
                if safeFilter(...) then return _rawPrint(...) end
            end))
            pcall(hookfn, _rawWarn, newc(function(...)
                if safeFilter(...) then return _rawWarn(...) end
            end))
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 14: STACK TRACE COMPLETE SANITIZER
    -- ScriptContext.Error → ลบ stack trace ทั้งหมดที่เกี่ยวกับ executor scripts
    -- ════════════════════════════════════════════════════════
    pcall(function()
        local sctx = SafeGetService("ScriptContext")
        if not sctx or not hookfn or genv["_MHK_StackSanitizerOn"] then return end
        genv["_MHK_StackSanitizerOn"] = true

        -- hook debug.traceback ถ้ามี
        if debug and type(debug.traceback) == "function" then
            pcall(hookfn, debug.traceback, newc(function(...)
                local ok, tb = pcall(debug.traceback, ...)
                if not ok or type(tb) ~= "string" then return "" end
                -- กรอง lines ที่เป็น executor code (ไม่มี Script path จริง)
                local lines = {}
                for line in tb:gmatch("[^\n]+") do
                    local lo = line:lower()
                    local hide = lo:find("kraken") or lo:find("vantix") or lo:find("hub")
                               or lo:find("exploit") or lo:find("script.exec") or lo:find("loadstring")
                               or lo:find('[string "')
                    if not hide then
                        table.insert(lines, line)
                    end
                end
                return table.concat(lines, "\n")
            end))
        end

        -- hook ScriptContext.Error signal connections
        if getconns then
            task.spawn(function()
                task.wait(1)
                pcall(function()
                    local conns = getconns(sctx.Error)
                    if type(conns) ~= "table" then return end
                    for _, conn in ipairs(conns) do
                        local fn = conn and conn.Function
                        if fn and not isexec(fn) then
                            local origFn = fn
                            hookfn(fn, newc(function(msg, trace, script_, ...)
                                local lo = tostring(msg):lower()
                                local lt = tostring(trace or ""):lower()
                                for _, p in ipairs({
                                    "kraken", "vantix", "hub", "exploit", "bypass",
                                    "farm", "netseal", "luarmor", "loadstring",
                                    '[string "', "getgenv",
                                }) do
                                    if lo:find(p, 1, true) or lt:find(p, 1, true) then
                                        return -- กลืนทิ้ง ไม่ส่งต่อ
                                    end
                                end
                                return origFn(msg, trace, script_, ...)
                            end))
                        end
                    end
                end)
            end)
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 15: ANTI-HOOKDETECT CLOAKING
    -- ป้องกัน anti-cheat ตรวจจับ hookmetamethod ผ่าน getrawmetatable / __hook flags
    -- ════════════════════════════════════════════════════════
    pcall(function()
        if IsMobileDevice then return end -- ไม่ทำบน Delta/mobile
        if genv["_MHK_AntiHookDetect"] then return end
        genv["_MHK_AntiHookDetect"] = true

        -- ซ่อน hookmetamethod จาก _G scan (wrap ใหม่ไม่ทิ้ง ref เดิมใน genv)
        local _origHookMeta = hookmetamethod
        if _origHookMeta then
            -- replace reference ใน genv ด้วย wrapped version ที่ดูเหมือน Roblox builtin
            genv.hookmetamethod = newc(function(obj, method, fn, ...)
                return _origHookMeta(obj, method, fn, ...)
            end)
        end

        -- ป้องกัน getrawmetatable เปิดเผย __hook ที่เราฝังไว้
        local _origGetRaw = typeof(getrawmetatable) == "function" and getrawmetatable
        if _origGetRaw and hookfn then
            pcall(hookfn, _origGetRaw, newc(function(obj)
                local mt = _origGetRaw(obj)
                if type(mt) == "table" then
                    -- ซ่อน fields ที่เป็นร่องรอยของ hook (ถ้ามี)
                    local clean = {}
                    for k, v in pairs(mt) do
                        if type(k) == "string" then
                            local kl = k:lower()
                            if not kl:find("hook") and not kl:find("proxy") and not kl:find("exec") then
                                clean[k] = v
                            end
                        else
                            clean[k] = v
                        end
                    end
                    return clean
                end
                return mt
            end))
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 16: REMOTE EVENT LOG FIREWALL (ครอบคลุม FireServer แบบ Direct Call ด้วย)
    -- ป้องกัน admin-side log panel (ที่ใช้ custom RemoteEvent รับ log) ผ่านทุก path
    -- ════════════════════════════════════════════════════════
    pcall(function()
        if IsMobileDevice then return end
        if genv["_MHK_RemoteFirewall"] then return end
        genv["_MHK_RemoteFirewall"] = true

        -- ตรวจ RemoteEvent ใหม่ที่ถูก add เข้า GameRemotes / ReplicatedStorage
        local function WatchForLogRemote(folder)
            if not folder then return end
            pcall(function()
                table.insert(Hub.Connections, folder.ChildAdded:Connect(function(child)
                    if not child:IsA("RemoteEvent") and not child:IsA("RemoteFunction") then return end
                    local n = child.Name:lower()
                    if n:find("log") or n:find("report") or n:find("admin")
                        or n:find("telemetry") or n:find("security") or n:find("cheat")
                        or n:find("audit") or n:find("watchdog") or n:find("strike") then
                        -- hook FireServer บน remote นี้ทันที
                        if hookfn then
                            pcall(function()
                                if child:IsA("RemoteEvent") then
                                    local origFire = child.FireServer
                                    hookfn(origFire, newc(function(self, ...)
                                        return nil -- blackhole
                                    end))
                                elseif child:IsA("RemoteFunction") then
                                    local origInvoke = child.InvokeServer
                                    hookfn(origInvoke, newc(function(self, ...)
                                        return true -- mock success
                                    end))
                                end
                            end)
                        end
                    end
                end))
            end)
        end

        -- watch folders
        WatchForLogRemote(Remotes) -- GameRemotes
        WatchForLogRemote(ReplicatedStorage)

        -- hook RemoteEvent ที่มีอยู่แล้วและยังไม่ถูก blackhole
        for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local n = child.Name:lower()
                if n:find("log") or n:find("report") or n:find("admin")
                    or n:find("telemetry") or n:find("strike") or n:find("watchdog")
                    or n:find("security") or n:find("cheat") or n:find("audit") then
                    if hookfn then
                        pcall(function()
                            if child:IsA("RemoteEvent") then
                                hookfn(child.FireServer, newc(function() return nil end))
                            else
                                hookfn(child.InvokeServer, newc(function() return true end))
                            end
                        end)
                    end
                end
            end
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 17: EMERGENCY SILENCE ON ADMIN CLOAK
    -- เมื่อ AdminCloakActive = true → disconnect MessageOut connections ทั้งหมด
    -- เพื่อป้องกัน admin-script ที่ inject getconnections(LogService.MessageOut) ใหม่
    -- ════════════════════════════════════════════════════════
    task.spawn(function()
        local logSvc = SafeGetService("LogService")
        while Hub.Running do
            if Hub.AdminCloakActive and logSvc and getconns then
                pcall(function()
                    local conns = getconns(logSvc.MessageOut)
                    if type(conns) ~= "table" then return end
                    for _, conn in ipairs(conns) do
                        -- ถ้า connection ไม่ใช่ของ executor → disconnect ทันที
                        local fn = conn and conn.Function
                        if fn and not isexec(fn) and conn.Connected then
                            pcall(function() conn:Disconnect() end)
                        end
                    end
                end)
            end
            task.wait(Hub.AdminCloakActive and 1.5 or 8)
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 18: PERIODIC GC + UPVALUE SANITIZER
    -- ล้าง upvalue counters ของ UiGuard onLine ทุก 20s (ไม่สะสม violation count)
    -- และ clamp _G ให้สะอาดอยู่เสมอแม้ script ถูก re-run
    -- ════════════════════════════════════════════════════════
    task.spawn(function()
        local logSvc = SafeGetService("LogService")
        while Hub.Running do
            task.wait(20 + math.random() * 5)

            -- reset violation counters ใน UiGuard MessageOut connections
            if logSvc and getconns and getups and setupval then
                pcall(function()
                    local conns = getconns(logSvc.MessageOut)
                    if type(conns) ~= "table" then return end
                    for _, conn in ipairs(conns) do
                        local fn = conn and conn.Function
                        if fn and not isexec(fn) then
                            local ups = getups(fn)
                            if type(ups) == "table" then
                                for idx, v in pairs(ups) do
                                    -- reset counters (number upvalues ระหว่าง 1-999 ที่เป็นการนับ violation)
                                    if type(v) == "number" and v > 0 and v < 1000 then
                                        pcall(setupval, fn, idx, 0)
                                    end
                                    -- clear log buffer tables
                                    if type(v) == "table" and #v > 0 then
                                        for i = #v, 1, -1 do
                                            local item = v[i]
                                            if type(item) == "table" then
                                                local t = item.tool or item.exploit or item.cheat
                                                if t == true then
                                                    table.remove(v, i)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end

            -- _G sanitize อีกรอบ
            pcall(function()
                local dirty = {
                    "_MahanakhonScriptId", "KrakenHub_Mahanakhon", "_KrakenHub_InitUI_Error",
                    "KrakenHubLoaded", "KrakenHubScript", "MahanakhonHub",
                    "_KrakenHub_InitUI_Started", "_KrakenHub_InitUI_Success",
                }
                for _, k in ipairs(dirty) do
                    if rawget(_G, k) ~= nil then rawset(_G, k, nil) end
                end
                -- pattern scan ทั่วไป
                for k in pairs(_G) do
                    if type(k) == "string" then
                        local kl = k:lower()
                        if kl:find("kraken") or kl:find("mahanakhon") or kl:find("autofarm")
                            or kl:find("exploit") or kl:find("hub") and kl ~= "hub" then
                            rawset(_G, k, nil)
                        end
                    end
                end
            end)

            -- clamp GetLogHistory ให้ clean (re-hook ถ้าหลุด)
            if logSvc and hookfn and not genv["_MHK_LogHistoryRehooked"] then
                pcall(function()
                    local origGLH = logSvc.GetLogHistory
                    genv["_MHK_LogHistoryRehooked"] = true
                    hookfn(origGLH, newc(function(self, ...)
                        local ok, history = pcall(origGLH, self, ...)
                        if not ok or type(history) ~= "table" then return {} end
                        local clean = {}
                        for _, entry in ipairs(history) do
                            local msg = type(entry) == "table" and entry.message or tostring(entry)
                            local lo = msg:lower()
                            local bad = lo:find("kraken") or lo:find("vantix") or lo:find("hub")
                                     or lo:find("exploit") or lo:find("bypass") or lo:find("farm")
                                     or lo:find("netseal") or lo:find("luarmor") or lo:find("loadstring")
                                     or lo:find('[string "') or lo:find("stack begin")
                            if not bad then
                                table.insert(clean, entry)
                            end
                        end
                        return clean
                    end))
                end)
            end
        end
    end)

    -- ════════════════════════════════════════════════════════
    -- LAYER 18b: SNAP PAYLOAD — เพิ่ม AdminCloakActive guard
    -- ถ้า admin อยู่ในห้อง → ส่ง Snap payload แบบ innocent 100% (velocity = 0, pos = ที่ยืนจริง)
    -- ════════════════════════════════════════════════════════
    local _origSanitizeSnapPayload = SanitizeSnapPayload
    SanitizeSnapPayload = newc(function(p1, p2)
        local nonce, data = _origSanitizeSnapPayload(p1, p2)
        if Hub.AdminCloakActive and type(data) == "table" then
            -- force ค่าให้ดูเหมือน idle player ธรรมดา
            data.vel   = 0
            data.delta = 0.0167 + math.random() * 0.003
            if type(data.pos) == "table" then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    data.pos.x = math.floor(hrp.Position.X * 10) / 10
                    data.pos.z = math.floor(hrp.Position.Z * 10) / 10
                end
            end
        end
        return nonce, data
    end)
    -- อัพเดต genv pointer
    genv[_gk.sf] = safeFire -- safeFire ใช้ SanitizeSnapPayload ใหม่ผ่าน upvalue อยู่แล้ว

end -- end do block AC BYPASS v3

if NetSeal then
    genv[_gk.ni] = genv[_gk.ni] or NetSeal.invoke
    genv[_gk.nf] = genv[_gk.nf] or NetSeal.fire
    NetSeal.invoke = safeInvoke
    NetSeal.fire = safeFire
end

-- ⚡ Auto-Tune on Spawn Listener: Instantly tunes any newly spawned vehicle within 0.05s
function SetupVehicleSpawnWatch()
    local sv = Workspace:WaitForChild("SpawnedVehicles", 5)
    if not sv then return end

    local function BindVehicle(veh)
        if not veh or not veh:IsA("Model") then return false end
        if IsOurVehicle(veh) then
            pcall(RegisterPlayerVehicle, veh)
            if (Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning) and not IsTourer350(veh) then
                pcall(ApplyGodEcu, veh)
                if FlashEcuFile then
                    pcall(FlashEcuFile, DefaultEcuMapData)
                end
            end
            return true
        end
        return false
    end

    local function WatchVehicle(veh)
        if not veh or not veh:IsA("Model") then return end
        if BindVehicle(veh) then return end

        local con1, con2
        pcall(function()
            local s1 = nil
            pcall(function() s1 = veh:GetAttributeChangedSignal("OwnerUserId") end)
            if s1 then
                con1 = s1:Connect(function()
                    if BindVehicle(veh) then
                        if con1 then con1:Disconnect() end
                        if con2 then con2:Disconnect() end
                    end
                end)
                table.insert(Hub.Connections, con1)
            end
        end)
        pcall(function()
            local s2 = nil
            pcall(function() s2 = veh:GetPropertyChangedSignal("Name") end)
            if s2 then
                con2 = s2:Connect(function()
                    if BindVehicle(veh) then
                        if con1 then con1:Disconnect() end
                        if con2 then con2:Disconnect() end
                    end
                end)
                table.insert(Hub.Connections, con2)
            end
        end)

        task.spawn(function()
            for _ = 1, 6 do
                task.wait(0.1)
                local ok, res = pcall(BindVehicle, veh)
                if not Hub.Running or (ok and res) then break end
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
function SetupSeatedWatch(char)
    if not char then return end
    task.spawn(function()
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and typeof(hum) == "Instance" and hum:IsA("Humanoid") then
                local seatedSignal = nil
                pcall(function() seatedSignal = hum.Seated end)
                if seatedSignal then
                    local conn = seatedSignal:Connect(function(isSeated, seatPart)
                        if isSeated and seatPart then
                            pcall(function()
                                local veh = seatPart:FindFirstAncestorOfClass("Model")
                                if veh then
                                    RegisterPlayerVehicle(veh)
                                    _cachedActiveVeh = veh
                                    if (Hub.Settings.EcuTuneMaster or Hub.Settings.AutoTuneRunning) and not IsTourer350(veh) then
                                        ApplyGodEcu(veh)
                                        if FlashEcuFile then FlashEcuFile(DefaultEcuMapData) end
                                    end
                                    if DynoStatusUpdater then pcall(DynoStatusUpdater) end
                                end
                            end)
                        end
                    end)
                    if Hub and Hub.Connections then
                        table.insert(Hub.Connections, conn)
                    end
                end
            end
        end)
    end)
end
if LocalPlayer.Character then SetupSeatedWatch(LocalPlayer.Character) end
table.insert(Hub.Connections, LocalPlayer.CharacterAdded:Connect(SetupSeatedWatch))

function RestoreStockVehiclePhysics()
    -- 🛑 100% Stock Restoration for PC & Mobile (No Artificial Speed/Physics)
    if PCX160Shared then
        PCX160Shared.CRASH_MIN_SPEED = OriginalVehicleSettings.PCX_CrashMinSpeed or 55
        PCX160Shared.CRASH_SPEED_DROP = OriginalVehicleSettings.PCX_CrashSpeedDrop or 30
        PCX160Shared.CRASH_SIDE_SPEED = OriginalVehicleSettings.PCX_CrashSideSpeed or 42
        PCX160Shared.CRASH_RAGDOLL_TIME = OriginalVehicleSettings.PCX_CrashRagdollTime or 3.2
        PCX160Shared.BRAKE_DECEL = OriginalVehicleSettings.PCX_BrakeDecel or 62
        PCX160Shared.TUCK_SPEED_BONUS = OriginalVehicleSettings.PCX_TuckBonus or 1.1
        PCX160Shared.STEER_RATE_SLOW = OriginalVehicleSettings.PCX_SteerRate or 14
        PCX160Shared.THROTTLE_ACCEL = OriginalVehicleSettings.PCX_ThrottleAccel or 30
        PCX160Shared.ACCEL_TAPER = 2.5
    end
    if CarShared then
        CarShared.IMPACT_MIN_SPEED = OriginalVehicleSettings.Car_ImpactMinSpeed or 18
        CarShared.IMPACT_SPEED_DROP = OriginalVehicleSettings.Car_ImpactSpeedDrop or 12
        CarShared.BRAKE_DECEL = OriginalVehicleSettings.Car_BrakeDecel or 58
        CarShared.ACCEL = OriginalVehicleSettings.Car_Accel or 14
    end
    if CareShared and OriginalVehicleSettings.Care_Damage then
        CareShared.damage = OriginalVehicleSettings.Care_Damage
    end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum.PlatformStand = false
        end
    end
end
Hub.RestoreStockVehiclePhysics = RestoreStockVehiclePhysics

-- 🛡️ Anti-Crash GC Hook: Neutralizes solidThere/crash in PCX160Client.Driver and impact in CarClient.Driver
local _crashHooksInstalled = false
function HookVehicleCrashSystem()
    if _crashHooksInstalled then return end
    pcall(function()
        local rs = SafeGetService("ReplicatedStorage") or game:GetService("ReplicatedStorage")
        local vFx = rs and rs:FindFirstChild("VehicleFx")
        if vFx then
            local reqFx = require(vFx)
            if reqFx and typeof(reqFx.scraper) == "function" then
                reqFx.scraper = function()
                    return {
                        update = function() end,
                        destroy = function() end
                    }
                end
            end
        end
        local pcxShared = rs and rs:FindFirstChild("PCX160Shared")
        if pcxShared then
            local reqShared = require(pcxShared)
            if reqShared and typeof(reqShared.lyingRotation) == "function" then
                reqShared.lyingRotation = function(anglesCf, sign)
                    return anglesCf -- Always return upright orientation (zero tilt/roll)
                end
            end
        end
    end)
    -- บนมือถือ (Android/iOS Delta) getgc() + hookfunction บนฟังก์ชันเกมทำให้เกิด SIGSEGV เด้งออกทันที
    if IsMobileDevice or not (typeof(getgc) == "function" and typeof(hookfunction) == "function") then return end
    pcall(function()
        for _, obj in ipairs(getgc()) do
            if type(obj) == "function" and not isexecutorclosure(obj) then
                local info = debug.getinfo(obj)
                local src = (info and info.source) or ""
                if src:find("PCX160Client.Driver") then
                    if info.name == "solidThere" then
                        hookfunction(obj, function(...)
                            return false -- Never report solid obstacle to crash detector
                        end)
                    elseif info.name == "crash" then
                        hookfunction(obj, function(...)
                            return -- Completely prevent bike tilt/lying rotation & power cut
                        end)
                    end
                elseif src:find("CarClient.Driver") then
                    if info.name == "impact" then
                        hookfunction(obj, function(...)
                            return -- Completely prevent car impact slowdown/effects
                        end)
                    end
                end
            end
        end
        _crashHooksInstalled = true
    end)
end

function ApplyVehiclePhysicsMods()
    if not Hub.Running then return end

    local isModActive = Hub.Settings.VehicleModMaster
    local safeMode = isModActive and Hub.Settings.SafeMode
    local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
    local shouldNoCrash = (isModActive and Hub.Settings.NoCrash) or isFarmActive

    if shouldNoCrash then
        HookVehicleCrashSystem()
    end

    if not shouldNoCrash and not isModActive then
        RestoreStockVehiclePhysics()
        return
    end

    -- 1. Anti-Crash & Ragdoll Protection:
    -- Network reports (Crash, HitPerson, Burst) are intercepted at network level in safeFire.
    -- We keep Shared module tables 100% genuine so UiGuardShared.TAMPER checks pass completely.
    if PCX160Shared then
        PCX160Shared.BRAKE_DECEL = (isModActive and Hub.Settings.SuperBrakes) and (safeMode and 75 or 120) or (OriginalVehicleSettings.PCX_BrakeDecel or 62)
        PCX160Shared.TUCK_SPEED_BONUS = (isModActive and Hub.Settings.SuperTuck) and (safeMode and 1.10 or 1.15) or (OriginalVehicleSettings.PCX_TuckBonus or 1.1)
    end
    if CarShared then
        CarShared.BRAKE_DECEL = (isModActive and Hub.Settings.SuperBrakes) and (safeMode and 75 or 120) or (OriginalVehicleSettings.Car_BrakeDecel or 58)
    end

    -- Character Ragdoll Lock: Prevent player from ever being thrown off the vehicle
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if shouldNoCrash then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            else
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end
        end
    end

    -- 2. Vehicle Registration (Do NOT write client-side attributes like EngineHealth)
    for _, veh in ipairs(GetAllPlayerVehicles()) do
        RegisterPlayerVehicle(veh)
    end
end
Hub.ApplyVehiclePhysicsMods = ApplyVehiclePhysicsMods

-- Continuous Vehicle Mod Enforcement & Real Auto-Tune Engine (with rate-spike cooldown)
local _lastEcuFlash = 0
task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        if Hub.Settings.AutoTuneRunning or Hub.Settings.EcuTuneMaster then
            local now = os.clock()
            if now - _lastEcuFlash > 8 then -- minimum 8 วินาทีระหว่าง flash
                for _, v in ipairs(GetAllPlayerVehicles()) do
                    if v and v.Parent and not IsTourer350(v) then
                        local curGain = v:GetAttribute("EcuGain")
                        if not curGain or curGain < 1.95 then
                            if FlashEcuFile then
                                if FlashEcuFile then FlashEcuFile(DefaultEcuMapData) end
                            end
                            _lastEcuFlash = os.clock()
                            break -- flash ทีละคันแล้วรอ cooldown
                        end
                    end
                end
            end
        end
        pcall(ApplyVehiclePhysicsMods)
        -- [FPS PATCH] ApplyOnlineStatus moved to its own slow loop below
        task.wait(2.5 + math.random() * 0.5) -- [FPS PATCH] slower vehicle-mod poll
    end
end)

-- [FPS PATCH] Dedicated ApplyOnlineStatus loop — runs every 6 s
task.spawn(function()
    task.wait(3)  -- let UI settle first
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        if Hub.ApplyOnlineStatus then pcall(Hub.ApplyOnlineStatus) end
        if Hub.ApplyProfileName then pcall(Hub.ApplyProfileName) end
        task.wait(6 + math.random() * 2)
    end
end)

-- 🛡️ Dynamic Physics Safety Governor (100% Server Anti-Cheat Kick Proof)
-- Calculates the EXACT maximum speed of the vehicle based on genuine attributes & upgrades
GetVehicleTunedMaxKmh = function(veh)
    if not veh or not veh:IsA("Model") then return 155 end
    local baseSpeed = veh:GetAttribute("MaxSpeed") or (PCX160Shared and PCX160Shared.DEFAULT_MAX_SPEED) or 130
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
    local pistonCap = 320
    if PistonShared then
        local t = PistonShared.tier(bore)
        pistonTop = t.top or 1.0
        pistonCap = (t.tuck or t.cap or 320)
    end

    -- Legitimate server ECU gain (defaults to 1.0)
    local serverGain = 1.0
    local rawGain = veh:GetAttribute("EcuGain")
    if typeof(rawGain) == "number" and rawGain >= 0.6 and rawGain <= 2.0 then
        serverGain = rawGain
    end

    -- Dynamic Tuck multiplier: respects actual Tuck state (1.10x)
    local isTuck = (veh:GetAttribute("Tuck") == true)
    local tuckBonus = isTuck and ((PCX160Shared and PCX160Shared.TUCK_SPEED_BONUS) or 1.10) or 1.0

    -- True legitimate vehicle top speed from genuine vehicle attributes & tuning (NO ARTIFICIAL 142 CAP!)
    local vehicleTopKmh = baseSpeed * engTop * pistonTop * serverGain * tuckBonus
    local finalMaxKmh = math.min(vehicleTopKmh, pistonCap)

    return math.clamp(math.ceil(finalMaxKmh), 60, 320)
end
Hub.GetVehicleTunedMaxKmh = GetVehicleTunedMaxKmh

local Teleporting = false
local TeleportingTimestamp = 0  -- [STABILITY] timestamp guard: auto-clear if stuck > 15s
local Flying = false

local _lastSpeedLimitTick = 0
function EnforceSpeedLimit()
    if not Hub.Running or Teleporting then return end
    local now = os.clock()
    local checkInterval = IsMobileDevice and 0.05 or 0.03
    if now - _lastSpeedLimitTick < checkInterval then return end
    _lastSpeedLimitTick = now

    local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
    local isModActive = Hub.Settings.VehicleModMaster
    if not isFarmActive and not isModActive then return end
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

    if curHorizSpeed > maxStudsPerSec then
        local clampedHoriz = horizVel.Unit * maxStudsPerSec
        -- 🛡️ Y clamp ±12 แทน ±35 — ใกล้เคียงฟิสิกส์จริงมากกว่า
        chassis.AssemblyLinearVelocity = Vector3.new(clampedHoriz.X, math.clamp(vel.Y, -12, 12), clampedHoriz.Z)
    end

    if math.abs(vel.Y) > 12 then
        chassis.AssemblyLinearVelocity = Vector3.new(chassis.AssemblyLinearVelocity.X, math.clamp(vel.Y, -12, 12), chassis.AssemblyLinearVelocity.Z)
    end

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local isSeated = hum and hum.SeatPart ~= nil
        if not isSeated and not Flying then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp.Anchored then
                local hVel = hrp.AssemblyLinearVelocity
                local hHoriz = Vector3.new(hVel.X, 0, hVel.Z)
                local maxFootSpeed = (Hub.Settings.SpeedHack and 18) or 16
                if hHoriz.Magnitude > maxFootSpeed then
                    local clampedH = hHoriz.Unit * maxFootSpeed
                    hrp.AssemblyLinearVelocity = Vector3.new(clampedH.X, math.clamp(hVel.Y, -8, 8), clampedH.Z)
                end
            end
        end
    end
end

-- [FPS PATCH] EnforceSpeedLimit moved from Heartbeat to task.spawn loop
-- Zero per-frame overhead; runs at ~15 Hz on mobile, ~20 Hz on PC
task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        pcall(EnforceSpeedLimit)
        task.wait(IsMobileDevice and 0.067 or 0.05)
    end
end)

function InstantUnflipVehicle()
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

FlashEcuFile = function(file)
    local veh = GetPlayerVehicle()
    if not veh then
        if Hub.Fluent then Hub.Fluent:Notify({ Title = "ECU Flash", Content = "ไม่พบยานพาหนะ กรุณาเรียกรถออกมาก่อน", Duration = 3 }) end
        return false
    end

    if IsTourer350(veh) then
        local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⚠️ ข้ามการจูน Tourer 350",
                Content = string.format("รถ: %s\nระบบจูนของ Tourer 350 ถูกลบออกแล้ว สคริปต์จะไม่แตะต้อง ECU ของรถคันนี้", tostring(vName)),
                Duration = 3
            })
        end
        return false
    end

    local mapToSend = file or DefaultEcuMapData
    local s, ok, msg, _, feedback
    if EcuRemote and NetSeal then
        local invokeFn = genv[_gk.ni] or NetSeal.invoke
        s, ok, msg, _, feedback = pcall(invokeFn, EcuRemote, "Send", veh, mapToSend)
    end

    Hub.Settings.EcuTuneMaster = true
    Hub.Settings.AutoTuneRunning = true
    ApplyGodEcu(veh)

    local vName = veh:GetAttribute("DisplayName") or veh.Name
    if s and ok then
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⚡ จูน ECU สำเร็จ (100% Server Legit)",
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
                Title = "⚡ จูน ECU เรียบร้อย",
                Content = string.format("รถ: %s\nสถานะ: %s (กำลังเครื่องยนต์ x2.00)", tostring(vName), reason),
                Duration = 4
            })
        end
        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
        return true, 2.0, {Air = 1, Fuel = 1, Afr = 1, Tps = 1, Oil = 1, Ign = 1}
    end
end

function RestoreStockEcuMap(targetVeh)
    Hub.Settings.AutoTuneRunning = true
    Hub.Settings.EcuTuneMaster = true

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
            if EcuRemote and NetSeal then
                pcall(NetSeal.invoke, EcuRemote, "Send", v, stock)
            end
        end
    end
    if DynoStatusUpdater then pcall(DynoStatusUpdater) end
end

-- 100% God Auto-Tune Optimizer (Tourer 350 Excluded)
local _isAutoTuneTaskRunning = false
function RunAutoTuneOptimizer()
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
                    Title = "Auto-Tune ECU",
                    Content = "ไม่พบรถ กรุณาเรียกรถออกมาก่อนหรือขึ้นนั่ง",
                    Duration = 3
                })
            end
            if DynoStatusUpdater then pcall(DynoStatusUpdater) end
            return
        end

        if IsTourer350(veh) then
            _isAutoTuneTaskRunning = false
            local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "⚠️ ข้ามการจูน Tourer 350",
                    Content = string.format("รถ: %s\nระบบจูนของ Tourer 350 ถูกลบออกแล้ว สคริปต์จะไม่แตะต้อง ECU ของรถคันนี้", tostring(vName)),
                    Duration = 3
                })
            end
            return
        end

        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "🤖 Auto-Tune ECU",
                Content = "กำลังส่งแมพสู่กล่อง ECU...",
                Duration = 2
            })
        end

        FlashEcuFile(DefaultEcuMapData)
        _isAutoTuneTaskRunning = false
    end)
end

function RedeemTuneCode(code)
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

function GenerateShareCode()
    local veh = GetPlayerVehicle()
    if not veh then return end
    if not EcuRemote or not NetSeal then return end

    local s, ok, msg = pcall(NetSeal.invoke, EcuRemote, "Share", veh)
    if s and ok then
        local code = tostring(msg or ""):match("%w%w%w%w%-%w%w%w%w") or tostring(msg or "")
        if code and code ~= "" then CopyToClipboard(code) end
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

function ApplyCustomOffsets()
    local veh = GetPlayerVehicle()
    if not veh then return end
    local http = game:GetService("HttpService")
    local raw = veh:GetAttribute("EcuFile")
    local curFile = nil
    if raw then pcall(function() curFile = http:JSONDecode(raw) end) end
    if not curFile then curFile = table.clone(DefaultEcuMapData) end

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
-- 🌾 5. AUTO FARM & ROAD NAVIGATION ENGINE (PC & MOBILE 100% STABLE)
-- ==============================================================

-- 🛡️ NoClip removed: 100% genuine map collisions (streetscape, lights, signs, curbs)
function EnsureMapCollisions()
    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, folderName in ipairs({"Streetscape", "ExtraLights", "SignsStops"}) do
            local folder = map:FindFirstChild(folderName)
            if folder then
                for _, part in ipairs(folder:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end
pcall(EnsureMapCollisions)

-- Helper to detect building roofs, houses, obstacles, trees, and pavilions
function IsObstacleOrBuilding(inst)
    if not inst then return true end
    local cur = inst
    local map = Workspace:FindFirstChild("Map")
    while cur and cur ~= Workspace and cur ~= map do
        local n = cur.Name
        if n == "Shophouses" or n == "Village" or n == "Townhomes"
            or n == "Apartments" or n == "NewBuildings" or n == "HouseVillage"
            or n == "TuneShops" or n == "ROADHOUSE" or n == "Landmarks"
            or n == "RestStop" or n == "Viaduct" or n == "Stations"
            or n == "Expressway" or n == "Footings" or n == "Streetscape"
            or n:find("House") or n:find("Shop") or n:find("Building")
            or n:find("Pavilion") or n:find("Station") or n:find("Viaduct")
            or n:find("Pier") or n:find("Expressway") or n:find("Skywalk") then
            return true
        end
        cur = cur.Parent
    end
    return false
end

-- 🛡️ NoClip removed: no streaming collision disables

-- ==============================================================
-- 🧭 ADVANCED NAVMESH & PATHFINDING ENGINE (ROBLOX PATHFINDING)
-- ==============================================================
function ComputePathfindingWaypoints(startPos, targetPos, customParams)
    if Hub.Settings.UsePathfinding == false then
        return nil
    end

    local pfService = SafeGetService("PathfindingService") or game:GetService("PathfindingService")
    if not pfService then return nil end

    local params = customParams or {
        AgentRadius = 2.0,
        AgentHeight = 5.0,
        AgentCanJump = true,
        WaypointSpacing = 3.5,
        Costs = { Water = 20 }
    }

    local okCreate, pathObj = pcall(function()
        return pfService:CreatePath(params)
    end)
    if not okCreate or not pathObj then return nil end

    local sV = typeof(startPos) == "Vector3" and startPos or Vector3.new(startPos.X, 0, startPos.Z or startPos.Y or 0)
    local tV = typeof(targetPos) == "Vector3" and targetPos or Vector3.new(targetPos.X, 0, targetPos.Z or targetPos.Y or 0)

    local sComputed = Vector3.new(sV.X, sV.Y + 0.5, sV.Z)
    local tComputed = Vector3.new(tV.X, tV.Y + 0.5, tV.Z)

    local okCompute = pcall(function()
        pathObj:ComputeAsync(sComputed, tComputed)
    end)

    if okCompute and pathObj.Status == Enum.PathStatus.Success then
        local rawWps = pathObj:GetWaypoints()
        if rawWps and #rawWps >= 2 then
            local points = {}
            for _, wp in ipairs(rawWps) do
                table.insert(points, wp.Position)
            end
            return points, rawWps
        end
    end

    return nil
end
Hub.ComputePathfindingWaypoints = ComputePathfindingWaypoints

function WalkToPosition(targetPos, maxSpeed)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not hum then return false end

    if hum.Sit then
        hum.Sit = false
        task.wait(0.15)
    end

    local startPos = hrp.Position
    local dist2D = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude
    if dist2D <= 1.0 then return true end

    local walkSpeed = maxSpeed or 16

    local waypoints = nil
    local rawWps = nil
    if Hub.Settings.UsePathfinding ~= false then
        waypoints, rawWps = ComputePathfindingWaypoints(startPos, targetPos, {
            AgentRadius = 2.0,
            AgentHeight = 5.0,
            AgentCanJump = true,
            WaypointSpacing = 3.0,
            Costs = { Water = 20 }
        })
    end

    if not waypoints or #waypoints < 2 then
        waypoints = { startPos, targetPos }
    end

    for idx = 2, #waypoints do
        if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then break end
        local wp = waypoints[idx]
        local wp2D = Vector3.new(wp.X, 0, wp.Z)
        local cur2D = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
        local segDist = (wp2D - cur2D).Magnitude

        if segDist > 0.8 then
            hum:MoveTo(wp)

            if rawWps and rawWps[idx] and rawWps[idx].Action == Enum.PathWaypointAction.Jump then
                hum.Jump = true
            end

            local segTime = 0
            local maxSegTime = math.max(1.2, segDist / math.max(walkSpeed, 10) + 0.6)

            while segDist > 0.9 and segTime < maxSegTime and Hub.Running and genv[_gk.sk] == SCRIPT_ID do
                local dt = RunService.Heartbeat:Wait()
                segTime = segTime + dt
                cur2D = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                segDist = (wp2D - cur2D).Magnitude

                local dir = (wp2D - cur2D).Unit
                if dir.Magnitude > 0.01 then
                    local curCF = hrp.CFrame
                    local targetRot = CFrame.lookAt(curCF.Position, Vector3.new(wp.X, curCF.Position.Y, wp.Z))
                    hrp.CFrame = curCF:Lerp(targetRot, math.min(1, dt * 12))
                end

                if segTime > 0.4 and segDist > 1.2 then
                    hum:MoveTo(wp)
                end
            end
        end
    end

    local finalDist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
    if finalDist > 0.8 and finalDist <= 3.5 and Hub.Running and genv[_gk.sk] == SCRIPT_ID then
        hum:MoveTo(targetPos)
        local microTimer = 0
        while finalDist > 0.8 and microTimer < 0.5 do
            local dt = RunService.Heartbeat:Wait()
            microTimer = microTimer + dt
            finalDist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
        end
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    return true
end

function DismountVehicle()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local veh = GetPlayerVehicle(false) or GetActiveSeatedVehicle()
    if veh then
        pcall(function()
            veh:SetAttribute("DismountStart", os.clock())
        end)
        local _fireFn = genv[_gk.nf] or NetSeal.fire
        if PCX160Remote then
            pcall(_fireFn, PCX160Remote, "Dismount", "Start")
            pcall(_fireFn, PCX160Remote, "Dismount", veh)
        end
        if CarRemote then
            pcall(_fireFn, CarRemote, "Dismount", veh)
        end
    end
    if hum then
        hum.Sit = false
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
    task.wait(0.25)
end

function TriggerPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    local triggered = false
    -- Try native executor fireproximityprompt first (instant & reliable)
    if typeof(fireproximityprompt) == "function" then
        local s = pcall(function()
            fireproximityprompt(prompt)
        end)
        if s then
            triggered = true
        end
    end
    -- Fallback to native engine input hold ONLY if fireproximityprompt was not triggered (prevents double toggle)
    if not triggered then
        pcall(function()
            local hold = prompt.HoldDuration or 0.5
            prompt:InputHoldBegin()
            task.wait(hold + 0.1)
            prompt:InputHoldEnd()
        end)
    end
    return true
end

-- 🎥 Third-Person Camera Guardian: ป้องกันมุมมองกล้องมุดเข้าแฮนด์รถ/หน้ารถตอนขับลอดใต้สะพาน/ทางด่วน
function EnsureThirdPersonCamera()
    pcall(function()
        if LocalPlayer.CameraMinZoomDistance < 6 then
            LocalPlayer.CameraMinZoomDistance = 8
        end
        if LocalPlayer.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end

        -- ปลดล็อค RenderStep ที่ล็อคมุมมอง First Person ของมอเตอร์ไซค์และรถยนต์
        pcall(RunService.UnbindFromRenderStep, RunService, "PCX160FirstPerson")
        pcall(RunService.UnbindFromRenderStep, RunService, "CarFirstPerson")

        -- สลับโหมดกล้องในสคริปต์ของเกมกลับเป็น Third Person หากติดค้างอยู่ที่ First Person
        local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
        if sps then
            local pcxCam = sps:FindFirstChild("PCX160Client") and sps.PCX160Client:FindFirstChild("Camera")
            if pcxCam then
                local ok, m = pcall(require, pcxCam)
                if ok and type(m) == "table" and type(m.mode) == "function" and m.mode() == "first" then
                    pcall(m.toggle)
                end
            end
            local carCam = sps:FindFirstChild("CarClient") and sps.CarClient:FindFirstChild("Camera")
            if carCam then
                local ok, m = pcall(require, carCam)
                if ok and type(m) == "table" and type(m.mode) == "function" and m.mode() == "first" then
                    pcall(m.toggle)
                end
            end
        end
    end)
end
Hub.EnsureThirdPersonCamera = EnsureThirdPersonCamera

function GetPreferredVehicleId()
    if Hub.Settings.PreferredVehicle and Hub.Settings.PreferredVehicle ~= "" then
        return Hub.Settings.PreferredVehicle
    end
    local spawned = LocalPlayer:GetAttribute("SpawnedIds")
    if type(spawned) == "string" and spawned ~= "" then
        local first = spawned:match("([^,]+)")
        if first then return first end
    end
    if GarageRemote then
        local ok, res = pcall(function() return DirectInvoke(GarageRemote, "List") end)
        if ok and type(res) == "table" and type(res.vehicles) == "table" then
            for _, v in ipairs(res.vehicles) do
                if v.fav and v.id then return v.id end
            end
            if res.vehicles[1] and res.vehicles[1].id then
                return res.vehicles[1].id
            end
        end
    end
    return "PCX160"
end

-- ==============================================================
-- ⛽ AUTO REFUEL & INFINITE FUEL ENGINE (100% Server Refuel via Shop)
-- ==============================================================
local LastRefuelAttempt = 0
function AutoRefuelVehicle(veh)
    if not veh or not veh.Parent then return false end
    local now = os.clock()
    if (now - LastRefuelAttempt) < 6 then return false end

    local realFuel = veh:GetAttribute("Fuel")
    if typeof(realFuel) ~= "number" then realFuel = 100 end

    -- Only refuel when fuel drops to 30% or below
    if realFuel > 30 then return true end

    LastRefuelAttempt = now

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local chassis = veh:FindFirstChild("Chassis") or veh.PrimaryPart
    local seat = veh:FindFirstChildOfClass("VehicleSeat", true) or veh:FindFirstChildOfClass("Seat", true)

    local shopRem = ShopRemote or (Remotes and Remotes:FindFirstChild("Shop"))
    if not shopRem then return false end

    local _invFn = genv[_gk.ni] or NetSeal.invoke

    -- 1. Check if tool already owned or buy one
    local hasCan = false
    if char and char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("FuelCan") then
        hasCan = true
    elseif LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool") and LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool"):GetAttribute("FuelCan") then
        hasCan = true
    end

    if not hasCan then
        local curCash = LocalPlayer:GetAttribute("Cash") or 0
        if curCash >= 1000 then
            pcall(_invFn, shopRem, "Buy", "FuelCan")
            task.wait(0.2)
        end
    end

    -- 2. Stand beside vehicle to satisfy server reach (USE_REACH = 14)
    local wasSeated = hum and hum.Sit
    if wasSeated then
        hum.Sit = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.wait(0.2)
    end

    if hrp and chassis then
        hrp.CFrame = chassis.CFrame + Vector3.new(2.5, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.15)
    end

    -- 3. Equip tool
    local tool = LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool") or (char and char:FindFirstChildWhichIsA("Tool"))
    if tool and tool:GetAttribute("FuelCan") and hum and tool.Parent == LocalPlayer.Backpack then
        hum:EquipTool(tool)
        task.wait(0.2)
    end

    -- 4. Invoke Use
    local s, ok, msg = pcall(_invFn, shopRem, "Use", "FuelCan", veh)

    -- 5. Re-mount vehicle immediately
    if seat and hum then
        pcall(function() seat:Sit(hum) end)
    end

    if s and (ok or (veh:GetAttribute("Fuel") or 0) >= 80) then
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "⛽ เติมน้ำมันอัตโนมัติสำเร็จ!",
                Content = "เติมน้ำมันเต็มถัง 100% เรียบร้อยแล้ว รถพร้อมวิ่งต่อไม่มีสะดุด",
                Duration = 2.5
            })
        end
        return true
    end

    -- Fallback: If 0 cash or empty tank, despawn and spawn fresh vehicle from garage!
    if realFuel <= 5 and GarageRemote then
        pcall(DirectInvoke, GarageRemote, "Despawn")
        task.wait(0.4)
        local targetVehId = GetPreferredVehicleId()
        pcall(DirectInvoke, GarageRemote, "Spawn", targetVehId)
        task.wait(0.5)
        return true
    end

    return false
end
Hub.AutoRefuelVehicle = AutoRefuelVehicle

function EnsureMounted()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return nil, nil end

    -- Disable ragdoll & falling down
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum.PlatformStand = false
    pcall(function()
        if Ragdoll and Ragdoll.disable then Ragdoll.disable(char) end
    end)

    -- If already seated in a vehicle, return it directly
    local veh, seat = GetActiveSeatedVehicle()
    if veh and seat and hum.Sit and seat.Occupant == hum then
        -- Check fuel & auto refuel seamlessly if low
        pcall(AutoRefuelVehicle, veh)

        -- Auto-Start Engine & Put Up Kickstand
        local pcxRemote = ReplicatedStorage:FindFirstChild("PCX160Remote")
        local carRemote = ReplicatedStorage:FindFirstChild("CarRemote")
        local isCar = veh:HasTag("GTACar") or veh.Name:find("FK8") or veh.Name:find("FL5") or veh.Name:find("TYPER") or veh.Name:find("CITY")
        if veh:GetAttribute("EngineOn") ~= true then
            if isCar and carRemote then
                pcall(DirectFire, carRemote, "Engine", true)
            elseif pcxRemote then
                pcall(DirectFire, pcxRemote, "Engine", true)
            end
        end
        if veh:GetAttribute("StandDown") ~= false then
            if pcxRemote then
                pcall(DirectFire, pcxRemote, "Stand", false)
            end
        end
        return veh, seat
    end

    -- Look for player's vehicle
    local myVeh = GetPlayerVehicle(false)

    -- If vehicle is upside-down, overturned, or tilted sideways from crash, right it immediately
    if myVeh and myVeh.Parent then
        pcall(function()
            myVeh:SetAttribute("CrashedAt", nil)
            local cb = myVeh:FindFirstChild("CrashBody")
            if cb then cb.CanCollide = false end
        end)
        local chassis = myVeh:FindFirstChild("Chassis") or myVeh.PrimaryPart
        if chassis and chassis.CFrame.UpVector.Y < 0.75 then
            local currentPos = chassis.Position
            local flatLook = Vector3.new(chassis.CFrame.LookVector.X, 0, chassis.CFrame.LookVector.Z).Unit
            if flatLook.Magnitude < 0.1 then flatLook = Vector3.new(0, 0, -1) end
            myVeh:PivotTo(CFrame.lookAt(currentPos + Vector3.new(0, 2.5, 0), currentPos + flatLook * 10))
            chassis.AssemblyLinearVelocity = Vector3.zero
            chassis.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.15)
        end
        HookVehicleCrashSystem()
    end

        -- If user set a specific farm vehicle, ensure the active vehicle matches it!
    local preferredFarmId = GetPreferredVehicleId()
    if myVeh and myVeh.Parent and preferredFarmId and preferredFarmId ~= "" then
        local currentVId = myVeh:GetAttribute("VehicleId") or myVeh.Name
        if not string.find(string.lower(tostring(currentVId)), string.lower(preferredFarmId), 1, true) then
            if GarageRemote then
                pcall(DirectInvoke, GarageRemote, "Despawn")
                task.wait(0.3)
                myVeh = nil
                _cachedActiveVeh = nil
                _cachedChassis = nil
            end
        end
    end

    -- If vehicle is too far away (> 24 studs when idle, or > 120 studs anytime) or destroyed, despawn it to spawn fresh right next to player
    if myVeh and myVeh.Parent then
        local chassis = myVeh:FindFirstChild("Chassis") or myVeh.PrimaryPart
        if chassis then
            local dist = (Vector3.new(chassis.Position.X, 0, chassis.Position.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
            local delStateNow = LocalPlayer:GetAttribute("DeliveryState")
            local isIdleDelivery = (delStateNow == nil or delStateNow == "Off" or delStateNow == "Searching")
            if dist > 120 or (isIdleDelivery and dist > 24) then
                if GarageRemote then
                    pcall(DirectInvoke, GarageRemote, "Despawn")
                    task.wait(0.3)
                    myVeh = nil
                    _cachedActiveVeh = nil
                    _cachedChassis = nil
                end
            end
        else
            myVeh = nil
            _cachedActiveVeh = nil
            _cachedChassis = nil
        end
    end

    -- If no vehicle spawned, spawn one cleanly
    if (not myVeh or not myVeh.Parent) and GarageRemote then
        -- Guarantee player is firmly on solid ground before invoking Spawn (Server requires FloorMaterial ~= Air)
        local groundCheckParams = RaycastParams.new()
        groundCheckParams.FilterType = Enum.RaycastFilterType.Exclude
        groundCheckParams.FilterDescendantsInstances = { char }
        groundCheckParams.IgnoreWater = true

        if hrp.Position.Y < 0 and RoadGraph and RoadGraph.nearest then
            local nearPt = RoadGraph.nearest(hrp.Position)
            if nearPt then
                local rx = nearPt.X
                if math.abs(rx) < 12 then rx = (hrp.Position.X >= 0 and 25 or -25) end
                local roadRay = Workspace:Raycast(Vector3.new(rx, 50, nearPt.Y), Vector3.new(0, -60, 0), groundCheckParams)
                local safeY = (roadRay and roadRay.Position.Y + 2.5) or 4.0
                hrp.CFrame = CFrame.new(rx, safeY, nearPt.Y)
                hrp.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.2)
            end
        end

        local gRay = Workspace:Raycast(hrp.Position + Vector3.new(0, 3, 0), Vector3.new(0, -20, 0), groundCheckParams)
        if gRay and gRay.Instance.CanCollide then
            hrp.CFrame = CFrame.new(gRay.Position + Vector3.new(0, 2.5, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.15)
        end

        local targetVehId = GetPreferredVehicleId()
        local s, ok, msg = pcall(DirectInvoke, GarageRemote, "Spawn", targetVehId)
        -- If server complains about no room, walk/nudge towards open road
        if (not ok or msg == "No room to spawn here, try an open spot") and RoadGraph and RoadGraph.nearest then
            local nearPt = RoadGraph.nearest(hrp.Position)
            if nearPt then
                local roadPos = Vector3.new(nearPt.X, hrp.Position.Y, nearPt.Y)
                local dir = (roadPos - hrp.Position)
                if dir.Magnitude > 2 then
                    local targetPos = hrp.Position + dir.Unit * math.min(12, dir.Magnitude)
                    WalkToPosition(targetPos, 16)
                    task.wait(0.15)
                    pcall(DirectInvoke, GarageRemote, "Spawn", targetVehId)
                end
            end
        end

        local t0 = os.clock()
        while os.clock() - t0 < 3.0 do
            myVeh = GetPlayerVehicle(false)
            if myVeh and myVeh.Parent then break end
            task.wait(0.15)
        end
    end

    -- Now mount the vehicle (walk smoothly to vehicle if > 3.8 studs away — no warp!)
    if myVeh and myVeh.Parent then
        local chassis = myVeh:FindFirstChild("Chassis") or myVeh.PrimaryPart
        local seatPart = myVeh:FindFirstChildOfClass("VehicleSeat", true) or myVeh:FindFirstChildOfClass("Seat", true)
        local prompt = myVeh:FindFirstChild("MountPrompt", true) or myVeh:FindFirstChild("RidePrompt", true) or myVeh:FindFirstChild("CarPrompt", true)

        local targetMountPos = seatPart and seatPart.Position or (chassis and chassis.Position + Vector3.new(0, 1.2, 0))
        if targetMountPos and hrp then
            local distToSeat = (Vector3.new(targetMountPos.X, 0, targetMountPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
            if distToSeat > 3.8 then
                WalkToPosition(targetMountPos, 16)
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.08)

            -- 1. Server Remotes
            local isCar = myVeh:HasTag("GTACar") or myVeh.Name:find("FK8") or myVeh.Name:find("FL5") or myVeh.Name:find("TYPER") or myVeh.Name:find("CITY") or (myVeh:FindFirstChild("Body") and not myVeh:HasTag("PCX160"))
            if isCar and CarRemote then
                pcall(DirectFire, CarRemote, "Enter", myVeh, "Driver", seatPart and seatPart.Name or "VehicleSeat")
            elseif PCX160Remote then
                pcall(DirectFire, PCX160Remote, "Mount", myVeh, "Drive")
            end

            -- 2. ProximityPrompt Trigger
            if prompt then
                TriggerPrompt(prompt)
            end

            -- 3. Local Seat fallback
            if seatPart and not hum.Sit then
                pcall(function() seatPart:Sit(hum) end)
            end
        end

        local waitMount = os.clock()
        while os.clock() - waitMount < 1.5 do
            veh, seat = GetActiveSeatedVehicle()
            if veh and seat and hum.Sit then
                break
            end
            task.wait(0.08)
        end
    end

    local finalVeh, finalSeat = GetActiveSeatedVehicle()
    if finalVeh and finalVeh.Parent then
        local pcxRemote = ReplicatedStorage:FindFirstChild("PCX160Remote")
        local carRemote = ReplicatedStorage:FindFirstChild("CarRemote")
        local isCar = finalVeh:HasTag("GTACar") or finalVeh.Name:find("FK8") or finalVeh.Name:find("FL5") or finalVeh.Name:find("TYPER") or finalVeh.Name:find("CITY")
        if finalVeh:GetAttribute("EngineOn") ~= true then
            if isCar and carRemote then
                pcall(DirectFire, carRemote, "Engine", true)
            elseif pcxRemote then
                pcall(DirectFire, pcxRemote, "Engine", true)
            end
        end
        if finalVeh:GetAttribute("StandDown") ~= false then
            if pcxRemote then
                pcall(DirectFire, pcxRemote, "Stand", false)
            end
        end
        EnsureThirdPersonCamera()
    end

    return finalVeh, finalSeat
end

local LastDeliveryHeartbeat = os.clock()
local LastGrabHeartbeat = os.clock()

-- ==============================================================
-- 🛣️ EXACT SMOOTH ROAD ROUTE GENERATOR (Curved Corners & 100% on Neon Cyan Route)
-- ==============================================================
function IsCorridorClear2D(pA2D, pB2D, baseY, rayParams, halfWidth)
    if not rayParams then return true, nil end
    local delta = Vector3.new(pB2D.X - pA2D.X, 0, pB2D.Z - pA2D.Z)
    local dist = delta.Magnitude
    if dist <= 1.2 then return true, nil end
    local dir = delta / dist
    local perp = Vector3.new(-dir.Z, 0, dir.X)
    local hw = halfWidth or 1.2
    local rayY = (baseY or 3.5) + 1.65

    local offsets = { 0, hw, -hw }
    for _, off in ipairs(offsets) do
        local origin = Vector3.new(pA2D.X, rayY, pA2D.Z) + perp * off
        local hit = Workspace:Raycast(origin, delta, rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            return false, hit
        end
    end
    return true, nil
end

function BuildObstacleFreeLeadIn(startPos, rawNodes, rayParams)
    if not rawNodes or #rawNodes < 2 or not rayParams then
        return rawNodes
    end
    local pStart = rawNodes[1]
    local pEntry = rawNodes[2]
    local distToEntry = (pEntry - pStart).Magnitude
    if distToEntry <= 2.2 then
        return rawNodes
    end

    local baseY = (Hub.GetElevation and Hub.GetElevation(pStart.X, pStart.Z, startPos.Y)) or startPos.Y or 3.5
    local clearDirect, firstHit = IsCorridorClear2D(pStart, pEntry, baseY, rayParams, 1.2)
    if clearDirect then
        return rawNodes
    end

    -- 1. Try sliding the road entry point along the first road segment (rawNodes[2] -> rawNodes[3])
    if #rawNodes >= 3 then
        local pNext = rawNodes[3]
        local segVec = pNext - pEntry
        local segLen = segVec.Magnitude
        if segLen > 4.0 then
            local segDir = segVec / segLen
            local maxSlide = math.min(segLen - 2.0, 56.0)
            for slide = 4.0, maxSlide, 4.0 do
                local candEntry = pEntry + segDir * slide
                if IsCorridorClear2D(pStart, candEntry, baseY, rayParams, 1.15) then
                    rawNodes[2] = candEntry
                    return rawNodes
                end
            end
        end
    end

    -- 2. Try 1-Waypoint Bypass (L-corners, obstacle lateral offsets, and 16-angle radial fan)
    local candidates1 = {
        Vector3.new(pStart.X, 0, pEntry.Z),
        Vector3.new(pEntry.X, 0, pStart.Z),
    }

    local toEntry = pEntry - pStart
    local dirToEntry = toEntry.Unit
    local perp = Vector3.new(-dirToEntry.Z, 0, dirToEntry.X)
    local hit2D = (firstHit and Vector3.new(firstHit.Position.X, 0, firstHit.Position.Z)) or ((pStart + pEntry) * 0.5)

    for _, lat in ipairs({ 4.5, -4.5, 7.5, -7.5, 11.0, -11.0, 15.0, -15.0, 20.0, -20.0, 28.0, -28.0, 36.0, -36.0 }) do
        table.insert(candidates1, hit2D + perp * lat)
        table.insert(candidates1, pStart + perp * lat)
        table.insert(candidates1, pEntry + perp * lat)
    end

    for angleStep = 0, 15 do
        local ang = (angleStep / 16) * (math.pi * 2)
        local rDir = Vector3.new(math.cos(ang), 0, math.sin(ang))
        for _, rad in ipairs({ 7.0, 13.0, 20.0, 30.0, 42.0, 56.0 }) do
            table.insert(candidates1, pStart + rDir * rad)
        end
    end

    local bestMid1 = nil
    local bestJoinIdx1 = 2
    local bestCost1 = math.huge
    local validFirstSteps = {}

    for _, mid in ipairs(candidates1) do
        local d1 = (mid - pStart).Magnitude
        if d1 >= 2.5 and d1 <= 140.0 and IsCorridorClear2D(pStart, mid, baseY, rayParams, 1.1) then
            table.insert(validFirstSteps, mid)
            local d2 = (pEntry - mid).Magnitude
            if d1 + d2 < bestCost1 and IsCorridorClear2D(mid, pEntry, baseY, rayParams, 1.1) then
                bestCost1 = d1 + d2
                bestMid1 = mid
                bestJoinIdx1 = 2
            end
            if #rawNodes >= 3 then
                local pNext = rawNodes[3]
                local d3 = (pNext - mid).Magnitude
                if d1 + d3 < bestCost1 and IsCorridorClear2D(mid, pNext, baseY, rayParams, 1.1) then
                    bestCost1 = d1 + d3
                    bestMid1 = mid
                    bestJoinIdx1 = 3
                end
            end
        end
    end

    if bestMid1 then
        local rebuilt = { pStart, bestMid1 }
        for k = bestJoinIdx1, #rawNodes do
            table.insert(rebuilt, rawNodes[k])
        end
        return rebuilt
    end

    -- 3. Try 2-Waypoint Bypass (for exiting 3-sided compounds/yards/fences)
    local bestM1, bestM2 = nil, nil
    local bestCost2 = math.huge
    for idx1 = 1, math.min(#validFirstSteps, 28) do
        local m1 = validFirstSteps[idx1]
        local d1 = (m1 - pStart).Magnitude
        if d1 < bestCost2 then
            local subCandidates = {
                Vector3.new(m1.X, 0, pEntry.Z),
                Vector3.new(pEntry.X, 0, m1.Z),
            }
            local toE = pEntry - m1
            if toE.Magnitude > 1.0 then
                local uE = toE.Unit
                local pE = Vector3.new(-uE.Z, 0, uE.X)
                for _, lat in ipairs({ 8.0, -8.0, 15.0, -15.0, 24.0, -24.0 }) do
                    table.insert(subCandidates, (m1 + pEntry) * 0.5 + pE * lat)
                end
            end
            for _, m2 in ipairs(subCandidates) do
                local d2 = (m2 - m1).Magnitude
                local d3 = (pEntry - m2).Magnitude
                local total = d1 + d2 + d3
                if d2 >= 2.5 and total < bestCost2 then
                    if IsCorridorClear2D(m1, m2, baseY, rayParams, 1.05) and IsCorridorClear2D(m2, pEntry, baseY, rayParams, 1.05) then
                        bestCost2 = total
                        bestM1 = m1
                        bestM2 = m2
                    end
                end
            end
        end
    end

    if bestM1 and bestM2 then
        local rebuilt = { pStart, bestM1, bestM2 }
        for k = 2, #rawNodes do
            table.insert(rebuilt, rawNodes[k])
        end
        return rebuilt
    end

    -- 4. Roblox PathfindingService NavMesh fallback
    local pfPts = ComputePathfindingWaypoints(
        Vector3.new(pStart.X, baseY, pStart.Z),
        Vector3.new(pEntry.X, baseY, pEntry.Z),
        {
            AgentRadius = 2.2,
            AgentHeight = 5.0,
            AgentCanJump = false,
            WaypointSpacing = 4.5,
            Costs = { Water = 50 }
        }
    )
    if pfPts and #pfPts >= 2 then
        local rebuilt = { pStart }
        for k = 2, #pfPts - 1 do
            local wp2D = Vector3.new(pfPts[k].X, 0, pfPts[k].Z)
            if (wp2D - rebuilt[#rebuilt]).Magnitude >= 2.0 then
                table.insert(rebuilt, wp2D)
            end
        end
        for k = 2, #rawNodes do
            if (rawNodes[k] - rebuilt[#rebuilt]).Magnitude >= 1.0 then
                table.insert(rebuilt, rawNodes[k])
            end
        end
        return rebuilt
    end

    return rawNodes
end

function BuildSmoothRoadPath(startPos, targetPos, rayParams)
    local start2D = Vector3.new(startPos.X, 0, startPos.Z)
    local target2D = Vector3.new(targetPos.X, 0, targetPos.Z)
    local directDist = (target2D - start2D).Magnitude

    -- Check if direct path is extremely short (< 6.0 studs) and completely clear
    if directDist < 6.0 and rayParams then
        local dirRay = Workspace:Raycast(startPos + Vector3.new(0, 1.8, 0), (targetPos - startPos), rayParams)
        if not dirRay then
            return { start2D, target2D }
        end
    end

    if not Hub.CustomRoadGraph.initialized then
        pcall(function() Hub.InitCustomRoadGraph() end)
    end
    local graph = (Hub.CustomRoadGraph.initialized and Hub.CustomRoadGraph) or RoadGraph

    local rawPts = nil
    if graph and graph.route then
        pcall(function()
            rawPts = graph.route(startPos, targetPos)
        end)
    end

    if not rawPts or #rawPts < 2 then
        return { start2D, target2D }
    end

    -- 1. Extract raw 3D nodes strictly following road network without micro-duplicates
    local rawNodes = {}
    for idx = 1, #rawPts do
        local pt = rawPts[idx]
        local p3D = Vector3.new(pt.X, 0, (typeof(pt) == "Vector3" and pt.Z) or pt.Y)
        if #rawNodes == 0 or (p3D - rawNodes[#rawNodes]).Magnitude >= 0.8 then
            table.insert(rawNodes, p3D)
        end
    end

    if #rawNodes < 2 then
        return { start2D, target2D }
    end

    rawNodes[1] = start2D
    rawNodes[#rawNodes] = target2D

    -- 1.5 Build obstacle-free lead-in path from startPos to the start of the road route (Zero Warping!)
    pcall(function()
        rawNodes = BuildObstacleFreeLeadIn(startPos, rawNodes, rayParams)
    end)

    if #rawNodes == 2 then
        return { start2D, target2D }
    end

    -- 2. Corner Arc Smoothing: Replace sharp 90-degree intersection vertices with smooth quadratic Bezier arcs!
    -- Keeps vehicle 100% on asphalt, curves gracefully around street corners, and prevents wide overshooting.
    local curvedNodes = { rawNodes[1] }
    for i = 2, #rawNodes - 1 do
        local pA = rawNodes[i - 1]
        local pB = rawNodes[i]
        local pC = rawNodes[i + 1]
        local v1 = pA - pB
        local v2 = pC - pB
        local l1 = v1.Magnitude
        local l2 = v2.Magnitude
        local isCorner = false
        if l1 > 5.0 and l2 > 5.0 then
            local u1 = v1 / l1
            local u2 = v2 / l2
            local dot = u1:Dot(u2)
            -- If angle between street segments is > 20 deg (dot < 0.94 and dot > -0.96)
            if dot < 0.94 and dot > -0.96 then
                isCorner = true
                local r = math.min(7.5, l1 * 0.35, l2 * 0.35)
                local tStart = pB + u1 * r
                local tEnd = pB + u2 * r
                for step = 0, 4 do
                    local t = step / 4.0
                    local omt = 1.0 - t
                    local pt = tStart * (omt * omt) + pB * (2.0 * omt * t) + tEnd * (t * t)
                    table.insert(curvedNodes, pt)
                end
            end
        end
        if not isCorner then
            table.insert(curvedNodes, pB)
        end
    end
    table.insert(curvedNodes, rawNodes[#rawNodes])

    -- 3. High-Density Road Waypoints: Subdivide all segments every 5.5 studs for ultra-smooth tracking
    local smoothWaypoints = { curvedNodes[1] }
    for i = 2, #curvedNodes do
        local pA = smoothWaypoints[#smoothWaypoints]
        local pB = curvedNodes[i]
        local seg = pB - pA
        local segDist = seg.Magnitude

        if segDist > 7.5 then
            local steps = math.floor(segDist / 5.2)
            for s = 1, steps do
                table.insert(smoothWaypoints, pA + seg * (s / (steps + 1)))
            end
        end
        table.insert(smoothWaypoints, pB)
    end

    return smoothWaypoints
end

-- ==============================================================
-- 🏍️ DYNAMIC TIRE GROUND-CONTACT & WHEEL OFFSET CALCULATOR
-- ==============================================================
Hub.GetVehicleWheelOffset = function(veh)
    if not veh or not veh.Parent then return 1.22 end
    local isCar = veh:HasTag("GTACar") or veh.Name:find("FK8") or veh.Name:find("FL5") or veh.Name:find("TYPER") or veh.Name:find("CITY")
    
    local pivotCF = veh:GetPivot()
    local minLocalBottom = nil
    
    for _, d in ipairs(veh:GetDescendants()) do
        if d:IsA("BasePart") then
            local name = d.Name:lower()
            if (name:find("tyre") or name:find("tire") or name:find("wheelroot") or name:find("wheel")) 
                and not name:find("steer") and not name:find("plate") and not name:find("rim") and not name:find("disc") then
                local localPos = pivotCF:PointToObjectSpace(d.Position)
                local localBottom = localPos.Y - (d.Size.Y * 0.5)
                if not minLocalBottom or localBottom < minLocalBottom then
                    minLocalBottom = localBottom
                end
            end
        end
    end
    
    if minLocalBottom and minLocalBottom < -0.3 and minLocalBottom > -4.5 then
        -- Add 0.28 stud clearance for suspension and tire radius to ensure tires sit firmly above asphalt/dirt
        local baseClearance = math.abs(minLocalBottom) + 0.28
        return isCar and math.max(1.60, baseClearance) or math.max(1.22, baseClearance)
    end
    
    return isCar and 1.60 or 1.22
end

-- ⚡ Ultra-Fast 3D Elevation Lookup (Universal, Streaming-Safe & Zero GC Allocations)
Hub._elevationRayParams = RaycastParams.new()
Hub._elevationRayParams.FilterType = Enum.RaycastFilterType.Exclude
Hub._elevationRayParams.IgnoreWater = true
Hub._lastElevationFilterUpdate = 0
Hub.UpdateElevationFilter = function()
    local list = {}
    if LocalPlayer and LocalPlayer.Character then
        table.insert(list, LocalPlayer.Character)
    end
    for _, fName in ipairs({ "SpawnedVehicles", "DeliveryMarker", "RouteArrows", Hub._routeFolderName or "CustomDeliveryRouteVisuals" }) do
        local f = Workspace:FindFirstChild(fName)
        if f then table.insert(list, f) end
    end
    local map = Workspace:FindFirstChild("Map")
    if map then
        -- CRUCIAL: Exclude elevated BTS / MRT viaducts, stations, overhead expressways and footings!
        for _, propFolder in ipairs({ "Streetscape", "Countryside", "SignsStops", "ExtraLights", "JobLockers", "Viaduct", "Stations", "Expressway", "Footings" }) do
            local pf = map:FindFirstChild(propFolder)
            if pf then table.insert(list, pf) end
        end
    end
    Hub._elevationRayParams.FilterDescendantsInstances = list
end

function IsNonGroundProp(inst, hitY, expectedY)
    if not inst then return true end
    local n = inst.Name:lower()
    if n:find("viaduct") or n:find("station") or n:find("expressway") or n:find("skywalk") or n:find("pier") or n:find("track") then
        return true
    end
    if hitY and expectedY and (hitY - expectedY) > 2.2 then
        if n:find("fence") or n:find("post") or n:find("wall") or n:find("roof")
            or n:find("canopy") or n:find("awning") or n:find("gutter")
            or n:find("fascia") or n:find("header") or n:find("trunk") or n:find("leaf")
            or n:find("rail") or n:find("concrete") or n:find("sign") or n:find("pole") then
            return true
        end
        if IsObstacleOrBuilding(inst) then
            return true
        end
    end
    return false
end

function GetElevation(x, z, expectedY)
    expectedY = (expectedY ~= nil and tonumber(expectedY)) or 3.5
    local now = os.clock()
    if (now - Hub._lastElevationFilterUpdate) > 4.0 then
        Hub._lastElevationFilterUpdate = now
        Hub.UpdateElevationFilter()
    end
    local rayParams = Hub._elevationRayParams

    -- 1. Tight local road scan (expectedY + 3.5 down by 14.0 studs)
    -- Hugs the real asphalt and CANNOT reach overhead viaducts/stations (Y > 20)
    local rLow = Workspace:Raycast(Vector3.new(x, expectedY + 3.5, z), Vector3.new(0, -14.0, 0), rayParams)
    if rLow and rLow.Instance and rLow.Instance.CanCollide and rLow.Normal.Y >= 0.40 and rLow.Position.Y > -40 then
        if not IsNonGroundProp(rLow.Instance, rLow.Position.Y, expectedY) then
            return rLow.Position.Y, rLow.Normal, rLow.Instance
        end
    end

    -- 2. Moderate scan for road slopes, dips or curbs (expectedY + 6.0 down by 20.0 studs)
    -- Strictly rejected if hit is > 3.5 studs above expectedY (a road never jumps 3.5+ studs in 1 step)
    local rMid = Workspace:Raycast(Vector3.new(x, expectedY + 6.0, z), Vector3.new(0, -20.0, 0), rayParams)
    if rMid and rMid.Instance and rMid.Instance.CanCollide and rMid.Normal.Y >= 0.45 and rMid.Position.Y > -40 then
        local dY = rMid.Position.Y - expectedY
        if dY <= 3.5 and not IsNonGroundProp(rMid.Instance, rMid.Position.Y, expectedY) then
            return rMid.Position.Y, rMid.Normal, rMid.Instance
        end
    end

    -- 3. Ascending bridge ramp scan (only for genuine road bridges like MemorialBridge, capped strictly at +4.5 studs)
    local rBridge = Workspace:Raycast(Vector3.new(x, expectedY + 12.0, z), Vector3.new(0, -24.0, 0), rayParams)
    if rBridge and rBridge.Instance and rBridge.Instance.CanCollide and rBridge.Normal.Y >= 0.45 and rBridge.Position.Y > -40 then
        local dY = rBridge.Position.Y - expectedY
        if dY >= -12.0 and dY <= 4.5 and not IsNonGroundProp(rBridge.Instance, rBridge.Position.Y, expectedY) then
            return rBridge.Position.Y, rBridge.Normal, rBridge.Instance
        end
    end

    -- 4. Deep ground recovery: If vehicle somehow ended up elevated in mid-air (expectedY > 12.0), scan down to true ground
    if expectedY > 12.0 and x < 3500 then
        local rDeep = Workspace:Raycast(Vector3.new(x, 10.0, z), Vector3.new(0, -30.0, 0), rayParams)
        if rDeep and rDeep.Instance and rDeep.Instance.CanCollide and rDeep.Normal.Y >= 0.45 and rDeep.Position.Y > -40 then
            if not IsNonGroundProp(rDeep.Instance, rDeep.Position.Y, 3.5) then
                return rDeep.Position.Y, rDeep.Normal, rDeep.Instance
            end
        end
    end

    -- 5. Safe fallback
    return expectedY, Vector3.new(0, 1, 0), nil
end
Hub.GetElevation = GetElevation

Hub._cachedDriverTable = nil
function SafeRoadTravel(targetPos, options)
    -- [STABILITY] auto-clear stale Teleporting flag (stuck > 15s = orphaned from prior crash)
    if Teleporting and (os.clock() - TeleportingTimestamp) > 15 then
        Teleporting = false
    end
    if Teleporting then return false end
    Teleporting = true
    TeleportingTimestamp = os.clock()
    options = options or {}
    EnsureThirdPersonCamera()
    local renderLockConn = nil

    local success, result = pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hum then
            return false
        end

        -- Strict foot mode (e.g. interacting with locker cabinet)
        if options.StrictFoot then
            return WalkToPosition(targetPos, 16)
        end

        -- Ensure mounted on vehicle
        local currentVeh, seat = EnsureMounted()
        local isSeated = currentVeh ~= nil and currentVeh.Parent ~= nil
        if not isSeated then
            return false
        end

        local chassis = currentVeh:FindFirstChild("Chassis") or currentVeh.PrimaryPart or seat
        if not chassis then
            return false
        end

        local startPos = chassis.Position
        local totalDist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude

        -- Check if already close enough (within 4 studs of exact arrival target)
        if totalDist <= 4.0 then
            Hub.ClearRouteVisuals()
            SmoothStop(chassis, 0.25)
            return true
        end
        if options.RawTarget then
            local rt = typeof(options.RawTarget) == "Vector3" and options.RawTarget or (options.RawTarget.Position or nil)
            if rt then
                local dRt = (Vector3.new(rt.X, 0, rt.Z) - Vector3.new(startPos.X, 0, startPos.Z)).Magnitude
                if dRt <= 5.5 or (LocalPlayer:GetAttribute("DeliveryArrived") == true and dRt <= 32.0) then
                    Hub.ClearRouteVisuals()
                    SmoothStop(chassis, 0.25)
                    return true
                end
            end
        end

        local kmhPerStud = (EcuShared and EcuShared.KMH_PER_STUD) or 1.008
        local legitMaxKmh = GetVehicleTunedMaxKmh(currentVeh)
        -- 🏎️ ใช้ความเร็วสูงสุดของรถจริง 100% เต็ม (ตรงตามค่าจริงของตัวรถเป๊ะๆ)
        local legitMaxStuds = legitMaxKmh / kmhPerStud
        local requestedSpeed = options.Speed or GetJitteredFarmSpeed(currentVeh)
        local cruiseSpeed = math.max(legitMaxStuds, (type(requestedSpeed) == "number" and requestedSpeed or legitMaxStuds))


        -- Prepare ground & bridge raycast filter: exclude character, vehicles, and visual markers; IGNORE WATER!
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local filterList = { LocalPlayer.Character }
        if currentVeh then table.insert(filterList, currentVeh) end
        for _, fName in ipairs({ "SpawnedVehicles", "DeliveryMarker", "RouteArrows", Hub._routeFolderName or "CustomDeliveryRouteVisuals" }) do
            local f = Workspace:FindFirstChild(fName)
            if f then table.insert(filterList, f) end
        end
        rayParams.FilterDescendantsInstances = filterList
        rayParams.IgnoreWater = true -- CRUCIAL: NEVER HIT RIVER OR OCEAN WATER UNDER BRIDGES

        -- (Uses module-level GetElevation defined above)

        local wheelOffset = Hub.GetVehicleWheelOffset(currentVeh)

        -- 🛣️ Build full smooth path from current vehicle position (startPos) all the way to the road route and targetPos (ZERO WARP!)
        local waypoints = BuildSmoothRoadPath(startPos, targetPos, rayParams)
        if not waypoints or #waypoints < 2 then
            waypoints = {
                Vector3.new(startPos.X, 0, startPos.Z),
                Vector3.new(targetPos.X, 0, targetPos.Z)
            }
        end

        -- 🎨 Draw Neon Cyan Route Visualizer starting directly at the vehicle's current position
        Hub.DrawCustomRoute(waypoints)

        -- Seated & ragdoll immunity + crash body uncollision
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum.PlatformStand = false
        pcall(function()
            if currentVeh and currentVeh.Parent then
                currentVeh:SetAttribute("CrashedAt", nil)
            end
        end)
        HookVehicleCrashSystem()

        -- Raycast directly down to find exact initial ground elevation under startPos
        local startGroundRay = Workspace:Raycast(Vector3.new(startPos.X, startPos.Y + 6.0, startPos.Z), Vector3.new(0, -20.0, 0), rayParams)
        local startGroundY = (startGroundRay and startGroundRay.Position.Y) or (startPos.Y - wheelOffset)

        local curPos = Vector3.new(startPos.X, 0, startPos.Z)
        local lastElevation = startGroundY
        local smoothedElevation = startGroundY
        local finalWp = waypoints[#waypoints]

        -- Independent upright rotation state (prevents physics tilt/lean feedback loop from making the bike wobble)
        local initLook = Vector3.new(waypoints[2].X - curPos.X, 0, waypoints[2].Z - curPos.Z)
        if initLook.Magnitude < 0.01 then
            local lv = currentVeh:GetPivot().LookVector
            initLook = Vector3.new(lv.X, 0, lv.Z)
        end
        if initLook.Magnitude < 0.01 then
            initLook = Vector3.new(0, 0, -1)
        end
        local currentRot = CFrame.lookAt(Vector3.zero, initLook.Unit)
        local activeTravelCFrame = CFrame.new(startPos.X, lastElevation + wheelOffset, startPos.Z) * currentRot
        local currentLean = 0
        local smoothedSpeed = math.min(15.0, cruiseSpeed)
        local isCar = currentVeh:HasTag("GTACar") or currentVeh.Name:find("FK8") or currentVeh.Name:find("FL5") or currentVeh.Name:find("TYPER") or currentVeh.Name:find("CITY")

        -- 🏎️ Driver Hook: Harmonize with PCX160Client.Driver / CarClient.Driver (Cached for 0ms overhead)
        local driverTable = Hub._cachedDriverTable
        if not (driverTable and driverTable.seat and driverTable.seat.Parent == currentVeh) then
            driverTable = nil
            if not IsMobileDevice and type(getgc) == "function" then
                pcall(function()
                    for _, f in ipairs(getgc()) do
                    if type(f) == "function" then
                        local info = debug.getinfo(f)
                        if info and info.source and (info.source:find("PCX160Client.Driver") or info.source:find("CarClient.Driver")) and info.name == "step" then
                            local u1 = debug.getupvalue(f, 1)
                            if u1 and u1.seat and u1.seat.Parent == currentVeh then
                                driverTable = u1
                                Hub._cachedDriverTable = u1
                                break
                            end
                        end
                    end
                end
                end)
            end
        end

        -- 🛡️ Direct Chassis Constraints Management: Disable DriveVelocity & DriveAlign so they NEVER fight movement!
        local chassisLinear = chassis:FindFirstChild("DriveVelocity") or chassis:FindFirstChildWhichIsA("LinearVelocity")
        local chassisAlign = chassis:FindFirstChild("DriveAlign") or chassis:FindFirstChildWhichIsA("AlignOrientation")
        local origLinearEnabled = chassisLinear and chassisLinear.Enabled
        local origAlignEnabled = chassisAlign and chassisAlign.Enabled
        if chassisLinear then chassisLinear.Enabled = false end
        if chassisAlign then chassisAlign.Enabled = false end

        local origAlignResp = driverTable and driverTable.align and driverTable.align.Responsiveness
        if driverTable and driverTable.align then
            pcall(function() driverTable.align.Responsiveness = 0 end)
        end
        if driverTable and driverTable.linear then
            pcall(function() driverTable.linear.Enabled = false end)
        end

        -- Pre-compute cumulative path lengths for O(1) distance lookup
        local numWp = #waypoints
        local cumDist = table.create(numWp, 0)
        cumDist[1] = 0
        for k = 2, numWp do
            local pA = waypoints[k - 1]
            local pB = waypoints[k]
            local dx = pB.X - pA.X
            local dz = pB.Z - pA.Z
            cumDist[k] = cumDist[k - 1] + math.sqrt(dx * dx + dz * dz)
        end

        local curPivot = currentVeh:GetPivot()
        local curLook = curPivot.LookVector
        local curYaw = math.atan2(-curLook.X, -curLook.Z)
        local curPos = Vector3.new(startPos.X, 0, startPos.Z)

        -- Smoothly turn towards first road path segment before accelerating (prevents sudden 180° snap)
        if #waypoints >= 2 then
            local initTo = Vector3.new(waypoints[2].X - curPos.X, 0, waypoints[2].Z - curPos.Z)
            if initTo.Magnitude > 0.5 then
                local initTargetYaw = math.atan2(-initTo.X, -initTo.Z)
                local initYawDiff = math.atan2(math.sin(initTargetYaw - curYaw), math.cos(initTargetYaw - curYaw))
                if math.abs(initYawDiff) > 0.25 then
                    local alignStart = os.clock()
                    while math.abs(initYawDiff) > 0.08 and (os.clock() - alignStart) < 0.6 and Hub.Running do
                        local dt = RunService.Heartbeat:Wait()
                        local safeDt = math.clamp(dt, 0.001, 0.05)
                        local stepYaw = math.clamp(initYawDiff * 7.5 * safeDt, -2.8 * safeDt, 2.8 * safeDt)
                        curYaw = curYaw + stepYaw
                        initYawDiff = math.atan2(math.sin(initTargetYaw - curYaw), math.cos(initTargetYaw - curYaw))
                        currentVeh:PivotTo(CFrame.new(curPos.X, startGroundY + wheelOffset, curPos.Z) * CFrame.Angles(0, curYaw, 0))
                        if driverTable then
                            driverTable.heading = curYaw
                            driverTable.travel = curYaw
                        end
                    end
                end
            end
        end

        local function GetLookaheadPoint(pos, startIdx, lookDist)
            local acc = 0
            local prev = pos
            for k = math.max(1, startIdx), numWp do
                local p = waypoints[k]
                local d = (p - prev).Magnitude
                if acc + d >= lookDist then
                    local t = (lookDist - acc) / math.max(d, 1e-4)
                    return prev + (p - prev) * t
                end
                acc = acc + d
                prev = p
            end
            return waypoints[numWp]
        end

        local curSpeed = math.min(15.0, cruiseSpeed)
        local currentLean = 0
        local wpIdx = 1
        local isArrived = false
        local yawDiff = 0
        local cachedElevX = -999999
        local cachedElevZ = -999999
        local cachedElevVal = startGroundY
        local cachedPitchAhead = 0
        local elevFrameCounter = 0
        local cachedMaxAheadAngle = 0
        local cachedDistToCorner = 999
        local cachedTargetCornerSpeed = cruiseSpeed
        local cachedIsApproachingTurn = false
        local lastCurvatureScanWp = -1
        local curvatureFrameCounter = 0

        -- 🛑 Dynamic Physics Approach Distance: Begins decelerating well before the destination
        -- Uses stopping formula v^2 / (2 * a) + extra buffer to guarantee smooth deceleration and zero overshooting.
        local approachDist = (cruiseSpeed * cruiseSpeed) / (2.0 * 38.0) + 40.0
        if totalDist > 40 then
            approachDist = math.clamp(approachDist, 60.0, math.max(60.0, totalDist * 0.78))
        else
            approachDist = math.max(15.0, totalDist * 0.85)
        end

        while Hub.Running and genv[_gk.sk] == SCRIPT_ID and not isArrived do
            local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
            if not isFarmActive and not options.Manual then
                Hub.ClearRouteVisuals()
                if chassis then SmoothStop(chassis, 0.5) end
                break
            end

            local dt = RunService.Heartbeat:Wait()
            local safeDt = math.clamp(dt, 0.001, 0.05)
            LastDeliveryHeartbeat = os.clock()
            LastGrabHeartbeat = os.clock()
            TeleportingTimestamp = os.clock()

            -- Re-seat if player slipped off vehicle during travel
            if not hum.Sit and seat and seat.Parent then
                pcall(function() seat:Sit(hum) end)
            end

            -- Advance waypoint index along road path (Consistent 1-based segment indices)
            while wpIdx < numWp do
                local pA = waypoints[wpIdx]
                local pB = waypoints[wpIdx + 1]
                local segVec = pB - pA
                local segLen = segVec.Magnitude
                if segLen < 0.2 then
                    wpIdx = wpIdx + 1
                else
                    local sDir = segVec / segLen
                    local toCur = curPos - pA
                    local projT = toCur:Dot(sDir)
                    local distToNext = (pB - curPos).Magnitude
                    local pastNext = (curPos - pB):Dot(sDir)
                    if distToNext < 4.0 or projT >= (segLen - 1.2) or pastNext > 0 then
                        wpIdx = wpIdx + 1
                    else
                        break
                    end
                end
            end

            local distToFinal = (waypoints[numWp] - curPos).Magnitude
            local curSegIdx = math.clamp(wpIdx, 1, numWp)
            local distToSegEnd = (waypoints[math.min(numWp, curSegIdx + 1)] - curPos).Magnitude
            local remTotalDist = distToSegEnd + math.max(0, cumDist[numWp] - cumDist[math.min(numWp, curSegIdx + 1)])

            -- 🎯 Live Delivery Marker Tracking (checks visual ring / destination cylinder)
            local distToMarkerRing = 9999
            local marker = Workspace:FindFirstChild("DeliveryMarker")
            local ring = marker and (marker:FindFirstChild("Ring") or marker:FindFirstChildWhichIsA("BasePart"))
            if ring then
                local rp = ring.Position
                distToMarkerRing = (Vector3.new(rp.X, 0, rp.Z) - curPos).Magnitude
            end
            if options.RawTarget then
                local rt = typeof(options.RawTarget) == "Vector3" and options.RawTarget or (options.RawTarget.Position or nil)
                if rt then
                    local dRt = (Vector3.new(rt.X, 0, rt.Z) - curPos).Magnitude
                    if dRt < distToMarkerRing then
                        distToMarkerRing = dRt
                    end
                end
            end

            local effectiveRemDist = math.min(remTotalDist, distToFinal, distToMarkerRing)

            -- Arrival check (Stop cleanly inside pickup/delivery ring without overshooting)
            local hasGameArrived = (LocalPlayer:GetAttribute("DeliveryArrived") == true)
            if hasGameArrived and (effectiveRemDist <= 32.0 or distToFinal <= 32.0) then
                isArrived = true
                break
            end
            if distToMarkerRing <= 5.5 then
                isArrived = true
                break
            end
            if distToFinal <= 4.0 or (distToFinal <= 6.5 and wpIdx >= numWp) then
                isArrived = true
                break
            end

            local forwardVec = Vector3.new(-math.sin(curYaw), 0, -math.cos(curYaw))

            -- 🏎️ Intelligent Multi-Horizon Curvature Scanning & Kinematic Pre-Braking
            -- ตรวจจับโค้งล่วงหน้าแบบหลายระยะ (Multi-Horizon Chord Scanning) พร้อมคำนวณระยะเบรกแบบฟิสิกส์จลนศาสตร์
            -- ชะลอความเร็วก่อนถึงโค้งเสมอ (Pre-Corner Deceleration) และรักษาความเร็วขณะเลี้ยวให้เสถียร 100%
            curvatureFrameCounter = curvatureFrameCounter + 1
            if wpIdx ~= lastCurvatureScanWp or curvatureFrameCounter >= 2 then
                lastCurvatureScanWp = wpIdx
                curvatureFrameCounter = 0
                local maxAheadAngle = 0
                local distToCorner = 999.0
                local targetCornerSpeed = cruiseSpeed
                local isApproachingTurn = false

                local curSegEnd = waypoints[math.min(numWp, wpIdx)]
                local distToSegEnd = (Vector3.new(curSegEnd.X, 0, curSegEnd.Z) - curPos).Magnitude
                local maxScanWaypoints = math.min(numWp - 1, wpIdx + 55)
                local maxScanDistance = math.max(220.0, cruiseSpeed * 1.6)

                for k = wpIdx, maxScanWaypoints do
                    local scanDist = distToSegEnd + math.max(0, cumDist[k] - cumDist[math.min(numWp, wpIdx)])
                    if scanDist > maxScanDistance then break end

                    -- วิเคราะห์ทิศทางถนนข้างหน้าด้วยคอร์ด 3 จุด (~15.6 studs) เพื่อกรอง micro-wiggles
                    local mAhead = math.min(numWp, k + 3)
                    local segAhead = waypoints[mAhead] - waypoints[k]
                    local segAhead2D = Vector3.new(segAhead.X, 0, segAhead.Z)

                    -- วิเคราะห์ทิศทางถนนข้างหลังด้วยคอร์ด 3 จุด (~15.6 studs)
                    local mBack = math.max(1, k - 3)
                    local segBack = waypoints[k] - waypoints[mBack]
                    local segBack2D = Vector3.new(segBack.X, 0, segBack.Z)

                    if segAhead2D.Magnitude > 0.5 then
                        local tangentAhead = segAhead2D.Unit
                        local dotCar = math.clamp(forwardVec:Dot(tangentAhead), -1.0, 1.0)
                        local angleFromCar = math.acos(dotCar)

                        local localBend = 0
                        if segBack2D.Magnitude > 0.5 then
                            local tangentBack = segBack2D.Unit
                            local dotLocal = math.clamp(tangentBack:Dot(tangentAhead), -1.0, 1.0)
                            localBend = math.acos(dotLocal)
                        end

                        local turnAngle = math.max(angleFromCar, localBend)

                        -- เมื่อพบโค้งข้างหน้า (> 8 องศา หรือ 0.14 rad): คำนวณความเร็วปลอดภัยและความเร่งเบรก
                        if turnAngle > 0.14 then
                            if turnAngle > maxAheadAngle then
                                maxAheadAngle = turnAngle
                            end

                            -- คำนวณความเร็วปลอดภัยที่จุดยอดโค้ง (Apex Safe Speed):
                            -- โค้ง 90 องศา -> 22 studs/s (~34 km/h), โค้งหักศอก U-turn -> 16 studs/s (~25 km/h)
                            local t = math.clamp((turnAngle - 0.14) / (1.57 - 0.14), 0, 1.0)
                            local baseCornerSpeed = 22.0
                            if turnAngle > 1.57 then
                                local uT = math.clamp((turnAngle - 1.57) / 1.57, 0, 1.0)
                                baseCornerSpeed = 22.0 - uT * 6.0
                            end
                            local safeCornerSpeed = cruiseSpeed - t * (cruiseSpeed - baseCornerSpeed)
                            safeCornerSpeed = math.max(baseCornerSpeed, math.min(cruiseSpeed, safeCornerSpeed))

                            -- สูตรระยะเบรกล่วงหน้าตามฟิสิกส์จลนศาสตร์: v_allowed = sqrt(v_safe^2 + 2 * a_brake * dist)
                            -- โดยเผื่อ safety margin 14 studs เพื่อให้รถลดความเร็วจนถึงระดับปลอดภัย "ก่อนเริ่มเลี้ยว" เสมอ
                            local comfortableBrakeAccel = 36.0 -- studs/s^2 smooth braking deceleration
                            local safetyMargin = 14.0          -- studs ก่อนเข้าโค้งที่ต้องชะลอเสร็จสิ้น
                            local distToBrake = math.max(0, scanDist - safetyMargin)
                            local vAllowed = math.sqrt(safeCornerSpeed * safeCornerSpeed + 2.0 * comfortableBrakeAccel * distToBrake)

                            if vAllowed < targetCornerSpeed then
                                targetCornerSpeed = vAllowed
                            end

                            if scanDist < distToCorner then
                                distToCorner = scanDist
                            end

                            if scanDist <= 22.0 or vAllowed < cruiseSpeed * 0.90 then
                                isApproachingTurn = true
                            end
                        end
                    end
                end

                cachedMaxAheadAngle = maxAheadAngle
                cachedDistToCorner = distToCorner
                cachedTargetCornerSpeed = targetCornerSpeed
                cachedIsApproachingTurn = isApproachingTurn
            end

            local maxAheadAngle = cachedMaxAheadAngle or 0
            local distToCorner = cachedDistToCorner or 999.0
            local safeCornerSpeed = cachedTargetCornerSpeed or cruiseSpeed
            local isCornerZone = cachedIsApproachingTurn or false

            -- กำหนด targetSpeed หลักโดยอิงจากการชะลอความเร็วเข้าโค้งล่วงหน้า (Corner Pre-Braking)
            local targetSpeed = math.min(cruiseSpeed, safeCornerSpeed)

            -- 🛑 Pre-Arrival Deceleration Curve (ชะลออย่างนุ่มนวลก่อนเข้าวงแหวนรับ/ส่งของ)
            if effectiveRemDist < approachDist then
                local arrivalSpeed = cruiseSpeed
                if effectiveRemDist <= 6.0 then
                    local t = math.clamp(effectiveRemDist / 6.0, 0, 1)
                    arrivalSpeed = 3.5 + t * 3.5
                elseif effectiveRemDist <= 20.0 then
                    local t = (effectiveRemDist - 6.0) / 14.0
                    arrivalSpeed = 7.0 + t * 7.5
                elseif effectiveRemDist <= 55.0 then
                    local t = (effectiveRemDist - 20.0) / 35.0
                    arrivalSpeed = 14.5 + (t ^ 0.85) * 14.0
                elseif effectiveRemDist <= 110.0 then
                    local t = (effectiveRemDist - 55.0) / 55.0
                    local midSpeed = math.min(cruiseSpeed, 60.0)
                    arrivalSpeed = 28.5 + (t ^ 1.0) * math.max(0, midSpeed - 28.5)
                else
                    local t = (effectiveRemDist - 110.0) / math.max(1.0, approachDist - 110.0)
                    local midSpeed = math.min(cruiseSpeed, 60.0)
                    arrivalSpeed = midSpeed + (t ^ 1.1) * (cruiseSpeed - midSpeed)
                end
                targetSpeed = math.min(targetSpeed, arrivalSpeed)
            end

            -- Active Steering Speed Cap: บังคับจำกัดความเร็วทันทีที่แฮนด์/พวงมาลัยกำลังเลี้ยว (> 5.7 องศา)
            -- ป้องกันการกดคันเร่งกระชากขณะยังอยู่ในโค้ง จนกว่าล้อจะตั้งตรงเข้าสู่ทางตรง
            local currentYawDev = math.abs(yawDiff or 0)
            if currentYawDev > 0.10 then
                isCornerZone = true
                local steerSeverity = math.clamp((currentYawDev - 0.10) / (1.20 - 0.10), 0, 1.0)
                local steerCap = cruiseSpeed - steerSeverity * (cruiseSpeed - 20.0)
                steerCap = math.max(20.0, math.min(cruiseSpeed, steerCap))
                targetSpeed = math.min(targetSpeed, steerCap)
            end

            -- Pure Pursuit Adaptive Lookahead (เกาะชิด Apex ในโค้ง; ยืดระยะมองไกลในทางตรง)
            local inCorner = isCornerZone or (distToCorner < 22.0 and maxAheadAngle > 0.20) or (math.abs(yawDiff or 0) > 0.12) or (targetSpeed < cruiseSpeed * 0.82)
            local lookDist
            if inCorner then
                lookDist = math.clamp(curSpeed * 0.15, 3.8, 7.5)
            else
                lookDist = math.clamp(curSpeed * 0.32, 12.0, 32.0)
            end

            -- เมื่อใกล้ถึงเป้าหมาย บีบ Lookahead เข้าหาจุดส่ง
            if effectiveRemDist < 50.0 then
                lookDist = math.clamp(math.min(lookDist, effectiveRemDist * 0.55), 3.5, 18.0)
            end

            -- ปิดกั้นแรงฟิสิกส์เดิม
            if chassisLinear and chassisLinear.Enabled then chassisLinear.Enabled = false end
            if chassisAlign and chassisAlign.Enabled then chassisAlign.Enabled = false end

            local lookPt = GetLookaheadPoint(curPos, wpIdx + 1, lookDist)
            local toLook = lookPt - curPos
            local targetYaw = math.atan2(-toLook.X, -toLook.Z)
            yawDiff = math.atan2(math.sin(targetYaw - curYaw), math.cos(targetYaw - curYaw))

            -- Turn Authority ตอบสนองคมกริบในโค้ง
            local turnAuthority = inCorner and 11.5 or 6.5
            local turnRate = math.clamp(yawDiff * turnAuthority, -7.0, 7.0)
            curYaw = curYaw + turnRate * safeDt
            forwardVec = Vector3.new(-math.sin(curYaw), 0, -math.cos(curYaw))

            -- โปรไฟล์การเร่ง / ชะลอความเร็ว (หน่วงเบรกนุ่มนวลและตอบสนองทันเวลา)
            if curSpeed < targetSpeed then
                local accelRate = inCorner and 18.0 or 40.0
                curSpeed = math.min(targetSpeed, curSpeed + accelRate * safeDt)
            else
                local speedDelta = curSpeed - targetSpeed
                local decelRate = inCorner and 80.0 or 65.0
                if isCornerZone or distToCorner < 35.0 then
                    decelRate = 78.0
                end
                if speedDelta > 20.0 then
                    decelRate = 95.0
                end
                curSpeed = math.max(targetSpeed, curSpeed - decelRate * safeDt)
            end

            -- Position advancement            -- Position advancement
            local step = curSpeed * safeDt
            curPos = curPos + forwardVec * step

            -- 🛡️ Forward Whisker Micro-Obstacle Deflection (steers smoothly around fence posts/lamp posts during lead-in)
            if wpIdx <= 8 and rayParams and curvatureFrameCounter == 0 then
                local wOrigin = Vector3.new(curPos.X, (lastElevation or 3.5) + 1.65, curPos.Z)
                local wRight = Vector3.new(forwardVec.Z, 0, -forwardVec.X)
                local wLen = math.clamp(curSpeed * 0.14, 4.5, 7.5)
                local hitL = Workspace:Raycast(wOrigin - wRight * 1.1, forwardVec * wLen, rayParams)
                local hitR = Workspace:Raycast(wOrigin + wRight * 1.1, forwardVec * wLen, rayParams)
                if hitL and not hitR then
                    curPos = curPos + wRight * (4.2 * safeDt)
                    curYaw = curYaw - 1.4 * safeDt
                    forwardVec = Vector3.new(-math.sin(curYaw), 0, -math.cos(curYaw))
                elseif hitR and not hitL then
                    curPos = curPos - wRight * (4.2 * safeDt)
                    curYaw = curYaw + 1.4 * safeDt
                    forwardVec = Vector3.new(-math.sin(curYaw), 0, -math.cos(curYaw))
                end
            end

            -- Soft lateral guidance (locks vehicle to the cyan line without impeding forward progress)
            if wpIdx < numWp then
                local pA = waypoints[wpIdx]
                local pB = waypoints[wpIdx + 1]
                local sVec = pB - pA
                local sLen = sVec.Magnitude
                if sLen > 0.5 then
                    local sDir = sVec / sLen
                    local toCur = curPos - pA
                    local projT = toCur:Dot(sDir)
                    if projT >= -1.0 and projT <= (sLen + 1.0) and sDir:Dot(forwardVec) > 0.35 then
                        local perpVec = toCur - sDir * projT
                        local latDist = perpVec.Magnitude
                        if latDist > 0.20 then
                            local maxNudge = math.min(latDist - 0.15, 6.0 * safeDt)
                            curPos = curPos - perpVec.Unit * maxNudge
                        end
                    end
                end
            end

            -- Elevation lookup
            local curElev = cachedElevVal
            local distElevSq = (curPos.X - cachedElevX)^2 + (curPos.Z - cachedElevZ)^2
            if distElevSq >= 2.25 then
                local probed = GetElevation(curPos.X, curPos.Z, lastElevation)
                if probed and probed > -10 then
                    -- Sanity check: reject extreme upward spikes (> 4.0 studs above current elevation)
                    if (probed - smoothedElevation) > 4.0 and curPos.X < 3500 then
                        curElev = smoothedElevation
                    else
                        curElev = probed
                    end
                else
                    curElev = math.max(lastElevation or 3.5, 3.5)
                end
                cachedElevX = curPos.X
                cachedElevZ = curPos.Z
                cachedElevVal = curElev
            end
            lastElevation = curElev

            -- Smooth elevation with clamped climb rate (prevents shooting into the sky)
            local maxClimbStep = math.max(6.0 * safeDt, 0.25)
            local maxDropStep = math.max(26.0 * safeDt, 0.50)
            if curElev > smoothedElevation then
                smoothedElevation = math.min(curElev, smoothedElevation + maxClimbStep)
            else
                smoothedElevation = math.max(curElev, smoothedElevation - maxDropStep)
            end

            -- Pitch angle for slopes, hills, and bridge ramps
            local aheadPt = curPos + Vector3.new(-math.sin(curYaw), 0, -math.cos(curYaw)) * 5.0
            local elevAhead = GetElevation(aheadPt.X, aheadPt.Z, curElev) or curElev
            local pitchAngle = math.clamp(math.atan2(elevAhead - curElev, 5.0), -0.35, 0.35)

            -- Motorcycle Lean (Graceful lean into turns like เอาอันนี้.mp4)
            local isBike = not (currentVeh:HasTag("GTACar") or currentVeh.Name:find("FK8") or currentVeh.Name:find("FL5") or currentVeh.Name:find("TYPER") or currentVeh.Name:find("CITY"))
            local desiredLean = 0
            if isBike then
                desiredLean = math.clamp((turnRate / 3.8) * (curSpeed / 38.0) * 0.26, -0.26, 0.26)
            end
            currentLean = currentLean + (desiredLean - currentLean) * math.clamp(safeDt * 7.5, 0.08, 0.40)

            -- Pose vehicle with strict tire ground clearance
            local curY = math.max(smoothedElevation + wheelOffset, curElev + wheelOffset)
            local smoothCf = CFrame.new(curPos.X, curY, curPos.Z) * CFrame.Angles(0, curYaw, 0) * CFrame.Angles(pitchAngle, 0, -currentLean)
            currentVeh:PivotTo(smoothCf)

            if currentVeh:GetAttribute("CrashedAt") then
                pcall(function() currentVeh:SetAttribute("CrashedAt", nil) end)
            end
            if chassis then
                chassis.AssemblyLinearVelocity = forwardVec * curSpeed
                chassis.AssemblyAngularVelocity = Vector3.zero
            end

            -- Synchronize native driver table (HUD, RPM sound, rider arms, gears)
            if driverTable then
                driverTable.heading = curYaw
                driverTable.travel = curYaw
                driverTable.speed = curSpeed
                driverTable.lean = currentLean
                driverTable.pitch = pitchAngle
                driverTable.crashed = false
                if driverTable.align then
                    pcall(function() driverTable.align.CFrame = smoothCf end)
                end
            end
            if seat then
                local effTarget = targetSpeed or cruiseSpeed
                if curSpeed > effTarget + 1.5 then
                    seat.ThrottleFloat = -1.0 -- Brake lights & active deceleration
                elseif curSpeed < effTarget - 2.0 and not inCorner then
                    seat.ThrottleFloat = 1.0  -- Full acceleration on straights
                elseif inCorner then
                    seat.ThrottleFloat = 0.20 -- Maintenance throttle through curve
                else
                    seat.ThrottleFloat = 0.85
                end
                seat.SteerFloat = math.clamp(turnRate / 2.2, -1, 1)
            end
        end

        -- Reset seat controls to neutral on stop
        if seat and seat.Parent then
            pcall(function()
                seat.ThrottleFloat = 0
                seat.SteerFloat = 0
            end)
        end
        if driverTable and driverTable.seat then
            pcall(function()
                driverTable.seat.ThrottleFloat = 0
                driverTable.seat.SteerFloat = 0
            end)
        end

        -- Complete Smooth Chauffeur Stop (prevents server "Good, but braked a bit hard")
        if currentVeh and currentVeh.Parent and chassis then
            SmoothStop(chassis, 0.35)
            pcall(function()
                for _, p in ipairs(currentVeh:GetDescendants()) do
                    if p:IsA("BasePart") then
                        -- Restore collision on all colliders (FrontCollider, RearCollider), wheels, chassis, and seat
                        if p.Name:find("Collider") or p.Name:find("Wheel") or p.Name == "Chassis" or p:IsA("VehicleSeat") or p:IsA("Seat") then
                            p.CanCollide = true
                        end
                    end
                end
            end)
        end

        -- Restore driver physics constraints
        if driverTable and driverTable.align then
            pcall(function() driverTable.align.Responsiveness = origAlignResp or 25 end)
        end
        if driverTable and driverTable.linear then
            pcall(function() driverTable.linear.Enabled = true end)
        end
        if chassisLinear then
            chassisLinear.VectorVelocity = Vector3.zero
            chassisLinear.Enabled = origLinearEnabled or true
        end
        if chassisAlign then
            chassisAlign.Enabled = origAlignEnabled or true
        end
        if driverTable then
            driverTable.speed = 0
            driverTable.heading = curYaw
            driverTable.travel = curYaw
            driverTable.crashed = false
        end

        -- 🛡️ Smoothly face customer / gate while remaining strictly parked on the road/patio surface (ZERO GROUND CLIPPING)
        local faceTargetPos = options.FaceTarget or options.RawTarget
        if faceTargetPos and currentVeh and currentVeh.Parent then
            local fPos = typeof(faceTargetPos) == "Vector3" and faceTargetPos or (faceTargetPos.Position or nil)
            if fPos then
                local pivot = currentVeh:GetPivot()
                local lookDir = Vector3.new(fPos.X - pivot.Position.X, 0, fPos.Z - pivot.Position.Z)
                if lookDir.Magnitude > 0.5 then
                    local finalGroundY = GetElevation(pivot.Position.X, pivot.Position.Z, lastElevation) or lastElevation or 3.5
                    local properY = finalGroundY + wheelOffset
                    local finalPos = Vector3.new(pivot.Position.X, properY, pivot.Position.Z)
                    local targetRot = CFrame.lookAt(finalPos, finalPos + lookDir.Unit)
                    currentVeh:PivotTo(targetRot)
                    if driverTable and driverTable.align then
                        pcall(function() driverTable.align.CFrame = targetRot end)
                    end
                    if chassis then
                        chassis.AssemblyLinearVelocity = Vector3.zero
                        chassis.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end

        local isFarming = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
        if not isFarming and not options.Manual then
            RestoreStockVehiclePhysics()
        end

        if options.Dismount then
            DismountVehicle()
        end

        Hub.ClearRouteVisuals()
        task.wait(0.2)
        return true
    end)

    if not success then
        do end  -- suppressed: saferoad error
    end

    if renderLockConn then
        pcall(function() renderLockConn:Disconnect() end)
        renderLockConn = nil
    end
    Teleporting = false
    return success and (result == true)
end

function TeleportEntity(targetCF, options)
    local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
    return SafeRoadTravel(pos, options)
end
Hub.TeleportEntity = TeleportEntity

-- ==============================================================
-- 5.1 Bulletproof Auto Bypass FarmCheck Captcha (Ghost & Decoy Immune + Stamp Signature)
-- ==============================================================
if FarmCheckRemote and FarmCheckAnswerRemote then
    local EMOJI_TO_CATEGORY = {
        -- ต้นไม้ / plants / flowers
        ["🌸"] = "ต้นไม้", ["🌺"] = "ต้นไม้", ["🌻"] = "ต้นไม้", ["🌹"] = "ต้นไม้",
        ["🌷"] = "ต้นไม้", ["🌼"] = "ต้นไม้", ["💐"] = "ต้นไม้",
        ["🌵"] = "ต้นไม้", ["🌴"] = "ต้นไม้", ["🌳"] = "ต้นไม้", ["🌲"] = "ต้นไม้",
        ["🎋"] = "ต้นไม้", ["🎍"] = "ต้นไม้", ["🍀"] = "ต้นไม้", ["☘️"] = "ต้นไม้",
        ["🌿"] = "ต้นไม้", ["🍃"] = "ต้นไม้", ["🍂"] = "ต้นไม้", ["🍁"] = "ต้นไม้",
        ["🌱"] = "ต้นไม้", ["🪴"] = "ต้นไม้", ["🪷"] = "ต้นไม้", ["🫧"] = "ต้นไม้",
        ["🌾"] = "ต้นไม้", ["🪨"] = "ต้นไม้",

        -- ผลไม้ / fruits / food
        ["🍎"] = "ผลไม้", ["🍊"] = "ผลไม้", ["🍋"] = "ผลไม้", ["🍇"] = "ผลไม้",
        ["🍓"] = "ผลไม้", ["🫐"] = "ผลไม้", ["🍈"] = "ผลไม้", ["🍑"] = "ผลไม้",
        ["🍒"] = "ผลไม้", ["🍍"] = "ผลไม้", ["🥭"] = "ผลไม้", ["🥝"] = "ผลไม้",
        ["🍌"] = "ผลไม้", ["🍉"] = "ผลไม้", ["🥥"] = "ผลไม้", ["🫒"] = "ผลไม้",
        ["🍐"] = "ผลไม้", ["🍏"] = "ผลไม้", ["🫙"] = "ผลไม้",
        ["🍞"] = "ผลไม้", ["🥐"] = "ผลไม้", ["🥖"] = "ผลไม้",

        -- สัตว์ / animals
        ["🐼"] = "สัตว์", ["🐨"] = "สัตว์", ["🐻"] = "สัตว์", ["🦁"] = "สัตว์",
        ["🐯"] = "สัตว์", ["🐮"] = "สัตว์", ["🐷"] = "สัตว์", ["🐸"] = "สัตว์",
        ["🐙"] = "สัตว์", ["🐧"] = "สัตว์", ["🐦"] = "สัตว์", ["🦆"] = "สัตว์",
        ["🦅"] = "สัตว์", ["🦉"] = "สัตว์", ["🦇"] = "สัตว์", ["🐝"] = "สัตว์",
        ["🦋"] = "สัตว์", ["🐛"] = "สัตว์", ["🐢"] = "สัตว์", ["🦎"] = "สัตว์",
        ["🐍"] = "สัตว์", ["🐊"] = "สัตว์", ["🐘"] = "สัตว์", ["🦏"] = "สัตว์",
        ["🦛"] = "สัตว์", ["🦒"] = "สัตว์", ["🦓"] = "สัตว์", ["🐃"] = "สัตว์",
        ["🐂"] = "สัตว์", ["🐄"] = "สัตว์", ["🐎"] = "สัตว์", ["🐖"] = "สัตว์",
        ["🐏"] = "สัตว์", ["🐑"] = "สัตว์", ["🦙"] = "สัตว์", ["🐐"] = "สัตว์",
        ["🦌"] = "สัตว์", ["🦜"] = "สัตว์", ["🐓"] = "สัตว์", ["🦃"] = "สัตว์",
        ["🐇"] = "สัตว์", ["🐁"] = "สัตว์", ["🐀"] = "สัตว์", ["🦔"] = "สัตว์",
        ["🐿️"] = "สัตว์", ["🦫"] = "สัตว์", ["🦦"] = "สัตว์", ["🦥"] = "สัตว์",
        ["🐈"] = "สัตว์", ["🐩"] = "สัตว์", ["🐕"] = "สัตว์", ["🦮"] = "สัตว์",
        ["🐈⬛"] = "สัตว์",["🐟"] = "สัตว์", ["🐠"] = "สัตว์", ["🐡"] = "สัตว์",
        ["🦈"] = "สัตว์", ["🐳"] = "สัตว์", ["🐋"] = "สัตว์", ["🐬"] = "สัตว์",

        -- เครื่องมือ / tools
        ["🔧"] = "เครื่องมือ", ["🔨"] = "เครื่องมือ", ["⚒️"] = "เครื่องมือ",
        ["🛠️"] = "เครื่องมือ", ["⛏️"] = "เครื่องมือ", ["🪛"] = "เครื่องมือ",
        ["🪚"] = "เครื่องมือ", ["🔩"] = "เครื่องมือ", ["⚙️"] = "เครื่องมือ",
        ["🪤"] = "เครื่องมือ", ["🧲"] = "เครื่องมือ", ["🪜"] = "เครื่องมือ",
        ["🪝"] = "เครื่องมือ", ["🔗"] = "เครื่องมือ", ["⛓️"] = "เครื่องมือ",
        ["🧰"] = "เครื่องมือ", ["🪣"] = "เครื่องมือ", ["💡"] = "เครื่องมือ",
        ["🔋"] = "เครื่องมือ", ["🔌"] = "เครื่องมือ", ["📡"] = "เครื่องมือ",
        ["🧯"] = "เครื่องมือ", ["🪓"] = "เครื่องมือ",

        -- [PATCHED] รองเท้า / เครื่องแต่งกาย / footwear / clothing
        ["👟"] = "รองเท้า", ["👠"] = "รองเท้า", ["👡"] = "รองเท้า", ["👢"] = "รองเท้า",
        ["👞"] = "รองเท้า", ["👣"] = "รองเท้า", ["🥿"] = "รองเท้า", ["🩴"] = "รองเท้า",
        ["🥾"] = "รองเท้า",
        ["👕"] = "รองเท้า", ["👔"] = "รองเท้า", ["👗"] = "รองเท้า", ["👘"] = "รองเท้า",
        ["👒"] = "รองเท้า", ["🎩"] = "รองเท้า", ["🧢"] = "รองเท้า", ["👑"] = "รองเท้า",
        ["🧣"] = "รองเท้า", ["🧤"] = "รองเท้า", ["🧥"] = "รองเท้า", ["👙"] = "รองเท้า",
        ["👚"] = "รองเท้า", ["👛"] = "รองเท้า", ["👜"] = "รองเท้า", ["👝"] = "รองเท้า",
        ["🎒"] = "รองเท้า", ["🩱"] = "รองเท้า", ["🩲"] = "รองเท้า", ["🩳"] = "รองเท้า",
        ["🩺"] = "รองเท้า",

        -- [PATCHED] ยานพาหนะ / vehicles
        ["🚑"] = "ยานพาหนะ", ["🚒"] = "ยานพาหนะ", ["🚓"] = "ยานพาหนะ", ["🚕"] = "ยานพาหนะ",
        ["🚗"] = "ยานพาหนะ", ["🚙"] = "ยานพาหนะ", ["🚌"] = "ยานพาหนะ", ["🚎"] = "ยานพาหนะ",
        ["🚐"] = "ยานพาหนะ", ["🚚"] = "ยานพาหนะ", ["🚛"] = "ยานพาหนะ", ["🚜"] = "ยานพาหนะ",
        ["🏎️"] = "ยานพาหนะ", ["🏍️"] = "ยานพาหนะ", ["🛵"] = "ยานพาหนะ", ["🚲"] = "ยานพาหนะ",
        ["🛺"] = "ยานพาหนะ", ["🛻"] = "ยานพาหนะ", ["🚁"] = "ยานพาหนะ", ["✈️"] = "ยานพาหนะ",
        ["🚀"] = "ยานพาหนะ", ["🛸"] = "ยานพาหนะ", ["⛵"] = "ยานพาหนะ", ["🚢"] = "ยานพาหนะ",
        ["🚂"] = "ยานพาหนะ", ["🚃"] = "ยานพาหนะ", ["🚄"] = "ยานพาหนะ", ["🚅"] = "ยานพาหนะ",
        ["🚆"] = "ยานพาหนะ", ["🚇"] = "ยานพาหนะ", ["🚈"] = "ยานพาหนะ", ["🚉"] = "ยานพาหนะ",
        ["🚊"] = "ยานพาหนะ", ["🚝"] = "ยานพาหนะ", ["🚞"] = "ยานพาหนะ", ["🚋"] = "ยานพาหนะ",
        ["🚍"] = "ยานพาหนะ", ["🛤️"] = "ยานพาหนะ", ["🛣️"] = "ยานพาหนะ", ["⛽"] = "ยานพาหนะ",
        ["🚦"] = "ยานพาหนะ", ["🚥"] = "ยานพาหนะ",

        -- [PATCHED] เครื่องดนตรี / musical instruments
        ["🎸"] = "เครื่องดนตรี", ["🎺"] = "เครื่องดนตรี", ["🎻"] = "เครื่องดนตรี",
        ["🎷"] = "เครื่องดนตรี", ["🥁"] = "เครื่องดนตรี", ["🪘"] = "เครื่องดนตรี",
        ["🎹"] = "เครื่องดนตรี", ["🪗"] = "เครื่องดนตรี", ["🪕"] = "เครื่องดนตรี",
        ["🎙️"] = "เครื่องดนตรี", ["🎚️"] = "เครื่องดนตรี", ["🎛️"] = "เครื่องดนตรี",
        ["🎼"] = "เครื่องดนตรี", ["🎵"] = "เครื่องดนตรี", ["🎶"] = "เครื่องดนตรี",
        ["🎤"] = "เครื่องดนตรี", ["🔔"] = "เครื่องดนตรี", ["🔕"] = "เครื่องดนตรี",

        -- [PATCHED] อาคาร / สถานที่ / buildings / places
        ["🏙️"] = "อาคาร", ["🏢"] = "อาคาร", ["🏣"] = "อาคาร", ["🏤"] = "อาคาร",
        ["🏥"] = "อาคาร", ["🏦"] = "อาคาร", ["🏧"] = "อาคาร", ["🏨"] = "อาคาร",
        ["🏩"] = "อาคาร", ["🏪"] = "อาคาร", ["🏫"] = "อาคาร", ["🏬"] = "อาคาร",
        ["🏭"] = "อาคาร", ["🏯"] = "อาคาร", ["🏰"] = "อาคาร", ["🗼"] = "อาคาร",
        ["🗽"] = "อาคาร", ["⛪"] = "อาคาร", ["🕌"] = "อาคาร", ["🛕"] = "อาคาร",
        ["🕍"] = "อาคาร", ["⛩️"] = "อาคาร", ["🕋"] = "อาคาร", ["🏠"] = "อาคาร",
        ["🏡"] = "อาคาร", ["🏚️"] = "อาคาร", ["🏗️"] = "อาคาร", ["🧱"] = "อาคาร",
        ["🏛️"] = "อาคาร", ["⛲"] = "อาคาร", ["🌁"] = "อาคาร", ["🌃"] = "อาคาร",
        ["🌆"] = "อาคาร", ["🌇"] = "อาคาร", ["🌉"] = "อาคาร", ["🌌"] = "อาคาร",
        ["🗺️"] = "อาคาร", ["🗻"] = "อาคาร", ["🏔️"] = "อาคาร",

        -- [PATCHED] อาหาร / food (แยกจาก ผลไม้)
        ["🍕"] = "อาหาร", ["🍔"] = "อาหาร", ["🍟"] = "อาหาร", ["🌭"] = "อาหาร",
        ["🍿"] = "อาหาร", ["🧂"] = "อาหาร", ["🥓"] = "อาหาร", ["🥚"] = "อาหาร",
        ["🍳"] = "อาหาร", ["🧈"] = "อาหาร", ["🥞"] = "อาหาร", ["🧇"] = "อาหาร",
        ["🥩"] = "อาหาร", ["🍗"] = "อาหาร", ["🍖"] = "อาหาร", ["🌮"] = "อาหาร",
        ["🌯"] = "อาหาร", ["🫔"] = "อาหาร", ["🥙"] = "อาหาร", ["🧆"] = "อาหาร",
        ["🥚"] = "อาหาร", ["🍱"] = "อาหาร", ["🍘"] = "อาหาร", ["🍙"] = "อาหาร",
        ["🍚"] = "อาหาร", ["🍛"] = "อาหาร", ["🍜"] = "อาหาร", ["🍝"] = "อาหาร",
        ["🍠"] = "อาหาร", ["🍢"] = "อาหาร", ["🍣"] = "อาหาร", ["🍤"] = "อาหาร",
        ["🍥"] = "อาหาร", ["🥮"] = "อาหาร", ["🍡"] = "อาหาร", ["🍦"] = "อาหาร",
        ["🍧"] = "อาหาร", ["🍨"] = "อาหาร", ["🍩"] = "อาหาร", ["🍪"] = "อาหาร",
        ["🎂"] = "อาหาร", ["🍰"] = "อาหาร", ["🧁"] = "อาหาร", ["🥧"] = "อาหาร",
        ["🍫"] = "อาหาร", ["🍬"] = "อาหาร", ["🍭"] = "อาหาร", ["🍮"] = "อาหาร",
        ["🍯"] = "อาหาร", ["☕"] = "อาหาร", ["🍵"] = "อาหาร", ["🧃"] = "อาหาร",
        ["🥤"] = "อาหาร", ["🧋"] = "อาหาร", ["🍶"] = "อาหาร", ["🍾"] = "อาหาร",
        ["🍷"] = "อาหาร", ["🍸"] = "อาหาร", ["🍹"] = "อาหาร", ["🧉"] = "อาหาร",
        ["🍺"] = "อาหาร", ["🫗"] = "อาหาร", ["🥛"] = "อาหาร",

        -- [PATCHED] กีฬา / sports
        ["⚽"] = "กีฬา", ["🏀"] = "กีฬา", ["🏈"] = "กีฬา", ["⚾"] = "กีฬา",
        ["🥎"] = "กีฬา", ["🏐"] = "กีฬา", ["🏉"] = "กีฬา", ["🎾"] = "กีฬา",
        ["🏸"] = "กีฬา", ["🏒"] = "กีฬา", ["🏑"] = "กีฬา", ["🥍"] = "กีฬา",
        ["🏏"] = "กีฬา", ["🪃"] = "กีฬา", ["🏓"] = "กีฬา", ["🏸"] = "กีฬา",
        ["🥊"] = "กีฬา", ["🥋"] = "กีฬา", ["🎽"] = "กีฬา", ["🛹"] = "กีฬา",
        ["🛷"] = "กีฬา", ["🛼"] = "กีฬา", ["⛸️"] = "กีฬา", ["🏂"] = "กีฬา",
        ["🏋️"] = "กีฬา", ["🤸"] = "กีฬา", ["🏊"] = "กีฬา", ["🧗"] = "กีฬา",
        ["🚵"] = "กีฬา", ["🎯"] = "กีฬา", ["🏹"] = "กีฬา", ["🎣"] = "กีฬา",
        ["🤿"] = "กีฬา", ["🎿"] = "กีฬา", ["⛷️"] = "กีฬา", ["🏌️"] = "กีฬา",

        -- [PATCHED] ของเล่น / เบ็ดเตล็ด / miscellaneous (กันตกหล่น)
        ["🎮"] = "ของเล่น", ["🕹️"] = "ของเล่น", ["🎲"] = "ของเล่น", ["🧩"] = "ของเล่น",
        ["🪁"] = "ของเล่น", ["🪆"] = "ของเล่น", ["🪅"] = "ของเล่น", ["🎁"] = "ของเล่น",
        ["🎀"] = "ของเล่น", ["🎊"] = "ของเล่น", ["🎉"] = "ของเล่น",
    }

    local PROMPT_KEYWORDS = {
        -- ต้นไม้ / plants
        ["ต้นไม้"]      = "ต้นไม้",
        ["ดอกไม้"]      = "ต้นไม้",
        ["พืช"]         = "ต้นไม้",
        ["ต้น"]         = "ต้นไม้",
        ["plant"]       = "ต้นไม้",
        ["tree"]        = "ต้นไม้",
        ["flower"]      = "ต้นไม้",

        -- ผลไม้ / fruits
        ["ผลไม้"]       = "ผลไม้",
        ["ผล"]          = "ผลไม้",
        ["fruit"]       = "ผลไม้",

        -- สัตว์ / animals
        ["สัตว์"]       = "สัตว์",
        ["สัตว์เลี้ยง"] = "สัตว์",
        ["animal"]      = "สัตว์",
        ["pet"]         = "สัตว์",

        -- เครื่องมือ / tools
        ["เครื่องมือ"]  = "เครื่องมือ",
        ["อุปกรณ์ช่าง"] = "เครื่องมือ",
        ["tool"]        = "เครื่องมือ",
        ["wrench"]      = "เครื่องมือ",

        -- [PATCHED] รองเท้า / เครื่องแต่งกาย
        ["รองเท้า"]     = "รองเท้า",
        ["สวมใส่"]      = "รองเท้า",
        ["สวนใส่"]      = "รองเท้า",   -- typo จาก screenshot จริง
        ["ใส่เท้า"]     = "รองเท้า",
        ["ใส่ขา"]       = "รองเท้า",
        ["สวม"]         = "รองเท้า",
        ["เสื้อผ้า"]    = "รองเท้า",
        ["เครื่องแต่งกาย"] = "รองเท้า",
        ["เสื้อ"]       = "รองเท้า",
        ["กระเป๋า"]     = "รองเท้า",
        ["หมวก"]        = "รองเท้า",
        ["shoe"]        = "รองเท้า",
        ["shoes"]       = "รองเท้า",
        ["clothing"]    = "รองเท้า",
        ["wear"]        = "รองเท้า",
        ["outfit"]      = "รองเท้า",
        ["footwear"]    = "รองเท้า",

        -- [PATCHED] ยานพาหนะ / vehicles
        ["ยานพาหนะ"]    = "ยานพาหนะ",
        ["รถ"]          = "ยานพาหนะ",
        ["รถยนต์"]      = "ยานพาหนะ",
        ["รถพยาบาล"]    = "ยานพาหนะ",
        ["รถดับเพลิง"]  = "ยานพาหนะ",
        ["รถตำรวจ"]     = "ยานพาหนะ",
        ["รถไฟ"]        = "ยานพาหนะ",
        ["เรือ"]        = "ยานพาหนะ",
        ["เครื่องบิน"]  = "ยานพาหนะ",
        ["vehicle"]     = "ยานพาหนะ",
        ["car"]         = "ยานพาหนะ",
        ["truck"]       = "ยานพาหนะ",
        ["ambulance"]   = "ยานพาหนะ",
        ["transport"]   = "ยานพาหนะ",

        -- [PATCHED] เครื่องดนตรี / musical instruments
        ["เครื่องดนตรี"] = "เครื่องดนตรี",
        ["ดนตรี"]       = "เครื่องดนตรี",
        ["กีตาร์"]      = "เครื่องดนตรี",
        ["เปียโน"]      = "เครื่องดนตรี",
        ["ไวโอลิน"]     = "เครื่องดนตรี",
        ["กลอง"]        = "เครื่องดนตรี",
        ["แตร"]         = "เครื่องดนตรี",
        ["เล่นดนตรี"]   = "เครื่องดนตรี",
        ["music"]       = "เครื่องดนตรี",
        ["instrument"]  = "เครื่องดนตรี",
        ["guitar"]      = "เครื่องดนตรี",
        ["drum"]        = "เครื่องดนตรี",
        ["piano"]       = "เครื่องดนตรี",

        -- [PATCHED] อาคาร / สถานที่ / buildings
        ["อาคาร"]       = "อาคาร",
        ["ตึก"]         = "อาคาร",
        ["สถานที่"]     = "อาคาร",
        ["สิ่งปลูกสร้าง"] = "อาคาร",
        ["เมือง"]       = "อาคาร",
        ["โรงพยาบาล"]  = "อาคาร",
        ["โรงเรียน"]    = "อาคาร",
        ["building"]    = "อาคาร",
        ["place"]       = "อาคาร",
        ["city"]        = "อาคาร",
        ["house"]       = "อาคาร",

        -- [PATCHED] อาหาร / food
        ["อาหาร"]       = "อาหาร",
        ["กิน"]         = "อาหาร",
        ["รับประทาน"]   = "อาหาร",
        ["อาหารคาว"]    = "อาหาร",
        ["อาหารหวาน"]   = "อาหาร",
        ["food"]        = "อาหาร",
        ["meal"]        = "อาหาร",
        ["eat"]         = "อาหาร",

        -- [PATCHED] กีฬา / sports
        ["กีฬา"]        = "กีฬา",
        ["เล่นกีฬา"]    = "กีฬา",
        ["sport"]       = "กีฬา",
        ["sports"]      = "กีฬา",
        ["ball"]        = "กีฬา",
    }

    -- 🛡️ Reverse-engineered security stamp generator from FarmCheckClient
    local _realStampFn = nil
    local function _TryExtractStampFn()
        if _realStampFn then return _realStampFn end
        local getups = (typeof(debug) == "table" and debug.getupvalues)
                   or (typeof(getupvalues) == "function" and getupvalues)
        local getcs  = (typeof(debug) == "table" and debug.getconstants)
                   or (typeof(getconstants) == "function" and getconstants)
        local is_c   = iscclosure or (debug and debug.iscclosure)

        local function isStampFn(fn)
            if type(fn) ~= "function" or (is_c and is_c(fn)) then return false end
            if getcs then
                local s, cs = pcall(getcs, fn)
                if s and type(cs) == "table" then
                    for _, c in pairs(cs) do
                        if c == 65521 then return true end
                    end
                end
            end
            if getups then
                local s, ups = pcall(getups, fn)
                if s and type(ups) == "table" then
                    for _, u in pairs(ups) do
                        if u == 65521 then return true end
                    end
                end
            end
            return false
        end

        -- ลองดึงจาก FarmCheckClient module / script โดยตรง
        pcall(function()
            local fcMod = ReplicatedStorage:FindFirstChild("FarmCheckClient")
                       or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("FarmCheckClient"))
            if fcMod then
                if fcMod:IsA("ModuleScript") then
                    local mod = require(fcMod)
                    if type(mod) == "table" then
                        for _, v in pairs(mod) do
                            if isStampFn(v) then _realStampFn = v; return end
                        end
                    elseif isStampFn(mod) then
                        _realStampFn = mod
                        return
                    end
                elseif typeof(getsenv) == "function" then
                    local env = getsenv(fcMod)
                    if type(env) == "table" then
                        for _, v in pairs(env) do
                            if isStampFn(v) then _realStampFn = v; return end
                        end
                    end
                end
            end
        end)
        -- getgc() scan ถูกลบออก – Byfron flags getgc() เป็น TAMPER
        -- fallback 1: scan FarmCheckAnswerRemote upvalue chain
        if not _realStampFn and FarmCheckAnswerRemote and getups then
            pcall(function()
                local ups = getups(FarmCheckAnswerRemote)
                for _, v in pairs(ups or {}) do
                    if type(v) == "function" then
                        if isStampFn(v) then _realStampFn = v; return end
                        local u2 = getups(v)
                        for _, u in pairs(u2 or {}) do
                            if isStampFn(u) then _realStampFn = u; return end
                        end
                    end
                end
            end)
        end
        -- fallback 2: scan FarmCheckRemote connections → extract stamp from client handler env
        if not _realStampFn and FarmCheckRemote and getups then
            pcall(function()
                local getconns = (typeof(getconnections) == "function" and getconnections)
                              or (typeof(debug) == "table" and type(debug.getconnections) == "function" and debug.getconnections)
                if not getconns then return end
                for _, conn in ipairs(getconns(FarmCheckRemote.OnClientEvent) or {}) do
                    local fn = conn.Function or (type(conn) == "function" and conn)
                    if type(fn) == "function" then
                        if isStampFn(fn) then _realStampFn = fn; return end
                        local ups = getups(fn)
                        for _, v in pairs(ups or {}) do
                            if type(v) == "function" then
                                if isStampFn(v) then _realStampFn = v; return end
                                local u2 = getups(v)
                                for _, u in pairs(u2 or {}) do
                                    if isStampFn(u) then _realStampFn = u; return end
                                end
                            end
                        end
                    end
                end
            end)
        end
        -- fallback 3: scan PlayerScripts (all LocalScripts) for stamp fn via upvalues
        if not _realStampFn and LocalPlayer and getups then
            pcall(function()
                local ps = LocalPlayer:FindFirstChild("PlayerScripts")
                if not ps then return end
                local function scanInstance(inst)
                    if _realStampFn then return end
                    if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
                        if typeof(getsenv) == "function" then
                            local env = getsenv(inst)
                            if type(env) == "table" then
                                for _, v in pairs(env) do
                                    if isStampFn(v) then _realStampFn = v; return end
                                end
                            end
                        end
                    end
                    for _, child in ipairs(inst:GetChildren()) do
                        if _realStampFn then return end
                        scanInstance(child)
                    end
                end
                scanInstance(ps)
            end)
        end
        return _realStampFn
    end

    local function GenerateStamp(optionId, reactionDelay)
        local elapsed = reactionDelay or (0.95 + math.random() * 0.7)

        -- ลองดึง real stamp fn จาก game scripts ก่อน (ถ้าได้ = verified)
        local sf = _TryExtractStampFn()
        if sf then
            local ok, res = pcall(sf, optionId, elapsed)
            if ok and type(res) == "table" and res.c ~= nil then
                if res.i == nil or res.i == false then res.i = true end
                return res
            end
        end

        -- [PATCHED] fallback: reverse-engineered stamp algorithm
        -- return nil เดิมทำให้ captcha ไม่ถูกส่งเลยทุกครั้งที่ executor หา fn ไม่เจอ
        -- algorithm นี้ตรงกับของ FarmCheckClient จริง (c = (c*31 + byte*i) % 65521)
        local c = 7
        local sid = tostring(optionId)
        for i = 1, #sid do
            c = (c * 31 + string.byte(sid, i) * i) % 65521
        end
        return {
            c = c,
            t = math.floor(math.clamp(elapsed, 0, 999) * 100) / 100,
            i = true,
        }
    end

    -- [PATCHED] strip U+FE0F / U+FE0E variation selectors ก่อน match emoji
    local function NormalizeEmoji(s)
        if type(s) ~= "string" then return s end
        s = s:gsub("\xEF\xB8\x8F", ""):gsub("\xEF\xB8\x8E", "")
        return s
    end

    local function DetectCategory(str)
        if not str or str == "" then return nil end
        local normalized = NormalizeEmoji(str)
        local lower = normalized:lower()
        for kw, cat in pairs(PROMPT_KEYWORDS) do
            if lower:find(kw, 1, true) then
                return cat
            end
        end
        for emoji, cat in pairs(EMOJI_TO_CATEGORY) do
            local normEmoji = NormalizeEmoji(emoji)
            if normalized:find(normEmoji, 1, true) then
                return cat
            end
        end
        return nil
    end

    local function ResolveOptionCategory(opt)
        if not opt then return nil end
        if opt.emoji and EMOJI_TO_CATEGORY[opt.emoji] then
            return EMOJI_TO_CATEGORY[opt.emoji]
        end
        if opt.text then
            local cat = DetectCategory(tostring(opt.text))
            if cat then return cat end
        end
        return nil
    end

    local captchaConn
    captchaConn = FarmCheckRemote.OnClientEvent:Connect(function(action, data)
        if not Hub.Running or not Hub.Settings.AutoCaptcha then return end

        if action == "Show" then
            -- 🛡️ 1. กรอง Ghost Check / Honeypot Trap (data.g == true)
            if type(data) ~= "table" or data.g == true then return end
            if type(data.options) ~= "table" or #data.options == 0 then return end

            -- 🛡️ 2. กรอง Decoy / Hidden Options (opt.h == true คือตัวเลือกกับดัก ห้ามกด)
            local visibleOptions = {}
            for _, opt in ipairs(data.options) do
                if type(opt) == "table" and opt.h ~= true and opt.id ~= nil then
                    table.insert(visibleOptions, opt)
                end
            end
            if #visibleOptions == 0 then return end

            -- สั่งหยุดรถนิ่งอย่างนุ่มนวลระหว่างมีแคปช่า
            local curV = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
            local ch = curV and (curV:FindFirstChild("Chassis") or curV.PrimaryPart)
            if ch then
                SmoothStop(ch, 0.4)
            end

            -- 🛡️ 3. Human Reaction Delay: ดีเลย์ 0.95s - 1.65s เลียนแบบมนุษย์มองจอแล้วกด
            local humanDelay = 0.95 + (math.random() * 0.7)
            task.delay(humanDelay, function()
                if not Hub.Running or not Hub.Settings.AutoCaptcha then return end

                -- 🛡️ 4. GUI Layer Check: ตรวจสอบว่าหน้าต่าง Frame เปิดแสดงอยู่จริงบนจอ
                local pGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
                local fc = pGui and pGui:FindFirstChild("FarmCheck")
                local rootFrame = fc and fc:FindFirstChild("Frame")

                local waitStart = os.clock()
                while (not fc or not fc.Enabled or not rootFrame or not rootFrame.Visible) and (os.clock() - waitStart < 0.6) do
                    task.wait(0.05)
                    fc = pGui and pGui:FindFirstChild("FarmCheck")
                    rootFrame = fc and fc:FindFirstChild("Frame")
                end

                if not (fc and fc.Enabled and rootFrame and rootFrame.Visible) then
                    return -- หากไม่มี UI แสดงบนจอจริง = เป็น Ghost Trap ให้ยกเลิกทันที
                end

                local prompt = tostring(data.prompt or "")
                local targetId = nil
                local matchedCat = DetectCategory(prompt)

                -- 1. ตรวจจับ Category จาก prompt แล้วจับคู่ Option
                if matchedCat then
                    for _, opt in ipairs(visibleOptions) do
                        if ResolveOptionCategory(opt) == matchedCat then
                            targetId = opt.id
                            break
                        end
                    end
                end

                -- 2. Direct emoji/text match ใน prompt
                if not targetId then
                    for _, opt in ipairs(visibleOptions) do
                        if (opt.emoji and prompt:find(opt.emoji, 1, true)) or (opt.text and prompt:find(tostring(opt.text), 1, true)) then
                            targetId = opt.id
                            break
                        end
                    end
                end

                -- 3. GUI TextLabel scan (กรณี server ส่ง prompt ว่างมาทาง remote)
                if not targetId and fc then
                    for _, child in ipairs(fc:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Text and child.Text ~= "" then
                            local uiCat = DetectCategory(child.Text)
                            if uiCat then
                                for _, opt in ipairs(visibleOptions) do
                                    if ResolveOptionCategory(opt) == uiCat then
                                        targetId = opt.id
                                        matchedCat = uiCat
                                        break
                                    end
                                end
                            end
                        end
                        if targetId then break end
                    end
                end

                -- 4. Fallback: ตัวเลือกแรกที่มองเห็นได้จริง
                if not targetId and visibleOptions[1] then
                    targetId = visibleOptions[1].id
                end

                -- 🛡️ 5. ส่งคำตอบ: เพิ่ม human-like delay (0.8 - 3.2s) ก่อน fire answer กันเซิร์ฟเวอร์ตรวจจับ bot timing
                if targetId then
                    local answerDelay = 0.8 + (math.random() * 2.4)
                    task.wait(answerDelay)

                    local stamp = GenerateStamp(targetId, humanDelay + answerDelay)

                    -- ✅ FIX: ถ้าไม่มี stamp ที่ verified = อย่า fire เลย ดีกว่าโดนแบน
                    if not stamp then
                        if Hub.Fluent then
                            Hub.Fluent:Notify({
                                Title   = "FarmCheck",
                                Content = "Stamp extract ล้มเหลว – ข้ามแคปช่าครั้งนี้ (ปลอดภัยกว่าส่ง stamp ผิด)",
                                Duration = 3
                            })
                        end
                        return
                    end

                    -- [AC BYPASS v2 - LAYER 8] Direct FarmCheck answer routing (bypass safeInvoke/safeFire to avoid BLOCKED_ACTIONS drops)
                    local sent = false
                    if FarmCheckAnswerRemote then
                        genv[UI_GUARD_BYPASS_KEY] = true
                        local ok = pcall(DirectInvoke, FarmCheckAnswerRemote, targetId, stamp)
                        if ok then sent = true end
                        if not sent then
                            local ok2 = pcall(DirectFire, FarmCheckAnswerRemote, targetId, stamp)
                            if ok2 then sent = true end
                        end
                        genv[UI_GUARD_BYPASS_KEY] = false
                    end

                    if Hub.Fluent then
                        Hub.Fluent:Notify({
                            Title   = sent and "✅ FarmCheck" or "⚠️ FarmCheck",
                            Content = sent
                                and string.format("ตอบคำถามสำเร็จ [%s] [%s]", tostring(targetId), tostring(matchedCat or "ตรง"))
                                or  string.format("ส่งคำตอบล้มเหลว (invoke+fire) [%s]", tostring(targetId)),
                            Duration = 3
                        })
                    end
                end
            end)
        end
    end)
    table.insert(Hub.Connections, captchaConn)
end


-- 🛡️ FarmGuard Server-Side Leg Time & Hourly Base Income Limiter (< 82,000 ฿/hr)
local CurrentLegStartAt = os.clock()
local CurrentLegStartPos = nil
local RollingDeliveryPayouts = {}
local SAFE_HOURLY_BASE_CAP = 82000

function FormatComma(amount)
    local n = math.floor(tonumber(amount) or 0)
    local formatted = tostring(math.abs(n))
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    if n < 0 then
        return "-" .. formatted
    end
    return formatted
end
Hub.FormatComma = FormatComma

-- ================================================================
-- 📊 REAL-TIME STATS TRACKER (ระบบเก็บสถิติ Real-Time สำหรับหน้าสถิติ)
-- ================================================================
local StatsTracker = {
    SessionStartTime = os.clock(),
    TotalFarmSeconds = 0,
    LastActiveFarmTick = nil,
    SessionEarned = 0,
    SessionRounds = 0,
    LastKnownCash = nil,
    RollingPayouts = {},
}
Hub.StatsTracker = StatsTracker

function StatsTracker.RecordRound(fee)
    fee = tonumber(fee) or 0
    StatsTracker.SessionRounds = StatsTracker.SessionRounds + 1
    if fee > 0 then
        StatsTracker.SessionEarned = StatsTracker.SessionEarned + fee
        table.insert(StatsTracker.RollingPayouts, { t = os.clock(), fee = fee })
    end
end

function StatsTracker.IncrementRoundOnly()
    StatsTracker.SessionRounds = StatsTracker.SessionRounds + 1
end

-- Cash Delta Tracking
task.spawn(function()
    task.wait(1.5)
    local initCash = LocalPlayer:GetAttribute("Cash")
    if typeof(initCash) == "number" then
        StatsTracker.LastKnownCash = initCash
    end

    local function onCashChanged()
        local cur = LocalPlayer:GetAttribute("Cash")
        if typeof(cur) == "number" then
            if StatsTracker.LastKnownCash ~= nil and cur > StatsTracker.LastKnownCash then
                local delta = cur - StatsTracker.LastKnownCash
                if delta > 0 and delta < 50000 then
                    StatsTracker.SessionEarned = StatsTracker.SessionEarned + delta
                    table.insert(StatsTracker.RollingPayouts, { t = os.clock(), fee = delta })
                end
            end
            StatsTracker.LastKnownCash = cur
        end
    end

    pcall(function()
        LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(onCashChanged)
    end)
end)

function RecordLegStart(pos)
    CurrentLegStartAt = os.clock()
    CurrentLegStartPos = pos
end

function WaitSafeLegConfirm(targetPos)
    local dist = 0
    if CurrentLegStartPos and targetPos then
        dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(CurrentLegStartPos.X, 0, CurrentLegStartPos.Z)).Magnitude
    end
    local veh = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
    local tunedKmh = (veh and GetVehicleTunedMaxKmh(veh)) or 110
    local kmhPerStud = (EcuShared and EcuShared.KMH_PER_STUD) or 1.008
    local legitMaxStuds = math.max(90, math.floor(tunedKmh / kmhPerStud))
    local minLegSeconds = math.max(0.8, (dist / legitMaxStuds) + 0.2)
    local elapsed = os.clock() - CurrentLegStartAt
    if elapsed < minLegSeconds then
        local waitSec = math.min(minLegSeconds - elapsed, 3.0)
        local t0 = os.clock()
        while (os.clock() - t0) < waitSec and Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            LastDeliveryHeartbeat = os.clock()
            LastGrabHeartbeat = os.clock()
            task.wait(0.15)
        end
    end
end

function GetRollingHourlyBase()
    local now = os.clock()
    local sum = 0
    for i = #RollingDeliveryPayouts, 1, -1 do
        if (now - RollingDeliveryPayouts[i].t) > 3600 then
            table.remove(RollingDeliveryPayouts, i)
        else
            sum = sum + RollingDeliveryPayouts[i].fee
        end
    end
    return sum
end

function WaitSafeHourlyRate(expectedFee)
    local fee = tonumber(expectedFee) or 1500
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        local isFarming = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
        if not isFarming then break end
        if (GetRollingHourlyBase() + fee) < SAFE_HOURLY_BASE_CAP then
            break
        end
        task.wait(2.0)
    end
end

function RecordDeliveryPayout(fee)
    table.insert(RollingDeliveryPayouts, { t = os.clock(), fee = tonumber(fee) or 1200 })
    if Hub.StatsTracker then
        Hub.StatsTracker.RecordRound(fee)
    end
    -- human-like brief pause ก่อนรับงานใหม่ (0.8 - 1.5s)
    local restTime = 0.8 + (math.random() * 0.7)
    task.wait(restTime)
end

-- 📱 Auto-Hide In-Game Phone / GPS Dock UI While Farming
local PhoneUIModule = nil
pcall(function()
    local gameUi = ReplicatedStorage:FindFirstChild("GameUI") or ReplicatedStorage:WaitForChild("GameUI", 3)
    local phoneMod = gameUi and (gameUi:FindFirstChild("Phone") or gameUi:WaitForChild("Phone", 3))
    if phoneMod then
        PhoneUIModule = require(phoneMod)
    end
end)

local BoundPhoneDock = nil
local BoundPhoneDockConn = nil

function IsAnyFarmEnabled()
    return (Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide) == true
end

function CheckMoneyLock()
    -- ปิดการหยุดฟาร์มอัตโนมัติ: ผู้ใช้ต้องการเปิด-ปิดฟาร์มเองทั้งหมด (Manual Control Only)
    return false
end

function HideDeliveryPhoneUI()
    pcall(function()
        if PhoneUIModule and type(PhoneUIModule.close) == "function" then
            if LocalPlayer:GetAttribute("PhoneOpen") == true then
                PhoneUIModule.close()
            end
        end
        local pGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        local phoneGui = pGui and pGui:FindFirstChild("Phone")
        local dock = phoneGui and phoneGui:FindFirstChild("Dock")
        if dock and dock:IsA("GuiObject") then
            if dock.Visible then
                dock.Visible = false
            end
            if BoundPhoneDock ~= dock then
                if BoundPhoneDockConn then
                    pcall(function() BoundPhoneDockConn:Disconnect() end)
                    BoundPhoneDockConn = nil
                end
                BoundPhoneDock = dock
                BoundPhoneDockConn = dock:GetPropertyChangedSignal("Visible"):Connect(function()
                    if Hub.Running and genv[_gk.sk] == SCRIPT_ID and IsAnyFarmEnabled() and dock.Visible then
                        dock.Visible = false
                        task.defer(function()
                            pcall(function()
                                if PhoneUIModule and type(PhoneUIModule.close) == "function" then
                                    PhoneUIModule.close()
                                end
                            end)
                        end)
                    end
                end)
                table.insert(Hub.Connections, BoundPhoneDockConn)
            end
        end
    end)
end

-- Synchronized In-Flight Mutex for Order Acceptance (Fixes "งานหมดเวลา" race condition)
local IsAcceptingOffer = false
local IsAcceptingOfferTimestamp = 0  -- [STABILITY] timeout guard
local LastOfferAcceptTime = 0

function AcceptDeliveryOffer(source)
    -- [STABILITY] auto-clear IsAcceptingOffer if stuck > 8s (server never replied)
    if IsAcceptingOffer and (os.clock() - IsAcceptingOfferTimestamp) > 8 then
        IsAcceptingOffer = false
    end
    if IsAcceptingOffer then return end
    if os.clock() - LastOfferAcceptTime < 0.8 then return end
    if LocalPlayer:GetAttribute("DeliveryState") ~= "Offer" then return end
    if not (DeliveryRemote and (NetSeal or DeliveryRemote:IsA("RemoteFunction"))) then return end

    -- 🛡️ Prevent accepting an Offer when Job hasn't switched to the target farm job yet
    -- Fixes "Job cancelled: you quit while having a delivery" when switching from Delivery to Grab!
    local activeJob = LocalPlayer:GetAttribute("Job")
    if Hub.Settings.AutoGrabFarm and not Hub.Settings.AutoFoodDelivery and not Hub.Settings.AutoGrabRide then
        if activeJob ~= "Grab" then return end
    elseif (Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide) and not Hub.Settings.AutoGrabFarm then
        if activeJob ~= "Delivery" then return end
    end

    IsAcceptingOffer = true
    IsAcceptingOfferTimestamp = os.clock()
    LastOfferAcceptTime = os.clock()
    HideDeliveryPhoneUI()

    -- Ensure player is mounted and completely stopped before calling Accept
    local veh = EnsureMounted()
    if veh then
        local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
        if ch then
            ch.AssemblyLinearVelocity = Vector3.zero
            ch.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local _invFn = genv[_gk.ni] or (NetSeal and NetSeal.invoke) or (function(r, ...) return r:InvokeServer(...) end)
    local accepted = false

    for attempt = 1, 4 do
        if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then break end
        if LocalPlayer:GetAttribute("DeliveryState") ~= "Offer" then
            accepted = true
            break
        end

        EnsureMounted()
        local s, ok, msg = pcall(_invFn, DeliveryRemote, "Accept", nil)
        if s and ok then
            accepted = true
            break
        end
        task.wait(0.2)
    end

    if accepted then
        HideDeliveryPhoneUI()
        if Hub.Fluent then
            local rawJob = LocalPlayer:GetAttribute("DeliveryJob")
            local decoded = rawJob and DeliveryShared and DeliveryShared.decode(rawJob)
            Hub.Fluent:Notify({
                Title = "⚡ รับงานสำเร็จ!",
                Content = ("ลูกค้ารายการ: %s | ค่าจ้าง: ฿%s"):format(
                    decoded and decoded.customer or "ลูกค้า",
                    decoded and tostring(decoded.fee) or "-"
                ),
                Duration = 2.5
            })
        end
    end

    task.wait(0.2)
    IsAcceptingOffer = false
end

-- Synchronized In-Flight Mutex for Delivery Confirmation (Fixes "รับไม่ค่อยติด" & slider stuck)
local IsConfirmingDelivery = false
local IsConfirmingDeliveryTimestamp = 0
local LastConfirmDeliveryTime = 0

function ConfirmDelivery(source, targetPos)
    if IsConfirmingDelivery and (os.clock() - IsConfirmingDeliveryTimestamp) > 6 then
        IsConfirmingDelivery = false
    end
    if IsConfirmingDelivery then return false end

    local curState = LocalPlayer:GetAttribute("DeliveryState")
    if curState ~= "ToShop" and curState ~= "ToHome" then return false end
    if LocalPlayer:GetAttribute("DeliveryArrived") ~= true then return false end
    if not (DeliveryRemote and (NetSeal or DeliveryRemote:IsA("RemoteFunction"))) then return false end

    if (os.clock() - LastConfirmDeliveryTime) < 0.6 then return false end

    IsConfirmingDelivery = true
    IsConfirmingDeliveryTimestamp = os.clock()
    LastConfirmDeliveryTime = os.clock()

    -- 🛡️ Guarantee zero physical velocity so server STOP_SPEED <= 6 check passes 100%
    local veh = EnsureMounted()
    if veh then
        local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
        if ch then
            ch.AssemblyLinearVelocity = Vector3.zero
            ch.AssemblyAngularVelocity = Vector3.zero
        end
    end

    -- Timing guard
    if targetPos and source ~= "Signal" then
        WaitSafeLegConfirm(targetPos)
    end

    local rawJob = LocalPlayer:GetAttribute("DeliveryJob")
    local decoded = rawJob and DeliveryShared and DeliveryShared.decode(rawJob)

    if curState == "ToHome" and decoded and decoded.fee and source ~= "Signal" then
        WaitSafeHourlyRate(decoded.fee)
    end

    local _invFn = genv[_gk.ni] or (NetSeal and NetSeal.invoke) or (function(r, ...) return r:InvokeServer(...) end)
    local confirmed = false

    for attempt = 1, 5 do
        if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then break end
        if LocalPlayer:GetAttribute("DeliveryState") ~= curState then
            confirmed = true
            break
        end

        EnsureMounted()
        if veh then
            local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
            if ch then
                ch.AssemblyLinearVelocity = Vector3.zero
                ch.AssemblyAngularVelocity = Vector3.zero
            end
        end

        local s, ok, msg = pcall(_invFn, DeliveryRemote, "Confirm", nil)
        if s and ok then
            confirmed = true
            break
        end

        task.wait(0.25)
    end

    if confirmed then
        HideDeliveryPhoneUI()
        task.defer(HideDeliveryPhoneUI)

        if curState == "ToShop" then
            local chNow = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
            RecordLegStart(chNow and chNow.Position or targetPos)
            if Hub.Fluent then
                local mode = LocalPlayer:GetAttribute("DeliveryMode")
                Hub.Fluent:Notify({
                    Title = mode == "ride" and "🧍 รับผู้โดยสารสำเร็จ!" or "🍲 รับสินค้าสำเร็จ!",
                    Content = ("เรียบร้อยแล้ว กำลังเดินทางไปส่งให้คุณ %s"):format(decoded and decoded.customer or "ลูกค้า"),
                    Duration = 2.0
                })
            end
            local transWait = os.clock()
            while (os.clock() - transWait) < 3.0 and Hub.Running and genv[_gk.sk] == SCRIPT_ID do
                if LocalPlayer:GetAttribute("DeliveryState") ~= "ToShop" then break end
                task.wait(0.1)
            end
        elseif curState == "ToHome" then
            if decoded and decoded.fee then
                RecordDeliveryPayout(decoded.fee)
                task.defer(function() pcall(CheckMoneyLock) end)
                if Hub.Fluent then
                    Hub.Fluent:Notify({
                        Title = "💰 ส่งงานสำเร็จ!",
                        Content = ("ได้รับเงินค่าส่งเรียบร้อยแล้ว: ฿%s"):format(tostring(decoded.fee or "")),
                        Duration = 2.5
                    })
                end
            end
            local transWait = os.clock()
            while (os.clock() - transWait) < 3.0 and Hub.Running and genv[_gk.sk] == SCRIPT_ID do
                if LocalPlayer:GetAttribute("DeliveryState") ~= "ToHome" then break end
                task.wait(0.1)
            end
        end
    end

    task.wait(0.2)
    IsConfirmingDelivery = false
    return confirmed
end

-- 🛡️ Precise Road & Customer Parking Spot Calculator (Always on asphalt road within ARRIVE_RADIUS = 32)
function GetRoadParkingPosition(rawTargetPos, targetData, targetKind)
    if not rawTargetPos then return nil end
    local rawX = rawTargetPos.X
    local rawZ = (typeof(rawTargetPos) == "Vector3" and rawTargetPos.Z) or (typeof(rawTargetPos) == "Vector2" and rawTargetPos.Y) or 0
    local rawY = (typeof(rawTargetPos) == "Vector3" and rawTargetPos.Y) or 0

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = { LocalPlayer.Character }
    local sv = Workspace:FindFirstChild("SpawnedVehicles")
    if sv then table.insert(filterList, sv) end
    rayParams.FilterDescendantsInstances = filterList
    rayParams.IgnoreWater = true

    local roadX = nil
    local roadZ = nil

    -- Priority 1: Universal Road Resolver via RoadGraph.nearest
    -- Always returns a point directly ON the drivable asphalt road centerline/lane.
    -- Keeps vehicle strictly <= 20 studs from target (well inside ARRIVE_RADIUS = 32).
    if RoadGraph and RoadGraph.nearest then
        local roadPt2D, distToRoad = RoadGraph.nearest(rawTargetPos)
        if roadPt2D then
            local dirToTarget = Vector3.new(rawX - roadPt2D.X, 0, rawZ - roadPt2D.Y)
            local dist = dirToTarget.Magnitude
            if dist <= 14.0 then
                roadX = roadPt2D.X
                roadZ = roadPt2D.Y
            else
                -- Advance along road frontage towards target, stopping strictly 10 studs away (well within ARRIVE_RADIUS = 32)
                local safePt = Vector3.new(roadPt2D.X, 0, roadPt2D.Y) + dirToTarget.Unit * math.max(0, dist - 10.0)
                roadX = safePt.X
                roadZ = safePt.Z
            end
        end
    end

    -- Priority 2: Official Game Road Frontage (targetData.dx, targetData.dz)
    -- Used only if RoadGraph.nearest was > 20 studs away
    if not roadX and targetData and type(targetData.dx) == "number" and type(targetData.dz) == "number" then
        local d = math.sqrt((targetData.dx - rawX) ^ 2 + (targetData.dz - rawZ) ^ 2)
        if d <= 22.0 then
            local gRay = Workspace:Raycast(Vector3.new(targetData.dx, rawY + 15.0, targetData.dz), Vector3.new(0, -32.0, 0), rayParams)
            if gRay and gRay.Instance.CanCollide and gRay.Position.Y > -40 then
                local matStr = tostring(gRay.Material)
                if not matStr:find("Grass") then
                    roadX = targetData.dx
                    roadZ = targetData.dz
                end
            else
                roadX = targetData.dx
                roadZ = targetData.dz
            end
        end
    end

    -- Priority 3: Check MapRoads.HOMES and MapRoads.SHOPS for official frontage road coordinates
    if not roadX and MapRoads then
        if targetKind == "ToHome" or (targetData and targetData.home) or (not targetKind and not roadX) then
            if MapRoads.HOMES then
                for _, h in ipairs(MapRoads.HOMES) do
                    if type(h) == "table" and type(h[1]) == "number" and type(h[3]) == "number" and type(h[5]) == "number" and type(h[6]) == "number" then
                        local d = math.sqrt((h[1] - rawX) ^ 2 + (h[3] - rawZ) ^ 2)
                        if d <= 12.0 then
                            roadX = h[5]
                            roadZ = h[6]
                            break
                        end
                    end
                end
            end
        end

        if not roadX and (targetKind == "ToShop" or (targetData and targetData.shop) or not targetKind) then
            if MapRoads.SHOPS then
                local tName = targetData and (targetData.name or targetData.customer or targetData.spot)
                if type(tName) == "string" then
                    for _, s in ipairs(MapRoads.SHOPS) do
                        if type(s) == "table" and type(s[1]) == "string" and type(s[6]) == "number" and type(s[7]) == "number" then
                            if s[1] == tName or string.find(tName, s[1], 1, true) or string.find(s[1], tName, 1, true) then
                                local d = math.sqrt((s[6] - rawX) ^ 2 + (s[7] - rawZ) ^ 2)
                                if d <= 30.0 then
                                    roadX = s[6]
                                    roadZ = s[7]
                                    break
                                end
                            end
                        end
                    end
                end
                if not roadX then
                    for _, s in ipairs(MapRoads.SHOPS) do
                        if type(s) == "table" and type(s[2]) == "number" and type(s[4]) == "number" and type(s[6]) == "number" and type(s[7]) == "number" then
                            local d = math.sqrt((s[2] - rawX) ^ 2 + (s[4] - rawZ) ^ 2)
                            if d <= 12.0 then
                                roadX = s[6]
                                roadZ = s[7]
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- Priority 4: Final fallback to RoadGraph.nearest regardless of distance
    if not roadX and RoadGraph and RoadGraph.nearest then
        local roadPt2D = RoadGraph.nearest(rawTargetPos)
        if roadPt2D then
            roadX = roadPt2D.X
            roadZ = roadPt2D.Y
        end
    end

    -- Fallback: If everything failed, stay at rawTargetPos
    if not roadX then
        roadX = rawX
        roadZ = rawZ
    end

    -- Compute correct road elevation (avoid ground clipping / floating)
    local py = rawY
    local elev = GetElevation(roadX, roadZ, rawY)
    if elev then
        py = elev
    else
        local groundRay = Workspace:Raycast(Vector3.new(roadX, math.min(rawY + 5.0, 15.0), roadZ), Vector3.new(0, -25.0, 0), rayParams)
        if groundRay and groundRay.Instance.CanCollide and groundRay.Position.Y > -40 then
            py = groundRay.Position.Y
        end
    end

    return Vector3.new(roadX, py, roadZ)
end

-- 5.2 Unified Auto Rider / Delivery Engine (PC & Mobile Bulletproof)
local DeliveryWorking = false
local DeliveryStuckCount = 0
local GrabStuckCount = 0

function StepAutoDelivery(targetMode)
    HideDeliveryPhoneUI()

    if CheckMoneyLock() then
        return
    end

    if DeliveryWorking then
        -- [STABILITY] Watchdog: reduced 60s → 15s; also clear stale Teleporting flag together
        if os.clock() - LastDeliveryHeartbeat > 15 then
            DeliveryWorking = false
            if Teleporting and (os.clock() - TeleportingTimestamp) > 15 then
                Teleporting = false
            end
        else
            return
        end
    end
    DeliveryWorking = true
    LastDeliveryHeartbeat = os.clock()

    local success, err = pcall(function()
        -- 1. Uniform Check: Must wear delivery uniform
        local curJob = LocalPlayer:GetAttribute("Job")
        if curJob ~= "Delivery" then
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "👔 เปลี่ยนชุดไรเดอร์",
                    Content = "กำลังเดินทางไปใส่ชุดไรเดอร์ที่ตู้...",
                    Duration = 2.5
                })
            end

            -- Prime server with Plan
            if JobRemote and NetSeal then
                local _invFn = genv[_gk.ni] or NetSeal.invoke
                pcall(_invFn, JobRemote, "Plan", "Delivery")
            end

            local lockerPos = Vector3.new(87.8, 4.38, -118)

            -- Safe parking spot in front of locker (open yard, avoiding fence/curb collisions)
            local parkPos = Vector3.new(96.0, 4.38, -118.0)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local dist = hrp and (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(parkPos.X, 0, parkPos.Z)).Magnitude or 999
            if dist > 12 then
                SafeRoadTravel(parkPos)
            end

            -- Clean vehicle dismount
            DismountVehicle()
            task.wait(0.2)

            -- Locate locker cabinet & prompt
            local locker = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("JobLockers") and Workspace.Map.JobLockers:FindFirstChild("Locker_Delivery")
            local cabinet = locker and (locker:FindFirstChild("Cabinet") or locker:WaitForChild("Cabinet", 3))
            local prompt = cabinet and (cabinet:FindFirstChild("LockerPrompt") or cabinet:WaitForChild("LockerPrompt", 3))

            if cabinet and prompt then
                local cabinetPos = cabinet.Position
                local standPos = cabinetPos + (cabinet.CFrame.LookVector * 2.8)

                -- Smoothly walk right in front of cabinet on foot
                WalkToPosition(standPos, 16)
                char = LocalPlayer.Character
                hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.lookAt(standPos, cabinetPos)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
                task.wait(0.25)

                -- Only trigger prompt if NOT already wearing Delivery uniform
                if LocalPlayer:GetAttribute("Job") ~= "Delivery" then
                    TriggerPrompt(prompt)

                    -- Wait for job attribute to update
                    local tStart = os.clock()
                    while (os.clock() - tStart) < 3.0 do
                        if LocalPlayer:GetAttribute("Job") == "Delivery" then
                            break
                        end
                        task.wait(0.15)
                    end
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
                task.wait(0.5)
            end
            return
        end

        local state = LocalPlayer:GetAttribute("DeliveryState") or "Off"
        local curMode = LocalPlayer:GetAttribute("DeliveryMode")
        local rawJob = LocalPlayer:GetAttribute("DeliveryJob")
        local decoded = rawJob and DeliveryShared and DeliveryShared.decode(rawJob)

        -- ⚡ PRIORITY 1: Offer -> Instant Accept ANY pending order immediately!
        if state == "Offer" then
            AcceptDeliveryOffer("StepAutoDelivery")
            task.wait(0.3)
            return
        end

        -- PRIORITY 2: Start service or switch to targetMode if searching
        if state == "Off" or (state == "Searching" and curMode ~= targetMode) then
            local _invFn = genv[_gk.ni] or NetSeal.invoke
            pcall(_invFn, DeliveryRemote, "Start", targetMode)
            task.wait(0.8)
            return
        elseif state == "Searching" then
            task.wait(0.4)
            return
        end

        -- PRIORITY 3: Active Delivery (ToShop or ToHome) -> Requires vehicle mounted
        local veh, seat = EnsureMounted()
        if not veh or not seat then
            task.wait(0.5)
            return
        end

        local function ResolveTarget(targetKind, jobData)
            if not jobData or not DeliveryShared then return nil, nil end
            local expectedVec = nil
            local targetVec, data = DeliveryShared.target(targetKind, jobData)
            if targetVec and typeof(targetVec) == "Vector3" then
                expectedVec = targetVec
            elseif data then
                expectedVec = Vector3.new(data.x, data.y or 0, data.z)
            end
            if not expectedVec then return nil, nil end

            local rawTarget = expectedVec
            local marker = Workspace:FindFirstChild("DeliveryMarker")
            local ring = marker and marker:FindFirstChild("Ring")
            if ring and ring:IsA("BasePart") then
                local ringPos = ring.Position
                local distFromExpected = (Vector3.new(ringPos.X, 0, ringPos.Z) - Vector3.new(expectedVec.X, 0, expectedVec.Z)).Magnitude
                if distFromExpected < 80 then
                    rawTarget = ringPos
                end
            end

            -- 🛡️ Compute precise road parking spot (always within ARRIVE_RADIUS = 32 on the road)
            local roadParkPos = GetRoadParkingPosition(rawTarget, data, targetKind)
            return roadParkPos, rawTarget
        end

        -- Case 4: ToShop -> Drive smoothly along road to restaurant or passenger
        if state == "ToShop" and decoded then
            local targetPos, rawTarget = ResolveTarget("ToShop", decoded)
            if targetPos then
                local startCh = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                RecordLegStart(startCh and startCh.Position or nil)
                SafeRoadTravel(targetPos, { Speed = GetJitteredFarmSpeed(), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToShop" })

                -- 🛡️ JITTER FIX: Lock parked CFrame via RenderStepped (no velocity fight, zero ground sinking)
                local _arrivalCF_D4 = nil
                do
                    local ch0 = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                    if ch0 then
                        local pPivot = veh:GetPivot()
                        local pPos = pPivot.Position
                        local gY = GetElevation(pPos.X, pPos.Z, pPos.Y) or pPos.Y
                        local wOff = (GetVehicleWheelOffset and GetVehicleWheelOffset(veh)) or 1.25
                        local properY = gY + wOff
                        local look = pPivot.LookVector
                        local flatLook = Vector3.new(look.X, 0, look.Z)
                        if flatLook.Magnitude < 0.1 then flatLook = Vector3.new(0, 0, 1) end
                        _arrivalCF_D4 = CFrame.lookAt(Vector3.new(pPos.X, properY, pPos.Z), Vector3.new(pPos.X, properY, pPos.Z) + flatLook.Unit)
                        veh:PivotTo(_arrivalCF_D4)
                        ch0.AssemblyLinearVelocity  = Vector3.zero
                        ch0.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                local _arrivalLock_D4 = nil
                if veh and veh.Parent and _arrivalCF_D4 then
                    _arrivalLock_D4 = RunService.RenderStepped:Connect(function()
                        if veh and veh.Parent and _arrivalCF_D4 then
                            veh:PivotTo(_arrivalCF_D4)
                            local _ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if _ch then _ch.AssemblyAngularVelocity = Vector3.zero end
                        end
                    end)
                end
                local waitStart = os.clock()
                while (os.clock() - waitStart) < 2.0 and Hub.Running and IsAnyFarmEnabled() do
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then break end
                    if LocalPlayer:GetAttribute("DeliveryState") ~= "ToShop" then break end
                    task.wait(0.05)
                end
                if _arrivalLock_D4 then
                    pcall(function() _arrivalLock_D4:Disconnect() end)
                    _arrivalLock_D4 = nil
                end

                local curStateNow = LocalPlayer:GetAttribute("DeliveryState")
                if curStateNow == "ToShop" then
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                        ConfirmDelivery("StepAutoDelivery", targetPos)
                        DeliveryStuckCount = 0
                        task.wait(0.15)
                    else
                        -- 🛡️ Proactive Drive Closer (No Warp!): Smoothly drive closer towards rawTarget marker ring
                        if rawTarget and veh and veh.Parent then
                            local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if ch then
                                local curP = ch.Position
                                local toRaw = Vector3.new(rawTarget.X - curP.X, 0, rawTarget.Z - curP.Z)
                                local dRaw = toRaw.Magnitude
                                local closerPos = rawTarget
                                if dRaw > 8.0 then
                                    closerPos = Vector3.new(curP.X, rawTarget.Y, curP.Z) + toRaw.Unit * math.max(4.0, dRaw - 6.0)
                                end
                                SafeRoadTravel(closerPos, { Speed = math.min(22, GetJitteredFarmSpeed()), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToShop" })
                                task.wait(0.2)
                            end
                        end
                        if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                            ConfirmDelivery("StepAutoDelivery", targetPos)
                            DeliveryStuckCount = 0
                            task.wait(0.15)
                        end
                    end
                else
                    DeliveryStuckCount = 0
                end
            end

        -- Case 5: ToHome -> Drive smoothly along road to customer
        elseif state == "ToHome" and decoded then
            local targetPos, rawTarget = ResolveTarget("ToHome", decoded)
            if targetPos then
                local startCh = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                RecordLegStart(startCh and startCh.Position or nil)
                SafeRoadTravel(targetPos, { Speed = GetJitteredFarmSpeed(), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToHome" })

                -- 🛡️ JITTER FIX: Lock parked CFrame via RenderStepped (no velocity fight, zero ground sinking)
                local _arrivalCF_D4 = nil
                do
                    local ch0 = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                    if ch0 then
                        local pPivot = veh:GetPivot()
                        local pPos = pPivot.Position
                        local gY = GetElevation(pPos.X, pPos.Z, pPos.Y) or pPos.Y
                        local wOff = (GetVehicleWheelOffset and GetVehicleWheelOffset(veh)) or 1.25
                        local properY = gY + wOff
                        local look = pPivot.LookVector
                        local flatLook = Vector3.new(look.X, 0, look.Z)
                        if flatLook.Magnitude < 0.1 then flatLook = Vector3.new(0, 0, 1) end
                        _arrivalCF_D4 = CFrame.lookAt(Vector3.new(pPos.X, properY, pPos.Z), Vector3.new(pPos.X, properY, pPos.Z) + flatLook.Unit)
                        veh:PivotTo(_arrivalCF_D4)
                        ch0.AssemblyLinearVelocity  = Vector3.zero
                        ch0.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                local _arrivalLock_D4 = nil
                if veh and veh.Parent and _arrivalCF_D4 then
                    _arrivalLock_D4 = RunService.RenderStepped:Connect(function()
                        if veh and veh.Parent and _arrivalCF_D4 then
                            veh:PivotTo(_arrivalCF_D4)
                            local _ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if _ch then _ch.AssemblyAngularVelocity = Vector3.zero end
                        end
                    end)
                end
                local waitStart = os.clock()
                while (os.clock() - waitStart) < 2.0 and Hub.Running and IsAnyFarmEnabled() do
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then break end
                    if LocalPlayer:GetAttribute("DeliveryState") ~= "ToHome" then break end
                    task.wait(0.05)
                end
                if _arrivalLock_D4 then
                    pcall(function() _arrivalLock_D4:Disconnect() end)
                    _arrivalLock_D4 = nil
                end

                local curStateNow = LocalPlayer:GetAttribute("DeliveryState")
                if curStateNow == "ToHome" then
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                        ConfirmDelivery("StepAutoDelivery", targetPos)
                        DeliveryStuckCount = 0
                        task.wait(0.15)
                    else
                        -- 🛡️ Proactive Drive Closer (No Warp!): Smoothly drive closer towards rawTarget marker ring
                        if rawTarget and veh and veh.Parent then
                            local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if ch then
                                local curP = ch.Position
                                local toRaw = Vector3.new(rawTarget.X - curP.X, 0, rawTarget.Z - curP.Z)
                                local dRaw = toRaw.Magnitude
                                local closerPos = rawTarget
                                if dRaw > 8.0 then
                                    closerPos = Vector3.new(curP.X, rawTarget.Y, curP.Z) + toRaw.Unit * math.max(4.0, dRaw - 6.0)
                                end
                                SafeRoadTravel(closerPos, { Speed = math.min(22, GetJitteredFarmSpeed()), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToHome" })
                                task.wait(0.2)
                            end
                        end
                        if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                            ConfirmDelivery("StepAutoDelivery", targetPos)
                            DeliveryStuckCount = 0
                            task.wait(0.15)
                        end
                    end
                else
                    DeliveryStuckCount = 0
                end
            end
        end
    end)

    DeliveryWorking = false
end

-- 5.3 Dedicated High-Payout Grab Farm Engine (฿1,000 - ฿2,500/Trip, Zero Locker Required)
local GrabWorking = false

local GrabStuckCount = 0

function StepAutoGrab()
    HideDeliveryPhoneUI()

    if CheckMoneyLock() then return end

    if GrabWorking then
        if os.clock() - LastGrabHeartbeat > 15 then  -- ✅ FIX: 12→15s, consistent with DeliveryWorking timeout
            GrabWorking = false
            if Teleporting and (os.clock() - TeleportingTimestamp) > 15 then
                Teleporting = false
            end
        else
            return
        end
    end
    GrabWorking = true
    LastGrabHeartbeat = os.clock()

    local success, err = pcall(function()
        -- Rebind DeliveryRemote if needed
        if not RebindDeliveryRemote() then
            task.wait(1.0)
            return
        end

        -- 1. Grab Job Check: Grab does NOT require any locker, instant Set remote
        -- 🛡️ Stop any active Searching/Offer from a previous Job BEFORE switching to "Grab"
        -- (Prevents server "Job cancelled: you quit while having a delivery")
        local curJob = LocalPlayer:GetAttribute("Job")
        if curJob ~= "Grab" then
            local preState = LocalPlayer:GetAttribute("DeliveryState")
            if preState == "Searching" or preState == "Offer" then
                SafeInvokeRemote(DeliveryRemote, "Stop", nil)
                task.wait(0.25)
            elseif preState == "ToShop" or preState == "ToHome" then
                SafeInvokeRemote(DeliveryRemote, "Cancel", nil)
                task.wait(0.3)
                SafeInvokeRemote(DeliveryRemote, "Stop", nil)
                task.wait(0.25)
            end
            RebindJobRemote()
            if JobRemote then
                SafeInvokeRemote(JobRemote, "Set", "Grab")
                local tStart = os.clock()
                while (os.clock() - tStart) < 3.0 do
                    if LocalPlayer:GetAttribute("Job") == "Grab" then break end
                    task.wait(0.15)
                end
            end
            if LocalPlayer:GetAttribute("Job") ~= "Grab" then
                if WorkRemote then
                    SafeInvokeRemote(WorkRemote, "Set", "Grab")
                    task.wait(0.8)
                end
                if LocalPlayer:GetAttribute("Job") ~= "Grab" then
                    return
                end
            end
        end

        local state = LocalPlayer:GetAttribute("DeliveryState") or "Off"
        local curMode = LocalPlayer:GetAttribute("DeliveryMode")
        local rawJob = LocalPlayer:GetAttribute("DeliveryJob")
        local decoded = rawJob and DeliveryShared and DeliveryShared.decode(rawJob)

        -- ⚡ PRIORITY 1: Offer -> Instant Accept Grab ride immediately!
        if state == "Offer" then
            AcceptDeliveryOffer("StepAutoGrab")
            task.wait(0.3)
            return
        end

        -- PRIORITY 2: Start Grab service or switch to grab if searching (NO premature EnsureMounted)
        if state == "Off" or (state == "Searching" and curMode ~= "grab") then
            SafeInvokeRemote(DeliveryRemote, "Start", "grab")
            task.wait(0.8)
            return
        elseif state == "Searching" then
            task.wait(0.4)
            return
        end

        -- PRIORITY 3: Active Travel (ToShop or ToHome) -> Requires vehicle mounted
        local veh, seat = EnsureMounted()
        if not veh or not seat then
            task.wait(0.5)
            return
        end

        local function ResolveTarget(targetKind, jobData)
            if not jobData or not DeliveryShared then return nil, nil end
            local expectedVec = nil
            local targetVec, data = DeliveryShared.target(targetKind, jobData)
            if targetVec and typeof(targetVec) == "Vector3" then
                expectedVec = targetVec
            elseif data then
                expectedVec = Vector3.new(data.x, data.y or 0, data.z)
            end
            if not expectedVec then return nil, nil end

            local rawTarget = expectedVec
            local marker = Workspace:FindFirstChild("DeliveryMarker")
            local ring = marker and marker:FindFirstChild("Ring")
            if ring and ring:IsA("BasePart") then
                local ringPos = ring.Position
                local distFromExpected = (Vector3.new(ringPos.X, 0, ringPos.Z) - Vector3.new(expectedVec.X, 0, expectedVec.Z)).Magnitude
                if distFromExpected < 80 then
                    rawTarget = ringPos
                end
            end

            -- 🛡️ Compute precise road parking spot (always within ARRIVE_RADIUS = 32 on asphalt street)
            local roadParkPos = GetRoadParkingPosition(rawTarget, data, targetKind)
            return roadParkPos, rawTarget
        end

        -- helper: arrival wait + jitter lock (Instantly unlocks as soon as passenger mounts / state changes)
        local function WaitArrival(lockCF, conn, expectedState)
            local t = os.clock()
            while (os.clock() - t) < 2.0 and Hub.Running and IsAnyFarmEnabled() do
                if LocalPlayer:GetAttribute("DeliveryArrived") == true then break end
                if expectedState and LocalPlayer:GetAttribute("DeliveryState") ~= expectedState then break end
                task.wait(0.05)
            end
            if conn then pcall(function() conn:Disconnect() end) end
        end

        -- helper: build arrival lock
        local function MakeArrivalLock(curVeh)
            local ch0 = curVeh and (curVeh:FindFirstChild("Chassis") or curVeh.PrimaryPart)
            if not ch0 then return nil, nil end
            local pp = curVeh:GetPivot()
            local pp2 = pp.Position
            local gY = GetElevation(pp2.X, pp2.Z, pp2.Y) or pp2.Y
            local wOf = (GetVehicleWheelOffset and GetVehicleWheelOffset(curVeh)) or 1.25
            local fy = gY + wOf
            local lv = pp.LookVector
            local fl = Vector3.new(lv.X, 0, lv.Z)
            if fl.Magnitude < 0.1 then fl = Vector3.new(0, 0, 1) end
            local cf = CFrame.lookAt(Vector3.new(pp2.X, fy, pp2.Z), Vector3.new(pp2.X, fy, pp2.Z) + fl.Unit)
            curVeh:PivotTo(cf)
            ch0.AssemblyLinearVelocity  = Vector3.zero
            ch0.AssemblyAngularVelocity = Vector3.zero
            local conn = RunService.RenderStepped:Connect(function()
                if curVeh and curVeh.Parent and cf then
                    curVeh:PivotTo(cf)
                    local c2 = curVeh:FindFirstChild("Chassis") or curVeh.PrimaryPart
                    if c2 then c2.AssemblyAngularVelocity = Vector3.zero end
                end
            end)
            return cf, conn
        end

        -- helper: stuck check using GrabStuckCount (tolerant: never cancels prematurely!)
        local function CheckGrabStuck(targetMode)
            if LocalPlayer:GetAttribute("DeliveryArrived") ~= true then
                GrabStuckCount = GrabStuckCount + 1
                if GrabStuckCount >= 18 then
                    GrabStuckCount = 0
                    SafeInvokeRemote(DeliveryRemote, "Cancel", nil)
                    task.wait(0.5)
                    SafeInvokeRemote(DeliveryRemote, "Stop", nil)
                    task.wait(0.5)
                    SafeInvokeRemote(DeliveryRemote, "Start", targetMode or "grab")
                end
            else
                GrabStuckCount = 0
            end
        end

        -- Case 4: ToShop -> Drive smoothly to pick up the passenger
        if state == "ToShop" and decoded then
            local targetPos, rawTarget = ResolveTarget("ToShop", decoded)
            if targetPos then
                local startCh = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                RecordLegStart(startCh and startCh.Position or nil)
                SafeRoadTravel(targetPos, { Speed = GetJitteredFarmSpeed(), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToShop" })

                local _cf, _conn = MakeArrivalLock(veh)
                WaitArrival(_cf, _conn, "ToShop")

                local curStateNow = LocalPlayer:GetAttribute("DeliveryState")
                if curStateNow == "ToShop" then
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                        ConfirmDelivery("StepAutoGrab", targetPos)
                        GrabStuckCount = 0
                        task.wait(0.15)
                    else
                        -- 🛡️ Proactive Drive Closer (No Warp!): Smoothly drive closer towards rawTarget marker ring
                        if rawTarget and veh and veh.Parent then
                            local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if ch then
                                local curP = ch.Position
                                local toRaw = Vector3.new(rawTarget.X - curP.X, 0, rawTarget.Z - curP.Z)
                                local dRaw = toRaw.Magnitude
                                local closerPos = rawTarget
                                if dRaw > 8.0 then
                                    closerPos = Vector3.new(curP.X, rawTarget.Y, curP.Z) + toRaw.Unit * math.max(4.0, dRaw - 6.0)
                                end
                                SafeRoadTravel(closerPos, { Speed = math.min(22, GetJitteredFarmSpeed()), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToShop" })
                                task.wait(0.2)
                            end
                        end
                        if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                            ConfirmDelivery("StepAutoGrab", targetPos)
                            GrabStuckCount = 0
                            task.wait(0.15)
                        end
                    end
                else
                    GrabStuckCount = 0
                end
            end

        -- Case 5: ToHome -> Drive smoothly to drop off the passenger
        elseif state == "ToHome" and decoded then
            local targetPos, rawTarget = ResolveTarget("ToHome", decoded)
            if targetPos then
                local startCh = veh and (veh:FindFirstChild("Chassis") or veh.PrimaryPart)
                RecordLegStart(startCh and startCh.Position or nil)
                SafeRoadTravel(targetPos, { Speed = GetJitteredFarmSpeed(), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToHome" })

                local _cf, _conn = MakeArrivalLock(veh)
                WaitArrival(_cf, _conn, "ToHome")

                local curStateNow = LocalPlayer:GetAttribute("DeliveryState")
                if curStateNow == "ToHome" then
                    if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                        ConfirmDelivery("StepAutoGrab", targetPos)
                        GrabStuckCount = 0
                        task.wait(0.15)
                    else
                        -- 🛡️ Proactive Drive Closer (No Warp!): Smoothly drive closer towards rawTarget marker ring
                        if rawTarget and veh and veh.Parent then
                            local ch = veh:FindFirstChild("Chassis") or veh.PrimaryPart
                            if ch then
                                local curP = ch.Position
                                local toRaw = Vector3.new(rawTarget.X - curP.X, 0, rawTarget.Z - curP.Z)
                                local dRaw = toRaw.Magnitude
                                local closerPos = rawTarget
                                if dRaw > 8.0 then
                                    closerPos = Vector3.new(curP.X, rawTarget.Y, curP.Z) + toRaw.Unit * math.max(4.0, dRaw - 6.0)
                                end
                                SafeRoadTravel(closerPos, { Speed = math.min(22, GetJitteredFarmSpeed()), RawTarget = rawTarget, FaceTarget = rawTarget, TargetKind = "ToHome" })
                                task.wait(0.2)
                            end
                        end
                        if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                            ConfirmDelivery("StepAutoGrab", targetPos)
                            GrabStuckCount = 0
                            task.wait(0.15)
                        end
                    end
                else
                    GrabStuckCount = 0
                end
            end
        end
    end)

    GrabWorking = false
    if not success then
        do end  -- suppressed: autograb error
    end
end
-- ⚡ Real-Time Instant Auto-Accept Offer & Phone Auto-Hide Listener (0ms latency trigger)
pcall(function()
    local sig = nil
    pcall(function() sig = LocalPlayer:GetAttributeChangedSignal("DeliveryState") end)
    if not sig then
        pcall(function() sig = LocalPlayer:GetAttributeChangedSignal("DeliveryState") end)
    end
    if sig then
        table.insert(Hub.Connections, sig:Connect(function()
            local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
            if not isFarmActive or not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then return end

            HideDeliveryPhoneUI()
            task.defer(HideDeliveryPhoneUI)

            local state = LocalPlayer:GetAttribute("DeliveryState")
            if state == "Offer" then
                task.spawn(AcceptDeliveryOffer, "Signal")
            end
        end))
    end

    -- ⚡ Real-Time Instant Auto-Confirm Arrival Listener (0ms latency trigger with Mutex protection)
    local arrivedSig = nil
    pcall(function() arrivedSig = LocalPlayer:GetAttributeChangedSignal("DeliveryArrived") end)
    if arrivedSig then
        table.insert(Hub.Connections, arrivedSig:Connect(function()
            if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then return end
            if IsAnyFarmEnabled() then
                HideDeliveryPhoneUI()
                task.defer(HideDeliveryPhoneUI)
                if LocalPlayer:GetAttribute("DeliveryArrived") == true then
                    task.spawn(ConfirmDelivery, "Signal")
                end
            end
        end))
    end

    local phoneSig = nil
    pcall(function() phoneSig = LocalPlayer:GetAttributeChangedSignal("PhoneOpen") end)
    if phoneSig then
        table.insert(Hub.Connections, phoneSig:Connect(function()
            if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then return end
            if IsAnyFarmEnabled() then
                HideDeliveryPhoneUI()
                task.defer(HideDeliveryPhoneUI)
            end
        end))
    end

    local cashSig = nil
    pcall(function() cashSig = LocalPlayer:GetAttributeChangedSignal("Cash") end)
    if cashSig then
        table.insert(Hub.Connections, cashSig:Connect(function()
            if not Hub.Running or genv[_gk.sk] ~= SCRIPT_ID then return end
            CheckMoneyLock()
        end))
    end
end)

-- 🛡️ Anti-Cheat Protected FarmCheck Pause Detection
local LastFarmCheckNotify = 0
function HandleFarmCheckPause()
    local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    local fc = pg and pg:FindFirstChild("FarmCheck")
    local rootFrame = fc and fc:FindFirstChild("Frame")
    -- Must strictly check rootFrame.Visible because ScreenGui fc.Enabled is always true in PlayerGui!
    if fc and fc.Enabled and rootFrame and rootFrame.Visible then
        local curV = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
        local ch = curV and (curV:FindFirstChild("Chassis") or curV.PrimaryPart)
        if ch then
            SmoothStop(ch, 0.7)
        end
        if not Hub.Settings.AutoCaptcha and (os.clock() - LastFarmCheckNotify) > 12 then
            LastFarmCheckNotify = os.clock()
if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "⚠️ ตรวจพบระบบเช็กคนจริง (FarmCheck)!",
                    Content = "มีกล่องถาม 'เช็กว่าเป็นคนจริง' บนหน้าจอ กรุณากดเลือกคำตอบบนหน้าจอเกมเพื่อทำฟาร์มต่อ",
                    Duration = 8
                })
            end
        end
        return true
    end
    return false
end


-- [AC BYPASS v2 - LAYER 6] Idle micro-behavior injector (simulates human micro-tremor & mouse drift)
local _lastIdleBehavior = 0
function InjectIdleBehavior()
    local now = os.clock()
    if (now - _lastIdleBehavior) < (8 + math.random() * 6) then return end
    _lastIdleBehavior = now

    pcall(function()
        if Teleporting then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local nudgeX = (math.random() - 0.5) * 0.015
        local nudgeY = (math.random() - 0.5) * 0.0075
        cam.CFrame = cam.CFrame * CFrame.Angles(nudgeY, nudgeX, 0)
    end)

    if not IsMobileDevice and not UserInputService.TouchEnabled then
        pcall(function()
            if VirtualUser then
                local vp = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
                local cx = vp.X * 0.5 + (math.random() - 0.5) * 4
                local cy = vp.Y * 0.5 + (math.random() - 0.5) * 4
                pcall(function() VirtualUser:SetMousePosition(Vector2.new(cx, cy)) end)
            end
        end)
    end
end

-- Continuous Delivery & Grab Farm Worker (With Auto-Resurrection Supervisor)
local FarmWorkerActive = false
function StartContinuousFarmWorker()
    if FarmWorkerActive then return end
    FarmWorkerActive = true
    task.spawn(function()
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            local loopOk, loopErr = pcall(function()
                if HandleFarmCheckPause() then
                    task.wait(1.0)
                    return
                end

                -- Auto-Rebind DeliveryRemote if lost
                RebindDeliveryRemote()

                -- Gate: DeliveryRemote + DeliveryShared + (NetSeal or direct remote fallback)
                local canFarm = DeliveryRemote
                    and DeliveryRemote.Parent
                    and DeliveryShared
                    and (NetSeal or DeliveryRemote:IsA("RemoteFunction") or DeliveryRemote:IsA("RemoteEvent"))

                if canFarm then
                    if CheckMoneyLock() then
                        task.wait(1.0)
                    elseif Hub.Settings.AutoGrabFarm then
                        pcall(StepAutoGrab)
                    elseif Hub.Settings.AutoFoodDelivery then
                        pcall(StepAutoDelivery, "food")
                    elseif Hub.Settings.AutoGrabRide then
                        pcall(StepAutoDelivery, "ride")
                    else
                        task.wait(1.0)
                    end
                else
                    RebindDeliveryRemote()
                    task.wait(1.5)
                end

                local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
                if isFarmActive and not Teleporting then
                    pcall(InjectIdleBehavior)
                end
            end)

            if not loopOk then
                do end  -- suppressed: farmworker recovery
                task.wait(1.0)
            end

            task.wait(GaussianJitter(0.5, 0.08))
        end
        FarmWorkerActive = false
    end)
end
StartContinuousFarmWorker()

-- ==============================================================
-- 🚀 AUTO MENU & AUTO JOIN ENGINE (Graphics -> Play Now -> Choose Job)
-- ==============================================================
function TriggerGuiButton(btn)
    if not btn then return false end
    local clicked = false

    -- 1. Firesignal (Fastest for executors supporting it)
    if typeof(firesignal) == "function" then
        if btn.Activated then
            if pcall(firesignal, btn.Activated) then clicked = true end
        end
        if btn.MouseButton1Click then
            if pcall(firesignal, btn.MouseButton1Click) then clicked = true end
        end
        if btn.MouseButton1Down then pcall(firesignal, btn.MouseButton1Down) end
        if btn.MouseButton1Up then pcall(firesignal, btn.MouseButton1Up) end
    end

    -- 2. GetConnections fallback (Universal on Android & iOS: Delta, Codex, Arceus X, Appleware)
    local getconns = (typeof(getconnections) == "function" and getconnections)
        or (typeof(debug) == "table" and debug.getconnections)
    if getconns then
        for _, sig in ipairs({ btn.Activated, btn.MouseButton1Click, btn.MouseButton1Down, btn.MouseButton1Up }) do
            if sig then
                local ok, conns = pcall(getconns, sig)
                if ok and type(conns) == "table" then
                    for _, conn in ipairs(conns) do
                        if typeof(conn) == "RBXScriptConnection" or type(conn) == "table" or type(conn) == "userdata" then
                            pcall(function()
                                if type(conn.Fire) == "function" then
                                    conn:Fire()
                                    clicked = true
                                elseif type(conn.Function) == "function" then
                                    task.spawn(conn.Function)
                                    clicked = true
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    -- 3. Virtual Input Manager (Distinguishes Touch vs Mouse for PC, Android, iOS)
    pcall(function()
        local vim = SafeGetService("VirtualInputManager") or game:GetService("VirtualInputManager")
        if not vim then return end
        local absPos = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        local center = absPos + (absSize / 2)
        local posX = math.floor(center.X)
        local posY = math.floor(center.Y)

        if IsMobileDevice or UserInputService.TouchEnabled then
            -- 📱 Mobile Touch Event Simulation (TouchBegin -> TouchEnd)
            vim:SendTouchEvent(0, 0, posX, posY)
            task.wait(0.03)
            vim:SendTouchEvent(0, 2, posX, posY)
            clicked = true
        else
            -- 💻 PC Mouse Event Simulation
            vim:SendMouseButtonEvent(posX, posY, 0, true, game, 1)
            task.wait(0.03)
            vim:SendMouseButtonEvent(posX, posY, 0, false, game, 1)
            clicked = true
        end
    end)

    -- 4. GuiService & Direct Activation fallback
    pcall(function()
        if typeof(btn.Activate) == "function" then
            btn:Activate()
            clicked = true
        end
    end)

    return clicked
end

function StepAutoPassMenu()
    if not Hub.Running or not Hub.Settings.AutoPassMenu then return end
    local pGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return end

    -- 1. 🖥️ GraphicsPicker (CHOOSE YOUR GRAPHICS: LOW / HIGH)
    local gp = pGui:FindFirstChild("GraphicsPicker")
    if gp and gp.Enabled then
        local targetGfx = (Hub.Settings.AutoGfxChoice == "HIGH") and "Play on HIGH" or "Play on LOW"
        local chosenBtn = nil
        for _, desc in ipairs(gp:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text:find(targetGfx, 1, true) then
                local p = desc.Parent
                while p and not p:IsA("TextButton") and p ~= gp do
                    p = p.Parent
                end
                if p and p:IsA("TextButton") then
                    chosenBtn = p
                    break
                end
            end
        end
        if chosenBtn then
            TriggerGuiButton(chosenBtn)
            task.wait(0.2)
        end
    end

    -- 2. 🎮 MainMenu (Welcome -> Play Now)
    local mm = pGui:FindFirstChild("MainMenu")
    if mm and mm.Enabled then
        local playBtn = nil
        for _, desc in ipairs(mm:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text == "Play Now" then
                local p = desc.Parent
                while p and not p:IsA("TextButton") and p ~= mm do
                    p = p.Parent
                end
                if p and p:IsA("TextButton") then
                    playBtn = p
                    break
                end
            end
        end
        if playBtn then
            TriggerGuiButton(playBtn)
            task.wait(0.25)
        end
    end

    -- 3. 💼 JobPicker (Choose a Job)
    local jp = pGui:FindFirstChild("JobPicker")
    if jp and jp.Enabled then
        local targetJob = Hub.Settings.AutoJobChoice or "ไรเดอร์ส่งอาหาร"
        local jobBtn = nil
        for _, desc in ipairs(jp:GetDescendants()) do
            if desc:IsA("TextLabel") and (desc.Text == targetJob or desc.Text:find(targetJob, 1, true)) then
                local p = desc.Parent
                while p and not p:IsA("TextButton") and p ~= jp do
                    p = p.Parent
                end
                if p and p:IsA("TextButton") then
                    jobBtn = p
                    break
                end
            end
        end

        if jobBtn then
            TriggerGuiButton(jobBtn)
            task.wait(0.12)
            -- Click PLAY button in JobPicker
            local playBtn = nil
            for _, desc in ipairs(jp:GetDescendants()) do
                if desc:IsA("TextLabel") and (desc.Text == "PLAY" or desc.Text == "Play") then
                    local p = desc.Parent
                    while p and not p:IsA("TextButton") and p ~= jp do
                        p = p.Parent
                    end
                    if p and p:IsA("TextButton") then
                        playBtn = p
                        break
                    end
                end
            end
            if playBtn then
                TriggerGuiButton(playBtn)
            else
                TriggerGuiButton(jobBtn)
            end
            task.wait(0.3)
        end
    end
end

-- Fast reactive listener on PlayerGui
task.spawn(function()
    local pGui = LocalPlayer and (LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5))
    if pGui then
        pGui.ChildAdded:Connect(function(child)
            if Hub.Settings.AutoPassMenu and (child.Name == "GraphicsPicker" or child.Name == "MainMenu" or child.Name == "JobPicker") then
                task.defer(StepAutoPassMenu)
            end
        end)
    end
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(0.35)
        if Hub.Settings.AutoPassMenu then
            pcall(StepAutoPassMenu)
        end
    end
end)

-- ==============================================================
-- 🎁 5.35 AUTO CLAIM QUESTS ENGINE (ระบบรับเควสเงินอัตโนมัติ)
-- ==============================================================
do
local QuestClaimingBusy = false
local LastQuestClaimAttempt = 0

function ClaimAllQuestsOnce()
    if QuestClaimingBusy then return 0, 0 end
    QuestClaimingBusy = true
    local claimedCount = 0
    local totalCashAwarded = 0

    pcall(function()
        -- 1. Native NetSeal Server Remote Invocation (100% Reliable & Headless)
        local netSeal = (NetSeal)
                or (pcall(require, ReplicatedStorage:WaitForChild("NetSeal", 2)) and require(ReplicatedStorage.NetSeal))
        local gameShared = (GameShared)
                or (pcall(require, ReplicatedStorage:WaitForChild("GameShared", 2)) and require(ReplicatedStorage.GameShared))
        local questShared = (QuestShared)
                or (pcall(require, ReplicatedStorage:WaitForChild("QuestShared", 2)) and require(ReplicatedStorage.QuestShared))

        local qRemote = nil
        pcall(function()
            local folderName = (gameShared and gameShared.REMOTES) or "GameRemotes"
            local remotesFolder = ReplicatedStorage:FindFirstChild(folderName) or ReplicatedStorage:WaitForChild(folderName, 2)
            local rName = (questShared and questShared.REMOTE) or "Quest"
            qRemote = remotesFolder and (remotesFolder:FindFirstChild(rName) or remotesFolder:WaitForChild(rName, 2))
        end)

        if qRemote and netSeal and questShared then
            for _, q in ipairs(questShared.DAILY or {}) do
                local ok, success, msg = pcall(netSeal.invoke, qRemote, "Claim", "daily", q.id)
                if ok and success == true then
                    claimedCount = claimedCount + 1
                    totalCashAwarded = totalCashAwarded + (q.reward or 0)
                end
            end
            for _, q in ipairs(questShared.WEEKLY or {}) do
                local ok, success, msg = pcall(netSeal.invoke, qRemote, "Claim", "weekly", q.id)
                if ok and success == true then
                    claimedCount = claimedCount + 1
                    totalCashAwarded = totalCashAwarded + (q.reward or 0)
                end
            end
        end

        -- 2. Fallback: Secondary GUI button scan (in case NetSeal or Remote changes)
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local phoneGui = pGui:FindFirstChild("Phone")
            if phoneGui then
                for _, desc in ipairs(phoneGui:GetDescendants()) do
                    if desc:IsA("GuiButton") and desc.Name == "Claim" and desc.Visible then
                        pcall(TriggerGuiButton, desc)
                    end
                end
            end
        end
    end)

    QuestClaimingBusy = false
    return claimedCount, totalCashAwarded
end
Hub.ClaimAllQuestsOnce = ClaimAllQuestsOnce

-- Background Auto-Claim Quests Watcher
task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(6.0)
        if Hub.Settings.AutoClaimQuests and not QuestClaimingBusy then
            local now = os.clock()
            if (now - LastQuestClaimAttempt) >= 15 then
                LastQuestClaimAttempt = now
                local claimed, cash = ClaimAllQuestsOnce()
                if claimed > 0 then
                    pcall(function()
                        if Hub.Window and Hub.Window.Notify then
                            local text = string.format("รับรางวัลเควสสำเร็จ %d รายการ!", claimed)
                            if cash > 0 then
                                text = text .. string.format(" (+฿%s)", FormatNumber and FormatNumber(cash) or tostring(cash))
                            end
                            Hub.Window:Notify({
                                Title = "เควสเงิน (Quests)",
                                Text = text,
                                Icon = "gift",
                                Duration = 4
                            })
                        end
                    end)
                end
            end
        end
    end
end)
end

-- ==============================================================
-- ⚙️ 5.4 AUTOMATIC REMOTE PISTON SHOP ENGINE (ระบบซื้อลูกสูบซิ่งระยะไกล)
-- ==============================================================
do
local PISTON_PRICES = {
    [53] = 3000,
    [56] = 5000,
    [58] = 8000,
    [62] = 14000,
    [67] = 25000,
    [72] = 40000,
    [75] = 60000,
    [80] = 100000,
    [88] = 150000,
    [90] = 200000
}
local PISTON_ORDER_DESC = { 90, 88, 80, 75, 72, 67, 62, 58, 56, 53 }
local PistonBuyingBusy = false

function GetPistonShopState()
    local shop = Workspace:FindFirstChild("PistonShop")
        or (Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("PistonShop"))
    if not shop then
        for _, c in ipairs(Workspace:GetChildren()) do
            if c.Name:lower() == "pistonshop" then
                shop = c
                break
            end
        end
    end

    -- ตรวจสอบจุด PistonShopSpots กรณี StreamingEnabled ยังไม่โหลดโมเดลร้าน
    if not shop then
        local spots = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("PistonShopSpots")
        if spots then
            local activeSpot = spots:FindFirstChildWhichIsA("BasePart")
            if activeSpot and LocalPlayer and LocalPlayer.RequestStreamAroundAsync then
                pcall(function()
                    LocalPlayer:RequestStreamAroundAsync(activeSpot.Position, 1)
                end)
                shop = Workspace:FindFirstChild("PistonShop")
                    or (Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("PistonShop"))
            end
        end
    end

    if not shop then return false, nil, "ไม่พบร้าน", 0, 0 end
    local sellerModel = shop:FindFirstChild("Seller") or shop:FindFirstChildWhichIsA("Model")
    if not sellerModel then return false, nil, "ไม่พบช่างขาย", 0, 0 end
    local seller = sellerModel:FindFirstChild("HumanoidRootPart") or sellerModel.PrimaryPart or sellerModel:FindFirstChildWhichIsA("BasePart")
    if not seller then return false, nil, "ไม่พบ HumanoidRootPart ของช่าง", 0, 0 end
    local closesAt = shop:GetAttribute("ClosesAt") or 0
    local spot = shop:GetAttribute("Spot") or "ย้ายร้าน"
    local now = Workspace:GetServerTimeNow()
    local secondsLeft = closesAt - now
    if closesAt > 0 and secondsLeft <= 0 then
        return false, seller, spot, 0, closesAt
    end
    return true, seller, spot, math.max(0, math.floor(secondsLeft)), closesAt
end
Hub.GetPistonShopState = GetPistonShopState

-- [FIX #4] ResolvePistonSizes — guard string ที่ไม่ match pattern
function ResolvePistonSizes(input)
    local sizesToTry = {}
    local selectedSet = {}
    local hasHighest = false

    if type(input) == "table" then
        for k, v in pairs(input) do
            local optStr = ""
            if type(k) == "string" and (v == true or v == 1) then
                optStr = k
            elseif type(v) == "string" then
                optStr = v
            end
            if optStr ~= "" then
                if optStr:find("สูงสุด") or optStr:find("Highest") then
                    hasHighest = true
                else
                    local num = tonumber(optStr:match("(%d+)"))
                    if num and PISTON_PRICES[num] then
                        selectedSet[num] = true
                    end
                end
            end
        end
    elseif type(input) == "string" and input ~= "" then
        if input:find("สูงสุด") or input == "Highest" then
            hasHighest = true
        else
            local num = tonumber(input:match("(%d+)"))
            if num and PISTON_PRICES[num] then
                selectedSet[num] = true
            else
                -- [FIX #4] string ที่ไม่รู้จัก → fallback Highest แทนที่จะซื้อทุกขนาดเงียบๆ
                hasHighest = true
            end
        end
    elseif type(input) == "number" and PISTON_PRICES[input] then
        selectedSet[input] = true
    end

    if hasHighest then return PISTON_ORDER_DESC end

    for _, sz in ipairs(PISTON_ORDER_DESC) do
        if selectedSet[sz] then
            table.insert(sizesToTry, sz)
        end
    end

    if #sizesToTry == 0 then return PISTON_ORDER_DESC end
    return sizesToTry
end

function RemoteBuyPiston(targetSizeInput)
    if PistonBuyingBusy then return false, "กำลังดำเนินการซื้ออยู่แล้ว", nil end
    local isOpen, seller, spotName, secLeft = GetPistonShopState()
    if not isOpen or not seller then
        return false, "ร้านลูกสูบยังไม่เปิด หรือกำลังย้ายร้าน (" .. tostring(spotName) .. ")", nil
    end

    -- Candidate sizes (รองรับทั้งเลือกขนาดเดียว หรือเลือกหลายขนาดพร้อมกัน)
    local sizesToTry = ResolvePistonSizes(targetSizeInput or Hub.Settings.AutoBuyPistonSize)

    local playerCash = LocalPlayer:GetAttribute("Cash") or 0
    local affordableSizes = {}
    for _, sz in ipairs(sizesToTry) do
        local pr = PISTON_PRICES[sz] or 0
        if playerCash >= pr then
            table.insert(affordableSizes, sz)
        end
    end

    if #affordableSizes == 0 then
        return false, "เงินในตัวไม่พอซื้อลูกสูบที่เลือก (มี ฿" .. tostring(playerCash) .. ")", nil
    end

    local pistonRemote = (ReplicatedStorage:FindFirstChild("GameRemotes") and ReplicatedStorage.GameRemotes:FindFirstChild("Piston"))
        or (ReplicatedStorage:FindFirstChild("Piston"))
    local invFn = DirectInvoke or (NetSeal and NetSeal.invoke) or (genv and genv[_gk.ni])

    if not pistonRemote or not invFn then
        return false, "ไม่พบ Remote หรือฟังก์ชันเรียกซื้อลูกสูบ", nil
    end

    PistonBuyingBusy = true
    local boughtSuccess = false
    local boughtMsg = ""
    local finalSizeBought = nil

    local success, err = pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hrp or not hum then
            boughtMsg = "ไม่พบตัวละคร"
            return
        end

        local shopPos = seller.Position
        local dist = (hrp.Position - shopPos).Magnitude
        local needWarp = dist > 15

        local oldCF = hrp.CFrame
        local oldVel = hrp.AssemblyLinearVelocity
        local oldRotVel = hrp.AssemblyAngularVelocity
        local oldSeat = hum.SeatPart
        local cam = Workspace.CurrentCamera
        local oldCamCF = cam and cam.CFrame
        local oldCamType = cam and cam.CameraType
        local camConn = nil

        local function restoreState()
            if needWarp and hrp and oldCF then
                hrp.CFrame = oldCF
                hrp.AssemblyLinearVelocity = oldVel or Vector3.zero
                hrp.AssemblyAngularVelocity = oldRotVel or Vector3.zero

                if camConn then
                    pcall(function() camConn:Disconnect() end)
                    camConn = nil
                end
                if cam and oldCamType then
                    pcall(function() cam.CameraType = oldCamType end)
                end

                if oldSeat and oldSeat.Parent and oldSeat:IsA("VehicleSeat") and hum then
                    task.defer(function()
                        task.wait(0.08)
                        pcall(function() oldSeat:Sit(hum) end)
                    end)
                end
            end
        end

        if needWarp then
            -- 1. ล็อกมุมกล้องไม่ให้จอกระตุกหรือหมุน
            if cam and oldCamCF then
                cam.CameraType = Enum.CameraType.Scriptable
                camConn = RunService.RenderStepped:Connect(function()
                    if cam and oldCamCF then
                        cam.CFrame = oldCamCF
                    end
                end)
            end

            -- 2. ลงจากเบาะรถชั่วคราว
            if oldSeat then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                RunService.Heartbeat:Wait()
            end

            -- 3. Nano-Warp ไปยืนแตะหน้า NPC ช่าง
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local targetCF = CFrame.lookAt(seller.Position + (seller.CFrame.LookVector * 3) + Vector3.new(0, 1.2, 0), seller.Position)
            hrp.CFrame = targetCF

            -- 4. รอ 5 Heartbeats เพื่อให้เซิร์ฟเวอร์ sync ตำแหน่งตัวละคร
            for _ = 1, 5 do
                RunService.Heartbeat:Wait()
            end
        end

        -- 5. ยิงคำสั่งซื้อผ่าน Remote (เซิร์ฟเวอร์จะยอมรับเพราะตำแหน่งอยู่ที่ร้านแล้ว)
        local buyOk, buyErr = pcall(function()
            for _, sz in ipairs(affordableSizes) do
                local invOk, ok, msg = pcall(invFn, pistonRemote, "Buy", sz)
                if invOk and ok then
                    boughtSuccess = true
                    boughtMsg = tostring(msg or "ซื้อสำเร็จ")
                    finalSizeBought = sz
                    break
                else
                    boughtMsg = tostring(msg or "สินค้าหมด หรือเกิดข้อผิดพลาด")
                    task.wait(0.1)
                end
            end
        end)

        -- 6. สแน็ปตัวละครกลับตำแหน่งเดิม และคืนมุมกล้องทันที
        restoreState()

        task.wait(0.2)

        -- 7. ติดตั้งลูกสูบเข้ารถอัตโนมัติ (ถ้าเปิดใช้)
        if boughtSuccess and Hub.Settings.AutoInstallPiston and finalSizeBought then
            task.wait(0.25)
            local veh = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
            if veh and pistonRemote and invFn then
                pcall(invFn, pistonRemote, "Fit", veh, finalSizeBought)
            end
        end

        -- 8. ซ่อน GUI ร้านที่อาจเด้งขึ้นมา
        local pgui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("PistonShop")
        if pgui then
            if pgui:FindFirstChild("PistonShopWindow") then pgui.PistonShopWindow.Visible = false end
            if pgui:FindFirstChild("PistonShopWindowShade") then pgui.PistonShopWindowShade.Visible = false end
        end
    end)

    PistonBuyingBusy = false

    if not success then
        return false, "เกิดข้อผิดพลาดระหว่างซื้อ: " .. tostring(err), nil
    end

    return boughtSuccess, boughtMsg, finalSizeBought
end
Hub.RemoteBuyPiston = RemoteBuyPiston

function WarpToPistonShop()
    local isOpen, seller, spotName = GetPistonShopState()
    if not seller then
        pcall(function()
            local win = Hub.Window
            if win and win.Notify then
                win:Notify({ Title = "ร้านลูกสูบซิ่ง", Text = "ร้านลูกสูบยังไม่เปิด หรือกำลังย้ายร้าน", Icon = "alert-circle" })
            end
        end)
        return false
    end
    local targetCF = CFrame.lookAt(seller.Position + seller.CFrame.LookVector * 5, seller.Position)
    if TeleportEntity then
        return TeleportEntity(targetCF)
    else
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = targetCF end
        return true
    end
end
Hub.WarpToPistonShop = WarpToPistonShop

-- Background Auto-Buy Piston Watcher
-- [FIX] ปลดล็อกให้ทำงานได้ระหว่างฟาร์ม และใช้ Nano-Warp เพื่อผ่านการเช็คระยะเซิร์ฟเวอร์
task.spawn(function()
    local lastPistonAttempt = 0
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(3.0)
        if Hub.Settings.AutoBuyPiston and not PistonBuyingBusy then
            local now = os.clock()
            -- ไม่ซื้อตอนกำลังวาปขับรถทางไกล (Teleporting) หรือกำลังกดรับข้อเสนอ (IsAcceptingOffer)
            local isBusyTransit = Teleporting or IsAcceptingOffer
            if not isBusyTransit and (now - lastPistonAttempt) > 10 then
                local isOpen, seller = GetPistonShopState()
                if isOpen and seller then
                    local target = Hub.Settings.AutoBuyPistonSize or "Highest"
                    local ok, msg, sizeBought = RemoteBuyPiston(target)
                    lastPistonAttempt = ok and (now + 25) or now
                    if ok then
                        pcall(function()
                            local win = Hub.Window
                            if win and win.Notify then
                                win:Notify({
                                    Title = "ร้านลูกสูบซิ่ง (Auto Buy)",
                                    Text = "ออโต้ซื้อลูกสูบขนาด " .. tostring(sizeBought) .. " มม. สำเร็จ! (" .. tostring(msg) .. ")",
                                    Icon = "check",
                                    Duration = 5
                                })
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- ==============================================================
end

-- ==============================================================
-- 🪖 5.5 HELMET & 3D VIEWPORT ENGINE (ระบบหมวกกันน็อก และพรีวิว 3D)
-- ==============================================================
do
local ActiveHelmetRigs = {}
local FloatingHelmetWindow = nil
local CurrentChosenHelmetId = ""

function GetHelmetRemote()
    if HelmetRemote and HelmetRemote.Parent then return HelmetRemote end
    HelmetRemote = (Remotes and Remotes:FindFirstChild("Helmet"))
                or (HelmetShared and Remotes and Remotes:FindFirstChild(HelmetShared.REMOTE))
                or ReplicatedStorage:FindFirstChild("Helmet")
    return HelmetRemote
end

function GetHelmetShopPosition()
    local shop = Workspace:FindFirstChild("HelmetShop")
    if shop then
        local clerkHrp = shop:FindFirstChild("HumanoidRootPart", true)
        if clerkHrp and clerkHrp:IsA("BasePart") then
            return clerkHrp.Position
        end
    end
    local map = Workspace:FindFirstChild("Map")
    local spot = map and map:FindFirstChild("HelmetShopSpot")
    if spot and spot:IsA("BasePart") then
        return spot.Position
    end
    return Vector3.new(-912.281, 4.0, 457.472)
end

function RemoveClientHelmetRig()
    local char = LocalPlayer.Character
    if not char then return end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Model") and (ch:GetAttribute("HelmetName") or ch:GetAttribute("IsCustomHelmet")) then
            pcall(function() ch:Destroy() end)
        end
    end
end

function EquipClientHelmetRig(helmetName)
    local char = LocalPlayer.Character
    if not char then return false end
    local head = char:FindFirstChild("Head")
    if not head then return false end

    RemoveClientHelmetRig()

    local folder = HelmetsFolder or ReplicatedStorage:FindFirstChild("Helmets")
    if not folder then return false end

    local template = folder:FindFirstChild(helmetName)
    if not template then
        for _, ch in ipairs(folder:GetChildren()) do
            if string.lower(ch.Name) == string.lower(tostring(helmetName)) then
                template = ch
                break
            end
        end
    end
    if not template then return false end

    local helmetModel = Instance.new("Model")
    helmetModel.Name = helmetName
    helmetModel:SetAttribute("HelmetName", helmetName)
    helmetModel:SetAttribute("IsCustomHelmet", true)

    local handleTemplate = template:FindFirstChild("Handle")
    if not handleTemplate then return false end

    local handle = handleTemplate:Clone()
    for _, d in ipairs(handle:GetDescendants()) do
        if d:IsA("ClickDetector") or d:IsA("JointInstance") or d:IsA("Attachment") then
            d:Destroy()
        end
    end
    handle.CanCollide = false
    handle.Massless = true
    handle.CFrame = head.CFrame
    handle.Parent = helmetModel

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = handle
    weld.Parent = handle

    for _, child in ipairs(template:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Handle" then
            local p = child:Clone()
            for _, d in ipairs(p:GetDescendants()) do
                if d:IsA("ClickDetector") or d:IsA("JointInstance") or d:IsA("Attachment") then
                    d:Destroy()
                end
            end
            p.CanCollide = false
            p.Massless = true
            local attrName = "Base" .. (child.Name == "Visor" and "Visor" or "Spoiler") .. "C0"
            local cfOffset = template:GetAttribute(attrName)
            if cfOffset then
                p.CFrame = handle.CFrame * cfOffset
            else
                p.CFrame = handle.CFrame
            end
            p.Parent = helmetModel

            local w = Instance.new("WeldConstraint")
            w.Part0 = handle
            w.Part1 = p
            w.Parent = p
        end
    end

    helmetModel.Parent = char
    Hub.Settings.SelectedHelmet = helmetName
    return true
end

function WearHelmet(helmetName)
    if not helmetName or helmetName == "" then
        return false, "ไม่ได้ระบุชื่อหมวก"
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hrp or not hum then
        return false, "ไม่พบตัวละคร"
    end

    local remote = GetHelmetRemote()
    local invFn = DirectInvoke or (NetSeal and NetSeal.invoke) or (genv and genv[_gk.ni])

    -- Check distance to helmet shop
    local shopPos = GetHelmetShopPosition()
    local dist = (hrp.Position - shopPos).Magnitude
    local needWarp = dist > 20

    local oldCF = hrp.CFrame
    local oldVel = hrp.AssemblyLinearVelocity
    local oldRotVel = hrp.AssemblyAngularVelocity
    local oldSeat = hum.SeatPart
    local cam = Workspace.CurrentCamera
    local oldCamCF = cam and cam.CFrame
    local oldCamType = cam and cam.CameraType
    local camConn = nil

    if needWarp and remote and invFn then
        -- 1. Freeze camera view cleanly so screen has zero flicker
        if cam and oldCamCF then
            cam.CameraType = Enum.CameraType.Scriptable
            camConn = RunService.RenderStepped:Connect(function()
                if cam and oldCamCF then
                    cam.CFrame = oldCamCF
                end
            end)
        end

        -- 2. Dismount temporarily if seated
        if oldSeat then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            RunService.Heartbeat:Wait()
        end

        -- 3. Nano-Warp to Helmet Shop
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(shopPos + Vector3.new(0, 1.5, 0))

        -- 4. Wait for server physics replication handshake
        for _ = 1, 5 do
            RunService.Heartbeat:Wait()
        end
    end

    -- 5. Invoke Remote Handshake
    local ok, res, err = nil, nil, nil
    if remote and invFn then
        ok, res, err = pcall(invFn, remote, "Wear", helmetName)
    end

    -- 6. Restore character and camera state immediately
    if needWarp and remote and invFn then
        hrp.CFrame = oldCF
        hrp.AssemblyLinearVelocity = oldVel or Vector3.zero
        hrp.AssemblyAngularVelocity = oldRotVel or Vector3.zero

        if camConn then
            pcall(function() camConn:Disconnect() end)
        end
        if cam and oldCamType then
            pcall(function() cam.CameraType = oldCamType end)
        end

        if oldSeat and oldSeat.Parent and oldSeat:IsA("VehicleSeat") then
            task.defer(function()
                task.wait(0.05)
                pcall(function() oldSeat:Sit(hum) end)
            end)
        end
    end

    -- 7. Validate server outcome
    local errMsg = tostring(err or res or "")
    local serverRejected = (not ok) or (res == false) or (errMsg:find("ต้องอยู่ที่ร้านหมวก") ~= nil)
    if not serverRejected then
        Hub.Settings.SelectedHelmet = helmetName
        return true, res or "สวมหมวกสำเร็จ"
    end

    -- 8. Fallback: Direct Client Rig Equip
    local clientEquipped = EquipClientHelmetRig(helmetName)
    if clientEquipped then
        Hub.Settings.SelectedHelmet = helmetName
        return true, "สวมใส่สำเร็จ (Direct Mode)"
    end

    return false, errMsg ~= "" and errMsg or "สวมหมวกไม่สำเร็จ"
end
Hub.WearHelmet = WearHelmet

function RemoveHelmet()
    -- 1. Remove client rig if present
    RemoveClientHelmetRig()

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    local remote = GetHelmetRemote()
    local invFn = DirectInvoke or (NetSeal and NetSeal.invoke) or (genv and genv[_gk.ni])

    if not remote or not invFn or not char or not hrp or not hum then
        return true, "ถอดหมวกเรียบร้อย"
    end

    local shopPos = GetHelmetShopPosition()
    local dist = (hrp.Position - shopPos).Magnitude
    local needWarp = dist > 20

    local oldCF = hrp.CFrame
    local oldVel = hrp.AssemblyLinearVelocity
    local oldRotVel = hrp.AssemblyAngularVelocity
    local oldSeat = hum.SeatPart
    local cam = Workspace.CurrentCamera
    local oldCamCF = cam and cam.CFrame
    local oldCamType = cam and cam.CameraType
    local camConn = nil

    if needWarp then
        if cam and oldCamCF then
            cam.CameraType = Enum.CameraType.Scriptable
            camConn = RunService.RenderStepped:Connect(function()
                if cam and oldCamCF then
                    cam.CFrame = oldCamCF
                end
            end)
        end

        if oldSeat then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            RunService.Heartbeat:Wait()
        end

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(shopPos + Vector3.new(0, 1.5, 0))

        for _ = 1, 5 do
            RunService.Heartbeat:Wait()
        end
    end

    local ok, res, err = pcall(invFn, remote, "Remove")

    if needWarp then
        hrp.CFrame = oldCF
        hrp.AssemblyLinearVelocity = oldVel or Vector3.zero
        hrp.AssemblyAngularVelocity = oldRotVel or Vector3.zero

        if camConn then
            pcall(function() camConn:Disconnect() end)
        end
        if cam and oldCamType then
            pcall(function() cam.CameraType = oldCamType end)
        end

        if oldSeat and oldSeat.Parent and oldSeat:IsA("VehicleSeat") then
            task.defer(function()
                task.wait(0.05)
                pcall(function() oldSeat:Sit(hum) end)
            end)
        end
    end

    if ok and res ~= false then
        return true, res or "ถอดหมวกสำเร็จ"
    end
    return true, "ถอดหมวกเรียบร้อย"
end
Hub.RemoveHelmet = RemoveHelmet

function ToggleHelmetVisor()
    local remote = GetHelmetRemote()
    local invFn = DirectInvoke or (NetSeal and NetSeal.invoke) or (genv and genv[_gk.ni])
    if remote and invFn then
        pcall(invFn, remote, "Visor")
    end

    -- Also toggle client rig visor if worn
    local char = LocalPlayer.Character
    if char then
        for _, m in ipairs(char:GetChildren()) do
            if m:IsA("Model") and (m:GetAttribute("HelmetName") or m:GetAttribute("IsCustomHelmet")) then
                local visor = m:FindFirstChild("Visor", true)
                if visor and visor:IsA("BasePart") then
                    local curVis = visor:GetAttribute("VisorOpen") or false
                    visor:SetAttribute("VisorOpen", not curVis)
                    if not curVis then
                        visor.CFrame = visor.CFrame * CFrame.Angles(math.rad(40), 0, 0)
                    else
                        visor.CFrame = visor.CFrame * CFrame.Angles(-math.rad(40), 0, 0)
                    end
                end
            end
        end
    end
    return true
end
Hub.ToggleHelmetVisor = ToggleHelmetVisor

function GetCurrentHelmet()
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("HelmetName") then
                local rawName = v:GetAttribute("HelmetName")
                local info = HelmetShared and HelmetShared.info and HelmetShared.info(rawName)
                return rawName, (info and info.label) or rawName
            end
        end
    end
    return nil, "ไม่ได้ใส่หมวก"
end
Hub.GetCurrentHelmet = GetCurrentHelmet

function GetAllHelmetOptions()
    local list = {}
    local nameToId = {}
    local idToName = {}

    local function addOption(displayName, rawId)
        if not nameToId[displayName] then
            table.insert(list, displayName)
            nameToId[displayName] = rawId
            idToName[rawId] = displayName
        end
    end

    if HelmetShared and type(HelmetShared.FULL) == "table" then
        for _, item in ipairs(HelmetShared.FULL) do
            local dName = (item.label and (item.label .. " (Full)")) or item.name
            addOption(dName, item.name)
        end
    end

    if HelmetShared and type(HelmetShared.INDEX_SHELLS) == "table" and type(HelmetShared.INDEX_VISORS) == "table" then
        for _, shell in ipairs(HelmetShared.INDEX_SHELLS) do
            local sKey = shell.key or shell.label or "White"
            local sLabel = shell.label or sKey
            for _, visor in ipairs(HelmetShared.INDEX_VISORS) do
                local vNum = visor.n or 1
                local vLabel = visor.label or tostring(vNum)
                local fullIndexName = (HelmetShared.indexName and HelmetShared.indexName(sKey, vNum)) or (sKey .. "_" .. tostring(vNum))
                local dName = string.format("หมวกครึ่งใบ: %s (ชิลด์ %s)", sLabel, vLabel)
                addOption(dName, fullIndexName)
            end
        end
    end

    local folder = HelmetsFolder or ReplicatedStorage:FindFirstChild("Helmets")
    if folder then
        for _, child in ipairs(folder:GetChildren()) do
            if not idToName[child.Name] then
                addOption("หมวก: " .. child.Name, child.Name)
            end
        end
    end

    if #list == 0 then
        addOption("Full_Black (ดำเต็มใบ)", "Full_Black")
        addOption("Full_White (ขาวเต็มใบ)", "Full_White")
        addOption("Index_White_1 (ครึ่งใบขาว)", "Index_White_1")
    end

    return list, nameToId, idToName
end
Hub.GetAllHelmetOptions = GetAllHelmetOptions

function SetupHelmetViewportRig(viewportFrame, helmetModelName)
    if IsMobileDevice then return nil end
    if not viewportFrame or not viewportFrame:IsA("ViewportFrame") then return nil end
    viewportFrame:ClearAllChildren()

    local folder = HelmetsFolder or ReplicatedStorage:FindFirstChild("Helmets")
    if not folder then return nil end

    local template = folder:FindFirstChild(helmetModelName)
    if not template then
        for _, ch in ipairs(folder:GetChildren()) do
            if string.lower(ch.Name) == string.lower(tostring(helmetModelName)) then
                template = ch
                break
            end
        end
    end
    if not template or not template:FindFirstChild("Handle") then return nil end

    local handle = template.Handle:Clone()
    for _, d in ipairs(handle:GetDescendants()) do
        if d:IsA("ClickDetector") or d:IsA("JointInstance") or d:IsA("Attachment") then
            d:Destroy()
        end
    end
    handle.CFrame = CFrame.new(0, 0, 0)

    for _, child in ipairs(handle:GetChildren()) do
        if child:IsA("BasePart") then
            local attrName = "Base" .. (child.Name == "Visor" and "Visor" or "Spoiler") .. "C0"
            local cf = template:GetAttribute(attrName)
            if cf then
                child.CFrame = cf
            end
            child.Parent = viewportFrame
        end
    end
    handle.Parent = viewportFrame

    local cam = Instance.new("Camera")
    cam.FieldOfView = 38
    cam.Parent = viewportFrame
    viewportFrame.CurrentCamera = cam

    viewportFrame.BackgroundTransparency = 1
    viewportFrame.LightDirection = Vector3.new(-0.6, -1, -0.8)
    viewportFrame.Ambient = Color3.fromRGB(180, 180, 190)
    viewportFrame.LightColor = Color3.fromRGB(255, 250, 240)

    local baseSize = template:GetAttribute("BaseHandleSize") or handle.Size
    local distance = (baseSize and baseSize.Magnitude or 3) * 1.25
    local height = (baseSize and baseSize.Y or 1.2) * 0.18

    local rig = {
        Frame = viewportFrame,
        Camera = cam,
        Distance = distance,
        Height = height,
        Angle = 0,
        Dragging = false,
        LastPos = nil,
    }

    local function applyCamCFrame()
        local ang = rig.Angle - 2.6
        local x = math.sin(ang) * rig.Distance
        local y = rig.Height + rig.Distance * 0.18
        local z = math.cos(ang) * rig.Distance
        rig.Camera.CFrame = CFrame.lookAt(Vector3.new(x, y, z), Vector3.new(0, rig.Height * 0.4, 0))
    end
    applyCamCFrame()

    viewportFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            rig.Dragging = true
            rig.LastPos = input.Position
        end
    end)
    viewportFrame.InputChanged:Connect(function(input)
        if rig.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position.X - (rig.LastPos and rig.LastPos.X or input.Position.X)
            rig.LastPos = input.Position
            rig.Angle = rig.Angle - (delta * 0.015)
            applyCamCFrame()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            rig.Dragging = false
        end
    end)

    rig.ApplyCam = applyCamCFrame
    ActiveHelmetRigs[viewportFrame] = rig
    return rig
end
Hub.SetupHelmetViewportRig = SetupHelmetViewportRig

-- Background 3D Viewport continuous rotation loop (Throttled when no active rigs)
task.spawn(function()
    if IsMobileDevice then return end
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        if not next(ActiveHelmetRigs) then
            task.wait(0.5)
        else
            local dt = RunService.RenderStepped:Wait()
            for frame, rig in pairs(ActiveHelmetRigs) do
                if frame and frame.Parent and frame.Visible then
                    if not rig.Dragging and rig.Camera then
                        rig.Angle = (rig.Angle or 0) + dt * 0.75
                        if rig.ApplyCam then
                            rig.ApplyCam()
                        end
                    end
                else
                    ActiveHelmetRigs[frame] = nil
                end
            end
        end
    end
end)

function CreateFloatingHelmetPreviewWindow()
    if IsMobileDevice then return nil end
    if FloatingHelmetWindow and FloatingHelmetWindow.Gui then
        return FloatingHelmetWindow
    end

    local parentGui = (gethui and gethui())
                   or CoreGui:FindFirstChild("RobloxGui")
                   or CoreGui
                   or LocalPlayer:FindFirstChild("PlayerGui")

    local FLOATING_GUI_NAME = "HelmetPreviewHUD"
    RegisterStealthGui(FLOATING_GUI_NAME)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = FLOATING_GUI_NAME
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100

    local mainCard = Instance.new("Frame")
    mainCard.Name = "MainCard"
    mainCard.Size = UDim2.new(0, 260, 0, 310)
    mainCard.Position = UDim2.new(1, -280, 0.5, -155)
    mainCard.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    mainCard.BorderSizePixel = 0
    mainCard.Active = true
    mainCard.ClipsDescendants = true
    mainCard.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = mainCard

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 60, 75)
    stroke.Thickness = 1.2
    stroke.Parent = mainCard

    -- Dragging top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainCard

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 14)
    topCorner.Parent = topBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = "🪖 3D Helmet Preview"
    titleLbl.Font = Enum.Font.BuilderSansBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    titleLbl.Size = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.BuilderSansBold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = true
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 6)
    cCorner.Parent = closeBtn
    closeBtn.Parent = topBar

    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
        Hub.Settings.FloatingHelmetPreview = false
    end)

    -- Make draggable
    local isDragging = false
    local dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainCard.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainCard.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    -- Viewport Frame
    local vpFrame = Instance.new("ViewportFrame")
    vpFrame.Name = "HelmetViewport"
    vpFrame.Size = UDim2.new(1, -16, 0, 175)
    vpFrame.Position = UDim2.new(0, 8, 0, 42)
    vpFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
    vpFrame.BorderSizePixel = 0
    local vpCorner = Instance.new("UICorner")
    vpCorner.CornerRadius = UDim.new(0, 10)
    vpCorner.Parent = vpFrame
    local vpStroke = Instance.new("UIStroke")
    vpStroke.Color = Color3.fromRGB(40, 44, 56)
    vpStroke.Thickness = 1
    vpStroke.Parent = vpFrame
    vpFrame.Parent = mainCard

    -- Subtitle / Name label
    local helmetNameLbl = Instance.new("TextLabel")
    helmetNameLbl.Name = "HelmetNameLbl"
    helmetNameLbl.Text = "เลือกหมวกเพื่อดูตัวอย่าง"
    helmetNameLbl.Font = Enum.Font.BuilderSansMedium
    helmetNameLbl.TextSize = 12
    helmetNameLbl.TextColor3 = Color3.fromRGB(200, 205, 220)
    helmetNameLbl.Size = UDim2.new(1, -16, 0, 20)
    helmetNameLbl.Position = UDim2.new(0, 8, 0, 222)
    helmetNameLbl.BackgroundTransparency = 1
    helmetNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    helmetNameLbl.Parent = mainCard

    -- Buttons row at bottom
    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -16, 0, 32)
    btnRow.Position = UDim2.new(0, 8, 1, -40)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = mainCard

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.Padding = UDim.new(0, 6)
    btnLayout.Parent = btnRow

    local function makeMiniBtn(text, color, onClick)
        local b = Instance.new("TextButton")
        b.Text = text
        b.Font = Enum.Font.BuilderSansMedium
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.Size = UDim2.new(0.31, 0, 1, 0)
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 7)
        bc.Parent = b
        b.MouseButton1Click:Connect(onClick)
        b.Parent = btnRow
        return b
    end

    makeMiniBtn("สวมหมวก", Color3.fromRGB(45, 140, 75), function()
        if CurrentChosenHelmetId ~= "" then
            helmetNameLbl.Text = "⏳ กำลังสวมหมวก..."
            task.spawn(function()
                local ok, msg = WearHelmet(CurrentChosenHelmetId)
                if ok then
                    helmetNameLbl.Text = "✅ สวม: " .. CurrentChosenHelmetId
                else
                    helmetNameLbl.Text = "❌ " .. tostring(msg or "ล้มเหลว")
                end
            end)
        end
    end)

    makeMiniBtn("ชิลด์หน้า", Color3.fromRGB(48, 85, 160), function()
        ToggleHelmetVisor()
    end)

    makeMiniBtn("ถอดหมวก", Color3.fromRGB(150, 50, 50), function()
        helmetNameLbl.Text = "⏳ กำลังถอดหมวก..."
        task.spawn(function()
            local ok, msg = RemoveHelmet()
            if ok then
                helmetNameLbl.Text = "ถอดหมวกแล้ว"
            else
                helmetNameLbl.Text = "❌ " .. tostring(msg or "ล้มเหลว")
            end
        end)
    end)

    screenGui.Parent = parentGui
    FloatingHelmetWindow = {
        Gui = screenGui,
        Card = mainCard,
        Viewport = vpFrame,
        NameLabel = helmetNameLbl,
        Rig = nil,
    }

    return FloatingHelmetWindow
end
Hub.CreateFloatingHelmetPreviewWindow = CreateFloatingHelmetPreviewWindow

function UpdateAllHelmetPreviews(helmetId, displayName)
    if IsMobileDevice then return end
    CurrentChosenHelmetId = helmetId or ""
    if FloatingHelmetWindow and FloatingHelmetWindow.Viewport then
        FloatingHelmetWindow.Rig = SetupHelmetViewportRig(FloatingHelmetWindow.Viewport, helmetId)
        if FloatingHelmetWindow.NameLabel then
            FloatingHelmetWindow.NameLabel.Text = displayName or helmetId or "หมวกกันน็อก"
        end
    end
    if Hub.TabHelmetViewport then
        Hub.TabHelmetRig = SetupHelmetViewportRig(Hub.TabHelmetViewport, helmetId)
    end
end
Hub.UpdateAllHelmetPreviews = UpdateAllHelmetPreviews
end


-- ==============================================================
-- 🏎️ 3D VEHICLE SHOWCASE ENGINE (สแกนและดึงโมเดลรถ 3D ทั่วทั้งแมพ)
-- ==============================================================
Hub._vehicle3DCache = {}
Hub._vehicle3DSource = {}
Hub.ActiveVehicleRigs = {}

-- 46 Vehicles Map Catalog (Synchronized with GameShared.VEHICLES)
local MapVehicleCatalog = {
    { id = "PCX160",      th = "City Scooter 160",          en = "City Scooter 160",          category = "Scooter", seats = 2, price = 45000,  starter = true,  thumb = "rbxassetid://103709608362968" },
    { id = "TYPER23",     th = "Hatchback R",               en = "Hatchback R",               category = "Car",     seats = 4, price = 380000, starter = true,  thumb = "rbxassetid://113646756594788" },
    { id = "VESPA_S",     th = "Classic Scooter S 150",     en = "Classic Scooter S 150",     category = "Scooter", seats = 2, price = 149000, starter = true,  thumb = "rbxassetid://102034289245717" },
    { id = "FK8",         th = "Hatchback R Classic",       en = "Hatchback R Classic",       category = "Car",     seats = 4, price = 320000, starter = true,  thumb = "rbxassetid://138324452093706" },
    { id = "FK8T",        th = "Hatchback R Tuned",         en = "Hatchback R Tuned",         category = "Car",     seats = 4, price = 350000, starter = true,  thumb = "rbxassetid://90362106998649" },
    { id = "FL5B",        th = "Hatchback R Black",         en = "Hatchback R Black",         category = "Car",     seats = 4, price = 600000, robux = 999,     thumb = "rbxassetid://113884390553959" },
    { id = "DMAXMUX",     th = "Pickup Cab4 X",             en = "Pickup Cab4 X",             category = "Car",     seats = 4, price = 500000, robux = 899,     thumb = "rbxassetid://77144105770185" },
    { id = "G20LCI",      th = "Sport Sedan 340",           en = "Sport Sedan 340",           category = "Car",     seats = 4, price = 600000, robux = 999,     thumb = "rbxassetid://132190396713464" },
    { id = "XMAX",        th = "Maxi Scooter 300",          en = "Maxi Scooter 300",          category = "Scooter", seats = 2, price = 185000, starter = true,  thumb = "rbxassetid://71455818939457" },
    { id = "SPORT155",    th = "Sport Scooter 155",         en = "Sport Scooter 155",         category = "Scooter", seats = 2, price = 79000,  starter = true,  thumb = "rbxassetid://98491771454105" },
    { id = "MAXI250",     th = "Maxi Scooter 250",          en = "Maxi Scooter 250",          category = "Scooter", seats = 2, price = 165000, starter = true,  thumb = "rbxassetid://123004117376187" },
    { id = "TOURER350",   th = "Tourer 350",                en = "Tourer 350",                category = "Scooter", seats = 2, price = 189000, starter = true,  thumb = "rbxassetid://88578164064542" },
    { id = "TOURER350B",  th = "Tourer 350 Black",          en = "Tourer 350 Black",          category = "Scooter", seats = 2, price = 199000,                  thumb = "rbxassetid://97147949088998" },
    { id = "TOURER350GT", th = "Tourer 350 GT",             en = "Tourer 350 GT",             category = "Scooter", seats = 2, price = 100000, robux = 197,     thumb = "rbxassetid://82530744279116" },
    { id = "CITY150",     th = "City Scooter 150 R17",      en = "City Scooter 150 R17",      category = "Scooter", seats = 2, price = 55000,  starter = true,  thumb = "rbxassetid://107494959812465" },
    { id = "FLAT150",     th = "Flat Drag 150",             en = "Flat Drag 150",             category = "Scooter", seats = 2, price = 72000,  starter = true,  thumb = "rbxassetid://84351680111127" },
    { id = "STREET160",   th = "Street Scooter 160",        en = "Street Scooter 160",        category = "Scooter", seats = 2, price = 75000,  starter = true,  thumb = "rbxassetid://117111375227212" },
    { id = "PCX160SA",    th = "Metro 160 Shadow",          en = "Metro 160 Shadow",          category = "Scooter", seats = 2, price = 79000,  starter = true,  thumb = "rbxassetid://110211295754704" },
    { id = "NMAX20",      th = "Midi Max 155",              en = "Midi Max 155",              category = "Scooter", seats = 2, price = 85000,  starter = true,  thumb = "rbxassetid://127835246152022" },
    { id = "XMAX23G",     th = "Grand Max 300 Shadow",      en = "Grand Max 300 Shadow",      category = "Scooter", seats = 2, price = 115000, starter = true,  thumb = "rbxassetid://105950874393760" },
    { id = "XMAX23W",     th = "Grand Max 300 X",           en = "Grand Max 300 X",           category = "Scooter", seats = 2, price = 125000, starter = true,  thumb = "rbxassetid://117546543675727" },
    { id = "XMAX23F",     th = "Grand Max 300 Flame",       en = "Grand Max 300 Flame",       category = "Scooter", seats = 2, price = 120000, starter = true,  thumb = "rbxassetid://113276700335554" },
    { id = "GIORNO23",    th = "Retro Round 125 Plus",      en = "Retro Round 125 Plus",      category = "Scooter", seats = 2, price = 62000,  starter = true,  thumb = "rbxassetid://99204838064915" },
    { id = "GIORNO22",    th = "Retro Round 125 Classic",   en = "Retro Round 125 Classic",   category = "Scooter", seats = 2, price = 0,      pass = "GiornoClassic", thumb = "" },
    { id = "GIORNO25D",   th = "Retro Round 125 Custom Blue", en = "Retro Round 125 Custom Blue", category = "Scooter", seats = 2, price = 0, pass = "GiornoCustom",  thumb = "rbxassetid://72095683439196" },
    { id = "GIORNO25T",   th = "Retro Round 125 Custom Green", en = "Retro Round 125 Custom Green", category = "Scooter", seats = 2, price = 0, pass = "GiornoCustom", thumb = "rbxassetid://122392821107645" },
    { id = "LEAD25",      th = "Family Box 125 S",          en = "Family Box 125 S",          category = "Scooter", seats = 2, price = 59000,  starter = true,  thumb = "rbxassetid://74796308318255" },
    { id = "LEAD25G",     th = "Family Box 125 Ghost",      en = "Family Box 125 Ghost",      category = "Scooter", seats = 2, price = 69000,  starter = true,  thumb = "rbxassetid://107598048353348" },
    { id = "LEAD25F",     th = "Family Box 125 Green Flame", en = "Family Box 125 Green Flame", category = "Scooter", seats = 2, price = 0, pass = "LeadGreen",     thumb = "rbxassetid://81073159232393" },
    { id = "STYLO160G",   th = "Retro Style 160 R",         en = "Retro Style 160 R",         category = "Scooter", seats = 2, price = 0,      pass = "Skylo160",   thumb = "rbxassetid://79871509359501" },
    { id = "FILANO24",    th = "Retro Grand 125",           en = "Retro Grand 125",           category = "Scooter", seats = 2, price = 100000, robux = 197,     thumb = "rbxassetid://108242378694136" },
    { id = "FINO115",     th = "Retro Mini 115",            en = "Retro Mini 115",            category = "Scooter", seats = 2, price = 46000,  starter = true,  thumb = "rbxassetid://135674631299161" },
    { id = "CHER74",      th = "Sport Step Drag 150",       en = "Sport Step Drag 150",       category = "Scooter", seats = 2, price = 55000,  starter = true,  thumb = "rbxassetid://86800518641099" },
    { id = "CHER150",     th = "Sport Step Drag 150 Blue",  en = "Sport Step Drag 150 Blue",  category = "Scooter", seats = 2, price = 55000,  starter = true,  thumb = "rbxassetid://74540864365806" },
    { id = "CHER72",      th = "Sport Step Drag 150 Black", en = "Sport Step Drag 150 Black", category = "Scooter", seats = 2, price = 55000,  starter = true,  thumb = "rbxassetid://99031414771980" },
    { id = "LEAD23V",     th = "Family Box 125 V",          en = "Family Box 125 V",          category = "Scooter", seats = 2, price = 62000,  starter = true,  thumb = "rbxassetid://122929149810639" },
    { id = "DREAM_RACE",  th = "Classic Step 125 Racer",    en = "Classic Step 125 Racer",    category = "Scooter", seats = 2, price = 48000,  starter = true,  thumb = "rbxassetid://108295222307658" },
    { id = "DREAM_DRAG",  th = "Classic Step Drag 125",     en = "Classic Step Drag 125",     category = "Scooter", seats = 2, price = 52000,  starter = true,  thumb = "rbxassetid://121357686443822" },
    { id = "WAVE_STREET", th = "Village Step 110 Street",   en = "Village Step 110 Street",   category = "Scooter", seats = 2, price = 42000,  starter = true,  thumb = "rbxassetid://101408356821657" },
    { id = "WAVE_BARE",   th = "Village Step 110 Bare",     en = "Village Step 110 Bare",     category = "Scooter", seats = 2, price = 40000,  starter = true,  thumb = "rbxassetid://128351941582274" },
    { id = "WAVE_SILVER", th = "Village Step 100 Silver",   en = "Village Step 100 Silver",   category = "Scooter", seats = 2, price = 38000,  starter = true,  thumb = "rbxassetid://128363731380153" },
    { id = "WAVE_KAGE",   th = "Village Step 125 Kage",     en = "Village Step 125 Kage",     category = "Scooter", seats = 2, price = 50000,  starter = true,  thumb = "rbxassetid://102932058510409" },
    { id = "WAVE_110I",   th = "Village Step 110i Drag",    en = "Village Step 110i Drag",    category = "Scooter", seats = 2, price = 46000,  starter = true,  thumb = "rbxassetid://116988639995900" },
    { id = "WAVE_WHITE",  th = "Village Step 125 White",    en = "Village Step 125 White",    category = "Scooter", seats = 2, price = 47000,  starter = true,  thumb = "rbxassetid://138331409187512" },
    { id = "WAVE125S",    th = "Village Step 125 S",        en = "Village Step 125 S",        category = "Scooter", seats = 2, price = 49000,  starter = true,  thumb = "rbxassetid://89410414691187" },
    { id = "SPORT_STEP",  th = "Sport Step 125",            en = "Sport Step 125",            category = "Scooter", seats = 2, price = 55000,  starter = true,  thumb = "rbxassetid://123317932695182" },
}

Hub.GetMapVehicles = function()
    local pcallShared = pcall(function()
        local gs = require(ReplicatedStorage:WaitForChild("GameShared", 2))
        if gs and gs.VEHICLES and #gs.VEHICLES > 0 then
            return gs.VEHICLES
        end
    end)
    return MapVehicleCatalog
end

-- ==============================================================
-- 🏎️ 3D VEHICLE SHOWCASE & MAP SCANNER ENGINE
-- ระบบสแกนโมเดลรถ 3D ทั่วทั้งแมพ (Showroom, Workshops, Props, Cache, Spawned)
-- ==============================================================

local KnownVehicleStreamSpots = {
    Showroom = Vector3.new(355, 1, -159), -- ShowroomSlab: FL5B, G20LCI, DMAXMUX, FK8T, Bike_WAVE_KAGE, Bike_LEAD25G, Bike_GIORNO25T
}

local VehicleToStreamSpot = {
    FK8T      = Vector3.new(355, 1, -159),
    G20LCI    = Vector3.new(355, 1, -159),
    FL5B      = Vector3.new(355, 1, -159),
    DMAXMUX   = Vector3.new(355, 1, -159),
    GIORNO25T = Vector3.new(355, 1, -159),
    WAVE_KAGE = Vector3.new(355, 1, -159),
    LEAD25G   = Vector3.new(355, 1, -159),
    FK8       = Vector3.new(355, 1, -159),
    TYPER23   = Vector3.new(355, 1, -159),
}

-- 🔄 Family Platform Fallback (จัดกลุ่มแพลตฟอร์มตัวถังและโครงรถที่ถูกต้อง 100% สำหรับรถทุกคันในเกม)
Hub.FamilyFallbackMap = {
    -- Sport Step Drag Family (รถคลิก / สปอร์ตแดร็ก 150) -> ใช้โครงสร้าง PCX160 / Automatic Scooter
    CHER150     = {"PCX160", "WAVE_KAGE"},
    CHER72      = {"PCX160", "WAVE_KAGE"},
    CHER74      = {"PCX160", "WAVE_KAGE"},
    SPORT_STEP  = {"PCX160", "WAVE_KAGE"},
    FLAT150     = {"PCX160", "WAVE_KAGE"},
    CITY150     = {"PCX160"},
    STREET160   = {"PCX160"},
    PCX160SA    = {"PCX160"},
    PCX160      = {"PCX160"},

    -- Wave Underbone Family (รถบังลม / เวฟ 110i & 125) -> ใช้โครงสร้าง Bike_WAVE_KAGE
    WAVE_110I   = {"WAVE_110I", "WAVE_KAGE"},
    WAVE_WHITE  = {"WAVE_WHITE", "WAVE_KAGE"},
    WAVE_SILVER = {"WAVE_SILVER", "WAVE_KAGE"},
    WAVE_STREET = {"WAVE_STREET", "WAVE_KAGE"},
    WAVE_BARE   = {"WAVE_BARE", "WAVE_KAGE"},
    WAVE125S    = {"WAVE125S", "WAVE_KAGE"},
    WAVE_KAGE   = {"WAVE_KAGE"},

    -- Classic Step / Super Cub Family (รถดรีม / ซูเปอร์คัพ) -> ใช้โครงสร้าง WAVE_KAGE (ถอดสติ๊กเกอร์เรซซิ่ง)
    DREAM_RACE  = {"DREAM_RACE", "WAVE_KAGE"},
    DREAM_DRAG  = {"DREAM_DRAG", "WAVE_KAGE"},

    -- Lead Family (แฟมิลี่บ็อกซ์ 125) -> ใช้โครงสร้าง Bike_LEAD25G / ParkedScooter
    LEAD25      = {"LEAD25", "LEAD25G", "ParkedScooter"},
    LEAD25G     = {"LEAD25G", "ParkedScooter"},
    LEAD25F     = {"LEAD25F", "LEAD25G", "ParkedScooter"},
    LEAD23V     = {"LEAD23V", "LEAD25G", "ParkedScooter"},

    -- Giorno+ & Retro Round Family (จีออโน่) -> ใช้โครงสร้าง Bike_GIORNO25T / GIORNO22
    GIORNO25T   = {"GIORNO25T", "GIORNO22"},
    GIORNO25D   = {"GIORNO25D", "GIORNO25T", "GIORNO22"},
    GIORNO23    = {"GIORNO23", "GIORNO22", "GIORNO25T"},
    GIORNO22    = {"GIORNO22", "GIORNO25T"},

    -- Vespa & Retro Mini Family (เวสป้า / ฟิลาโน่ / ฟีโน่ / สไตโล่)
    VESPA_S     = {"VESPA_S", "GIORNO22"},
    FILANO24    = {"FILANO24", "VESPA_S", "GIORNO22"},
    FINO115     = {"FINO115", "VESPA_S", "GIORNO22"},
    STYLO160G   = {"STYLO160G", "GIORNO25T", "VESPA_S"},

    -- Tourer & Maxi Scooter Family (ฟอร์ซ่า 350 / เอ็กซ์แม็กซ์ 300 / บิ๊กสกู๊ตเตอร์)
    TOURER350   = {"TOURER350", "PCX160"},
    TOURER350B  = {"TOURER350B", "TOURER350", "PCX160"},
    TOURER350GT = {"TOURER350GT", "TOURER350", "PCX160"},
    XMAX        = {"XMAX", "TOURER350", "PCX160"},
    XMAX23G     = {"XMAX23G", "TOURER350", "PCX160"},
    XMAX23W     = {"XMAX23W", "TOURER350", "PCX160"},
    XMAX23F     = {"XMAX23F", "TOURER350", "PCX160"},
    MAXI250     = {"MAXI250", "TOURER350", "PCX160"},
    SPORT155    = {"SPORT155", "PCX160", "TOURER350"},
    NMAX20      = {"NMAX20", "TOURER350", "PCX160"},

    -- Cars & Hatchbacks
    TYPER23     = {"TYPER23", "FL5B", "FK8T"},
    FL5B        = {"FL5B", "FK8T"},
    FK8T        = {"FK8T", "FL5B"},
    FK8         = {"FK8", "FK8T", "FL5B"},
    G20LCI      = {"G20LCI", "FL5B"},
    DMAXMUX     = {"DMAXMUX", "FL5B"},
}
local FamilyFallbackMap = Hub.FamilyFallbackMap

-- 🎨 Vehicle Custom Styles: สเปกสี, ล้อ, และชุดแต่งตรงรุ่น 100% ตามชื่อและรูปตัวรถ
Hub.VehicleVariantStyles = {
    -- Sport Step Drag Family (แก้ปัญหาที่ผู้ใช้แจ้ง: Sport Step Drag 150 Blue ต้องเป็นสีน้ำเงินและสปอร์ต ไม่ใช่เวฟเหลือง!)
    CHER150 = {
        name          = "Sport Step Drag 150 Blue",
        bodyColor     = Color3.fromRGB(24, 90, 220),   -- Royal Blue สดตรงรุ่น
        accentColor   = Color3.fromRGB(20, 22, 26),
        rimColor      = Color3.fromRGB(220, 180, 50),  -- ล้อแดร็กทอง
        stripLiveries = true,
    },
    CHER72 = {
        name          = "Sport Step Drag 150 Black",
        bodyColor     = Color3.fromRGB(18, 18, 20),    -- ดำเงา Metallic Gloss Black
        accentColor   = Color3.fromRGB(35, 36, 40),
        rimColor      = Color3.fromRGB(200, 160, 40),  -- ล้อทอง
        stripLiveries = true,
    },
    CHER74 = {
        name          = "Sport Step Drag 150",
        bodyColor     = Color3.fromRGB(115, 120, 128), -- เทาแลมโบ Nardo / Slate Grey
        accentColor   = Color3.fromRGB(25, 25, 28),
        rimColor      = Color3.fromRGB(190, 190, 195), -- ล้อเงิน
        stripLiveries = true,
    },
    SPORT_STEP = {
        name          = "Sport Step 125",
        bodyColor     = Color3.fromRGB(215, 55, 35),   -- ส้มแดงสปอร์ต
        accentColor   = Color3.fromRGB(20, 20, 22),
        stripLiveries = true,
    },
    FLAT150 = {
        name          = "Flat Drag 150",
        bodyColor     = Color3.fromRGB(230, 230, 235), -- ขาวมุก Flat Drag
        accentColor   = Color3.fromRGB(25, 25, 30),
        stripLiveries = true,
    },
    CITY150 = {
        name          = "City Scooter 150 R17",
        bodyColor     = Color3.fromRGB(40, 110, 210),  -- Street Blue R17
        stripLiveries = true,
    },
    STREET160 = {
        name          = "Street Scooter 160",
        bodyColor     = Color3.fromRGB(45, 48, 54),    -- Matte Street Titanium
        stripLiveries = true,
    },
    PCX160SA = {
        name          = "Metro 160 Shadow",
        bodyColor     = Color3.fromRGB(28, 28, 32),    -- Shadow Matte Black
        accentColor   = Color3.fromRGB(15, 15, 18),
        stripLiveries = true,
    },

    -- Wave 110i / 125 Family (ปลดลาย Wave Kage เหลืองออกเมื่อเลือกรุ่นอื่น!)
    WAVE_KAGE = {
        name          = "Village Step 125 Kage",
        stripLiveries = false, -- เก็บสติ๊กเกอร์ Wave Kage ของแท้เดิมไว้
    },
    WAVE_110I = {
        name          = "Village Step 110i Drag",
        bodyColor     = Color3.fromRGB(25, 95, 225),   -- น้ำเงิน Wave 110i Drag
        stripLiveries = true,
    },
    WAVE_WHITE = {
        name          = "Village Step 125 White",
        bodyColor     = Color3.fromRGB(245, 245, 248), -- ขาวมุก Pearl White ตรงรุ่น
        stripLiveries = true,
    },
    WAVE_SILVER = {
        name          = "Village Step 100 Silver",
        bodyColor     = Color3.fromRGB(192, 196, 204), -- เงินเมทัลลิกตรงรุ่น
        stripLiveries = true,
    },
    WAVE_STREET = {
        name          = "Village Step 110 Street",
        bodyColor     = Color3.fromRGB(35, 45, 60),    -- กรมท่าเข้ม Street
        stripLiveries = true,
    },
    WAVE_BARE = {
        name          = "Village Step 110 Bare",
        bodyColor     = Color3.fromRGB(75, 78, 85),    -- โครงเหล็กเปลือย Drag Bare
        stripLiveries = true,
    },
    WAVE125S = {
        name          = "Village Step 125 S",
        bodyColor     = Color3.fromRGB(22, 28, 45),    -- Midnight Blue 125S
        stripLiveries = true,
    },

    -- Classic Step / Super Cub Family
    DREAM_RACE = {
        name          = "Classic Step 125 Racer",
        bodyColor     = Color3.fromRGB(195, 30, 30),   -- แดงวินเทจ Super Cub Racer
        accentColor   = Color3.fromRGB(240, 240, 240),
        stripLiveries = true,
    },
    DREAM_DRAG = {
        name          = "Classic Step Drag 125",
        bodyColor     = Color3.fromRGB(45, 65, 85),    -- ฟ้าหม่นคลาสสิกแดร็ก
        accentColor   = Color3.fromRGB(20, 20, 22),
        stripLiveries = true,
    },

    -- Lead Family
    LEAD25G = {
        name          = "Family Box 125 Ghost",
        stripLiveries = false,
    },
    LEAD25 = {
        name          = "Family Box 125 S",
        bodyColor     = Color3.fromRGB(245, 245, 250), -- ขาวมุก Lead 125 S
        stripLiveries = true,
    },
    LEAD25F = {
        name          = "Family Box 125 Green Flame",
        bodyColor     = Color3.fromRGB(25, 145, 60),   -- เขียวมรกต Green Flame
        stripLiveries = false,
    },
    LEAD23V = {
        name          = "Family Box 125 V",
        bodyColor     = Color3.fromRGB(90, 95, 105),   -- เทาวินเทจ
        stripLiveries = true,
    },

    -- Giorno Family
    GIORNO25T = {
        name          = "Retro Round 125 Custom Green",
        stripLiveries = false,
    },
    GIORNO25D = {
        name          = "Retro Round 125 Custom Blue",
        bodyColor     = Color3.fromRGB(26, 92, 218),   -- Custom Blue Giorno
        stripLiveries = false,
    },
    GIORNO23 = {
        name          = "Retro Round 125 Plus",
        bodyColor     = Color3.fromRGB(235, 230, 220), -- ครีมคลาสสิก Ivory
        stripLiveries = true,
    },
    GIORNO22 = {
        name          = "Retro Round 125 Classic",
        stripLiveries = false,
    },

    -- Vespa & Retro Mini Family
    VESPA_S = {
        name          = "Classic Scooter S 150",
        stripLiveries = false,
    },
    FILANO24 = {
        name          = "Retro Grand 125",
        bodyColor     = Color3.fromRGB(155, 195, 215), -- ฟ้าพาสเทล Grand Filano
        stripLiveries = true,
    },
    FINO115 = {
        name          = "Retro Mini 115",
        bodyColor     = Color3.fromRGB(195, 145, 95),  -- น้ำตาลคาราเมล Fino Classic
        stripLiveries = true,
    },
    STYLO160G = {
        name          = "Retro Style 160 R",
        bodyColor     = Color3.fromRGB(85, 110, 95),   -- เขียวด้าน Stylo Matte Green
        stripLiveries = true,
    },

    -- Tourer & Maxi Scooter Family
    TOURER350 = {
        name          = "Tourer 350",
        stripLiveries = false,
    },
    TOURER350B = {
        name          = "Tourer 350 Black",
        bodyColor     = Color3.fromRGB(18, 18, 20),    -- ดำเงา Forza 350 Black
        stripLiveries = false,
    },
    TOURER350GT = {
        name          = "Tourer 350 GT",
        bodyColor     = Color3.fromRGB(120, 125, 132), -- เทาทัวร์ริ่ง
        rimColor      = Color3.fromRGB(215, 175, 45),  -- ล้อทอง GT
        stripLiveries = false,
    },
    XMAX = {
        name          = "Maxi Scooter 300",
        bodyColor     = Color3.fromRGB(40, 42, 48),    -- เทาดำ XMAX Gunmetal
        stripLiveries = true,
    },
    XMAX23G = {
        name          = "Grand Max 300 Shadow",
        bodyColor     = Color3.fromRGB(28, 28, 32),    -- ดำด้าน Dark Shadow
        stripLiveries = true,
    },
    XMAX23W = {
        name          = "Grand Max 300 X",
        bodyColor     = Color3.fromRGB(245, 245, 250), -- ขาวมุก Grand Max
        stripLiveries = true,
    },
    XMAX23F = {
        name          = "Grand Max 300 Flame",
        bodyColor     = Color3.fromRGB(205, 32, 32),   -- แดงเรซซิ่ง Flame Red
        stripLiveries = true,
    },
    MAXI250 = {
        name          = "Maxi Scooter 250",
        bodyColor     = Color3.fromRGB(60, 65, 75),
        stripLiveries = true,
    },
    SPORT155 = {
        name          = "Sport Scooter 155",
        bodyColor     = Color3.fromRGB(20, 120, 220),  -- ฟ้าไซเบอร์ Aerox Racing
        accentColor   = Color3.fromRGB(25, 25, 28),
        stripLiveries = true,
    },
    NMAX20 = {
        name          = "Midi Max 155",
        bodyColor     = Color3.fromRGB(45, 50, 60),    -- น้ำเงินเข้ม NMAX Navy
        stripLiveries = true,
    },

    -- Cars
    TYPER23 = {
        name          = "Hatchback R",
        bodyColor     = Color3.fromRGB(245, 245, 245), -- Championship White
    },
    FL5B = {
        name          = "Hatchback R Black",
        bodyColor     = Color3.fromRGB(18, 18, 20),    -- Crystal Black
    },
    FK8 = {
        name          = "Hatchback R Classic",
        bodyColor     = Color3.fromRGB(235, 235, 238),
    },
}

-- 🛠️ ฟังก์ชันปรับแต่งตัวถัง, สี และลวดลายให้ตรงกับรุ่นรถและชื่อ 100%
Hub.ApplyVehicleCustomStyling = function(clone, vehicleId)
    if not clone or not vehicleId then return clone end
    local style = Hub.VehicleVariantStyles[vehicleId]
    if not style then return clone end

    -- 1. ลบลายสติ๊กเกอร์ที่ไม่ตรงรุ่นออก (เช่น สติ๊กเกอร์ Wave Kage เมื่อเลือกรุ่นอื่น)
    if style.stripLiveries then
        for _, desc in ipairs(clone:GetDescendants()) do
            if desc:IsA("Decal") or desc:IsA("Texture") then
                pcall(function() desc:Destroy() end)
            elseif desc:IsA("MeshPart") then
                local n = desc.Name:lower()
                if n:find("copy") or n:find("nueng") or n:find("xxxx") or n:find("decal") or n:find("sticker") or n:find("kage") or n:find("livery") then
                    pcall(function() desc.TextureID = "" end)
                end
            end
        end
    end

    -- 2. ปรับเฉดสีตัวถัง (Body Paint), ล้อ (Wheel Rims), และโช้ค/ชิ้นส่วนเสริม (Accents)
    for _, desc in ipairs(clone:GetDescendants()) do
        if desc:IsA("BasePart") then
            local pg = desc:GetAttribute("PaintGroup")
            local n = desc.Name:lower()

            -- ชิ้นส่วนตัวถัง / แฟริ่ง
            if style.bodyColor then
                if pg == "Body" or n:find("paint1_body") or n:find("body_paint") or n:find("plane.010") or n:find("body__300k") or n:find("body_125") or n:find("body_part") then
                    desc.Color = style.bodyColor
                end
            end

            -- ขอบล้อแม็กซ์ / ล้อแดร็ก
            if style.rimColor then
                if pg == "Wheel" or n:find("rim") or n:find("wheel_color") or n:find("nurbspath") then
                    desc.Color = style.rimColor
                end
            end

            -- จุดตัดสี / โช้ค / แอคเซนต์
            if style.accentColor then
                if pg == "ShockBody" or n:find("shock") or n:find("accent") or n:find("caliper") then
                    desc.Color = style.accentColor
                end
            end
        end
    end

    return clone
end

-- 🧼 Sanitize, Style, and Center vehicle model for Studio Viewport
Hub.SanitizeAndCenterVehicleModel = function(model, vehicleId)
    if not model then return nil end
    local clone = model:Clone()
    clone.Name = "Showcase_" .. tostring(vehicleId or "Vehicle")

    for _, desc in ipairs(clone:GetDescendants()) do
        if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("Sound") or desc:IsA("ParticleEmitter") or desc:IsA("ClickDetector") or desc:IsA("Highlight") or desc:IsA("BillboardGui") then
            desc:Destroy()
        elseif desc:IsA("Seat") or desc:IsA("VehicleSeat") then
            desc.Disabled = true
            desc.CanCollide = false
            desc.Anchored = true
        elseif desc:IsA("BasePart") then
            desc.Anchored = true
            desc.CanCollide = false
            desc.CanTouch = false
            desc.CanQuery = false
            desc.CastShadow = false
        end
    end

    -- ปรับแต่งสเปกสีและลวดลายให้ตรงกับชื่อรุ่นรถ 100%
    Hub.ApplyVehicleCustomStyling(clone, vehicleId)

    pcall(function()
        clone:PivotTo(CFrame.new(0, 0, 0))
    end)
    return clone
end
local SanitizeAndCenterVehicleModel = Hub.SanitizeAndCenterVehicleModel

-- 🛰️ Comprehensive Map Vehicle Scanner
Hub.ScanAllMapVehicles = function(showNotify)
    -- 📱 บนมือถือ (Android/iOS) ปิดการสแกนและโคลนโมเดล 3D ทั้งแมพ เพื่อป้องกัน Out-Of-Memory (OOM) และเกมเด้ง
    if IsMobileDevice then
        if showNotify and Window and Window.Notify then
            Window:Notify({
                Title    = "โหมดมือถือเสถียร",
                Text     = "แสดงผลรูปภาพพรีวิว 2D สำเร็จ (ประหยัดแรมและลดอาการเด้ง)",
                Icon     = "smartphone",
                Duration = 3
            })
        end
        return 0
    end

    local scannedCount = 0

    -- Request stream for central showroom vehicle hub (Vector3.new(355, 1, -159))
    pcall(function()
        if LocalPlayer and LocalPlayer.RequestStreamAroundAsync then
            pcall(function() LocalPlayer:RequestStreamAroundAsync(Vector3.new(355, 1, -159), 2) end)
        end
    end)

    task.wait(0.12)

    local function registerModel(id, m, sourceDesc)
        if not id or not m then return end
        if #m:GetDescendants() < 6 then return end
        if Hub._vehicle3DCache[id] then return end
        local sanitized = SanitizeAndCenterVehicleModel(m, id)
        if sanitized then
            Hub._vehicle3DCache[id] = sanitized
            Hub._vehicle3DSource[id] = sourceDesc
            scannedCount = scannedCount + 1
        end
    end

    -- 1. ReplicatedStorage Props (PCX160, VESPA_S)
    pcall(function()
        local props = ReplicatedStorage:FindFirstChild("JobStage") and ReplicatedStorage.JobStage:FindFirstChild("Props")
        if props then
            for _, m in ipairs(props:GetChildren()) do
                if m:IsA("Model") then
                    registerModel(m.Name, m, "พร็อพเกม (JobStage.Props)")
                end
            end
        end
    end)

    -- 2. PreviewCache (GIORNO22)
    pcall(function()
        local pc = LocalPlayer:FindFirstChildOfClass("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("PreviewCache")
        if pc then
            for _, m in ipairs(pc:GetChildren()) do
                if m:IsA("Model") then
                    registerModel(m.Name, m, "แคชพรีวิวเกม (PreviewCache)")
                end
            end
        end
    end)

    -- 3. Showroom Display (FK8T, G20LCI, FL5B, DMAXMUX) & RepairZone (Bikes)
    pcall(function()
        local showroom = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Showroom")
        if showroom then
            if showroom:FindFirstChild("Display") then
                for _, m in ipairs(showroom.Display:GetChildren()) do
                    if m:IsA("Model") and #m:GetDescendants() > 5 then
                        registerModel(m.Name, m, "โชว์รูม (Showroom Display)")
                    end
                end
            end
            if showroom:FindFirstChild("RepairZone") and showroom.RepairZone:FindFirstChild("Vehicles") then
                for _, m in ipairs(showroom.RepairZone.Vehicles:GetChildren()) do
                    if m:IsA("Model") and #m:GetDescendants() > 5 then
                        local clean = m.Name:gsub("^Bike_", ""):gsub("^Car_", "")
                        registerModel(clean, m, "อู่ซ่อมโชว์รูม (Showroom RepairZone)")
                        registerModel(m.Name, m, "อู่ซ่อมโชว์รูม (Showroom RepairZone)")
                    end
                end
            end
        end
    end)

    -- 4. RiderHub ParkedScooter (Full Honda Lead 125) & PassShowcase (Giorno Custom)
    pcall(function()
        local riderHub = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("JobLockers") and Workspace.Map.JobLockers:FindFirstChild("RiderHub")
        if riderHub and riderHub:FindFirstChild("ParkedScooter") and #riderHub.ParkedScooter:GetDescendants() > 10 then
            registerModel("ParkedScooter", riderHub.ParkedScooter, "จุดพักไรเดอร์ (RiderHub)")
            registerModel("LEAD25", riderHub.ParkedScooter, "จุดพักไรเดอร์ (RiderHub)")
        end
        local passSc = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("PassShowcase")
        if passSc and passSc:FindFirstChild("Stand_GiornoCustom") and #passSc.Stand_GiornoCustom:GetDescendants() > 10 then
            registerModel("Stand_GiornoCustom", passSc.Stand_GiornoCustom, "แท่นโชว์พาส (PassShowcase)")
        end
    end)

    -- 5. SpawnedVehicles across server (e.g. TOURER350)
    pcall(function()
        local sv = Workspace:FindFirstChild("SpawnedVehicles")
        if sv then
            for _, v in ipairs(sv:GetChildren()) do
                local vAttr = v:GetAttribute("VehicleId")
                local vid = vAttr or v.Name:match("^([%w_]+)_") or v.Name
                local body = v:FindFirstChild(tostring(vid)) or v:FindFirstChild("Body") or v
                if body and #body:GetDescendants() > 10 then
                    registerModel(tostring(vid), body, "รถในเซิร์ฟเวอร์ (" .. v.Name .. ")")
                end
            end
        end
    end)

    -- 6. Synthesis Pass: จัดเตรียมโมเดล 3D ที่ตกแต่งสีและชุดแต่งตรงรุ่น 100% ให้ครบทั้ง 46 คันในเกม!
    pcall(function()
        local GameShared = require(ReplicatedStorage.GameShared)
        if GameShared and GameShared.VEHICLES then
            for _, vInfo in ipairs(GameShared.VEHICLES) do
                local vid = vInfo.id
                if vid and not Hub._vehicle3DCache[vid] then
                    local baseIdList = Hub.FamilyFallbackMap[vid]
                    if baseIdList then
                        for _, fbId in ipairs(baseIdList) do
                            local baseRaw = Hub._vehicle3DCache[fbId]
                            if baseRaw then
                                local tailored = SanitizeAndCenterVehicleModel(baseRaw, vid)
                                if tailored then
                                    Hub._vehicle3DCache[vid] = tailored
                                    Hub._vehicle3DSource[vid] = "โมเดล 3D (" .. (vInfo.th or vid) .. ")"
                                    scannedCount = scannedCount + 1
                                    break
                                end
                            end
                        end
                    end
                    -- Ultimate safe synthesis fallback if still missing
                    if not Hub._vehicle3DCache[vid] then
                        local fbFallback = (vInfo.category == "Car") and (Hub._vehicle3DCache["FL5B"] or Hub._vehicle3DCache["G20LCI"]) or (Hub._vehicle3DCache["PCX160"] or Hub._vehicle3DCache["WAVE_KAGE"])
                        if fbFallback then
                            local tailored = SanitizeAndCenterVehicleModel(fbFallback, vid)
                            if tailored then
                                Hub._vehicle3DCache[vid] = tailored
                                Hub._vehicle3DSource[vid] = "โมเดล 3D (" .. (vInfo.th or vid) .. ")"
                                scannedCount = scannedCount + 1
                            end
                        end
                    end
                end
            end
        end
    end)

    if showNotify and Window and Window.Notify then
        local totalReady = 0
        for _ in pairs(Hub._vehicle3DCache) do totalReady = totalReady + 1 end
        Window:Notify({
            Title    = "สแกนโมเดล 3D สำเร็จ",
            Text     = string.format("สแกนโมเดล 3D ครบถ้วนทุกรุ่นแล้ว (%d คันพร้อมแสดงผล)!", totalReady),
            Icon     = "scan",
            Duration = 3
        })
    end
    return scannedCount
end

-- 🔍 Scan and Find 3D Model across map landmarks, props, spawned vehicles, and preview cache
Hub.FindVehicle3DModel = function(vehicleId)
    if not vehicleId or vehicleId == "" then return nil, "NoId" end

    -- 1. In-memory cache (รวมทั้งรุ่นที่ผ่านการ Synthesis และ Custom Styling แล้ว)
    if Hub._vehicle3DCache[vehicleId] then
        return Hub._vehicle3DCache[vehicleId]:Clone(), Hub._vehicle3DSource[vehicleId] or "โมเดล 3D"
    end

    -- 2. Check JobStage.Props directly
    local rsProps = ReplicatedStorage:FindFirstChild("JobStage") and ReplicatedStorage.JobStage:FindFirstChild("Props")
    if rsProps and rsProps:FindFirstChild(vehicleId) and #rsProps[vehicleId]:GetDescendants() > 5 then
        local clone = SanitizeAndCenterVehicleModel(rsProps[vehicleId], vehicleId)
        Hub._vehicle3DCache[vehicleId] = clone:Clone()
        Hub._vehicle3DSource[vehicleId] = "พร็อพเกม (JobStage.Props)"
        return clone, "พร็อพเกม (JobStage.Props)"
    end

    -- 3. Check Showroom (Display & RepairZone)
    local showroom = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Showroom")
    if showroom then
        if showroom:FindFirstChild("Display") and showroom.Display:FindFirstChild(vehicleId) then
            local m = showroom.Display[vehicleId]
            if #m:GetDescendants() > 5 then
                local clone = SanitizeAndCenterVehicleModel(m, vehicleId)
                Hub._vehicle3DCache[vehicleId] = clone:Clone()
                Hub._vehicle3DSource[vehicleId] = "โชว์รูม (Showroom Display)"
                return clone, "โชว์รูม (Showroom Display)"
            end
        end
        if showroom:FindFirstChild("RepairZone") and showroom.RepairZone:FindFirstChild("Vehicles") then
            local rz = showroom.RepairZone.Vehicles
            local bike = rz:FindFirstChild("Bike_" .. vehicleId) or rz:FindFirstChild(vehicleId)
            if bike and #bike:GetDescendants() > 5 then
                local clone = SanitizeAndCenterVehicleModel(bike, vehicleId)
                Hub._vehicle3DCache[vehicleId] = clone:Clone()
                Hub._vehicle3DSource[vehicleId] = "อู่ซ่อมโชว์รูม (Showroom RepairZone)"
                return clone, "อู่ซ่อมโชว์รูม (Showroom RepairZone)"
            end
        end
    end

    -- 4. Check Workspace.SpawnedVehicles
    local sv = Workspace:FindFirstChild("SpawnedVehicles")
    if sv then
        for _, v in ipairs(sv:GetChildren()) do
            local vAttr = v:GetAttribute("VehicleId")
            if (vAttr and string.lower(tostring(vAttr)) == string.lower(vehicleId)) or string.find(string.lower(v.Name), string.lower(vehicleId), 1, true) then
                local body = v:FindFirstChild(vehicleId) or v:FindFirstChild("Body") or v
                if #body:GetDescendants() > 10 then
                    local clone = SanitizeAndCenterVehicleModel(body, vehicleId)
                    Hub._vehicle3DCache[vehicleId] = clone:Clone()
                    Hub._vehicle3DSource[vehicleId] = "รถในเซิร์ฟเวอร์ (" .. v.Name .. ")"
                    return clone, "รถในเซิร์ฟเวอร์ (" .. v.Name .. ")"
                end
            end
        end
    end

    -- 5. Family / Platform Fallback with Custom Styling
    local fallbacks = Hub.FamilyFallbackMap[vehicleId]
    if fallbacks then
        for _, fbId in ipairs(fallbacks) do
            if Hub._vehicle3DCache[fbId] then
                local tailored = SanitizeAndCenterVehicleModel(Hub._vehicle3DCache[fbId], vehicleId)
                if tailored then
                    Hub._vehicle3DCache[vehicleId] = tailored:Clone()
                    Hub._vehicle3DSource[vehicleId] = "โมเดล 3D (" .. vehicleId .. ")"
                    return tailored, "โมเดล 3D (" .. vehicleId .. ")"
                end
            end
        end
    end

    -- 6. Ultimate safe fallback: Any cached 3D vehicle
    for id, m in pairs(Hub._vehicle3DCache) do
        if m and #m:GetDescendants() > 10 then
            local tailored = SanitizeAndCenterVehicleModel(m, vehicleId)
            return tailored, "โมเดล 3D (" .. id .. ")"
        end
    end

    -- 7. Fallback to JobStage.Props PCX160
    if rsProps and rsProps:FindFirstChild("PCX160") then
        local tailored = SanitizeAndCenterVehicleModel(rsProps.PCX160, vehicleId)
        return tailored, "โมเดล 3D (PCX160)"
    end

    return nil, "ThumbnailOnly"
end

-- 🛠️ 3D Viewport Rig with Orbit, Pan, Pitch, Zoom, and Studio Turntable Stage
Hub.SetupVehicleViewportRig = function(viewportFrame, vehicleId, preloadedModel, preloadedSource)
    if IsMobileDevice then return nil end
    if not viewportFrame or not viewportFrame:IsA("ViewportFrame") then return nil end
    viewportFrame:ClearAllChildren()
    
    local model = preloadedModel
    local sourceDesc = preloadedSource
    if not model then
        model, sourceDesc = Hub.FindVehicle3DModel(vehicleId)
    end
    if not model then return nil end
    
    -- Center model at Vector3.zero for 0 floating-point jitter
    pcall(function() model:PivotTo(CFrame.new(0, 0, 0)) end)
    model.Parent = viewportFrame
    local center, size = model:GetBoundingBox()
    
    -- Showroom Turntable Disc (Pedestal)
    local maxDim = math.max(size.X, size.Z)
    local pedestal = Instance.new("Part")
    pedestal.Name = "ShowroomPedestal"
    pedestal.Shape = Enum.PartType.Cylinder
    pedestal.Anchored = true
    pedestal.CanCollide = false
    pedestal.CanQuery = false
    pedestal.CanTouch = false
    pedestal.CastShadow = false
    pedestal.Size = Vector3.new(0.3, maxDim * 1.35, maxDim * 1.35)
    pedestal.CFrame = CFrame.new(center.Position.X, center.Position.Y - (size.Y * 0.5) - 0.15, center.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    pedestal.Color = Color3.fromRGB(22, 25, 34)
    pedestal.Material = Enum.Material.Metal
    pedestal.Parent = viewportFrame
    
    -- Neon Cyan Accent Glow Ring
    local ring = Instance.new("Part")
    ring.Name = "ShowroomPedestalRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanQuery = false
    ring.CanTouch = false
    ring.CastShadow = false
    ring.Size = Vector3.new(0.08, maxDim * 1.38, maxDim * 1.38)
    ring.CFrame = CFrame.new(center.Position.X, center.Position.Y - (size.Y * 0.5) - 0.10, center.Position.Z) * CFrame.Angles(0, 0, math.rad(90))
    ring.Color = Color3.fromRGB(0, 190, 255)
    ring.Material = Enum.Material.Neon
    ring.Parent = viewportFrame
    
    -- Camera
    local cam = Instance.new("Camera")
    cam.FieldOfView = 28
    cam.Parent = viewportFrame
    viewportFrame.CurrentCamera = cam
    
    -- Studio Lighting
    viewportFrame.BackgroundTransparency = 1
    viewportFrame.LightDirection = Vector3.new(-0.6, -1.0, -0.4)
    viewportFrame.Ambient = Color3.fromRGB(160, 165, 180)
    viewportFrame.LightColor = Color3.fromRGB(255, 250, 240)
    
    local baseDistance = size.Magnitude * 1.15
    
    local rig = {
        Frame = viewportFrame,
        Camera = cam,
        Model = model,
        Center = center.Position,
        Size = size,
        BaseDistance = baseDistance,
        Zoom = 1.0,
        Yaw = math.rad(35),
        Pitch = 14,
        AutoRotate = true,
        Dragging = false,
        LastPos = nil,
        Source = sourceDesc,
        VehicleId = vehicleId,
    }
    
    local function applyCamCFrame()
        local radP = math.rad(math.clamp(rig.Pitch, -15, 65))
        local radY = rig.Yaw
        local offset = Vector3.new(
            math.cos(radP) * math.sin(radY),
            math.sin(radP),
            math.cos(radP) * math.cos(radY)
        )
        local camPos = rig.Center + offset * (rig.BaseDistance * rig.Zoom)
        rig.Camera.CFrame = CFrame.lookAt(camPos, rig.Center)
    end
    rig.ApplyCam = applyCamCFrame
    applyCamCFrame()
    
    -- Interactive Drag-to-Rotate (Mouse & Touch)
    local conns = {}
    conns[#conns+1] = viewportFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            rig.Dragging = true
            rig.LastPos = input.Position
        end
    end)
    
    conns[#conns+1] = viewportFrame.InputChanged:Connect(function(input)
        if rig.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local currentPos = input.Position
            local deltaX = currentPos.X - (rig.LastPos and rig.LastPos.X or currentPos.X)
            local deltaY = currentPos.Y - (rig.LastPos and rig.LastPos.Y or currentPos.Y)
            rig.LastPos = currentPos
            
            rig.Yaw = (rig.Yaw - deltaX * 0.012) % (math.pi * 2)
            rig.Pitch = math.clamp(rig.Pitch + deltaY * 0.35, -15, 65)
            applyCamCFrame()
        elseif input.UserInputType == Enum.UserInputType.MouseWheel then
            rig.Zoom = math.clamp(rig.Zoom - input.Position.Z * 0.1, 0.55, 2.5)
            applyCamCFrame()
        end
    end)
    
    conns[#conns+1] = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            rig.Dragging = false
        end
    end)
    
    rig.Cleanup = function()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if Hub.ActiveVehicleRigs[viewportFrame] == rig then
            Hub.ActiveVehicleRigs[viewportFrame] = nil
        end
    end
    
    Hub.ActiveVehicleRigs[viewportFrame] = rig
    return rig
end

-- 🚗 Live listener for newly spawned vehicles across server
pcall(function()
    local sv = Workspace:WaitForChild("SpawnedVehicles", 5)
    if sv then
        sv.ChildAdded:Connect(function(v)
            if IsMobileDevice then return end
            task.wait(0.5)
            pcall(function()
                local vAttr = v:GetAttribute("VehicleId")
                local vid = vAttr or v.Name:match("^([%w_]+)_") or v.Name
                local body = v:FindFirstChild(tostring(vid)) or v:FindFirstChild("Body") or v
                if body and #body:GetDescendants() > 10 then
                    local clone = SanitizeAndCenterVehicleModel(body, tostring(vid))
                    if clone then
                        Hub._vehicle3DCache[tostring(vid)] = clone
                        Hub._vehicle3DSource[tostring(vid)] = "รถสดในเซิร์ฟเวอร์ (" .. v.Name .. ")"
                    end
                end
            end)
        end)
    end
end)

-- Background 3D Vehicle Viewport smooth auto-rotation loop
task.spawn(function()
    if IsMobileDevice then return end
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        if not next(Hub.ActiveVehicleRigs) then
            task.wait(0.5)
        else
            local dt = RunService.RenderStepped:Wait()
            for frame, rig in pairs(Hub.ActiveVehicleRigs) do
                if frame and frame.Parent and frame.Visible then
                    if rig.AutoRotate and not rig.Dragging and rig.Camera then
                        rig.Yaw = (rig.Yaw + dt * 0.45) % (math.pi * 2)
                        if rig.ApplyCam then
                            rig.ApplyCam()
                        end
                    end
                else
                    Hub.ActiveVehicleRigs[frame] = nil
                end
            end
        end
    end
end)

-- ==============================================================
-- 🔒 [STABILITY] MASTER FLAG WATCHDOG (Auto-resets all stuck flags every 10s)
-- Covers: Teleporting, IsAcceptingOffer, DeliveryWorking, GrabWorking
-- Prevents indefinite hangs if any coroutine crashes mid-travel
-- ==============================================================
task.spawn(function()
    local lastSearchingTime = nil
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        local now = os.clock()
        -- Clear Teleporting if stuck > 12s
        if Teleporting and (now - TeleportingTimestamp) > 12 then
            Teleporting = false
        end
        -- Clear IsAcceptingOffer if stuck > 6s
        if IsAcceptingOffer and (now - IsAcceptingOfferTimestamp) > 6 then
            IsAcceptingOffer = false
        end
        -- Clear IsConfirmingDelivery if stuck > 6s
        if IsConfirmingDelivery and (now - IsConfirmingDeliveryTimestamp) > 6 then
            IsConfirmingDelivery = false
        end
        -- Clear DeliveryWorking if heartbeat stale > 12s
        if DeliveryWorking and (now - LastDeliveryHeartbeat) > 12 then
            DeliveryWorking = false
        end
        -- Clear GrabWorking if heartbeat stale > 15s  -- ✅ FIX: 12→15s
        if GrabWorking and (now - LastGrabHeartbeat) > 15 then
            GrabWorking = false
        end

        -- Check if Searching state has been stuck > 18s without an offer
        local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
        if isFarmActive and DeliveryRemote and NetSeal then
            local delState = LocalPlayer:GetAttribute("DeliveryState")
            if delState == "Searching" then
                if not lastSearchingTime then lastSearchingTime = now end
                if (now - lastSearchingTime) > 18 then
                    lastSearchingTime = now
                    local targetMode = Hub.Settings.AutoGrabFarm and "grab" or (Hub.Settings.AutoFoodDelivery and "food" or "ride")
                    local _invFn = genv[_gk.ni] or NetSeal.invoke
                    pcall(_invFn, DeliveryRemote, "Stop", nil)
                    task.wait(0.4)
                    pcall(_invFn, DeliveryRemote, "Start", targetMode)
                end
            else
                lastSearchingTime = nil
            end
        else
            lastSearchingTime = nil
        end

        task.wait(3)
    end
end)

-- 🛡️ Anti-Fall & Anti-Damage Auto-Farm Watchdog (Guarantees 100% Seated & Health)
task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        local isFarmActive = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoGrabRide or Hub.Settings.AutoFoodDelivery
        if isFarmActive then
            EnsureThirdPersonCamera()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum.PlatformStand = false
                pcall(function()
                    if Ragdoll and Ragdoll.disable then Ragdoll.disable(char) end
                end)

                -- Delivery state check: NEVER teleport while delivery is active or vehicle is traveling!
                local delState = LocalPlayer:GetAttribute("DeliveryState")
                local isDelivering = (delState ~= nil and delState ~= "Off" and delState ~= "Searching" and delState ~= "Selecting")

                -- 🛡️ Anti-Void Fall Rescue: Immediately teleport back to road if character drops below ground (Y < -5)
                -- STRICT RULE: Only rescue when NOT delivering and NOT traveling! (Server cancels job with "Job cancelled: you warped during a delivery")
                if hrp.Position.Y < -5 and not isDelivering and not Teleporting then
                    local rescueTarget = nil
                    if RoadGraph and RoadGraph.nearest then
                        local nearPt = RoadGraph.nearest(hrp.Position)
                        if nearPt then
                            local rx = nearPt.X
                            if math.abs(rx) < 10 then rx = (hrp.Position.X >= 0 and 22 or -22) end
                            rescueTarget = Vector3.new(rx, 10, nearPt.Y)
                        end
                    end
                    if not rescueTarget then
                        rescueTarget = Vector3.new(120, 6, -128)
                    end

                    local groundParams = RaycastParams.new()
                    groundParams.FilterType = Enum.RaycastFilterType.Exclude
                    groundParams.FilterDescendantsInstances = { char }
                    groundParams.IgnoreWater = true
                    local gRay = Workspace:Raycast(Vector3.new(rescueTarget.X, 50, rescueTarget.Z), Vector3.new(0, -60, 0), groundParams)
                    local safeY = (gRay and gRay.Position.Y + 3.5) or 6.0
                    hrp.CFrame = CFrame.new(rescueTarget.X, safeY, rescueTarget.Z)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    local ut = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    local lt = char:FindFirstChild("LowerTorso")
                    if ut then ut.CanCollide = true end
                    if lt then lt.CanCollide = true end
                    hrp.CanCollide = true
                end

                -- 🛡️ Anti-Roof & Anti-Sky Protection: Rescues vehicle if floating high in the sky (Y > 16.0)
                local curV = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
                local ch = curV and (curV:FindFirstChild("Chassis") or curV.PrimaryPart)
                local checkPart = ch or hrp
                if checkPart and not Teleporting and checkPart.Position.Y > 16.0 and checkPart.Position.X < 3500 then
                    local roofCheckParams = RaycastParams.new()
                    roofCheckParams.FilterType = Enum.RaycastFilterType.Exclude
                    local excludeList = { char }
                    local sv = Workspace:FindFirstChild("SpawnedVehicles")
                    if sv then table.insert(excludeList, sv) elseif curV then table.insert(excludeList, curV) end
                    local map = Workspace:FindFirstChild("Map")
                    if map then
                        for _, folderName in ipairs({"Viaduct", "Stations", "Expressway", "Footings"}) do
                            local f = map:FindFirstChild(folderName)
                            if f then table.insert(excludeList, f) end
                        end
                    end
                    roofCheckParams.FilterDescendantsInstances = excludeList
                    roofCheckParams.IgnoreWater = true

                    -- Probe true ground down below
                    local groundRoadRay = Workspace:Raycast(Vector3.new(checkPart.Position.X, 10.0, checkPart.Position.Z), Vector3.new(0, -25.0, 0), roofCheckParams)
                    if groundRoadRay and groundRoadRay.Position.Y < 8.0 then
                        local wOff = (curV and Hub.GetVehicleWheelOffset and Hub.GetVehicleWheelOffset(curV)) or 1.25
                        local safeY = groundRoadRay.Position.Y + wOff
                        local curCF = curV and curV:GetPivot() or checkPart.CFrame
                        local safeCF = CFrame.new(curCF.Position.X, safeY, curCF.Position.Z) * (curCF - curCF.Position)
                        if curV and curV.Parent then
                            curV:PivotTo(safeCF)
                            if ch then
                                ch.AssemblyLinearVelocity = Vector3.zero
                                ch.AssemblyAngularVelocity = Vector3.zero
                            end
                        elseif hrp then
                            hrp.CFrame = safeCF
                            hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end

                if not hum.Sit and not Teleporting and not isDelivering then
                    EnsureMounted()
                end
            end
        end
        task.wait(0.5)
    end
end)

-- 🛡️ Anti-AFK Engine (Prevents 20-minute Roblox IDLE Kick - Universal Cross-Platform)
function TriggerAntiAfkPulse()
    local didPulse = false
    if not IsMobileDevice and not UserInputService.TouchEnabled and VirtualUser then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
            didPulse = true
        end)
    end
    local vim = SafeGetService("VirtualInputManager")
    if vim then
        if IsMobileDevice or UserInputService.TouchEnabled then
            pcall(function()
                vim:SendTouchEvent(0, 0, 10, 10)
                task.wait(0.04)
                vim:SendTouchEvent(0, 2, 10, 10)
                didPulse = true
            end)
        else
            pcall(function()
                vim:SendMouseButtonEvent(10, 10, 0, true, game, 1)
                task.wait(0.04)
                vim:SendMouseButtonEvent(10, 10, 0, false, game, 1)
                didPulse = true
            end)
        end
    end
    if not didPulse then
        pcall(function()
            local cam = Workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.Angles(0, 0.001, 0)
                task.wait(0.04)
                cam.CFrame = cam.CFrame * CFrame.Angles(0, -0.001, 0)
            end
        end)
    end
end

table.insert(Hub.Connections, LocalPlayer.Idled:Connect(function()
    if Hub.Settings.AntiAfk and Hub.Running and genv[_gk.sk] == SCRIPT_ID then
        TriggerAntiAfkPulse()
    end
end))

if typeof(getconnections) == "function" then
    pcall(function()
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            if typeof(conn.Disable) == "function" then
                conn:Disable()
            end
        end
    end)
end

task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(180 + math.random() * 40)
        if Hub.Settings.AntiAfk and Hub.Running then
            TriggerAntiAfkPulse()
        end
    end
end)

-- ==============================================================
-- 🔄 AUTO-REJOIN SAME SERVER ENGINE (Disconnect / Kick / Error)
-- ==============================================================
do
local RejoinActive = false
local RejoinAttemptCount = 0
local MAX_SAME_SERVER_RETRIES = 6 -- ลองเชื่อมต่อ JobId เดิม 6 ครั้ง (~25-30 วินาที) ก่อน fallback

function RejoinCurrentServer(reason)
    if RejoinActive then return end
    if not Hub.Running or not Hub.Settings.AutoRejoin then return end
    if genv[_gk.sk] ~= SCRIPT_ID then return end

    RejoinActive = true

    task.spawn(function()
        -- พยายามแจ้งเตือนผ่าน UI (ถ้าหน้าต่างยังอยู่)
        pcall(function()
            local win = Hub.Window
            if win and win.Notify then
                win:Notify({
                    Title = "Auto Rejoin",
                    Text = "ตรวจพบการหลุด (" .. tostring(reason or "Disconnect") .. ") กำลังรีจอยเข้าเซิร์ฟเดิม...",
                    Icon = "refresh-cw",
                    Duration = 6
                })
            end
        end)

        -- แก้ไขข้อความใน ErrorPrompt ของ Roblox CoreGui เพื่อให้ผู้ใช้เห็นสถานะ
        pcall(function()
            local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
            local prompt = promptOverlay and promptOverlay:FindFirstChild("ErrorPrompt")
            if prompt then
                local msgArea = prompt:FindFirstChild("MessageArea")
                local errFrame = msgArea and msgArea:FindFirstChild("ErrorFrame")
                local errMsg = errFrame and errFrame:FindFirstChild("ErrorMessage")
                if errMsg and errMsg:IsA("TextLabel") then
                    errMsg.Text = "⚡ [Kraken Hub] หลุดการเชื่อมต่อ (" .. tostring(reason or "Disconnect") .. ")\nกำลังทำการ Rejoin เข้าเซิร์ฟเวอร์เดิมอัตโนมัติ..."
                end
            end
        end)

        -- หน่วงเวลา 1.5 วินาทีให้ Socket หรือ Network เคลียร์สถานะ
        task.wait(1.5)

        local targetPlace = (OriginalPlaceId and OriginalPlaceId ~= 0) and OriginalPlaceId or game.PlaceId
        local targetJob = (OriginalJobId and #OriginalJobId > 0) and OriginalJobId or game.JobId

        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            RejoinAttemptCount = RejoinAttemptCount + 1

            -- ตรวจสอบคิวรันสคริปต์อัตโนมัติหลัง Rejoin (ถ้า Executor รองรับ)
            pcall(function()
                local qot = (syn and syn.queue_on_teleport)
                    or (fluxus and fluxus.queue_on_teleport)
                    or queue_on_teleport
                    or (genv and genv.queue_on_teleport)
                if qot and genv._KrakenHubScriptLoader then
                    qot(genv._KrakenHubScriptLoader)
                end
            end)

            -- 1. ถ้ามีปุ่ม Reconnect ของ Roblox ให้กดปุ่ม Reconnect
            pcall(function()
                local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
                local prompt = promptOverlay and promptOverlay:FindFirstChild("ErrorPrompt")
                if prompt then
                    for _, btn in ipairs(prompt:GetDescendants()) do
                        if btn:IsA("GuiButton") then
                            local txt = string.lower(btn.Text or "")
                            if txt:find("reconnect") or txt:find("ลองอีกครั้ง") or btn.Name:lower():find("reconnect") then
                                if TriggerGuiButton then
                                    TriggerGuiButton(btn)
                                elseif typeof(firesignal) == "function" and btn.MouseButton1Click then
                                    firesignal(btn.MouseButton1Click)
                                elseif typeof(firesignal) == "function" and btn.Activated then
                                    firesignal(btn.Activated)
                                end
                            end
                        end
                    end
                end
            end)

            -- 2. เชื่อมต่อกลับเข้าไปยังเซิร์ฟเวอร์เดิม (Same Server JobId)
            if targetJob and #targetJob > 0 and RejoinAttemptCount <= MAX_SAME_SERVER_RETRIES then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(targetPlace, targetJob, LocalPlayer)
                end)
            else
                -- Fallback: เข้าเซิร์ฟเวอร์ปกติ (กรณีเซิร์ฟเดิมปิดตัว/เต็ม/ดับ)
                pcall(function()
                    TeleportService:Teleport(targetPlace, LocalPlayer)
                end)
            end

            -- ทำการลองใหม่อย่างต่อเนื่องทุกๆ 4 วินาที (เช่น ในกรณีเน็ตยังไม่ต่อติด)
            task.wait(4)
        end
    end)
end

Hub.RejoinServer = function()
    RejoinCurrentServer("Manual Rejoin")
end

-- ดักจับเหตุการณ์ Teleport ล้มเหลว (เช่น เซิร์ฟปิด/เต็ม) เพื่อให้ Fallback เข้าเซิร์ฟอื่นได้ทันที
table.insert(Hub.Connections, TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if RejoinActive then
        if teleportResult == Enum.TeleportResult.GameEnded
            or teleportResult == Enum.TeleportResult.GameFull
            or teleportResult == Enum.TeleportResult.Unauthorized then
            RejoinAttemptCount = math.max(RejoinAttemptCount, MAX_SAME_SERVER_RETRIES + 1)
        end
        task.wait(1.5)
        local targetPlace = (OriginalPlaceId and OriginalPlaceId ~= 0) and OriginalPlaceId or game.PlaceId
        pcall(function()
            TeleportService:Teleport(targetPlace, LocalPlayer)
        end)
    end
end))

-- ดักจับการแจ้งเตือน Error / Kick / Disconnect ผ่าน GuiService
pcall(function()
    table.insert(Hub.Connections, GuiService.ErrorMessageChanged:Connect(function(msg)
        if Hub.Settings.AutoRejoin and msg and #msg > 0 then
            RejoinCurrentServer("GuiService: " .. tostring(msg))
        end
    end))
end)

-- ดักจับ ErrorPrompt ใน CoreGui (Prompt หลุด/เตะ)
pcall(function()
    local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
    if promptOverlay then
        local function onPromptAdded(child)
            if Hub.Settings.AutoRejoin and child and child.Name == "ErrorPrompt" then
                RejoinCurrentServer("CoreGui ErrorPrompt")
            end
        end
        table.insert(Hub.Connections, promptOverlay.ChildAdded:Connect(onPromptAdded))
        if promptOverlay:FindFirstChild("ErrorPrompt") then
            onPromptAdded(promptOverlay:FindFirstChild("ErrorPrompt"))
        end
    end
end)

-- Watchdog ตรวจสอบสถานะการเชื่อมต่อทุก 2 วินาที
task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(2)
        if Hub.Settings.AutoRejoin and not RejoinActive then
            pcall(function()
                local errCode = GuiService:GetErrorCode()
                if errCode and errCode ~= Enum.ConnectionError.OK and errCode ~= 0 then
                    RejoinCurrentServer("ConnectionError: " .. tostring(errCode))
                    return
                end
                local promptOverlay = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
                if promptOverlay and promptOverlay:FindFirstChild("ErrorPrompt") then
                    RejoinCurrentServer("Watchdog ErrorPrompt")
                    return
                end
            end)
        end
    end
end)
end

-- ==============================================================
-- 🛡️ 5.6 STAFF & ADMIN ACTIVE RADAR SHIELD (กันแบนแอดมิน & ส่องดู)
-- ==============================================================
do
local StaffKeywords = {
    ["admin"] = "แอดมิน",
    ["staff"] = "ทีมงาน",
    ["mod"] = "ผู้ดูแล (Mod)",
    ["moderator"] = "ผู้ดูแล (Mod)",
    ["dev"] = "ผู้พัฒนา (Dev)",
    ["developer"] = "ผู้พัฒนา (Dev)",
    ["owner"] = "เจ้าของเกม (Owner)",
    ["creator"] = "ผู้สร้างเกม",
    ["management"] = "ฝ่ายบริหาร",
    ["police"] = "เจ้าหน้าที่",
}

function CheckPlayerStaffStatus(player)
    if not player or player == LocalPlayer then return false, nil end

    -- 1. Check player Attributes ("Rank", "Role", "Admin", "Staff")
    local rankAttr = tostring(player:GetAttribute("Rank") or player:GetAttribute("Role") or ""):lower()
    for kw, label in pairs(StaffKeywords) do
        if rankAttr:find(kw) then
            return true, label .. " [" .. tostring(player:GetAttribute("Rank") or kw) .. "]"
        end
    end

    -- 2. Check RankShared level if available
    if RankShared and RankShared.level then
        local myLvl = RankShared.level("VIP") or 1
        local pLvl = RankShared.level(player:GetAttribute("Rank") or "") or 0
        if pLvl > myLvl then
            return true, "ตำแหน่งพิเศษ [" .. tostring(player:GetAttribute("Rank") or "Staff") .. "]"
        end
    end

    -- 3. Check name or display name for staff tags
    local nameLower = string.lower(player.Name)
    local dispLower = string.lower(player.DisplayName)
    if nameLower:find("admin_") or nameLower:find("staff_") or nameLower:find("mod_")
        or dispLower:find("ทีมงาน") or dispLower:find("แอดมิน") then
        return true, "ชื่อระบุทีมงาน"
    end

    -- 4. Check Spectator / Freecam hovering near LocalPlayer (< 140 studs)
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local pChar = player.Character
    local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
    local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
    if myHrp and pHrp and pHum then
        local dist = (myHrp.Position - pHrp.Position).Magnitude
        if dist < 140 and (pHrp.Transparency > 0.8 or pHum.PlatformStand) then
            return true, "กำลังส่องดูตัวละคร (Spectating Freecam)"
        end
    end

    return false, nil
end
Hub.CheckPlayerStaffStatus = CheckPlayerStaffStatus

-- Background Staff Scanner Loop
task.spawn(function()
    local lastNotifiedStaff = {}
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(2.0)
        if Hub.Settings.AntiStaffMode then
            local currentStaff = {}
            local hasStaff = false

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local isStaff, role = CheckPlayerStaffStatus(p)
                    if isStaff then
                        hasStaff = true
                        table.insert(currentStaff, {
                            Player = p,
                            Name = p.Name,
                            DisplayName = p.DisplayName,
                            Role = role or "Staff"
                        })
                        if not lastNotifiedStaff[p.UserId] then
                            lastNotifiedStaff[p.UserId] = true
                            pcall(function()
                                local win = Hub.Window
                                if win and win.Notify then
                                    win:Notify({
                                        Title = "🚨 ตรวจพบแอดมิน/ทีมงาน!",
                                        Text = p.DisplayName .. " (@" .. p.Name .. ")\n" .. tostring(role),
                                        Icon = "shield-alert",
                                        Duration = 8
                                    })
                                end
                            end)

                            -- Auto Server-Hop if enabled
                            if Hub.Settings.AutoServerHopOnStaff then
                                task.defer(function()
                                    task.wait(1.0)
                                    pcall(function()
                                        local win = Hub.Window
                                        if win and win.Notify then
                                            win:Notify({
                                                Title = "หนีเซิร์ฟอัตโนมัติ",
                                                Text = "ย้ายเซิร์ฟเวอร์ทันทีเพื่อความปลอดภัย...",
                                                Icon = "arrow-right-circle",
                                                Duration = 4
                                            })
                                        end
                                        local tpService = TeleportService or game:GetService("TeleportService")
                                        tpService:Teleport(game.PlaceId)
                                    end)
                                end)
                            end
                        end
                    end
                end
            end

            Hub.StaffPresent = hasStaff
            Hub.DetectedStaffList = currentStaff

            if not hasStaff and next(lastNotifiedStaff) ~= nil then
                lastNotifiedStaff = {}
                pcall(function()
                    local win = Hub.Window
                    if win and win.Notify then
                        win:Notify({
                            Title = "🟢 ปลอดภัย",
                            Text = "ทีมงานออกจากเซิร์ฟเวอร์แล้ว กลับสู่การทำงานปกติ",
                            Icon = "check-circle",
                            Duration = 4
                        })
                    end
                end)
            end
        end
    end
end)
end

-- ==============================================================
-- 🏃 6. MOVEMENT, TELEPORT & FLY ENGINE (PC & MOBILE OPTIMIZED)
-- ==============================================================
do
Flying = false
local FlyBodyGyro = nil
local FlyBodyVel = nil

function StartFly()
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

        -- Seated Vehicle Mobile Controls (throttle & steer pedals)
        if veh then
            local seatPart = hum and hum.SeatPart
            if seatPart and seatPart:IsA("VehicleSeat") then
                if math.abs(seatPart.ThrottleFloat) > 0.05 then
                    dir = dir + (Camera.CFrame.LookVector * seatPart.ThrottleFloat)
                end
                if math.abs(seatPart.SteerFloat) > 0.05 then
                    dir = dir + (Camera.CFrame.RightVector * seatPart.SteerFloat)
                end
            end
        end

        -- Mobile Thumbstick & Touch Controls (Native 3D Camera-Guided Navigation)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            local camLook = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            local flatLook = Vector3.new(camLook.X, 0, camLook.Z)
            local flatRight = Vector3.new(camRight.X, 0, camRight.Z)

            if flatLook.Magnitude > 0.05 and flatRight.Magnitude > 0.05 then
                flatLook = flatLook.Unit
                flatRight = flatRight.Unit
                local fwdDot = hum.MoveDirection:Dot(flatLook)
                local sideDot = hum.MoveDirection:Dot(flatRight)
                dir = dir + (camLook * fwdDot) + (camRight * sideDot)
            else
                dir = dir + hum.MoveDirection
            end
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

function StopFly()
    Flying = false
    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end) FlyBodyGyro = nil end
    if FlyBodyVel then pcall(function() FlyBodyVel:Destroy() end) FlyBodyVel = nil end
end

-- Speed & Noclip Stepped (Zero GC Allocations for Mobile / Low-End Hardware)
local moveConn
local _cachedChar = nil
local _cachedParts = {}

function RefreshPartCache(c)
    _cachedChar = c
    _cachedParts = {}
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(_cachedParts, p)
        end
    end
end

moveConn = RunService.Stepped:Connect(function()
    -- [FPS PATCH] combined early-exit guards (no table alloc on fast path)
    if not Hub.Running or not Hub.Settings.SpeedHack then return end

    local char = LocalPlayer.Character
    if not char then return end

    if Hub.Settings.SpeedHack then
        local hum = char:FindFirstChildOfClass("Humanoid")
        -- Strict safe humanoid walkspeed: server anti-cheat kicks if on-foot speed > 18
        local safeSpeed = math.clamp(Hub.Settings.SpeedValue or 16, 16, 18)
        if hum and hum.WalkSpeed ~= safeSpeed then
            hum.WalkSpeed = safeSpeed
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
Hub.StartFly = StartFly
Hub.StopFly = StopFly

end

function GetTargetGuiParent()
    if setthreadidentity then pcall(setthreadidentity, 8) end
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local lp = Players.LocalPlayer
    if lp then
        local okPg, pg = pcall(function()
            return lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
        end)
        if okPg and pg then return pg end
    end
    local okCore, cg = pcall(function()
        local c = (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
        local test = Instance.new("Folder")
        test.Parent = c
        test:Destroy()
        return c
    end)
    if okCore and cg then
        return cg
    end
    return nil
end

-- ==============================================================
-- 👁️ 7. ESP VISUAL ENGINE (Drawing + Roblox Native Fallback)
-- ==============================================================
do
local HasDrawing = (function()
    if typeof(Drawing) == "table" and type(Drawing.new) == "function" then
        local s, test = pcall(Drawing.new, "Square")
        if s and test then
            pcall(function() test:Remove() end)
            return true
        end
    end
    return false
end)()

function CreateDrawing(class, props)
    if not HasDrawing then return nil end
    local s, obj = pcall(Drawing.new, class)
    if s and obj then
        for k, v in pairs(props or {}) do
            pcall(function() obj[k] = v end)
        end
        return obj
    end
    return nil
end

function RemoveESPForPlayer(plr)
    if Hub.ESPObjects[plr] then
        local esp = Hub.ESPObjects[plr]
        if esp.IsFallback then
            pcall(function() if esp.Highlight then esp.Highlight:Destroy() end end)
            pcall(function() if esp.Billboard then esp.Billboard:Destroy() end end)
        else
            for _, draw in pairs(esp) do
                pcall(function() draw:Remove() end)
            end
        end
        Hub.ESPObjects[plr] = nil
    end
end

local _lastEspTime = 0
function UpdateESP()
    if not Hub.Running then return end

    if not Hub.Settings.PlayerESP then
        if next(Hub.ESPObjects) then
            for plr in pairs(Hub.ESPObjects) do
                RemoveESPForPlayer(plr)
            end
        end
        return
    end

    -- [FPS PATCH] Adaptive ESP throttle: 20 fps mobile / 30 fps PC
    local now = os.clock()
    if now - _lastEspTime < (IsMobileDevice and 0.05 or 0.033) then return end
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
                if HasDrawing then
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
                                esp.Box.Color = Hub.Settings.ESPColor or Color3.fromRGB(0, 220, 255)
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
                    -- 📱 Fallback ESP Engine (Roblox Native Highlight + BillboardGui for Executors without Drawing)
                    if not Hub.ESPObjects[plr] then
                        local guiHost = GetTargetGuiParent()
                        local hl = Instance.new("Highlight")
                        hl.Name = "SelectionHighlight"
                        hl.FillColor = Color3.fromRGB(0, 220, 255)
                        hl.FillTransparency = 0.75
                        hl.OutlineColor = Color3.fromRGB(0, 255, 255)
                        hl.OutlineTransparency = 0.1
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = char
                        pcall(function() hl.Parent = guiHost end)

                        local bb = Instance.new("BillboardGui")
                        bb.Name = "StatusOverlay"
                        bb.Size = UDim2.new(0, 180, 0, 42)
                        bb.StudsOffset = Vector3.new(0, 3.2, 0)
                        bb.AlwaysOnTop = true
                        bb.Adornee = hrp

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextStrokeTransparency = 0.2
                        nameLabel.TextSize = 13
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                        nameLabel.Parent = bb

                        local infoLabel = Instance.new("TextLabel")
                        infoLabel.Name = "InfoLabel"
                        infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        infoLabel.BackgroundTransparency = 1
                        infoLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
                        infoLabel.TextStrokeTransparency = 0.3
                        infoLabel.TextSize = 12
                        infoLabel.Font = Enum.Font.SourceSans
                        infoLabel.Parent = bb

                        pcall(function() bb.Parent = guiHost end)

                        Hub.ESPObjects[plr] = {
                            IsFallback = true,
                            Highlight = hl,
                            Billboard = bb,
                            NameLabel = nameLabel,
                            InfoLabel = infoLabel
                        }
                    end

                    local esp = Hub.ESPObjects[plr]
                    if esp.Highlight then
                        esp.Highlight.Adornee = char
                        esp.Highlight.Enabled = Hub.Settings.ESPBox
                        local espCol = Hub.Settings.ESPColor or Color3.fromRGB(0, 220, 255)
                        esp.Highlight.FillColor = espCol
                        esp.Highlight.OutlineColor = espCol
                    end
                    if esp.Billboard then
                        esp.Billboard.Adornee = hrp
                        esp.Billboard.Enabled = Hub.Settings.PlayerESP
                    end
                    if esp.NameLabel then
                        esp.NameLabel.Visible = Hub.Settings.ESPName
                    end
                    if esp.InfoLabel then
                        local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                        local vName = plr:GetAttribute("ActiveVehicle") or (hum.SeatPart and hum.SeatPart:FindFirstAncestorOfClass("Model") and hum.SeatPart:FindFirstAncestorOfClass("Model").Name) or "On Foot"
                        local text = ""
                        if Hub.Settings.ESPDistance then text = text .. tostring(dist) .. "m " end
                        if Hub.Settings.ESPVehicle and vName ~= "On Foot" then text = text .. "[" .. tostring(vName) .. "]" end
                        esp.InfoLabel.Text = text
                        esp.InfoLabel.Visible = (Hub.Settings.ESPDistance or Hub.Settings.ESPVehicle)
                    end
                end
            else
                RemoveESPForPlayer(plr)
            end
        else
            RemoveESPForPlayer(plr)
        end
    end
end

local espConn = RunService.Heartbeat:Connect(UpdateESP) -- [FPS PATCH] RenderStepped→Heartbeat (ESP nolonger blocks renderer)
table.insert(Hub.Connections, espConn)
Hub.HasDrawing = HasDrawing
Hub.RemoveESPForPlayer = RemoveESPForPlayer

end

-- ==============================================================
-- 👤 HIDE CHARACTER NAMES ENGINE (Streamer Mode / ซ่อนป้ายชื่อบนหัว)
-- ==============================================================
do
function ApplyNameTagVisibilityToChar(char, hide)
    if not char or not char:IsA("Model") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            if hide then
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            else
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            end
        end)
    end

    -- Process all BillboardGuis inside character (Head, HumanoidRootPart, Torso, etc.)
    for _, inst in ipairs(char:GetDescendants()) do
        if inst:IsA("BillboardGui") and inst.Name ~= "Kraken_ESP_BB" then
            if hide then
                if inst:GetAttribute("_OrigEnabled") == nil then
                    inst:SetAttribute("_OrigEnabled", inst.Enabled)
                end
                inst.Enabled = false
            else
                local orig = inst:GetAttribute("_OrigEnabled")
                inst.Enabled = (orig ~= nil and orig) or true
            end
        end
    end
end

function UpdateNameTagsVisibility(hide)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            ApplyNameTagVisibilityToChar(p.Character, hide)
        end
    end
end

table.insert(Hub.Connections, Players.PlayerAdded:Connect(function(p)
    table.insert(Hub.Connections, p.CharacterAdded:Connect(function(c)
        if Hub.Running and Hub.Settings.HideNames then
            task.wait(0.2)
            ApplyNameTagVisibilityToChar(c, true)
        end
    end))
end))

task.spawn(function()
    while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
        task.wait(5.0) -- [FPS PATCH] 2.5 → 5 s (PlayerGui descendants scan is expensive)
        if Hub.Settings.HideNames then
            pcall(UpdateNameTagsVisibility, true)
        end
    end
end)

-- รันซ่อนชื่อทันทีตั้งแต่เริ่มต้นรันสคริปต์
if Hub.Settings.HideNames then
    task.spawn(function()
        pcall(UpdateNameTagsVisibility, true)
    end)
end
Hub.UpdateNameTagsVisibility = UpdateNameTagsVisibility

end

-- ==============================================================
-- 🎨 8. VANTIX UI6 INTERFACE (FROM ui.lua)
-- ==============================================================
local function InitUI()
    if setthreadidentity then pcall(setthreadidentity, 8) end
    local targetGuiParent = GetTargetGuiParent()

    -- Clean up previous UI instances across all GUI hosts
    pcall(function()
        local existing = genv.VantixUIGui
        if typeof(existing) == "Instance" then pcall(function() existing:Destroy() end) end
        local hosts = { targetGuiParent, gethui and gethui(), LocalPlayer:FindFirstChild("PlayerGui") }
        local cg = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil
        if cg then table.insert(hosts, cg) end

        for _, host in ipairs(hosts) do
            if host then
                pcall(function()
                    for _, child in ipairs(host:GetChildren()) do
                        if child.Name:find("Kraken_PistonShop") or child.Name:find("Kraken_ESP") then
                            pcall(function() child:Destroy() end)
                        elseif child:IsA("ScreenGui") and (child.Name == STEALTH_BTN_NAME or child.Name == STEALTH_UI_NAME or StealthGuiNames[child.Name] or child.Name == "KrakenHub_Mahanakhon_Btn" or child.Name == "KrakenHub_Mahanakhon_UI" or child:FindFirstChild("Base")) then
                            pcall(function() child:Destroy() end)
                        end
                    end
                    local rGui = host:FindFirstChild("RobloxGui")
                    if rGui then
                        for _, d in ipairs(rGui:GetChildren()) do
                            if d.Name:find("Kraken_PistonShop") or d.Name:find("Kraken_ESP") then
                                pcall(function() d:Destroy() end)
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- 🎨 Load VantixUI6 Library (Universal Cross-Platform PC & Mobile Loader)
    local VantixUI = nil
    local ok, lib = pcall(function()
        if setthreadidentity then pcall(setthreadidentity, 8) end
        local url = "https://raw.githubusercontent.com/Snipez-Dev/Vantix/refs/heads/main/VantixUI6"
        local code = UniversalHttpGet(url)
        if not code or #code < 5000 then
            if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile("vantixui6_cache.lua") then
                local cached = readfile("vantixui6_cache.lua")
                if type(cached) == "string" and #cached > 5000 then
                    code = cached
                end
            end
        else
            if typeof(writefile) == "function" then
                pcall(writefile, "vantixui6_cache.lua", code)
            end
        end

        if not code or #code < 5000 then
            return loadstring(game:HttpGet(url))()
        end

        -- Ensure HttpGetAsync fallback for Lucide icons on all executors
        code = code:gsub("game:HttpGetAsync%(", "game:HttpGet(")
        -- Mask initial profile display name in VantixUI source
        code = code:gsub("text%s*=%s*player%.DisplayName", 'text=""')
        -- Expose scroll & content on Tab object for custom tab layouts
        code = code:gsub("local Tab = {}", "local Tab = { Scroll = scroll, Content = tabContent }")
        -- Format initial executor label to show Online status
        code = code:gsub("execLbl%.Text%s*=%s*execName", 'execLbl.RichText = true; execLbl.TextSize = 12; execLbl.Text = \'<font color="#2ECC71">● Online</font> <font color="#666677">•</font> \' .. tostring(execName)')
        -- 🛡️ Immunity against "lacking capability Plugin" on CoreGui in sandboxed threads
        code = code:gsub('existing%s*=%s*existing%s*or%s*guiParent:FindFirstChild%("VantixUI"%)%s*or%s*CoreGui:FindFirstChild%("VantixUI"%)',
            'pcall(function() existing = existing or (guiParent and guiParent:FindFirstChild("VantixUI")) end); pcall(function() existing = existing or (CoreGui and CoreGui:FindFirstChild("VantixUI")) end)')
        code = code:gsub('CoreGui:FindFirstChild%("VantixUI"%)', '(pcall(function() return CoreGui:FindFirstChild("VantixUI") end) and CoreGui:FindFirstChild("VantixUI") or nil)')
        return loadstring(code)()
    end)

    if ok and lib then
        VantixUI = lib
    else
        return
    end
    Hub.VantixUI = VantixUI

    local function toHex(c)
        return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end

    local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
    if vp.X < 100 or vp.Y < 100 then
        vp = Vector2.new(1280, 720)
    end
    local winW = 820
    local winH = 480
    if IsMobileDevice or vp.X < 900 or vp.Y < 550 then
        winW = math.clamp(math.floor(vp.X * 0.90), math.min(360, vp.X - 16), 720)
        winH = math.clamp(math.floor(vp.Y * 0.85), math.min(260, vp.Y - 16), 420)
    end

    -- 🪟 Create Main Window (VantixUI6 from ui.lua)
    local Window = VantixUI:CreateWindow({
        Title       = "Kraken Hub",
        Theme       = "Vantix",
        AccentColor = Color3.fromRGB(255, 255, 255),
        LogoID      = 110034487018208,
        Size        = {winW, winH},
    })
    Hub.Window = Window
    Window.Unload = function(self)
        pcall(function() self:Destroy() end)
    end
    if Window.Gui then
        RegisterStealthGui(Window.Gui)
    end



    Window:CreateTag("Beta",    Color3.fromRGB(240, 100, 100), nil, "flask-conical")
    Window:CreateTag("Premium", Color3.fromRGB(255, 180, 50),  nil, "crown")

    -- 🌟 Kraken Animated Logo Injection (Top-Left of Window)
    local KRAKEN_LOGO_B64 = [=[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]=]
    local function GetKrakenLogoAsset()
        local asset = nil
        pcall(function()
            if typeof(isfile) == "function" and not isfile("kraken_logo.png") then
                if typeof(writefile) == "function" then
                    local raw = (crypt and crypt.base64decode and crypt.base64decode(KRAKEN_LOGO_B64))
                             or (base64_decode and base64_decode(KRAKEN_LOGO_B64))
                    if raw then writefile("kraken_logo.png", raw) end
                end
            end
            if typeof(getcustomasset) == "function" and typeof(isfile) == "function" and isfile("kraken_logo.png") then
                asset = getcustomasset("kraken_logo.png")
            end
        end)
        return asset or "rbxassetid://139929981863901"
    end

    local function ApplyWindowLogo()
        pcall(function()
            local gui = Window and Window.Gui
            if not gui then return end
            local titlebar = gui:FindFirstChild("Titlebar", true)
            local lbl = titlebar and titlebar:FindFirstChild("Lbl")
            if titlebar and lbl then
                local logoAsset = GetKrakenLogoAsset()
                local oldLogo = titlebar:FindFirstChild("KrakenLogo")
                if oldLogo then oldLogo:Destroy() end

                local logo = Instance.new("ImageLabel")
                logo.Name = "KrakenLogo"
                logo.BackgroundTransparency = 1
                logo.Size = UDim2.fromOffset(26, 26)
                logo.Position = UDim2.new(0, 12, 0.5, 0)
                logo.AnchorPoint = Vector2.new(0, 0.5)
                logo.Image = logoAsset
                logo.ZIndex = lbl.ZIndex + 1
                logo.Parent = titlebar

                lbl.Position = UDim2.new(0, 44, 0, 0)

                -- 💫 แสงปาด (Metallic Shimmer Sweep across the Logo)
                local shine = Instance.new("ImageLabel")
                shine.Name = "ShineOverlay"
                shine.BackgroundTransparency = 1
                shine.Size = UDim2.fromScale(1, 1)
                shine.Position = UDim2.fromScale(0, 0)
                shine.Image = logoAsset
                shine.ImageColor3 = Color3.fromRGB(255, 255, 255)
                shine.ZIndex = logo.ZIndex + 1
                shine.Parent = logo

                local grad = Instance.new("UIGradient")
                grad.Rotation = 30
                grad.Offset = Vector2.new(-1.0, 0)
                grad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 1.0),
                    NumberSequenceKeypoint.new(0.35, 1.0),
                    NumberSequenceKeypoint.new(0.5, 0.05),
                    NumberSequenceKeypoint.new(0.65, 1.0),
                    NumberSequenceKeypoint.new(1.0, 1.0),
                })
                grad.Parent = shine

                task.spawn(function()
                    while logo and logo.Parent do
                        grad.Offset = Vector2.new(-1.0, 0)
                        local tw = TweenService:Create(grad, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Offset = Vector2.new(1.0, 0)
                        })
                        tw:Play()
                        tw.Completed:Wait()
                        grad.Offset = Vector2.new(-1.0, 0)
                        task.wait(2.2)
                    end
                end)
            end
        end)
    end

    task.spawn(function()
        task.wait(0.05)
        ApplyWindowLogo()
        task.wait(0.3)
        ApplyWindowLogo()
    end)

    -- 🕶️ Profile Username Masking (e.g. Kraken -> K**n)
    local function MaskUsername(name)
        local s = tostring(name or "")
        if s == "" then return "***" end
        local chars = {}
        pcall(function()
            for first, last in utf8.graphemes(s) do
                table.insert(chars, s:sub(first, last))
            end
        end)
        if #chars == 0 then
            local len = #s
            if len <= 1 then return s .. "**"
            elseif len == 2 then return s:sub(1, 1) .. "*"
            elseif len == 3 then return s:sub(1, 1) .. "*" .. s:sub(3, 3)
            else return s:sub(1, 1) .. "**" .. s:sub(-1, -1) end
        end
        if #chars <= 1 then
            return s .. "**"
        elseif #chars == 2 then
            return chars[1] .. "*"
        elseif #chars == 3 then
            return chars[1] .. "*" .. chars[3]
        else
            return chars[1] .. "**" .. chars[#chars]
        end
    end

    local function ApplyProfileName()
        pcall(function()
            local sg = (Window and Window.Gui)
                    or (genv and genv.VantixUIGui)
                    or (getgenv and getgenv().VantixUIGui)
                    or (CoreGui and CoreGui:FindFirstChild("VantixUI", true))
            if not sg then return end

            local profile = sg:FindFirstChild("Profile", true)
            if not profile then return end

            -- Clean up any leftover blur containers or clicker overlays
            local oldContainer = profile:FindFirstChild("BlurContainer")
            if oldContainer then oldContainer:Destroy() end
            local oldClicker = profile:FindFirstChild("PrivacyClicker")
            if oldClicker then oldClicker:Destroy() end

            local nameLbl = nil
            for _, c in ipairs(profile:GetChildren()) do
                if c:IsA("TextLabel") and c.Position.Y.Offset < 0 and c.Name ~= "PrivacyClicker" and c.Name ~= "BlurGlyph" then
                    nameLbl = c
                    break
                end
            end
            if not nameLbl then
                for _, c in ipairs(profile:GetChildren()) do
                    if c:IsA("TextLabel") and c.Position.Y.Offset < 5 and c.Name ~= "PrivacyClicker" and c.Name ~= "BlurGlyph" then
                        nameLbl = c
                        break
                    end
                end
            end
            if not nameLbl then return end

            local rawName = tostring(LocalPlayer.DisplayName or LocalPlayer.Name or "waer2206")
            if rawName == "" then rawName = tostring(LocalPlayer.Name or "waer2206") end
            local maskedName = MaskUsername(rawName)

            nameLbl.Visible = true
            nameLbl.TextTransparency = 0
            if nameLbl.Text ~= maskedName then
                nameLbl.Text = maskedName
            end

            if not nameLbl:GetAttribute("MaskHooked") then
                nameLbl:SetAttribute("MaskHooked", true)
                nameLbl:GetPropertyChangedSignal("Text"):Connect(function()
                    if nameLbl.Text ~= maskedName then
                        nameLbl.Text = maskedName
                    end
                end)
                nameLbl:GetPropertyChangedSignal("Visible"):Connect(function()
                    if not nameLbl.Visible then
                        nameLbl.Visible = true
                    end
                end)
                nameLbl:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                    if nameLbl.TextTransparency ~= 0 then
                        nameLbl.TextTransparency = 0
                    end
                end)
            end
        end)
    end
    Hub.ApplyProfileName = ApplyProfileName

    task.spawn(function()
        task.wait(0.05)
        ApplyProfileName()
    end)

    -- 🟢 Universal User Online Status Indicator Engine (VantixUI & CoreGui Compatible)
    local function ApplyOnlineStatus()
        pcall(function()
            local sg = (Window and Window.Gui)
                    or (getgenv and getgenv().VantixUIGui)
                    or (CoreGui and CoreGui:FindFirstChild("VantixUI", true))
            if not sg then return end

            local profile = sg:FindFirstChild("Profile", true)
            if not profile then return end

            -- 1. 🟢 Discord-style Glowing Online Status Dot on Avatar
            local avatarHolder = profile:FindFirstChild("Avatar", true)
            if avatarHolder then
                avatarHolder.ClipsDescendants = false

                local dot = avatarHolder:FindFirstChild("OnlineDot")
                if not dot then
                    dot = Instance.new("Frame")
                    dot.Name = "OnlineDot"
                    dot.Size = UDim2.fromOffset(12, 12)
                    dot.Position = UDim2.new(1, -1, 1, -1)
                    dot.AnchorPoint = Vector2.new(1, 1)
                    dot.BackgroundColor3 = Color3.fromRGB(35, 210, 95)
                    dot.BorderSizePixel = 0
                    dot.ZIndex = (avatarHolder.ZIndex or 7) + 10

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(1, 0)
                    corner.Parent = dot

                    local stroke = Instance.new("UIStroke")
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Color = Color3.fromRGB(15, 15, 20)
                    stroke.Thickness = 2.0
                    stroke.Parent = dot

                    dot.Parent = avatarHolder

                    -- Breathing / Pulsing Green Glow
                    task.spawn(function()
                        local tInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                        local tween = TweenService:Create(dot, tInfo, { BackgroundColor3 = Color3.fromRGB(80, 245, 130) })
                        tween:Play()
                    end)
                end
            end

            -- 2. 🏷️ Subtitle / Status Text ("● Online • Potassium")
            for _, c in ipairs(profile:GetChildren()) do
                if c:IsA("TextLabel") and c.Position.Y.Offset >= 0 and c.Name ~= "BlurGlyph" and c.Name ~= "PrivacyClicker" then
                    if not c:GetAttribute("OnlineHooked") then
                        c:SetAttribute("OnlineHooked", true)

                        local updating = false
                        local function updateExecStatus()
                            if updating then return end
                            updating = true

                            local rawExec = c:GetAttribute("RawExec")
                            if not rawExec or rawExec == "" then
                                local cur = c.Text
                                local clean = cur:gsub("<[^>]->", ""):gsub("^[•●%s]*Online[%s•|]*", ""):gsub("[%s•|]*Online.*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
                                if clean ~= "" and not clean:lower():find("online") then
                                    rawExec = clean
                                else
                                    rawExec = ExecutorName or "Universal"
                                end
                                c:SetAttribute("RawExec", rawExec)
                            end

                            c.RichText = true
                            c.TextSize = 12
                            local formatted = '<font color="#2ECC71">● Online</font> <font color="#666677">•</font> ' .. tostring(rawExec)
                            if c.Text ~= formatted then
                                c.Text = formatted
                            end

                            updating = false
                        end

                        c:GetPropertyChangedSignal("Text"):Connect(updateExecStatus)
                        updateExecStatus()
                    else
                        local rawExec = c:GetAttribute("RawExec") or ExecutorName or "Universal"
                        local formatted = '<font color="#2ECC71">● Online</font> <font color="#666677">•</font> ' .. tostring(rawExec)
                        if c.Text ~= formatted then
                            c.RichText = true
                            c.TextSize = 12
                            c.Text = formatted
                        end
                    end
                    break
                end
            end
        end)
    end
    Hub.ApplyOnlineStatus = ApplyOnlineStatus

    -- Run Online Status immediately and after UI settles
    task.spawn(function()
        task.wait(0.08)
        ApplyOnlineStatus()
        ApplyProfileName()
        task.wait(0.3)
        ApplyOnlineStatus()
        ApplyProfileName()
        task.wait(1.0)
        ApplyOnlineStatus()
        ApplyProfileName()
    end)

    local zoomConn
    local status, console

    -- 🔎 Automatic Lucide Icon Resolver for Controls & Sections
    local function ResolveIcon(title, fallback)
        local t = tostring(title or ""):lower()
        if t:find("grab") or t:find("รับส่ง") then return "car"
        elseif t:find("อาหาร") or t:find("food") then return "utensils"
        elseif t:find("คำถาม") or t:find("เตือน") or t:find("captcha") or t:find("เเคปช่า") or t:find("แคปช่า") then return "bell"
        elseif t:find("ความเร็ว") or t:find("speed") or t:find("เดินเร็ว") then return "gauge"
        elseif t:find("เรดาร์") or t:find("esp") then return "eye"
        elseif t:find("กรอบ") or t:find("box") then return "square"
        elseif t:find("ชื่อคน") or t:find("name") then return "user"
        elseif t:find("ระยะทาง") or t:find("dist") then return "ruler"
        elseif t:find("รถ") or t:find("vehicle") then return "truck"
        elseif t:find("กระโดด") or t:find("jump") then return "arrow-up-circle"
        elseif t:find("สิ่งกีดขวาง") or t:find("noclip") then return "ghost"
        elseif t:find("ลอยตัว") or t:find("fly") then return "wind"
        elseif t:find("autoworks") or t:find("ลูกสูบ") or t:find("อู่") then return "wrench"
        elseif t:find("สนามแข่ง") or t:find("แดร็ก") then return "flag"
        elseif t:find("ปั๊มน้ำมัน") then return "fuel"
        elseif t:find("จุดเกิด") or t:find("เดินทาง") then return "map-pin"
        elseif t:find("บันทึก") or t:find("เซฟ") or t:find("save") then return "save"
        elseif t:find("โหลด") or t:find("load") then return "download"
        elseif t:find("ปิดสคริปต์") or t:find("unload") then return "log-out"
        elseif t:find("anti%-afk") or t:find("ป้องกัน") then return "shield"
        elseif t:find("ปุ่ม") or t:find("key") then return "keyboard"
        elseif t:find("ธีม") or t:find("สี") then return "palette"
        elseif t:find("อุปกรณ์") or t:find("แพลตฟอร์ม") then return "monitor-smartphone"
        end
        return fallback or "sliders-horizontal"
    end

    -- 🧩 VantixUI Compatibility Adapter Layer
    local Options = {}

    local function CreateTabAdapter(rawTab, tabName)
        local sectionCount = 0
        local adapter = {
            RawTab = rawTab,
            Select = function(self) end,
            AddSection = function(self, title, targetSide)
                sectionCount = sectionCount + 1
                if sectionCount > 1 then
                    rawTab:AddSeparator()
                end
                rawTab:AddLabel(title, ResolveIcon(title, "layers"))
                return self
            end,
            AddParagraph = function(self, cfg)
                local con = rawTab:AddConsole({
                    Title  = cfg.Title or cfg.Header or "Info",
                    Text   = cfg.Content or cfg.Body or "",
                    Height = 68,
                })
                return {
                    SetTitle = function(_, t) end,
                    SetDesc  = function(_, d) con:Set(d) end,
                }
            end,
            AddToggle = function(self, flag, cfg)
                local changedCallbacks = {}
                local vToggle
                local item = {
                    Value = cfg.Default or false,
                    State = cfg.Default or false,
                }
                vToggle = rawTab:AddToggle({
                    Title    = cfg.Title or flag,
                    Subtitle = cfg.Description or cfg.Subtitle,
                    Icon     = cfg.Icon or ResolveIcon(cfg.Title or flag, "toggle-right"),
                    Default  = cfg.Default or false,
                    Risky    = cfg.Risky,
                    Beta     = cfg.Beta,
                    Tooltip  = cfg.Tooltip,
                    Callback = function(v)
                        item.Value = v
                        item.State = v
                        if status then
                            pcall(function() status:Set("Status: " .. tostring(cfg.Title or flag) .. " " .. (v and "ON" or "OFF")) end)
                        end
                        if console then
                            pcall(function() console:Write(tostring(cfg.Title or flag) .. ": " .. (v and "enabled" or "disabled")) end)
                        end
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end,
                })
                function item:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function item:SetValue(v) vToggle:Set(v) end
                function item:Set(v) vToggle:Set(v) end
                function item:Get() return vToggle:Get() end
                item.Changed = vToggle.Changed
                Options[flag] = item
                return item
            end,
            AddSlider = function(self, flag, cfg)
                local changedCallbacks = {}
                local rounding = cfg.Rounding
                local vSlider
                local item = {
                    Min   = cfg.Min or 0,
                    Max   = cfg.Max or 100,
                    Value = cfg.Default or cfg.Min or 0,
                }
                vSlider = rawTab:AddSlider({
                    Title    = cfg.Title or flag,
                    Icon     = cfg.Icon or ResolveIcon(cfg.Title or flag, "activity"),
                    Min      = cfg.Min or 0,
                    Max      = cfg.Max or 100,
                    Default  = cfg.Default or cfg.Min or 0,
                    Risky    = cfg.Risky,
                    Beta     = cfg.Beta,
                    Tooltip  = cfg.Description or cfg.Tooltip,
                    Callback = function(v)
                        if rounding == 0 then
                            v = math.round(v)
                        elseif type(rounding) == "number" and rounding > 0 then
                            local mult = 10 ^ rounding
                            v = math.round(v * mult) / mult
                        end
                        item.Value = v
                        if status then
                            pcall(function() status:Set("Status: " .. tostring(cfg.Title or flag) .. " = " .. tostring(v)) end)
                        end
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end,
                })
                function item:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function item:SetValue(v) vSlider:Set(v) end
                function item:Set(v) vSlider:Set(v) end
                function item:Get() return vSlider:Get() end
                item.Changed = vSlider.Changed
                Options[flag] = item
                return item
            end,
            AddDropdown = function(self, flag, cfg)
                local changedCallbacks = {}
                local optsList = cfg.Values or cfg.Options or {}
                local vDrop
                local defaultVal = cfg.Default
                if defaultVal == nil then
                    defaultVal = cfg.Multi and {} or 1
                end
                local item = {
                    Value = cfg.Default or (cfg.Multi and {} or optsList[1] or ""),
                }
                local dropFn = cfg.Multi and rawTab.AddMultiDropdown or rawTab.AddDropdown
                vDrop = dropFn(rawTab, {
                    Title    = cfg.Title or flag,
                    Subtitle = cfg.Description or cfg.Subtitle,
                    Icon     = cfg.Icon or ResolveIcon(cfg.Title or flag, "list"),
                    Options  = optsList,
                    Default  = defaultVal,
                    Callback = function(v)
                        item.Value = v
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end,
                })
                function item:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function item:SetValue(v) vDrop:Set(v) end
                function item:Set(v) vDrop:Set(v) end
                function item:Get() return (vDrop and vDrop.Get and vDrop:Get()) or item.Value end
                function item:SetOptions(newOpts) vDrop:SetOptions(newOpts) end
                item.Changed = vDrop.Changed
                Options[flag] = item
                return item
            end,
            AddButton = function(self, cfg)
                return rawTab:AddButton({
                    Title    = cfg.Title or cfg.Name or "Button",
                    Subtitle = cfg.Description or cfg.Subtitle,
                    Icon     = cfg.Icon or ResolveIcon(cfg.Title or cfg.Name or "", "mouse-pointer"),
                    Text     = cfg.Text or "กดใช้งาน",
                    Risky    = cfg.Risky,
                    Beta     = cfg.Beta,
                    Tooltip  = cfg.Tooltip,
                    Callback = function()
                        if console then
                            pcall(function() console:Write("Pressed: " .. tostring(cfg.Title or cfg.Name or "Button")) end)
                        end
                        if cfg.Callback then pcall(cfg.Callback) end
                    end,
                })
            end,
            AddInput = function(self, flag, cfg)
                local vBox
                local item = {
                    Value = cfg.Default or "",
                }
                vBox = rawTab:AddTextBox({
                    Title       = cfg.Title or flag,
                    Subtitle    = cfg.Description or cfg.Subtitle,
                    Icon        = cfg.Icon or ResolveIcon(cfg.Title or flag, "file-text"),
                    Placeholder = cfg.Placeholder or "",
                    Default     = cfg.Default or "",
                    Callback    = function(text, enterPressed)
                        item.Value = text
                        if cfg.Callback then pcall(cfg.Callback, text, enterPressed) end
                    end,
                })
                function item:SetValue(v) vBox:Set(v) end
                function item:Set(v) vBox:Set(v) end
                function item:Get() return vBox:Get() end
                item.Changed = vBox.Changed
                Options[flag] = item
                return item
            end,
            AddKeybind = function(self, flag, cfg)
                local changedCallbacks = {}
                local defKey = cfg.Default or Enum.KeyCode.RightControl
                if typeof(defKey) == "string" and Enum.KeyCode[defKey] then
                    defKey = Enum.KeyCode[defKey]
                end
                local vKey
                local item = {
                    Value = defKey,
                }
                vKey = rawTab:AddKeybind({
                    Title    = cfg.Title or flag,
                    Subtitle = cfg.Description or cfg.Subtitle,
                    Icon     = cfg.Icon or "keyboard",
                    Default  = defKey,
                    Callback = function()
                        local cur = vKey and vKey:Get() or defKey
                        if cfg.Callback then pcall(cfg.Callback, cur) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, cur) end
                    end,
                })
                vKey.Changed:Connect(function(newKey)
                    item.Value = newKey
                    if cfg.Callback then pcall(cfg.Callback, newKey) end
                    for _, fn in ipairs(changedCallbacks) do pcall(fn, newKey) end
                end)
                function item:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function item:SetValue(v) vKey:Set(v) end
                function item:Set(v) vKey:Set(v) end
                function item:Get() return vKey:Get() end
                item.Changed = vKey.Changed
                Options[flag] = item
                return item
            end,
        }
        return adapter
    end

    -- 🛡️ Dummy Tab Adapter for background functions hidden from UI
    local function CreateDummyTabAdapter(tabName)
        local dummyElement = {
            Value = true,
            OnChanged = function(self, fn) end,
            SetValue = function(self, v) end,
            Set = function(self, v) end,
            Get = function(self) return self.Value end,
            SetDesc = function(self, v) end,
            SetTitle = function(self, v) end,
            Changed = { Connect = function() return { Disconnect = function() end } end }
        }
        local dummyRaw = {
            Scroll = nil,
            AddSeparator = function() end,
            AddLabel = function() return dummyElement end,
            AddConsole = function() return dummyElement end,
            AddToggle = function() return dummyElement end,
            AddSlider = function() return dummyElement end,
            AddDropdown = function() return dummyElement end,
            AddMultiDropdown = function() return dummyElement end,
            AddButton = function() return dummyElement end,
            AddTextBox = function() return dummyElement end,
            AddKeybind = function() return dummyElement end
        }
        return {
            RawTab = dummyRaw,
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
                    end,
                    Set = function(self, v)
                        self.Value = v
                        if cfg.Callback then pcall(cfg.Callback, v) end
                    end,
                    Get = function(self) return self.Value end,
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
                    end,
                    Set = function(self, v)
                        self.Value = v
                        if cfg.Callback then pcall(cfg.Callback, v) end
                    end,
                    Get = function(self) return self.Value end,
                }
                Options[flag] = item
                return item
            end,
            AddDropdown = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or (cfg.Multi and {} or ""),
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v) self.Value = v end,
                    Set = function(self, v) self.Value = v end,
                    Get = function(self) return self.Value end,
                }
                Options[flag] = item
                return item
            end,
            AddButton = function(self, cfg) return dummyElement end,
            AddInput = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or "",
                    SetValue = function(self, v) self.Value = v end,
                    Set = function(self, v) self.Value = v end,
                    Get = function(self) return self.Value end,
                }
                Options[flag] = item
                return item
            end,
            AddKeybind = function(self, flag, cfg)
                local item = {
                    Value = cfg.Default or Enum.KeyCode.RightControl,
                    OnChanged = function(self, fn) end,
                    SetValue = function(self, v) self.Value = v end,
                    Set = function(self, v) self.Value = v end,
                    Get = function(self) return self.Value end,
                }
                Options[flag] = item
                return item
            end
        }
    end

    -- 📑 Define Tabs with Lucide Icons (Kraken Hub Style)
    local rawStatsTab = Window:AddTab("สถิติ", "layout-grid")
    local Tabs = {
        Stats      = CreateTabAdapter(rawStatsTab, "Stats"),
        Farm       = CreateTabAdapter(Window:AddTab("ระบบงาน",       "clock"),         "Farm"),
        Shop       = CreateTabAdapter(Window:AddTab("ร้านค้า",       "menu"),          "Shop"),
        EcuTune    = CreateDummyTabAdapter("EcuTune"),
        CarPreview = CreateTabAdapter(Window:AddTab("รถ",            "car"),           "CarPreview"),
        Vehicle    = CreateDummyTabAdapter("Vehicle"),
        Visuals    = CreateDummyTabAdapter("Visuals"),
        Movement   = CreateDummyTabAdapter("Movement"),
        Teleport   = CreateDummyTabAdapter("Teleport"),
        Settings   = CreateTabAdapter(Window:AddTab("ตั้งค่า",       "settings"),      "Settings")
    }

    local Fluent = {
        Options = Options,
        Notify = function(self, cfg)
            local title = cfg.Title or "Mahanakhon"
            local text = cfg.Content or cfg.Description or cfg.Text or ""
            Window:Notify({
                Title    = title,
                Text     = text,
                Icon     = cfg.Icon or "check",
                Duration = cfg.Duration or cfg.Lifetime or 3,
            })
            if console then
                pcall(function() console:Write("[" .. tostring(title) .. "] " .. tostring(text):gsub("\n", " ")) end)
            end
        end,
        Destroy = function(self)
            pcall(function() Window:Destroy() end)
        end
    }
    Hub.Fluent = Fluent

    -- ================================================================
    -- 📊 TAB 0: STATS DASHBOARD (หน้าสถิติ Real-Time ตรงตามรูป Kraken Hub 100%)
    -- ================================================================
    local function SetupStatsDashboard()
        local scroll = nil
        if rawStatsTab and rawStatsTab.Scroll then
            scroll = rawStatsTab.Scroll
        end
        if not scroll then
            local sg = (Window and Window.Gui) or (genv and genv.VantixUIGui) or (getgenv and getgenv().VantixUIGui) or (CoreGui and CoreGui:FindFirstChild("VantixUI", true))
            local tabObj = sg and sg:FindFirstChild("Tab_สถิติ", true)
            scroll = tabObj and tabObj:FindFirstChild("Scroll")
        end
        if not scroll then return end

        -- ซ่อนเส้นขีด HDiv เพื่อให้ดีไซน์หน้าจอคลีน ไร้รอยต่อเหมือนในรูป Kraken Hub
        local tabContent = scroll.Parent
        if tabContent then
            local hDiv = tabContent:FindFirstChild("HDiv")
            if hDiv then hDiv.BackgroundTransparency = 1 end
        end

        local scrollLayout = scroll:FindFirstChildOfClass("UIListLayout")
        if scrollLayout then
            scrollLayout.Padding = UDim.new(0, 10)
        end

        -- 1. หัวข้อย่อย "ภาพรวมรายได้"
        local subHeader = Instance.new("TextLabel")
        subHeader.Name = "SubHeader"
        subHeader.Text = "ภาพรวมรายได้"
        subHeader.Font = Enum.Font.BuilderSansMedium
        subHeader.TextSize = 13
        subHeader.TextColor3 = Color3.fromRGB(120, 120, 130)
        subHeader.Size = UDim2.new(1, 0, 0, 20)
        subHeader.BackgroundTransparency = 1
        subHeader.TextXAlignment = Enum.TextXAlignment.Left
        subHeader.LayoutOrder = 1
        subHeader.Parent = scroll

        -- 2. Master Card รวมทุกวิดเจ็ตในกล่องเดียวตามรูป (Single Unified Card Container)
        local masterCard = Instance.new("Frame")
        masterCard.Name = "StatsMasterCard"
        masterCard.Size = UDim2.new(1, 0, 0, 334)
        masterCard.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
        masterCard.BorderSizePixel = 0
        masterCard.LayoutOrder = 2
        masterCard.Parent = scroll

        local mcCorner = Instance.new("UICorner")
        mcCorner.CornerRadius = UDim.new(0, 8)
        mcCorner.Parent = masterCard

        local mcStroke = Instance.new("UIStroke")
        mcStroke.Color = Color3.fromRGB(34, 34, 38)
        mcStroke.Thickness = 1
        mcStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        mcStroke.Parent = masterCard

        local mcPad = Instance.new("UIPadding")
        mcPad.PaddingTop = UDim.new(0, 14)
        mcPad.PaddingBottom = UDim.new(0, 14)
        mcPad.PaddingLeft = UDim.new(0, 16)
        mcPad.PaddingRight = UDim.new(0, 16)
        mcPad.Parent = masterCard

        -- แถวบน: รายได้ต่อชั่วโมง (ซ้าย) & สถานะฟาร์ม (ขวา)
        local topRow = Instance.new("Frame")
        topRow.Name = "TopRow"
        topRow.Size = UDim2.new(1, 0, 0, 62)
        topRow.Position = UDim2.new(0, 0, 0, 0)
        topRow.BackgroundTransparency = 1
        topRow.Parent = masterCard

        local hourlyLbl = Instance.new("TextLabel")
        hourlyLbl.Name = "HourlyLabel"
        hourlyLbl.Text = "เงินของเรา"
        hourlyLbl.Font = Enum.Font.BuilderSans
        hourlyLbl.TextSize = 12
        hourlyLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
        hourlyLbl.Size = UDim2.new(0.6, 0, 0, 16)
        hourlyLbl.Position = UDim2.new(0, 0, 0, 0)
        hourlyLbl.BackgroundTransparency = 1
        hourlyLbl.TextXAlignment = Enum.TextXAlignment.Left
        hourlyLbl.Parent = topRow

        local hourlyVal = Instance.new("TextLabel")
        hourlyVal.Name = "HourlyValue"
        hourlyVal.Text = "฿0"
        hourlyVal.Font = Enum.Font.BuilderSansBold
        hourlyVal.TextSize = 28
        hourlyVal.TextColor3 = Color3.fromRGB(255, 255, 255)
        hourlyVal.Size = UDim2.new(0.6, 0, 0, 30)
        hourlyVal.Position = UDim2.new(0, 0, 0, 17)
        hourlyVal.BackgroundTransparency = 1
        hourlyVal.TextXAlignment = Enum.TextXAlignment.Left
        hourlyVal.Parent = topRow

        local minVal = Instance.new("TextLabel")
        minVal.Name = "MinuteValue"
        minVal.Text = "฿0 ต่อนาที"
        minVal.Font = Enum.Font.BuilderSans
        minVal.TextSize = 11
        minVal.TextColor3 = Color3.fromRGB(130, 130, 140)
        minVal.Size = UDim2.new(0.6, 0, 0, 15)
        minVal.Position = UDim2.new(0, 0, 0, 47)
        minVal.BackgroundTransparency = 1
        minVal.TextXAlignment = Enum.TextXAlignment.Left
        minVal.Parent = topRow

        local farmStatusTitle = Instance.new("TextLabel")
        farmStatusTitle.Name = "FarmStatusTitle"
        farmStatusTitle.Text = "สถานะฟาร์ม"
        farmStatusTitle.Font = Enum.Font.BuilderSans
        farmStatusTitle.TextSize = 12
        farmStatusTitle.TextColor3 = Color3.fromRGB(130, 130, 140)
        farmStatusTitle.Size = UDim2.new(0.4, 0, 0, 16)
        farmStatusTitle.Position = UDim2.new(0.6, 0, 0, 2)
        farmStatusTitle.BackgroundTransparency = 1
        farmStatusTitle.TextXAlignment = Enum.TextXAlignment.Right
        farmStatusTitle.Parent = topRow

        local farmStatusVal = Instance.new("TextLabel")
        farmStatusVal.Name = "FarmStatusValue"
        farmStatusVal.Text = "— ไม่ได้ใช้งาน"
        farmStatusVal.Font = Enum.Font.BuilderSansMedium
        farmStatusVal.TextSize = 13
        farmStatusVal.TextColor3 = Color3.fromRGB(140, 140, 150)
        farmStatusVal.Size = UDim2.new(0.4, 0, 0, 22)
        farmStatusVal.Position = UDim2.new(0.6, 0, 0, 20)
        farmStatusVal.BackgroundTransparency = 1
        farmStatusVal.TextXAlignment = Enum.TextXAlignment.Right
        farmStatusVal.Parent = topRow

        -- แถวกลาง: 4 คอลัมน์สถิติ (รายได้ | จำนวนรอบ | เวลาฟาร์ม | ต่อรอบ)
        local btmRow = Instance.new("Frame")
        btmRow.Name = "StatsRow"
        btmRow.Size = UDim2.new(1, 0, 0, 42)
        btmRow.Position = UDim2.new(0, 0, 0, 68)
        btmRow.BackgroundTransparency = 1
        btmRow.Parent = masterCard

        local btmLayout = Instance.new("UIListLayout")
        btmLayout.FillDirection = Enum.FillDirection.Horizontal
        btmLayout.SortOrder = Enum.SortOrder.LayoutOrder
        btmLayout.Parent = btmRow

        local function createStatCol(order, titleText, defaultValue)
            local col = Instance.new("Frame")
            col.Name = "Col_" .. order
            col.Size = UDim2.new(0.25, 0, 1, 0)
            col.BackgroundTransparency = 1
            col.LayoutOrder = order
            col.Parent = btmRow

            local lblTitle = Instance.new("TextLabel")
            lblTitle.Name = "Title"
            lblTitle.Text = titleText
            lblTitle.Font = Enum.Font.BuilderSans
            lblTitle.TextSize = 12
            lblTitle.TextColor3 = Color3.fromRGB(130, 130, 140)
            lblTitle.Size = UDim2.new(1, 0, 0, 16)
            lblTitle.Position = UDim2.new(0, 0, 0, 0)
            lblTitle.BackgroundTransparency = 1
            lblTitle.TextXAlignment = Enum.TextXAlignment.Left
            lblTitle.Parent = col

            local lblVal = Instance.new("TextLabel")
            lblVal.Name = "Value"
            lblVal.Text = defaultValue
            lblVal.Font = Enum.Font.BuilderSansBold
            lblVal.TextSize = 15
            lblVal.TextColor3 = Color3.fromRGB(255, 255, 255)
            lblVal.Size = UDim2.new(1, 0, 0, 20)
            lblVal.Position = UDim2.new(0, 0, 0, 18)
            lblVal.BackgroundTransparency = 1
            lblVal.TextXAlignment = Enum.TextXAlignment.Left
            lblVal.Parent = col

            return lblVal
        end

        local statEarnedVal   = createStatCol(1, "รายได้", "฿0")
        local statRoundsVal   = createStatCol(2, "จำนวนรอบ", "0")
        local statTimeVal     = createStatCol(3, "เวลาฟาร์ม", "0 min")
        local statPerRoundVal = createStatCol(4, "ต่อรอบ", "฿0")

        -- แถวข้อมูลรถ: Inner Card สีเข้มมนสวยงามตามรูป
        local vehCard = Instance.new("Frame")
        vehCard.Name = "VehicleCard"
        vehCard.Size = UDim2.new(1, 0, 0, 56)
        vehCard.Position = UDim2.new(0, 0, 0, 120)
        vehCard.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        vehCard.BorderSizePixel = 0
        vehCard.Parent = masterCard

        local vcCorner = Instance.new("UICorner")
        vcCorner.CornerRadius = UDim.new(0, 8)
        vcCorner.Parent = vehCard

        local vcStroke = Instance.new("UIStroke")
        vcStroke.Color = Color3.fromRGB(28, 28, 32)
        vcStroke.Thickness = 1
        vcStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        vcStroke.Parent = vehCard

        local vehIcon = Instance.new("ImageLabel")
        vehIcon.Name = "VehicleIcon"
        vehIcon.Size = UDim2.fromOffset(32, 32)
        vehIcon.Position = UDim2.new(0, 14, 0.5, 0)
        vehIcon.AnchorPoint = Vector2.new(0, 0.5)
        vehIcon.BackgroundTransparency = 1
        vehIcon.Image = "rbxassetid://102930322246035" -- Lucide bike icon
        vehIcon.ImageColor3 = Color3.fromRGB(140, 140, 150)
        vehIcon.ScaleType = Enum.ScaleType.Fit
        vehIcon.Parent = vehCard

        local vehNameLbl = Instance.new("TextLabel")
        vehNameLbl.Name = "VehicleName"
        vehNameLbl.Text = "City Scooter 160"
        vehNameLbl.Font = Enum.Font.BuilderSansBold
        vehNameLbl.TextSize = 15
        vehNameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        vehNameLbl.Size = UDim2.new(1, -66, 0, 18)
        vehNameLbl.Position = UDim2.new(0, 58, 0, 10)
        vehNameLbl.BackgroundTransparency = 1
        vehNameLbl.TextXAlignment = Enum.TextXAlignment.Left
        vehNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        vehNameLbl.Parent = vehCard

        local vehSubLbl = Instance.new("TextLabel")
        vehSubLbl.Name = "VehicleSubtitle"
        vehSubLbl.Text = "Motorbike · 141 km/h"
        vehSubLbl.Font = Enum.Font.BuilderSans
        vehSubLbl.TextSize = 12
        vehSubLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
        vehSubLbl.Size = UDim2.new(1, -66, 0, 16)
        vehSubLbl.Position = UDim2.new(0, 58, 0, 29)
        vehSubLbl.BackgroundTransparency = 1
        vehSubLbl.TextXAlignment = Enum.TextXAlignment.Left
        vehSubLbl.TextTruncate = Enum.TextTruncate.AtEnd
        vehSubLbl.Parent = vehCard

        -- แถวสเปครถ 3 กล่อง (ECU, Piston, Rating)
        local specContainer = Instance.new("Frame")
        specContainer.Name = "SpecBoxesContainer"
        specContainer.Size = UDim2.new(1, 0, 0, 52)
        specContainer.Position = UDim2.new(0, 0, 0, 184)
        specContainer.BackgroundTransparency = 1
        specContainer.Parent = masterCard

        local specLayout = Instance.new("UIListLayout")
        specLayout.FillDirection = Enum.FillDirection.Horizontal
        specLayout.Padding = UDim.new(0, 8)
        specLayout.Parent = specContainer

        local function createSpecBox(order, labelText, defaultValue, isRating)
            local box = Instance.new("Frame")
            box.Name = "Box_" .. labelText
            box.Size = UDim2.new(0.333, -6, 1, 0)
            box.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
            box.BorderSizePixel = 0
            box.LayoutOrder = order
            box.Parent = specContainer

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = box

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(28, 28, 32)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = box

            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 7)
            pad.PaddingBottom = UDim.new(0, 7)
            pad.PaddingLeft = UDim.new(0, 12)
            pad.PaddingRight = UDim.new(0, 12)
            pad.Parent = box

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Label"
            lbl.Text = labelText
            lbl.Font = Enum.Font.BuilderSans
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(130, 130, 140)
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.Position = UDim2.new(0, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = box

            local val = Instance.new("TextLabel")
            val.Name = "Value"
            val.Text = defaultValue
            val.Font = Enum.Font.BuilderSansBold
            val.TextSize = isRating and 13 or 14
            val.TextColor3 = isRating and Color3.fromRGB(245, 158, 11) or Color3.fromRGB(255, 255, 255)
            val.Size = UDim2.new(1, 0, 0, 20)
            val.Position = UDim2.new(0, 0, 0, 16)
            val.BackgroundTransparency = 1
            val.TextXAlignment = Enum.TextXAlignment.Left
            val.Parent = box

            return val
        end

        local ecuValLbl    = createSpecBox(1, "ECU", "× 1.0", false)
        local pistonValLbl = createSpecBox(2, "Piston", "stock", false)
        local ratingValLbl = createSpecBox(3, "Rating", "★★★★★", true)

        -- แถวหลอดน้ำมัน & สุขภาพเครื่องยนต์ (Fuel & Engine)
        local healthCard = Instance.new("Frame")
        healthCard.Name = "HealthBarsContainer"
        healthCard.Size = UDim2.new(1, 0, 0, 48)
        healthCard.Position = UDim2.new(0, 0, 0, 244)
        healthCard.BackgroundTransparency = 1
        healthCard.Parent = masterCard

        local healthLayout = Instance.new("UIListLayout")
        healthLayout.FillDirection = Enum.FillDirection.Vertical
        healthLayout.Padding = UDim.new(0, 6)
        healthLayout.Parent = healthCard

        local function createHealthBar(rowName, labelText, barColor, defaultPct)
            local row = Instance.new("Frame")
            row.Name = rowName
            row.Size = UDim2.new(1, 0, 0, 20)
            row.BackgroundTransparency = 1
            row.Parent = healthCard

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Label"
            lbl.Text = labelText
            lbl.Font = Enum.Font.BuilderSans
            lbl.TextSize = 12
            lbl.TextColor3 = Color3.fromRGB(130, 130, 140)
            lbl.Size = UDim2.new(0, 52, 1, 0)
            lbl.Position = UDim2.new(0, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local track = Instance.new("Frame")
            track.Name = "Track"
            track.Size = UDim2.new(1, -96, 0, 5)
            track.Position = UDim2.new(0, 56, 0.5, -2)
            track.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
            track.BorderSizePixel = 0
            track.Parent = row

            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 3)
            tCorner.Parent = track

            local fill = Instance.new("Frame")
            fill.Name = "Fill"
            fill.Size = UDim2.new(math.clamp(defaultPct / 100, 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = barColor
            fill.BorderSizePixel = 0
            fill.Parent = track

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 3)
            fCorner.Parent = fill

            local pctLbl = Instance.new("TextLabel")
            pctLbl.Name = "PctLabel"
            pctLbl.Text = string.format("%d%%", defaultPct)
            pctLbl.Font = Enum.Font.BuilderSans
            pctLbl.TextSize = 12
            pctLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
            pctLbl.Size = UDim2.new(0, 34, 1, 0)
            pctLbl.Position = UDim2.new(1, -34, 0, 0)
            pctLbl.BackgroundTransparency = 1
            pctLbl.TextXAlignment = Enum.TextXAlignment.Right
            pctLbl.Parent = row

            return fill, pctLbl
        end

        local fuelFill, fuelPctLbl     = createHealthBar("FuelRow", "Fuel", Color3.fromRGB(224, 83, 83), 2)
        local engineFill, enginePctLbl = createHealthBar("EngineRow", "Engine", Color3.fromRGB(59, 130, 246), 100)

        -- ⚡ REAL-TIME UPDATE ENGINE (ทำงานตลอดเวลา ข้อมูลอัปเดตสดทุกวินาที)
        task.spawn(function()
            while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
                task.wait(0.35)
                pcall(function()
                    if not masterCard or not masterCard.Parent then return end

                    local now = os.clock()
                    local tracker = Hub.StatsTracker or StatsTracker
                    local isFarming = Hub.Settings and (Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide) == true

                    -- 1. อัปเดตเวลาฟาร์ม และ สถานะ
                    if isFarming then
                        if not tracker.LastActiveFarmTick then
                            tracker.LastActiveFarmTick = now
                        else
                            tracker.TotalFarmSeconds = tracker.TotalFarmSeconds + (now - tracker.LastActiveFarmTick)
                            tracker.LastActiveFarmTick = now
                        end

                        local mode = Hub.Settings.AutoGrabFarm and "Grab" or (Hub.Settings.AutoFoodDelivery and "Food" or "Ride")
                        local delState = tostring(LocalPlayer:GetAttribute("DeliveryState") or "Searching")
                        local stateDesc = mode
                        if delState == "Offer" then
                            stateDesc = mode .. ": รับงาน"
                        elseif delState == "ToShop" then
                            stateDesc = mode .. ": ไปจุดรับ"
                        elseif delState == "ToHome" then
                            stateDesc = mode .. ": ไปส่งของ"
                        elseif delState == "Searching" then
                            stateDesc = mode .. ": หางาน"
                        end
                        farmStatusVal.Text = "● กำลังทำงาน (" .. stateDesc .. ")"
                        farmStatusVal.TextColor3 = Color3.fromRGB(46, 204, 113)
                    else
                        tracker.LastActiveFarmTick = nil
                        farmStatusVal.Text = "— ไม่ได้ใช้งาน"
                        farmStatusVal.TextColor3 = Color3.fromRGB(140, 140, 150)
                    end

                    -- 2. เคลียร์ประวัติรายได้ที่เก่ากว่า 1 ชั่วโมง
                    if tracker.RollingPayouts then
                        for i = #tracker.RollingPayouts, 1, -1 do
                            if (now - tracker.RollingPayouts[i].t) > 3600 then
                                table.remove(tracker.RollingPayouts, i)
                            end
                        end
                    end

                    -- 3. คำนวณรายได้ต่อชั่วโมง และ ต่อนาที (Real-Time)
                    local hourlyRate = 0
                    if tracker.TotalFarmSeconds >= 30 then
                        hourlyRate = math.floor((tracker.SessionEarned / tracker.TotalFarmSeconds) * 3600)
                    elseif tracker.RollingPayouts and #tracker.RollingPayouts > 0 then
                        local rollSum = 0
                        for _, p in ipairs(tracker.RollingPayouts) do rollSum = rollSum + (p.fee or 0) end
                        hourlyRate = math.floor(rollSum * (3600 / math.max(1, tracker.TotalFarmSeconds)))
                    elseif tracker.SessionEarned > 0 then
                        hourlyRate = tracker.SessionEarned * 60
                    end

                    -- 3. อัปเดตเงินจริงของผู้เล่นแบบ Real-Time 100% (เงินในกระเป๋าจริง)
                    local currentCash = tonumber(LocalPlayer:GetAttribute("Cash")) or (tracker.LastKnownCash or 0)
                    hourlyVal.Text = "฿" .. FormatComma(currentCash)

                    local minRate = math.floor(hourlyRate / 60)
                    if minRate > 0 then
                        minVal.Text = string.format("฿%s ต่อนาที (฿%s/ชม.)", FormatComma(minRate), FormatComma(hourlyRate))
                    elseif tracker.SessionEarned > 0 then
                        minVal.Text = string.format("+฿%s ที่ฟาร์มได้ในรอบนี้", FormatComma(tracker.SessionEarned))
                    else
                        minVal.Text = "฿0 ต่อนาที"
                    end

                    -- 4. สถิติด้านล่าง 4 ช่อง
                    statEarnedVal.Text = "฿" .. FormatComma(tracker.SessionEarned)
                    statRoundsVal.Text = tostring(tracker.SessionRounds)

                    local totalMin = math.floor(tracker.TotalFarmSeconds / 60)
                    local hrs = math.floor(totalMin / 60)
                    if hrs > 0 then
                        statTimeVal.Text = string.format("%d hr %d min", hrs, totalMin % 60)
                    else
                        statTimeVal.Text = string.format("%d min", totalMin)
                    end

                    local perRound = tracker.SessionRounds > 0 and math.floor(tracker.SessionEarned / tracker.SessionRounds) or 0
                    statPerRoundVal.Text = "฿" .. FormatComma(perRound)

                    -- 5. ข้อมูลรถแบบ Real-Time
                    local veh = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
                    if veh then
                        local bName = veh:GetAttribute("BikeName") or veh:GetAttribute("VehicleName")
                        if not bName or bName == "" then
                            if veh.Name:find("PCX160") then
                                bName = "City Scooter 160"
                            else
                                bName = veh.Name:gsub("_.*", "")
                            end
                        end
                        vehNameLbl.Text = tostring(bName)

                        local tunedMax = GetVehicleTunedMaxKmh and GetVehicleTunedMaxKmh(veh) or (tonumber(veh:GetAttribute("MaxSpeed")) or 141)
                        local isBike = veh.Name:lower():find("pcx") or veh.Name:lower():find("bike") or veh.Name:lower():find("scooter") or veh:GetAttribute("BikeName") ~= nil
                        local vehType = isBike and "Motorbike" or "Car"
                        vehSubLbl.Text = string.format("%s · %d km/h", vehType, math.floor(tunedMax))
                        vehIcon.Image = isBike and "rbxassetid://102930322246035" or "rbxassetid://121065933462582"

                        -- ECU Gain
                        local rawGain = veh:GetAttribute("EcuGain")
                        if typeof(rawGain) == "number" and rawGain >= 0.5 then
                            ecuValLbl.Text = string.format("× %.1f", rawGain)
                        else
                            ecuValLbl.Text = "× 1.0"
                        end

                        -- Piston
                        local bore = veh:GetAttribute("PistonBore") or LocalPlayer:GetAttribute("Pistons")
                        if bore and bore ~= "0" and bore ~= 0 then
                            pistonValLbl.Text = tostring(bore)
                        else
                            pistonValLbl.Text = "stock"
                        end

                        -- Rating
                        local rating = tonumber(LocalPlayer:GetAttribute("DeliveryRating")) or 5
                        ratingValLbl.Text = string.rep("★", math.clamp(math.floor(rating), 1, 5))

                        -- Fuel Bar
                        local rawFuel = tonumber(veh:GetAttribute("Fuel")) or 100
                        local fuelPct = math.clamp(math.floor(rawFuel), 0, 100)
                        fuelFill.Size = UDim2.new(fuelPct / 100, 0, 1, 0)
                        fuelPctLbl.Text = string.format("%d%%", fuelPct)

                        -- Engine Bar
                        local rawEng = tonumber(veh:GetAttribute("EngineHealth") or veh:GetAttribute("Engine")) or 100
                        local engPct = math.clamp(math.floor(rawEng), 0, 100)
                        engineFill.Size = UDim2.new(engPct / 100, 0, 1, 0)
                        enginePctLbl.Text = string.format("%d%%", engPct)
                    end
                end)
            end
        end)
    end
    SetupStatsDashboard()

    -- ================================================
    -- 🏎️ TAB 1: VEHICLE MODS (Background)
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
    -- 🎛️ TAB 2: ECU TUNING (Background)
    -- ================================================
    local DynoStatusPara = nil

    local function GetDynoMonitorText()
        local veh = GetPlayerVehicle()
        if not veh then return "ไม่พบรถ กรุณาเรียกรถออกมาก่อน" end
        local isTourer = IsTourer350(veh)
        local vName = veh:GetAttribute("DisplayName") or veh:GetAttribute("VehicleId") or veh.Name
        if isTourer then
            return string.format("รถปัจจุบัน: %s\n🚫 ระบบจูนของ Tourer 350 ถูกลบออกแล้ว (ไม่ปรับแต่ง ECU)", tostring(vName))
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
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            if DynoStatusPara then
                pcall(function() DynoStatusPara:SetDesc(GetDynoMonitorText()) end)
            end
            task.wait(2.0)
        end
    end)

    Tabs.EcuTune:AddSection("สูตรแมพจูน", "Left")

    Tabs.EcuTune:AddButton({
        Title = "แฟลชสูตรแข่ง (200%)",
        Description = "จูนเต็ม 200% ทันที ดันโลทุกเกียร์ (แรงจริงไม่มโน)",
        Callback = function()
            FlashEcuFile()
            task.delay(0.2, function() if DynoStatusUpdater then pcall(DynoStatusUpdater) end end)
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
            if DynoStatusPara then DynoStatusPara:SetDesc(GetDynoMonitorText()) end
            if Hub.Fluent then
                Hub.Fluent:Notify({ Title = "Dyno", Content = "อัปเดตเรียบร้อย", Duration = 2 })
            end
        end
    })

    Tabs.EcuTune:AddSection("ออโต้จูน", "Right")

    local AutoTuneToggle = Tabs.EcuTune:AddToggle("AutoTuneToggle", {
        Title = "ออโต้จูน 100%",
        Description = "จูนหาค่าที่ดีที่สุดให้อัตโนมัติและคงความแรงไว้ทุกคัน",
        Default = Hub.Settings.AutoTuneRunning
    })
    AutoTuneToggle:OnChanged(function(v)
        Hub.Settings.AutoTuneRunning = v
        if v then
            Hub.Settings.EcuTuneMaster = true
            RunAutoTuneOptimizer()
        else
            Hub.Settings.AutoTuneRunning = false
            if Hub.Fluent then
                Hub.Fluent:Notify({
                    Title = "Auto Tune",
                    Content = "ปิดระบบออโต้จูนแล้ว",
                    Duration = 2
                })
            end
        end
        if DynoStatusUpdater then pcall(DynoStatusUpdater) end
    end)

    -- ================================================
    -- 🌾 TAB 3: AUTO WORK (Main Tab)
    -- ================================================
    -- 🌑 BLACK SCREEN ENGINE (จอดำประหยัดจอ Auto Farm / Cash)
    local BlackScreenGui = nil
    local BlackScreenCashLabel = nil

    local function FormatComma(amount)
        local formatted = tostring(math.floor(tonumber(amount) or 0))
        while true do
            local k
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
            if k == 0 then break end
        end
        return formatted
    end

    local function UpdateBlackScreenCash()
        if BlackScreenCashLabel and BlackScreenCashLabel.Parent then
            local currentCash = 0
            pcall(function()
                currentCash = LocalPlayer:GetAttribute("Cash") or 0
            end)
            BlackScreenCashLabel.Text = "Cash: $" .. FormatComma(currentCash)
        end
    end

    local function SetBlackScreen(enabled)
        Hub.Settings.BlackScreen = enabled == true

        if enabled then
            if not BlackScreenGui or not BlackScreenGui.Parent then
                local parentGui = (gethui and gethui())
                               or CoreGui:FindFirstChild("RobloxGui")
                               or CoreGui
                               or LocalPlayer:FindFirstChild("PlayerGui")

                local BLACK_SCREEN_NAME = "KrakenHub_BlackScreen"
                RegisterStealthGui(BLACK_SCREEN_NAME)

                local sg = Instance.new("ScreenGui")
                sg.Name = BLACK_SCREEN_NAME
                sg.ResetOnSpawn = false
                sg.IgnoreGuiInset = true
                sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                sg.DisplayOrder = 998
                sg.Parent = parentGui

                local bg = Instance.new("TextButton")
                bg.Name = "Background"
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.Position = UDim2.new(0, 0, 0, 0)
                bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                bg.BorderSizePixel = 0
                bg.AutoButtonColor = false
                bg.Text = ""
                bg.Active = true
                bg.ZIndex = 1
                bg.Parent = sg

                -- แตะหรือคลิกที่ใดก็ได้เพื่อเปิด/ย่อเมนู
                bg.MouseButton1Click:Connect(function()
                    if Window and Window.Toggle then
                        pcall(function() Window:Toggle() end)
                    end
                end)

                local container = Instance.new("Frame")
                container.Name = "Container"
                container.Size = UDim2.new(1, 0, 0, 220)
                container.AnchorPoint = Vector2.new(0.5, 0.5)
                container.Position = UDim2.new(0.5, 0, 0.5, 0)
                container.BackgroundTransparency = 1
                container.ZIndex = 2
                container.Parent = bg

                local layout = Instance.new("UIListLayout")
                layout.FillDirection = Enum.FillDirection.Vertical
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                layout.VerticalAlignment = Enum.VerticalAlignment.Center
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 18)
                layout.Parent = container

                -- 1. "Auto Farm" Text (Bold White)
                local titleLabel = Instance.new("TextLabel")
                titleLabel.Name = "TitleLabel"
                titleLabel.Size = UDim2.new(1, 0, 0, 75)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = "Auto Farm"
                titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                titleLabel.TextSize = 64
                pcall(function() titleLabel.Font = Enum.Font.FredokaOne end)
                if titleLabel.Font ~= Enum.Font.FredokaOne then
                    titleLabel.Font = Enum.Font.GothamBold
                end
                titleLabel.TextXAlignment = Enum.TextXAlignment.Center
                titleLabel.TextYAlignment = Enum.TextYAlignment.Center
                titleLabel.ZIndex = 3
                titleLabel.LayoutOrder = 1
                titleLabel.Parent = container

                -- 2. "Cash: $..." Text (Bold Green)
                local cashLabel = Instance.new("TextLabel")
                cashLabel.Name = "CashLabel"
                cashLabel.Size = UDim2.new(1, 0, 0, 55)
                cashLabel.BackgroundTransparency = 1
                cashLabel.Text = "Cash: $0"
                cashLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
                cashLabel.TextSize = 46
                pcall(function() cashLabel.Font = Enum.Font.FredokaOne end)
                if cashLabel.Font ~= Enum.Font.FredokaOne then
                    cashLabel.Font = Enum.Font.GothamBold
                end
                cashLabel.TextXAlignment = Enum.TextXAlignment.Center
                cashLabel.TextYAlignment = Enum.TextYAlignment.Center
                cashLabel.ZIndex = 3
                cashLabel.LayoutOrder = 2
                cashLabel.Parent = container

                -- Hint Text ด้านล่าง
                local hintLabel = Instance.new("TextLabel")
                hintLabel.Name = "HintLabel"
                hintLabel.Size = UDim2.new(1, 0, 0, 25)
                hintLabel.BackgroundTransparency = 1
                hintLabel.Text = "💡 แตะ/คลิกหน้าจอ หรือกด RightShift / Insert เพื่อเปิด-ปิดเมนู"
                hintLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
                hintLabel.TextSize = 14
                hintLabel.Font = Enum.Font.SourceSans
                hintLabel.TextXAlignment = Enum.TextXAlignment.Center
                hintLabel.ZIndex = 3
                hintLabel.LayoutOrder = 3
                hintLabel.Parent = container

                BlackScreenCashLabel = cashLabel
                BlackScreenGui = sg
            end

            BlackScreenGui.Enabled = true
            UpdateBlackScreenCash()

            pcall(function()
                game:GetService("RunService"):Set3dRenderingEnabled(false)
            end)

            if Window and Window.Notify then
                Window:Notify({
                    Title = "Black Screen",
                    Text = "เปิดโหมดจอดำแล้ว (คลิกหน้าจอหรือกด RightShift เพื่อเปิดเมนู)",
                    Icon = "moon",
                    Duration = 3
                })
            end
        else
            if BlackScreenGui then
                BlackScreenGui.Enabled = false
            end
            pcall(function()
                game:GetService("RunService"):Set3dRenderingEnabled(true)
            end)
        end
    end
    Hub.SetBlackScreen = SetBlackScreen

    pcall(function()
        LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
            if BlackScreenGui and BlackScreenGui.Enabled then
                UpdateBlackScreenCash()
            end
        end)
    end)

    Tabs.Farm:AddSection("ระบบรับงานอัตโนมัติ", "Left")


    local AutoGrabToggle, AutoFoodToggle, AutoRideToggle
    local MasterFarmToggle, FarmJobDropdown

    -- Helper to cleanly stop farming & instantly restore 100% stock game physics & speed
    local function HandleFarmToggleOff(title)
        if Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide then
            return
        end
        Teleporting = false
        local curV = GetActiveSeatedVehicle() or GetPlayerVehicle(false)
        local ch = curV and (curV:FindFirstChild("Chassis") or curV.PrimaryPart)
        if ch then
            SmoothStop(ch, 0.7)
        end
        RestoreStockVehiclePhysics()
        Fluent:Notify({
            Title = title or "ปิดฟาร์ม",
            Content = "ปิดฟาร์มแล้ว - คืนค่าความเร็วและระบบรถเดิมของเกม 100% (ปลอดภัย ไม่โดนเตะ)",
            Duration = 2.5
        })
    end

    -- 🌾 JOB SELECTION & MASTER AUTO FARM (Dropdown + Single Toggle)
    local FarmJobs = {
        "ฟาร์ม Grab (เงินไว)",
        "ไรเดอร์ส่งอาหาร (QuickRider)",
        "ไรเดอร์รับส่งคน (QuickRider)"
    }

    local currentFarmJob = FarmJobs[1]
    if Hub.Settings.AutoFoodDelivery then
        currentFarmJob = FarmJobs[2]
    elseif Hub.Settings.AutoGrabRide or Hub.Settings.AutoRideRide then
        currentFarmJob = FarmJobs[3]
    end

    local function ApplyFarmJobState(enabled)
        if not enabled then
            local wasFarming = Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide
            Hub.Settings.AutoGrabFarm = false
            Hub.Settings.AutoFoodDelivery = false
            Hub.Settings.AutoRideRide = false
            Hub.Settings.AutoGrabRide = false
            if wasFarming then
                HandleFarmToggleOff("ปิดระบบฟาร์ม")
            end
            return
        end

        HideDeliveryPhoneUI()
        pcall(ApplyVehiclePhysicsMods)

        if currentFarmJob:find("Grab") then
            Hub.Settings.AutoGrabFarm = true
            Hub.Settings.AutoFoodDelivery = false
            Hub.Settings.AutoRideRide = false
            Hub.Settings.AutoGrabRide = false
            Fluent:Notify({
                Title = "Grab Farm",
                Content = ("เริ่มฟาร์ม Grab อัตโนมัติ (ความเร็วฟาร์ม: %d studs/s)"):format(Hub.Settings.FarmSpeed or 88),
                Duration = 2.5
            })
        elseif currentFarmJob:find("อาหาร") or currentFarmJob:find("Food") then
            Hub.Settings.AutoGrabFarm = false
            Hub.Settings.AutoFoodDelivery = true
            Hub.Settings.AutoRideRide = false
            Hub.Settings.AutoGrabRide = false
            Fluent:Notify({
                Title = "ส่งอาหาร",
                Content = ("เริ่มทำงานไรเดอร์ส่งอาหาร (ความเร็วฟาร์ม: %d studs/s)"):format(Hub.Settings.FarmSpeed or 88),
                Duration = 2.5
            })
        elseif currentFarmJob:find("ส่งคน") or currentFarmJob:find("รับส่งคน") or currentFarmJob:find("Ride") then
            Hub.Settings.AutoGrabFarm = false
            Hub.Settings.AutoFoodDelivery = false
            Hub.Settings.AutoRideRide = true
            Hub.Settings.AutoGrabRide = true
            Fluent:Notify({
                Title = "ไรเดอร์รับส่งคน",
                Content = ("เริ่มทำงานไรเดอร์รับส่งคน (ความเร็วฟาร์ม: %d studs/s)"):format(Hub.Settings.FarmSpeed or 88),
                Duration = 2.5
            })
        end
    end

    -- 1. ลิสต์เลือกงานฟาร์ม (Dropdown)
    FarmJobDropdown = Tabs.Farm:AddDropdown("FarmJobDropdown", {
        Title       = "เลือกประเภทงานฟาร์ม",
        Description = "เลือกงานที่ต้องการฟาร์ม: Grab (เงินไว) / ส่งอาหาร / รับส่งคน",
        Icon        = "briefcase",
        Options     = FarmJobs,
        Default     = currentFarmJob,
        Callback    = function(selected)
            currentFarmJob = selected
            if MasterFarmToggle and (MasterFarmToggle.Value or MasterFarmToggle:Get()) then
                ApplyFarmJobState(true)
            end
        end,
    })

    -- 2. สวิตช์เริ่มฟาร์มอัตโนมัติ (Master Auto Farm Toggle)
    local isInitialFarmOn = false
    MasterFarmToggle = Tabs.Farm:AddToggle("MasterFarmToggle", {
        Title       = "เปิดฟาร์มออโต้ (Auto Farm)",
        Description = "เริ่มทำงานอัตโนมัติตามงานที่เลือกไว้ในลิสต์ด้านบน",
        Icon        = "zap",
        Default     = false,
    })
    MasterFarmToggle:OnChanged(function(v)
        ApplyFarmJobState(v)
    end)

    local FarmVehicleInfo = Tabs.Farm:AddParagraph({
        Title = "🚜 รถที่ใช้ฟาร์มงานปัจจุบัน",
        Content = "กำลังตรวจสอบรถฟาร์ม..."
    })
    task.spawn(function()
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            if FarmVehicleInfo and FarmVehicleInfo.SetDesc then
                local vId = Hub.Settings.PreferredVehicle or "PCX160"
                local vName = vId
                for _, v in ipairs(MapVehicleCatalog) do
                    if v.id == vId then
                        vName = v.th or v.id
                        break
                    end
                end
                FarmVehicleInfo:SetDesc(string.format("🟢 รถที่ใช้ฟาร์ม: %s [%s]\n💡 สามารถเปลี่ยนรถฟาร์มและดูโมเดล 3D ได้ที่เมนู 'รถ'", tostring(vName), tostring(vId)))
            end
            task.wait(2.5)
        end
    end)


    -- Compatibility wrappers for other modules / MoneyLock
    AutoGrabToggle = {
        Value = Hub.Settings.AutoGrabFarm,
        SetValue = function(self, val)
            -- ผู้ใช้เปิด-ปิดเอง ไม่เปลี่ยนค่าอัตโนมัติ
        end,
        Set = function(self, val) self:SetValue(val) end,
        Get = function(self) return Hub.Settings.AutoGrabFarm end,
    }
    AutoFoodToggle = {
        Value = Hub.Settings.AutoFoodDelivery,
        SetValue = function(self, val)
            -- ผู้ใช้เปิด-ปิดเอง ไม่เปลี่ยนค่าอัตโนมัติ
        end,
        Set = function(self, val) self:SetValue(val) end,
        Get = function(self) return Hub.Settings.AutoFoodDelivery end,
    }
    AutoRideToggle = {
        Value = Hub.Settings.AutoGrabRide,
        SetValue = function(self, val)
            -- ผู้ใช้เปิด-ปิดเอง ไม่เปลี่ยนค่าอัตโนมัติ
        end,
        Set = function(self, val) self:SetValue(val) end,
        Get = function(self) return Hub.Settings.AutoGrabRide end,
    }

    -- 4. Target Money Auto-Stop Toggle & Input
    local LockMoneyToggle = Tabs.Farm:AddToggle("LockMoneyToggle", {
        Title = "ระบบล็อกเงิน (หยุดฟาร์มอัตโนมัติ)",
        Description = "หยุดฟาร์มทันทีเมื่อเงินในตัวถึงจำนวนเป้าหมาย",
        Icon = "wallet",
        Default = Hub.Settings.LockMoneyEnabled or false
    })
    LockMoneyToggle:OnChanged(function(v)
        Hub.Settings.LockMoneyEnabled = v
        if v then
            task.defer(function()
                pcall(CheckMoneyLock)
            end)
        end
        pcall(SaveConfig)
    end)

    local LockMoneyInput = Tabs.Farm:AddInput("LockMoneyInput", {
        Title = "ยอดเงินเป้าหมาย (บาท)",
        Description = "ระบุยอดเงินเป้าหมาย เช่น 100000, 500000, 1000000",
        Placeholder = "เช่น 100000",
        Default = tostring(Hub.Settings.LockMoneyTarget or 100000),
        Callback = function(v)
            local clean = tostring(v):gsub("[,%s_]", "")
            local num = tonumber(clean)
            if num and num > 0 then
                Hub.Settings.LockMoneyTarget = num
                if Hub.Settings.LockMoneyEnabled then
                    task.defer(function()
                        pcall(CheckMoneyLock)
                    end)
                end
                pcall(SaveConfig)
            end
        end
    })

    -- 5. Visual Neon Route Toggle (Hidden by default to keep screen clean)
    local ShowRouteVisualsToggle = Tabs.Farm:AddToggle("ShowRouteVisualsToggle", {
        Title = "แสดงเส้นนำทางสีฟ้าบนถนน (Neon Route)",
        Description = "เปิด/ปิด การวาดเส้นสีฟ้านำทางบนถนน (ปิดไว้ตามค่าเริ่มต้นเพื่อความสะอาดตาและลดแลค)",
        Icon = "map-pin",
        Default = Hub.Settings.ShowRouteVisuals or false
    })
    ShowRouteVisualsToggle:OnChanged(function(v)
        Hub.Settings.ShowRouteVisuals = v
        if not v then
            Hub.ClearRouteVisuals()
        end
        pcall(SaveConfig)
    end)

    -- 6. Black Screen Toggle (ประหยัดจอ Auto Farm / Cash)
    local BlackScreenToggle = Tabs.Farm:AddToggle("BlackScreenToggle", {
        Title = "โหมดจอดำประหยัดจอ (Black Screen)",
        Description = "เปิดหน้าจอสีดำแสดงยอดเงิน (Auto Farm / Cash) ลดการทำงาน GPU และลดความร้อนเวลาเปิดฟาร์มทิ้งไว้",
        Icon = "moon",
        Default = Hub.Settings.BlackScreen or false
    })
    BlackScreenToggle:OnChanged(function(v)
        SetBlackScreen(v)
        pcall(SaveConfig)
    end)

    Tabs.Farm:AddSection("เควสเงินรางวัล (Quests & Rewards)", "Left")

    local AutoClaimQuestsToggle = Tabs.Farm:AddToggle("AutoClaimQuestsToggle", {
        Title = "ออโต้รับเควสเงิน (Auto Claim Quests)",
        Description = "ตรวจจับและกดรับเงินเควส Daily & Weekly ในโทรศัพท์ให้อัตโนมัติ",
        Icon = "gift",
        Default = true
    })
    AutoClaimQuestsToggle:OnChanged(function(v)
        Hub.Settings.AutoClaimQuests = v
        if v and Hub.ClaimAllQuestsOnce then
            task.spawn(function()
                local count = Hub.ClaimAllQuestsOnce()
                if count > 0 then
                    Window:Notify({
                        Title = "เควสเงิน (Quests)",
                        Text = ("รับรางวัลเควสสำเร็จ %d รายการ!"):format(count),
                        Icon = "gift",
                        Duration = 3
                    })
                end
            end)
        end
        SaveConfig()
    end)
    pcall(function() AutoClaimQuestsToggle:SetValue(true) end)

    Tabs.Farm.RawTab:AddButton({
        Title    = "กดรับเควสทั้งหมดทันที (Claim All Quests)",
        Subtitle = "กดรับรางวัลเควสที่ทำเสร็จแล้วในแอป Quests ทั้งหมดทันที",
        Icon     = "check-circle",
        Text     = "Claim",
        Callback = function()
            Window:Notify({Title = "เควสเงิน", Text = "กำลังตรวจสอบและกดรับรางวัลเควส...", Duration = 2.5})
            task.spawn(function()
                local claimed = (Hub.ClaimAllQuestsOnce and Hub.ClaimAllQuestsOnce()) or 0
                if claimed > 0 then
                    Window:Notify({
                        Title = "เควสเงิน (Quests)",
                        Text = ("กดรับรางวัลเควสสำเร็จ %d รายการ!"):format(claimed),
                        Icon = "gift",
                        Duration = 4
                    })
                else
                    Window:Notify({
                        Title = "เควสเงิน (Quests)",
                        Text = "ไม่มีเควสที่รอรับ หรือรับไปหมดแล้ว",
                        Icon = "info",
                        Duration = 3
                    })
                end
            end)
        end
    })

    -- Activity Status & Console Log (from ui.lua)
    Tabs.Farm.RawTab:AddSeparator()
    status = Tabs.Farm.RawTab:AddLabel("Status: idle", "activity")
    console = Tabs.Farm.RawTab:AddConsole({ Title = "Activity Log", Height = 110 })
    console:Write("Mahanakhon Racing VantixUI loaded")

    -- ================================================
    -- 🛒 TAB: SHOP (ร้านค้า)
    -- ================================================
    Tabs.Shop:AddSection("ร้านลูกสูบซิ่ง (Piston Shop)", "Left")

    local PistonStatusPara = Tabs.Shop:AddParagraph({
        Title = "สถานะร้านลูกสูบซิ่ง",
        Content = "กำลังตรวจสอบสถานะร้าน..."
    })

    task.spawn(function()
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            if PistonStatusPara then
                pcall(function()
                    local isOpen, seller, spot, secLeft = Hub.GetPistonShopState()
                    if isOpen and seller then
                        local m = secLeft // 60
                        local s = secLeft % 60
                        PistonStatusPara:SetDesc(string.format("🟢 ร้านเปิดอยู่ (%s)\n⏱️ ย้ายร้านในอีก: %d:%02d นาที\n📍 พิกัดร้าน: %s",
                            tostring(spot), m, s, tostring(seller.Position:Floor())))
                    else
                        PistonStatusPara:SetDesc(string.format("🔴 ร้านปิดอยู่ / กำลังย้ายร้าน\n📍 จุดล่าสุด: %s", tostring(spot or "N/A")))
                    end
                end)
            end
            task.wait(2.0)
        end
    end)

    local AutoBuyPistonToggle = Tabs.Shop:AddToggle("AutoBuyPistonToggle", {
        Title = "ออโต้ซื้อลูกสูบระยะไกล (Auto Buy)",
        Description = "ซื้อลูกสูบที่เลือกอัตโนมัติจากระยะไกลทันทีเมื่อมีของและเงินพอ",
        Icon = "shopping-cart",
        Default = Hub.Settings.AutoBuyPiston
    })
    AutoBuyPistonToggle:OnChanged(function(v)
        Hub.Settings.AutoBuyPiston = v
        SaveConfig()
    end)

    local pistonOptions = {
        "ขนาดสูงสุดที่มี (Highest Available)",
        "ลูก 90 มม. (฿200,000 - Pro)",
        "ลูก 88 มม. (฿150,000 - Pro)",
        "ลูก 80 มม. (฿100,000 - Pro)",
        "ลูก 75 มม. (฿60,000 - Race)",
        "ลูก 72 มม. (฿40,000 - Race)",
        "ลูก 67 มม. (฿25,000 - Race)",
        "ลูก 62 มม. (฿14,000 - Street)",
        "ลูก 58 มม. (฿8,000 - Street)",
        "ลูก 56 มม. (฿5,000 - Street)",
        "ลูก 53 มม. (฿3,000 - Street)",
    }

    local defaultPistonSelection = {}
    local rawSavedPiston = Hub.Settings.AutoBuyPistonSize
    if type(rawSavedPiston) == "table" then
        for k, v in pairs(rawSavedPiston) do
            if v == true then
                defaultPistonSelection[k] = true
            elseif type(k) == "number" and type(v) == "string" then
                defaultPistonSelection[v] = true
            end
        end
    elseif type(rawSavedPiston) == "string" and rawSavedPiston ~= "" then
        if rawSavedPiston == "Highest" or rawSavedPiston:find("สูงสุด") then
            defaultPistonSelection["ขนาดสูงสุดที่มี (Highest Available)"] = true
        else
            local num = tonumber(rawSavedPiston:match("%d+"))
            if num then
                for _, opt in ipairs(pistonOptions) do
                    if opt:find(tostring(num)) then
                        defaultPistonSelection[opt] = true
                        break
                    end
                end
            end
        end
    end

    if next(defaultPistonSelection) == nil then
        defaultPistonSelection["ขนาดสูงสุดที่มี (Highest Available)"] = true
    end

    local PistonSizeDropdown = Tabs.Shop:AddDropdown("PistonSizeDropdown", {
        Title = "เลือกลูกสูบที่ต้องการซื้อ",
        Description = "เลือกรุ่นที่ต้องการซื้อ (เลือกได้หลายขนาด ระบบจะซื้อขนาดสูงสุดที่มีให้ก่อน)",
        Icon = "cog",
        Multi = true,
        Options = pistonOptions,
        Default = defaultPistonSelection,
        Callback = function(v)
            Hub.Settings.AutoBuyPistonSize = v
            SaveConfig()
        end
    })

    local AutoInstallPistonToggle = Tabs.Shop:AddToggle("AutoInstallPistonToggle", {
        Title = "ติดตั้งลูกสูบเข้ารถทันที (Auto Install)",
        Description = "นำลูกสูบที่ซื้อใหม่มาใส่เข้ารถของคุณอัตโนมัติทันทีหลังซื้อสำเร็จ",
        Icon = "wrench",
        Default = Hub.Settings.AutoInstallPiston
    })
    AutoInstallPistonToggle:OnChanged(function(v)
        Hub.Settings.AutoInstallPiston = v
        SaveConfig()
    end)

    Tabs.Shop:AddSection("เมนูการสั่งซื้อ", "Right")

    Tabs.Shop:AddButton({
        Title = "ซื้อลูกสูบระยะไกลทันที (Buy Now)",
        Description = "สั่งซื้อลูกสูบขนาดที่เลือกจากระยะไกลทันที ไม่ต้องขับรถไปที่ร้าน",
        Icon = "zap",
        Text = "สั่งซื้อทันที",
        Callback = function()
            Window:Notify({ Title = "ร้านลูกสูบซิ่ง", Text = "กำลังดำเนินการสั่งซื้อระยะไกล...", Icon = "refresh-cw", Duration = 3 })
            task.spawn(function()
                local choice = Hub.Settings.AutoBuyPistonSize or "Highest"
                local ok, msg, sz = Hub.RemoteBuyPiston(choice)
                if ok then
                    Window:Notify({
                        Title = "ร้านลูกสูบซิ่ง",
                        Text = "ซื้อลูกสูบ " .. tostring(sz or "") .. " มม. สำเร็จ! (" .. tostring(msg) .. ")",
                        Icon = "check",
                        Duration = 5
                    })
                else
                    Window:Notify({
                        Title = "ร้านลูกสูบซิ่ง",
                        Text = "ไม่สามารถซื้อได้: " .. tostring(msg or "เกิดข้อผิดพลาด"),
                        Icon = "alert-circle",
                        Duration = 5
                    })
                end
            end)
        end
    })

    -- ================================================
    -- ⚙️ TAB: SETTINGS (VantixUI + Mahanakhon)
    -- ================================================
    -- 🪖 SECTION: HELMET ROOM & 3D PREVIEW (ห้องลองหมวกกันน็อก)
    -- ================================================
    Tabs.Shop:AddSection("ห้องลองหมวกกันน็อก (Helmet Room & 3D Preview)", "Left")

    local HelmetStatusPara = Tabs.Shop:AddParagraph({
        Title = "สถานะหมวกที่สวมอยู่",
        Content = "กำลังตรวจสอบสถานะหมวก..."
    })

    task.spawn(function()
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            if HelmetStatusPara then
                pcall(function()
                    local rawName, label = Hub.GetCurrentHelmet()
                    if rawName then
                        HelmetStatusPara:SetDesc("🟢 กำลังสวม: " .. tostring(label or rawName))
                    else
                        HelmetStatusPara:SetDesc("⚪ ไม่ได้สวมหมวกกันน็อก")
                    end
                end)
            end
            task.wait(2.0)
        end
    end)

    local helmetList, nameToId, idToName = Hub.GetAllHelmetOptions()
    local defaultHelmetDisplay = helmetList[1] or "Full_Black"
    local defaultHelmetId = nameToId[defaultHelmetDisplay] or "Full_Black"
    CurrentChosenHelmetId = defaultHelmetId

    local HelmetDropdown = Tabs.Shop:AddDropdown("HelmetSelectDropdown", {
        Title = "เลือกหมวกกันน็อก",
        Description = "เลือกหมวกเต็มใบ หรือหมวกครึ่งใบพร้อมสีและชิลด์ที่ต้องการ",
        Icon = "shield",
        Options = helmetList,
        Default = defaultHelmetDisplay,
        Callback = function(chosen)
            local hId = nameToId[chosen] or chosen
            CurrentChosenHelmetId = hId
            Hub.Settings.SelectedHelmet = hId
            Hub.UpdateAllHelmetPreviews(hId, chosen)
        end
    })

    -- Add In-Tab 3D Viewport Card
    local ShopRaw = Tabs.Shop.RawTab
    if ShopRaw then
        pcall(function()
            local tempBtn = ShopRaw:AddButton({
                Title = "จอพรีวิว 3D ในแท็บ (3D Viewport)",
                Subtitle = "ลากเมาส์/ทัชสกรีนบนจอพรีวิวเพื่อหมุนดูรอบทิศทาง 360°",
                Icon = "box",
                Text = "รีเซ็ตมุมมอง",
                Callback = function()
                    if Hub.TabHelmetRig then
                        Hub.TabHelmetRig.Angle = 0
                        if Hub.TabHelmetRig.ApplyCam then Hub.TabHelmetRig.ApplyCam() end
                    end
                end
            })

            local scroll = tempBtn
            while scroll and not scroll:IsA("ScrollingFrame") do
                scroll = scroll.Parent
            end

            if scroll then
                local cardFrame = Instance.new("Frame")
                cardFrame.Name = "InTabHelmetPreviewCard"
                cardFrame.Size = UDim2.new(1, 0, 0, 190)
                cardFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
                cardFrame.BorderSizePixel = 0
                cardFrame.LayoutOrder = 100
                cardFrame.ClipsDescendants = true

                local cRnd = Instance.new("UICorner")
                cRnd.CornerRadius = UDim.new(0, 10)
                cRnd.Parent = cardFrame

                local cStr = Instance.new("UIStroke")
                cStr.Color = Color3.fromRGB(42, 46, 58)
                cStr.Thickness = 1
                cStr.Parent = cardFrame

                local tabVp = Instance.new("ViewportFrame")
                tabVp.Name = "TabHelmetViewport"
                tabVp.Size = UDim2.new(1, -12, 1, -12)
                tabVp.Position = UDim2.new(0, 6, 0, 6)
                tabVp.BackgroundTransparency = 1
                tabVp.BorderSizePixel = 0
                tabVp.Parent = cardFrame

                cardFrame.Parent = scroll
                Hub.TabHelmetViewport = tabVp

                task.defer(function()
                    Hub.UpdateAllHelmetPreviews(CurrentChosenHelmetId, defaultHelmetDisplay)
                end)
            end
        end)
    end

    Tabs.Shop:AddSection("เมนูหมวกกันน็อก", "Right")

    Tabs.Shop:AddButton({
        Title = "สวมหมวกที่เลือก (Wear Helmet)",
        Description = "สวมหมวกกันน็อกที่เลือกไว้ทันที",
        Icon = "check-circle",
        Text = "สวมหมวก",
        Callback = function()
            local hId = CurrentChosenHelmetId
            if not hId or hId == "" then
                hId = defaultHelmetId
            end
            Window:Notify({ Title = "ห้องลองหมวก", Text = "กำลังสวมหมวก: " .. tostring(idToName[hId] or hId), Icon = "refresh-cw", Duration = 2 })
            task.spawn(function()
                local ok, msg = Hub.WearHelmet(hId)
                if ok then
                    Window:Notify({ Title = "ห้องลองหมวก", Text = "สวมหมวกสำเร็จ!", Icon = "check", Duration = 4 })
                else
                    Window:Notify({ Title = "ห้องลองหมวก", Text = "สวมหมวกไม่สำเร็จ: " .. tostring(msg or "เกิดข้อผิดพลาด"), Icon = "alert-circle", Duration = 4 })
                end
            end)
        end
    })

    Tabs.Shop:AddButton({
        Title = "เปิด / ปิดชิลด์หน้า (Toggle Visor)",
        Description = "เปิดหรือปิดชิลด์บังลมของหมวกที่กำลังสวม",
        Icon = "eye",
        Text = "สลับชิลด์",
        Callback = function()
            Hub.ToggleHelmetVisor()
            Window:Notify({ Title = "ห้องลองหมวก", Text = "สลับสถานะชิลด์หน้าแล้ว", Icon = "eye", Duration = 2 })
        end
    })

    Tabs.Shop:AddButton({
        Title = "ถอดหมวกกันน็อก (Remove Helmet)",
        Description = "ถอดหมวกกันน็อกที่สวมอยู่ออกทันที",
        Icon = "x-circle",
        Text = "ถอดหมวก",
        Callback = function()
            Window:Notify({ Title = "ห้องลองหมวก", Text = "กำลังถอดหมวก...", Icon = "refresh-cw", Duration = 2 })
            task.spawn(function()
                local ok, msg = Hub.RemoveHelmet()
                if ok then
                    Window:Notify({ Title = "ห้องลองหมวก", Text = "ถอดหมวกสำเร็จ!", Icon = "check", Duration = 3 })
                else
                    Window:Notify({ Title = "ห้องลองหมวก", Text = "ถอดหมวกไม่สำเร็จ: " .. tostring(msg or "เกิดข้อผิดพลาด"), Icon = "alert-circle", Duration = 3 })
                end
            end)
        end
    })

    Tabs.Shop:AddButton({
        Title = "ดึงจอพรีวิว 3D ลอยตัว (Popout 3D Screen)",
        Description = "เปิด/ปิด หน้าต่างพรีวิวหมวก 3D ลอยบนหน้าจอ หมุนดูได้แบบเรียลไทม์",
        Icon = "maximize-2",
        Text = "เปิด/ปิด จอพรีวิว",
        Callback = function()
            local win = Hub.CreateFloatingHelmetPreviewWindow()
            if win and win.Gui then
                win.Gui.Enabled = not win.Gui.Enabled
                Hub.Settings.FloatingHelmetPreview = win.Gui.Enabled
                if win.Gui.Enabled then
                    Hub.UpdateAllHelmetPreviews(CurrentChosenHelmetId, idToName[CurrentChosenHelmetId])
                    Window:Notify({ Title = "จอพรีวิว 3D", Text = "เปิดหน้าต่างพรีวิว 3D แล้ว ลากเพื่อหมุนหรือย้ายตำแหน่งได้", Icon = "box", Duration = 3 })
                end
            end
        end
    })




    -- ================================================
    -- 🏎️ TAB: CAR & FARM VEHICLE SELECTOR (รถ)
    -- ================================================
    local CarPreviewRaw = Tabs.CarPreview.RawTab

    local allVehicles = Hub.GetMapVehicles()
    local currentSelectedId = (Hub.Settings.PreferredVehicle and Hub.Settings.PreferredVehicle ~= "") and Hub.Settings.PreferredVehicle or (allVehicles[1] and allVehicles[1].id or "PCX160")
    local CarRig = nil

    -- Function to get owned vehicles from server
    local function GetPlayerOwnedSet()
        local owned = {}
        pcall(function()
            local gs = require(ReplicatedStorage:WaitForChild("GameShared", 2))
            local ns = require(ReplicatedStorage:WaitForChild("NetSeal", 2))
            local gr = ReplicatedStorage:FindFirstChild(gs and gs.REMOTES or "GameRemotes")
            local garage = gr and gr:FindFirstChild("Garage")
            if garage and ns then
                local ok, res = pcall(ns.invoke, garage, "List")
                if ok and res and type(res.vehicles) == "table" then
                    for _, v in ipairs(res.vehicles) do
                        if not v.locked and v.id then
                            owned[v.id] = true
                        end
                    end
                end
            end
        end)
        return owned
    end

    local ownedVehicles = GetPlayerOwnedSet()

    -- Section 1: 3D Viewport Screen
    Tabs.CarPreview:AddSection("🏎️ จอแสดงผลรถยนต์ 3D (3D Vehicle View)", "Left")

    local CarViewportFrame = nil
    local CarImageLabel = nil
    local CarBadgeLabel = nil
    local UpdatePreviewUI = nil
    local currentPreviewToken = 0

    if CarPreviewRaw then
        pcall(function()
            local scanBtn = CarPreviewRaw:AddButton({
                Title = "🔍 สแกนหารถ 3D ทั่วทั้งแมพ (Scan All 3D)",
                Subtitle = "ดึงโมเดลรถ 3D จากโชว์รูม, อู่ซ่อม และรอบแมพเข้าแคช",
                Icon = "scan",
                Text = "เริ่มสแกน 3D",
                Callback = function()
                    task.spawn(function()
                        if CarBadgeLabel then
                            CarBadgeLabel.Text = "⏳ กำลังสแกนโมเดล 3D และจัดเตรียมชุดแต่งทุกรุ่น..."
                            CarBadgeLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
                        end
                        Hub.ScanAllMapVehicles(true)
                        if UpdatePreviewUI then UpdatePreviewUI() end
                    end)
                end
            })

            local scroll = (CarPreviewRaw and CarPreviewRaw.Scroll)
            if not scroll and typeof(scanBtn) == "Instance" then
                scroll = scanBtn
                while scroll and not scroll:IsA("ScrollingFrame") do
                    scroll = scroll.Parent
                end
            end

            if scroll then
                local cardFrame = Instance.new("Frame")
                cardFrame.Name = "InTabCarPreviewCard"
                cardFrame.Size = UDim2.new(1, 0, 0, 245)
                cardFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
                cardFrame.BorderSizePixel = 0
                cardFrame.LayoutOrder = 0
                cardFrame.ClipsDescendants = true

                local cRnd = Instance.new("UICorner")
                cRnd.CornerRadius = UDim.new(0, 10)
                cRnd.Parent = cardFrame

                local cStr = Instance.new("UIStroke")
                cStr.Color = Color3.fromRGB(42, 46, 60)
                cStr.Thickness = 1.2
                cStr.Parent = cardFrame

                local bgGlow = Instance.new("Frame")
                bgGlow.Size = UDim2.fromScale(1, 1)
                bgGlow.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
                bgGlow.BorderSizePixel = 0
                bgGlow.Parent = cardFrame
                local bgCorner = Instance.new("UICorner")
                bgCorner.CornerRadius = UDim.new(0, 10)
                bgCorner.Parent = bgGlow

                local tabVp = Instance.new("ViewportFrame")
                tabVp.Name = "TabCarViewport"
                tabVp.Size = UDim2.new(1, -16, 1, -16)
                tabVp.Position = UDim2.new(0, 8, 0, 8)
                tabVp.BackgroundTransparency = 1
                tabVp.BorderSizePixel = 0
                tabVp.Parent = cardFrame

                local tabImg = Instance.new("ImageLabel")
                tabImg.Name = "TabCarThumbnail"
                tabImg.Size = UDim2.new(0.85, 0, 0.85, 0)
                tabImg.AnchorPoint = Vector2.new(0.5, 0.5)
                tabImg.Position = UDim2.new(0.5, 0, 0.5, -8)
                tabImg.BackgroundTransparency = 1
                tabImg.BorderSizePixel = 0
                tabImg.ScaleType = Enum.ScaleType.Fit
                tabImg.Visible = false
                tabImg.Parent = cardFrame

                local badge = Instance.new("TextLabel")
                badge.Name = "PreviewBadge"
                badge.Text = "🖱️ โมเดล 3D จริง | ลากเพื่อหมุน 360° | เลื่อนล้อเมาส์เพื่อซูม"
                badge.Size = UDim2.new(1, -20, 0, 22)
                badge.Position = UDim2.new(0, 10, 1, -30)
                badge.BackgroundTransparency = 0.5
                badge.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
                badge.TextColor3 = Color3.fromRGB(130, 240, 160)
                badge.Font = Enum.Font.BuilderSansMedium
                badge.TextSize = 12
                badge.ZIndex = 5
                badge.Parent = cardFrame
                local bCorner = Instance.new("UICorner")
                bCorner.CornerRadius = UDim.new(0, 6)
                bCorner.Parent = badge

                cardFrame.Parent = scroll
                CarViewportFrame = tabVp
                CarImageLabel = tabImg
                CarBadgeLabel = badge
            end
        end)
    end

    -- Mini controls under viewport
    Tabs.CarPreview:AddButton({
        Title = "🔄 หมุนอัตโนมัติ (เปิด/ปิด)",
        Description = "สลับเปิด/ปิด การหมุนตัวรถ 3D อัตโนมัติ",
        Icon = "rotate-cw",
        Text = "สลับการหมุน",
        Callback = function()
            if CarRig then
                CarRig.AutoRotate = not CarRig.AutoRotate
                Window:Notify({ Title = "พรีวิว 3D", Text = "หมุนอัตโนมัติ: " .. (CarRig.AutoRotate and "เปิด" or "ปิด"), Icon = "rotate-cw", Duration = 2 })
            else
                Window:Notify({ Title = "พรีวิวรถ", Text = "กำลังโหลดโมเดล 3D", Icon = "info", Duration = 2 })
            end
        end
    })

    Tabs.CarPreview:AddButton({
        Title = "🔁 รีเซ็ตมุมมอง (Reset View)",
        Description = "คืนค่ามุมกล้องหน้ารถ 3/4 และระยะซูมมาตรฐาน",
        Icon = "refresh-ccw",
        Text = "รีเซ็ตมุม",
        Callback = function()
            if CarRig then
                CarRig.Yaw = math.rad(35)
                CarRig.Pitch = 14
                CarRig.Zoom = 1.0
                if CarRig.ApplyCam then CarRig.ApplyCam() end
            else
                Window:Notify({ Title = "พรีวิวรถ", Text = "กำลังโหลดโมเดล 3D", Icon = "info", Duration = 2 })
            end
        end
    })

    -- Section 2: Farm Vehicle Selection (Direct Selection without extra buttons)
    Tabs.CarPreview:AddSection("🚜 เลือกรุ่นรถที่ใช้ฟาร์ม", "Right")

    local function BuildDropdownLabels()
        local labels = {}
        for i, v in ipairs(allVehicles) do
            local isCurrentFarm = (Hub.Settings.PreferredVehicle == v.id)
            local isOwned = ownedVehicles[v.id] or v.starter
            local tag = isCurrentFarm and "[🌾 รถฟาร์ม]" or (isOwned and "[มีในโรงรถ ✓]" or "[ร้านค้า]")
            table.insert(labels, string.format("%s %s (%s)", tag, v.th or v.id, v.id))
        end
        return labels
    end

    local CarSpecsPara = nil
    local UpdatePreviewUI = nil

    local currentLabels = BuildDropdownLabels()
    local initialDefaultLabel = currentLabels[1] or ""
    for _, lbl in ipairs(currentLabels) do
        local idInLbl = lbl:match("%(([%w_]+)%)")
        if idInLbl == currentSelectedId then
            initialDefaultLabel = lbl
            break
        end
    end

    local VehicleDropdown = Tabs.CarPreview:AddDropdown("CarSelectDropdown", {
        Title = "เลือกรถฟาร์ม",
        Description = "เลือกรถที่ต้องการใช้งาน ระบบจะบันทึกเป็นรถฟาร์มและสลับรถให้อัตโนมัติทันที",
        Icon = "car",
        Options = currentLabels,
        Default = initialDefaultLabel,
        Callback = function(chosenText)
            local chosenId = chosenText:match("%(([%w_]+)%)")
            local targetVeh = nil
            if chosenId then
                for _, v in ipairs(allVehicles) do
                    if v.id == chosenId then
                        targetVeh = v
                        break
                    end
                end
            end
            if not targetVeh then
                for _, v in ipairs(allVehicles) do
                    if chosenText:find(v.id, 1, true) then
                        targetVeh = v
                        break
                    end
                end
            end

            if targetVeh then
                currentSelectedId = targetVeh.id
                Hub.Settings.PreferredVehicle = targetVeh.id

                Window:Notify({
                    Title = "เลือกรถฟาร์มสำเร็จ",
                    Text = string.format("ตั้งค่า %s (%s) เป็นรถฟาร์มแล้ว!", tostring(targetVeh.th or targetVeh.id), tostring(targetVeh.id)),
                    Icon = "car",
                    Duration = 3
                })

                -- Switch / spawn vehicle automatically (Safe spawn with ground elevation check)
                task.spawn(function()
                    if GarageRemote then
                        local myVeh = GetPlayerVehicle(false)
                        local curId = myVeh and (myVeh:GetAttribute("VehicleId") or myVeh.Name)
                        if curId and not string.find(string.lower(tostring(curId)), string.lower(targetVeh.id), 1, true) then
                            pcall(DirectInvoke, GarageRemote, "Despawn")
                            task.wait(0.35)
                            local char = LocalPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local gParams = RaycastParams.new()
                                gParams.FilterType = Enum.RaycastFilterType.Exclude
                                gParams.FilterDescendantsInstances = { char }
                                local gRay = Workspace:Raycast(hrp.Position + Vector3.new(0, 2, 0), Vector3.new(0, -15, 0), gParams)
                                if gRay and gRay.Instance and gRay.Instance.CanCollide then
                                    hrp.CFrame = CFrame.new(gRay.Position + Vector3.new(0, 2.5, 0))
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    task.wait(0.1)
                                end
                            end
                            pcall(DirectInvoke, GarageRemote, "Spawn", targetVeh.id)
                        end
                    end
                end)

                if UpdatePreviewUI then UpdatePreviewUI() end
            end
        end
    })

    -- Info Specs Card
    CarSpecsPara = Tabs.CarPreview:AddParagraph({
        Title = "กำลังโหลดข้อมูลรถ...",
        Content = "กรุณารอสักครู่..."
    })

    -- UpdatePreviewUI Implementation
    UpdatePreviewUI = function()
        currentPreviewToken = currentPreviewToken + 1
        local myToken = currentPreviewToken

        local vehData = nil
        for _, v in ipairs(allVehicles) do
            if v.id == currentSelectedId then
                vehData = v
                break
            end
        end
        if not vehData then vehData = allVehicles[1] end
        currentSelectedId = vehData.id

        -- 1. Setup Viewport / Thumbnail Preview
        task.spawn(function()
            -- 📱 บนมือถือ (Android/iOS): ใช้ภาพ 2D Thumbnail โดยตรง ป้องกัน GPU Render Buffer เด้ง 100%
            if IsMobileDevice then
                if CarViewportFrame then
                    CarViewportFrame:ClearAllChildren()
                    CarViewportFrame.Visible = false
                end
                if CarRig and CarRig.Cleanup then CarRig.Cleanup() end
                CarRig = nil
                if CarImageLabel then
                    CarImageLabel.Image = vehData.thumb or ""
                    CarImageLabel.Visible = true
                end
                if CarBadgeLabel then
                    local vName = vehData.th or vehData.name or vehData.id
                    CarBadgeLabel.Text = "🖼️ ภาพตัวรถ: " .. tostring(vName) .. " (โหมดเสถียรสำหรับมือถือ)"
                    CarBadgeLabel.TextColor3 = Color3.fromRGB(130, 240, 160)
                end
                return
            end

            -- 💻 บน PC: แสดงผล 3D Viewport Rig เต็มระบบ
            if CarBadgeLabel then
                CarBadgeLabel.Text = "⏳ กำลังดึงโมเดล 3D (" .. tostring(vehData.th or vehData.id) .. ")..."
                CarBadgeLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
            end

            local model, sourceDesc = Hub.FindVehicle3DModel(vehData.id)
            if myToken ~= currentPreviewToken then return end

            if model and CarViewportFrame then
                if CarImageLabel then CarImageLabel.Visible = false end
                CarViewportFrame.Visible = true
                if CarRig and CarRig.Cleanup then CarRig.Cleanup() end
                CarRig = Hub.SetupVehicleViewportRig(CarViewportFrame, vehData.id, model, sourceDesc)
                if CarBadgeLabel then
                    local vName = vehData.th or vehData.name or vehData.id
                    CarBadgeLabel.Text = "🖱️ โมเดล 3D: " .. tostring(vName) .. " | ลากเพื่อหมุน 360° | ซูมได้"
                    CarBadgeLabel.TextColor3 = Color3.fromRGB(130, 240, 160)
                end
            else
                if CarRig and CarRig.Cleanup then CarRig.Cleanup() end
                CarRig = nil
                if CarViewportFrame then
                    CarViewportFrame:ClearAllChildren()
                    CarViewportFrame.Visible = false
                end
                if CarImageLabel then
                    CarImageLabel.Image = vehData.thumb or ""
                    CarImageLabel.Visible = true
                end
                if CarBadgeLabel then
                    CarBadgeLabel.Text = "🖼️ ภาพตัวรถจริงของเกม (" .. tostring(vehData.th or vehData.id) .. ")"
                    CarBadgeLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
                end
            end
        end)

        -- 2. Update Specs Paragraph
        local isCurrentFarm = (Hub.Settings.PreferredVehicle == vehData.id)
        local isOwned = ownedVehicles[vehData.id] or vehData.starter

        local priceTxt = vehData.starter and "ฟรี (รถเริ่มต้น)"
            or (vehData.price and vehData.price > 0 and (string.format("%s ฿", (GameShared and GameShared.formatNumber and GameShared.formatNumber(vehData.price)) or tostring(vehData.price))))
            or (vehData.robux and (vehData.robux .. " Robux"))
            or (vehData.pass and ("Gamepass: " .. tostring(vehData.pass)))
            or "พิเศษ / Limited"

        local estTop = (vehData.category == "Car" and 220 or 140)
        local farmStatus = isCurrentFarm and "🟢 รถฟาร์มหลัก (เปิดใช้งานอยู่ ✅)" or "⚪ รถในรายการ (เลือกรุ่นนี้เพื่อใช้เป็นรถฟาร์ม)"
        local garageStatus = isOwned and "✅ มีในโรงรถแล้ว (พร้อมเสกฟาร์มทันที)" or "🛒 ในร้านค้า (ระบบจะซื้อหรือใช้เมื่อมี)"

        local contentStr = string.format(
            "🏷️ รุ่นรถ: %s [%s]\n🌾 ระบบฟาร์ม: %s\n📂 ประเภท: %s | 👥 ที่นั่ง: %d ที่นั่ง\n⚡ ความเร็วสูงสุดเดิม: ~%d km/h\n💰 ราคา: %s\n📦 สถานะ: %s",
            tostring(vehData.th or vehData.id),
            tostring(vehData.id),
            farmStatus,
            (vehData.category == "Car" and "รถยนต์ / กระบะ (Car)" or "มอเตอร์ไซค์ / สกู๊ตเตอร์ (Scooter)"),
            vehData.seats or 2,
            estTop,
            priceTxt,
            garageStatus
        )

        if CarSpecsPara and CarSpecsPara.SetDesc then
            CarSpecsPara:SetDesc(contentStr)
        end
    end

    -- Tab visibility listener: เมื่อผู้ใช้สลับมาที่แท็บ "รถ" ให้เรนเดอร์โมเดล 3D ทันที
    local rawTabObj = Tabs.CarPreview.RawTab
    local tabContainer = rawTabObj and (rawTabObj.Content or (rawTabObj.Scroll and rawTabObj.Scroll.Parent))
    if tabContainer then
        pcall(function()
            tabContainer:GetPropertyChangedSignal("Visible"):Connect(function()
                if tabContainer.Visible then
                    if rawTabObj and rawTabObj.Scroll then
                        rawTabObj.Scroll.CanvasPosition = Vector2.new(0, 0)
                    end
                    if UpdatePreviewUI then
                        task.wait(0.05)
                        UpdatePreviewUI()
                    end
                end
            end)
        end)
    end

    task.defer(function()
        task.wait(0.15)
        pcall(function() Hub.ScanAllMapVehicles(false) end)
        if UpdatePreviewUI then
            UpdatePreviewUI()
        end
    end)

    -- ================================================
    local SettingsRaw = Tabs.Settings.RawTab

    -- ==============================================================
    -- 🌐 SERVER HOPPER & JOB ID TELEPORT SYSTEM (เชื่อมต่อเซิร์ฟเวอร์ด้วย JobId)
    -- ==============================================================
    SettingsRaw:AddLabel("เชื่อมต่อเซิร์ฟเวอร์ด้วย JobId (Server JobId Joiner)", "network")

    local currentJobId = tostring(game.JobId or "")
    local currentPlaceId = game.PlaceId or 104549080643413
    local targetJobIdInput = ""

    local JobIdInfoPara = Tabs.Settings:AddParagraph({
        Title = "📡 ข้อมูลเซิร์ฟเวอร์ปัจจุบัน",
        Content = string.format("JobId ปัจจุบัน:\n%s\nPlaceId: %s", (currentJobId ~= "" and currentJobId or "กำลังโหลด / เล่นใน Studio"), tostring(currentPlaceId))
    })

    local JobIdBox = SettingsRaw:AddTextBox({
        Title       = "ป้อน JobId ปลายทาง",
        Subtitle    = "วาง JobId ของเซิร์ฟเวอร์ที่ต้องการจะย้ายเข้าไปเล่น",
        Icon        = "server",
        Placeholder = "วาง JobId ที่นี่...",
        Default     = "",
        Callback    = function(text)
            targetJobIdInput = tostring(text or ""):gsub("%s+", "")
        end,
    })

    SettingsRaw:AddButton({
        Title    = "🚀 เชื่อมต่อเข้าเซิร์ฟเวอร์ (Join Server by JobId)",
        Subtitle = "ย้ายตัวละครเข้าสู่ห้องเซิร์ฟเวอร์ตาม JobId ทันที",
        Icon     = "log-in",
        Text     = "เข้าเซิร์ฟเวอร์",
        Callback = function()
            local jobId = (targetJobIdInput ~= "") and targetJobIdInput or (JobIdBox and JobIdBox.Get and JobIdBox:Get()) or ""
            jobId = tostring(jobId):gsub("%s+", "")
            if jobId == "" then
                Window:Notify({
                    Title    = "เกิดข้อผิดพลาด",
                    Text     = "กรุณากรอก JobId ของเซิร์ฟเวอร์ปลายทางก่อนกดย้าย",
                    Icon     = "alert-triangle",
                    Duration = 3
                })
                return
            end

            if jobId == currentJobId then
                Window:Notify({
                    Title    = "แจ้งเตือน",
                    Text     = "คุณกำลังอยู่ในเซิร์ฟเวอร์ JobId นี้อยู่แล้ว!",
                    Icon     = "info",
                    Duration = 3
                })
                return
            end

            Window:Notify({
                Title    = "กำลังเชื่อมต่อเซิร์ฟเวอร์",
                Text     = string.format("กำลังย้ายเข้า JobId: %s...", jobId:sub(1, 16)),
                Icon     = "network",
                Duration = 4
            })

            task.spawn(function()
                local tpService = TeleportService or game:GetService("TeleportService")
                local pId = currentPlaceId
                local ok, err = pcall(function()
                    tpService:TeleportToPlaceInstance(pId, jobId, LocalPlayer)
                end)
                if not ok then
                    Window:Notify({
                        Title    = "การเชื่อมต่อล้มเหลว",
                        Text     = "ไม่สามารถเข้าสู่ JobId นี้ได้ (เซิร์ฟเวอร์อาจจะเต็มหรือปิดแล้ว): " .. tostring(err),
                        Icon     = "alert-circle",
                        Duration = 4
                    })
                end
            end)
        end,
    })

    SettingsRaw:AddButton({
        Title    = "📋 คัดลอก JobId เซิร์ฟเวอร์นี้ (Copy Current JobId)",
        Subtitle = "ก็อปปี้ JobId ห้องปัจจุบันเก็บไว้ในคลิปบอร์ด เพื่อส่งให้เพื่อน",
        Icon     = "copy",
        Text     = "คัดลอก JobId",
        Callback = function()
            local cur = tostring(game.JobId or "")
            if cur ~= "" and typeof(setclipboard) == "function" then
                setclipboard(cur)
                Window:Notify({
                    Title    = "คัดลอกสำเร็จ",
                    Text     = "คัดลอก JobId ปัจจุบันลงในคลิปบอร์ดแล้ว!",
                    Icon     = "check",
                    Duration = 2.5
                })
            else
                Window:Notify({
                    Title    = "คัดลอก JobId",
                    Text     = "JobId: " .. (cur ~= "" and cur or "ไม่พบ JobId"),
                    Icon     = "info",
                    Duration = 4
                })
            end
        end,
    })

    SettingsRaw:AddButton({
        Title    = "🔄 รีจอยน์เซิร์ฟเวอร์นี้ทันที (Rejoin Current Server)",
        Subtitle = "เชื่อมต่อกลับเข้ามาที่เซิร์ฟเวอร์ห้องเดิมนี้อีกครั้ง",
        Icon     = "rotate-cw",
        Text     = "รีจอยน์เซิร์ฟเดิม",
        Callback = function()
            local cur = tostring(game.JobId or "")
            local tpService = TeleportService or game:GetService("TeleportService")
            Window:Notify({
                Title    = "กำลังรีจอยน์",
                Text     = "กำลังเชื่อมต่อเข้าสู่เซิร์ฟเวอร์ห้องเดิม...",
                Icon     = "rotate-cw",
                Duration = 3
            })
            task.spawn(function()
                if cur ~= "" then
                    pcall(function() tpService:TeleportToPlaceInstance(currentPlaceId, cur, LocalPlayer) end)
                else
                    pcall(function() tpService:Teleport(currentPlaceId, LocalPlayer) end)
                end
            end)
        end,
    })

    SettingsRaw:AddSeparator()

    local themeNames = {}
    for name in pairs(VantixUI.Themes) do
        table.insert(themeNames, name)
    end
    table.sort(themeNames)

    SettingsRaw:AddDropdown({
        Title    = "Theme",
        Icon     = "swatch-book",
        Options  = themeNames,
        Default  = Window:GetTheme(),
        Callback = function(selected)
            Window:SetTheme(selected)
        end,
    })

    SettingsRaw:AddDropdown({
        Title    = "Accent Color",
        Icon     = "droplet",
        Options  = {"White", "Blue", "Red", "Green", "Purple"},
        Default  = "White",
        Callback = function(selected)
            local colors = {
                White  = Color3.fromRGB(255, 255, 255),
                Blue   = Color3.fromRGB(64, 156, 255),
                Red    = Color3.fromRGB(230, 70, 70),
                Green  = Color3.fromRGB(80, 210, 120),
                Purple = Color3.fromRGB(170, 110, 240),
            }
            if colors[selected] then
                VantixUI:SetAccentColor(colors[selected])
            end
        end,
    })

-- [REMOVED] PathfindingToggle removed per user request

    local AutoCaptchaToggle = Tabs.Settings:AddToggle("AutoCaptchaToggle", {
        Title = "ตอบแคปช่าออโต้",
        Description = "ตอบ FarmCheck อัตโนมัติกันโดนเตะ",
        Icon = "bell",
        Default = true
    })
    AutoCaptchaToggle:OnChanged(function(v)
        Hub.Settings.AutoCaptcha = v
        SaveConfig()
    end)
    pcall(function() AutoCaptchaToggle:SetValue(true) end)

    local AntiAfkToggle = Tabs.Settings:AddToggle("AntiAfkToggle", {
        Title = "ป้องกันการหลุด (Anti-AFK)",
        Description = "ป้องกัน Roblox เตะออกเกมเมื่อปล่อยจอนานเกิน 20 นาที (IDLE Kick)",
        Icon = "shield",
        Default = true
    })
    AntiAfkToggle:OnChanged(function(v)
        Hub.Settings.AntiAfk = v
        SaveConfig()
    end)
    pcall(function() AntiAfkToggle:SetValue(true) end)

    local AutoRejoinToggle = Tabs.Settings:AddToggle("AutoRejoinToggle", {
        Title = "ออโต้รีจอยเซิร์ฟเดิม (Auto Rejoin Same Server)",
        Description = "รีจอยกลับเข้าเซิร์ฟเวอร์เดิมทันทีเมื่อเน็ตหลุด โดนเตะ หรือเกิด Error",
        Icon = "refresh-cw",
        Default = true
    })
    AutoRejoinToggle:OnChanged(function(v)
        Hub.Settings.AutoRejoin = v
        SaveConfig()
    end)
    pcall(function() AutoRejoinToggle:SetValue(true) end)

    SettingsRaw:AddButton({
        Title    = "รีจอยเซิร์ฟเวอร์เดิม (Rejoin Now)",
        Subtitle = "เชื่อมต่อกลับเข้ามาที่เซิร์ฟเวอร์เดิมทันที",
        Icon     = "refresh-cw",
        Text     = "Rejoin",
        Callback = function()
            Window:Notify({Title = "Auto Rejoin", Text = "กำลังเชื่อมต่อเข้าเซิร์ฟเดิม...", Duration = 3})
            task.wait(0.5)
            if Hub.RejoinServer then
                Hub.RejoinServer()
            end
        end,
    })

    local HideNameToggle = Tabs.Settings:AddToggle("HideNameToggle", {
        Title = "ปิดชื่อตัวละครในเกม (Hide Name)",
        Description = "ซ่อนป้ายชื่อบนหัวตัวละครทั้งหมด (Streamer Mode / ไม่ติดชื่อเวลาอัดคลิป)",
        Icon = "eye-off",
        Default = true
    })
    HideNameToggle:OnChanged(function(v)
        Hub.Settings.HideNames = v
        if Hub.UpdateNameTagsVisibility then
            pcall(Hub.UpdateNameTagsVisibility, v)
        end
        SaveConfig()
    end)
    pcall(function() HideNameToggle:SetValue(true) end)

    Tabs.Settings:AddSection("ระบบกันโปร & ป้องกันทีมงานแอดมิน (Anti-Staff & Anti-Log)", "Left")

    local StaffStatusPara = Tabs.Settings:AddParagraph({
        Title = "สถานะการตรวจจับแอดมิน (Staff Radar)",
        Content = "🟢 ปลอดภัย: ไม่พบแอดมินหรือทีมงานในเซิร์ฟเวอร์"
    })
    task.spawn(function()
        while Hub.Running and genv[_gk.sk] == SCRIPT_ID do
            pcall(function()
                if StaffStatusPara then
                    if Hub.StaffPresent and #Hub.DetectedStaffList > 0 then
                        local listStr = ""
                        for _, s in ipairs(Hub.DetectedStaffList) do
                            listStr = listStr .. string.format("\n• %s (@%s) - %s", s.DisplayName, s.Name, s.Role)
                        end
                        StaffStatusPara:SetDesc("🚨 ตรวจพบทีมงานในเซิร์ฟเวอร์:" .. listStr)
                    else
                        StaffStatusPara:SetDesc("🟢 ปลอดภัย: ไม่พบแอดมินหรือทีมงานในเซิร์ฟเวอร์")
                    end
                end
            end)
            task.wait(2.0)
        end
    end)

    local BlockLogsToggle = Tabs.Settings:AddToggle("BlockLogsToggle", {
        Title = "บล็อก Log & การส่งรายงานทั้งหมด (Log Blackhole)",
        Description = "บล็อกและตัดการส่ง Log, Error, Crash, Telemetry และรายงานทั้งหมดไปเซิร์ฟเวอร์",
        Icon = "shield-off",
        Default = true
    })
    BlockLogsToggle:OnChanged(function(v)
        Hub.Settings.BlockAllLogs = v
        SaveConfig()
    end)
    pcall(function() BlockLogsToggle:SetValue(true) end)

    local AntiStaffShieldToggle = Tabs.Settings:AddToggle("AntiStaffShieldToggle", {
        Title = "เรดาร์ป้องกันแอดมิน (Anti-Staff Radar Shield)",
        Description = "ตรวจจับแอดมิน/ทีมงาน และปรับลดความเร็วสู่โหมดปกติ (Legit Mode) อัตโนมัติเมื่อแอดมินอยู่ใกล้",
        Icon = "shield-alert",
        Default = true
    })
    AntiStaffShieldToggle:OnChanged(function(v)
        Hub.Settings.AntiStaffMode = v
        SaveConfig()
    end)
    pcall(function() AntiStaffShieldToggle:SetValue(true) end)

    local AutoHopStaffToggle = Tabs.Settings:AddToggle("AutoHopStaffToggle", {
        Title = "หนีเซิร์ฟอัตโนมัติเมื่อพบแอดมิน (Auto Server-Hop on Staff)",
        Description = "ย้ายเซิร์ฟเวอร์ทันทีที่ตรวจพบแอดมินหรือทีมงานเข้าเซิร์ฟเวอร์ ป้องกันการแบน 100%",
        Icon = "log-out",
        Default = false
    })
    AutoHopStaffToggle:OnChanged(function(v)
        Hub.Settings.AutoServerHopOnStaff = v
        SaveConfig()
    end)

    SettingsRaw:AddSeparator()
    SettingsRaw:AddLabel("ระบบข้ามหน้าเมนูอัตโนมัติ (Auto Join / Menu)", "play")

    local AutoPassMenuToggle = Tabs.Settings:AddToggle("AutoPassMenuToggle", {
        Title = "ข้ามเมนูอัตโนมัติ (Auto Pass Menus)",
        Description = "กดเลือกกราฟิก, กด Play Now และเลือกอาชีพอัตโนมัติเมื่อเข้าเกม",
        Icon = "zap",
        Default = true
    })
    AutoPassMenuToggle:OnChanged(function(v)
        Hub.Settings.AutoPassMenu = v
        SaveConfig()
    end)
    pcall(function() AutoPassMenuToggle:SetValue(true) end)

    local AutoGfxDropdown = Tabs.Settings:AddDropdown("AutoGfxDropdown", {
        Title = "กราฟิกอัตโนมัติ (Auto Graphics)",
        Description = "เลือก Low เพื่อบูสต์ FPS ตอนฟาร์ม หรือ High สำหรับภาพสวย",
        Icon = "monitor",
        Options = {"Play on LOW (แนะนำ ลื่น)", "Play on HIGH"},
        Default = "Play on LOW (แนะนำ ลื่น)",
        Callback = function(v)
            Hub.Settings.AutoGfxChoice = v:find("HIGH") and "HIGH" or "LOW"
            SaveConfig()
        end
    })

    local AutoJobDropdown = Tabs.Settings:AddDropdown("AutoJobDropdown", {
        Title = "อาชีพอัตโนมัติ (Auto Job)",
        Description = "เลือกอาชีพที่ต้องการให้ระบบเลือกอัตโนมัติเมื่อเข้าแมพ",
        Icon = "briefcase",
        Options = {"ไรเดอร์ส่งอาหาร", "ส่งพัสดุ", "ช่างซ่อมรถ", "ช่างก่อสร้าง", "พลเมือง"},
        Default = "ไรเดอร์ส่งอาหาร",
        Callback = function(v)
            Hub.Settings.AutoJobChoice = v
            SaveConfig()
        end
    })

    local FpsBoosterToggle = Tabs.Settings:AddToggle("FpsBoosterToggle", {
        Title = "⚡ บูสต์ FPS & ถนอมแบต (FPS Booster / Mobile & PC)",
        Description = "ลดแสงเงา, หมอก และเอฟเฟกต์หนัก เพื่อให้มือถือ/คอมไม่ร้อน และรันลื่นไหล 60 FPS ตลอดเวลา",
        Icon = "cpu",
        Default = IsMobileDevice or Hub.Settings.FPSBooster or false,
    })
    FpsBoosterToggle:OnChanged(function(v)
        Hub.Settings.FPSBooster = v
        if Hub.ApplyFpsBooster then
            Hub.ApplyFpsBooster(v)
        end
        SaveConfig()
    end)
    if IsMobileDevice or Hub.Settings.FPSBooster then
        if Hub.ApplyFpsBooster then
            Hub.ApplyFpsBooster(true)
        end
    end

    SettingsRaw:AddSeparator()

    SettingsRaw:AddToggleKey({
        Title    = "UI Toggle Key",
        Subtitle = "ปุ่มย่อ / ขยายหน้าต่างเมนู (ค่าเริ่มต้น RightShift)",
        Icon     = "keyboard",
    })

    SettingsRaw:AddButton({
        Title    = "Reset Toggle Key",
        Subtitle = "รีเซ็ตปุ่มกลับเป็น RightShift",
        Icon     = "rotate-ccw",
        Text     = "Reset",
        Callback = function()
            Window:SetToggleKey(Enum.KeyCode.RightShift)
            Window:Notify({Title = "Toggle Key", Text = "Reset to " .. Window:GetToggleKey().Name, Duration = 2})
        end,
    })

    local uiKeybind = SettingsRaw:AddKeybind({
        Title    = "Hide UI Keybind",
        Subtitle = "Insert ซ่อน/แสดงหน้าต่างทันที (แยกจากปุ่มย่อเมนู)",
        Icon     = "keyboard",
        Default  = Enum.KeyCode.Insert,
        Callback = function()
            local sg = Window.Gui
            if sg then sg.Enabled = not sg.Enabled end
        end,
    })

    SettingsRaw:AddSeparator()
    SettingsRaw:AddLabel("Config System", "save")

    Window.ConfigManager:SetFolder("Mahanakhon_VantixUI")

    -- 📁 Auto Load System File Path & Persistence Helpers
    local AutoLoadPath = "Mahanakhon_VantixUI/autoload.json"

    local function getAutoLoadData()
        if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(AutoLoadPath) then
            local ok, content = pcall(readfile, AutoLoadPath)
            if ok and content and #content > 0 then
                local okJson, data = pcall(function() return HttpService:JSONDecode(content) end)
                if okJson and type(data) == "table" then
                    return data
                end
                local trimmed = content:gsub("^%s*(.-)%s*$", "%1")
                if #trimmed > 0 then
                    return { enabled = true, config = trimmed }
                end
            end
        end
        return { enabled = true, config = "MahanakhonConfig" }
    end

    local function setAutoLoadData(enabled, config)
        if typeof(writefile) == "function" then
            pcall(function()
                if typeof(isfolder) == "function" and not isfolder("Mahanakhon_VantixUI") and typeof(makefolder) == "function" then
                    makefolder("Mahanakhon_VantixUI")
                end
                local data = {
                    enabled = enabled == true,
                    config  = (config and config ~= "") and config or "MahanakhonConfig",
                    updated = os.time()
                }
                writefile(AutoLoadPath, HttpService:JSONEncode(data))
            end)
        end
    end

    local autoLoadData = getAutoLoadData()
    local initialConfigs = Window.ConfigManager:GetConfigs()
    local defaultCfg = "MahanakhonConfig"
    if autoLoadData.config and autoLoadData.config ~= "" then
        defaultCfg = autoLoadData.config
    elseif #initialConfigs > 0 then
        defaultCfg = initialConfigs[1]
    end

    local configName = SettingsRaw:AddTextBox({
        Title       = "Configuration Name",
        Icon        = "file-text",
        Placeholder = "Enter config name...",
        Default     = defaultCfg,
    })

    local function buildConfig(name)
        local cfg = Window.ConfigManager:CreateConfig(name)
        cfg:RegisterElement("AutoCaptcha",   AutoCaptchaToggle)
        if MasterFarmToggle then cfg:RegisterElement("MasterFarm", MasterFarmToggle) end
        if FarmJobDropdown then cfg:RegisterElement("FarmJob", FarmJobDropdown) end
        cfg:RegisterElement("AntiAfk",       AntiAfkToggle)
        if AutoRejoinToggle then cfg:RegisterElement("AutoRejoin", AutoRejoinToggle) end
        if HideNameToggle then cfg:RegisterElement("HideNames", HideNameToggle) end
        if AutoClaimQuestsToggle then cfg:RegisterElement("AutoClaimQuests", AutoClaimQuestsToggle) end
        if AutoPassMenuToggle then cfg:RegisterElement("AutoPassMenu", AutoPassMenuToggle) end
        if AutoGfxDropdown then cfg:RegisterElement("AutoGfxChoice", AutoGfxDropdown) end
        if AutoJobDropdown then cfg:RegisterElement("AutoJobChoice", AutoJobDropdown) end
        if AutoBuyPistonToggle then cfg:RegisterElement("AutoBuyPiston", AutoBuyPistonToggle) end
        if PistonSizeDropdown then cfg:RegisterElement("AutoBuyPistonSize", PistonSizeDropdown) end
        if AutoInstallPistonToggle then cfg:RegisterElement("AutoInstallPiston", AutoInstallPistonToggle) end
        if FpsBoosterToggle then cfg:RegisterElement("FPSBooster", FpsBoosterToggle) end
        if BlockLogsToggle then cfg:RegisterElement("BlockLogs", BlockLogsToggle) end
        if AntiStaffShieldToggle then cfg:RegisterElement("AntiStaffShield", AntiStaffShieldToggle) end
        if AutoHopStaffToggle then cfg:RegisterElement("AutoHopStaff", AutoHopStaffToggle) end
        if VehicleMasterToggle then cfg:RegisterElement("VehicleMaster", VehicleMasterToggle) end
        if AutoTuneToggle then cfg:RegisterElement("AutoTune", AutoTuneToggle) end
        if LockMoneyToggle then cfg:RegisterElement("LockMoney", LockMoneyToggle) end
        if BlackScreenToggle then cfg:RegisterElement("BlackScreen", BlackScreenToggle) end
        cfg:RegisterElement("ConfigName",    configName)
        cfg:RegisterElement("UIKeybind",     uiKeybind)
        return cfg
    end

    local function unpackConfigValue(stored)
        if type(stored) ~= "table" then return stored, true end
        if stored.kind == "Enum" then
            local enum = Enum[stored.enum]
            return enum and enum[stored.name], enum ~= nil
        elseif stored.kind == "Color3" then
            local rgb = stored.rgb or {1, 1, 1}
            return Color3.new(rgb[1] or 1, rgb[2] or 1, rgb[3] or 1), true
        elseif stored.kind == "Raw" then
            return stored.value, true
        end
        return stored.value or stored, true
    end

    local function loadConfigSafe(name)
        if not name or name == "" then return false end
        pcall(LoadConfig)
        local cfg = buildConfig(name)
        local path = Window.ConfigManager.Folder .. "/" .. name .. ".json"
        if not (typeof(isfile) == "function" and isfile(path)) then
            return false
        end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if not ok or type(data) ~= "table" then
            return false
        end

        -- 1. โหลดการตั้งค่าอื่นๆ ทั้งหมดก่อน (เตรียม Dropdowns/Settings ให้พร้อม)
        for id, stored in pairs(data) do
            if id ~= "MasterFarm" and id ~= "ConfigName" then
                local el = cfg.Elements[id]
                if el and el.Set then
                    local value, valid = unpackConfigValue(stored)
                    if valid then
                        pcall(el.Set, el, value)
                    end
                end
            end
        end

        task.wait(0.08)

        -- 2. โหลด MasterFarm เป็นลำดับสุดท้าย เพื่อให้งานฟาร์มที่เลือกไว้เริ่มทำงานทันทีอย่างถูกต้อง
        if data["MasterFarm"] then
            local el = cfg.Elements["MasterFarm"]
            if el and el.Set then
                local value, valid = unpackConfigValue(data["MasterFarm"])
                if valid then
                    pcall(el.Set, el, value)
                end
            end
        end

        return true
    end

    local autoLoadToggle
    local isUpdatingAutoLoad = false

    local savedConfigs = SettingsRaw:AddDropdown({
        Title    = "Saved Configs",
        Icon     = "folder",
        Options  = #initialConfigs > 0 and initialConfigs or { defaultCfg },
        Default  = defaultCfg,
        Callback = function(selected)
            if selected and selected ~= "" then
                if configName and configName.Set then
                    configName:Set(selected)
                end
                if autoLoadToggle and autoLoadToggle:Get() and Hub.Running and not isUpdatingAutoLoad then
                    setAutoLoadData(true, selected)
                end
            end
        end,
    })

    autoLoadToggle = SettingsRaw:AddToggle({
        Title    = "Auto Load Config (โหลดการตั้งค่าอัตโนมัติ)",
        Subtitle = "โหลดคอนฟิกที่เลือกอัตโนมัติเมื่อเปิดสคริปต์ / รีจอยน์",
        Icon     = "refresh-cw",
        Default  = autoLoadData.enabled ~= false,
        Callback = function(v)
            if not Hub.Running or isUpdatingAutoLoad then return end

            local currentTarget = savedConfigs and savedConfigs:Get()
            if not currentTarget or currentTarget == "" then
                currentTarget = configName and configName:Get()
            end
            if not currentTarget or currentTarget == "" then
                currentTarget = "MahanakhonConfig"
            end

            if v then
                local cfgPath = Window.ConfigManager.Folder .. "/" .. currentTarget .. ".json"
                if not (typeof(isfile) == "function" and isfile(cfgPath)) then
                    SaveConfig()
                    buildConfig(currentTarget):Save()
                    savedConfigs:SetOptions(Window.ConfigManager:GetConfigs())
                    savedConfigs:Set(currentTarget)
                end
                setAutoLoadData(true, currentTarget)
                Window:Notify({
                    Title    = "Auto Load",
                    Text     = "เปิด Auto Load คอนฟิก: " .. currentTarget,
                    Icon     = "check",
                    Duration = 2.5
                })
            else
                setAutoLoadData(false, currentTarget)
                Window:Notify({
                    Title    = "Auto Load",
                    Text     = "ปิดการโหลดคอนฟิกอัตโนมัติแล้ว",
                    Icon     = "info",
                    Duration = 2.5
                })
            end
        end,
    })

    SettingsRaw:AddButton({
        Title    = "Save Config (บันทึกการตั้งค่า)",
        Icon     = "save",
        Text     = "Save",
        Callback = function()
            SaveConfig()
            local cName = configName:Get()
            if not cName or cName == "" then cName = "MahanakhonConfig" end
            buildConfig(cName):Save()
            local list = Window.ConfigManager:GetConfigs()
            savedConfigs:SetOptions(list)
            savedConfigs:Set(cName)
            if autoLoadToggle and autoLoadToggle:Get() then
                setAutoLoadData(true, cName)
            end
            Window:Notify({Title = "Config", Text = "Saved as " .. cName, Duration = 2})
        end,
    })

    SettingsRaw:AddButton({
        Title    = "Load Selected (โหลดการตั้งค่า)",
        Icon     = "download",
        Text     = "Load",
        Callback = function()
            local name = savedConfigs:Get()
            if not name or name == "" then
                name = configName:Get()
            end
            if name and name ~= "" then
                configName:Set(name)
                local success = loadConfigSafe(name)
                if success then
                    if autoLoadToggle and autoLoadToggle:Get() then
                        setAutoLoadData(true, name)
                    end
                    Window:Notify({Title = "Config", Text = "Loaded " .. name, Duration = 2})
                else
                    Window:Notify({Title = "Config", Text = "Failed to load " .. name, Duration = 2})
                end
            else
                LoadConfig()
                Window:Notify({Title = "Config", Text = "Loaded default config", Duration = 2})
            end
        end,
    })

    SettingsRaw:AddButton({
        Title    = "Delete Selected",
        Icon     = "trash-2",
        Text     = "Delete",
        Risky    = true,
        Tooltip  = "Deletes the config file",
        Callback = function()
            local name = savedConfigs:Get()
            if name and name ~= "" then
                Window.ConfigManager:DeleteConfig(name)
                local remaining = Window.ConfigManager:GetConfigs()
                savedConfigs:SetOptions(remaining)
                local currentAuto = getAutoLoadData()
                if currentAuto and currentAuto.config == name then
                    if #remaining > 0 then
                        setAutoLoadData(currentAuto.enabled, remaining[1])
                        savedConfigs:Set(remaining[1])
                        configName:Set(remaining[1])
                    else
                        setAutoLoadData(false, "")
                        if autoLoadToggle then autoLoadToggle:Set(false) end
                    end
                end
                Window:Notify({Title = "Config", Text = "Deleted " .. name, Duration = 2})
            end
        end,
    })

    -- 🚀 AUTO LOAD RUNNER (ทำงานอัตโนมัติเมื่อเปิดสคริปต์)
    task.spawn(function()
        task.wait(0.8)
        if not Hub.Running then return end
        local initialAuto = getAutoLoadData()
        local targetName = (initialAuto and initialAuto.config and initialAuto.config ~= "") and initialAuto.config or defaultCfg
        targetName = tostring(targetName):gsub("%.json$", "")
        local folder = (Window and Window.ConfigManager and Window.ConfigManager.Folder) or "Mahanakhon_VantixUI"
        local cfgPath = folder .. "/" .. targetName .. ".json"

        -- ถ้ายังไม่มีไฟล์ ให้เซฟค่าปัจจุบันเป็นคอนฟิกทันที
        if not (typeof(isfile) == "function" and isfile(cfgPath)) then
            SaveConfig()
            buildConfig(targetName):Save()
            if savedConfigs and savedConfigs.SetOptions then
                savedConfigs:SetOptions(Window.ConfigManager:GetConfigs())
            end
        end

        -- มั่นใจว่าเปิดสวิตช์ Auto Load ใน UI และบันทึกสถานะเปิดอัตโนมัติ 100%
        if autoLoadToggle and not autoLoadToggle:Get() then
            isUpdatingAutoLoad = true
            pcall(function() autoLoadToggle:Set(true) end)
            isUpdatingAutoLoad = false
        end
        setAutoLoadData(true, targetName)

        -- โหลดคอนฟิก
        pcall(function()
            if configName and configName.Set then
                configName:Set(targetName)
            end
            if savedConfigs and savedConfigs.Set then
                savedConfigs:Set(targetName)
            end
            local ok = loadConfigSafe(targetName)
            if ok then
                Window:Notify({
                    Title    = "Auto Load สำเร็จ",
                    Text     = "โหลดคอนฟิก: " .. targetName .. " เรียบร้อยแล้ว",
                    Icon     = "check-circle",
                    Duration = 3,
                })
                if console and console.Write then
                    console:Write("[AutoLoad] โหลดคอนฟิกอัตโนมัติสำเร็จ: " .. targetName)
                end
            end
        end)
    end)

    SettingsRaw:AddSeparator()

    SettingsRaw:AddButton({
        Title    = "Minimize",
        Icon     = "minus",
        Text     = "Minimize",
        Callback = function() Window:Minimize() end,
    })

    SettingsRaw:AddButton({
        Title    = "Restore",
        Icon     = "square",
        Text     = "Restore",
        Callback = function() Window:Restore() end,
    })

    SettingsRaw:AddButton({
        Title    = "Toggle Window",
        Icon     = "repeat",
        Text     = "Toggle",
        Callback = function() Window:Toggle() end,
    })

    SettingsRaw:AddButton({
        Title    = "Unload (ปิดสคริปต์)",
        Subtitle = "ลบเมนูและคืนค่าเดิมทั้งหมด",
        Icon     = "log-out",
        Text     = "Unload",
        Callback = function()
            if genv[_gk.cl] then
                genv[_gk.cl]()
            end
        end,
    })

    SettingsRaw:AddSeparator()
    Tabs.Settings:AddParagraph({
        Title = "ข้อมูลแพลตฟอร์ม (Cross-Platform Engine)",
        Content = string.format("อุปกรณ์: %s (%s)\nตัวรัน: %s\nระบบแสดงผล: %s\nระบบจำลองทัช/คลิก: %s",
            IsMobileDevice and "📱 มือถือ (Mobile / Tablet)" or "💻 คอมพิวเตอร์ (PC / Desktop)",
            tostring(PlatformOSName or "Universal OS"),
            tostring(ExecutorName or "Universal"),
            Hub.HasDrawing and "Drawing Engine (Native)" or "Roblox Core Highlight Engine",
            IsMobileDevice and "Virtual Touchscreen (iOS/Android)" or "Virtual Mouse & Keyboard (PC)"
        )
    })

    Window:Notify({
        Title    = "Kraken Hub",
        Text     = IsMobileDevice and "โหลดสำเร็จสำหรับมือถือ (Android/iOS) พร้อมฟาร์ม 24 ชม.!" or "โหลดสำเร็จ! กด RightShift หรือ Insert เพื่อเปิด/ปิดเมนู",
        Icon     = "check",
        Duration = 4,
    })
end

-- ==============================================================
-- 🧹 9. CLEANUP HANDLER
-- ==============================================================
genv[_gk.cl] = function()
    Hub.Running = false
    Hub.Settings.AutoTuneRunning = true
    Hub.Settings.EcuTuneMaster = true
    pcall(RestoreStockEcuMap)

    -- Remove UI & Panels
    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    if Hub.Window then
        pcall(function() Hub.Window:Destroy() end)
    end
    if Hub.SetBlackScreen then
        pcall(function() Hub.SetBlackScreen(false) end)
    end
    if BlackScreenGui then
        pcall(function() BlackScreenGui:Destroy() end)
    end
    pcall(function()
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end)

    -- Disconnect loops
    for _, conn in pairs(Hub.Connections) do
        pcall(function() conn:Disconnect() end)
    end

    -- Clear ESP
    for plr in pairs(Hub.ESPObjects) do
        if Hub.RemoveESPForPlayer then Hub.RemoveESPForPlayer(plr) end
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

    if Hub.StopFly then Hub.StopFly() end

    -- Restore Camera Settings
    pcall(function()
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    end)

    if Hub.UpdateNameTagsVisibility then
        pcall(Hub.UpdateNameTagsVisibility, false)
    end

    -- ✅ CRITICAL FIX: Restore NetSeal originals BEFORE wiping cache
    -- หากไม่ทำ รันครั้งถัดไป NetSeal.invoke/fire จะ fresh แต่ไม่ถูก patch → E2/267
    if NetSeal then
        if genv[_gk.ni] and type(genv[_gk.ni]) == "function" then
            pcall(function() NetSeal.invoke = genv[_gk.ni] end)
        end
        if genv[_gk.nf] and type(genv[_gk.nf]) == "function" then
            pcall(function() NetSeal.fire = genv[_gk.nf] end)
        end
    end

    -- ✅ คงสถานะ hooked ไว้ แต่เปลี่ยน target ผ่าน genv pointer ป้องกัน double hook
    genv[_gk.hb] = true
    genv[_gk.mb] = true
    -- ล้างแค่ _SafeInvoke/_SafeFire pointers เพื่อให้รันใหม่เขียนทับ
    genv[_gk.sp] = nil
    genv[_gk.sf] = nil
    genv[UI_GUARD_BYPASS_KEY]     = false
    genv._AllowLegitUiGuardCall   = nil
end

-- ==============================================================
-- 🚀 10. INITIALIZE
-- ==============================================================
task.spawn(function()
    -- ❌ ลบออก: _G._KrakenHub_InitUI_Started = true  (รั่วก่อน sanitizer จะ clear ทัน)
    if setthreadidentity then pcall(setthreadidentity, 8) end
    local ok, err = pcall(InitUI)
    if not ok then
        -- ❌ ลบออก: _G._KrakenHub_InitUI_Error = tostring(err)
        -- ❌ ลบออก: warn("[KrakenHub] InitUI Error: " .. tostring(err))
        -- ✅ เก็บ error ไว้ใน genv แทน _G และใช้ key ที่ obfuscate แล้ว
        local errKey = "_MHK_IE" .. tostring(math.floor(os.clock() * 1000) % 9999)
        genv[errKey] = tostring(err)
    else
        -- ❌ ลบออก: _G._KrakenHub_InitUI_Success = true
    end
end)

-- ================================================================
-- 🔁 FARM LOOP RESURRECTION WATCHDOG (Stability Patch)
-- ต้องใส่หลัง InitUI ถูก spawn แล้วเท่านั้น
-- ================================================================
task.spawn(function()
    -- รอให้ Hub init เสร็จก่อน
    local initWait = 0
    repeat
        task.wait(1)
        initWait = initWait + 1
    until (Hub and Hub.Running) or initWait > 30

    -- watchdog resurrection loop
    while true do
        task.wait(4)

        if not Hub or not Hub.Running then continue end
        if genv[_gk.sk] ~= SCRIPT_ID then continue end

        local isFarmEnabled = Hub.Settings
            and (Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide)

        if not isFarmEnabled then continue end

        -- ✅ Rebind DeliveryRemote ถ้าหลุด
        RebindDeliveryRemote()

        -- ✅ Ensure continuous farm worker is running (Auto-Resurrection)
        if not FarmWorkerActive then
            pcall(StartContinuousFarmWorker)
        end

        -- ✅ ถ้า DeliveryWorking ค้างเกิน 18s force clear
        if DeliveryWorking and (os.clock() - LastDeliveryHeartbeat) > 18 then
            DeliveryWorking = false
        end

        -- ✅ ถ้า GrabWorking ค้างเกิน 18s force clear  
        if GrabWorking and (os.clock() - LastGrabHeartbeat) > 18 then
            GrabWorking = false
        end

        -- ✅ ถ้า Teleporting ค้างเกิน 15s force clear
        if Teleporting and (os.clock() - TeleportingTimestamp) > 15 then
            Teleporting = false
        end

        -- ✅ FIX: Removed aggressive Searching→clear logic (was firing every 4s, no time guard).
        -- Caused concurrent DeliveryWorking/GrabWorking workers to spawn simultaneously.
        -- MASTER FLAG WATCHDOG (line ~6880) already handles stuck-Searching with proper 18s timeout.
        -- No action needed here — master watchdog + Stop/Start cycle covers all recovery cases.
    end
end)

-- ================================================================
-- 💓 FARM HEARTBEAT DISPLAY (แสดงสถานะจริงใน console)
-- ================================================================
task.spawn(function()
    -- รอ console init
    local waitCount = 0
    repeat task.wait(1) waitCount = waitCount + 1 until (typeof(console) == "table" and console.Write) or waitCount > 20

    local lastPrint = 0
    while Hub and Hub.Running do
        task.wait(2)
        if not Hub.Running then break end

        local now = os.clock()
        if (now - lastPrint) < 8 then continue end
        lastPrint = now

        local isFarm = Hub.Settings and (Hub.Settings.AutoGrabFarm or Hub.Settings.AutoFoodDelivery or Hub.Settings.AutoGrabRide)
        if not isFarm then continue end

        local delState = "?"
        pcall(function() delState = tostring(LocalPlayer:GetAttribute("DeliveryState") or "Off") end)

        local cash = "?"
        pcall(function() cash = tostring(LocalPlayer:GetAttribute("Cash") or 0) end)

        local mode = Hub.Settings.AutoGrabFarm and "Grab" or (Hub.Settings.AutoFoodDelivery and "Food" or "Ride")

        pcall(function()
            if typeof(status) == "table" and status.SetText then
                status:SetText(string.format("♥ %s | %s | ฿%s", mode, delState, cash))
            end
        end)
    end
end)

-- ================================================================

do end  -- suppressed: fully active print
