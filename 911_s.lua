local policeTimeouts = {}
local emsTimeouts = {}
local policeCalls = {}
local emsCalls = {}

ELCore.Commands.Add('100', 'Send emergancy signal to Police.', {{name = 'firstname', help = 'First Name'}, {name = 'lastname', help = 'Last Name'}, {name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = ELCore.Functions.GetPlayer(src)
	if not xPlayer.PlayerData.metadata["ishandcuffed"] then
    if policeTimeouts[src] == nil or policeTimeouts[src] == true then
        CreateThread(function()
            policeTimeouts[src] = false
            Wait(60000)
            policeTimeouts[src] = true
        end)
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id =#policeCalls+1
            policeTimeouts[src] = GetGameTimer()

            local coords = GetEntityCoords(GetPlayerPed(src))
            local name = args[1] .. ' ' .. args[2]
            
            table.remove(args, 1)
            table.remove(args, 1)
            local message = table.concat(args, ' ')

            policeCalls[id] = { name = name, message = message, source = src }

            TriggerClientEvent('el-911:client:createBlip', -1, 'police', coords, name, message, id, src)
            TriggerClientEvent('el-911:client:justcalled', src)


        else
            TriggerClientEvent('ELCore:Notify', src, "You dont have phone.", "error")
        end
    else
        TriggerClientEvent('ELCore:Notify', src, "Please wait till your next message.", "error")
		end
	else
		TriggerClientEvent('ELCore:Notify', src, "You cant do that while cuffed!", "error")
	end
end)

ELCore.Commands.Add('100r', 'Reply to 100 call. (Police Only)', {{name = 'id', help = 'Call #ID'}, {name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = ELCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == 'police' then
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id = tonumber(args[1])
            table.remove(args, 1)
            local message = table.concat(args, ' ')
            if policeCalls[id] then
                if not policeCalls[id].reply then
                    policeCalls[id].reply = true
                    TriggerClientEvent('el-911:client:justcalled', src)
                    TriggerClientEvent('el-911:client:reply', -1, 'police', id, message,xPlayer.PlayerData.charinfo.firstname:sub(1,1) .. '. ' .. xPlayer.PlayerData.charinfo.lastname, policeCalls[id].source)
                else
                    TriggerClientEvent('ELCore:Notify', src, "Message already replied.", "error")
                end
            else
                TriggerClientEvent('ELCore:Notify', src, "Invaild call #ID.", "error")
            end
        else
            TriggerClientEvent('ELCore:Notify', src, "You dont have phone.", "error")
        end
    end
end)

ELCore.Commands.Add('101', 'Send emergancy signal to EMS.', {{name = 'firstname', help = 'First Name'}, {name = 'lastname', help = 'Last Name'}, {name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = ELCore.Functions.GetPlayer(src)

    if emsTimeouts[src] == nil or emsTimeouts[src] == true then
        CreateThread(function()
            emsTimeouts[src] = false
            Wait(60000)
            emsTimeouts[src] = true
        end)
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id =#emsCalls+1
            emsTimeouts[src] = GetGameTimer()

            local coords = GetEntityCoords(GetPlayerPed(src))
            local name = args[1] .. ' ' .. args[2]

            table.remove(args, 1)
            table.remove(args, 1)
            local message = table.concat(args, ' ')

            emsCalls[id] = { name = name, message = message, source = src }

            TriggerClientEvent('el-911:client:createBlip', -1, 'ems', coords, name, message, id, src)
            TriggerClientEvent('el-911:client:justcalled', src)

        else
            TriggerClientEvent('ELCore:Notify', src, "You dont have phone.", "error")
        end
    else
        TriggerClientEvent('ELCore:Notify', src, "Please wait till your next message.", "error")
    end
end)

ELCore.Commands.Add('101r', 'Reply to 100 call. (Police Only)', {{name = 'id', help = 'Call #ID'}, {name = 'content', help = 'Message Content'}}, true, function(source, args)
    local src = source
    local xPlayer = ELCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == 'ambulance' then
        local item = xPlayer.Functions.GetItemByName('phone')
        if item ~= nil and item.amount > 0 then
            local id = tonumber(args[1])
            table.remove(args, 1)
            local message = table.concat(args, ' ')
            if emsCalls[id] then
                if not emsCalls[id].reply then
                    emsCalls[id].reply = true
                    TriggerClientEvent('el-911:client:justcalled', src)
                    TriggerClientEvent('el-911:client:reply', -1, 'ems', id, message,xPlayer.PlayerData.charinfo.firstname:sub(1,1) .. '. ' .. xPlayer.PlayerData.charinfo.lastname, emsCalls[id].source)
                else
                    TriggerClientEvent('ELCore:Notify', src, "Message already replied.", "error")
                end
            else
                TriggerClientEvent('ELCore:Notify', src, "Invaild call #ID.", "error")
            end
        else
            TriggerClientEvent('ELCore:Notify', src, "You dont have phone.", "error")
        end
    end
end)
