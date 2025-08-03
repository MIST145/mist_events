-- Server script para persistência de configurações
-- Tabela para armazenar configurações em memória (fallback)
local playerConfigs = {}

-- Verifica se MySQL está disponível
local useSQL = false
if MySQL and MySQL.Async then
    useSQL = true
    print('[mist_events] MySQL detected - using SQL persistence')
else
    print('[mist_events] MySQL not found - using memory persistence')
end

-- Evento para salvar configuração
RegisterServerEvent('dynamic_menu:saveConfig')
AddEventHandler('dynamic_menu:saveConfig', function(slotId, config)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print('[mist_events] Error: Could not get player identifier')
        return
    end
    
    print('[mist_events] Saving config for player', identifier, 'slot', slotId)
    
    -- Salva em memória sempre (fallback)
    if not playerConfigs[identifier] then
        playerConfigs[identifier] = {}
    end
    playerConfigs[identifier][slotId] = config
    
    -- Salva no SQL se disponível
    if useSQL then
        MySQL.Async.execute('INSERT INTO dynamic_menu_configs (identifier, slot_id, icon, tooltip, event_type, event, close_menu) VALUES (@identifier, @slot_id, @icon, @tooltip, @event_type, @event, @close_menu) ON DUPLICATE KEY UPDATE icon = @icon, tooltip = @tooltip, event_type = @event_type, event = @event, close_menu = @close_menu', {
            ['@identifier'] = identifier,
            ['@slot_id'] = slotId,
            ['@icon'] = config.icon,
            ['@tooltip'] = config.tooltip,
            ['@event_type'] = config.eventType,
            ['@event'] = config.event,
            ['@close_menu'] = config.closeMenu and 1 or 0
        }, function(affectedRows)
            if affectedRows then
                print('[mist_events] Config saved to database for slot', slotId)
            else
                print('[mist_events] Error saving to database for slot', slotId)
            end
        end)
    end
end)

-- Evento para carregar configurações
RegisterServerEvent('dynamic_menu:loadConfigs')
AddEventHandler('dynamic_menu:loadConfigs', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print('[mist_events] Error: Could not get player identifier for loading configs')
        return
    end
    
    print('[mist_events] Loading configs for player', identifier)
    
    if useSQL then
        -- Carrega do SQL
        MySQL.Async.fetchAll('SELECT * FROM dynamic_menu_configs WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(results)
            local configs = {}
            
            if results then
                for i = 1, #results do
                    local row = results[i]
                    configs[row.slot_id] = {
                        icon = row.icon,
                        tooltip = row.tooltip,
                        eventType = row.event_type,
                        event = row.event,
                        closeMenu = row.close_menu == 1
                    }
                end
                print('[mist_events] Loaded', #results, 'configs from database')
            else
                print('[mist_events] No configs found in database')
            end
            
            -- Atualiza cache em memória
            playerConfigs[identifier] = configs
            
            TriggerClientEvent('dynamic_menu:configsLoaded', source, configs)
        end)
    else
        -- Carrega da memória
        local configs = playerConfigs[identifier] or {}
        print('[mist_events] Loaded configs from memory')
        TriggerClientEvent('dynamic_menu:configsLoaded', source, configs)
    end
end)

-- Evento para remover configuração
RegisterServerEvent('dynamic_menu:removeConfig')
AddEventHandler('dynamic_menu:removeConfig', function(slotId)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        print('[mist_events] Error: Could not get player identifier for removing config')
        return
    end
    
    print('[mist_events] Removing config for player', identifier, 'slot', slotId)
    
    -- Remove da memória
    if playerConfigs[identifier] then
        playerConfigs[identifier][slotId] = nil
    end
    
    -- Remove do SQL se disponível
    if useSQL then
        MySQL.Async.execute('DELETE FROM dynamic_menu_configs WHERE identifier = @identifier AND slot_id = @slot_id', {
            ['@identifier'] = identifier,
            ['@slot_id'] = slotId
        }, function(affectedRows)
            if affectedRows and affectedRows > 0 then
                print('[mist_events] Config removed from database for slot', slotId)
            else
                print('[mist_events] No config found in database for slot', slotId)
            end
        end)
    end
end)

-- Evento quando jogador sai (limpa cache de memória para economizar RAM)
AddEventHandler('playerDropped', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if identifier and playerConfigs[identifier] then
        playerConfigs[identifier] = nil
        print('[mist_events] Cleared memory cache for player', identifier)
    end
end)

-- Debug: mostrar quando o script carrega
print('[mist_events] Server script loaded successfully')

-- Comando para admin testar a tabela (remover em produção)
RegisterCommand('testmenu_db', function(source, args)
    if source == 0 then -- Console apenas
        if useSQL then
            MySQL.Async.fetchAll('SELECT COUNT(*) as total FROM dynamic_menu_configs', {}, function(result)
                if result and result[1] then
                    print('[mist_events] Total configs in database:', result[1].total)
                else
                    print('[mist_events] Error querying database')
                end
            end)
        else
            local total = 0
            for identifier, configs in pairs(playerConfigs) do
                for slotId, config in pairs(configs) do
                    total = total + 1
                end
            end
            print('[mist_events] Total configs in memory:', total)
        end
    end
end, true)