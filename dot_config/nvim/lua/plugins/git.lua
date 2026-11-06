return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- 打开文件时才加载
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "下一处改动")
        map("n", "[h", function() gs.nav_hunk("prev") end, "上一处改动")
        map({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", "暂存这处改动")
        map({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", "撤销这处改动")
        map("n", "<leader>hp", gs.preview_hunk, "预览这处改动")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "这一行的 blame")
        map("n", "<leader>hB", gs.blame, "整个文件的 blame")
      end,
    },
  },
  {
    "dlyongemallo/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "当前分支相对于main的改动 (PR Review)" },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "工作区 diff" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "当前文件历史" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "仓库历史" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "关闭 diff" },
    },
    opts = { enhanced_diff_hl = true },
  },
}
