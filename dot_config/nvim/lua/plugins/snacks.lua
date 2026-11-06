return {
  { "nvim-mini/mini.icons", lazy = false, opts = {} },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    terminal = {},
    opts = {
      explorer = { replace_netrw = true }, -- nvim 打开目录时用这个文件树
      picker = {
        sources = {
          explorer = { hidden = true, layout = { auto_hide = { "input" } } },
          files = { hidden = true },  -- 能搜到 .github 这类隐藏文件
          grep = { hidden = true },
        },
      },
      lazygit = {},
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "文件树" },
      { "<leader><space>", function() Snacks.picker.files() end, desc = "找文件" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "全局搜索" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "已打开的文件" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "最近文件" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "搜索光标下的词", mode = { "n", "x" } },
      { "<leader>fR", function() Snacks.picker.resume() end, desc = "回到上次查找" },
      { "<C-/>", function() Snacks.terminal() end, desc = "终端", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "终端", mode = { "n", "t" } },
      -- lazy git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "lazygit 提交记录" },
    },
  },
}
