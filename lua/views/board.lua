local winc = require('views.window_configuration')
local Board = {}
-- Set the method lookup back to itself
Board.__index = Board

function Board:new(game, controller)
    return setmetatable({ game = game, active_tower = nil, controller = controller }, self)
end

local disk_char = '\u{2593}' --'\u{1F7E7}'  ▓, an orange block respectively
local padding_char = ' '

local hideAllWindows = function(floats)
    for _, float in pairs(floats) do
        if vim.api.nvim_win_is_valid(float.win) then
            vim.api.nvim_win_hide(float.win)
        end
    end
end

local showAllWindows = function(floats)
    for _, float in pairs(floats) do
        local win = vim.api.nvim_open_win(float.buf, float.confg.enter, float.confg.opts)
        float.win = win
        if float.confg.title then
            vim.api.nvim_win_set_config(float.win, {
                title = float.confg.title,
                title_pos = float.confg.title_pos,
            })
        end
        if float.confg.footer then
            vim.api.nvim_win_set_config(float.win, {
                footer = float.confg.footer,
                footer_pos = float.confg.footer_pos,
            })
        end
    end
end

local function create_game_buffer(lines)
    local buf = vim.api.nvim_create_buf(false, true)
    if lines then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
    vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
    return buf
end

local function create_game_buffers(dimensions)
    local window_configs = winc.create_window_configurations(dimensions)
    local floats = {}
    for key, confg in pairs(window_configs) do
        floats[key] = {}
        floats[key].buf = create_game_buffer(confg.lines)
        floats[key].confg = confg
    end

    return floats
end

local function render_tower(tower, float)
    local stack = tower:get_stack()
    print('Tower float configuration: ', vim.inspect(float))
    local lines = {}
    local disk_char_len = string.len(disk_char)
    local emtpy_lines = float.confg.dims.height - (#stack * float.confg.dims.disk_block_height)
    for i = emtpy_lines, 1, -1 do
        table.insert(lines, string.rep(padding_char, float.confg.dims.width))
    end
    for _, disk in ipairs(stack) do
        local dl = string.rep(disk_char, disk.size * float.confg.dims.disk_block_width)
        local disk_ln = string.len(dl) / disk_char_len
        local disk_padding = string.rep(padding_char, (float.confg.dims.width - disk_ln) / 2)
        local disk_line = disk_padding .. dl .. disk_padding
        for i = float.confg.dims.disk_block_height, 1, -1 do
            table.insert(lines, disk_line)
        end
    end
    if lines then
        vim.api.nvim_set_option_value('modifiable', true, { buf = float.buf })
        vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value('modifiable', false, { buf = float.buf })
    end
end

function setFloatBorder(win, border)
    -- Save buffer and current window config
    local win_config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)

    -- Close the current window
    vim.api.nvim_win_close(win, true)

    -- Modify the border in the config
    win_config.border = border

    -- Reopen the window with the new border
    local new_win = vim.api.nvim_open_win(buf, true, win_config)

    return new_win
end

function Board:activate_tower(tower_index)
    tower_index = tower_index or 1
    if (self.active_tower ~= nil and tower_index == self.active_tower) then
        return
    end
    local new_tower = self.floats['tower' .. tower_index]
    new_tower.win = setFloatBorder(new_tower.win, 'double')
    if (self.active_tower ~= nil) then
    local old_tower = self.floats['tower' .. self.active_tower]
    old_tower.win = setFloatBorder(old_tower.win, 'single')
    end

    vim.api.nvim_set_current_win(new_tower.win)
    self.active_tower = tower_index
end

function Board:render()
    self.dims = winc.calculate_window_dimensions(self.game.disks)
    -- print('Created the window dimensions: ', vim.inspect(state.dims))
    if not self.floats then
        self.floats = create_game_buffers(self.dims)
        for _, float in pairs(self.floats) do
            vim.keymap.set('n', 'q', function() hideAllWindows(self.floats) end, { buffer = float.buf, silent = true })
            vim.keymap.set('n', '<Esc>', function() hideAllWindows(self.floats) end,
                { buffer = float.buf, silent = true })
        end
    end
    vim.keymap.set('n', 'l', function()
        self:activate_tower(2)
    end, { buffer = self.floats.tower1.buf, silent = true })

    vim.keymap.set('n', 'l', function()
        self:activate_tower(3)
    end, { buffer = self.floats.tower2.buf, silent = true })

    vim.keymap.set('n', 'h', function()
        self:activate_tower(1)
    end, { buffer = self.floats.tower2.buf, silent = true })

    vim.keymap.set('n', 'h', function()
        self:activate_tower(2)
    end, { buffer = self.floats.tower3.buf, silent = true })

    local panel_id = self.floats.panel.win
    if panel_id == nil or not vim.api.nvim_win_is_valid(panel_id) then
        showAllWindows(self.floats)
    end
    for i, tower in ipairs(self.game.towers) do
        render_tower(tower, self.floats['tower' .. i])
    end
    self:activate_tower(self.active_tower)
end

return Board
