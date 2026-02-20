-- ~/.config/nvim/lua/rmanz_vi/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
	result.diagnostics = vim.tbl_filter(function(d)
		return not d.message:match("ephemeral")
	end, result.diagnostics)
	vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

-- ============================================================================
-- Global LSP keymaps & formatting overrides
-- ============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			result.diagnostics = vim.tbl_filter(function(d)
				return not d.message:match("ephemeral")
			end, result.diagnostics)
			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local bufnr = ev.buf

		-- Disable LSP formatting for clients where we use conform.nvim
		if
			client
			and (
				client.name == "ts_ls"
				or client.name == "eslint"
				or client.name == "pyright"
				or client.name == "jdtls"
				or client.name == "rust_analyzer"
			)
		then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	end,
})

-- ============================================================================
-- Plugins
-- ============================================================================
require("lazy").setup({
	-- Essential plugins (load immediately)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- LSP: nvim-lspconfig provides default configs, we customize and enable here
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 900,
		config = function()
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						validate = true,
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
						},
					},
				},
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("gitlab_ci_ls", {
				filetypes = { "yaml" },
				root_markers = { ".gitlab-ci.yml", ".gitlab-ci.yaml" },
				settings = {
					gitlabCiLs = {
						cache = {
							path = vim.fn.stdpath("cache") .. "/gitlab-ci-ls",
						},
					},
				},
			})

			-- OpenSIPS LSP (installed via pip, not Mason)
			vim.lsp.config("opensips_lsp", {
				cmd = { vim.fn.expand("~/.local/bin/opensips-lsp") },
				filetypes = { "opensips" },
				root_markers = { ".git", "opensips.cfg" },
			})

			-- Enable all servers EXCEPT jdtls (handled by nvim-jdtls)
			vim.lsp.enable({
				"kotlin_language_server",
				"ts_ls",
				"eslint",
				"lua_ls",
				"rust_analyzer",
				"jsonls",
				"yamlls",
				"pyright",
				"terraformls",
				"gitlab_ci_ls",
				"opensips_lsp",
			})
		end,
	},

	-- Mason (package manager for LSP servers, formatters, linters)
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				-- IMPORTANT: do NOT auto-enable servers, we handle that manually
				automatic_enable = false,
				ensure_installed = {
					"kotlin_language_server",
					"ts_ls",
					"eslint",
					"lua_ls",
					"rust_analyzer",
					"jsonls",
					"yamlls",
					"pyright",
					"terraformls",
					"gitlab_ci_ls",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"jdtls",
					"google-java-format",
					"ktlint",
					"prettier",
					"prettierd",
					"stylua",
					"eslint_d",
					"black",
					"isort",
					"rustfmt",
					"yamllint",
					"jsonlint",
					"jq",
					"yamlfmt",
					"shfmt",
				},
			})
		end,
	},

	-- Java LSP (dedicated plugin, loads only for Java files)
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local root_dir = require("jdtls.setup").find_root({
						".git",
						"mvnw",
						"gradlew",
						"pom.xml",
						"build.gradle",
					}) or vim.fn.getcwd()

					local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
					local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

					require("jdtls").start_or_attach({
						cmd = {
							vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls",
							"-data",
							workspace_dir,
						},
						root_dir = root_dir,
						settings = {
							java = {
								configuration = {
									runtimes = {
										{
											name = "JavaSE-17",
											path = "/home/linuxbrew/.linuxbrew/Cellar/openjdk@17/17.0.18/libexec",
											default = true,
										},
										{
											name = "JavaSE-21",
											path = "/home/linuxbrew/.linuxbrew/Cellar/openjdk@21/21.0.10/libexec",
										},
									},
								},
							},
						},
					})
				end,
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-k>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})
		end,
	},

	-- Formatting with conform.nvim
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					java = { "google-java-format" },
					kotlin = { "ktlint" },

					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
					scss = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettierd", "prettier", stop_after_first = true },
					terraform = { "terraform_fmt" },
					tf = { "terraform_fmt" },
					bash = { "shfmt" },
					powershell = { "powershell_es" },
					sh = { "shfmt" },
					json = { "jq" },
					yaml = { "yamlfmt" },
					xml = { "xmlformat" },
				},
			})
		end,
	},

	-- File tree (lazy load on command)
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		keys = {
			{ "<leader>f", ":NvimTreeToggle<CR>", desc = "Toggle file tree" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				sort = { sorter = "case_sensitive" },
				view = { width = 30 },
				renderer = { group_empty = true },
				filters = { dotfiles = true },
			})
		end,
	},

	-- Telescope (lazy load on command)
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{
				"<leader>pf",
				function()
					require("telescope.builtin").find_files({
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob",
							"!.git/*",
							"--glob",
							"!**/.terraform/**",
						},
					})
				end,
			},
			{
				"<C-p>",
				function()
					require("telescope.builtin").git_files()
				end,
			},
			{
				"<leader>ps",
				function()
					require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
				end,
			},
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "^%.git/", "node_modules", "vendor", "__pycache__", "target", "dist" },
				},
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Newer nvim-treesitter stores queries under runtime/
			vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

			local wanted = { "java", "kotlin", "c", "python", "lua", "vim", "vimdoc", "query", "yaml" }
			local parser_dir = vim.fn.expand("/var/home/rocco/.local/share/nvim/site/parser")
			local missing = {}
			for _, p in ipairs(wanted) do
				if vim.fn.filereadable(parser_dir .. p .. ".so") == 0 then
					table.insert(missing, p)
				end
			end
			if #missing > 0 then
				require("nvim-treesitter").install(missing)
			end
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},

	-- Harpoon (lazy load on keymap)
	{
		"theprimeagen/harpoon",
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon.mark").add_file()
				end,
			},
			{
				"<C-e>",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
			},
			{
				"<C-h>",
				function()
					require("harpoon.ui").nav_file(1)
				end,
			},
			{
				"<C-t>",
				function()
					require("harpoon.ui").nav_file(2)
				end,
			},
			{
				"<C-n>",
				function()
					require("harpoon.ui").nav_file(3)
				end,
			},
			{
				"<C-s>",
				function()
					require("harpoon.ui").nav_file(4)
				end,
			},
		},
	},

	-- Terminal (lazy load)
	{
		"kassio/neoterm",
		cmd = { "Tnew", "T", "Ttoggle" },
		keys = {
			{ "<leader>pe", ":TaskThenExit " },
			{ "<leader>pp", ":TaskPersist " },
			{ "<leader>pt", ":1Ttoggle<CR><ESC>" },
			{ "<leader>e", ":TaskPersist<CR>" },
		},
		dependencies = { "MunifTanjim/nui.nvim" },
	},

	-- Git (lazy load on command)
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
		keys = {
			{ "<leader>gs", vim.cmd.Git },
		},
	},

	-- Undo tree (lazy load)
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle },
		},
	},

	-- Autopairs (load on insert mode)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					java = false,
				},
				disable_filetype = { "TelescopePrompt" },
				fast_wrap = {
					map = "<M-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "xml",
	callback = function()
		vim.treesitter.stop()
	end,
})
