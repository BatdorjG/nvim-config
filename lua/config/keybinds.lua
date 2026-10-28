vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

local term = {
    buf = nil,
    win = nil,
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = function(event)
        vim.keymap.set("n", "<leader>tp", function()
            vim.cmd("TypstPreviewToggle")
        end, { buffer = event.buf, desc = "Toggle Typst Live Preview" })
    end,
})

vim.keymap.set("n", "<leader>r", function()

    if vim.bo.modified then
	vim.cmd("silent write")
    end

    local file_ext = vim.fn.expand("%:e")
    local current_file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fs.dirname(current_file)
    local bin_name = vim.fn.expand("%:t:r")
    local cmd

    local function esc(p)
	return vim.fn.shellescape(p)
    end

    local function run_in_term(cmd)
	if not term.buf or not vim.api.nvim_buf_is_valid(term.buf) or not term.win or not vim.api.nvim_win_is_valid(term.win) then
	    vim.cmd("botright 12split")
	    vim.cmd("terminal")

	    term.buf = vim.api.nvim_get_current_buf()
	    term.win = vim.api.nvim_get_current_win()
	else
	    vim.api.nvim_set_current_win(term.win)
	end
	
	vim.api.nvim_chan_send(
	    vim.bo[term.buf].channel,
	    cmd .. "\n"
	)

	vim.cmd("startinsert")
    end

    if file_ext == "zig" then
    	local root = vim.fs.root(current_file, "build.zig")
	if root then
	    cmd = "cd " .. esc(root) .. " && zig build run"
	else
	    cmd = "zig run " .. esc(current_file)
	end

    elseif file_ext == "c" or file_ext == "cpp" then
	local compiler = (file_ext == "cpp") and "clang++" or "clang"
	local root = vim.fs.root(current_file, { "Makefile", "makefile", "GNUmakefile" , "CMakeLists.txt" })
	if root then
	    local a = vim.fs.root(current_file, { "CMakeLists.txt" })
	    if a then 
		cmd = "cd " .. esc(root) .. " && cmake -B build && cmake --build build"
	    else
		cmd = "cd " .. esc(root) .. " && make"
	    end
	else
	    cmd = "cd " .. esc(dir) .. " && " .. compiler .." -o " .. esc(bin_name) .. " " .. esc(current_file) .. " && ./" .. esc(bin_name)
	end
    elseif file_ext == "py" then
	cmd = "python3 " .. esc(current_file)
    elseif file_ext == "sh" then 
	cmd = "bash " .. esc(current_file)
    elseif file_ext == "odin" then
	local parent = vim.fs.basename(vim.fs.dirname(current_file)) 
	if parent == "src" then
	    local project_dir = vim.fs.dirname(dir)
	    cmd = "cd " .. esc(project_dir) .. " && odin run src/"
	else
	    cmd = "cd " .. esc(dir) .. " && odin run ."
	end
    elseif file_ext == "rs" then
	local root = vim.fs.root(current_file, "Cargo.toml")
	if root then
	    cmd = "cd " .. esc(root) .. " && cargo run"
	else
	    cmd = "rustc " .. esc(current_file) .. " -o " .. esc(dir .. "/" .. bin_name) .. " && " .. esc(dir .. "/" .. bin_name)
	end
    else
	vim.notify("No runner configured for '." .. file_ext .. "'", vim.log.levels.WARN)
	return
    end

    run_in_term(cmd)

end)
