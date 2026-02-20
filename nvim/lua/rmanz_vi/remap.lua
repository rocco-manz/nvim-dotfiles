vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":Ex<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

vim.keymap.set("v", "J", ":m '>+2<CR>gv=gv")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

local function smart_resize(direction)
	local pos = vim.api.nvim_win_get_position(0) -- 0 refers to the current window
	if direction == "L" then
		if tonumber(pos[2]) < 1 then
			vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) + 50)
		else
			vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) - 50)
		end
	elseif direction == "H" then
		if pos[2] < 1 then
			vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) - 50)
		else
			vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) + 50)
		end
	end
end

vim.keymap.set("n", "<C-w>L", function()
	smart_resize("L")
end)
vim.keymap.set("n", "<C-w>H", function()
	smart_resize("H")
end)
