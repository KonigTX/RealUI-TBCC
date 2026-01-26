local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PaperDollFrame.lua ]]
    do --[[ PaperDollFrame.lua ]]
        function Hook.PaperDollFrame_SetLevel()
            if not _G.CharacterLevelText or not _G.CharacterFrame or not _G.CharacterFrame.TitleContainer then
                return
            end
            local classLocale, classColor = private.charClass.locale, _G.CUSTOM_CLASS_COLORS[private.charClass.token]

            local level = _G.UnitLevel("player")
            local effectiveLevel = _G.UnitEffectiveLevel("player")

            if ( effectiveLevel ~= level ) then
                level = _G.EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
            end

            local _, specName = _G.C_SpecializationInfo.GetSpecializationInfo(_G.C_SpecializationInfo.GetSpecialization(), nil, nil, nil, _G.UnitSex("player"))
            if specName and specName ~= "" then
                _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, level, classColor.colorStr, specName, classLocale)
            end

            local showTrialCap = false
            if _G.GameLimitedMode_IsActive() then
                local rLevel = _G.GetRestrictedAccountData()
                if _G.UnitLevel("player") >= rLevel then
                    showTrialCap = true
                end
            end
            _G.CharacterLevelText:ClearAllPoints()
            if showTrialCap then
                _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleContainer, "TOP", 0, -36)
            else
                --_G.CharacterTrialLevelErrorText:Show()
                _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleContainer, "BOTTOM", 0, -4)
            end
        end
    end
end

