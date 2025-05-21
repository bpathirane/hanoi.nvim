local Controller = require("controller")

local M = {}

vim.api.nvim_create_user_command("TowersOfHanoi", function()
  if not M.controller then
    M.controller = Controller:new()
  end
  M.controller:open_towers_of_hanoi()
end, {})

return M
