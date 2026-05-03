-- Define symbols (feel free to change these)
local symbols = { error = " ", warn = " ", info = " ", hint = "   " }

---Get diagnostic counts and format them into a string
---@return string
local function diagnostic_status()
	local counts = vim.diagnostic.count(0) -- Get counts for current buffer
	local items = {}

	-- Check each level and add to table if count > 0
	if counts[vim.diagnostic.severity.ERROR] then
		table.insert(items, "%#DiagnosticError#" .. symbols.error .. counts[vim.diagnostic.severity.ERROR])
	end
	if counts[vim.diagnostic.severity.WARN] then
		table.insert(items, "%#DiagnosticWarn#" .. symbols.warn .. counts[vim.diagnostic.severity.WARN])
	end
	if counts[vim.diagnostic.severity.INFO] then
		table.insert(items, "%#DiagnosticInfo#" .. symbols.info .. counts[vim.diagnostic.severity.INFO])
	end
	if counts[vim.diagnostic.severity.HINT] then
		table.insert(items, "%#DiagnosticHint#" .. symbols.hint .. counts[vim.diagnostic.severity.HINT])
	end

	return #items > 0 and table.concat(items, " ") .. " " or ""
end

local function lsp_status()
	local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
	if #attached_clients == 0 then
		return ""
	end
	local names = vim.iter(attached_clients)
		:map(function(client)
			local name = client.name:gsub("language.server", "ls")
			return name
		end)
		:totable()
	return "[" .. table.concat(names, ", ") .. "]"
end

function _G.statusline()
	return table.concat({
		"%f",
		"%h%w%m%r",
		"%=",
		diagnostic_status(), -- Added here
		lsp_status(),
		" %-14(%l,%c%V%)",
		"%P",
	}, " ")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
