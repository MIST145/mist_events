$(function() {
    let currentConfigs = {};
    let availableIcons = [];
    let currentSlot = null;
    let selectedIcon = null;

    console.log('Dynamic menu script loaded successfully');

    // Escuta mensagens do cliente Lua
    window.addEventListener('message', function(event) {
        const item = event.data;
        console.log('Received message:', item.action);
        
        switch (item.action) {
            case 'show':
                currentConfigs = item.configs || {};
                availableIcons = item.availableIcons || [];
                generateMainMenu();
                $('.main-menu').fadeIn(500);
                break;

            case 'hide':
                $('.main-menu, .config-menu').fadeOut(500);
                break;

            case 'showConfig':
                currentSlot = item.slot;
                setupConfigMenu(item.slot, item.currentConfig);
                $('.main-menu').hide();
                $('.config-menu').fadeIn(500);
                break;

            case 'hideConfig':
                $('.config-menu').hide();
                $('.main-menu').fadeIn(500);
                currentSlot = null;
                break;

            case 'updateSlot':
                updateSlotInMainMenu(item.slot, item.config);
                break;
        }
    });

    // Gera o menu principal dinamicamente
    function generateMainMenu() {
        const itemsContainer = $('#mainItems');
        itemsContainer.empty();

        Object.keys(currentConfigs).forEach(slotId => {
            const config = currentConfigs[slotId];
            const isConfigured = config.eventType && config.event;
            
            const item = $(`
                <div class='item ${isConfigured ? 'configured' : 'unconfigured'}' 
                     data-slot='${slotId}' 
                     title="${config.tooltip || 'Clique para configurar'}">
                    <i class="${config.icon}"></i>
                </div>
            `);
            
            itemsContainer.append(item);
        });

        console.log('Main menu generated with', Object.keys(currentConfigs).length, 'slots');
    }

    // Atualiza um slot específico no menu principal
    function updateSlotInMainMenu(slotId, config) {
        const item = $(`.item[data-slot='${slotId}']`);
        if (item.length) {
            const isConfigured = config.eventType && config.event;
            
            item.removeClass('configured unconfigured')
                .addClass(isConfigured ? 'configured' : 'unconfigured');
            
            item.find('i').attr('class', config.icon);
            item.attr('title', config.tooltip || 'Clique para configurar');
        }
        
        currentConfigs[slotId] = config;
    }

    // Configura o menu de configuração
    function setupConfigMenu(slotId, currentConfig) {
        selectedIcon = currentConfig.icon;
        
        generateIconGrid();
        
        $('#tooltipInput').val(currentConfig.tooltip || '');
        $('#eventTypeSelect').val(currentConfig.eventType || '');
        $('#eventInput').val(currentConfig.event || '');
        $('#closeMenuCheck').prop('checked', currentConfig.closeMenu !== false);
        
        updateEventLabels(currentConfig.eventType);
        
        setTimeout(() => {
            $(`.icon-option[data-icon='${selectedIcon}']`).addClass('selected');
        }, 100);
    }

    // Gera a grade de ícones disponíveis
    function generateIconGrid() {
        const iconGrid = $('#iconGrid');
        iconGrid.empty();

        availableIcons.forEach(iconData => {
            const iconOption = $(`
                <div class='icon-option' data-icon='${iconData.class}' title='${iconData.name}'>
                    <i class='${iconData.class}'></i>
                </div>
            `);
            
            iconGrid.append(iconOption);
        });
    }

    // Atualiza labels baseado no tipo de evento
    function updateEventLabels(eventType) {
        const label = $('#eventLabel');
        const help = $('#eventHelp');
        const input = $('#eventInput');
        
        switch(eventType) {
            case 'client':
                label.text('Nome do Evento Cliente:');
                help.text('Digite o nome do evento que será disparado no cliente. Exemplo: "openInventory"');
                input.attr('placeholder', 'nomeDoEvento');
                break;
            case 'server':
                label.text('Nome do Evento Servidor:');
                help.text('Digite o nome do evento que será enviado ao servidor. Exemplo: "giveItem"');
                input.attr('placeholder', 'nomeDoEventoServidor');
                break;
            case 'command':
                label.text('Comando:');
                help.text('Digite o comando sem a barra "/". Exemplo: "me olá" em vez de "/me olá"');
                input.attr('placeholder', 'nomeDoComando');
                break;
            default:
                label.text('Evento/Comando:');
                help.text('Selecione primeiro o tipo de ação');
                input.attr('placeholder', 'Digite o evento ou comando');
        }
    }

    // Clique em slot do menu principal
    $(document).on('click', '.item', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const slotId = $(this).data('slot');
        const resourceName = GetParentResourceName();
        const url = `https://${resourceName}/slotClicked`;
        
        console.log('Slot clicked:', slotId);
        console.log('Resource name:', resourceName);
        console.log('POST URL:', url);
        
        $.post(url, JSON.stringify({
            slot: slotId
        })).done(function(response) {
            console.log('slotClicked success:', response);
        }).fail(function(xhr, status, error) {
            console.log('Failed to send slotClicked event');
            console.log('Status:', status);
            console.log('Error:', error);
            console.log('XHR:', xhr);
        });
    });

    // Seleção de ícone
    $(document).on('click', '.icon-option', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        $('.icon-option').removeClass('selected');
        $(this).addClass('selected');
        selectedIcon = $(this).data('icon');
        console.log('Icon selected:', selectedIcon);
    });

    // Mudança no tipo de evento
    $('#eventTypeSelect').on('change', function() {
        updateEventLabels($(this).val());
    });

    // Botão voltar
    $('#backToMain').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const resourceName = GetParentResourceName();
        console.log('Back to main clicked, resource:', resourceName);
        
        $.post(`https://${resourceName}/backToMain`, JSON.stringify({}))
        .fail(function(xhr, status, error) {
            console.log('Failed to send backToMain event:', status, error);
        });
    });

    // Botão salvar
    $('#saveConfig').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (!validateConfig()) {
            return;
        }
        
        const config = {
            icon: selectedIcon,
            tooltip: $('#tooltipInput').val() || 'Botão Configurado',
            eventType: $('#eventTypeSelect').val(),
            event: $('#eventInput').val(),
            closeMenu: $('#closeMenuCheck').is(':checked')
        };
        
        const resourceName = GetParentResourceName();
        console.log('Saving config:', config);
        console.log('Resource name:', resourceName);
        
        $.post(`https://${resourceName}/saveSlotConfig`, JSON.stringify({
            slot: currentSlot,
            config: config
        })).fail(function(xhr, status, error) {
            console.log('Failed to send saveSlotConfig event:', status, error);
        });
    });

    // Botão resetar
    $('#resetSlot').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (confirm('Tem certeza que deseja resetar este slot? Esta ação não pode ser desfeita.')) {
            const resourceName = GetParentResourceName();
            console.log('Reset slot clicked, resource:', resourceName);
            
            $.post(`https://${resourceName}/resetSlot`, JSON.stringify({
                slot: currentSlot
            })).fail(function(xhr, status, error) {
                console.log('Failed to send resetSlot event:', status, error);
            });
        }
    });

    // Fechar com ESC
    $(document).on('keyup', function(e) {
        if (e.which == 27) {
            const resourceName = GetParentResourceName();
            console.log('ESC pressed, closing menu, resource:', resourceName);
            
            $.post(`https://${resourceName}/close`, JSON.stringify({}))
            .fail(function(xhr, status, error) {
                console.log('Failed to send close event:', status, error);
            });
        }
    });

    // Validação de configuração
    function validateConfig() {
        if (!selectedIcon) {
            alert('Selecione um ícone');
            return false;
        }
        
        if (!$('#eventTypeSelect').val()) {
            alert('Selecione o tipo de ação');
            return false;
        }
        
        if (!$('#eventInput').val() || $('#eventInput').val().trim() === '') {
            alert('Digite o evento ou comando');
            return false;
        }
        
        return true;
    }

    // Função para obter nome do recurso - CORRIGIDA
    function GetParentResourceName() {
        // Método 1: Tentar obter da janela pai (mais confiável)
        try {
            if (window.parent && window.parent.GetParentResourceName) {
                return window.parent.GetParentResourceName();
            }
        } catch(e) {
            console.log('Method 1 failed:', e);
        }

        // Método 2: Usar a variável global do FiveM se disponível
        try {
            if (typeof GetParentResourceName !== 'undefined') {
                return GetParentResourceName();
            }
        } catch(e) {
            console.log('Method 2 failed:', e);
        }

        // Método 3: Extrair da URL
        try {
            const url = window.location.href;
            console.log('Current URL:', url);
            
            // Para URLs como nui://resourcename/path
            let match = url.match(/nui:\/\/([^\/]+)/);
            if (match && match[1]) {
                console.log('Resource name from URL method 1:', match[1]);
                return match[1];
            }
            
            // Para URLs como http://localhost/resourcename/
            match = url.match(/\/([^\/]+)\/[^\/]*\.html/);
            if (match && match[1]) {
                console.log('Resource name from URL method 2:', match[1]);
                return match[1];
            }
        } catch(e) {
            console.log('Method 3 failed:', e);
        }

        // Método 4: Hardcoded fallback
        console.log('Using fallback resource name: mist_events');
        return 'mist_events';
    }
});