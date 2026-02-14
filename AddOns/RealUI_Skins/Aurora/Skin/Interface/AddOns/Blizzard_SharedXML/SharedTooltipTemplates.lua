local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style, embedded)
        if self:IsForbidden() then return end
        if not (embedded or self.IsEmbedded) then
            if self.NineSlice then
                local r, g, b = Color.frame:GetRGB()
                local a = Util.GetFrameAlpha()
                self.NineSlice:SetCenterColor(r, g, b, a);
            end
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        if GameTooltip.NineSlice then
            if GameTooltip.debug then
                GameTooltip.NineSlice.debug = GameTooltip.debug
            end
            if Skin.NineSlicePanelTemplate then
                Skin.NineSlicePanelTemplate(GameTooltip.NineSlice)
            end
        end
    end
    function Skin.SharedNoHeaderTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end

    function Skin.TooltipBackdropTemplate(Frame)
        if not Frame then return end

        -- TBC: Use NineSlice if available (Retail), otherwise use SetBackdrop (TBC)
        if Frame.NineSlice and Skin.NineSlicePanelTemplate then
            if Frame.debug then
                Frame.NineSlice.debug = Frame.debug
            end
            Skin.NineSlicePanelTemplate(Frame.NineSlice)
        else
            -- TBC fallback: Apply backdrop directly
            local Base = Aurora.Base
            if Base and Base.SetBackdrop then
                Base.SetBackdrop(Frame, Color.frame)
            end
        end

        local r, g, b = Color.frame:GetRGB()
        if Frame.SetBackdropColor then
            Frame:SetBackdropColor(r, g, b, Frame.backdropColorAlpha or 1)
        end
    end

    function Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end

    function Skin.TooltipBorderedFrameTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end

end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    if _G.SharedTooltip_SetBackdropStyle then
        _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
    end
end
