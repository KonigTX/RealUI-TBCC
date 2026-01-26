local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


do --[[ AddOns\Blizzard_InspectUI.lua ]]
    do --[[ InspectPaperDollFrame.lua ]]
        function Hook.InspectPaperDollFrame_OnShow()
            local _, classToken = _G.UnitClass(_G.InspectFrame.unit)
            if _G.InspectPaperDollFrame and _G.InspectPaperDollFrame._classBG then
                _G.InspectPaperDollFrame._classBG:SetAtlas("dressingroom-background-"..classToken)
            end
        end
        function Hook.InspectPaperDollItemSlotButton_Update(button)
            local unit = _G.InspectFrame.unit
            local quality = _G.GetInventoryItemQuality(unit, button:GetID())
            Hook.SetItemButtonQuality(button, quality, _G.GetInventoryItemID(unit, button:GetID()))

            local name = button.GetName and button:GetName() or ""
            local slotTexture = name ~= "" and _G[name.."SlotTexture"] or nil
            if slotTexture then
                slotTexture:Hide()
                slotTexture:SetTexture("")
            end
            local slotBackground = name ~= "" and _G[name.."SlotBackground"] or nil
            if slotBackground then
                slotBackground:Hide()
                slotBackground:SetTexture("")
            end
            local normal = button.GetNormalTexture and button:GetNormalTexture() or nil
            if normal then
                normal:SetTexture("")
                normal:Hide()
            end
            local pushed = button.GetPushedTexture and button:GetPushedTexture() or nil
            if pushed then
                pushed:SetTexture("")
                pushed:Hide()
            end
            local highlight = button.GetHighlightTexture and button:GetHighlightTexture() or nil
            if highlight then
                highlight:SetTexture("")
                highlight:Hide()
            end
        end
    end
    do --[[ InspectPVPFrame.lua ]]
        Hook.InspectPvpTalentSlotMixin = {}
        function Hook.InspectPvpTalentSlotMixin:Update()
            if not self._auroraBG then return end

            local selectedTalentID = _G.C_SpecializationInfo.GetInspectSelectedPvpTalent(_G.INSPECTED_UNIT, self.slotIndex)
            if selectedTalentID then
                local _, _, texture = _G.GetPvpTalentInfoByID(selectedTalentID)
                self.Texture:SetTexture(texture)
                self._auroraBG:SetColorTexture(Color.black:GetRGB())
                self.Texture:SetDesaturated(false)
            else
                self.Texture:Show()
                self._auroraBG:SetColorTexture(Color.gray:GetRGB())
                self.Texture:SetDesaturated(true)
            end
        end
    end
    do --[[ InspectHonorFrame.lua ]]
        function Hook.InspectHonorFrame_Update()
            local xOffset = _G.InspectHonorFrameCurrentPVPRank:GetWidth()/2
            _G.InspectHonorFrameCurrentPVPTitle:SetPoint("TOP", _G.InspectFrame:GetBackdropTexture("bg"), -xOffset, -30)
        end
    end
    -- do --[[ InspectTalentFrame.lua ]]
    --     function Hook.InspectTalentFrameSpec_OnShow(self)
    --         local spec
    --         if _G.INSPECTED_UNIT ~= nil then
    --             spec = _G.GetInspectSpecialization(_G.INSPECTED_UNIT)
    --         end
    --         if spec ~= nil and spec > 0 then
    --             local role1 = _G.GetSpecializationRoleByID(spec)
    --             if role1 ~= nil then
    --                 local _, _, _, icon = _G.GetSpecializationInfoByID(spec)
    --                 self.specIcon:SetTexture(icon)
    --                 Base.SetTexture(self.roleIcon, "icon"..role1)
    --             end
    --         end
    --     end
    -- end
end

