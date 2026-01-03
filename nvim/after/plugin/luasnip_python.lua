local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Função para pegar argumentos e retornar tabela de linhas
local function get_args_table()
    local line = vim.api.nvim_get_current_line()
    local args = line:match("def%s+[%w_]+%s*%((.-)%)") or ""
    local res = {}
    for arg in args:gmatch("([%w_]+)") do
        table.insert(res, arg .. " : type")
        table.insert(res, "    description")
        table.insert(res, "") -- linha em branco entre parâmetros
    end
    return res
end

ls.add_snippets("python", {
    s("npdoc", fmt([[
    """
    {}

    Parameters
    ----------
    {}

    Returns
    -------
    {} : {}
        {}
    """
]], {
        i(3, "Short description of the function"),
        f(get_args_table, {}),
        i(4, "return_value"),
        i(5, "type"),
        i(6, "Description of return value")
    }))
})

-- Mapear <Tab> para expandir ou pular
vim.api.nvim_set_keymap("i", "<Tab>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {expr = true, noremap = true})
vim.api.nvim_set_keymap("s", "<Tab>", "<Plug>luasnip-expand-or-jump", {})

