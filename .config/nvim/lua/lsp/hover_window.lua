-- lua/lsp/hover_window.lua

local M = {}

local documentation_window_bufnr = nil
local documentation_window_winid = nil


local open_documentation_window = function(contents, client_bufnr)

    if #contents == 0 then
        print("open_documentation_window: No content, closing window if open.")
        if documentation_window_winid and vim.api.nvim_win_is_valid(documentation_window_winid) then
            vim.api.nvim_win_close(documentation_window_winid, true)
            documentation_window_winid = nil
            documentation_window_bufnr = nil
        end
        return
    end
    
    local width = vim.opt.columns:get()
    local height = math.floor(vim.opt.lines:get() * 0.2)

    local client_winid = vim.fn.bufwinid(client_bufnr)
    if client_winid > 0 then
        width = vim.fn.winwidth(client_winid)
    end

    local original_win = vim.api.nvim_get_current_win()
    if documentation_window_winid and vim.api.nvim_win_is_valid(documentation_window_winid) then
        -- local original_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(documentation_window_winid)
        vim.api.nvim_buf_set_option(documentation_window_bufnr, 'modifiable', true)
        vim.api.nvim_buf_set_option(documentation_window_bufnr, 'readonly', false)

        vim.api.nvim_buf_set_lines(documentation_window_bufnr, 0, -1, false, contents)
        vim.lsp.util.stylize_markdown(documentation_window_bufnr, contents)

        vim.api.nvim_buf_set_option(documentation_window_bufnr, 'modifiable', false)
        vim.api.nvim_buf_set_option(documentation_window_bufnr, 'readonly', true)
        -- vim.api.nvim_win_set_cursor(documentation_window_winid, {1, 0})
        vim.api.nvim_set_current_win(original_win)
    else
        local new_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(new_buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(new_buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(new_buf, 'swapfile', false)
        vim.api.nvim_buf_set_option(new_buf, 'filetype', 'markdown')

        vim.cmd('split')
        documentation_window_winid = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_buf(new_buf)
        documentation_window_bufnr = new_buf

        vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, contents)

        vim.api.nvim_buf_set_option(new_buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(new_buf, 'readonly', true)

        -- vim.api.nvim_win_set_width(documentation_window_winid, target_width)
        vim.api.nvim_win_set_width(documentation_window_winid, width)
        vim.api.nvim_win_set_height(documentation_window_winid, height)
        vim.api.nvim_win_set_option(documentation_window_winid, 'wrap', true)
        vim.api.nvim_win_set_option(documentation_window_winid, 'relativenumber', false)
        vim.api.nvim_win_set_option(documentation_window_winid, 'number', false)
        vim.api.nvim_win_set_option(documentation_window_winid, 'winbar', ' Documentation ')

        vim.api.nvim_set_current_win(original_win)
        -- vim.api.nvim_set_current_win(vim.api.nvim_get_current_win())
    end
end

function M.setup_hover_handler(bufnr)
    -- print("hover_window.setup_hover_handler CALLED for bufnr: " .. bufnr)

    vim.keymap.set('n', 'K', function()
        -- print("K KEYMAP ACTIVATED! Making direct LSP request for hover...")

        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients == 0 then
            print("No active LSP client for this buffer.")
            open_documentation_window({})
            return
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = pos[1] - 1
        local char = pos[2]

        local found_hover_content = false

        for _, client in ipairs(clients) do
            if client.server_capabilities.hoverProvider then
                client.request('textDocument/hover', {
                    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
                    position = { line = line, character = char },
                }, function(err, result, ctx)
                    -- print("DIRECT LSP HOVER REQUEST CALLBACK TRIGGERED!")
                    if err then
                        print("Direct hover error: " .. vim.inspect(err))
                        return
                    end
                    if result and result.contents and result.contents.value then
                        found_hover_content = true
                        -- Розділяємо рядок value на окремі рядки
                        local lines_to_display = vim.split(result.contents.value, '\n')
                        open_documentation_window(lines_to_display, bufnr)
                        return -- Зупиняємося після першого знайденого контенту
                    else
                        print("Direct hover: No content available (or not in expected format).")
                        -- Продовжуємо обробляти інших клієнтів, якщо потрібно
                    end
                end)
            end
        end

        -- Цей vim.schedule може бути викликаний до того, як LSP-сервери дадуть відповідь.
        -- Для складнішої логіки з кількома клієнтами, краще використовувати асинхронні Promise
        -- або лічильник відповідей, щоб знати, коли всі клієнти відповіли.
        -- Але для простоти, якщо єдиний успішний клієнт (Pyright) вже мав відповісти,
        -- ця перевірка може спрацювати.
        vim.schedule(function()
            if not found_hover_content then
                -- print("No hover content found from any LSP client after all attempts.")
                open_documentation_window({"No documentation available."}, bufnr)
            end
        end)

    end, { buffer = bufnr, desc = "Persistent Documentation (direct request)" })

    vim.keymap.set('n', '<leader>kd', function()
        if documentation_window_winid and vim.api.nvim_win_is_valid(documentation_window_winid) then
            vim.api.nvim_win_close(documentation_window_winid, true)
            documentation_window_winid = nil
            documentation_window_bufnr = nil
        end
    end, { buffer = bufnr, desc = "Close Documentation Window" })
end

function M.close_documentation_window()
    if documentation_window_winid and vim.api.nvim_win_is_valid(documentation_window_winid) then
        vim.api.nvim_win_close(documentation_window_winid, true)
        documentation_window_winid = nil
        documentation_window_bufnr = nil
    end
end

return M
