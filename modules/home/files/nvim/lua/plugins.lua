vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
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
