local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs type select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\ChatConfigFrame.lua ]]
    function Hook.ChatConfig_CreateCheckboxes(frame, checkBoxTable, checkBoxTemplate, title)
        local checkBoxNameString = frame:GetName().."Checkbox"
        local skinFunc = Skin[checkBoxTemplate]
        for index, value in ipairs(checkBoxTable) do
            local checkBoxName = checkBoxNameString..index
            if not _G[checkBoxName]._auroraSkinned then
                if skinFunc then
                    skinFunc(_G[checkBoxName])
                end
                _G[checkBoxName]._auroraSkinned = true
            end
        end
    end
    function Hook.ChatConfig_CreateTieredCheckboxes(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate, columns, spacing)
        local checkBoxNameString = frame:GetName().."Checkbox"
        local skinFunc = Skin[checkBoxTemplate]
        local subSkinFunc = Skin[subCheckBoxTemplate]

        for index, value in ipairs(checkBoxTable) do
            local checkBoxName = checkBoxNameString..index
            if skinFunc then
                skinFunc(_G[checkBoxName])
            end

            if value.subTypes then
                local subCheckBoxNameString = checkBoxName.."_"
                for i, v in ipairs(value.subTypes) do
                    if subSkinFunc then
                        subSkinFunc(_G[subCheckBoxNameString..i])
                    end
                end
            end
        end
    end
    function Hook.ChatConfig_CreateColorSwatches(frame, swatchTable, swatchTemplate, title)
        local nameString = frame:GetName().."Swatch"
        local skinFunc = Skin[swatchTemplate]

        for index, value in ipairs(swatchTable) do
            local swatchName = nameString..index
            if skinFunc then
                skinFunc(_G[swatchName])
            end
        end
    end
end

do --[[ FrameXML\ChatConfigFrame.xml ]]
    Skin.ConfigCategoryButtonTemplate = private.nop
    function Skin.ConfigFilterButtonTemplate(Button)
        Skin.ConfigCategoryButtonTemplate(Button)
    end
    function Skin.ChatConfigBoxTemplate(Frame)
        Util.HideNineSlice(Frame)
    end
    function Skin.ChatConfigBorderBoxTemplate(Frame)
        Skin.TooltipBorderBackdropTemplate(Frame)
        Frame.NineSlice:SetBackdropBorderColor(Color.button)
        Frame.NineSlice:SetBackdropOption("offsets", {
            left = 3,
            right = 2,
            top = 2,
            bottom = 2,
        })
    end
    function Skin.ChatConfigBoxWithHeaderTemplate(Frame)
        Skin.ChatConfigBoxTemplate(Frame)
    end
    function Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(Frame)
        Skin.ChatConfigBoxWithHeaderTemplate(Frame)
    end

    function Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
        Skin.UICheckButtonTemplate(CheckButton) -- BlizzWTF: Doesn't use the template
    end
    function Skin.ChatConfigCheckButtonTemplate(CheckButton)
        Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.ChatConfigSmallCheckButtonTemplate(CheckButton)
        Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
    end

    function Skin.ChatConfigCheckboxTemplate(Frame)
        Skin.ChatConfigBorderBoxTemplate(Frame)
        Skin.ChatConfigCheckButtonTemplate(Frame.CheckButton)
    end
    function Skin.ChatConfigCheckboxSmallTemplate(Frame)
        Skin.ChatConfigCheckboxTemplate(Frame)
    end
    function Skin.ChatConfigCheckboxWithSwatchTemplate(Frame)
        Skin.ChatConfigCheckboxTemplate(Frame)
        Skin.ColorSwatchTemplate(Frame.ColorSwatch)
    end
    function Skin.ChatConfigWideCheckboxWithSwatchTemplate(Frame)
        Skin.ChatConfigCheckboxWithSwatchTemplate(Frame)
    end
    function Skin.MovableChatConfigWideCheckboxWithSwatchTemplate(Frame)
        Skin.ChatConfigWideCheckboxWithSwatchTemplate(Frame)
        Frame.ArtOverlay.GrayedOut:SetPoint("TOPLEFT")
    end
    function Skin.ChatConfigSwatchTemplate(Frame)
        Skin.ChatConfigBorderBoxTemplate(Frame)
        Skin.ColorSwatchTemplate(_G[Frame:GetName().."ColorSwatch"])
    end
    function Skin.ChatConfigTabTemplate(Button)
        if Button.Left then Button.Left:Hide() end
        if Button.Right then Button.Right:Hide() end
        if Button.Middle then Button.Middle:Hide() end

        if Button.Text then
            Button.Text:SetHeight(0)
            Button.Text:SetPoint("LEFT", 0, -5)
            Button.Text:SetPoint("RIGHT", 0, -5)
        end
        local highlight = Button.GetHighlightTexture and Button:GetHighlightTexture() or nil
        if highlight then highlight:Hide() end
    end
    function Skin.ChatWindowTab(Button)
        Skin.ChatTabArtTemplate(Button)
    end


    -- not a template
    function Skin.ChatConfigMoveFilter(Button, direction)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 6,
            right = 6,
            top = 7,
            bottom = 7,
        })

        local bg = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 2, -4)
        arrow:SetSize(10, 5)

        Base.SetTexture(arrow, "arrow"..direction)
        Button._auroraTextures = {arrow}
    end
