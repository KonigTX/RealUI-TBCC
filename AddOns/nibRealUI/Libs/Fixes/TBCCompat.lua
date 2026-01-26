--[[
    TBCC Compatibility Shim for RealUI

    This file provides compatibility wrappers for Retail WoW APIs that don't exist in TBC.
    It MUST be loaded FIRST before any other RealUI code to ensure all compatibility
    functions are available.

    TBCC Interface Version: 20504 (TBC 2.5.4)
    Original Retail Version: 110207 (11.0.2)

    Author: RealUI TBCC Port Team
    Date: January 16, 2026
]]

-- =============================================================================
-- C_AddOns Namespace Compatibility
-- =============================================================================
-- In Retail, all addon management functions were moved to the C_AddOns namespace.
-- In TBC, these are still global functions.

if not C_AddOns then
    C_AddOns = {}

    -- Get addon information
    function C_AddOns.GetAddOnInfo(nameOrIndex)
        return GetAddOnInfo(nameOrIndex)
    end

    -- Get total number of addons
    function C_AddOns.GetNumAddOns()
        return GetNumAddOns()
    end

    -- Load an addon on demand
    function C_AddOns.LoadAddOn(name)
        return LoadAddOn(name)
    end

    -- Check if addon is loaded
    function C_AddOns.IsAddOnLoaded(nameOrIndex)
        return IsAddOnLoaded(nameOrIndex)
    end

    -- Get addon metadata field
    function C_AddOns.GetAddOnMetadata(nameOrIndex, field)
        return GetAddOnMetadata(nameOrIndex, field)
    end

    -- Enable addon for loading
    function C_AddOns.EnableAddOn(nameOrIndex, character)
        return EnableAddOn(nameOrIndex, character)
    end

    -- Disable addon from loading
    function C_AddOns.DisableAddOn(nameOrIndex, character)
        return DisableAddOn(nameOrIndex, character)
    end

    -- Get addon dependencies
    function C_AddOns.GetAddOnDependencies(index)
        return GetAddOnDependencies(index)
    end

    -- Get addon optional dependencies
    function C_AddOns.GetAddOnOptionalDependencies(index)
        return GetAddOnOptionalDependencies(index)
    end

    -- Check if addon is loaded on demand
    function C_AddOns.IsAddOnLoadOnDemand(index)
        return IsAddOnLoadOnDemand(index)
    end

    -- Get addon enable state (TBC approximation)
    function C_AddOns.GetAddOnEnableState(nameOrIndex, character)
        -- TBC doesn't have GetAddOnEnableState, approximate it
        local name, title, notes, loadable, reason = GetAddOnInfo(nameOrIndex)
        if not name then
            return 0 -- Enum.AddOnEnableState.None
        end

        -- If character is specified, check character-specific enable state
        local enabled
        if character then
            enabled = GetAddOnInfo(nameOrIndex, character)
        else
            enabled = select(4, GetAddOnInfo(nameOrIndex))
        end

        if enabled then
            return 2 -- Enum.AddOnEnableState.All
        else
            return 0 -- Enum.AddOnEnableState.None
        end
    end
end

-- =============================================================================
-- Specialization System Compatibility (TBC has no specs)
-- =============================================================================
-- TBC uses talent trees instead of specializations. We return safe defaults.

if not GetSpecialization then
    -- Always return 1 (primary spec) since TBC has no dual spec system
    function GetSpecialization()
        return 1
    end
end

if not GetSpecializationInfo then
    -- Return generic spec info based on class
    function GetSpecializationInfo(specIndex)
        local _, class = UnitClass("player")
        -- Return: id, name, description, icon, role, primaryStat
        return specIndex or 1, class, class, nil, "DPS", nil
    end
end

if not GetNumSpecializations then
    -- TBC only has one "spec" (no dual spec until WotLK)
    function GetNumSpecializations()
        return 1
    end
end

if not GetSpecializationInfoForClassID then
    -- Return spec info for a class by spec index
    function GetSpecializationInfoForClassID(classID, specIndex)
        -- TBC doesn't have specs, return mock data
        -- Return: id, name, description, icon, role, primaryStat
        return specIndex, "Primary", "Primary talents", nil, "DPS", nil
    end
end

if not GetSpecializationInfoByID then
    -- Get spec info by spec ID
    function GetSpecializationInfoByID(specID)
        -- TBC doesn't have specs, return mock data
        -- Return: id, name, description, icon, role, primaryStat, class
        return specID, "Primary", "Primary talents", nil, "DPS", nil, nil
    end
end

