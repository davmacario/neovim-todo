-- Source this file, then call :lua Todo()
function Todo()
  print("Hello, world!")
end

-- Trigger function:
-- Via user command (can call :Todo)
vim.api.nvim_create_user_command("Todo", Todo, {})

-- Via autocommand (when cursor is still)
-- vim.api.nvim_create_autocmd("CursorHold", { callback = Todo })

-- Via keymap (leader + u)
vim.keymap.set("n", "<leader>u", Todo)

