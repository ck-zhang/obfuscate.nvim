local M = {}

local ns = nil
local enabled = false

local old_lines = {}

local cache = {}

local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

local function get_random_letter()
	local idx = math.random(#letters)
	return letters:sub(idx, idx)
end

local function obfuscate_line(buf, line_idx, new_line, old_line)
	vim.api.nvim_buf_clear_namespace(buf, ns, line_idx, line_idx + 1)

	local cached_line = cache[line_idx] or {}

	if new_line ~= old_line then
		for col = 1, #new_line do
			local char = new_line:sub(col, col)
			if char:match("%a") then
				if old_line and col <= #old_line and old_line:sub(col, col) == char and cached_line[col] then
				else
					cached_line[col] = get_random_letter()
				end
			else
				cached_line[col] = nil
			end
		end

		if old_line and #old_line > #new_line then
			for col = #new_line + 1, #old_line do
				cached_line[col] = nil
			end
		end

		cache[line_idx] = cached_line
	end

	for col, rand_char in pairs(cached_line) do
		if col <= #new_line then
			vim.api.nvim_buf_set_extmark(buf, ns, line_idx, col - 1, {
				virt_text = { { rand_char, "" } },
				virt_text_pos = "overlay",
				hl_mode = "combine",
			})
		end
	end
end

local function full_obfuscate(buf)
	old_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	cache = {}

	for lnum, line_text in ipairs(old_lines) do
		local line_idx = lnum - 1
		cache[line_idx] = {}

		for col = 1, #line_text do
			local char = line_text:sub(col, col)
			if char:match("%a") then
				cache[line_idx][col] = get_random_letter()
			end
		end

		vim.api.nvim_buf_clear_namespace(buf, ns, line_idx, line_idx + 1)
		for col, rand_char in pairs(cache[line_idx]) do
			vim.api.nvim_buf_set_extmark(buf, ns, line_idx, col - 1, {
				virt_text = { { rand_char, "Normal" } },
				virt_text_pos = "overlay",
				hl_mode = "combine",
			})
		end
	end
end

local function partial_obfuscate(buf)
	local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	for lnum, new_line in ipairs(new_lines) do
		local old_line = old_lines[lnum] or ""
		local line_idx = lnum - 1
		obfuscate_line(buf, line_idx, new_line, old_line)
	end
	old_lines = new_lines
end

function M.toggle()
	if not ns then
		ns = vim.api.nvim_create_namespace("obfuscate_ns")
	end
	enabled = not enabled

	if enabled then
		local buf = 0
		full_obfuscate(buf)
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			group = vim.api.nvim_create_augroup("obfuscate_group", { clear = true }),
			callback = function()
				partial_obfuscate(buf)
			end,
		})
	else
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		vim.api.nvim_clear_autocmds({ group = "obfuscate_group" })
		cache = {}
		old_lines = {}
	end
end

return M
