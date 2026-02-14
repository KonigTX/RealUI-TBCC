local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide ONLY border/background textures, preserving icons
local function StripBorderTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            local texturePath = region:GetTexture()
            -- Only hide border/background textures, not icons
            -- GetTexture() can return a string path or numeric file ID
            -- Numeric IDs are usually icons, so skip them
            if texturePath and type(texturePath) == "string" and (
                texturePath:find("Border") or
                texturePath:find("Background") or
                texturePath:find("Edge") or
                texturePath:find("Corner") or
                texturePath:find("DialogFrame") or
                texturePath:find("UI%-Panel")
            ) then
                region:SetTexture("")
                region:SetAlpha(0)
            end
        end
    end
end

function private.FrameXML.GroupLootFrame()
    -- Skin all 4 GroupLootFrame instances
    for i = 1, 4 do
        local frame = _G["GroupLootFrame"..i]
        if not frame then break end

        -- Only strip border textures, preserve everything else
        StripBorderTextures(frame)

        -- Hide specific named border elements only
        local border = frame.Border or _G["GroupLootFrame"..i.."Border"]
        if border then
            border:SetAlpha(0)
        end

        -- Apply Aurora backdrop
        Base.SetBackdrop(frame, Color.frame)

        -- DO NOT strip the IconFrame - it contains the item icon!
        -- Just make sure it's styled nicely
        local iconFrame = frame.IconFrame or _G["GroupLootFrame"..i.."IconFrame"]
        if iconFrame then
            -- Only add a subtle border, don't strip textures
            if iconFrame.SetBackdrop then
                iconFrame:SetBackdrop({
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = 1,
                })
                iconFrame:SetBackdropBorderColor(0, 0, 0)
            end
        end

        -- Style the timer bar if it exists
        local timer = frame.Timer or _G["GroupLootFrame"..i.."Timer"]
        if timer then
            -- Don't hide it, just make sure it's visible
            timer:SetAlpha(1)
        end

        -- Make sure roll buttons preserve their icons
        -- The icons are part of the button, so we just add a backdrop
        for _, buttonName in ipairs({"NeedButton", "GreedButton", "DisenchantButton", "PassButton"}) do
            local button = frame[buttonName] or _G["GroupLootFrame"..i..buttonName]
            if button then
                -- Don't call Skin.FrameTypeButton as it might strip textures
                -- Just ensure the button is clickable and visible
                if button.SetBackdrop then
                    button:SetBackdrop({
                        edgeFile = "Interface\\Buttons\\WHITE8x8",
                        edgeSize = 1,
                    })
                    button:SetBackdropBorderColor(0.3, 0.3, 0.3)
                end
            end
        end

        -- Make sure the name/slot text is visible and white
        local name = frame.Name or _G["GroupLootFrame"..i.."Name"]
        if name and name.SetTextColor then
            name:SetTextColor(1, 1, 1)
        end

        local slot = frame.Slot or _G["GroupLootFrame"..i.."Slot"]
        if slot and slot.SetTextColor then
            slot:SetTextColor(0.8, 0.8, 0.8)
        end
    end
end
