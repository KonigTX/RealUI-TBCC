local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\MoneyFrame.lua ]]
    local numCurrencies = 0
    function Hook.MerchantFrame_UpdateCurrencies()
        for i = numCurrencies + 1, _G.MAX_MERCHANT_CURRENCIES do
            local button = _G["MerchantToken"..i]
            if button then
                Skin.BackpackTokenTemplate(button)
                numCurrencies = numCurrencies + 1
            end
        end
    end
end

do --[[ FrameXML\MerchantFrame.xml ]]
    function Skin.MerchantItemTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."SlotTexture"]:Hide()
        _G[name.."NameFrame"]:Hide()

        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetPoint("TOPLEFT", Frame.ItemButton.icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", 0, -4)
        Base.SetBackdrop(bg, Color.frame)

        Frame.Name:ClearAllPoints()
        Frame.Name:SetPoint("TOPLEFT", bg, 2, -1)
        Frame.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)

        Skin.FrameTypeItemButton(Frame.ItemButton)
        Skin.SmallAlternateCurrencyFrameTemplate(_G[name.."AltCurrencyFrame"])
    end
end

function private.FrameXML.MerchantFrame()
    _G.hooksecurefunc("MerchantFrame_UpdateCurrencies", Hook.MerchantFrame_UpdateCurrencies)

    Skin.ButtonFrameTemplate(_G.MerchantFrame)
    _G.BuybackBG:SetPoint("TOPLEFT")
    _G.BuybackBG:SetPoint("BOTTOMRIGHT")

    _G.MerchantFrameBottomLeftBorder:SetAlpha(0)

    -- if not private.isPatch then
    --     _G.MerchantFrameBottomRightBorder:SetAlpha(0)
    -- end

    for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
        local item = _G["MerchantItem"..i]
        if item then
            Skin.MerchantItemTemplate(item)
        end
    end

    -- if private.isPatch then
        if _G.MerchantSellAllJunkButton then
            _G.MerchantSellAllJunkButton:ClearPushedTexture()
            Base.CropIcon(_G.MerchantSellAllJunkButton.Icon, _G.MerchantSellAllJunkButton)
        end

        if _G.MerchantRepairAllButton then
            _G.MerchantRepairAllButton:ClearPushedTexture()
            Base.CropIcon(_G.MerchantRepairAllButton.Icon, _G.MerchantRepairAllButton)
        end

        if _G.MerchantRepairItemButton then
            _G.MerchantRepairItemButton:ClearPushedTexture()
            Base.CropIcon(_G.MerchantRepairItemButton.Icon, _G.MerchantRepairItemButton)
        end

        if _G.MerchantGuildBankRepairButton then
            _G.MerchantGuildBankRepairButton:ClearPushedTexture()
            Base.CropIcon(_G.MerchantGuildBankRepairButton.Icon, _G.MerchantGuildBankRepairButton)
        end
    -- else
    --     _G.MerchantRepairAllButton:ClearPushedTexture()
    --     _G.MerchantRepairAllIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
    --     Base.CropIcon(_G.MerchantRepairAllIcon, _G.MerchantRepairAllButton)

    --     local repairItem = _G.MerchantRepairItemButton:GetRegions()
    --     _G.MerchantRepairItemButton:ClearPushedTexture()
    --     repairItem:SetTexture([[Interface\Icons\INV_Hammer_20]])
    --     Base.CropIcon(repairItem, _G.MerchantRepairItemButton)

    --     _G.MerchantGuildBankRepairButton:ClearPushedTexture()
    --     _G.MerchantGuildBankRepairButtonIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
    --     _G.MerchantGuildBankRepairButtonIcon:SetVertexColor(0.9, 0.8, 0)
    --     Base.CropIcon(_G.MerchantGuildBankRepairButtonIcon, _G.MerchantGuildBankRepairButton)
    -- end

    do
        local buyback = _G.MerchantBuyBackItem
        if not buyback then return end
        local name = buyback:GetName()
        if name then
            local slotTexture = _G[name.."SlotTexture"]
            if slotTexture then slotTexture:Hide() end
            local nameFrame = _G[name.."NameFrame"]
            if nameFrame then nameFrame:Hide() end
        end

        local bg = _G.CreateFrame("Frame", nil, buyback)
        if buyback.ItemButton and buyback.ItemButton.icon then
            bg:SetPoint("TOPLEFT", buyback.ItemButton.icon, "TOPRIGHT", 2, 1)
        end
        bg:SetPoint("BOTTOMRIGHT", 0, -1)
        Base.SetBackdrop(bg, Color.frame)

        if buyback.Name then
            buyback.Name:ClearAllPoints()
            buyback.Name:SetPoint("TOPLEFT", bg, 2, -1)
            buyback.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)
        end

        if buyback.ItemButton then
            Skin.FrameTypeItemButton(buyback.ItemButton)
        end
        if name then
            local moneyFrame = _G[name.."MoneyFrame"]
            if moneyFrame then moneyFrame:SetPoint("BOTTOMLEFT", bg, 1, 1) end
        end
    end

    if _G.MerchantExtraCurrencyInset then _G.MerchantExtraCurrencyInset:SetAlpha(0) end
    if _G.MerchantExtraCurrencyBg then
        Skin.ThinGoldEdgeTemplate(_G.MerchantExtraCurrencyBg)
    end
    if _G.MerchantMoneyInset then _G.MerchantMoneyInset:Hide() end
    if _G.MerchantMoneyBg then
        Skin.ThinGoldEdgeTemplate(_G.MerchantMoneyBg)
        _G.MerchantMoneyBg:ClearAllPoints()
        _G.MerchantMoneyBg:SetPoint("BOTTOMRIGHT", _G.MerchantFrame, -5, 5)
        _G.MerchantMoneyBg:SetSize(160, 22)
    end
    if _G.MerchantMoneyFrame then
        Skin.SmallMoneyFrameTemplate(_G.MerchantMoneyFrame)
        if _G.MerchantMoneyBg then
            _G.MerchantMoneyFrame:SetPoint("BOTTOMRIGHT", _G.MerchantMoneyBg, 7, 5)
        end
    end

    for i, delta in _G.next, {"PrevPageButton", "NextPageButton"} do
        local button = _G["Merchant"..delta]
        if button then
            button:ClearAllPoints()

            local label, bg = button:GetRegions()
            if bg then bg:Hide() end
            if i == 1 then
                Skin.NavButtonPrevious(button)
                button:SetPoint("BOTTOMLEFT", 16, 82)
                if label then
                    label:SetPoint("LEFT", button, "RIGHT", 3, 0)
                end
            else
                Skin.NavButtonNext(button)
                button:SetPoint("BOTTOMRIGHT", -16, 82)
                if label then
                    label:SetPoint("RIGHT", button, "LEFT", -3, 0)
                end
            end
        end
    end

    if _G.MerchantFrameTab1 then
        Skin.PanelTabButtonTemplate(_G.MerchantFrameTab1)
    end
    if _G.MerchantFrameTab2 then
        Skin.PanelTabButtonTemplate(_G.MerchantFrameTab2)
    end
    if _G.MerchantFrameTab1 and _G.MerchantFrameTab2 then
        Util.PositionRelative("TOPLEFT", _G.MerchantFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
            _G.MerchantFrameTab1,
            _G.MerchantFrameTab2,
        })
    end

    if _G.MerchantFrame and _G.MerchantFrame.FilterDropdown then
        Skin.DropdownButton(_G.MerchantFrame.FilterDropdown)
    end
end
