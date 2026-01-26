local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next type select math ipairs
-- luacheck: globals getmetatable setmetatable tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

-- TBCC: SafeSkin wrapper for skin functions that may not exist
local function SafeSkin(skinFunc, ...)
    if skinFunc and type(skinFunc) == "function" then
        local success, err = pcall(skinFunc, ...)
        if not success then
            -- Silently fail - skin function not available in TBCC
        end
    end
end


do --[[ AddOns\DBM-GUI.lua ]]
    local frameTitle = "DBM_GUI_Option_"
    local PanelPrototype, prottypemetatable = {}
    function PanelPrototype:CreateText(text, width, autoplaced, style, justify)
        --local textblock = self:GetLastObj()
    end
    function PanelPrototype:CreateButton(title, width, height, onclick, FontObject)
        local button = self:GetLastObj()
        SafeSkin(Skin.UIPanelButtonTemplate, button)
    end
    function PanelPrototype:CreateSlider(text, low, high, step, framewidth)
        local slider = self:GetLastObj()
        SafeSkin(Skin.OptionsSliderTemplate, slider)
    end
    function PanelPrototype:CreateEditBox(text, value, width, height)
        local textbox = self:GetLastObj()
        SafeSkin(Skin.InputBoxTemplate, textbox)
    end
    function PanelPrototype:CreateLine(text)
        --local line = self:GetLastObj()
    end
    function PanelPrototype:CreateCheckButton(name, autoplace, textleft, dbmvar, dbtvar, mod, modvar, globalvar, isTimer)
        local button = self:GetLastObj()
        SafeSkin(Skin.OptionsBaseCheckButtonTemplate, button)

        if modvar then
            if not isTimer then
                local noteButton = _G[frameTitle.._G.DBM_GUI:GetCurrentID()]
                SafeSkin(Skin.UIPanelButtonTemplate, noteButton)
            end
        end
    end
    function PanelPrototype:CreateArea(name, width, height, autoplace)
        local area = self:GetLastObj()
        SafeSkin(Skin.OptionsBoxTemplate, area)
    end

    Hook.DBM_GUI_OptionsFrame = {}
    function Hook.DBM_GUI_OptionsFrame:DisplayButton(button, element)
        if element.haschilds then
            --button.toggle:SetNormalTexture("")
            button.toggle:SetPushedTexture("")
        end
    end
    function Hook.DBM_GUI_OptionsFrame:ShowTab(tab)
        local tabPrefix = self:GetName().."Tab"
        if tab == 1 then
            _G[tabPrefix..1]:SetNormalFontObject("GameFontHighlightSmall")
            _G[tabPrefix..2]:SetNormalFontObject("GameFontNormalSmall")
        else
            _G[tabPrefix..1]:SetNormalFontObject("GameFontNormalSmall")
            _G[tabPrefix..2]:SetNormalFontObject("GameFontHighlightSmall")
        end
    end

    Hook.DBM_GUI = {}
    function Hook.DBM_GUI:CreateNewPanel(FrameName, FrameTyp, showsub, sortID, DisplayName)
        if not prottypemetatable then
            prottypemetatable = getmetatable(self.panels[#self.panels])
            Util.Mixin(prottypemetatable.__index, PanelPrototype)
        end
    end

    local dropdownTitle = "DBM_GUI_DropDown"
    function Hook.DBM_GUI:CreateDropdown(title, values, vartype, var, callfunc, width, height, parent)
        local dropdown = _G[dropdownTitle..self:GetCurrentID()]
        dropdown._height = height
        Skin.DBM_UIDropDownMenuTemplate(dropdown)
    end
end

do --[[ AddOns\DBM-GUI.xml ]]
    function Skin.DBM_ExpandOrCollapse(Button)
        if Button.Left then Button.Left:SetAlpha(0) end
        if Button.Right then Button.Right:SetAlpha(0) end
        if Button.Middle then Button.Middle:SetAlpha(0) end

        SafeSkin(Skin.ExpandOrCollapse, Button)
    end
    function Skin.DBM_UIDropDownMenuTemplate(Frame)
        SafeSkin(Skin.DropdownButton, Frame)
        local name = Frame:GetName()
        local topOffset, bottomOffset = 5, 9
        if Frame._height then
            topOffset = 6
            bottomOffset = 1
        end

        Frame:SetBackdropOption("offsets", {
            left = 21,
            right = -13,
            top = topOffset,
            bottom = bottomOffset,
        })

        local Button = _G[name.."Button"]
        topOffset, bottomOffset = 4, 2
        if Frame._height then
            topOffset = 5
            bottomOffset = 1
        end
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 4,
            top = topOffset,
            bottom = bottomOffset,
        })
    end
