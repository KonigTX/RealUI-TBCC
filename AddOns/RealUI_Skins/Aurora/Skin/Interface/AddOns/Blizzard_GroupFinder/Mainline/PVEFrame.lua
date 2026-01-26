local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\PVEFrame.lua ]]
    function Hook.GroupFinderFrame_SelectGroupButton(index)
        for i = 1, 3 do
            local button = _G.GroupFinderFrame["groupButton"..i]
            if i == index then
                button.bg:Show()
            else
                button.bg:Hide()
            end
        end
    end
end

do --[[ FrameXML\PVEFrame.xml ]]
    function Skin.GroupFinderGroupButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 0,
            top = -3,
            bottom = -5,
        })

        local bg = Button:GetBackdropTexture("bg")
        Button.bg:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.bg:SetAllPoints(bg)
        Button.bg:Hide()

        Button.ring:Hide()
        Base.CropIcon(Button.icon)
    end
end

function private.FrameXML.PVEFrame()
    if _G.GroupFinderFrame_SelectGroupButton then
        _G.hooksecurefunc("GroupFinderFrame_SelectGroupButton", Hook.GroupFinderFrame_SelectGroupButton)
    end

    local PVEFrame = _G.PVEFrame
    if not PVEFrame then return end
    Skin.PortraitFrameTemplate(PVEFrame)

    if _G.PVEFrameBlueBg then _G.PVEFrameBlueBg:SetAlpha(0) end
    if _G.PVEFrameTLCorner then _G.PVEFrameTLCorner:SetAlpha(0) end
    if _G.PVEFrameTRCorner then _G.PVEFrameTRCorner:SetAlpha(0) end
    if _G.PVEFrameBRCorner then _G.PVEFrameBRCorner:SetAlpha(0) end
    if _G.PVEFrameBLCorner then _G.PVEFrameBLCorner:SetAlpha(0) end
    if _G.PVEFrameLLVert then _G.PVEFrameLLVert:SetAlpha(0) end
    if _G.PVEFrameRLVert then _G.PVEFrameRLVert:SetAlpha(0) end
    if _G.PVEFrameBottomLine then _G.PVEFrameBottomLine:SetAlpha(0) end
    if _G.PVEFrameTopLine then _G.PVEFrameTopLine:SetAlpha(0) end
    if _G.PVEFrameTopFiligree then _G.PVEFrameTopFiligree:SetAlpha(0) end
    if _G.PVEFrameBottomFiligree then _G.PVEFrameBottomFiligree:SetAlpha(0) end

    if PVEFrame.Inset then
        Skin.InsetFrameTemplate(PVEFrame.Inset)
    end
    if PVEFrame.tab1 then Skin.PanelTabButtonTemplate(PVEFrame.tab1) end
    if PVEFrame.tab2 then Skin.PanelTabButtonTemplate(PVEFrame.tab2) end
    if PVEFrame.tab3 then Skin.PanelTabButtonTemplate(PVEFrame.tab3) end
    if PVEFrame.tab4 then Skin.PanelTabButtonTemplate(PVEFrame.tab4) end
    Util.PositionRelative("TOPLEFT", PVEFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        PVEFrame.tab1,
        PVEFrame.tab2,
        PVEFrame.tab3,
        PVEFrame.tab4,
    })

    local GroupFinderFrame = _G.GroupFinderFrame
    if GroupFinderFrame and GroupFinderFrame.groupButton1 then
        Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton1)
        GroupFinderFrame.groupButton1.icon:SetTexture([[Interface\Icons\INV_Helmet_08]])
    end
    if GroupFinderFrame and GroupFinderFrame.groupButton2 then
        Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton2)
        GroupFinderFrame.groupButton2:SetPoint("LEFT", GroupFinderFrame.groupButton1)
        GroupFinderFrame.groupButton2.icon:SetTexture([[Interface\Icons\Icon_Scenarios]])
    end
    if GroupFinderFrame and GroupFinderFrame.groupButton3 then
        Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton3)
        GroupFinderFrame.groupButton3:SetPoint("LEFT", GroupFinderFrame.groupButton2)
        GroupFinderFrame.groupButton3.icon:SetTexture([[Interface\Icons\INV_Helmet_06]])
    end

    if _G.LFGListPVEStub then
        _G.LFGListPVEStub:SetWidth(339)
    end
    if PVEFrame.shadows then
        PVEFrame.shadows:SetAlpha(0)
    end
end
