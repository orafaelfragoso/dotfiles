vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

local eslint_fix_on_save_group = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local opts = { buffer = event.buf, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
    vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
    vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    vim.keymap.set("n", "<leader>lf", function()
      require("conform").format({
        bufnr = event.buf,
        lsp_format = "fallback",
        timeout_ms = 3000,
      })
    end, vim.tbl_extend("force", opts, { desc = "Format Document" }))
    vim.keymap.set("n", "<leader>cd", function()
      require("fzf-lua").diagnostics_document({
        severity = "warn|error",
        opts = { height = 0.4, prompt = "Diagnostics> " },
        mode = "location",
      })
    end, vim.tbl_extend("force", opts, { desc = "Show Diagnostics on FZF" }))
    vim.keymap.set("n", "<leader>cX", function()
      local oxlint = vim.lsp.get_clients({ bufnr = event.buf, name = "oxlint" })[1]
      if not oxlint then
        vim.notify("No oxlint client attached", vim.log.levels.WARN)
        return
      end

      require("fzf-lua").diagnostics_document({
        client_id = oxlint.id,
        severity = "warn|error",
        opts = { height = 0.4, prompt = "Oxlint Diagnostics> " },
        mode = "location",
      })
    end, vim.tbl_extend("force", opts, { desc = "Show Oxlint Diagnostics" }))
    vim.keymap.set("n", "<leader>cO", function()
      if vim.fn.exists(":LspOxlintFixAll") ~= 2 then
        vim.notify("No oxlint fix-all command available", vim.log.levels.WARN)
        return
      end

      vim.cmd.LspOxlintFixAll()
    end, vim.tbl_extend("force", opts, { desc = "Oxlint Fix All" }))

    if client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = eslint_fix_on_save_group,
        buffer = event.buf,
        command = "LspEslintFixAll",
      })

      vim.keymap.set("n", "<leader>cE", function()
        local eslint = vim.lsp.get_clients({ bufnr = event.buf, name = "eslint" })[1]
        if not eslint then
          vim.notify("No eslint client attached", vim.log.levels.WARN)
          return
        end

        require("fzf-lua").diagnostics_document({
          client_id = eslint.id,
          severity = "warn|error",
          opts = { height = 0.4, prompt = "ESLint Diagnostics> " },
          mode = "location",
        })
      end, vim.tbl_extend("force", opts, { desc = "Show ESLint Diagnostics" }))

      vim.keymap.set("n", "<leader>cL", function()
        vim.cmd.LspEslintFixAll()
      end, vim.tbl_extend("force", opts, { desc = "ESLint Fix All" }))
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" }))
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

  end,
})