end

private.AddOns["DBM-GUI"] = function()
    if not _G.DBM_GUI then return end
    Util.Mixin(_G.DBM_GUI, Hook.DBM_GUI)

    ----====####$$$$%%%%$$$$####====----
    --             DBM-GUI            --
    ----====####$$$$%%%%$$$$####====----
    if _G.DBM_GUI_OptionsFrame then
        Util.Mixin(_G.DBM_GUI_OptionsFrame, Hook.DBM_GUI_OptionsFrame)

        SafeSkin(Skin.FrameTypeFrame, _G.DBM_GUI_OptionsFrame)
        if _G.DBM_GUI_OptionsFrameHeader then
            _G.DBM_GUI_OptionsFrameHeader:SetTexture("")
        end

        SafeSkin(Skin.UIPanelButtonTemplate, _G.DBM_GUI_OptionsFrameOkay)
        SafeSkin(Skin.UIPanelButtonTemplate, _G.DBM_GUI_OptionsFrameWebsiteButton)
        SafeSkin(Skin.OptionsFrameTabButtonTemplate, _G.DBM_GUI_OptionsFrameTab1)
        SafeSkin(Skin.OptionsFrameTabButtonTemplate, _G.DBM_GUI_OptionsFrameTab2)

        if _G.DBM_GUI_OptionsFrameList then
            SafeSkin(Skin.OptionsFrameListTemplate, _G.DBM_GUI_OptionsFrameList)
            if _G.DBM_GUI_OptionsFrameList.buttons then
                for index, button in next, _G.DBM_GUI_OptionsFrameList.buttons do
                    if button.toggle then
                        SafeSkin(Skin.DBM_ExpandOrCollapse, button.toggle)
                    end
                end
            end
        end

        if _G.DBM_GUI_OptionsFramePanelContainer then
            Base.SetBackdrop(_G.DBM_GUI_OptionsFramePanelContainer, Color.frame)
        end
        SafeSkin(Skin.FauxScrollFrameTemplate, _G.DBM_GUI_OptionsFramePanelContainerFOV)
        if _G.DBM_GUI_OptionsFramePanelContainerFOVScrollBar then
            local scrollChild = select(3, _G.DBM_GUI_OptionsFramePanelContainerFOVScrollBar:GetChildren())
            if scrollChild then scrollChild:Hide() end
        end
    end

    local typeToTemplate = {
        --modelframe = "",
        --textblock = "",
        button = "UIPanelButtonTemplate",
        --colorselect = "",
        slider = "OptionsSliderTemplate",
        textbox = "InputBoxTemplate",
        --line = "",
        checkbutton = "OptionsBaseCheckButtonTemplate",
        area = "OptionsBoxTemplate",
    }
    local function CheckChildren(frame)
        for i = 1, frame:GetNumChildren() do
            local child = select(i, frame:GetChildren())
            if typeToTemplate[child.mytype] then
                SafeSkin(Skin[typeToTemplate[child.mytype]], child)
            elseif child.values then
                SafeSkin(Skin.DBM_UIDropDownMenuTemplate, child)
            end

            if child.mytype == "area" then
                CheckChildren(child)
            end
        end
    end

    if _G.DBM_GUI.panels then
        for index, panel in next, _G.DBM_GUI.panels do
            if panel.frame then
                CheckChildren(panel.frame)
            end
        end
    end

    ----====####$$$$%%%%$$$$####====----
    --        DBM-GUI_DropDown        --
    ----====####$$$$%%%%$$$$####====----
    if _G.DBM_GUI_DropDown then
        SafeSkin(Skin.OptionsFrameListTemplate, _G.DBM_GUI_DropDown)

        if _G.DBM_GUI_DropDown.buttons then
            for index, button in next, _G.DBM_GUI_DropDown.buttons do
                SafeSkin(Skin.UIDropDownMenuButtonTemplate, button)
            end
        end
    end
end
