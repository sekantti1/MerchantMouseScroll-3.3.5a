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
local scrollBinder = CreateFrame("Frame")
scrollBinder:Hide()

scrollBinder:SetScript("OnUpdate", function(self)
    -- Instantly drop bindings if combat starts to prevent action blocking
    if InCombatLockdown() then 
        if self.isBound then
            ClearOverrideBindings(self)
            self.isBound = false
        end
        return 
    end

    -- Check if the mouse is currently hovering over the Spellbook or any of its children
    local focus = GetMouseFocus()
    local isOver = false
    
    if focus then
        local current = focus
        while current do
            if current == SpellBookFrame then
                isOver = true
                break
            end
            current = current:GetParent()
        end
    end
    
    -- Apply secure bindings when hovering over the frame
    if isOver and not self.isBound then
        SetOverrideBindingClick(self, true, "MOUSEWHEELUP", "SpellBookPrevPageButton")
        SetOverrideBindingClick(self, true, "MOUSEWHEELDOWN", "SpellBookNextPageButton")
        self.isBound = true
        
    -- Clear bindings when mouse leaves the frame so standard scrolling works again
    elseif not isOver and self.isBound then
        ClearOverrideBindings(self)
        self.isBound = false
    end
end)

-- Only run the update tracker when the Spellbook is actually open
SpellBookFrame:HookScript("OnShow", function()
    scrollBinder:Show()
end)

SpellBookFrame:HookScript("OnHide", function()
    scrollBinder:Hide()
    if scrollBinder.isBound and not InCombatLockdown() then
        ClearOverrideBindings(scrollBinder)
        scrollBinder.isBound = false
    end
end)