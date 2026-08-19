local lint = require "lint"

lint.linters_by_ft = {
  python = { "ruff" },
  yaml = { "yamllint" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
}

lint.linters.yamllint = vim.tbl_extend("force", lint.linters.yamllint, {
  args = { "--format", "parsable", "-" },
})

lint.linters.yamllint_chart = vim.tbl_extend("force", lint.linters.yamllint, {
  args = {
    "-d",
    "{extends: default, rules: {line-length: disable, empty-lines: {max-end: false}}}",
    "--format",
    "parsable",
    "-",
  },
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype == "yaml" and vim.fn.expand "%:t" == "Chart.yaml" then
      lint.try_lint("yamllint_chart")
    else
      lint.try_lint()
    end
  end,
})
