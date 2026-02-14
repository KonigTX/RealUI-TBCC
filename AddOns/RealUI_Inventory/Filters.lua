local _, private = ...

-- Lua Globals --
-- luacheck: globals tinsert tremove next ipairs unpack wipe

-- RealUI --
local RealUI = _G.RealUI
local Inventory = private.Inventory
local L = RealUI.L

local menu do
    local MenuFrame = RealUI:GetModule("MenuFrame")
    menu = {}

    local menuList = {}
    local title = {
        text = "Choose bag",
        isTitle = true,
    }

    local function SetToFilter(filterButton, arg1, arg2, isChecked)
        if isChecked then
            if arg1 == "junk" then
                local bagID, slotIndex = menu.slot:GetBagAndSlot()
                if not Inventory.db.char.junk[bagID] then
                    Inventory.db.char.junk[bagID] = {}
                end

                Inventory.db.char.junk[bagID][slotIndex] = true
            else
                Inventory.db.global.assignedFilters[menu.slot.item:GetItemID()] = arg1
            end
        else
            if arg1 == "junk" then
                local bagID, slotIndex = menu.slot:GetBagAndSlot()
                if not Inventory.db.char.junk[bagID] then
                    Inventory.db.char.junk[bagID] = {}
                end

                Inventory.db.char.junk[bagID][slotIndex] = nil
            else
                Inventory.db.global.assignedFilters[menu.slot.item:GetItemID()] = nil
            end
        end
        private.Update()
        MenuFrame:Close(1, true)
    end
    function menu:AddFilter(filter)
        local tag = filter.tag
        tinsert(menuList, {
            text = filter.name,
            func = SetToFilter,
            arg1 = tag,
            checked = function(...)
                if tag == "junk" then
                    local bagID, slotIndex = menu.slot:GetBagAndSlot()
                    if Inventory.db.char.junk[bagID] then
                        return Inventory.db.char.junk[bagID][slotIndex] or false
                    end

                    return false
                else
                    return Inventory.db.global.assignedFilters[self.slot.item:GetItemID()] == tag
                end
            end
        })
    end
    function menu:UpdateLines()
        wipe(menuList)
        tinsert(menuList, 1, title)
        for i, filter in Inventory:IndexedFilters() do
            if not filter then
                _G.print("Inventory:UpdateLines - Filter is nil at index", i)
                return
            end
            if filter:IsEnabled() then
                self:AddFilter(filter)
            end
        end
    end
    function menu:Open(slot)
        if slot.item then
            self.slot = slot
            if slot:GetBagType() == "main" then
                MenuFrame:Open(slot, "TOPLEFT", menuList)
            else
                MenuFrame:Open(slot, "BOTTOMLEFT", menuList)
            end
        end
    end
    private.menu = menu
end

