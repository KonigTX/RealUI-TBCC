local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

--[[
    TBCC CHARACTER FRAME TEXTURE BEHAVIOR (IMPORTANT):
    ==================================================
    - StripTextures hides ALL textures including gear icons
    - We must: 1) Save icon reference, 2) Strip textures, 3) Restore icon
    - Icon textures: slot.icon or _G["Character*SlotIconTexture"]
    - Border textures: NormalTexture, slot frames, unnamed regions
]]

function private.FrameXML.PaperDollFrame()
    local slotNames = {
        "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard",
        "Wrist", "Hands", "Waist", "Legs", "Feet",
        "Finger0", "Finger1", "Trinket0", "Trinket1",
        "MainHand", "SecondaryHand", "Ranged"
    }

    for _, slotName in ipairs(slotNames) do
        local slot = _G["Character"..slotName.."Slot"]
        if slot then
            -- STEP 1: Get icon texture reference BEFORE stripping
            local icon = slot.icon or _G["Character"..slotName.."SlotIconTexture"]
            local iconTexture = icon and icon:GetTexture()

            -- STEP 2: Strip ALL textures (this hides borders AND icons)
            for i = 1, slot:GetNumRegions() do
                local region = select(i, slot:GetRegions())
                if region and region:IsObjectType("Texture") then
                    region:SetTexture("")
                    region:SetAlpha(0)
                    region:Hide()
                end
            end

            -- Also hide the NormalTexture (border)
            local normalTex = slot:GetNormalTexture()
            if normalTex then
                normalTex:SetTexture("")
                normalTex:SetAlpha(0)
            end

            -- STEP 3: RESTORE the icon texture
            if icon then
                if iconTexture then
                    icon:SetTexture(iconTexture)
                end
                icon:SetAlpha(1)
                icon:Show()
                icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end

            -- Add Aurora backdrop
            Base.SetBackdrop(slot, Color.button, 0.3)
        end
    end

    -- Skin resistance frame
    local MagicResFrame1 = _G.MagicResFrame1
    if MagicResFrame1 and MagicResFrame1:GetParent() then
        for i = 1, 5 do
            local resFrame = _G["MagicResFrame"..i]
            if resFrame then
                Base.SetBackdrop(resFrame, Color.frame, 0.3)
            end
        end
    end
end