do --[[ AddOns\Blizzard_InspectUI.xml ]]
    do --[[ InspectPaperDollFrame.xml ]]
        function Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            if not ItemButton.icon and ItemButton.GetName then
                ItemButton.icon = _G[ItemButton:GetName().."IconTexture"]
            end
            if not ItemButton.subicon and ItemButton.GetName then
                ItemButton.subicon = _G[ItemButton:GetName().."SubIconTexture"]
            end
            Skin.FrameTypeItemButton(ItemButton)
            ItemButton:ClearNormalTexture()
            if ItemButton.SetHighlightTexture then
                ItemButton:SetHighlightTexture("")
            end
        end
        function Skin.InspectPaperDollItemSlotButtonLeftTemplate(ItemButton)
            Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            _G[ItemButton:GetName().."Frame"]:Hide()
        end
        Skin.InspectPaperDollItemSlotButtonRightTemplate = Skin.InspectPaperDollItemSlotButtonLeftTemplate
        Skin.InspectPaperDollItemSlotButtonBottomTemplate = Skin.InspectPaperDollItemSlotButtonLeftTemplate
    end
    do --[[ InspectPVPFrame.xml ]]
        function Skin.InspectPvpTalentSlotTemplate(Button)
            Skin.PvpTalentSlotTemplate(Button)
            Util.Mixin(Button, Hook.InspectPvpTalentSlotMixin)
        end
    end
    do --[[ InspectTalentFrame.xml ]]
        function Skin.InspectTalentButtonTemplate(Button)
            Button._auroraIconBG = Base.CropIcon(Button.icon, Button)
            Button.Slot:Hide()
            Button.border:SetTexture("")
        end
        function Skin.InspectTalentRowTemplate(Frame)
            Skin.InspectTalentButtonTemplate(Frame.talent1)
            Skin.InspectTalentButtonTemplate(Frame.talent2)
            Skin.InspectTalentButtonTemplate(Frame.talent3)
        end
    end
end