-- C_SpecializationInfo namespace
if not C_SpecializationInfo then
    C_SpecializationInfo = {}

    function C_SpecializationInfo.GetSpecialization()
        return 1
    end

    function C_SpecializationInfo.GetNumSpecializationsForClassID(classID)
        return 1
    end

    function C_SpecializationInfo.GetSpecializationInfo(specIndex, isInspect, isPet, sex)
        return specIndex, "Primary", "Primary talents", nil, "DPS", nil
    end

    function C_SpecializationInfo.GetActiveSpecGroup()
        return 1
    end

    function C_SpecializationInfo.SetSpecialization(specIndex)
        -- No-op in TBC
    end

    function C_SpecializationInfo.CanPlayerUseTalentSpecUI()
        -- In TBC, players can always access talents (no restrictions like in combat)
        return not InCombatLockdown()
    end
end

-- =============================================================================
-- Settings API Compatibility
-- =============================================================================
-- Retail introduced a new Settings namespace for managing game settings.
-- TBC uses the older InterfaceOptions system.

if not Settings then
    Settings = {}

    -- Mock settings registration functions
    function Settings.RegisterCanvasLayoutCategory(frame, categoryName, order)
        -- In TBC, use InterfaceOptions_AddCategory instead
        if frame and frame.name then
            InterfaceOptions_AddCategory(frame)
        end
        return frame
    end

    function Settings.RegisterAddOnCategory(category)
        -- No-op for TBC
        return category
    end

    function Settings.OpenToCategory(categoryName)
        -- Try to open the interface options panel
        InterfaceOptionsFrame_OpenToCategory(categoryName)
    end
end

-- =============================================================================
-- Container (Bag) API Compatibility
-- =============================================================================
-- Retail moved container functions to C_Container namespace.
-- TBC uses global GetContainerItemInfo, etc.

if not C_Container then
    C_Container = {}

    -- Get container item info
    function C_Container.GetContainerItemInfo(bagID, slotID)
        local texture, itemCount, locked, quality, readable, lootable, itemLink,
              isFiltered, noValue, itemID = GetContainerItemInfo(bagID, slotID)

        if not texture then
            return nil
        end

        -- Return a table structure similar to Retail
        return {
            iconFileID = texture,
            stackCount = itemCount,
            isLocked = locked,
            quality = quality,
            isReadable = readable,
            hasLoot = lootable,
            hyperlink = itemLink,
            isFiltered = isFiltered,
            hasNoValue = noValue,
            itemID = itemID,
        }
    end

    -- Get container number of slots
    function C_Container.GetContainerNumSlots(bagID)
        return GetContainerNumSlots(bagID)
    end

    -- Get container number of free slots
    function C_Container.GetContainerNumFreeSlots(bagID)
        return GetContainerNumFreeSlots(bagID)
    end

    -- Use container item
    function C_Container.UseContainerItem(bagID, slotID)
        return UseContainerItem(bagID, slotID)
    end

    -- Pick up container item
    function C_Container.PickupContainerItem(bagID, slotID)
        return PickupContainerItem(bagID, slotID)
    end

    -- Get number of bag slots
    function C_Container.GetNumBagSlots()
        return NUM_BAG_SLOTS or 4
    end
end

-- =============================================================================
-- Unit Aura API Compatibility
-- =============================================================================
-- Retail uses C_UnitAuras.GetAuraDataByIndex, TBC uses UnitBuff/UnitDebuff

if not C_UnitAuras then
    C_UnitAuras = {}

    -- Get buff/debuff by index
    function C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
        local isHelpful = filter and filter:find("HELPFUL")
        local isHarmful = filter and filter:find("HARMFUL")

        local name, icon, count, dispelType, duration, expirationTime, source,
              isStealable, nameplateShowPersonal, spellId

        if isHelpful or (not isHarmful and not isHelpful) then
            name, icon, count, dispelType, duration, expirationTime, source,
            isStealable, nameplateShowPersonal, spellId = UnitBuff(unit, index, filter)
        elseif isHarmful then
            name, icon, count, dispelType, duration, expirationTime, source,
            isStealable, nameplateShowPersonal, spellId = UnitDebuff(unit, index, filter)
        end

        if not name then
            return nil
        end

        -- Return table structure similar to Retail
        return {
            name = name,
            icon = icon,
            applications = count,
            dispelName = dispelType,
            duration = duration,
            expirationTime = expirationTime,
            sourceUnit = source,
            isStealable = isStealable,
            nameplateShowPersonal = nameplateShowPersonal,
            spellId = spellId,
        }
    end
end

-- =============================================================================
-- LibDualSpec Mock
-- =============================================================================
-- LibDualSpec-1.0 is a WotLK feature library. Mock it for TBC to prevent errors.

local LibStub = _G.LibStub
if LibStub then
    -- Only create mock if LibDualSpec isn't already loaded
    if not LibStub:GetLibrary("LibDualSpec-1.0", true) then
        local MockLibDualSpec = {}

        function MockLibDualSpec:EnhanceDatabase(db, name)
            -- No-op: TBC has no dual spec, so just return the database unchanged
            return db
        end

        function MockLibDualSpec:EnhanceOptions(options, db)
            -- No-op: No dual spec options needed in TBC
        end

        -- Register the mock library
        LibStub:NewLibrary("LibDualSpec-1.0", 1)
        for k, v in pairs(MockLibDualSpec) do
            LibStub.libs["LibDualSpec-1.0"][k] = v
        end
    end
