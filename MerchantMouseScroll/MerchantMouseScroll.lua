local function GetMaxPages()
    return math.ceil(GetMerchantNumItems() / 10)
end

local function OnScroll(self, delta)
    if delta > 0 then
        if MerchantFrame.page and MerchantFrame.page > 1 then
            MerchantFrame.page = MerchantFrame.page - 1
            MerchantFrame_UpdateMerchantInfo()
        end
    else
        if MerchantFrame.page and MerchantFrame.page < GetMaxPages() then
            MerchantFrame.page = MerchantFrame.page + 1
            MerchantFrame_UpdateMerchantInfo()
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_CLOSED")

frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        MerchantFrame:EnableMouseWheel(true)
        MerchantFrame:SetScript("OnMouseWheel", OnScroll)
        for _, child in pairs({MerchantFrame:GetChildren()}) do
            child:EnableMouseWheel(true)
            child:SetScript("OnMouseWheel", OnScroll)
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