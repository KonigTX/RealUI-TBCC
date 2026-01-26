local _, private = ...

-- Lua Globals --
-- luacheck: globals next

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

-- TBCC: SafeSkin wrapper for skin functions that may not exist
local function SafeSkin(skinFunc, ...)
    if skinFunc and type(skinFunc) == "function" then
        local success, err = pcall(skinFunc, ...)
        if not success then
            -- Silently fail - skin function not available in TBCC
        end
    end
end

do --[[ AddOns\Clique.lua ]]
    function Hook.CliqueConfig_SetupGUI(self)
        for _, row in next, self.rows do
            SafeSkin(Skin.CliqueRowTemplate, row)
        end
    end
    function Hook.GENERAL_CreateOptions(self)
        SafeSkin(Skin.UICheckButtonTemplate, self.updown)
        SafeSkin(Skin.UICheckButtonTemplate, self.fastooc)

        SafeSkin(Skin.UICheckButtonTemplate, self.specswap)
        for i, dropdown in next, self.talentProfiles do
            SafeSkin(Skin.DropdownButton, dropdown)
        end

        SafeSkin(Skin.DropdownButton, self.profiledd)
        SafeSkin(Skin.UICheckButtonTemplate, self.stopcastingfix)
    end
    function Hook.BLACKLIST_CreateOptions(self)
        SafeSkin(Skin.FauxScrollFrameTemplate, self.scrollframe)

        for i, checkbox in next, self.rows do
            SafeSkin(Skin.UICheckButtonTemplate, checkbox)
        end

        SafeSkin(Skin.UIPanelButtonTemplate, self.selectall)
        SafeSkin(Skin.UIPanelButtonTemplate, self.selectnone)
    end
    function Hook.BLIZZFRAMES_CreateOptions(self)
        SafeSkin(Skin.UICheckButtonTemplate, self.PlayerFrame)
        SafeSkin(Skin.UICheckButtonTemplate, self.PetFrame)
        SafeSkin(Skin.UICheckButtonTemplate, self.TargetFrame)
        SafeSkin(Skin.UICheckButtonTemplate, self.TargetFrameToT)
        SafeSkin(Skin.UICheckButtonTemplate, self.party)
        SafeSkin(Skin.UICheckButtonTemplate, self.compactraid)
        SafeSkin(Skin.UICheckButtonTemplate, self.boss)
        SafeSkin(Skin.UICheckButtonTemplate, self.FocusFrame)
        SafeSkin(Skin.UICheckButtonTemplate, self.FocusFrameToT)
        SafeSkin(Skin.UICheckButtonTemplate, self.arena)
    end
end

do --[[ AddOns\Clique.xml ]]
    function Skin.CliqueRowTemplate(Button)
        Base.CropIcon(Button.icon)

        local color = Color.highlight
        Button:GetHighlightTexture():SetColorTexture(color.r, color.g, color.b, Color.frame.a)
    end
    function Skin.CliqueColumnTemplate(Button)
        SafeSkin(Skin.WhoFrameColumnHeaderTemplate, Button)
    end
end

function private.AddOns.Clique()
    SafeSkin(Skin.SpellBookSkillLineTabTemplate, _G.CliqueSpellTab)

    local CliqueTabAlert = _G.CliqueTabAlert
    if CliqueTabAlert then
        CliqueTabAlert.Arrow = CliqueTabAlert.arrow
        CliqueTabAlert.CloseButton = CliqueTabAlert.close
        SafeSkin(Skin.GlowBoxFrame, CliqueTabAlert, "Left")
    end


    local CliqueDialog = _G.CliqueDialog
    if CliqueDialog then
        SafeSkin(Skin.BasicFrameTemplate, CliqueDialog)
        SafeSkin(Skin.UIPanelButtonTemplate, CliqueDialog.button_binding)
        SafeSkin(Skin.UIPanelButtonTemplate, CliqueDialog.button_accept)
    end


    local CliqueConfig = _G.CliqueConfig
    if CliqueConfig then
        _G.hooksecurefunc(CliqueConfig, "SetupGUI", Hook.CliqueConfig_SetupGUI)
        SafeSkin(Skin.ButtonFrameTemplate, CliqueConfig)
        SafeSkin(Skin.DropdownButton, CliqueConfig.dropdown)

        local page1 = CliqueConfig.page1
        if page1 then
            SafeSkin(Skin.CliqueColumnTemplate, page1.column1)
            SafeSkin(Skin.CliqueColumnTemplate, page1.column2)
            if page1.slider then
                page1.slider:SetBackdrop(nil)
                SafeSkin(Skin.ScrollBarThumb, _G.CliqueConfigPage1_VSliderThumbTexture)
            end
            SafeSkin(Skin.MagicButtonTemplate, page1.button_spell)
            SafeSkin(Skin.MagicButtonTemplate, page1.button_other)
            SafeSkin(Skin.MagicButtonTemplate, page1.button_options)
        end

        local page2 = CliqueConfig.page2
        if page2 then
            SafeSkin(Skin.UIPanelButtonTemplate, page2.button_binding)
            SafeSkin(Skin.MagicButtonTemplate, page2.button_save)
            SafeSkin(Skin.MagicButtonTemplate, page2.button_cancel)
        end

        if _G.CliqueConfigBindAlert then
            SafeSkin(Skin.GlowBoxTemplate, _G.CliqueConfigBindAlert)
            SafeSkin(Skin.GlowBoxArrowTemplate, _G.CliqueConfigBindAlert.arrow)
        end
    end



    local optpanels = _G.Clique and _G.Clique.optpanels
    if optpanels then
        if optpanels.GENERAL then
            _G.hooksecurefunc(optpanels.GENERAL, "CreateOptions", Hook.GENERAL_CreateOptions)
        end
        if optpanels.BLACKLIST then
            _G.hooksecurefunc(optpanels.BLACKLIST, "CreateOptions", Hook.BLACKLIST_CreateOptions)
        end
        if optpanels.BLIZZFRAMES then
            _G.hooksecurefunc(optpanels.BLIZZFRAMES, "CreateOptions", Hook.BLIZZFRAMES_CreateOptions)
        end
    end
end