end

function private.FrameXML.ChatConfigFrame()
    _G.hooksecurefunc("ChatConfig_CreateCheckboxes", Hook.ChatConfig_CreateCheckboxes)
    _G.hooksecurefunc("ChatConfig_CreateTieredCheckboxes", Hook.ChatConfig_CreateTieredCheckboxes)
    _G.hooksecurefunc("ChatConfig_CreateColorSwatches", Hook.ChatConfig_CreateColorSwatches)

    local ChatConfigFrame = _G.ChatConfigFrame
    Skin.DialogBorderTemplate(ChatConfigFrame.Border)
    Skin.DialogHeaderTemplate(ChatConfigFrame.Header)

    Skin.ChatConfigBoxTemplate(_G.ChatConfigCategoryFrame)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton1)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton2)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton3)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton4)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton5)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton6)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton7)
    Util.Mixin(ChatConfigFrame.ChatTabManager.tabPool, Hook.ObjectPoolMixin)
    Skin.ChatConfigBoxTemplate(_G.ChatConfigBackgroundFrame)

    local divider = _G.ChatConfigFrame:CreateTexture()
    divider:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrame, "TOPRIGHT")
    divider:SetPoint("BOTTOMRIGHT", _G.ChatConfigBackgroundFrame, "BOTTOMLEFT", 0, 60)
    divider:SetColorTexture(1, 1, 1, .2)

    Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(_G.ChatConfigChatSettingsLeft)
    Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(_G.ChatConfigChannelSettingsLeft)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsCombat)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsPVP)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsSystem)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsCreature)

    -------------------------
    -- Combat Log Settings --
    -------------------------
    local Filters = _G.ChatConfigCombatSettings and _G.ChatConfigCombatSettings.Filters
    if Filters then
        Skin.ChatConfigBoxTemplate(_G.ChatConfigCombatSettingsFilters)
        Skin.WowScrollBoxList(Filters.ScrollBox)
        Skin.MinimalScrollBar(Filters.ScrollBar)
        Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersDeleteButton)
        Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersAddFilterButton)
        _G.ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -5, 0)
        Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersCopyFilterButton)
        _G.ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -5, 0)
        Skin.ChatConfigMoveFilter(_G.ChatConfigMoveFilterUpButton, "Up")
        Skin.ChatConfigMoveFilter(_G.ChatConfigMoveFilterDownButton, "Down")
        _G.ChatConfigMoveFilterDownButton:SetPoint("LEFT", _G.ChatConfigMoveFilterUpButton, "RIGHT", -5, 0)
    end

    -- MessageSources --
    if _G.CombatConfigMessageSourcesDoneBy then
        Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigMessageSourcesDoneBy)
    end
    if _G.CombatConfigMessageSourcesDoneTo then
        Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigMessageSourcesDoneTo)
    end

    -- MessageTypes --

    -- Colors --
    if _G.CombatConfigColorsUnitColors then
        Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigColorsUnitColors)
    end
    if _G.CombatConfigColorsHighlighting then
        Util.HideNineSlice(_G.CombatConfigColorsHighlighting)
    end
    if _G.CombatConfigColorsHighlightingLine then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingLine)
    end
    if _G.CombatConfigColorsHighlightingAbility then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingAbility)
    end
    if _G.CombatConfigColorsHighlightingDamage then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingDamage)
    end
    if _G.CombatConfigColorsHighlightingSchool then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingSchool)
    end

    if _G.CombatConfigColorsColorizeUnitName then
        Util.HideNineSlice(_G.CombatConfigColorsColorizeUnitName)
    end
    if _G.CombatConfigColorsColorizeUnitNameCheck then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeUnitNameCheck)
    end

    if _G.CombatConfigColorsColorizeSpellNames then
        Util.HideNineSlice(_G.CombatConfigColorsColorizeSpellNames)
    end
    if _G.CombatConfigColorsColorizeSpellNamesCheck then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeSpellNamesCheck)
    end
    if _G.CombatConfigColorsColorizeSpellNamesSchoolColoring then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsColorizeSpellNamesSchoolColoring)
    end
    if _G.CombatConfigColorsColorizeSpellNamesColorSwatch then
        Skin.ColorSwatchTemplate(_G.CombatConfigColorsColorizeSpellNamesColorSwatch)
    end

    if _G.CombatConfigColorsColorizeDamageNumber then
        Util.HideNineSlice(_G.CombatConfigColorsColorizeDamageNumber)
    end
    if _G.CombatConfigColorsColorizeDamageNumberCheck then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageNumberCheck)
    end
    if _G.CombatConfigColorsColorizeDamageNumberSchoolColoring then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageNumberSchoolColoring)
    end
    if _G.CombatConfigColorsColorizeDamageNumberColorSwatch then
        Skin.ColorSwatchTemplate(_G.CombatConfigColorsColorizeDamageNumberColorSwatch)
    end

    if _G.CombatConfigColorsColorizeDamageSchool then
        Util.HideNineSlice(_G.CombatConfigColorsColorizeDamageSchool)
    end
    if _G.CombatConfigColorsColorizeDamageSchoolCheck then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageSchoolCheck)
    end

    if _G.CombatConfigColorsColorizeEntireLine then
        Util.HideNineSlice(_G.CombatConfigColorsColorizeEntireLine)
    end
    if _G.CombatConfigColorsColorizeEntireLineCheck then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeEntireLineCheck)
    end
    if _G.CombatConfigColorsColorizeEntireLineBySource then
        Skin.UIRadioButtonTemplate(_G.CombatConfigColorsColorizeEntireLineBySource)
    end
    if _G.CombatConfigColorsColorizeEntireLineByTarget then
        Skin.UIRadioButtonTemplate(_G.CombatConfigColorsColorizeEntireLineByTarget)
    end

    -- Formatting --
    if _G.CombatConfigFormattingShowTimeStamp then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingShowTimeStamp)
    end
    if _G.CombatConfigFormattingShowBraces then
        Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingShowBraces)
    end
    if _G.CombatConfigFormattingUnitNames then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingUnitNames)
    end
    if _G.CombatConfigFormattingSpellNames then
        Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingSpellNames)
    end
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingItemNames)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingFullText)

    -- Settings --
    Skin.InputBoxTemplate(_G.CombatConfigSettingsNameEditBox)
    Skin.UIPanelButtonTemplate(_G.CombatConfigSettingsSaveButton)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigSettingsShowQuickButton)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsSolo)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsParty)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsRaid)

    for index, value in ipairs(_G.COMBAT_CONFIG_TABS) do
        Skin.ChatConfigTabTemplate(_G[_G.CHAT_CONFIG_COMBAT_TAB_NAME..index])
    end

    Skin.UIPanelButtonTemplate(ChatConfigFrame.DefaultButton)
    ChatConfigFrame.DefaultButton:SetPoint("BOTTOMLEFT", 10, 10)
    Skin.UIPanelButtonTemplate(ChatConfigFrame.RedockButton)
    ChatConfigFrame.RedockButton:SetPoint("BOTTOMLEFT", ChatConfigFrame.DefaultButton, "BOTTOMRIGHT", 5, 0)

    Skin.UIPanelButtonTemplate(_G.CombatLogDefaultButton)
    Skin.UIPanelButtonTemplate(_G.TextToSpeechDefaultButton)
    Skin.UICheckButtonTemplate(_G.TextToSpeechCharacterSpecificButton)
    _G.TextToSpeechCharacterSpecificButton:SetPoint("BOTTOMLEFT", _G.TextToSpeechDefaultButton, "BOTTOMRIGHT", 5, 0)

    --Skin.UIPanelButtonTemplate(_G.ChatConfigFrameCancelButton) -- BlizzWTF: Not used?
    Skin.UIPanelButtonTemplate(_G.ChatConfigFrameOkayButton)
    _G.ChatConfigFrameOkayButton:ClearAllPoints()
    _G.ChatConfigFrameOkayButton:SetPoint("BOTTOMRIGHT", -10, 10)
end
