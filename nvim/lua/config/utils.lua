-- Utility functions for neovim configuration

local M = {}

-- Optimized function to show search count in statusline
M.search_count = function()
	-- Early exit if search highlighting is not active
	if vim.v.hlsearch ~= 1 or vim.fn.getreg("/") == "" then
		return ""
	end

	local result = vim.fn.searchcount({ recompute = 0, maxcount = 999 })
	if vim.tbl_isempty(result) then
		return ""
	end

	-- Handle incomplete results more efficiently
	if result.incomplete == 1 then
		return " [?/??]"
	end

	-- Handle max count exceeded cases with single condition
	if result.incomplete == 2 then
		local current_display = result.current > result.maxcount and (">" .. result.current) or result.current
		local total_display = result.total > result.maxcount and (">" .. result.total) or result.total
		return " [" .. current_display .. "/" .. total_display .. "]"
	end

	return " [" .. result.current .. "/" .. result.total .. "]"
end

return M