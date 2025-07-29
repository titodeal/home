
vim.opt.completeopt = 'menu,menuone,noselect'

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'L3MON4D3/LuaSnip',              -- Двигун сніпетів
        'saadparwaiz1/cmp_luasnip',      -- Джерело для nvim-cmp з LuaSnip
        'rafamadriz/friendly-snippets',   -- Набір готових сніпетів
        'hrsh7th/cmp-nvim-lsp',          -- Обробник даних lsp
        'hrsh7th/cmp-buffer',            -- Підстановка з поточного буфер
        'hrsh7th/cmp-path',              -- Підстановка з файлової системи
        'hrsh7th/cmp-cmdline',           -- Підстановка в коммндному рядку
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require('luasnip')
      -- Завантажуємо всі сніпети з friendly-snippets (якщо використовуєте)
      require('luasnip.loaders.from_vscode').lazy_load()

      -- 📦 Основне автодоповнення
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-N>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-P>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ['<C-L>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Підтвердження вибору, з автоматичним вибором першого варіанта
            ['<C-Space>'] = cmp.mapping.complete(), -- Виклик автодоповнення 
        }),

        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },

        -- Додаткові налаштування вікна автодоповнення (вигляд)
        window = {
          completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
          documentation = cmp.config.disable,
        },

      })

      -- 🔍 Пошук (`/`, `?`)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      ---- Command Line -----
      vim.keymap.set("c", "<C-L>", function()
          cmp.abort()
      end, { silent = true })

      -- 💻 Командний режим (`:`)
      cmp.setup.cmdline(":", {
          mapping = {
            ["<C-N>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
            ["<C-P>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
            ["<CR>"] = cmp.mapping.confirm({ select = true })
          },
        sources = cmp.config.sources(
          { { name = "path" } },
          {
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
                treat_trailing_slash = true,
              },
            }
          }
        )
      })
    end,
  },
}
