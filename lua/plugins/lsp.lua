return {
    {
	"neovim/nvim-lspconfig",
	dependencies = {
	    "williamboman/mason.nvim",
	    "saghen/blink.cmp",
	},

	config = function()
	    local capabilities = require("blink.cmp").get_lsp_capabilities() 
	    local servers = {
		    "asm-lsp",
		    "bacon-ls",
		    "bash-language-server",
		    "bqls",
		    "c3-lsp",
		    "clangd",
		    "fish-lsp",
		    "gopls",
		    "jls",
		    "lua-language-server",
		    "ols",
		    "pyrefly",
		    "tailwindcss-language-server",
            "tinymist",
		    "zls",
        }

	    for _, server in ipairs(servers) do
		    vim.lsp.config(server, {
		        capabilities = capabilities,
		    })
	    
		    vim.lsp.enable(server)
	    end

        vim.lsp.config("tinymist", {
            capabilities = capabilities,
                settings = {
                    formatterMode = "typstyle",
                    exportPdf = "onSave",
                },
            })
	    end,
    },
}
