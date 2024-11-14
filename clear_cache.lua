vim.api.nvim_create_user_command("Test", function()
  package.loaded.MyPlugin = nil
  require("MyPlugin").todo()
end, {})