do
    local filters, FilterMixin = {}, {}
    function FilterMixin:GetIndex()
        return Inventory.db.global.filters[self.tag]
    end
    function FilterMixin:SetIndex(newIndex)
        local oldIndex = Inventory.db.global.filters[self.tag]
        local filter = Inventory:GetFilterAtIndex(newIndex)
        Inventory.db.global.filters[self.tag] = newIndex
        if filter then
            filter:SetIndex(oldIndex)
        end

        menu:UpdateLines()
        private.Update()
    end
    function FilterMixin:DoesMatchSlot(slot)
        if not Inventory.db.global.filtersEnabled then return false end
        if not self:IsEnabled() then return false end
        if self.filter then
            return self.filter(slot)
        end
    end
    function FilterMixin:HasPriority(filterTag)
        local filter = Inventory:GetFilter(filterTag)
        if not filter then
            _G.print(L.Inventory_UnknownFilter, filterTag)
            return true
        end

        -- Lower ranks have priority
        return self.rank < filter.rank
    end
    function FilterMixin:Delete()
        Inventory:RemoveFilter(self.tag, true)
        menu:UpdateLines()
    end
    function FilterMixin:SetEnabled(enabled)
        Inventory.db.global.disabledFilters[self.tag] = not enabled
        menu:UpdateLines()
    end
    function FilterMixin:IsEnabled()
        if self.isCustom then return true end
        --print("FilterMixin:IsEnabled", self.tag, not Inventory.db.global.disabledFilters[self.tag])
        return not Inventory.db.global.disabledFilters[self.tag]
    end

    local numFilters = 0
    function Inventory:GetNumFilters()
        return numFilters
    end
    function Inventory:ClearAssignedItems(tag)
        for itemID, assignedTag in next, Inventory.db.global.assignedFilters do
            if assignedTag == tag then
                Inventory.db.global.assignedFilters[itemID] = nil
            end
        end
    end
    function Inventory:AddFilter(filter)
        numFilters = numFilters + 1
        filters[filter.tag] = filter
        if not Inventory.db.global.filters[filter.tag] then
            Inventory.db.global.filters[filter.tag] = numFilters
        end
    end
    function Inventory:RemoveFilter(tag, clearItems)
        numFilters = numFilters - 1
        Inventory.db.global.filters[tag] = nil
        filters[tag] = nil

        if Inventory.db.global.customFilters[tag] or clearItems then
            Inventory:ClearAssignedItems(tag)
        end
        Inventory.db.global.customFilters[tag] = nil
    end
    function Inventory:CreateFilter(info)
        local filter = _G.Mixin(info, FilterMixin)

        private.CreateFilterBag(Inventory.main, filter)
        -- Create filter bags for bank too (except "new" items filter)
        if filter.tag ~= "new" and Inventory.bank then
            private.CreateFilterBag(Inventory.bank, filter)
        end

        Inventory:AddFilter(filter)
        return filter
    end
    function Inventory:CreateCustomFilter(tag, name, fromConfig)
        if not Inventory.db.global.customFilters[tag] then
            Inventory.db.global.customFilters[tag] = name
        end

        local filter = Inventory:CreateFilter({
            tag = tag,
            name = name,
            isCustom = true,
        })

        if fromConfig then
            menu:AddFilter(filter)
        end

        return filter
    end


    local function iPairsFilter(filterTable, index)
        index = index + 1
        local tag = filterTable[index]
        if tag ~= nil then
            return index, filters[tag]
        else
            return nil
        end
    end

    local indexedFilters = {}
    function Inventory:IndexedFilters()
        wipe(indexedFilters)
        for i = 1, numFilters do
            for tag, index in next, Inventory.db.global.filters do
                if index == i then
                    tinsert(indexedFilters, tag)
                end
            end
        end

        return iPairsFilter, indexedFilters, 0
    end
    function Inventory:GetFilter(tag)
        return filters[tag]
    end
    function Inventory:GetFilterAtIndex(index)
        for tag, i in next, Inventory.db.global.filters do
            if index == i then
                return filters[tag]
            end
        end
    end
end

-- TBCC: Enum.ItemClass may not exist, use numeric values
local ItemClass = _G.Enum and _G.Enum.ItemClass or {
    Consumable = 0,
    Container = 1,
    Weapon = 2,
    Gem = 3,
    Armor = 4,
    Reagent = 5,
    Projectile = 6,
    Tradegoods = 7,
    ItemEnhancement = 8,
    Recipe = 9,
    -- TBCC doesn't have all classes
    Questitem = 12,
    Key = 13,
    Miscellaneous = 15,
}

-- TBCC: GetItemInfoInstant wrapper
local function GetItemInfoInstant(itemID)
    if _G.C_Item and _G.C_Item.GetItemInfoInstant then
        return _G.C_Item.GetItemInfoInstant(itemID)
    elseif _G.GetItemInfoInstant then
        return _G.GetItemInfoInstant(itemID)
    else
        -- Fallback: use GetItemInfo (slower but works)
        local name, _, quality, ilvl, _, itemType, itemSubType, _, equipLoc, icon, _, classID, subclassID = _G.GetItemInfo(itemID)
        return itemID, itemType, itemSubType, equipLoc, icon, classID, subclassID
    end
