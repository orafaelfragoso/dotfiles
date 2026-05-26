vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").setup()

require("nvim-treesitter").install({
  "bash",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
})

require("mason").setup()

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      codeActions = true,
      classFunctions = { "cn", "cva", "clsx" },
      lint = {
        recommendedVariantOrder = "ignore",
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })

    local css_entrypoint = vim.fs.joinpath(config.root_dir or "", "src", "style.css")
    if vim.fn.filereadable(css_entrypoint) == 1 then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        tailwindCSS = {
          experimental = {
            configFile = "src/style.css",
          },
        },
      })
    end
  end,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "oxlint",
    "eslint",
    "html",
    "cssls",
    "jsonls",
    "tailwindcss",
  },
  automatic_enable = {
    "lua_ls",
    "ts_ls",
    "oxlint",
    "eslint",
    "html",
    "cssls",
    "jsonls",
    "tailwindcss",
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "biome",
    "oxfmt",
    "oxlint",
    "prettier",
    "stylua",
  },
})

local prettier_root_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
}

local biome_root_files = { "biome.json", "biome.jsonc" }
local vite_plus_root_files = { "vite.config.ts", "vite.config.js" }

local function root_has_file(bufnr, names)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  return vim.fs.find(names, { path = path, upward = true })[1] ~= nil
end

local function package_has(bufnr, package_names)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  local package_json = vim.fs.find("package.json", { path = path, upward = true })[1]
  if not package_json then
    return false
  end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
  if not ok or type(package) ~= "table" then
    return false
  end

  local dependency_groups = { "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }
  for _, group in ipairs(dependency_groups) do
    local dependencies = package[group]
    if type(dependencies) == "table" then
      for _, name in ipairs(package_names) do
        if dependencies[name] then
          return true
        end
      end
    end
  end

  return false
end

local function has_vite_plus(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  local vite_config = vim.fs.find(vite_plus_root_files, { path = path, upward = true })[1]
  if not vite_config then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, vite_config, "", 80)
  if not ok then
    return false
  end

  return table.concat(lines, "\n"):find("vite%-plus") ~= nil
end

local function web_formatters(bufnr)
  if has_vite_plus(bufnr) or package_has(bufnr, { "vite-plus" }) then
    return { "oxfmt" }
  end

  if root_has_file(bufnr, biome_root_files) or package_has(bufnr, { "@biomejs/biome" }) then
    return { "biome" }
  end

  if root_has_file(bufnr, prettier_root_files) or package_has(bufnr, { "prettier" }) then
    return { "prettier" }
  end

  return {}
end

require("conform").setup({
  notify_on_error = true,
  formatters_by_ft = {
    javascript = web_formatters,
    javascriptreact = web_formatters,
    typescript = web_formatters,
    typescriptreact = web_formatters,
    json = web_formatters,
    jsonc = web_formatters,
    css = web_formatters,
    scss = web_formatters,
    html = web_formatters,
    markdown = web_formatters,
    lua = { "stylua" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 3000,
  },
})

require("catppuccin").setup({
  transparent_background = true,
  integrations = {
    fzf = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    semantic_tokens = true,
  },
})

vim.cmd.colorscheme("catppuccin")

require("nvim-web-devicons").setup()

require("fzf-lua").setup({
  winopts = {
    height = 0.40,
    width = 0.40,
    row = 0.3,
    col = 0.5,
    border = "rounded",
    backdrop = 100,
    preview = {
      hidden = "hidden",
    },
  },
  keymap = {
    builtin = {
      ["<esc>"] = "abort",
    },
  },
  file_icons = true,
  fzf_colors = true,
  fzf_opts = {
    ["--ansi"] = "",
    ["--info"] = "inline",
    ["--layout"] = "reverse",
  },
  files = {
    prompt = "Files❯ ",
    git_icons = true,
  },
  grep = {
    prompt = "Rg❯ ",
  },
})

require("lualine").setup({
  options = {
    theme = "auto",
    icons_enabled = true,
    globalstatus = true,
    component_separators = "",
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      { "mode", separator = { left = "" }, right_padding = 2 },
    },
    lualine_b = {
      {
        "filetype",
        colored = true,
        icon_only = true,
      },
      { "filename" },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        colored = true,
        update_in_insert = false,
        always_visible = false,
        symbols = {
          error = " ",
          warn = " ",
          hint = " ",
          info = " ",
        },
      },
    },
    lualine_c = {
      "%=",
    },
    lualine_x = {},
    lualine_y = {
      {
        "lsp_status",
        icon = "",
        symbols = {
          spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          done = "✓",
          separator = " | ",
        },
        ignore_lsp = {},
      },
    },
    lualine_z = {
      { "progress" },
      { "location", separator = { right = "" } },
    },
  },
  inactive_sections = {
    lualine_a = { "filename" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = {
    {
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
        lualine_z = { { "location", separator = { left = "", right = "" } } },
      },
      filetypes = { "fzf" },
    },
  },
})
