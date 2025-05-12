local Controller = require("controller")

local M = {}

vim.api.nvim_create_user_command("TowersOfHanoi", function()
  if not M.controller then
    print('Creating controller...')
    M.controller = Controller:new()
    print('Controller: ', vim.inspect(M))
  end
  M.controller:open_towers_of_hanoi()
end, {})

return M
