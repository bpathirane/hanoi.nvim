local M = require("hanoi")

vim.api.nvim_create_user_command("TowersOfHanoi", function()
  M.open_towers_of_hanoi()
end, {})
