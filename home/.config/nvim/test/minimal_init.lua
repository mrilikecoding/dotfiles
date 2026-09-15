-- Minimal init for testing
vim.cmd('set rtp+=' .. vim.fn.getcwd())
-- Add test directory to package.path
local test_dir = vim.fn.stdpath("config") .. "/test"
package.path = vim.fn.stdpath("config") .. "/?.lua;" ..
               test_dir .. "/?.lua;" ..
               test_dir .. "/?/init.lua;" ..
               test_dir .. "/helpers/?.lua;" ..
               package.path
vim.cmd('set noswapfile')
vim.cmd('set nobackup')
vim.cmd('set nowritebackup')
-- Set a generous timeout for CI environments
vim.o.timeout = true
vim.o.timeoutlen = 5000
