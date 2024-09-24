local M = {}

-- Function to set working directory to the closest git root
function M.set_git_root()
	-- Save the current working directory
	local cwd = vim.fn.getcwd()
	-- Get the directory of the currently opened file
	local file_dir = vim.fn.expand("%:p:h")
	-- Change directory to the file's directory
	vim.cmd("lcd " .. file_dir)

	-- Get the git root directory
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	-- If a git root is found, set it as the working directory
	if git_root and vim.fn.isdirectory(git_root) == 1 then
		vim.cmd("cd " .. git_root)
	else
		-- Restore the original working directory if not a git repo
		vim.cmd("cd " .. cwd)
	end
end

-- Set up an autocommand to call the set_git_root function
function M.setup()
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			M.set_git_root()
		end,
	})
end

return M
