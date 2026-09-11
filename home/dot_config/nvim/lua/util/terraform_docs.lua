local M = {}

-- Local provider name (as used in resource/data blocks) -> full registry
-- source. Extend this if a module starts using a provider not listed here.
local PROVIDER_SOURCES = {
  aws = "hashicorp/aws",
  time = "hashicorp/time",
  random = "hashicorp/random",
  helm = "hashicorp/helm",
  kubectl = "alekc/kubectl",
  keycloak = "keycloak/keycloak",
}

-- Scan upward from the cursor for the nearest `resource "type" "name"` /
-- `data "type" "name"` header, so the mapping works with the cursor anywhere
-- inside the block, not just on the header line itself.
local function find_block_header()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  for line_nr = row, 1, -1 do
    local line = vim.fn.getline(line_nr)
    local kind, rtype = line:match '^%s*(resource)%s+"([%w_]+)"'
    if not kind then
      kind, rtype = line:match '^%s*(data)%s+"([%w_]+)"'
    end
    if kind then
      return kind, rtype
    end
  end
end

function M.open()
  local kind, rtype = find_block_header()
  if not rtype then
    vim.notify("No enclosing resource/data block found", vim.log.levels.WARN)
    return
  end

  local provider, name = rtype:match "^(%w+)_(.+)$"
  if not provider then
    vim.notify("Could not parse provider from type '" .. rtype .. "'", vim.log.levels.WARN)
    return
  end

  local source = PROVIDER_SOURCES[provider] or ("hashicorp/" .. provider)
  local doc_kind = kind == "data" and "data-sources" or "resources"
  local url =
    string.format("https://registry.terraform.io/providers/%s/latest/docs/%s/%s", source, doc_kind, name)

  vim.ui.open(url)
end

return M
