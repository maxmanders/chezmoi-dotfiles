require("nvchad.configs.lspconfig").defaults()

local servers = {
  "bashls",
  "clangd",
  "cssls",
  "gopls",
  "helm-ls",
  "html",
  "pyright",
  "ruff",
  "terraformls",
  "ts_ls",
  "yaml-language-server",
}
vim.lsp.config("yaml-language-server", {
  settings = {
    yaml = {
      schemas = {
        -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json"] = ["/*.yaml","/*.yml"],
        ["kubernetes"] = { "**/k8s/*.yaml", "**/manifests/*.yaml", "**/kubernetes/*.yaml", "**/clusters/**/*.yaml" },
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
      },
    },
  },
})

vim.lsp.config("ruff", {
  cmd = function(dispatchers, config)
    local ruff = require("util.ruff").find(config.root_dir)
    return vim.lsp.rpc.start({ ruff, "server" }, dispatchers)
  end,
})

vim.lsp.config("helm-ls", {
  settings = {
    helm_ls = {
      logLevel = "info",
      valuesFiles = {
        mainValuesFile = "values.yaml",
        lintOverlayValuesFile = "values.lint.yaml",
        additionalValuesFilesGlobPattern = "values*.yaml",
      },
      yamlls = {
        path = "yaml-language-server",
        config = {
          yaml = {
            completion = true,
            hover = true,
            validate = true,
          },
        },
      },
    },
  },
})

-- Don't attach to non-file buffers such as fugitive:// blobs, which would
-- otherwise be handed to the server as an invalid workspace folder
for _, name in ipairs(servers) do
  local root_dir = vim.lsp.config[name].root_dir
  local root_markers = vim.lsp.config[name].root_markers
  vim.lsp.config(name, {
    root_dir = function(bufnr, on_dir)
      if vim.api.nvim_buf_get_name(bufnr):match "^%a+://" then return end
      if type(root_dir) == "function" then return root_dir(bufnr, on_dir) end
      on_dir(root_dir or (root_markers and vim.fs.root(bufnr, root_markers)))
    end,
  })
end

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    -- Restore gq to use Vim's built-in line-wrapper instead of LSP
    vim.bo[args.buf].formatexpr = ""
  end,
})

-- read :h vim.lsp.config for changing options of lsp servers
