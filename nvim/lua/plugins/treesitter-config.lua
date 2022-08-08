-- Tree sitter
local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end
treesitter.setup {
  ensure_installed = { "javascript", "lua", "html", "css", "dockerfile", "dot", "json", "markdown", "prisma", "scss", "tsx", "typescript" },
  auto_install = true,
  highlight = {
    enable = true,
  }
}

