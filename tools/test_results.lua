-- Lists the results the test window (/tp tests) saved: luajit tools/test_results.lua [file]
-- Run from this repo's root. The file defaults to every account's SavedVariables/ForeverTestPad.lua
-- under ../wow_addons/../../WTF, the game's AddOns folder linked beside this repo (TP_SAVED names one instead).
-- The game writes it on /reload or logout.
local files = {}
local given = arg[1] or os.getenv("TP_SAVED")
if given then
    files[1] = given
else
    local list = io.popen('ls ../wow_addons/../../WTF/Account/*/SavedVariables/ForeverTestPad.lua 2>/dev/null')
    for path in list:lines() do files[#files + 1] = path end
    list:close()
end
if #files == 0 then
    print("no ForeverTestPad.lua found; pass its path")
    os.exit(1)
end

for _, path in ipairs(files) do
    ForeverTestPadDB = nil
    dofile(path)
    local results = ForeverTestPadDB and ForeverTestPadDB.tests or {}
    local ids = {}
    for id in pairs(results) do ids[#ids + 1] = id end
    table.sort(ids)
    print(path .. ": " .. #ids .. " result(s)")
    for _, id in ipairs(ids) do
        local r = results[id]
        print(string.format("%3d %-4s %s%s%s", id, r.state, r.at, r.how and (" (" .. r.how .. ")") or "",
            (r.note or "") ~= "" and ("  note: " .. r.note) or ""))
        for _, label in ipairs(r.met or {}) do print("      met: " .. label) end
        for _, line in ipairs(r.blocked or {}) do print("      blocked: " .. line) end
        for _, line in ipairs(r.shots or {}) do print("      shot: " .. line) end
    end
end
