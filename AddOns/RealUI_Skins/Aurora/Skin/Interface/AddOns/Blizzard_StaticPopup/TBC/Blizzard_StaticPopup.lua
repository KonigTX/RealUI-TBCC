local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide all textures in a frame
local function StripTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture("")
            region:SetAlpha(0)
            region:Hide()
        end
    end
end

do -- StaticPopup templates
    function Skin.StaticPopupButtonTemplate(Button)
        if Button then
            Skin.FrameTypeButton(Button)
        end
    end

    function Skin.StaticPopupTemplate(Frame)
        if not Frame then return end
        local name = Frame:GetName()

        -- Strip textures from the frame
        StripTextures(Frame)

        -- Apply Aurora backdrop
        Base.SetBackdrop(Frame, Color.frame)

        -- Skin close button (TBC uses FrameTypeButton, not UIPanelCloseButton)
        local close = _G[name .. "CloseButton"]
        if close then
            Skin.FrameTypeButton(close)
        end

        -- Skin buttons (TBC has button1-button4 as direct children, not object properties)
        local button1 = _G[name .. "Button1"]
        local button2 = _G[name .. "Button2"]
        local button3 = _G[name .. "Button3"]
        local button4 = _G[name .. "Button4"]

        Skin.StaticPopupButtonTemplate(button1)
        Skin.StaticPopupButtonTemplate(button2)
        Skin.StaticPopupButtonTemplate(button3)
        Skin.StaticPopupButtonTemplate(button4)

        -- Skin edit box
        local EditBox = _G[name .. "EditBox"]
        if EditBox then
            -- TBC edit box has Left, Right, Middle textures as global children
            local editBoxLeft = _G[name .. "EditBoxLeft"]
            local editBoxRight = _G[name .. "EditBoxRight"]
            local editBoxMid = _G[name .. "EditBoxMid"]

            if editBoxLeft then editBoxLeft:Hide() end
            if editBoxRight then editBoxRight:Hide() end
            if editBoxMid then editBoxMid:Hide() end

            if Skin.InputBoxTemplate then
                Skin.InputBoxTemplate(EditBox)
            end
        end

        -- Skin money frame
        local moneyFrame = _G[name .. "MoneyFrame"]
        if moneyFrame and Skin.SmallMoneyFrameTemplate then
            Skin.SmallMoneyFrameTemplate(moneyFrame)
        end

        -- Skin money input frame
        local moneyInputFrame = _G[name .. "MoneyInputFrame"]
        if moneyInputFrame and Skin.MoneyInputFrameTemplate then
            Skin.MoneyInputFrameTemplate(moneyInputFrame)
        end

        -- Skin item frame
        local ItemFrame = _G[name .. "ItemFrame"]
        if ItemFrame then
            if Skin.FrameTypeItemButton then
                Skin.FrameTypeItemButton(ItemFrame)
            end

            -- Hide name frame and create custom backdrop
            local nameFrame = _G[ItemFrame:GetName() .. "NameFrame"]
            if nameFrame then
                nameFrame:Hide()
            end

            if ItemFrame.icon then
                local nameBG = _G.CreateFrame("Frame", nil, ItemFrame)
                nameBG:SetPoint("TOPLEFT", ItemFrame.icon, "TOPRIGHT", 2, 1)
                nameBG:SetPoint("BOTTOMLEFT", ItemFrame.icon, "BOTTOMRIGHT", 2, -1)
                nameBG:SetPoint("RIGHT", 120, 0)
                Base.SetBackdrop(nameBG, Color.frame)
            end
        end
    end
end

function private.FrameXML.StaticPopup()
    -- Skin the static popup frames (TBC can have up to 4)
    for i = 1, 4 do
        local popup = _G["StaticPopup" .. i]
        if popup then
            Skin.StaticPopupTemplate(popup)

            -- Hook OnShow to re-strip Blizzard textures that StaticPopup_Show re-applies
            popup:HookScript("OnShow", function(self)
                StripTextures(self)
                Base.SetBackdrop(self, Color.frame)
            end)
        end
    end
end
