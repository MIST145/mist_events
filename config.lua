Config = {}

Config.Command = 'menuropa' -- command to open the menu
Config.KeyToOpen = 'K' -- default key to open the menu

-- Sistema de configurações dinâmicas
Config.DynamicIcons = {
    -- Cada slot pode ser configurado individualmente
    slot1 = {
        icon = "fa-solid fa-shirt",
        tooltip = "Configurar Slot 1",
        eventType = nil, -- "client", "server", "command"
        event = nil, -- nome do evento ou comando
        closeMenu = true -- se deve fechar o menu após execução
    },
    slot2 = {
        icon = "fa-solid fa-tshirt",
        tooltip = "Configurar Slot 2",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot3 = {
        icon = "fa-solid fa-shoe-prints",
        tooltip = "Configurar Slot 3",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot4 = {
        icon = "fa-solid fa-gem",
        tooltip = "Configurar Slot 4",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot5 = {
        icon = "fa-solid fa-sun",
        tooltip = "Weather",
        eventType = "command",
        event = "weatherr",
        closeMenu = true
    },
    slot6 = {
        icon = "fa-regular fa-clock",
        tooltip = "Configurar Slot 6",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot7 = {
        icon = "fa-solid fa-vest",
        tooltip = "Configurar Slot 7",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot8 = {
        icon = "fa-solid fa-mitten",
        tooltip = "Configurar Slot 8",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot9 = {
        icon = "fa-solid fa-mask",
        tooltip = "Configurar Slot 9",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot10 = {
        icon = "fa-solid fa-circle",
        tooltip = "Configurar Slot 10",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot11 = {
        icon = "fa-solid fa-hat-cowboy",
        tooltip = "Configurar Slot 11",
        eventType = nil,
        event = nil,
        closeMenu = true
    },
    slot12 = {
        icon = "fa-solid fa-backpack",
        tooltip = "Configurar Slot 12",
        eventType = nil,
        event = nil,
        closeMenu = true
    }
}

-- Lista de ícones disponíveis para seleção (usando apenas ícones gratuitos do Font Awesome)
Config.AvailableIcons = {
    {name = "Camiseta", class = "fa-solid fa-shirt"},
    {name = "Roupas", class = "fa-solid fa-tshirt"},
    {name = "Sapatos", class = "fa-solid fa-shoe-prints"},
    {name = "Joias", class = "fa-solid fa-gem"},
    {name = "Óculos", class = "fa-solid fa-glasses"},
    {name = "Relógio", class = "fa-regular fa-clock"},
    {name = "Colete", class = "fa-solid fa-vest"},
    {name = "Luvas", class = "fa-solid fa-mitten"},
    {name = "Máscara", class = "fa-solid fa-mask"},
    {name = "Brincos", class = "fa-solid fa-circle"},
    {name = "Chapéu", class = "fa-solid fa-hat-cowboy"},
    {name = "Mochila", class = "fa-solid fa-backpack"},
    {name = "Carro", class = "fa-solid fa-car"},
    {name = "Casa", class = "fa-solid fa-house"},
    {name = "Dinheiro", class = "fa-solid fa-dollar-sign"},
    {name = "Telefone", class = "fa-solid fa-phone"},
    {name = "Mapa", class = "fa-solid fa-map"},
    {name = "Configurações", class = "fa-solid fa-gear"},
    {name = "Usuário", class = "fa-solid fa-user"},
    {name = "Coração", class = "fa-solid fa-heart"},
    {name = "Estrela", class = "fa-solid fa-star"},
    {name = "Escudo", class = "fa-solid fa-shield"},
    {name = "Espada", class = "fa-solid fa-sword"},
    {name = "Chave", class = "fa-solid fa-key"},
    {name = "Cadeado", class = "fa-solid fa-lock"},
    {name = "Fogo", class = "fa-solid fa-fire"},
    {name = "Raio", class = "fa-solid fa-bolt"},
    {name = "Música", class = "fa-solid fa-music"},
    {name = "Câmera", class = "fa-solid fa-camera"},
    {name = "Microfone", class = "fa-solid fa-microphone"},
    {name = "Martelo", class = "fa-solid fa-hammer"},
    {name = "Lixo", class = "fa-solid fa-trash"},
    {name = "Editar", class = "fa-solid fa-edit"},
    {name = "Salvar", class = "fa-solid fa-save"},
    {name = "Plus", class = "fa-solid fa-plus"},
    {name = "Menos", class = "fa-solid fa-minus"}
}