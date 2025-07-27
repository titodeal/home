local M = {}

M.get_capabilities = function()
    local capabilities = vim.tbl_extend("force", {}, vim.lsp.protocol.make_client_capabilities())
    -- local base = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return require('cmp_nvim_lsp').default_capabilities(capabilities)
end

return M
