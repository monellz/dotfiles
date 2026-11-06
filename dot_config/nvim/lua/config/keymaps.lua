local map = vim.keymap.set

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "全部退出" })

-- terminal 模式下直接用 <C-w> 切窗口，不必先手动退出。
-- 不映射 <Esc>，避免 claude 等 TUI 的 Esc 被 timeoutlen 拖慢。
map("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "退出 terminal 模式并切窗口" })