do --[[ FrameXML\PaperDollFrame.xml ]]
    do --[[ AzeritePaperDollItemOverlay.xml ]]
        function Skin.PaperDollAzeriteItemOverlayTemplate(Frame)
            if Frame.RankFrame and Frame.RankFrame.Label and Frame.RankFrame.Texture then
                Frame.RankFrame.Label:SetPoint("CENTER", Frame.RankFrame.Texture, 0, 0)
            end
        end
    end
    do --[[ PaperDollFrame.xml ]]
        function Skin.PaperDollItemSlotButtonTemplate(ItemButton)
            if not ItemButton.icon and ItemButton.GetName then
                ItemButton.icon = _G[ItemButton:GetName().."IconTexture"]
            end
            if not ItemButton.subicon and ItemButton.GetName then
                ItemButton.subicon = _G[ItemButton:GetName().."SubIconTexture"]
            end
            Skin.FrameTypeItemButton(ItemButton)
            Skin.PaperDollAzeriteItemOverlayTemplate(ItemButton)
            local slotFrame = _G[ItemButton:GetName().."Frame"]
            if slotFrame then
                slotFrame:Hide()
            end
            local slotTexture = _G[ItemButton:GetName().."SlotTexture"]
            if slotTexture then
                slotTexture:SetTexture("")
                slotTexture:Hide()
            end
            local itemName = _G[ItemButton:GetName().."Name"]
            if itemName then itemName:Hide() end
            if ItemButton.Name then ItemButton.Name:Hide() end
            local itemNameFrame = _G[ItemButton:GetName().."NameFrame"]
            if itemNameFrame then itemNameFrame:Hide() end
            if ItemButton.IconBorder then
                ItemButton.IconBorder:Hide()
            end
            local icon = ItemButton.icon or _G[ItemButton:GetName().."IconTexture"]
            local subicon = ItemButton.subicon or _G[ItemButton:GetName().."SubIconTexture"]
            if ItemButton.GetNumRegions then
                for i = 1, ItemButton:GetNumRegions() do
                    local region = _G.select(i, ItemButton:GetRegions())
                    if region and region.GetObjectType and region:GetObjectType() == "Texture"
                        and region ~= icon and region ~= subicon
                        and region ~= ItemButton.IconOverlay and region ~= ItemButton.searchOverlay
                    then
                        local tex = region.GetTexture and region:GetTexture()
                        local atlas = region.GetAtlas and region:GetAtlas()
                        if (type(tex) == "string" and (tex:find("PaperDoll") or tex:find("UI%-Character") or tex:find("ItemSlot")))
                            or (atlas and atlas:find("Character"))
                        then
                            region:SetTexture("")
                            region:SetAtlas("")
                            region:Hide()
                        end
                    end
                end
            end
            local normal = ItemButton.GetNormalTexture and ItemButton:GetNormalTexture() or nil
            if normal then
                normal:SetTexture("")
                normal:Hide()
            end
            local pushed = ItemButton.GetPushedTexture and ItemButton:GetPushedTexture() or nil
            if pushed then
                pushed:SetTexture("")
                pushed:Hide()
            end
            local highlight = ItemButton.GetHighlightTexture and ItemButton:GetHighlightTexture() or nil
            if highlight then
                highlight:SetTexture("")
            end

            if ItemButton.popoutButton then
                if ItemButton.verticalFlyout then
                    ItemButton.popoutButton:SetPoint("TOP", ItemButton, "BOTTOM")
                    ItemButton.popoutButton:SetSize(38, 8)
                    Skin.EquipmentFlyoutPopoutButtonTemplate(ItemButton.popoutButton)
                    Base.SetTexture(ItemButton.popoutButton._auroraArrow, "arrowDown")
                else
                    ItemButton.popoutButton:SetPoint("LEFT", ItemButton, "RIGHT")
                    ItemButton.popoutButton:SetSize(8, 38)
                    Skin.EquipmentFlyoutPopoutButtonTemplate(ItemButton.popoutButton)
                end
            end
        end
        function Skin.PaperDollItemSlotButtonLeftTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PaperDollItemSlotButtonRightTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PaperDollItemSlotButtonBottomTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PlayerTitleButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)
            Button:GetHighlightTexture():SetColorTexture(0, 0, 1, 0.2)
        end
        function Skin.GearSetButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.HighlightBar:SetColorTexture(0, 0, 1, 0.3)
            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)

            Base.CropIcon(Button.icon, Button)
        end
        function Skin.GearSetPopupButtonTemplate(CheckButton)
            Skin.SimplePopupButtonTemplate(CheckButton)
            Base.CropIcon(_G[CheckButton:GetName().."Icon"])
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
        function Skin.PaperDollSidebarTabTemplate(Button)
            Button.TabBg:SetAlpha(0)
            Button.Hider:SetTexture("")

            Button.Icon:ClearAllPoints()
            Button.Icon:SetPoint("TOPLEFT", 1, -1)
            Button.Icon:SetPoint("BOTTOMRIGHT", -1, 1)

            Button.Highlight:SetTexture("")

            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button)
        end

        function Skin.MagicResistanceFrameTemplate(Frame)
            Frame:SetSize(20, 20)
            local icon = Frame:GetRegions()
            Frame._icon = icon
            Base.CropIcon(icon, Frame)
        end
    end
end

