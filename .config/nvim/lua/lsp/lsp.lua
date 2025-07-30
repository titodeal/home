local hover_window = require('lsp.hover_window')

return {
    {
        'neovim/nvim-lspconfig',
        config = function()
          local lspconfig = require('lspconfig')
          capabilities = require('lsp.capabilities').get_capabilities()
          lspconfig.pyright.setup({
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = "basic", -- Це за замовчуванням "basic", можна залишити або видалити
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    -- autoImportCompletions = false,
                  }
               }
            },
            on_attach = function(client, bufnr)
               hover_window.setup_hover_handler(bufnr) 
            end
        })

        lspconfig.ruff.setup ({
            init_options = {
                settings = {
                    -- args = { "--preview" },
                    -- logLevel = "info",
                    -- logFile = "ruff_lsp.log",
                    lint = {
                        enable = true,
                        preview = true,
                        select = { "E", "F", "UP", "B", "SIM", "I" },
                        extendSelect = {"W"},
                        ignore = {},
                    },
                    format = {
                        enable = true,
                        preview = true,
                    },
                    lineLength = 120,
                    fixAll = true,
                }
            },
            on_attach = function(client, bufnr)
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
            end
        })

        vim.diagnostic.config({
          virtual_text = { severity = { min = vim.diagnostic.severity.HINT } },
          signs = true,
          update_in_insert = false,
          severity_sort = true,
          float = { source = "always", border = "single" },
        })

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "[G]o to [R]eferences" })
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "[R]e[n]ame Symbol" })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true } -- Форматування коду
        end, { desc = "Format Code" })
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
     end,
  },
}
