local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\CharacterFrame.lua ]]
--end

do --[[ FrameXML\CharacterFrame.xml ]]
    function Skin.CharacterStatFrameCategoryTemplate(Button)
        local bg = Button.Background
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:ClearAllPoints()
        bg:SetPoint("CENTER", 0, -5)
        bg:SetSize(210, 30)

        local r, g, b = Color.highlight:GetRGB()
        bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
    end
    function Skin.CharacterStatFrameTemplate(Button)
        local bg = Button.Background
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")
        bg:SetColorTexture(1, 1, 1, 0.2)
    end
    function Skin.CharacterFrameTabTemplate(Button)
        Base.StripBlizzardTextures(Button)
        Skin.PanelTabButtonTemplate(Button)
    end
end

function private.FrameXML.CharacterFrame()
    local CharacterFrame = _G.CharacterFrame
    if not CharacterFrame then return end
    Skin.ButtonFrameTemplate(CharacterFrame)
    if CharacterFrame.Bg then CharacterFrame.Bg:Hide() end
    if CharacterFrame.TitleBg then CharacterFrame.TitleBg:Hide() end
    if CharacterFrame.TopTileStreaks then CharacterFrame.TopTileStreaks:SetTexture("") end
    if CharacterFrame.PortraitFrame then CharacterFrame.PortraitFrame:SetTexture("") end
    if CharacterFrame.portrait then CharacterFrame.portrait:SetAlpha(0) end
    if _G.CharacterNameFrame then
        Base.StripBlizzardTextures(_G.CharacterNameFrame)
    end
    local function HideTexture(tex)
        if not tex then return end
        tex:SetTexture("")
        tex:Hide()
    end
    HideTexture(_G.CharacterFramePortrait)
    HideTexture(_G.CharacterFramePortraitFrame)
    HideTexture(_G.CharacterFrameTopLeftCorner)
    HideTexture(_G.CharacterFrameTopRightCorner)
    HideTexture(_G.CharacterFrameBottomLeftCorner)
    HideTexture(_G.CharacterFrameBottomRightCorner)
    HideTexture(_G.CharacterFrameTopBorder)
    HideTexture(_G.CharacterFrameBottomBorder)
    HideTexture(_G.CharacterFrameLeftBorder)
    HideTexture(_G.CharacterFrameRightBorder)

    if CharacterFrame.TitleContainer and CharacterFrame.Inset then
        CharacterFrame.TitleContainer:SetPoint("TOPRIGHT", CharacterFrame.Inset, "RIGHT")
    end
    if CharacterFrame.Inset then
        CharacterFrame.Inset:SetPoint("TOPLEFT", 4, -private.FRAME_TITLE_HEIGHT)
        if _G.PANEL_DEFAULT_WIDTH and _G.PANEL_INSET_RIGHT_OFFSET then
            CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", _G.PANEL_DEFAULT_WIDTH + _G.PANEL_INSET_RIGHT_OFFSET, 4)
        end
    end

    local tabs = {}
    local numTabs = CharacterFrame.numTabs or 0
    for i = 1, numTabs do
        local tab = _G["CharacterFrameTab"..i]
        if tab then
            Skin.CharacterFrameTabTemplate(tab)
            tabs[#tabs + 1] = tab
        end
    end
    if #tabs > 1 then
        -- TBCC needs different spacing than Retail due to tab template width differences
        local tabSpacing = private.isTBC and 4 or 0
        Util.PositionRelative("TOPLEFT", CharacterFrame, "BOTTOMLEFT", 20, -1, tabSpacing, "Right", tabs)
    end

    if CharacterFrame._stripes then
        CharacterFrame._stripes:Hide()
    end
    if CharacterFrame.Center then
        CharacterFrame.Center:Hide()
    end

    if CharacterFrame.Inset then
        Skin.InsetFrameTemplate(CharacterFrame.Inset)
        Base.StripBlizzardTextures(CharacterFrame.Inset)
    end
    if CharacterFrame.InsetRight then
        Skin.InsetFrameTemplate(CharacterFrame.InsetRight)
        Base.StripBlizzardTextures(CharacterFrame.InsetRight)
        if CharacterFrame.Inset then
            CharacterFrame.InsetRight:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPRIGHT", 1, -20)
        end
    end

    -- TBCC: Strip ALL textures from CharacterFrame regions (handles unnamed textures)
    if CharacterFrame.GetNumRegions then
        for i = 1, CharacterFrame:GetNumRegions() do
            local region = select(i, CharacterFrame:GetRegions())
            if region and region.GetObjectType and region:GetObjectType() == "Texture" then
                local tex = region.GetTexture and region:GetTexture()
                local atlas = region.GetAtlas and region:GetAtlas()
                if (type(tex) == "string" and (tex:find("Character") or tex:find("UI%-Panel")))
                    or (atlas and atlas:find("Character"))
                then
                    region:SetTexture("")
                    if region.SetAtlas then region:SetAtlas("") end
                    region:Hide()
                end
            end
        end
    end

    local CharacterStatsPane = _G.CharacterStatsPane
    if CharacterStatsPane and CharacterStatsPane.statsFramePool then
        Util.Mixin(CharacterStatsPane.statsFramePool, Hook.ObjectPoolMixin)
    end

    if CharacterStatsPane then
        local ClassBackground = CharacterStatsPane.ClassBackground
        if ClassBackground and _G.C_Texture and _G.C_Texture.GetAtlasInfo then
            local atlas = "talents-animations-class-"..private.charClass.token
            local info = _G.C_Texture.GetAtlasInfo(atlas)
            if info then
                -- C_Texture.GetAtlasInfo("talents-animations-class-warrior")
                -- C_Texture.GetAtlasInfo("legionmission-landingpage-background-EVOKER")
                ClassBackground:ClearAllPoints()
                ClassBackground:SetPoint("CENTER")
                ClassBackground:SetSize(_G.Round(info.width * 0.7), _G.Round(info.height * 0.7))
                ClassBackground:SetAtlas(atlas)
                ClassBackground:SetDesaturated(true)
                ClassBackground:SetAlpha(0.4)
            end
        end

        if CharacterStatsPane.ItemLevelFrame and CharacterStatsPane.ItemLevelFrame.Value then
            CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Shadow_Huge2")
            CharacterStatsPane.ItemLevelFrame.Value:SetShadowOffset(0, 0)
        end
        if CharacterStatsPane.ItemLevelFrame and CharacterStatsPane.ItemLevelFrame.Background then
            CharacterStatsPane.ItemLevelFrame.Background:Hide()
        end
        if CharacterStatsPane.ItemLevelCategory then
            Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
        end
        if CharacterStatsPane.AttributesCategory then
            Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
        end
        if CharacterStatsPane.EnhancementsCategory then
            Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)
        end
    end

    -- Enable frame movability (TBCC frames not movable by default)
    private.EnableFrameMovement(CharacterFrame)
end