end

private.filterList = {}
tinsert(private.filterList, {
    tag = "new",
    name = _G.NEW,
    rank = 1,
    filter = function(slot)
        local bagID, slotIndex = slot:GetBagAndSlot()
        if Inventory.main.new[bagID] then
            return Inventory.main.new[bagID][slotIndex]
        end
    end,
})

tinsert(private.filterList, {
    tag = "junk",
    name = _G.BAG_FILTER_JUNK,
    rank = 0,
    filter = function(slot)
        local itemInfo = _G.C_Container.GetContainerItemInfo(slot:GetBagAndSlot())
        -- TBCC: itemInfo can be nil for empty slots or bank slots
        if not itemInfo then return false end
        return itemInfo.quality == _G.Enum.ItemQuality.Poor and not itemInfo.hasNoValue
    end,
})

tinsert(private.filterList, {
    tag = "consumables",
    name = _G.AUCTION_CATEGORY_CONSUMABLES or "Consumables",
    rank = 10,
    filter = function(slot)
        local _, _, _, _, _, typeID = GetItemInfoInstant(slot.item:GetItemID())
        return typeID == ItemClass.Consumable
    end,
})

tinsert(private.filterList, {
    tag = "equipment",
    name = _G.BAG_FILTER_EQUIPMENT,
    rank = 22,
    filter = function(slot)
        return slot:GetItemType() == "equipment"
    end,
})

tinsert(private.filterList, {
    tag = "sets",
    name = (":"):split(_G.EQUIPMENT_SETS),
    rank = 20,
    filter = function(slot)
        local bagID, slotIndex = slot:GetBagAndSlot()
        -- TBCC: equipSetItems may not have entry for bank container (-1)
        if not private.equipSetItems[bagID] then return false end
        local isSet = private.equipSetItems[bagID][slotIndex]
        return isSet
    end,
})

-- TBCC: Skip BnetAccountUntilEquipped filter (doesn't exist in TBCC)
-- tinsert(private.filterList, {
--     tag = "ToBnetAccountUntilEquipped",
--     name = "ToBnetAccountUntilEquipped",
--     rank = 21,
--     filter = function(slot) return false end,
-- })

tinsert(private.filterList, {
    tag = "questitems",
    name = _G.AUCTION_CATEGORY_QUEST_ITEMS or "Quest Items",
    rank = 3,
    filter = function(slot)
        local _, _, _, _, _, typeID = GetItemInfoInstant(slot.item:GetItemID())
        return typeID == ItemClass.Questitem
    end,
})

-- TBCC: C_AuctionHouse doesn't exist, skip detailed tradegoods filters
-- Just have a single tradegoods filter
local tradegoodsPrefix = (_G.BAG_FILTER_PROFESSION_GOODS or "Trade Goods") .. ": %s"

tinsert(private.filterList, {
    tag = "tradegoods",
    name = _G.AUCTION_CATEGORY_TRADE_GOODS or "Trade Goods",
    rank = 31,
    filter = function(slot)
        local _, _, _, _, _, typeID = GetItemInfoInstant(slot.item:GetItemID())
        return typeID == ItemClass.Tradegoods
    end,
})

-- TBCC: Anima doesn't exist in TBC
-- tinsert(private.filterList, {
--     tag = "anima",
--     name = _G.POWER_TYPE_ANIMA or "Anima",
--     rank = 50,
--     filter = function(slot) return false end,
-- })

local travel = private.travel
tinsert(private.filterList, {
    tag = "travel",
    name = _G.TUTORIAL_TITLE35,
    rank = 2,
    filter = function(slot)
        return travel[slot.item:GetItemID()]
    end,
})

function private.CreateFilters()
    for tag, name in next, Inventory.db.global.customFilters do
        Inventory:CreateCustomFilter(tag, name)
    end

    for i, info in ipairs(private.filterList) do
        Inventory:CreateFilter(info)
    end
    menu:UpdateLines()
end


