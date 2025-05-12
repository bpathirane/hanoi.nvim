local M = {}

M.double_border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
M.single_border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local calculate_window_dimensions = function(num_disks)
    local bg_width = vim.o.columns
    local bg_height = vim.o.lines

    local tower_padding = 2
    local disk_block_width = 4 -- Disks are rendered as blocks

    local disk_block_height = 2
    local tower_width = math.floor(bg_width * 0.2) -- two columns padding on eitherside
    tower_width = tower_width + (tower_width % disk_block_width)
    local tower_height = disk_block_height * (num_disks + 1)

    local header_height = 1
    local footer_height = 1
    local pnl_width = tower_width * 3 + tower_padding * 4
    local pnl_height = tower_height + tower_padding * 3 + header_height + footer_height
    local pnl_top = math.floor((bg_height - pnl_height) / 2)
    local pnl_left = math.floor((bg_width - pnl_width) / 2)

    local dims = {
        background = {
            height = bg_height,
            width = bg_width
        },
        panel = {
            height = pnl_height,
            width = pnl_width,
            top = pnl_top,
            left = pnl_left,
            padding = 2,
            content_top = pnl_top + 1,
            content_left = pnl_left + 2,
            content_width = pnl_width - 4,
        },
        towers = {
            width = tower_width,
            height = tower_height,
            padding = tower_padding,
            top = nil,
            left = nil
        }
    }

    dims.header = {
        height = header_height,
        width = dims.panel.content_width,
        top = dims.panel.content_top,
        left = dims.panel.left + dims.panel.padding
    }

    for i = 1, 3, 1 do
        dims['tower' .. i] = {
            is_active = i == 1,
            disk_block_height = disk_block_height,
            disk_block_width = disk_block_width,
            width = tower_width,
            height = tower_height,
            col = dims.panel.content_left + (tower_padding * (i - 1)) + (tower_width * (i - 1)),
            row = dims.panel.content_top + dims.header.height + dims.panel.padding,
        }
    end

    dims.footer = {
        height = footer_height,
        width = dims.panel.content_width,
        top = dims.panel.content_top + dims.panel.padding * 2 + dims.header.height + dims.towers.height,
        left = dims.panel.content_left
    }
    return dims
end

local create_window_configurations = function(dimensions)
    local configs = {
        panel = {
            dims = dimensions.panel,
            enter = false,
            opts = {
                relative = 'editor',
                width = dimensions.panel.width,
                height = dimensions.panel.height,
                style = 'minimal',
                border = 'rounded',
                col = dimensions.panel.left,
                row = dimensions.panel.top,
                zindex = 2,
            },
            lines = {},
            title = '[ Towers of Hanoi ]',
            title_pos = 'center'
        },
        header = {
            dims = dimensions.header,
            opts = {
                relative = 'editor',
                width = dimensions.header.width,
                height = 1,
                style = 'minimal',
                border = 'rounded',
                col = dimensions.header.left,
                row = dimensions.header.top,
                zindex = 3,
            },
            enter = false,
            lines = { "Game header" }
        },
        footer = {
            dims = dimensions.footer,
            opts = {
                relative = 'editor',
                width = dimensions.footer.width,
                height = 1,
                style = 'minimal',
                border = 'rounded',
                col = dimensions.footer.left,
                row = dimensions.footer.top,
                zindex = 30,
            },
            enter = false,
            lines = { "Help text " }
        },
    }
    for i = 1, 3, 1 do
        local tkey = 'tower' .. i
        configs[tkey] = {
            dims = dimensions[tkey],
            opts = {
                relative = 'editor',
                width = dimensions[tkey].width,
                height = dimensions[tkey].height,
                style = 'minimal',
                border = dimensions[tkey].is_active and M.double_border or M.single_border,
                col = dimensions[tkey].col,
                row = dimensions[tkey].row,
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
M.calculate_window_dimensions = calculate_window_dimensions

return M