end

-- =============================================================================
-- Power Type Constants
-- =============================================================================
-- Define power type enums that may not exist in TBC

if not Enum then
    Enum = {}
end

if not Enum.PowerType then
    Enum.PowerType = {
        Mana = 0,
        Rage = 1,
        Focus = 2,
        Energy = 3,
        Happiness = 4, -- Hunter pet happiness (TBC specific)
    }
end

if not Enum.AddOnEnableState then
    Enum.AddOnEnableState = {
        None = 0,
        Some = 1,
        All = 2,
    }
end

-- =============================================================================
-- Item Quality Colors
-- =============================================================================
-- Ensure ITEM_QUALITY_COLORS is available (should exist in TBC but verify)

if not ITEM_QUALITY_COLORS then
    ITEM_QUALITY_COLORS = {
        [0] = { r = 0.62, g = 0.62, b = 0.62 }, -- Poor (Gray)
        [1] = { r = 1.00, g = 1.00, b = 1.00 }, -- Common (White)
        [2] = { r = 0.12, g = 1.00, b = 0.00 }, -- Uncommon (Green)
        [3] = { r = 0.00, g = 0.44, b = 0.87 }, -- Rare (Blue)
        [4] = { r = 0.64, g = 0.21, b = 0.93 }, -- Epic (Purple)
        [5] = { r = 1.00, g = 0.50, b = 0.00 }, -- Legendary (Orange)
        [6] = { r = 0.90, g = 0.80, b = 0.50 }, -- Artifact (Golden)
    }
end

-- =============================================================================
-- Currency System Compatibility
-- =============================================================================
-- TBC has a much simpler currency system than Retail

if not C_CurrencyInfo then
    C_CurrencyInfo = {}

    function C_CurrencyInfo.GetCurrencyInfo(currencyID)
        -- TBC doesn't have the complex currency system
        -- Return nil or mock data as needed
        return nil
    end

    function C_CurrencyInfo.GetCurrencyListInfo(index)
        return nil
    end
end

-- =============================================================================
-- Spell System Compatibility
-- =============================================================================

if not C_Spell then
    C_Spell = {}

    function C_Spell.GetSpellInfo(spellID)
        if not spellID then return nil end

        local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)
        if not name then return nil end

        return {
            name = name,
            rank = rank,
            icon = icon,
            castTime = castTime,
            minRange = minRange,
            maxRange = maxRange,
        }
    end
end

-- =============================================================================
-- Trait/Talent System Compatibility
-- =============================================================================
-- Retail has trait trees, TBC has talent trees

if not C_Traits then
    C_Traits = {}

    -- Mock trait functions to prevent errors
    function C_Traits.GetConfigInfo()
        return nil
    end

    function C_Traits.GetTreeNodes()
        return {}
    end
end

-- =============================================================================
-- Item System Compatibility
-- =============================================================================

if not C_Item then
    C_Item = {}

    function C_Item.GetItemInfo(itemID)
        if not itemID then return nil end
        return GetItemInfo(itemID)
    end

    function C_Item.GetItemInfoInstant(itemID)
        if not itemID then return nil end
        return GetItemInfo(itemID)
    end

    function C_Item.IsItemDataCached(itemID)
        -- In TBC, items are generally cached after first request
        return GetItemInfo(itemID) ~= nil
    end
end

-- =============================================================================
-- Quest System Compatibility
-- =============================================================================

if not C_QuestLog then
    C_QuestLog = {}

    function C_QuestLog.GetNumQuestLogEntries()
        return GetNumQuestLogEntries()
    end

    function C_QuestLog.GetInfo(questLogIndex)
        local title, level, tag, suggestedGroup, isHeader, isCollapsed,
              isComplete, isDaily = GetQuestLogTitle(questLogIndex)

        return {
            title = title,
            level = level,
            tag = tag,
            suggestedGroup = suggestedGroup,
            isHeader = isHeader,
            isCollapsed = isCollapsed,
            isComplete = isComplete,
            frequency = isDaily and 1 or nil,
        }
    end
end

-- =============================================================================
-- Map System Compatibility
-- =============================================================================

if not C_Map then
    C_Map = {}

    function C_Map.GetBestMapForUnit(unit)
        return GetCurrentMapZone()
    end

    function C_Map.GetPlayerMapPosition(mapID, unit)
        local x, y = GetPlayerMapPosition(unit or "player")
        if x and y then
            return CreateVector2D(x, y)
        end
        return nil
    end
end

-- =============================================================================
-- Completed: TBC Compatibility Shim
-- =============================================================================
