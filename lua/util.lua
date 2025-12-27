local M = {}

function M.ensure_binary_installed(bin, install_cmd)
	if vim.fn.exepath(bin) then
		-- binary exists already
		return
	end
	local install_result = vim.system(install_cmd)
	if install_result ~= 0 then
		vim.notify(string.format("Error installing %s:\n", bin) .. M.sanitize_colors(string(install_result.stdout)),
			vim.log.levels.ERROR)
	end
end

function M.sanitize_colors(s)
	return s:gsub("\27%[[0-9;]*m", "")
end

function M.lua_ls_on_init(client)
	local path = vim.tbl_get(client, "workspace_folders", 1, "name")
	if not path then
		return
	end
	-- override the lua-language-server settings for Neovim config
	client.settings = vim.tbl_deep_extend('force', client.settings, {
		Lua = {
			runtime = {
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	})
end

function M.code_action_sync(action_kind)
	local params = vim.lsp.util.make_range_params(0, 'utf-8')
	params.context = { only = { action_kind }, diagnostics = {} }

	-- buf_request_sync halts execution until the server responds
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

	for _, res in pairs(result or {}) do
		for _, action in pairs(res.result or {}) do
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
			end
		end
	end
end

function M.isSSH()
	return vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION
end

function M.isV12()
	return vim.fn.has("nvim-0.12") == 1
end

return M
