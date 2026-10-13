local M = {}

--- Resolve which `ruff` executable to run, preferring (in order):
--- 1. an active virtualenv (`$VIRTUAL_ENV/bin/ruff`)
--- 2. a project-local `.venv/bin/ruff` next to pyproject.toml/uv.lock/.git
--- 3. a global install, e.g. `uv tool install ruff`, at `~/.local/bin/ruff`
--- 4. whatever `ruff` resolves to on $PATH (e.g. Mason's copy)
---@param start_path? string directory to search upward from (defaults to cwd)
---@return string
function M.find(start_path)
  start_path = start_path or vim.fn.getcwd()

  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    local candidate = venv .. "/bin/ruff"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  local root = vim.fs.root(start_path, { "pyproject.toml", "uv.lock", ".git" })
  if root then
    local candidate = root .. "/.venv/bin/ruff"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  local global = vim.fn.expand "~/.local/bin/ruff"
  if vim.fn.executable(global) == 1 then
    return global
  end

  return "ruff"
end

return M
