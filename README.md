---
title: Creating a Lua Neovim plugin
author: Davide Macario
date: 2024-11-14
---

## Lua function

Definition:

```lua
function Todo()
  print("Hello, world!")
end
```

Then, `:source` the file (`:source %`).
Now, you can call the function by running `:lua Todo()`

### Triggering the function

- Define `Todo` command:

  ```lua
  vim.api.nvim_create_user_command("Todo", Todo, {})
  ```

  Now, you can just call `:Todo`

- Autocommand:

  ```lua
  vim.api.nvim_create_autocmd("CursorHold", { callback = Todo })
  ```

  Now, the function will be executed when the cursor is still

- Keymap (`<leader>u`):

  ```lua
  vim.keymap.set("n", "<leader>u", Todo)
  ```

## Shipping the function

Starting from an empty directory (`MyPlugin`),

1. Create a `lua` directory
2. Create a file `lua/<plugin_name>.lua`
   - Whatever is returned by this file will be accessible (convention is to return a table, as follows)

   ```lua
   local M = {}

   M.todo = function()
     print("Hello, world!")
   end

   return M
   ```

When using a package manager, it is in charge of automatically sourcing the file.

For local development, we don't wanna go through a package manager.
It is possible to add the directory to the runtimepath by opening neovim as:

```bash
nvim --cmd "set rtp+=<path_to_directory>" "<file_name>"
```

In our case, standing in `my_plugin/`:

```bash
nvim -c "set rtp+=." "lua/MyPlugin.lua"
```

Then, it is possible to call `:lua require("MyPlugin").todo()`.

**Note:** changing the plugin content and re-running the same command (without exiting Neovim) will **NOT** apply the changes, as the result of `require()` is cached.
A trick is to use a user command:

```lua
vim.api.nvim_create_user_command("Test", function()
  package.loaded.MyPlugin = nil
  require("MyPlugin").todo()
end)
```

Then, source the file containing this function (note that it is specific to our plugin, so maybe keep it handy in the plugin directory), and execute the command `:Test` to clear the cache (and additionally, run the `todo()` function automatically).

### More advanced plugin

> Small intermission - populate a _quickfix_ list with all the occurrences of a specific string:
>
> ```vim
> :vimgrep <word> % "scan current file for occurrences of <word>
> :copen "populate quickfix list with contents of the above
> ```

Plugin idea: find TODO comments using Treesitter.

> _Hint: use the following Builtin Neovim commands (>=v0.10)_
>
> - `:Inspect`
> - `:InspectTree`
> - `:EditQuery`
