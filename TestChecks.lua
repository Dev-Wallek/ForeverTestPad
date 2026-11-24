-- What the test window checks by itself, by test ID: { label, met = fn(run) }.
-- Tests.lua asks each unmet check once a second while its test runs; a check
-- once met stays met for that run. A test with `auto` passes by itself when
-- all its checks are met and nothing was blocked. run.printed holds the
-- lines ImprovedForever printed since the test started.
local _, TP = ...

local function Loaded(name)
    return C_AddOns.IsAddOnLoaded(name)
end

local function On(name)
    return { label = name .. " an", met = function() return Loaded(name) end }
end

local TAINT_LOG = { label = "Taint-Log an (/console taintLog 1)", met = function() return GetCVar("taintLog") == "1" end }

local function Printed(label, pattern)
    return {
        label = label,
        met = function(run)
            for _, line in ipairs(run.printed) do
                if line:find(pattern) then return true end
            end
        end,
    }
end

local SCAN_DONE = Printed("Scan fertig („auction scan done“)", "auction scan done")

-- An item ImprovedForever_Auction has a price for on this realm
local function PricedItem()
    local store = ImprovedForeverAuctionDB and ImprovedForeverAuctionDB.realms
    local realm = store and store[GetNormalizedRealmName() or GetRealmName()]
    return realm and next(realm.items or {})
end

local function Price(itemID)
    local auction = ImprovedForever and ImprovedForever.Auction
    if auction and auction.Price then return auction.Price(itemID) end
end

local CHECKS = {
    [86] = {
        SCAN_DONE,
        {
            label = "Price gibt für ein Item mit Preis drei Zahlen",
            met = function()
                local itemID = PricedItem()
                local cheapest, _, days = Price(itemID or 1)
                return itemID ~= nil and type(cheapest) == "number" and type(days) == "number"
            end,
        },
        { label = "Price gibt für ein unbekanntes Item nichts", met = function() return Price(1) == nil end },
    },
    [87] = {
        {
            label = "„Auction window“ aus",
            met = function()
                local auction = ImprovedForever and ImprovedForever.Auction
                return auction ~= nil and auction.Settings().buy == false
            end,
        },
        SCAN_DONE,
    },
    [69] = { TAINT_LOG },
    [72] = { On("BagSync") },
    [90] = {
        {
            label = "Ein Wheel der Art „Cancel buffs“ ist angelegt",
            met = function()
                local wheels = ImprovedForever and ImprovedForever.MyWheels
                return wheels ~= nil and wheels.HasKind("cancel")
            end,
        },
    },
    [92] = {
        TAINT_LOG,
        {
            label = "Eckig an",
            met = function(run)
                local minimap = ImprovedForever and ImprovedForever.Minimap
                run.wasSquare = run.wasSquare or (minimap ~= nil and minimap.Settings().square
                    and GetMinimapShape() == "SQUARE")
                return run.wasSquare
            end,
        },
        {
            label = "Danach wieder rund",
            met = function(run)
                return run.wasSquare and GetMinimapShape() == "ROUND"
            end,
        },
    },
    [93] = { TAINT_LOG },
    [144] = { On("ImprovedForever_Threat") },
    [151] = { Printed("Brief voll („The mail is full“)", "The mail is full") },
    [152] = { TAINT_LOG },
    [153] = { Printed("Erinnerung im Chat („rested experience“)", "rested experience") },
}

function TP.TestChecks(id)
    return CHECKS[id] or {}
end