function private.AddOns.Blizzard_InspectUI()
    local InspectFrame = _G.InspectFrame
    ----====####$$$$%%%%$$$$####====----
    --       Blizzard_InspectUI       --
    ----====####$$$$%%%%$$$$####====----
    Skin.ButtonFrameTemplate(InspectFrame)
    local InspectPortrait = InspectFrame.PortraitContainer or _G.InspectFramePortrait or InspectFrame.portrait
    if InspectPortrait then
        InspectPortrait:Hide()
        InspectPortrait.SetAlpha = function() end
        InspectPortrait.Show = function() end
    end
    if InspectFrame.Inset then
        Base.StripBlizzardTextures(InspectFrame.Inset)
    end
    if InspectFrame.InsetRight then
        Base.StripBlizzardTextures(InspectFrame.InsetRight)
    end

    if _G.InspectFrameTab1 then
        Base.StripBlizzardTextures(_G.InspectFrameTab1)
        Skin.PanelTabButtonTemplate(_G.InspectFrameTab1)
    end
    if _G.InspectFrameTab2 then
        Base.StripBlizzardTextures(_G.InspectFrameTab2)
        Skin.PanelTabButtonTemplate(_G.InspectFrameTab2)
    end
    if _G.InspectFrameTab3 then
        Base.StripBlizzardTextures(_G.InspectFrameTab3)
        Skin.PanelTabButtonTemplate(_G.InspectFrameTab3)
    end
    -- TBCC needs different spacing than Retail due to tab template width differences
    local tabSpacing = private.isTBC and 4 or 1
    Util.PositionRelative("TOPLEFT", InspectFrame, "BOTTOMLEFT", 20, -1, tabSpacing, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
        _G.InspectFrameTab3,
    })

    ----====####$$$$%%%%%$$$$####====----
    --      InspectPaperDollFrame      --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("InspectPaperDollFrame_OnShow", Hook.InspectPaperDollFrame_OnShow)
    _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", Hook.InspectPaperDollItemSlotButton_Update)

    local InspectPaperDollFrame = _G.InspectPaperDollFrame
    InspectPaperDollFrame:HookScript("OnShow", Hook.InspectPaperDollFrame_OnShow)

    Skin.UIPanelButtonTemplate(InspectPaperDollFrame.ViewButton)

    local InspectPaperDollItemsFrame = _G.InspectPaperDollItemsFrame
    if InspectPaperDollItemsFrame and InspectPaperDollItemsFrame.InspectTalents then
        Skin.UIPanelButtonTemplate(InspectPaperDollItemsFrame.InspectTalents)
    end

    local bg
    if InspectFrame.NineSlice and InspectFrame.NineSlice.GetBackdropTexture then
        bg = InspectFrame.NineSlice:GetBackdropTexture("bg")
    elseif InspectFrame.GetBackdropTexture then
        bg = InspectFrame:GetBackdropTexture("bg")
    end
    local classBG = InspectPaperDollFrame:CreateTexture(nil, "BORDER")
    classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
    if bg then
        classBG:SetPoint("TOPLEFT", bg)
        classBG:SetPoint("BOTTOM", bg)
    end
    if InspectFrame.Inset then
        classBG:SetPoint("RIGHT", InspectFrame.Inset, 4, 0)
    end
    InspectPaperDollFrame._classBG = classBG

    local settings = private.CLASS_BACKGROUND_SETTINGS[private.charClass.token] or private.CLASS_BACKGROUND_SETTINGS["DEFAULT"];
    classBG:SetDesaturation(settings.desaturation)
    classBG:SetAlpha(settings.alpha)

    _G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
    _G.InspectModelFrame.BackgroundOverlay:Hide()
    _G.InspectModelFrame:DisableDrawLayer("OVERLAY")

    local EquipmentSlots = {
        "InspectHeadSlot", "InspectNeckSlot", "InspectShoulderSlot", "InspectBackSlot", "InspectChestSlot", "InspectShirtSlot", "InspectTabardSlot", "InspectWristSlot",
        "InspectHandsSlot", "InspectWaistSlot", "InspectLegsSlot", "InspectFeetSlot", "InspectFinger0Slot", "InspectFinger1Slot", "InspectTrinket0Slot", "InspectTrinket1Slot"
    }
    local WeaponSlots = {
        "InspectMainHandSlot", "InspectSecondaryHandSlot"
    }

    local slotsPerSide, prevSlot = 8
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]
        button:ClearAllPoints()
        local isLeftSide = button.IsLeftSide or i <= slotsPerSide

        if i % slotsPerSide == 1 then
            if isLeftSide then
                button:SetPoint("TOPLEFT", InspectFrame.Inset, 4, 22)
            else
                button:SetPoint("TOPRIGHT", InspectFrame.Inset, -4, 22)
            end
        else
            button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
        end

        if isLeftSide then
            Skin.InspectPaperDollItemSlotButtonLeftTemplate(button)
        elseif isLeftSide == false then
            Skin.InspectPaperDollItemSlotButtonRightTemplate(button)
        end

        prevSlot = button
    end
    local InspectRangedSlot = _G.InspectRangedSlot
    if InspectRangedSlot then
        Skin.InspectPaperDollItemSlotButtonRightTemplate(InspectRangedSlot)
    end
    local InspectAmmoSlot = _G.InspectAmmoSlot
    if InspectAmmoSlot then
        Skin.InspectPaperDollItemSlotButtonRightTemplate(InspectAmmoSlot)
    end

    for i = 1, #WeaponSlots do
        local button = _G[WeaponSlots[i]]

        if i == 1 then
            -- main hand
            button:SetPoint("BOTTOMLEFT", 130, 8)
        end

        _G.select(button:GetNumRegions(), button:GetRegions()):Hide()
        Skin.InspectPaperDollItemSlotButtonBottomTemplate(button)
    end

    ----====####$$$$%%%%%$$$$####====----
    --         InspectPVPFrame         --
    ----====####$$$$%%%%%$$$$####====----
    local InspectPVPFrame = _G.InspectPVPFrame
    if InspectPVPFrame and InspectPVPFrame.BG and bg then
        InspectPVPFrame.BG:SetTexCoord(0.00390625, 0.3115234375, 0.34375, 0.87890625)
        InspectPVPFrame.BG:SetDesaturated(true)
        InspectPVPFrame.BG:SetBlendMode("ADD")
        InspectPVPFrame.BG:SetAllPoints(bg)
    end

    if InspectPVPFrame and InspectPVPFrame.RatedBG then
        InspectPVPFrame.RatedBG:SetPoint("TOPLEFT", InspectPVPFrame, 8, -124)
    end
    if InspectPVPFrame and InspectPVPFrame.Slots and InspectPVPFrame.Slots[1] then
        InspectPVPFrame.Slots[1]:SetPoint("TOPRIGHT", InspectPVPFrame, -46, -124)
        for i = 1, #InspectPVPFrame.Slots do
            Skin.InspectPvpTalentSlotTemplate(InspectPVPFrame.Slots[i])
        end
    end

    ----====####$$$$%%%%$$$$####====----
    --       InspectTalentFrame       --
    ----====####$$$$%%%%$$$$####====----
    -- _G.hooksecurefunc("InspectTalentFrameSpec_OnShow", Hook.InspectTalentFrameSpec_OnShow)

    -- local InspectTalentFrame = _G.InspectTalentFrame
    -- local talentBG, talentTile = InspectTalentFrame:GetRegions()
    -- talentBG:Hide()
    -- talentTile:Hide()

    -- local InspectSpec = InspectTalentFrame.InspectSpec
    -- InspectSpec:HookScript("OnShow", Hook.InspectTalentFrameSpec_OnShow)
    -- InspectSpec.ring:Hide()
    -- Base.CropIcon(InspectSpec.specIcon, InspectSpec)

    -- local InspectTalents = InspectTalentFrame.InspectTalents
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier1)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier2)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier3)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier4)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier5)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier6)
    -- Skin.InspectTalentRowTemplate(InspectTalents.tier7)

    ----====####$$$$%%%%%$$$$####====----
    --        InspectGuildFrame        --
    ----====####$$$$%%%%%$$$$####====----
    --local InspectGuildFrame = _G.InspectGuildFrame
    if _G.InspectGuildFrameBG then
        _G.InspectGuildFrameBG:Hide()
    end
end
