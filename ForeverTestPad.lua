local addonName, TP = ...

-- Subcommands of /tp probe, filled by Probe.lua: probes[name](arg).
TP.probes = {}

local MAX_LOG = 3000

function TP.Print(text)
    print("|cff33ff99ForeverTestPad|r " .. text)
end

function TP.Log(text)
    local log = ForeverTestPadDB.probe
    if #log < MAX_LOG then
        log[#log + 1] = string.format("%.2f %s", GetTime() % 1000, text)
    elseif #log == MAX_LOG then
        log[#log + 1] = "log full"
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
-- Logged always: these say whether taint blocked an action, with the guilty addon.
events:RegisterEvent("ADDON_ACTION_BLOCKED")
events:RegisterEvent("ADDON_ACTION_FORBIDDEN")
events:SetScript("OnEvent", function(_, event, name, func)
    if event == "ADDON_LOADED" and name == addonName then
        ForeverTestPadDB = ForeverTestPadDB or {}
        ForeverTestPadDB.probe = ForeverTestPadDB.probe or {}
    elseif event == "PLAYER_LOGIN" then
        TP.Log("login")
        TP.Print("geladen.")
        -- The chat line "Interface action failed" appeared without an ADDON_ACTION_* event reaching us.
        if DisplayInterfaceActionBlockedMessage then
            hooksecurefunc("DisplayInterfaceActionBlockedMessage", function()
                TP.Log("blocked message shown\n" .. debugstack(2, 8, 0))
            end)
        end
    elseif event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN" then
        TP.Log(event .. " addon=" .. tostring(name) .. " func=" .. tostring(func))
    end
end)

SLASH_FOREVERTESTPAD1 = "/tp"
SLASH_FOREVERTESTPAD2 = "/testpad"
SlashCmdList.FOREVERTESTPAD = function(msg)
    local command, name, arg = strsplit(" ", strtrim(msg), 3)
    if command == "tests" then
        TP.ToggleTests()
        return
    end
    local probe = command == "probe" and TP.probes[(name or ""):lower()]
    if probe then
        probe(arg)
        return
    end
    local names = {}
    for key in pairs(TP.probes) do names[#names + 1] = key end
    table.sort(names)
    TP.Print("/tp tests | /tp probe " .. table.concat(names, " | "))
end
