vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

local nix_profile_bin = vim.fn.expand("~/.nix-profile/bin")
if vim.fn.isdirectory(nix_profile_bin) == 1 then
  vim.env.PATH = nix_profile_bin .. ":" .. vim.env.PATH
end

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

local prettier_root_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.ts",
  ".prettierrc.cts",
  ".prettierrc.mts",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
  "prettier.config.cts",
  "prettier.config.mts",
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

local function package_has_field(bufnr, field)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  local package_json = vim.fs.find("package.json", { path = path, upward = true })[1]
  if not package_json then
    return false
  end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
  return ok and type(package) == "table" and package[field] ~= nil
end

vim.lsp.config("oxlint", {
  cmd = { "oxlint", "--lsp" },
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
    local root = vim.fs.root(path, {
      ".oxlintrc.json",
      ".oxlintrc.jsonc",
      "oxlint.config.ts",
      "oxlint.config.js",
      "oxlint.config.mjs",
      "oxlint.config.cjs",
    })

    if not root and package_has(bufnr, { "oxlint" }) then
      root = vim.fs.root(path, { "package.json", ".git" })
    end

    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.config("eslint", {
  settings = {
    eslint = {
      format = { enable = false },
      codeActionsOnSave = { mode = "all" },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "oxlint",
  "eslint",
  "marksman",
  "html",
  "cssls",
  "jsonls",
})

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
  if root_has_file(bufnr, biome_root_files) or package_has(bufnr, { "@biomejs/biome" }) then
    return { "biome" }
  end

  if root_has_file(bufnr, prettier_root_files) or package_has_field(bufnr, "prettier") or package_has(bufnr, { "prettier" }) then
    return { "prettier" }
  end

  if has_vite_plus(bufnr) or package_has(bufnr, { "vite-plus" }) then
    return { "oxfmt" }
  end

  return {}
end

local function markdown_formatters(bufnr)
  if root_has_file(bufnr, biome_root_files) or package_has(bufnr, { "@biomejs/biome" }) then
    return { "biome" }
  end

  return { "prettier" }
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
    markdown = markdown_formatters,
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

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 32,
    side = "left",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_diagnostics = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
})

require("render-markdown").setup({
  completions = {
    lsp = { enabled = true },
  },
  file_types = { "markdown" },
})

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
