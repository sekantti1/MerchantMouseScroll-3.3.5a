-- ==========================================
-- MERCHANT SCROLLING
-- ==========================================
local function GetMaxMerchantPages()
    return math.ceil(GetMerchantNumItems() / 10)
end

local function OnMerchantScroll(self, delta)
    if delta > 0 then
        if MerchantFrame.page and MerchantFrame.page > 1 then
            MerchantFrame.page = MerchantFrame.page - 1
            MerchantFrame_UpdateMerchantInfo()
        end
    else
        if MerchantFrame.page and MerchantFrame.page < GetMaxMerchantPages() then
            MerchantFrame.page = MerchantFrame.page + 1
            MerchantFrame_UpdateMerchantInfo()
        end
    end
end

local merchantEventFrame = CreateFrame("Frame")
merchantEventFrame:RegisterEvent("MERCHANT_SHOW")
merchantEventFrame:RegisterEvent("MERCHANT_CLOSED")

merchantEventFrame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        MerchantFrame:EnableMouseWheel(true)
        MerchantFrame:SetScript("OnMouseWheel", OnMerchantScroll)
        for _, child in pairs({MerchantFrame:GetChildren()}) do
            child:EnableMouseWheel(true)
            child:SetScript("OnMouseWheel", OnMerchantScroll)
        end
    elseif event == "MERCHANT_CLOSED" then
        MerchantFrame:SetScript("OnMouseWheel", nil)
        MerchantFrame:EnableMouseWheel(false)
        for _, child in pairs({MerchantFrame:GetChildren()}) do
            child:SetScript("OnMouseWheel", nil)
            child:EnableMouseWheel(false)
        end
    end
end)

-- ==========================================
-- SPELLBOOK SCROLLING
-- ==========================================
local function OnSpellBookScroll(self, delta)
    if delta > 0 then
        -- Scroll Up -> Previous Page
        if SpellBookPrevPageButton and SpellBookPrevPageButton:IsEnabled() == 1 then
            SpellBookPrevPageButton:Click()
        end
    else
        -- Scroll Down -> Next Page
        if SpellBookNextPageButton and SpellBookNextPageButton:IsEnabled() == 1 then
            SpellBookNextPageButton:Click()
        end
    end
end

-- SpellBookFrame is a persistent UI frame, so we can hook its OnShow and OnHide scripts directly
SpellBookFrame:HookScript("OnShow", function()
    SpellBookFrame:EnableMouseWheel(true)
    SpellBookFrame:SetScript("OnMouseWheel", OnSpellBookScroll)
    
    for _, child in pairs({SpellBookFrame:GetChildren()}) do
        -- Only apply if the child doesn't already have its own mouse wheel script
        if not child:GetScript("OnMouseWheel") then
            child:EnableMouseWheel(true)
            child:SetScript("OnMouseWheel", OnSpellBookScroll)
        end
    end
end)

SpellBookFrame:HookScript("OnHide", function()
    SpellBookFrame:SetScript("OnMouseWheel", nil)
    SpellBookFrame:EnableMouseWheel(false)
    
    for _, child in pairs({SpellBookFrame:GetChildren()}) do
        if child:GetScript("OnMouseWheel") == OnSpellBookScroll then
            child:SetScript("OnMouseWheel", nil)
            child:EnableMouseWheel(false)
        end
    end
end)
