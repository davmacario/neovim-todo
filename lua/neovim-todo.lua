local M = {}

-- TODO: something
-- TODO: some other TODO

M.todo = function()
  local query_string = '((comment) @comment (#match? @comment "TODO"))'
  local parser = require("nvim-treesitter.parsers").get_parser()
  -- The query above may have some problems in specific languages
  -- Error handling: wrap function in `pcall`
  local ok, query = pcall(vim.treesitter.query.parse, parser:lang(), query_string)
  if not ok then
    return
  end
  -- Debug:
  -- vim.print(query)
  local tree = parser:parse()[1]
  local qflist = {}
  for _, n in query:iter_captures(tree:root(), 0) do
    local text = vim.treesitter.get_node_text(n, 0)
    local lnum, col = n:range()
    -- vim.print(text)
    table.insert(qflist, {
      bufnr = vim.api.nvim_get_current_buf(),
      text = text,
      lnum = lnum + 1, -- Some weird API
      col = col + 1,
    })
  end
  vim.fn.setqflist(qflist)
  vim.cmd.copen()
end

return M
