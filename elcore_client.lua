ELCore = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) -- 
        if ELCore == nil then
            TriggerEvent('ELCore:GetObject', function(obj) ELCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