function private.FrameXML.PaperDollFrame()
    if type(_G.hooksecurefunc) == "function" and type(_G.PaperDollFrame_SetLevel) == "function" then
        _G.hooksecurefunc("PaperDollFrame_SetLevel", Hook.PaperDollFrame_SetLevel)
    end

    local CharacterFrame = _G.CharacterFrame
    if not CharacterFrame then return end
    Skin.ButtonFrameTemplate(CharacterFrame)
    if CharacterFrame.Inset then
        Base.StripBlizzardTextures(CharacterFrame.Inset)
    end
    if CharacterFrame.InsetRight then
        Base.StripBlizzardTextures(CharacterFrame.InsetRight)
    end

    local bg
    if CharacterFrame.NineSlice and CharacterFrame.NineSlice.GetBackdropTexture then
        bg = CharacterFrame.NineSlice:GetBackdropTexture("bg")
    end
    local classBG = _G.PaperDollFrame:CreateTexture(nil, "BORDER")
    classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
    if bg then
        classBG:SetPoint("TOPLEFT", bg)
        classBG:SetPoint("BOTTOM", bg)
    end
    if CharacterFrame.Inset then
        classBG:SetPoint("RIGHT", CharacterFrame.Inset, 4, 0)
    end

    local settings = private.CLASS_BACKGROUND_SETTINGS[private.charClass.token] or private.CLASS_BACKGROUND_SETTINGS["DEFAULT"];
    classBG:SetDesaturation(settings.desaturation)
    classBG:SetAlpha(settings.alpha)

    if _G.PaperDollFrame and _G.PaperDollFrame.GetNumRegions then
        for i = 1, _G.PaperDollFrame:GetNumRegions() do
            local region = _G.select(i, _G.PaperDollFrame:GetRegions())
            if region and region.GetObjectType and region:GetObjectType() == "Texture" then
                local tex = region.GetTexture and region:GetTexture()
                local atlas = region.GetAtlas and region:GetAtlas()
                -- Expanded pattern matching for TBCC textures
                if (type(tex) == "string" and (
                    tex:find("PaperDoll") or
                    tex:find("UI%-Character") or
                    tex:find("Character") or
                    tex:find("UI%-Panel") or  -- Add panel textures
                    tex:find("Portrait") or   -- Add portrait textures
                    tex:find("Inset")         -- Add inset textures
                )) or (atlas and (
                    atlas:find("Character") or
                    atlas:find("ui%-panel") or
                    atlas:find("paperdoll")
                )) then
                    region:SetTexture("")
                    if region.SetAtlas then region:SetAtlas("") end
                    region:Hide()
                end
            end
        end
    end

    if _G.PaperDollSidebarTabs then
        _G.PaperDollSidebarTabs:ClearAllPoints()
        if CharacterFrame.InsetRight then
            _G.PaperDollSidebarTabs:SetPoint("BOTTOM", CharacterFrame.InsetRight, "TOP", 0, -3)
        end
        if _G.PaperDollSidebarTabs.DecorLeft then
            _G.PaperDollSidebarTabs.DecorLeft:Hide()
        end
        if _G.PaperDollSidebarTabs.DecorRight then
            _G.PaperDollSidebarTabs.DecorRight:Hide()
        end
    end

    if _G.PAPERDOLL_SIDEBARS then
        for i = 1, #_G.PAPERDOLL_SIDEBARS do
            local tab = _G["PaperDollSidebarTab"..i]
            if tab then
                Skin.PaperDollSidebarTabTemplate(tab)
            end
        end
    end


    local TitleManagerPane = _G.PaperDollFrame.TitleManagerPane
    if TitleManagerPane then
        if TitleManagerPane.ScrollBox and Skin.WowScrollBoxList then
            Skin.WowScrollBoxList(TitleManagerPane.ScrollBox)
        end
        if TitleManagerPane.ScrollBar and Skin.MinimalScrollBar then
            Skin.MinimalScrollBar(TitleManagerPane.ScrollBar)
        end
    end


    local EquipmentManagerPane = _G.PaperDollFrame.EquipmentManagerPane
    if EquipmentManagerPane then
        if EquipmentManagerPane.ScrollBox and Skin.WowScrollBoxList then
            Skin.WowScrollBoxList(EquipmentManagerPane.ScrollBox)
        end
        if EquipmentManagerPane.ScrollBar and Skin.MinimalScrollBar then
            Skin.MinimalScrollBar(EquipmentManagerPane.ScrollBar)
        end
    end

    if EquipmentManagerPane and EquipmentManagerPane.EquipSet then
        Skin.UIPanelButtonTemplate(EquipmentManagerPane.EquipSet)
    end
    if EquipmentManagerPane and EquipmentManagerPane.SaveSet then
        Skin.UIPanelButtonTemplate(EquipmentManagerPane.SaveSet)
    end


    if _G.CharacterModelScene and CharacterFrame.Inset then
        _G.CharacterModelScene:SetPoint("TOPLEFT", CharacterFrame.Inset, 45, -10)
        _G.CharacterModelScene:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, -45, 30)
    end

    local PaperDollItemsFrame = _G.PaperDollItemsFrame
    if PaperDollItemsFrame then
        Skin.FrameTypeFrame(PaperDollItemsFrame)
        PaperDollItemsFrame:DisableDrawLayer("BACKGROUND")
        PaperDollItemsFrame:DisableDrawLayer("BORDER")
        PaperDollItemsFrame:DisableDrawLayer("ARTWORK")
        if PaperDollItemsFrame._stripes then
            PaperDollItemsFrame._stripes:Hide()
        end
        if PaperDollItemsFrame.Center then
            PaperDollItemsFrame.Center:Hide()
        end
        if PaperDollItemsFrame.GetNumRegions then
            for i = 1, PaperDollItemsFrame:GetNumRegions() do
                local region = _G.select(i, PaperDollItemsFrame:GetRegions())
                if region and region.GetObjectType and region:GetObjectType() == "Texture" then
                    region:SetTexture("")
                    region:SetAtlas("")
                    region:Hide()
                end
            end
        end
    end

    local function HideTexture(name)
        local tex = _G[name]
        if tex then
            tex:SetTexture("")
            tex:Hide()
        end
    end
    HideTexture("PaperDollFrameBackgroundTopLeft")
    HideTexture("PaperDollFrameBackgroundTopRight")
    HideTexture("PaperDollFrameBackgroundBotLeft")
    HideTexture("PaperDollFrameBackgroundBotRight")
    HideTexture("PaperDollFrameBackgroundTop")
    HideTexture("PaperDollFrameBackgroundBottom")
    HideTexture("PaperDollFrameBackgroundMiddle")
    HideTexture("PaperDollFrameBackground")
    HideTexture("PaperDollFrameBg")
    -- Keep PaperDollFrame base so Aurora frame stays visible.

    if _G.CharacterModelFrameBackgroundTopLeft then _G.CharacterModelFrameBackgroundTopLeft:Hide() end
    if _G.CharacterModelFrameBackgroundTopRight then _G.CharacterModelFrameBackgroundTopRight:Hide() end
    if _G.CharacterModelFrameBackgroundBotLeft then _G.CharacterModelFrameBackgroundBotLeft:Hide() end
    if _G.CharacterModelFrameBackgroundBotRight then _G.CharacterModelFrameBackgroundBotRight:Hide() end

    if _G.CharacterModelFrameBorderTopLeft then _G.CharacterModelFrameBorderTopLeft:Hide() end
    if _G.CharacterModelFrameBorderTopRight then _G.CharacterModelFrameBorderTopRight:Hide() end
    if _G.CharacterModelFrameBorderBotLeft then _G.CharacterModelFrameBorderBotLeft:Hide() end
    if _G.CharacterModelFrameBorderBotRight then _G.CharacterModelFrameBorderBotRight:Hide() end
    if _G.CharacterModelFrameBorderTop then _G.CharacterModelFrameBorderTop:Hide() end
    if _G.CharacterModelFrameBorderBottom then _G.CharacterModelFrameBorderBottom:Hide() end
    if _G.CharacterModelFrameBorderLeft then _G.CharacterModelFrameBorderLeft:Hide() end
    if _G.CharacterModelFrameBorderRight then _G.CharacterModelFrameBorderRight:Hide() end

    if _G.CharacterModelFrameBackgroundOverlay then _G.CharacterModelFrameBackgroundOverlay:Hide() end

    if _G.PaperDollInnerBorderTopLeft then _G.PaperDollInnerBorderTopLeft:Hide() end
    if _G.PaperDollInnerBorderTopRight then _G.PaperDollInnerBorderTopRight:Hide() end
    if _G.PaperDollInnerBorderBottomLeft then _G.PaperDollInnerBorderBottomLeft:Hide() end
    if _G.PaperDollInnerBorderBottomRight then _G.PaperDollInnerBorderBottomRight:Hide() end
    if _G.PaperDollInnerBorderLeft then _G.PaperDollInnerBorderLeft:Hide() end
    if _G.PaperDollInnerBorderRight then _G.PaperDollInnerBorderRight:Hide() end
    if _G.PaperDollInnerBorderTop then _G.PaperDollInnerBorderTop:Hide() end
    if _G.PaperDollInnerBorderBottom then _G.PaperDollInnerBorderBottom:Hide() end
    if _G.PaperDollInnerBorderBottom2 then _G.PaperDollInnerBorderBottom2:Hide() end


    local EquipmentSlots = {
        "CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
        "CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot"
    }
    local WeaponSlots = {
        "CharacterMainHandSlot", "CharacterSecondaryHandSlot"
    }
    local baseSlot = _G.CharacterHeadSlot
    local slotW, slotH
    if baseSlot and baseSlot.GetSize then
        slotW, slotH = baseSlot:GetSize()
    end
    if not slotW or not slotH then
        slotW, slotH = 37, 37
    end

    local slotsPerSide, prevSlot = 8
    local itemsFrame = _G.PaperDollItemsFrame
    local inset = itemsFrame or CharacterFrame.Inset or CharacterFrame
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]
        if button then
            if not inset then
                break
            end
            button:ClearAllPoints()
            local isLeftSide
            if button.IsLeftSide ~= nil then
                isLeftSide = button.IsLeftSide
            else
                isLeftSide = i <= slotsPerSide
            end

            if i % slotsPerSide == 1 then
                if isLeftSide then
                    button:SetPoint("TOPLEFT", inset, 4, -11)
                else
                    button:SetPoint("TOPRIGHT", inset, -4, -11)
                end
            else
                button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
            end

            if isLeftSide then
                Skin.PaperDollItemSlotButtonLeftTemplate(button)
            else
                Skin.PaperDollItemSlotButtonRightTemplate(button)
            end

            prevSlot = button
        end
    end

    for i = 1, #WeaponSlots do
        local button = _G[WeaponSlots[i]]
        if button then
            button:ClearAllPoints()
            if slotW and slotH then
                button:SetSize(slotW, slotH)
            end
            if i == 1 then
                -- main hand
                if inset then
                    button:SetPoint("BOTTOMLEFT", inset, 130, 8)
                end
            else
                local mainHand = _G.CharacterMainHandSlot
                if mainHand then
                    button:SetPoint("LEFT", mainHand, "RIGHT", 4, 0)
                end
            end

            _G.select(button:GetNumRegions(), button:GetRegions()):Hide()
            Skin.PaperDollItemSlotButtonBottomTemplate(button)
        end
    end
    local CharacterRangedSlot = _G.CharacterRangedSlot
    if CharacterRangedSlot then
        Skin.PaperDollItemSlotButtonRightTemplate(CharacterRangedSlot)
    end
    local CharacterAmmoSlot = _G.CharacterAmmoSlot
    if CharacterAmmoSlot then
        Skin.PaperDollItemSlotButtonRightTemplate(CharacterAmmoSlot)
    end

    local CharacterAttributesFrame = _G.CharacterAttributesFrame
    if CharacterAttributesFrame then
        Base.StripBlizzardTextures(CharacterAttributesFrame)
    end

    for _, frameName in next, {"PlayerStatFrameLeft", "PlayerStatFrameMiddle", "PlayerStatFrameRight"} do
        local frame = _G[frameName]
        if frame then
            Base.StripBlizzardTextures(frame)
        end
    end

    local PlayerStatFrameLeftDropDown = _G.PlayerStatFrameLeftDropDown
    if PlayerStatFrameLeftDropDown then
        Skin.DropdownButton(PlayerStatFrameLeftDropDown)
    end
    local PlayerStatFrameRightDropDown = _G.PlayerStatFrameRightDropDown
    if PlayerStatFrameRightDropDown then
        Skin.DropdownButton(PlayerStatFrameRightDropDown)
    end

    if _G.PlayerStatFrameLeft then _G.PlayerStatFrameLeft:Hide() end
    if _G.PlayerStatFrameRight then _G.PlayerStatFrameRight:Hide() end
end
