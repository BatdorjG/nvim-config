
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local languages = {
                "lua",
                "c",
                "cpp",
                "typescript",
                "javascript",
                "go",
                "rust",
                "dockerfile",
                "make",
                "nginx",
                "odin",
                "sql",
                "zig",
                "bash",
                "vim",
                "vimdoc",
                "query",
            }

            require("nvim-treesitter").install(languages)

            -- Enable Treesitter highlighting for supported buffers.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })

            -- Use Treesitter-based indentation.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if lang then
                        pcall(function()
                            vim.bo[args.buf].indentexpr =
                                "v:lua.require'nvim-treesitter'.indentexpr()"
                        end)
                    end
                end,
            })
        end,
    },
}

