return {
--------- Commetray ---------------
    {
        "tpope/vim-commentary",
        lazy = false,
        config = function()
          vim.keymap.set('n', '<C-_>', '<Plug>Commentary', { silent = true, desc = "Comment/uncomment with operator" })
          vim.keymap.set('n', '<C-_><C-_>', '<Plug>CommentaryLine', { silent = true, desc = "Toggle comment on current line" })
        end,
    },
--------- Terminal Job ---------------
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
        require("toggleterm").setup({
          -- Налаштуйте, як вам зручно
          size = 20,
          open_mapping = [[<C-t>]], -- Замість <leader><C-B>
          hide_numbers = true,
          shade_filetypes = {},
          shade_terminals = true,
          -- direction = "float", -- "horizontal", "vertical", "float"
          -- direction = "horizontal", -- "horizontal", "vertical", "float"
          size = 15,
          terminal_mappings = true, -- Можливість мапінгу в термінальному режимі
          start_in_insert = true,
          insert_mappings = true,
          persist_size = true,
          -- persist_mode = true,
          -- close_on_exit = false, -- Запобігає автоматичному закриттю
          -- Запуск файлу:
          -- Створіть функцію, яка відкриває термінал і запускає команду
          -- Цю функцію потім можна замапити на <leader><C-B>
          -- Загальний cmd для ToggleTerm (якщо ви використовуєте :ToggleTerm напряму)
          -- Якщо ви використовуєте RunFile, то ця опція може бути порожньою або іншою
          cmd = '', -- Залишаємо порожнім, бо ми використовуємо RunFile
        })

        -- Приклад функції для запуску поточного файлу
        vim.api.nvim_create_user_command('RunFile', function()
          local file_path = vim.fn.expand('%:p')
          local file_type = vim.bo.filetype
          local cmd = ''

          if file_type == 'python' then
            cmd = 'python3 ' .. vim.fn.shellescape(file_path)
          elseif file_type == 'sh' or file_type == 'bash' then
            cmd = 'bash ' .. vim.fn.shellescape(file_path)
          -- Додайте інші типи файлів за потреби
          else
            vim.api.nvim_echo({{"Unknown filetype: " .. file_type, "Error"}}, true, {})
            return
          end

          -- Запускаємо команду в терміналі
          local term = require('toggleterm.terminal').Terminal:new({
              cmd = cmd,
              dir = vim.fn.expand('%:h'),
              direction = "horizontal", -- Можна перевизначити напрямок для цього терміналу
              size = 15,
              persist_mode = true,
              close_on_exit = false, -- Запобігає автоматичному закриттю
              hidden = false,         -- Гарантує, що він не буде прихований

              -- <--- КЛЮЧОВА ЧАСТИНА: on_exit callback

                   on_exit = function(t)
        local bufnr = t.bufnr
        local winid = t.winid

        if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
          -- Встановлення опцій ВІКНА:
          if winid and vim.api.nvim_win_is_valid(winid) then
            -- Використовуємо vim.cmd для встановлення опцій вікна
            vim.cmd(string.format('%d wincmd w | setlocal winfixheight< | setlocal winfixwidth<', winid))
            -- vim.cmd(string.format('%d wincmd w', winid)) -- Переходимо до вікна
            -- vim.cmd('setlocal winfixheight<') -- Знімаємо winfixheight
            -- vim.cmd('setlocal winfixwidth<')  -- Знімаємо winfixwidth
          end

          -- Встановлення опцій БУФЕРА:
          -- Використовуємо vim.cmd() для встановлення буферних опцій
          vim.cmd(string.format('bufdo if bufnr("%%") == %d | setlocal buftype=nofile modifiable readonly< filetype=log | endif', bufnr))

          -- Або, якщо хочемо більш явно керувати опціями буфера без bufdo (що може вплинути на всі буфери, якщо не обережно):
          -- Це не працює напряму, якщо ви не в тому буфері.
          -- Тому краще використати vim.api.nvim_set_option_value для явного встановлення для bufnr
          -- або забезпечити перехід до буфера перед setlocal.
          -- Але для on_exit, коли ми знаємо bufnr, це може бути достатньо:
          -- vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
          -- vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
          -- vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
          -- vim.api.nvim_buf_set_option(bufnr, 'readonly', false)
          
          -- Ось тут встановлюємо filetype через setlocal для конкретного буфера
          -- Це найбільш надійний спосіб для filetype в цьому контексті.
          -- Спробуємо більш прямий шлях, можливо, минула помилка була в синтаксисі string.format
          vim.cmd(string.format('buffer %d', bufnr)) -- Переходимо до буфера
          vim.cmd('setlocal filetype=log') -- Встановлюємо filetype

          -- Повертаємось до попереднього буфера, якщо ми змінили його, щоб встановити filetype.
          -- (Це може бути зайвим, якщо window id вже відомий)

          -- var current_win_before_change = vim.api.nvim_get_current_win()
          -- vim.api.nvim_set_current_win(current_win_before_change)

          -- Додатково: перейти в нормальний режим у цьому вікні, якщо курсор там
          if vim.api.nvim_get_current_win() == winid then
              vim.cmd('startinsert!') -- Вийти з insert mode
          end
        end
      end, 
          })
          term:toggle()
        end, { desc = "Run current file" })

        -- Мапінг для вашої команди RunFile
        vim.keymap.set('n', '<leader><C-B>', ':RunFile<CR>', { silent = true, desc = "Run current file" })
        end
    }
}
