# Sistema de Menu Dinâmico

## 📋 Descrição

Este sistema transforma o menu de roupas estático original em uma interface completamente configurável onde cada ícone pode ser personalizado pelo usuário para executar diferentes tipos de ações.

## ✨ Funcionalidades

### 🎯 Sistema Dinâmico
- **12 slots configuráveis** independentemente
- **Interface visual preservada** do sistema original
- **Configuração individual** para cada slot
- **Persistência de configurações** (memória ou SQL)

### 🔧 Tipos de Ação Suportados
1. **Evento Cliente** - Dispara eventos locais (`TriggerEvent`)
2. **Evento Servidor** - Envia eventos para o servidor (`TriggerServerEvent`)
3. **Comando** - Executa comandos de chat (`ExecuteCommand`)

### 🎨 Personalização Completa
- **30+ ícones disponíveis** para seleção
- **Tooltips personalizáveis** para cada slot
- **Controle de comportamento** (fechar menu ou manter aberto)
- **Estados visuais** diferenciados (configurado/não configurado)

## 🚀 Instalação

1. **Substitua os arquivos** pelos novos versions dinâmicas
2. **Configure o comando** no `config.lua` (padrão: `/menuropa`)
3. **Configure a tecla** no `config.lua` (padrão: `K`)
4. **(Opcional)** Configure persistência SQL no servidor

## 📖 Como Usar

### Para Usuários

1. **Abra o menu** com `/menuropa` ou tecla `K`
2. **Clique em qualquer slot** não configurado (ícones com ⚙)
3. **Configure o slot:**
   - Selecione um ícone
   - Digite um nome/tooltip
   - Escolha o tipo de ação
   - Digite o evento/comando
   - Defina se deve fechar o menu
4. **Salve a configuração**
5. **Use o slot** clicando nele no menu principal

### Exemplos de Configuração

#### Evento Cliente
- **Tipo:** Evento Cliente
- **Evento:** `openInventory`
- **Resultado:** Dispara `TriggerEvent('openInventory')`

#### Evento Servidor
- **Tipo:** Evento Servidor  
- **Evento:** `requestSalary`
- **Resultado:** Dispara `TriggerServerEvent('requestSalary')`

#### Comando
- **Tipo:** Comando
- **Comando:** `me está pensando`
- **Resultado:** Executa `/me está pensando`

## 🔨 Para Desenvolvedores

### Estrutura de Configuração

```lua
Config.DynamicIcons = {
    slot1 = {
        icon = "fa-sharp fa-solid fa-shirt",
        tooltip = "Meu Botão",
        eventType = "client", -- "client", "server", "command"
        event = "nomeDoEvento",
        closeMenu = true
    }
}
```

### Eventos Disponíveis

```lua
-- Cliente para Servidor (salvar configurações)
TriggerServerEvent('dynamic_menu:saveConfig', slotId, config)

-- Servidor para Cliente (carregar configurações)  
TriggerClientEvent('dynamic_menu:configsLoaded', source, configs)

-- Cliente (carregar configurações)
TriggerEvent('dynamic_menu:loadConfigs')
```

### Persistência SQL (Opcional)

```sql
CREATE TABLE IF NOT EXISTS `dynamic_menu_configs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `slot_id` varchar(20) NOT NULL,
    `icon` varchar(100) NOT NULL,
    `tooltip` varchar(50) NOT NULL,
    `event_type` enum('client','server','command') NOT NULL,
    `event` varchar(100) NOT NULL,
    `close_menu` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_user_slot` (`identifier`, `slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## 🎨 Personalização Visual

### Estados dos Slots
- **🟢 Configurado:** Verde - Slot com ação definida
- **🟠 Não Configurado:** Laranja - Slot vazio (ícone ⚙)
- **🔵 Hover:** Laranja - Efeito hover em qualquer slot

### Ícones Disponíveis
- Roupas e acessórios
- Veículos e transporte  
- Interface e sistema
- Ações e objetos
- Símbolos e decorativos

## 🔧 Configurações Avançadas

### Adicionar Novos Ícones

```lua
Config.AvailableIcons = {
    {name = "Novo Ícone", class = "fa-solid fa-novo-icone"},
    -- ... outros ícones
}
```

### Modificar Slots Padrão

```lua
-- Adicionar mais slots
Config.DynamicIcons.slot13 = {
    icon = "fa-solid fa-plus",
    tooltip = "Novo Slot",
    eventType = nil,
    event = nil,
    closeMenu = true
}
```

## 🐛 Solução de Problemas

### Configurações Não Salvam
- Verifique se o servidor está configurado
- Confirme se os eventos estão sendo disparados
- Teste sem SQL primeiro (modo memória)

### Ícones Não Aparecem
- Verifique a conexão com CDN Font Awesome
- Confirme se as classes de ícone estão corretas
- Teste com ícones padrão primeiro

### Eventos Não Funcionam
- Confirme a sintaxe do evento/comando
- Teste eventos existentes no servidor
- Verifique logs do console para erros

## 📝 Changelog

### Versão 2.0.0
- ✅ Sistema completamente dinâmico
- ✅ Interface de configuração integrada
- ✅ Suporte a 3 tipos de ação
- ✅ 30+ ícones disponíveis
- ✅ Persistência configurável
- ✅ Estados visuais diferenciados
- ❌ Funcionalidades de roupa removidas

### Versão 1.0.0 (Original)
- Sistema fixo de roupas
- 12 funções pré-definidas
- Interface estática

## 🤝 Suporte

Para suporte técnico ou dúvidas:
1. Verifique este README
2. Teste em ambiente de desenvolvimento
3. Consulte logs do console F8
4. Reporte bugs com detalhes específicos

---

**Nota:** Este sistema substitui completamente a funcionalidade original de roupas por um sistema flexível e configurável. Todas as configurações são feitas pelos próprios usuários através da interface.