-- /tp tests: the in-game tests (TestData.lua, made from the test list by
-- tools/tests_to_lua.py) one at a time, like quests. Start runs one: its
-- checks (TestChecks.lua) are asked once a second, a blocked action is kept
-- with the addon the game blames. Passed / failed / skipped go to
-- ForeverTestPadDB.tests[id], with a screenshot for passed and failed;
-- tools/test_results.lua lists them. Escape closes the window (UISpecialFrames).
-- The pad, while it's open: A start, X passed, Y failed, RB skip, LB
-- screenshot, D-pad left / right the test before / after, up / down
-- scroll, B close.
local _, TP = ...

local READY = "|TInterface\\RaidFrame\\ReadyCheck-Ready:14|t "
local WAITING = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:14|t "
local STATE_TEXT = { pass = "|cff33ff33bestanden|r", fail = "|cffff3333nicht bestanden|r", skip = "übersprungen" }

local index = 1
local run            -- the test under way: { id, printed, met, blocked, shots, started }
local win, banner

local function Results()
    ForeverTestPadDB.tests = ForeverTestPadDB.tests or {}
    return ForeverTestPadDB.tests
end

local function Current()
    return TP.TESTS[index]
end

-- The first test from `from` on (wrapping) not yet passed
local function NextOpen(from)
    local n = #TP.TESTS
    for step = 0, n - 1 do
        local i = (from - 1 + step) % n + 1
        local result = Results()[TP.TESTS[i].id]
        if not (result and result.state == "pass") then return i end
    end
    return from
end

---------------------------------------------------------------------------
-- Screenshots: the window and banner hidden for the shot
---------------------------------------------------------------------------
local shotPending = nil
local ShotDone

-- Only from a press (a click, a pad button): the game takes a screenshot
-- only in a hardware event's call. into: the list its line goes to
local function Shot(reason, into)
    if shotPending then return end
    shotPending = { reason = reason, reopen = win and win:IsShown(), into = into }
    if win then win:Hide() end
    banner:Hide()
    Screenshot()
    -- (no SCREENSHOT_* event: the window comes back anyway)
    local pending = shotPending
    C_Timer.After(5, function()
        if shotPending == pending then ShotDone(false) end
    end)
end

