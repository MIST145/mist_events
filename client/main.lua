local opened = false
local configMode = false
local currentSlot = nil

-- Tabela para armazenar configurações (persistência em memória)
local savedConfigs = {}

RegisterCommand(Config.Command, function()
    if not opened then
        opened = true
        -- Carrega configurações salvas antes de mostrar a interface
        LoadSavedConfigurations()
        
        SendNUIMessage({
            action = 'show',
            configs = Config.DynamicIcons,
            availableIcons = Config.AvailableIcons
        })

        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        StartLoopControls()
    end
end, false)

RegisterKeyMapping(Config.Command, 'Open Dynamic Menu', 'keyboard', Config.KeyToOpen)

function StartLoopControls()
    CreateThread(function()
        while opened do
            Wait(0)
            DisableControlAction(0, 1, true) -- disable mouse look
            DisableControlAction(0, 2, true) -- disable mouse look
            DisableControlAction(0, 3, true) -- disable mouse look
            DisableControlAction(0, 4, true) -- disable mouse look
            DisableControlAction(0, 5, true) -- disable mouse look
            DisableControlAction(0, 6, true) -- disable mouse look
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 177, true) -- disable escape
            DisableControlAction(0, 200, true) -- disable escape
            DisableControlAction(0, 202, true) -- disable escape
            DisableControlAction(0, 322, true) -- disable escape
            DisableControlAction(0, 245, true) -- disable chat
            DisableControlAction(0, 37, true) -- disable TAB
            DisableControlAction(0, 261, true) -- disable mouse wheel
            DisableControlAction(0, 262, true) -- disable mouse wheel
            HideHudComponentThisFrame(19)
            DisablePlayerFiring(PlayerId(), true) -- disable weapon firing
        end
    end)
end

RegisterNUICallback('close', function()
    print('[mist_events] NUI Callback: close')
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
    opened = false
    configMode = false
    currentSlot = nil
end)

-- Callback para quando um slot é clicado
RegisterNUICallback('slotClicked', function(data, cb)
    print('[mist_events] NUI Callback: slotClicked', json.encode(data))
    local slotId = data.slot
    local slotConfig = Config.DynamicIcons[slotId]
    
    if not slotConfig then
        print('[mist_events] Error: Slot config not found for', slotId)
        cb('error')
        return
    end
    
    -- Se o slot não tem configuração, abre o menu de configuração
    if not slotConfig.eventType or not slotConfig.event then
        print('[mist_events] Opening config for slot', slotId)
        currentSlot = slotId
        configMode = true
        
        SendNUIMessage({
            action = 'showConfig',
            slot = slotId,
            currentConfig = slotConfig,
            availableIcons = Config.AvailableIcons
        })
    else
        -- Executa a ação configurada
        print('[mist_events] Executing action for slot', slotId)
        ExecuteSlotAction(slotConfig)
    end
    
    cb('ok')
end)

-- Callback para salvar configuração de um slot
RegisterNUICallback('saveSlotConfig', function(data, cb)
    print('[mist_events] NUI Callback: saveSlotConfig', json.encode(data))
    local slotId = data.slot
    local newConfig = data.config
    
    if not Config.DynamicIcons[slotId] then
        print('[mist_events] Error: Slot not found for saveSlotConfig', slotId)
        cb('error')
        return
    end
    
    -- Atualiza a configuração
    Config.DynamicIcons[slotId].icon = newConfig.icon
    Config.DynamicIcons[slotId].tooltip = newConfig.tooltip
    Config.DynamicIcons[slotId].eventType = newConfig.eventType
    Config.DynamicIcons[slotId].event = newConfig.event
    Config.DynamicIcons[slotId].closeMenu = newConfig.closeMenu
    
    -- Salva na persistência
    SaveConfiguration(slotId, Config.DynamicIcons[slotId])
    
    -- Atualiza a interface
    SendNUIMessage({
        action = 'updateSlot',
        slot = slotId,
        config = Config.DynamicIcons[slotId]
    })
    
    -- Sai do modo de configuração
    configMode = false
    currentSlot = nil
    
    print('[mist_events] Slot', slotId, 'configured successfully')
    cb('ok')
end)

