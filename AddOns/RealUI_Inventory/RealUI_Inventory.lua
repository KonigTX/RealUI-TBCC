local _, private = ...

-- Lua Globals --
-- luacheck: globals next ipairs tinsert ceil tremove

-- RealUI --
local RealUI = _G.RealUI

local Inventory = RealUI:NewModule("Inventory", "AceEvent-3.0", "AceHook-3.0")
private.Inventory = Inventory

local defaults = {
    global = {
        version = 1,
        maxHeight = 0.5,
        sellJunk = true,
        filtersEnabled = true,
        combineBags = true, -- When filters disabled: true = one grid, false = separate bag sections
        filters = {},
        assignedFilters = {},
        customFilters = {},
        disabledFilters = {}
    },
    char = {
        junk = {},
    }
}

function private.Update()
    Inventory:debug("private.Update")
    private.UpdateBags()
    private.CalculateJunkProfit(_G.MerchantFrame:IsShown())
end

function private.GetBagTypeForBagID(bagID)
    -- TBCC: Bags 0-4 are main bags, 5+ are bank
    if bagID >= 0 and bagID <= (_G.NUM_BAG_SLOTS or 4) then
        return "main"
    else
        return "bank"
    end
end

function private.SellJunk()
    local bag = Inventory.main.bags.junk

    for _, slot in ipairs(bag.slots) do
        if slot.sellPrice then
            slot.sellPrice = nil
            slot.JunkIcon:Hide()

            _G.C_Container.UseContainerItem(slot:GetBagAndSlot()) --- FIXME
        end
    end

    if bag.profit > 0 then
        -- FIXMELATER
        -- -function GetMoneyString(money, separateThousands, checkGoldThreshold)
        -- +function GetMoneyString(money, separateThousands, checkGoldThreshold, showZeroAsGold)
        local money = _G.GetMoneyString(bag.profit, true)
        _G.print(_G.AMOUNT_RECEIVED_COLON, money)
    end
end
function private.CalculateJunkProfit(isAtMerchant)
    local bag = Inventory.main.bags.junk

    local profit = 0
    for _, slot in ipairs(bag.slots) do
        local _, _, _, _, _, _, _, _, _, _, sellPrice = _G.C_Item.GetItemInfo(slot.item:GetItemLink())
        if sellPrice > 0 then
            local stackCount = _G.C_Container.GetContainerItemInfo(slot:GetBagAndSlot()).stackCount
            profit = profit + (sellPrice * stackCount)

            slot.JunkIcon:SetShown(isAtMerchant)
            slot.sellPrice = sellPrice
        end
    end
    bag.profit = profit
end

local settingsVersion = 5
function private.SanitizeSavedVars(oldVer)
    if oldVer < 5 then
        if Inventory.db.global.filtersEnabled == nil then
            Inventory.db.global.filtersEnabled = true
        end
    end

    if oldVer < 4 then
        local indexedFilters = Inventory.db.global.filters
        Inventory.db.global.filters = {}
        for i, tag in ipairs(indexedFilters) do
            Inventory.db.global.filters[tag] = i
        end
    end

    if oldVer < 3 then
        Inventory:ClearAssignedItems("anima")
    end

    -- Remove custom filters with the same name as our default filters
    for i, info in ipairs(private.filterList) do
        if Inventory.db.global.customFilters[info.tag] then
            Inventory.db.global.customFilters[info.tag] = nil
        end
    end

    Inventory.db.global.version = settingsVersion
end

function Inventory:OnInitialize()
    for i, info in ipairs(private.filterList) do
        defaults.global.filters[info.tag] = i
    end
    self.db = _G.LibStub("AceDB-3.0"):New("RealUI_InventoryDB", defaults, true)

    if self.db.global.version < settingsVersion then
        private.SanitizeSavedVars(self.db.global.version)
    end

    private.CreateBags()
    private.CreateFilters()

    -- Preload slots out of combat to prevent taint
    private.Update()

    self.Update = private.Update

    -- TBCC: Tutorial CVars don't exist, skip this
    -- _G.C_Timer.After(1, function()
    --     -- Disable tutorials (Retail only)
    -- end)
end
