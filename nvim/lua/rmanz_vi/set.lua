vim.g.neoterm_default_mod = "botright"
vim.g.neoterm_reopen_on_resize = 1
vim.g.neoterm_keep_term_open = 2
vim.g.mapleader = " "

-- Enclose text between spaces (or line boundaries) with quotes
vim.keymap.set('n', '<leader>q', function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed
  
  -- Find start (search backwards for space or start of line)
  local start = col
  while start > 1 and line:sub(start - 1, start - 1) ~= ' ' do
    start = start - 1
  end
  
  -- Find end (search forwards for space or end of line)
  local end_pos = col
  while end_pos <= #line and line:sub(end_pos, end_pos) ~= ' ' do
    end_pos = end_pos + 1
  end
  end_pos = math.min(end_pos - 1, #line) -- Don't go past end of line
  
  -- Insert quotes
  local new_line = line:sub(1, start - 1) .. '"' .. line:sub(start, end_pos) .. '"' .. line:sub(end_pos + 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Enclose word in quotes" })




vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.clipboard = ""

vim.opt.mouse = ""
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

vim.g.neoterm_default_mod = "botright"
vim.g.neoterm_reopen_on_resize = 1
vim.g.neoterm_keep_term_open = 2
