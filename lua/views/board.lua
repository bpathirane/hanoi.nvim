local winc = require('views.window_configuration')
local M = {}
local state = {
    game = nil,
    floats = nil
}
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

local function create_game_buffers()
    local window_configs = winc.create_window_configurations(state.dims)
    local floats = {}
    for key, confg in pairs(window_configs) do
        floats[key] = {}
        floats[key].buf = create_game_buffer(confg.lines)
        floats[key].confg = confg
    end

    for _, float in pairs(floats) do
        vim.keymap.set('n', '<Esc>', function()
            hideAllWindows(state.floats)
        end, { buffer = float.buf, silent = true })
    end
    return floats
end

local function render_tower(tower, float)
    local stack = tower:get_stack()
    print('Tower float configuration: ', vim.inspect(float))
    local lines = {}
    local disk_char_len = string.len(disk_char)
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

function M.render(game)
    state.game = game
    state.dims = winc.calculate_window_dimensions(state.game.disks)
    -- print('Created the window dimensions: ', vim.inspect(state.dims))
    if not state.floats then
        state.floats = create_game_buffers()
    end
    local panel_id = state.floats.panel.win
    if panel_id == nil or not vim.api.nvim_win_is_valid(panel_id) then
        showAllWindows(state.floats)
        vim.api.nvim_set_current_win(state.floats.tower1.win)
    end
    for i, tower in ipairs(game.towers) do
        render_tower(tower, state.floats['tower' .. i])
    end
end

return M
