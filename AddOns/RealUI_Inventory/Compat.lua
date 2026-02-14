-- TBCC Compatibility Layer for RealUI_Inventory
-- This file provides Retail API emulation for TBCC (2.5.4)

local _, private = ...

-- =============================================================================
-- C_Container API Emulation
-- =============================================================================
-- TBCC uses global functions instead of C_Container namespace
if not _G.C_Container then
    _G.C_Container = {}

    -- GetContainerNumSlots(bagID) -> numSlots
    function _G.C_Container.GetContainerNumSlots(bagID)
        return _G.GetContainerNumSlots(bagID)
    end

    -- GetContainerNumFreeSlots(bagID) -> numFreeSlots, bagFamily
    function _G.C_Container.GetContainerNumFreeSlots(bagID)
        return _G.GetContainerNumFreeSlots(bagID)
    end

    -- GetContainerItemInfo(bagID, slotIndex) -> table
    -- TBCC returns multiple values, Retail returns a table
    function _G.C_Container.GetContainerItemInfo(bagID, slotIndex)
        local texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = _G.GetContainerItemInfo(bagID, slotIndex)
        if not texture then
            return nil
        end
        return {
            iconFileID = texture,
            stackCount = itemCount or 1,
            isLocked = locked,
            quality = quality,
            isReadable = readable,
            hasLoot = lootable,
            hyperlink = itemLink,
            isFiltered = isFiltered,
            hasNoValue = noValue,
            itemID = itemID,
            isBound = isBound,
        }
    end

    -- GetContainerItemLink(bagID, slotIndex) -> itemLink
    function _G.C_Container.GetContainerItemLink(bagID, slotIndex)
        return _G.GetContainerItemLink(bagID, slotIndex)
    end

    -- GetContainerItemCooldown(bagID, slotIndex) -> startTime, duration, enable
    function _G.C_Container.GetContainerItemCooldown(bagID, slotIndex)
        return _G.GetContainerItemCooldown(bagID, slotIndex)
    end

    -- GetContainerItemQuestInfo(bagID, slotIndex) -> table
    function _G.C_Container.GetContainerItemQuestInfo(bagID, slotIndex)
        local isQuestItem, questID, isActive = _G.GetContainerItemQuestInfo(bagID, slotIndex)
        return {
            isQuestItem = isQuestItem,
            questID = questID,
            isActive = isActive,
        }
    end

    -- UseContainerItem(bagID, slotIndex, target, reagentBankOpen)
    function _G.C_Container.UseContainerItem(bagID, slotIndex, target, reagentBankOpen)
        _G.UseContainerItem(bagID, slotIndex, target)
    end

    -- PickupContainerItem(bagID, slotIndex)
    function _G.C_Container.PickupContainerItem(bagID, slotIndex)
        _G.PickupContainerItem(bagID, slotIndex)
    end

    -- SplitContainerItem(bagID, slotIndex, amount)
    function _G.C_Container.SplitContainerItem(bagID, slotIndex, amount)
        _G.SplitContainerItem(bagID, slotIndex, amount)
    end

    -- IsContainerFiltered(bagID) -> isFiltered
    function _G.C_Container.IsContainerFiltered(bagID)
        -- TBCC doesn't have container filtering in the same way
        return false
    end

    -- IsBattlePayItem(bagID, slotIndex) -> isBattlePayItem
    function _G.C_Container.IsBattlePayItem(bagID, slotIndex)
        -- Battle Pay items don't exist in TBCC
        return false
    end

    -- ExpandCurrencyList/GetCurrencyListSize are in C_CurrencyInfo, not C_Container
end

-- =============================================================================
-- C_Container API - Individual function fallbacks
-- These are OUTSIDE the main block because C_Container may exist but be incomplete
-- =============================================================================
if _G.C_Container then
    -- SortBags() - TBCC doesn't have automatic bag sorting
    if not _G.C_Container.SortBags then
        function _G.C_Container.SortBags()
            -- TBCC doesn't have automatic bag sorting, do nothing
        end
    end

    -- SortBankBags() - TBCC doesn't have automatic bank sorting
    if not _G.C_Container.SortBankBags then
        function _G.C_Container.SortBankBags()
            -- TBCC doesn't have automatic bank sorting, do nothing
        end
    end
end

