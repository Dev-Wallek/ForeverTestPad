-- /tp probe start|stop|clear: logs into ForeverTestPadDB.probe every change of
-- the frame manager's focus and row, and every pad button press. Presses are
-- polled with IsKeyDown, not caught by a frame of ours, so the probe takes no
-- input away from the game.
local _, TP = ...
local P = TP.probes

local SHOULDERS = { "PADLSHOULDER", "PADRSHOULDER", "PADLTRIGGER", "PADRTRIGGER" }
local BUTTONS = { "PAD1", "PAD2", "PAD3", "PAD4", "PAD5", "PAD6", "PADDUP", "PADDDOWN", "PADDLEFT", "PADDRIGHT",
    "PADLSHOULDER", "PADRSHOULDER", "PADLTRIGGER", "PADRTRIGGER", "PADLSTICK", "PADRSTICK", "PADBACK", "PADFORWARD",
    "PADSOCIAL", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4" }

-- tostring errors on secret values.
local function Str(value)
    local ok, text = pcall(tostring, value)
    return ok and text or "<hidden>"
end

local function Name(frame)
    if not frame then return "nil" end
    local ok, name = pcall(function() return frame:GetName() or frame:GetDebugName() end)
    return ok and Str(name) or "<forbidden>"
end

local function FocusState()
    local manager = GamepadMode and GamepadMode.FrameControlsManager
    if not manager then return "no FrameControlsManager" end
    local shown = {}
    for i, frame in ipairs(manager.shownFrames or {}) do shown[i] = Name(frame) end
    return "focus=" .. Name(manager.focusedFrame) .. " uiFocused=" .. Str(manager.isUIFocused)
        .. " shown={" .. table.concat(shown, ",") .. "}"
end

local function Bindings()
    local parts = {}
    for i, key in ipairs(SHOULDERS) do parts[i] = key .. "=" .. Str(GetBindingAction(key, true)) end
    return table.concat(parts, " ")
end

local function NavButton()
    local ok, button = pcall(function() return SmartNavigation:GetCurrentButton() end)
    return ok and Name(button) or "?"
end

-- Shown frames that take pad buttons themselves (OnGamePadButtonDown).
local function Receivers()
    local names = {}
    local frame = EnumerateFrames()
    while frame do
        local ok, on = pcall(function() return frame:IsGamePadButtonEnabled() and frame:IsVisible() end)
        if ok and on then names[#names + 1] = Name(frame) end
        frame = EnumerateFrames(frame)
    end
    return table.concat(names, ",")
end

local watcher = CreateFrame("Frame")
local held, lastState = {}, nil
local watched, lastWatched -- name of a frame whose shown state and anchors the probe follows

local function WatchedState()
    local frame = _G[watched]
    if not frame then return "missing" end
    local points = {}
    for i = 1, frame:GetNumPoints() do
        local point, relative, relativePoint, x, y = frame:GetPoint(i)
        points[i] = Str(point) .. ">" .. Name(relative) .. ":" .. Str(relativePoint) .. " " .. Str(x) .. "," .. Str(y)
    end
    return "shown=" .. Str(frame:IsShown()) .. " visible=" .. Str(frame:IsVisible()) .. " alpha=" .. Str(frame:GetAlpha())
        .. " points={" .. table.concat(points, ";") .. "}"
end

local function Watch()
    for _, button in ipairs(BUTTONS) do
        local down = IsKeyDown(button)
        if down and not held[button] then
            TP.Log("press " .. button .. " action=" .. Str(GetBindingAction(button, true)) .. " nav=" .. NavButton()
                .. " receivers={" .. Receivers() .. "} " .. FocusState())
        end
        held[button] = down
    end
    local state = FocusState() .. " " .. Bindings()
    if state ~= lastState then
        lastState = state
        TP.Log("state " .. state)
    end
    if watched then
        local now = WatchedState()
        if now ~= lastWatched then
            lastWatched = now
            TP.Log("watch " .. watched .. " " .. now)
        end
    end
end

-- arg: global frame name the running probe also follows; without arg, none.
function P.watch(arg)
    watched, lastWatched = arg, nil
    TP.Print("Beobachte " .. Str(arg) .. ". Läuft mit /tp probe start.")
end

function P.start()
    lastState = nil
    TP.Log("start " .. date("%Y-%m-%d %H:%M:%S") .. " build=" .. Str(select(4, GetBuildInfo()))
        .. " version=" .. Str(GetBuildInfo()))
    watcher:SetScript("OnUpdate", Watch)
    TP.Print("Sonde läuft. /tp probe stop, dann /reload zum Speichern.")
end

function P.stop()
    watcher:SetScript("OnUpdate", nil)
    TP.Log("stop")
    TP.Print("Sonde gestoppt, " .. #ForeverTestPadDB.probe .. " Zeilen. /reload zum Speichern.")
end

function P.clear()
    wipe(ForeverTestPadDB.probe)
    TP.Print("Log geleert.")
end

local function Done(name, text)
    TP.Log(name .. ": " .. text)
    TP.Print("Sonde " .. name .. ": " .. text)
end

-- arg: global frame name; logs its anchors, children and parent chain.
function P.frame(arg)
    local frame = arg and _G[arg]
    if type(frame) ~= "table" or not frame.GetParent then return Done("frame", "no frame " .. Str(arg)) end
    local points, children = {}, {}
    for i = 1, frame:GetNumPoints() do
        local point, relative, relativePoint = frame:GetPoint(i)
        points[i] = Str(point) .. ">" .. Name(relative) .. ":" .. Str(relativePoint)
    end
    for i, child in ipairs({ frame:GetChildren() }) do children[i] = Name(child) .. (child:IsShown() and "+" or "-") end
    Done("frame", Name(frame) .. " points={" .. table.concat(points, ",") .. "} children={" .. table.concat(children, ",") .. "}")
    while frame do
        local ok, info = pcall(function()
            return Name(frame) .. " shown=" .. Str(frame:IsShown()) .. " visible=" .. Str(frame:IsVisible())
                .. " alpha=" .. Str(frame:GetAlpha()) .. " effAlpha=" .. Str(frame:GetEffectiveAlpha())
                .. " strata=" .. Str(frame:GetFrameStrata()) .. " mouse=" .. Str(frame:IsMouseEnabled())
        end)
        Done("frame", ok and info or Str(info))
        frame = frame:GetParent()
    end
end

---------------------------------------------------------------------------
-- S-3 taint experiments, one subcommand each. Each may taint the game's
-- state until /reload; that is what they measure. Blocked actions land in the
-- log through ForeverTestPad.lua's ADDON_ACTION_* handler.
---------------------------------------------------------------------------

local function Keys(map)
    local keys = {}
    for key in pairs(map) do keys[#keys + 1] = Str(key) end
    table.sort(keys)
    return table.concat(keys, ",")
end

local function BagView()
    for _, name in ipairs(UISpecialFrames) do
        local frame = _G[name]
        if name:find("^Baganator_.*BackpackViewFrame") and frame and frame:IsVisible() then return frame end
    end
end

local function FirstItem(frame)
    for _, child in ipairs({ frame:GetChildren() }) do
        if child:IsVisible() then
            if child.GetBagID then return child end
            local found = FirstItem(child)
            if found then return found end
        end
    end
end

-- A button of ours on top of everything, for experiments that need a click.
local function ClickButton(name, text, y, template)
    local button = _G[name]
    if not button then
        button = CreateFrame("Button", name, UIParent, (template and template .. "," or "") .. "UIPanelButtonTemplate")
        button:SetSize(220, 28)
        button:SetPoint("TOP", 0, y)
        button:SetFrameStrata("FULLSCREEN_DIALOG")
        button:SetText(text)
    end
    button:Show()
    return button
end

-- A shown frame of ours for OnClick handlers that anchor menus or tooltips.
local anchor = CreateFrame("Frame", "ForeverTestPadProbeAnchor", UIParent)
anchor:SetSize(32, 32)
anchor:SetPoint("TOP", 0, -200)

-- Forever's real cursor on a Baganator item, through SmartNavigation (the
-- frame manager is not involved).
function P.cursor()
    local view = BagView()
    local item = view and FirstItem(view)
    if not item then return Done("cursor", "no Baganator backpack window with items open") end
    local before = NavButton()
    local ok, err = pcall(function() SmartNavigation:SelectButton(item) end)
    local pointer = SmartNavigation and SmartNavigation.Pointer
    Done("cursor", "SelectButton ok=" .. Str(ok) .. " err=" .. Str(err) .. " nav " .. before .. " -> " .. NavButton()
        .. " pointerShown=" .. Str(pointer and pointer:IsShown()) .. " " .. FocusState())
end

local function CategoriesByName()
    local found = {}
    pcall(function()
        for _, category in ipairs(SettingsPanel:GetCategoryList():GetAllCategories()) do
            found[category:GetName()] = category
        end
    end)
    return found
end

-- arg: category name as shown in the AddOns tab. Opens it the way ForeverCore
-- does: the client's restricted opener through securecallfunction, since
-- Settings.OpenToCategory runs Blizzard Lua under our call path. The opener
-- wants a number; some addons (Baganator) set a string ID, so the log lists
-- the category's numeric fields as candidates.
function P.settings(arg)
    arg = arg or "KeepOrSell"
    local category = CategoriesByName()[arg]
    if not category then return Done("settings", "no category " .. Str(arg) .. ", known={" .. Keys(CategoriesByName()) .. "}") end
    local numbers = {}
    for key, value in pairs(category) do
        if type(value) == "number" then numbers[#numbers + 1] = Str(key) .. "=" .. value end
    end
    local id = category:GetID()
    if type(id) ~= "number" then return Done("settings", arg .. " id=" .. Str(id) .. " numbers={" .. table.concat(numbers, ",") .. "}") end
    local ok, err = pcall(securecallfunction, C_SettingsUtil.OpenSettingsPanel, id)
    Done("settings", arg .. " id=" .. id .. " ok=" .. Str(ok) .. " err=" .. Str(err))
end

-- arg: addon name.
function P.compartment(arg)
    arg = arg or "Baganator"
    local func = C_AddOns.GetAddOnMetadata(arg, "AddonCompartmentFunc")
    local fn = func and _G[strtrim(func)]
    if type(fn) ~= "function" then return Done("compartment", arg .. " has no AddonCompartmentFunc (" .. Str(func) .. ")") end
    local ok, err = pcall(fn, arg, "LeftButton", anchor)
    Done("compartment", arg .. " " .. func .. " ok=" .. Str(ok) .. " err=" .. Str(err))
end

-- arg: LibDataBroker object name; without it, logs the known names.
function P.ldb(arg)
    local ldb = LibStub and LibStub("LibDataBroker-1.1", true)
    if not ldb then return Done("ldb", "no LibDataBroker loaded") end
    local names = {}
    for name in ldb:DataObjectIterator() do names[name] = true end
    local object = arg and ldb:GetDataObjectByName(arg)
    if not (object and object.OnClick) then return Done("ldb", "no launcher " .. Str(arg) .. ", known={" .. Keys(names) .. "}") end
    local icon = _G["LibDBIcon10_" .. arg]
    local frame = icon and icon:IsVisible() and icon or anchor
    local ok, err = pcall(object.OnClick, frame, "LeftButton")
    Done("ldb", arg .. " OnClick on " .. Name(frame) .. " ok=" .. Str(ok) .. " err=" .. Str(err))
end

local PAD1_SECONDS = 10
local padOwner = CreateFrame("Frame")
local padTarget = CreateFrame("Button", "ForeverTestPadProbePad1", UIParent)
padTarget:RegisterForClicks("AnyUp", "AnyDown")
padTarget:SetScript("OnClick", function(_, button, down)
    TP.Log("pad1: click reached ForeverTestPadProbePad1 " .. Str(button) .. " down=" .. Str(down))
end)

local function PadStop(reason)
    padOwner:SetScript("OnUpdate", nil)
    padOwner:UnregisterAllEvents()
    ClearOverrideBindings(padOwner)
    TP.Log("pad1: stopped (" .. reason .. ")")
end
padOwner:SetScript("OnEvent", function() PadStop("combat") end)

-- Binds PAD1 without priority to a button of ours while a Baganator window is
-- open, and logs every change of what PAD1 runs, read each frame.
function P.pad1()
    if InCombatLockdown() then return Done("pad1", "in combat") end
    local view = BagView()
    if not view then return Done("pad1", "no Baganator backpack window open") end
    SetOverrideBindingClick(padOwner, false, "PAD1", padTarget:GetName())
    padOwner:RegisterEvent("PLAYER_REGEN_DISABLED")
    local started, frames, last = GetTime(), 0, nil
    padOwner:SetScript("OnUpdate", function()
        frames = frames + 1
        local action = Str(GetBindingAction("PAD1", true))
        if action ~= last then
            last = action
            TP.Log("pad1: frame " .. frames .. " PAD1=" .. action)
        end
        if not view:IsVisible() then
            PadStop("window closed after " .. frames .. " frames")
        elseif GetTime() - started > PAD1_SECONDS then
            PadStop(PAD1_SECONDS .. "s, " .. frames .. " frames")
        end
    end)
    Done("pad1", "bound for " .. PAD1_SECONDS .. "s, press A on the Baganator window")
end

local function EnableStates()
    local states, player = {}, UnitName("player")
    for i = 1, C_AddOns.GetNumAddOns() do
        local ok, state = pcall(C_AddOns.GetAddOnEnableState, i, player)
        states[C_AddOns.GetAddOnInfo(i)] = ok and state or "error"
    end
    return states
end

-- Shows a button that saves the addon list and reloads; the next login logs
-- whether the enable states survived.
function P.addons()
    local button = ClickButton("ForeverTestPadProbeAddons", "TP: Speichern + neu laden", -60)
    button:SetScript("OnClick", function()
        ForeverTestPadDB.addonsBefore = EnableStates()
        TP.Log("addons: SaveAddOns + ReloadUI")
        C_AddOns.SaveAddOns()
        ReloadUI()
    end)
    Done("addons", "button shown")
end

local loginCheck = CreateFrame("Frame")
loginCheck:RegisterEvent("PLAYER_LOGIN")
loginCheck:SetScript("OnEvent", function()
    local before = ForeverTestPadDB.addonsBefore
    if not before then return end
    ForeverTestPadDB.addonsBefore = nil
    local after, changed, count = EnableStates(), {}, 0
    for name, state in pairs(before) do
        count = count + 1
        if after[name] ~= state then changed[#changed + 1] = name .. " " .. Str(state) .. "->" .. Str(after[name]) end
    end
    TP.Log("addons: after reload " .. count .. " compared, changed={" .. table.concat(changed, ",") .. "}")
end)

-- Rare creatures seen through unit events only, never a nameplate frame: each
-- creature once a run (its first event), the rare ones flagged; a hidden GUID once an
-- event. A second /tp probe rares turns it off.
local rareWatch = CreateFrame("Frame")
local RARE_EVENTS = { "NAME_PLATE_UNIT_ADDED", "UPDATE_MOUSEOVER_UNIT", "PLAYER_TARGET_CHANGED" }
local RARE_CLASSES = { rare = true, rareelite = true, worldboss = true }
local rareSeen, hiddenSeen
rareWatch:SetScript("OnEvent", function(_, event, unit)
    unit = unit or (event == "UPDATE_MOUSEOVER_UNIT" and "mouseover" or "target")
    local guid = UnitGUID(unit)
    if issecretvalue and issecretvalue(guid) then
        if not hiddenSeen[event] then TP.Log("rares: " .. event .. " guid <hidden>") end
        hiddenSeen[event] = true
        return
    end
    if type(guid) ~= "string" or rareSeen[guid] or not guid:find("^Creature") then return end
    rareSeen[guid] = true
    local class = UnitClassification(unit)
    local npc = select(6, strsplit("-", guid))
    TP.Log("rares: " .. event .. " " .. Str(unit) .. " class=" .. Str(class) .. " name=" .. Str(UnitName(unit))
        .. " npc=" .. Str(npc) .. (RARE_CLASSES[class] and " RARE" or ""))
    if RARE_CLASSES[class] then TP.Print("Sonde rares: " .. Str(UnitName(unit)) .. " (" .. Str(class) .. ")") end
end)

function P.rares()
    if rareSeen then
        for _, e in ipairs(RARE_EVENTS) do rareWatch:UnregisterEvent(e) end
        local n = 0
        for _ in pairs(rareSeen) do n = n + 1 end
        rareSeen = nil
        return Done("rares", "off, " .. n .. " creatures seen")
    end
    rareSeen, hiddenSeen = {}, {}
    for _, e in ipairs(RARE_EVENTS) do rareWatch:RegisterEvent(e) end
    Done("rares", "on: nameplates, mouseover and target")
end

local MACRO_LINES = 30

-- A secure macro button whose macrotext is far over 255 characters; each line
-- logs its number, so the log shows how far it ran.
function P.macro()
    if InCombatLockdown() then return Done("macro", "in combat") end
    local lines = {}
    for i = 1, MACRO_LINES do
        lines[i] = "/run local l=ForeverTestPadDB.probe l[#l+1]=\"macro: line " .. i .. " of " .. MACRO_LINES .. " ran\""
    end
    local text = table.concat(lines, "\n")
    local button = ClickButton("ForeverTestPadProbeMacro", "TP: Makro", -95, "SecureActionButtonTemplate")
    button:RegisterForClicks("AnyUp", "AnyDown")
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", text)
    Done("macro", "macrotext " .. #text .. " chars, " .. MACRO_LINES .. " lines, button shown")
end
