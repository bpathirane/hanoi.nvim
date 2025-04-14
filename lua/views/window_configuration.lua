local M = {}
M.double_border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }

local create_window_configurations = function()
    local bg_width = vim.o.columns
    local bg_height = vim.o.lines

    local pnl_width = math.floor(bg_width * 0.7)
    local pnl_height = math.floor(bg_height * 0.5)
    local pnl_top = math.floor((bg_height - pnl_height) / 2)
    local pnl_left = math.floor((bg_width - pnl_width) / 2)

    local tower_padding = 2
    local tower_width = math.floor((pnl_width - tower_padding * 3) / 3) -- two columns padding on eitherside
    local tower_height = math.floor(pnl_height - 9)
    local tower_top = pnl_top + 5

    local configs = {
        panel = {
            enter = false,
            opts = {
                relative = 'editor',
                width = pnl_width,
                height = pnl_height,
                style = 'minimal',
                border = 'rounded',
                col = pnl_left,
                row = pnl_top,
                zindex = 2,
            },
            lines = {},
            title = '[ Towers of Hanoi ]',
            title_pos = 'center'
        },
        header = {
            opts = {
                relative = 'editor',
                width = pnl_width - 4,
                height = 1,
                style = 'minimal',
                border = 'rounded',
                col = pnl_left + tower_padding,
                row = pnl_top + 1,
                zindex = 3,
            },
            enter = false,
            lines = { "Game header" }
        },
        footer = {
            opts = {
                relative = 'editor',
                width = pnl_width - 4,
                height = 1,
                style = 'minimal',
                border = 'rounded',
                col = pnl_left + tower_padding,
                row = tower_top + tower_height + 2,
                zindex = 3,
            },
            enter = false,
            lines = { "Help text " }
        },
    }
    for i = 1, 3, 1 do
        configs['tower' .. i] = {
            opts = {
                relative = 'editor',
                width = tower_width,
                height = tower_height,
                style = 'minimal',
                border = M.double_border,
                col = pnl_left + (tower_padding * i) + (tower_width * (i - 1)),
                row = tower_top,
            },
            enter = false,
            lines = {},
            title = ' [ ' .. i .. ' ] ',
            title_pos = 'center',
        }
    end
    return configs
end

M.create_window_configurations = create_window_configurations

return M