-- =============================================================================
-- C_Bank API Emulation
-- =============================================================================
if not _G.C_Bank then
    _G.C_Bank = {}

    function _G.C_Bank.CloseBankFrame()
        _G.CloseBankFrame()
    end

    function _G.C_Bank.FetchNumPurchasedBankTabs(bankType)
        return _G.GetNumBankSlots()
    end
end

-- =============================================================================
-- C_NewItems API Emulation
-- =============================================================================
if not _G.C_NewItems then
    _G.C_NewItems = {}

    -- Track new items manually (TBCC doesn't have this system)
    local newItems = {}

    function _G.C_NewItems.IsNewItem(bagID, slotIndex)
        return newItems[bagID] and newItems[bagID][slotIndex] or false
    end

    function _G.C_NewItems.RemoveNewItem(bagID, slotIndex)
        if newItems[bagID] then
            newItems[bagID][slotIndex] = nil
        end
    end

    function _G.C_NewItems.ClearAll()
        _G.wipe(newItems)
    end
end

-- =============================================================================
-- Enum.BagIndex Emulation
-- =============================================================================
if not _G.Enum then
    _G.Enum = {}
end

if not _G.Enum.BagIndex then
    _G.Enum.BagIndex = {
        Backpack = 0,
        Bag_1 = 1,
        Bag_2 = 2,
        Bag_3 = 3,
        Bag_4 = 4,
        ReagentBag = 5, -- Doesn't exist in TBCC, but define for compat
        Keyring = -2, -- TBCC has keyring
        -- Bank containers
        Characterbanktab = -1, -- BANK_CONTAINER
        CharacterBankTab_1 = 5, -- NUM_BAG_SLOTS + 1
        CharacterBankTab_2 = 6,
        CharacterBankTab_3 = 7,
        CharacterBankTab_4 = 8,
        CharacterBankTab_5 = 9,
        CharacterBankTab_6 = 10,
        -- These don't exist in TBCC but define them
        Reagentbank = -3,
        Accountbanktab = -4,
        AccountBankTab_1 = -5,
        AccountBankTab_2 = -6,
        AccountBankTab_3 = -7,
        AccountBankTab_4 = -8,
        AccountBankTab_5 = -9,
    }
end

-- =============================================================================
-- Enum.PlayerInteractionType Emulation
-- =============================================================================
if not _G.Enum.PlayerInteractionType then
    _G.Enum.PlayerInteractionType = {
        MailInfo = 1,
        TradePartner = 2,
        Auctioneer = 3,
        Banker = 4,
        GuildBanker = 5,
        AccountBanker = 6,
        Merchant = 7,
        CharacterBanker = 8,
        -- Add more as needed
    }
end

-- =============================================================================
-- Enum.InventoryType Emulation (fill in missing values)
-- =============================================================================
if not _G.Enum.InventoryType then
    _G.Enum.InventoryType = {}
end

-- Ensure all inventory types are defined
local invTypeDefaults = {
    IndexNonEquipType = 0,
    IndexHeadType = 1,
    IndexNeckType = 2,
    IndexShoulderType = 3,
    IndexBodyType = 4,
    IndexChestType = 5,
    IndexWaistType = 6,
    IndexLegsType = 7,
    IndexFeetType = 8,
    IndexWristType = 9,
    IndexHandType = 10,
    IndexFingerType = 11,
    IndexTrinketType = 12,
    IndexWeaponType = 13,
    IndexShieldType = 14,
    IndexRangedType = 15,
    IndexCloakType = 16,
    Index2HweaponType = 17,
    IndexBagType = 18,
    IndexTabardType = 19,
    IndexRobeType = 20,
    IndexWeaponmainhandType = 21,
    IndexWeaponoffhandType = 22,
    IndexHoldableType = 23,
    IndexAmmoType = 24,
    IndexThrownType = 25,
    IndexRangedrightType = 26,
    IndexQuiverType = 27,
    IndexRelicType = 28,
    -- Retail-only types (assign high values)
    IndexProfessionToolType = 30,
    IndexProfessionGearType = 31,
    IndexEquipablespellOffensiveType = 32,
    IndexEquipablespellUtilityType = 33,
    IndexEquipablespellDefensiveType = 34,
    IndexEquipablespellWeaponType = 35,
}

for k, v in pairs(invTypeDefaults) do
    if _G.Enum.InventoryType[k] == nil then
        _G.Enum.InventoryType[k] = v
    end
end

-- =============================================================================
-- Enum.ItemQuality (ensure it exists)
-- =============================================================================
if not _G.Enum.ItemQuality then
    _G.Enum.ItemQuality = {
        Poor = 0,
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Epic = 4,
        Legendary = 5,
        Artifact = 6,
        Heirloom = 7,
    }
end

-- =============================================================================
-- FrameUtil Emulation
-- =============================================================================
if not _G.FrameUtil then
    _G.FrameUtil = {}

    function _G.FrameUtil.RegisterFrameForEvents(frame, events)
        if type(events) == "table" then
            for _, event in ipairs(events) do
                pcall(function() frame:RegisterEvent(event) end)
            end
        end
    end

    function _G.FrameUtil.UnregisterFrameForEvents(frame, events)
        if type(events) == "table" then
            for _, event in ipairs(events) do
                pcall(function() frame:UnregisterEvent(event) end)
            end
        end
    end
end

-- =============================================================================
-- CreateUnsecuredObjectPool (simplified version if missing)
-- =============================================================================
if not _G.CreateUnsecuredObjectPool then
    function _G.CreateUnsecuredObjectPool(creationFunc, resetFunc)
        local pool = {
            activeObjectCount = 0,
            activeObjects = {},
            inactiveObjects = {},
            creationFunc = creationFunc,
            resetFunc = resetFunc,
        }

        function pool:Acquire()
            local obj
            if #self.inactiveObjects > 0 then
                obj = table.remove(self.inactiveObjects)
            else
                obj = self.creationFunc(self)
            end

            if obj then
                self.activeObjects[obj] = true
                self.activeObjectCount = self.activeObjectCount + 1
            end
            return obj
        end

        function pool:Release(obj)
            if self.activeObjects[obj] then
                self.activeObjects[obj] = nil
                self.activeObjectCount = self.activeObjectCount - 1
                if self.resetFunc then
                    self.resetFunc(self, obj)
                end
                table.insert(self.inactiveObjects, obj)
            end
        end

        function pool:GetNumActive()
            return self.activeObjectCount
        end

        function pool:EnumerateActive()
            return pairs(self.activeObjects)
        end

        return pool
    end
end

-- =============================================================================
-- CreateFromMixins (ensure it exists)
-- =============================================================================
if not _G.CreateFromMixins then
    function _G.CreateFromMixins(...)
        local obj = {}
        for i = 1, select("#", ...) do
            local mixin = select(i, ...)
            if mixin then
                for k, v in pairs(mixin) do
                    obj[k] = v
                end
            end
        end
        return obj
    end
end

-- =============================================================================
-- Mixin (ensure it exists)
-- =============================================================================
if not _G.Mixin then
    function _G.Mixin(obj, ...)
        for i = 1, select("#", ...) do
            local mixin = select(i, ...)
            if mixin then
                for k, v in pairs(mixin) do
                    obj[k] = v
                end
            end
        end
        return obj
    end
end

-- =============================================================================
-- ContinuableContainer Emulation
-- =============================================================================
if not _G.ContinuableContainer then
    _G.ContinuableContainer = {}

    function _G.ContinuableContainer:AddContinuable(continuable)
        if not self._continuables then
            self._continuables = {}
        end
        table.insert(self._continuables, continuable)
    end

    function _G.ContinuableContainer:ContinueOnLoad(callback)
        -- Simplified: just call immediately since TBCC items load synchronously
        if callback then
            callback()
        end
    end

    function _G.ContinuableContainer:AreAnyLoadsOutstanding()
        return false
    end

    function _G.ContinuableContainer:Cancel()
        -- Nothing to cancel
    end
end

-- =============================================================================
-- ItemLocation Emulation
-- =============================================================================
if not _G.ItemLocation then
    _G.ItemLocation = {}

    function _G.ItemLocation:CreateEmpty()
        local loc = {
            bagID = nil,
            slotIndex = nil,
        }

        function loc:SetBagAndSlot(bagID, slotIndex)
            self.bagID = bagID
            self.slotIndex = slotIndex
        end

        function loc:GetBagAndSlot()
            return self.bagID, self.slotIndex
        end

        function loc:IsEqualToBagAndSlot(bagID, slotIndex)
            return self.bagID == bagID and self.slotIndex == slotIndex
        end

        function loc:IsValid()
            if self.bagID and self.slotIndex then
                local link = _G.GetContainerItemLink(self.bagID, self.slotIndex)
                return link ~= nil
            end
            return false
        end

        function loc:Clear()
            self.bagID = nil
            self.slotIndex = nil
        end

        return loc
    end

    function _G.ItemLocation:CreateFromBagAndSlot(bagID, slotIndex)
        local loc = _G.ItemLocation:CreateEmpty()
        loc:SetBagAndSlot(bagID, slotIndex)
        return loc
    end
end

-- =============================================================================
-- Item Emulation (for Item:CreateFromItemLocation)
-- =============================================================================
if not _G.Item then
    _G.Item = {}

    function _G.Item:CreateFromItemLocation(location)
        local bagID, slotIndex = location:GetBagAndSlot()
        local itemLink = _G.GetContainerItemLink(bagID, slotIndex)

        local item = {
            location = location,
            itemLink = itemLink,
        }

        function item:GetItemLink()
            return self.itemLink
        end

        function item:GetItemID()
            if self.itemLink then
                local id = self.itemLink:match("item:(%d+)")
                return id and tonumber(id)
            end
            return nil
        end

        function item:GetItemIcon()
            if self.itemLink then
                local _, _, _, _, _, _, _, _, _, icon = _G.GetItemInfo(self.itemLink)
                return icon
            end
            return nil
        end

        function item:GetItemQuality()
            if self.itemLink then
                local _, _, quality = _G.GetItemInfo(self.itemLink)
                return quality
            end
            return nil
        end

        function item:GetItemName()
            if self.itemLink then
                local name = _G.GetItemInfo(self.itemLink)
                return name
            end
            return nil
        end

        function item:GetCurrentItemLevel()
            if self.itemLink then
                local _, _, _, ilvl = _G.GetItemInfo(self.itemLink)
                return ilvl or 0
            end
            return 0
        end

        function item:GetInventoryType()
            if self.itemLink then
                local _, _, _, _, _, _, _, _, equipLoc = _G.GetItemInfo(self.itemLink)
                -- Map equipLoc string to InventoryType index
                local equipLocToType = {
                    ["INVTYPE_HEAD"] = _G.Enum.InventoryType.IndexHeadType,
                    ["INVTYPE_NECK"] = _G.Enum.InventoryType.IndexNeckType,
                    ["INVTYPE_SHOULDER"] = _G.Enum.InventoryType.IndexShoulderType,
                    ["INVTYPE_BODY"] = _G.Enum.InventoryType.IndexBodyType,
                    ["INVTYPE_CHEST"] = _G.Enum.InventoryType.IndexChestType,
                    ["INVTYPE_ROBE"] = _G.Enum.InventoryType.IndexRobeType,
                    ["INVTYPE_WAIST"] = _G.Enum.InventoryType.IndexWaistType,
                    ["INVTYPE_LEGS"] = _G.Enum.InventoryType.IndexLegsType,
                    ["INVTYPE_FEET"] = _G.Enum.InventoryType.IndexFeetType,
                    ["INVTYPE_WRIST"] = _G.Enum.InventoryType.IndexWristType,
                    ["INVTYPE_HAND"] = _G.Enum.InventoryType.IndexHandType,
                    ["INVTYPE_FINGER"] = _G.Enum.InventoryType.IndexFingerType,
                    ["INVTYPE_TRINKET"] = _G.Enum.InventoryType.IndexTrinketType,
                    ["INVTYPE_WEAPON"] = _G.Enum.InventoryType.IndexWeaponType,
                    ["INVTYPE_SHIELD"] = _G.Enum.InventoryType.IndexShieldType,
                    ["INVTYPE_RANGED"] = _G.Enum.InventoryType.IndexRangedType,
                    ["INVTYPE_CLOAK"] = _G.Enum.InventoryType.IndexCloakType,
                    ["INVTYPE_2HWEAPON"] = _G.Enum.InventoryType.Index2HweaponType,
                    ["INVTYPE_BAG"] = _G.Enum.InventoryType.IndexBagType,
                    ["INVTYPE_TABARD"] = _G.Enum.InventoryType.IndexTabardType,
                    ["INVTYPE_WEAPONMAINHAND"] = _G.Enum.InventoryType.IndexWeaponmainhandType,
                    ["INVTYPE_WEAPONOFFHAND"] = _G.Enum.InventoryType.IndexWeaponoffhandType,
                    ["INVTYPE_HOLDABLE"] = _G.Enum.InventoryType.IndexHoldableType,
                    ["INVTYPE_AMMO"] = _G.Enum.InventoryType.IndexAmmoType,
                    ["INVTYPE_THROWN"] = _G.Enum.InventoryType.IndexThrownType,
                    ["INVTYPE_RANGEDRIGHT"] = _G.Enum.InventoryType.IndexRangedrightType,
                    ["INVTYPE_QUIVER"] = _G.Enum.InventoryType.IndexQuiverType,
                    ["INVTYPE_RELIC"] = _G.Enum.InventoryType.IndexRelicType,
                    [""] = _G.Enum.InventoryType.IndexNonEquipType,
                }
                return equipLocToType[equipLoc] or _G.Enum.InventoryType.IndexNonEquipType
            end
            return _G.Enum.InventoryType.IndexNonEquipType
        end

        function item:IsItemLocked()
            local bagID, slotIndex = self.location:GetBagAndSlot()
            local _, _, locked = _G.GetContainerItemInfo(bagID, slotIndex)
            return locked
        end

        function item:ContinueWithCancelOnItemLoad(callback)
            -- TBCC items load synchronously, just call immediately
            if callback then
                callback()
            end
            return function() end -- Return a cancel function that does nothing
        end

        return item
    end
end

-- =============================================================================
-- C_Item Emulation (additional functions)
-- =============================================================================
if not _G.C_Item then
    _G.C_Item = {}
end

if not _G.C_Item.GetStackCount then
    function _G.C_Item.GetStackCount(location)
        local bagID, slotIndex = location:GetBagAndSlot()
        local _, itemCount = _G.GetContainerItemInfo(bagID, slotIndex)
        return itemCount or 1
    end
end

if not _G.C_Item.GetItemInfo then
    _G.C_Item.GetItemInfo = _G.GetItemInfo
end

if not _G.C_Item.GetItemIconByID then
    function _G.C_Item.GetItemIconByID(itemID)
        local _, _, _, _, _, _, _, _, _, icon = _G.GetItemInfo(itemID)
        return icon
    end
end

-- =============================================================================
-- C_Texture.GetAtlasInfo Emulation
-- =============================================================================
if not _G.C_Texture then
    _G.C_Texture = {}
end

if not _G.C_Texture.GetAtlasInfo then
    function _G.C_Texture.GetAtlasInfo(atlas)
        -- Return a default size for unknown atlases
        return {
            width = 16,
            height = 16,
        }
    end
end

-- =============================================================================
-- ItemButtonUtil Emulation
-- =============================================================================
if not _G.ItemButtonUtil then
    _G.ItemButtonUtil = {}

    function _G.ItemButtonUtil.GetItemContextMatchResultForContainer(bagID)
        return nil -- No context matching in TBCC
    end
end

-- =============================================================================
-- SetItemButtonQuality (may need adjustments for TBCC)
-- =============================================================================
if not _G.SetItemButtonQuality then
    function _G.SetItemButtonQuality(button, quality, itemIDOrLink, suppressOverlays)
        if button.IconBorder then
            if quality and quality > 1 then
                local color = _G.ITEM_QUALITY_COLORS[quality]
                if color then
                    button.IconBorder:SetVertexColor(color.r, color.g, color.b)
                    button.IconBorder:Show()
                else
                    button.IconBorder:Hide()
                end
            else
                button.IconBorder:Hide()
            end
        end
    end
end

-- =============================================================================
-- BAG_ITEM_QUALITY_COLORS (may not exist in TBCC)
-- =============================================================================
if not _G.BAG_ITEM_QUALITY_COLORS then
    _G.BAG_ITEM_QUALITY_COLORS = {}
    for i = 0, 7 do
        local color = _G.ITEM_QUALITY_COLORS[i]
        if color then
            _G.BAG_ITEM_QUALITY_COLORS[i] = _G.CreateColor(color.r, color.g, color.b)
        end
    end
end

-- =============================================================================
-- NUM_TOTAL_EQUIPPED_BAG_SLOTS (TBCC uses NUM_BAG_SLOTS)
-- =============================================================================
if not _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS then
    _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS = _G.NUM_BAG_SLOTS or 4
end

-- =============================================================================
-- PLAYER_INTERACTION events don't exist in TBCC
-- We'll need to use traditional events instead
-- =============================================================================
private.TBCC_COMPAT = true

-- Store info about missing features
private.debugCompat = function(msg)
    if _G.RealUI and _G.RealUI.isDev then
        print("|cFFFF9900[RealUI_Inventory Compat]|r", msg)
    end
end