-- Callback para voltar ao menu principal
RegisterNUICallback('backToMain', function(data, cb)
    print('[mist_events] NUI Callback: backToMain')
    configMode = false
    currentSlot = nil
    
    SendNUIMessage({
        action = 'hideConfig'
    })
    
    cb('ok')
end)

-- Callback para resetar um slot
RegisterNUICallback('resetSlot', function(data, cb)
    print('[mist_events] NUI Callback: resetSlot', json.encode(data))
    local slotId = data.slot
    
    if not Config.DynamicIcons[slotId] then
        print('[mist_events] Error: Slot not found for resetSlot', slotId)
        cb('error')
        return
    end
    
    -- Reseta para configuração padrão
    Config.DynamicIcons[slotId].eventType = nil
    Config.DynamicIcons[slotId].event = nil
    Config.DynamicIcons[slotId].closeMenu = true
    
    -- Remove da persistência
    RemoveConfiguration(slotId)
    
    -- Atualiza a interface
    SendNUIMessage({
        action = 'updateSlot',
        slot = slotId,
        config = Config.DynamicIcons[slotId]
    })
    
    print('[mist_events] Slot', slotId, 'reset successfully')
    cb('ok')
end)

-- Função para executar a ação de um slot
function ExecuteSlotAction(slotConfig)
    if not slotConfig.eventType or not slotConfig.event then
        return
    end
    
    print('[mist_events] Executing action:', slotConfig.eventType, slotConfig.event)
    
    if slotConfig.eventType == 'client' then
        -- Dispara evento do cliente
        TriggerEvent(slotConfig.event)
    elseif slotConfig.eventType == 'server' then
        -- Dispara evento do servidor
        TriggerServerEvent(slotConfig.event)
    elseif slotConfig.eventType == 'command' then
        -- Executa comando
        ExecuteCommand(slotConfig.event)
    end
    
    -- Fecha o menu se configurado para tal
    if slotConfig.closeMenu then
        SendNUIMessage({
            action = 'hide'
        })
        SetNuiFocus(false, false)
        opened = false
        configMode = false
        currentSlot = nil
    end
end

-- Sistema de persistência usando servidor
function SaveConfiguration(slotId, config)
    savedConfigs[slotId] = {
        icon = config.icon,
        tooltip = config.tooltip,
        eventType = config.eventType,
        event = config.event,
        closeMenu = config.closeMenu
    }
    
    print('[mist_events] Configuration saved for slot', slotId)
    -- Envia para o servidor para persistência
    TriggerServerEvent('dynamic_menu:saveConfig', slotId, savedConfigs[slotId])
end

function LoadSavedConfigurations()
    print('[mist_events] Loading saved configurations')
    -- Solicita configurações do servidor
    TriggerServerEvent('dynamic_menu:loadConfigs')
end

function RemoveConfiguration(slotId)
    savedConfigs[slotId] = nil
    print('[mist_events] Configuration removed for slot', slotId)
    
    -- Envia para o servidor para remoção
    TriggerServerEvent('dynamic_menu:removeConfig', slotId)
end

-- Eventos para sincronização com servidor
RegisterNetEvent('dynamic_menu:configsLoaded')
AddEventHandler('dynamic_menu:configsLoaded', function(configs)
    print('[mist_events] Received configs from server:', json.encode(configs))
    savedConfigs = configs or {}
    
    -- Aplica configurações carregadas
    for slotId, config in pairs(savedConfigs) do
        if Config.DynamicIcons[slotId] then
            Config.DynamicIcons[slotId].icon = config.icon
            Config.DynamicIcons[slotId].tooltip = config.tooltip
            Config.DynamicIcons[slotId].eventType = config.eventType
            Config.DynamicIcons[slotId].event = config.event
            Config.DynamicIcons[slotId].closeMenu = config.closeMenu
        end
    end
end)

-- Debug: mostrar quando o script carrega
print('[mist_events] Client script loaded successfully')