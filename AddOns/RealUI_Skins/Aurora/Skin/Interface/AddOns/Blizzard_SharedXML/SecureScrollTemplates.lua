local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ SharedXML\SecureScrollTemplates.lua ]]
--end

do --[[ SharedXML\SecureScrollTemplates.xml ]]
    function Skin.UIPanelScrollBarTemplate(Slider)
        if not Slider then return end
        if Slider.ScrollUpButton and _G.ScrollControllerMixin and _G.ScrollControllerMixin.Directions then
            Slider.ScrollUpButton.direction = _G.ScrollControllerMixin.Directions.Decrease
        end
        if Slider.ScrollDownButton and _G.ScrollControllerMixin and _G.ScrollControllerMixin.Directions then
            Slider.ScrollDownButton.direction = _G.ScrollControllerMixin.Directions.Increase
        end
        Skin.FrameTypeScrollBar(Slider, true)
    end

    function Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        if not ScrollFrame then return end
        Skin.UIPanelScrollBarTemplate(ScrollFrame.ScrollBar)
    end
    function Skin.UIPanelInputScrollFrameTemplate(ScrollFrame)
        if not ScrollFrame then return end
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        Base.CreateBackdrop(ScrollFrame, {
            offsets = {
                left = -4,
                right = -4,
                top = -3,
                bottom = -4,
            }
        }, {
            bg = ScrollFrame.MiddleTex,

            l = ScrollFrame.LeftTex,
            r = ScrollFrame.RightTex,
            t = ScrollFrame.TopTex,
            b = ScrollFrame.BottomTex,

            tl = ScrollFrame.TopLeftTex,
            tr = ScrollFrame.TopRightTex,
            bl = ScrollFrame.BottomLeftTex,
            br = ScrollFrame.BottomRightTex,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Base.SetBackdrop(ScrollFrame, Color.frame)
        ScrollFrame:SetBackdropBorderColor(Color.button)
    end
    function Skin.FauxScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
    end
    function Skin.ListScrollFrameTemplate(ScrollFrame)
        if not ScrollFrame then return end
        Skin.FauxScrollFrameTemplate(ScrollFrame)
        if ScrollFrame.ScrollBarTop then ScrollFrame.ScrollBarTop:Hide() end
        if ScrollFrame.ScrollBarBottom then ScrollFrame.ScrollBarBottom:Hide() end

        local _, _, middle = ScrollFrame:GetRegions()
        if middle then
            middle:Hide()
        end
    end
end

--function private.SharedXML.SecureScrollTemplates()
--end
