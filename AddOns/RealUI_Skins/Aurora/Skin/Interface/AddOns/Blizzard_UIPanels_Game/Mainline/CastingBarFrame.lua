local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\CastingBarFrame.lua ]]
--end

do --[[ FrameXML\CastingBarFrame.xml ]]
    function Skin.CastingBarFrameTemplate(StatusBar)
        if not StatusBar then return end
        Skin.FrameTypeStatusBar(StatusBar)
        Base.SetBackdropColor(StatusBar, Color.frame)

        if StatusBar.GetRegions then
            StatusBar:GetRegions():Hide()
        end
        if StatusBar.Border then
            StatusBar.Border:Hide()
        end
        if StatusBar.Text then
            StatusBar.Text:ClearAllPoints()
            StatusBar.Text:SetPoint("CENTER")
        end
        if StatusBar.Spark then
            StatusBar.Spark:SetAlpha(0)
        end

        if StatusBar.Flash then
            StatusBar.Flash:SetAllPoints(StatusBar)
            StatusBar.Flash:SetColorTexture(1, 1, 1)
        end
    end
    function Skin.SmallCastingBarFrameTemplate(StatusBar)
        if not StatusBar then return end
        Skin.FrameTypeStatusBar(StatusBar)

        if StatusBar.GetRegions then
            StatusBar:GetRegions():Hide()
        end
        if StatusBar.Border then
            StatusBar.Border:Hide()
        end
        if StatusBar.Text then
            StatusBar.Text:ClearAllPoints()
            StatusBar.Text:SetPoint("CENTER")
        end
        if StatusBar.Spark then
            StatusBar.Spark:SetAlpha(0)
        end

        if StatusBar.Flash then
            StatusBar.Flash:SetAllPoints(StatusBar)
            StatusBar.Flash:SetColorTexture(1, 1, 1)
        end
    end
end

function private.FrameXML.CastingBarFrame()
    Skin.CastingBarFrameTemplate(_G.PlayerCastingBarFrame)
    Skin.CastingBarFrameTemplate(_G.OverlayPlayerCastingBarFrame)
end
