local _, private = ...

-- Lua Globals --
-- luacheck: globals ipairs

local Inventory = private.Inventory

function Inventory:OpenBags(frame)
    if frame ~= nil then return end
    self.main:Show()
end
function Inventory:CloseBags(frame)
    if frame ~= nil then return end
    self.main:Hide()
end
function Inventory:ToggleBags(frame)
    if frame ~= nil then return end
    if self.main:IsShown() then
        self.main:Hide()
    else
        self.main:Show()
    end
end

Inventory:RawHook("OpenBackpack", "OpenBags", true)
Inventory:SecureHook("CloseBackpack", "CloseBags")

Inventory:RawHook("ToggleBag", "ToggleBags", true)
Inventory:RawHook("ToggleBackpack", "ToggleBags", true)
Inventory:RawHook("ToggleAllBags", "ToggleBags", true)
Inventory:RawHook("OpenAllBags", "OpenBags", true)
Inventory:RawHook("OpenBag", "OpenBags", true)

-- FIXME
-- function Inventory:OpenBank()
--     self.bank:Show()
-- end
-- function Inventory:CloseBank()
--     self.bank:Hide()
-- end
-- _G.BankFrame:UnregisterAllEvents()
-- _G.BankFrame:SetScript("OnShow", nil)
-- _G.BankFrame:SetParent(_G.RealUI.UIHider)

local function MERCHANT_SHOW(event, ...)
    local bag = Inventory.main.bags.junk
    if not bag:IsShown() then return end
    if #bag.slots == 0 then
        -- items aren't updated yet, wait a frame.
        return _G.C_Timer.After(0, MERCHANT_SHOW)
    end

    private.CalculateJunkProfit(true)
    if Inventory.db.global.sellJunk then
        private.SellJunk()
    else
        bag.sellJunk:Show()
    end
end
local function MERCHANT_CLOSED(event, ...)
    local bag = Inventory.main.bags.junk

    bag.sellJunk:Hide()
    for _, slot in ipairs(bag.slots) do
        slot.JunkIcon:Hide()
    end
end


-- TBCC: Use traditional events instead of PLAYER_INTERACTION_MANAGER
-- The PLAYER_INTERACTION_MANAGER events don't exist in TBCC

function Inventory:MAIL_SHOW()
    -- Don't auto-open bags for mail, let user open manually
end

function Inventory:TRADE_SHOW()
    self:OpenBags()
end

function Inventory:TRADE_CLOSED()
    self:CloseBags()
end

function Inventory:AUCTION_HOUSE_SHOW()
    self:OpenBags()
end

function Inventory:AUCTION_HOUSE_CLOSED()
    self:CloseBags()
end

function Inventory:BANKFRAME_OPENED()
    self.atBank = true
    self:OpenBags()
end

function Inventory:BANKFRAME_CLOSED()
    self.atBank = false
    self:CloseBags()
end

function Inventory:GUILDBANKFRAME_OPENED()
    self.atBank = true
    self:OpenBags()
end

function Inventory:GUILDBANKFRAME_CLOSED()
    self.atBank = false
    self:CloseBags()
end

function Inventory:MERCHANT_SHOW_EVENT()
    self:OpenBags()
    MERCHANT_SHOW()
end

function Inventory:MERCHANT_CLOSED_EVENT()
    MERCHANT_CLOSED()
    self:CloseBags()
end

-- TBCC: Register traditional events
Inventory:RegisterEvent("MAIL_SHOW")
Inventory:RegisterEvent("TRADE_SHOW")
Inventory:RegisterEvent("TRADE_CLOSED")
Inventory:RegisterEvent("AUCTION_HOUSE_SHOW")
Inventory:RegisterEvent("AUCTION_HOUSE_CLOSED")
Inventory:RegisterEvent("BANKFRAME_OPENED")
Inventory:RegisterEvent("BANKFRAME_CLOSED")
-- TBCC: Guild bank events may not exist in all versions
pcall(function() Inventory:RegisterEvent("GUILDBANKFRAME_OPENED") end)
pcall(function() Inventory:RegisterEvent("GUILDBANKFRAME_CLOSED") end)
-- TBCC: MERCHANT events use different names
Inventory:RegisterEvent("MERCHANT_SHOW", "MERCHANT_SHOW_EVENT")
Inventory:RegisterEvent("MERCHANT_CLOSED", "MERCHANT_CLOSED_EVENT")