function ShotDone(ok)
    local pending = shotPending
    shotPending = nil
    if not pending then return end
    local entry = date("%Y-%m-%d %H:%M:%S") .. " " .. pending.reason .. (ok and "" or " (failed)")
    if pending.into then pending.into[#pending.into + 1] = entry end
    TP.Log("test shot " .. entry)
    if pending.reopen then win:Show() end
    TP.RefreshTests()
end

---------------------------------------------------------------------------
-- A run
---------------------------------------------------------------------------
local function Tick()
    if not run then return end
    local checks = TP.TestChecks(run.id)
    local all = #checks > 0
    for i, check in ipairs(checks) do
        if not run.met[i] then
            local ok, met = pcall(check.met, run)
            run.met[i] = ok and met and true or nil
        end
        all = all and run.met[i]
    end
    if all and checks.auto and #run.blocked == 0 then
        TP.FinishTest("pass", "von selbst")
        return
    end
    TP.RefreshTests()
end

local ticker

function TP.StartTest()
    local test = Current()
    run = { id = test.id, printed = {}, met = {}, blocked = {}, shots = {}, started = date("%Y-%m-%d %H:%M:%S") }
    -- (saved, so a /reload inside the test keeps it)
    ForeverTestPadDB.testRun = run
    TP.Log("test start " .. test.id)
    if not ticker then ticker = C_Timer.NewTicker(1, Tick) end
    Tick()
end

function TP.FinishTest(state, how)
    local test = Current()
    local result = { state = state, at = date("%Y-%m-%d %H:%M:%S"), note = win.note:GetText() }
    if run and run.id == test.id then
        result.started, result.blocked, result.shots = run.started, run.blocked, run.shots
        result.met = {}
        for i, check in ipairs(TP.TestChecks(test.id)) do
            if run.met[i] then result.met[#result.met + 1] = check.label end
        end
    end
    result.how = how
    Results()[test.id] = result
    TP.Log("test " .. test.id .. " " .. state)
    TP.Print("Test " .. test.id .. ": " .. STATE_TEXT[state] .. ".")
    if state ~= "skip" then
        result.shots = result.shots or {}
        Shot(state, result.shots)
    end
    if run and run.id == test.id then
        run, ForeverTestPadDB.testRun = nil, nil
        if ticker then ticker:Cancel(); ticker = nil end
    end
    win.note:SetText("")
    index = NextOpen(index % #TP.TESTS + 1)
    TP.RefreshTests()
end

local function Blocked(event, addon, func)
    if not run then return end
    local line = date("%H:%M:%S") .. " " .. event .. " " .. tostring(addon) .. " " .. tostring(func)
    run.blocked[#run.blocked + 1] = line
    TP.RefreshTests()
end

---------------------------------------------------------------------------
-- The window
---------------------------------------------------------------------------
local function Body(test)
    local parts = {}
    if test.prep ~= "" then parts[#parts + 1] = "|cffaaaaaaVorher: " .. test.prep .. "|r" end
    parts[#parts + 1] = test.text
    for _, note in ipairs(test.combat) do parts[#parts + 1] = "|cffffaa55Kampf: " .. note .. "|r" end
    return table.concat(parts, "\n\n")
end

local function Status(test)
    local lines = {}
    for i, check in ipairs(TP.TestChecks(test.id)) do
        local met = run and run.id == test.id and run.met[i]
        lines[#lines + 1] = (met and READY or WAITING) .. check.label
    end
    local result = Results()[test.id]
    if run and run.id == test.id then
        lines[#lines + 1] = "|cff33ff99Läuft seit " .. run.started:sub(12) .. "|r"
            .. (#run.blocked > 0 and ("  |cffff3333Blockiert: " .. #run.blocked .. "×|r") or "")
    elseif result then
        lines[#lines + 1] = "Zuletzt " .. STATE_TEXT[result.state] .. " (" .. result.at .. ")"
    end
    return table.concat(lines, "\n")
end

function TP.RefreshTests()
    if not win then return end
    local test = Current()
    local open = 0
    for _, t in ipairs(TP.TESTS) do
        local result = Results()[t.id]
        if not (result and result.state == "pass") then open = open + 1 end
    end
    win.TitleText:SetText("Test " .. test.id .. " · " .. test.section .. " (" .. open .. " offen)")
    win.body:SetText(Body(test))
    win.child:SetHeight(win.body:GetStringHeight() + 4)
    win.scroll:UpdateScrollChildRect()
    win.status:SetText(Status(test))
    win.start:SetText(run and run.id == test.id and "Neu starten" or "Start")
    if run and not win:IsShown() and not shotPending then
        banner.text:SetText("Test " .. run.id .. " läuft · /tp tests" .. (#run.blocked > 0 and " · blockiert!" or ""))
        banner:Show()
    else
        banner:Hide()
    end
end

local function Button(parent, label, width, onClick)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24)
    b:SetText(label)
    b:SetScript("OnClick", onClick)
    return b
end

local function Build()
    win = CreateFrame("Frame", "ForeverTestPadTests", UIParent, "BasicFrameTemplateWithInset")
    win:SetSize(520, 460)
    win:SetPoint("CENTER")
    win:SetFrameStrata("HIGH")
    win:SetMovable(true)
    win:EnableMouse(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", win.StopMovingOrSizing)
    win:SetScript("OnShow", TP.RefreshTests)
    win:SetScript("OnHide", TP.RefreshTests)
    tinsert(UISpecialFrames, "ForeverTestPadTests")

    local scroll = CreateFrame("ScrollFrame", nil, win, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 14, -32)
    scroll:SetPoint("BOTTOMRIGHT", -34, 170)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetSize(460, 1)
    scroll:SetScrollChild(child)
    local body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT")
    body:SetWidth(460)
    body:SetJustifyH("LEFT")
    body:SetSpacing(2)
    win.scroll, win.child, win.body = scroll, child, body

    local status = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    status:SetPoint("TOPLEFT", win, "BOTTOMLEFT", 16, 162)
    status:SetWidth(488)
    status:SetJustifyH("LEFT")
    win.status = status

    local note = CreateFrame("EditBox", nil, win, "InputBoxTemplate")
    note:SetSize(470, 22)
    note:SetPoint("BOTTOMLEFT", 22, 68)
    note:SetAutoFocus(false)
    note:SetScript("OnEnterPressed", note.ClearFocus)
    note:SetScript("OnEscapePressed", note.ClearFocus)
    local noteLabel = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    noteLabel:SetPoint("BOTTOMLEFT", note, "TOPLEFT", -4, 2)
    noteLabel:SetText("Notiz (optional)")
    win.note = note

    local function Move(step)
        index = (index - 1 + step) % #TP.TESTS + 1
        TP.RefreshTests()
    end
    local actions = {
        PADDLEFT = function() Move(-1) end,
        PADDRIGHT = function() Move(1) end,
        PAD1 = function() TP.StartTest() end,
        PADLSHOULDER = function() Shot("manual", run and run.shots) end,
        PAD3 = function() TP.FinishTest("pass") end,
        PAD4 = function() TP.FinishTest("fail") end,
        PADRSHOULDER = function() TP.FinishTest("skip") end,
        PAD2 = function() win:Hide() end,
        PADDUP = function() scroll:SetVerticalScroll(math.max(0, scroll:GetVerticalScroll() - 40)) end,
        PADDDOWN = function()
            scroll:SetVerticalScroll(math.min(scroll:GetVerticalScrollRange(), scroll:GetVerticalScroll() + 40))
        end,
    }
    local row1 = {
        Button(win, "<", 56, actions.PADDLEFT),
        Button(win, "Start (A)", 110, actions.PAD1),
        Button(win, "Screenshot (LB)", 130, actions.PADLSHOULDER),
        Button(win, ">", 56, actions.PADDRIGHT),
    }
    local row2 = {
        Button(win, "Bestanden (X)", 150, actions.PAD3),
        Button(win, "Nicht bestanden (Y)", 150, actions.PAD4),
        Button(win, "Überspringen (RB)", 150, actions.PADRSHOULDER),
    }
    -- (the pad's presses while it's open; never switched in a fight)
    win:SetScript("OnGamePadButtonDown", function(_, button)
        if actions[button] then actions[button]() end
    end)
    win:EnableGamePadButton(false)
    local function Pad(on)
        if not InCombatLockdown() then win:EnableGamePadButton(on) end
    end
    win:HookScript("OnShow", function() Pad(true) end)
    win:HookScript("OnHide", function() Pad(false) end)
    win.start = row1[2]
    for i, b in ipairs(row1) do
        b:SetPoint("BOTTOMLEFT", row1[i - 1] or win, row1[i - 1] and "BOTTOMRIGHT" or "BOTTOMLEFT",
            row1[i - 1] and 8 or 16, row1[i - 1] and 0 or 40)
    end
    for i, b in ipairs(row2) do
        b:SetPoint("BOTTOMLEFT", row2[i - 1] or win, row2[i - 1] and "BOTTOMRIGHT" or "BOTTOMLEFT",
            row2[i - 1] and 8 or 16, row2[i - 1] and 0 or 12)
    end
    win:Hide()
end

local function BuildBanner()
    banner = CreateFrame("Frame", nil, UIParent)
    banner:SetSize(420, 22)
    banner:SetPoint("TOP", 0, -6)
    banner:SetFrameStrata("HIGH")
    local bg = banner:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.6)
    banner.text = banner:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    banner.text:SetPoint("CENTER")
    banner:Hide()
end

function TP.ToggleTests()
    if not win then
        Build()
        index = NextOpen(1)
        -- (a run kept over /reload: its test)
        for i, t in ipairs(TP.TESTS) do
            if run and t.id == run.id then index = i end
        end
    end
    win:SetShown(not win:IsShown())
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
BuildBanner()
local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("ADDON_ACTION_BLOCKED")
events:RegisterEvent("ADDON_ACTION_FORBIDDEN")
events:RegisterEvent("SCREENSHOT_SUCCEEDED")
events:RegisterEvent("SCREENSHOT_FAILED")
events:SetScript("OnEvent", function(_, event, addon, func)
    if event == "PLAYER_LOGIN" then
        run = ForeverTestPadDB.testRun
        if run then ticker = C_Timer.NewTicker(1, Tick) end
        local IF = rawget(_G, "ImprovedForever")
        if IF and IF.Print then
            hooksecurefunc(IF, "Print", function(msg)
                if run then run.printed[#run.printed + 1] = tostring(msg) end
            end)
        end
    elseif event == "SCREENSHOT_SUCCEEDED" or event == "SCREENSHOT_FAILED" then
        ShotDone(event == "SCREENSHOT_SUCCEEDED")
    else
        Blocked(event, addon, func)
    end
end)
