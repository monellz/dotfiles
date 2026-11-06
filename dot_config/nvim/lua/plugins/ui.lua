return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "H", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个文件" },
      { "L", "<cmd>BufferLineCycleNext<cr>", desc = "下一个文件" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "关闭当前文件" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "关闭其他文件" },
    },
    opts = {
      options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        always_show_bufferline = false, -- 只开一个文件时不显示
        diagnostics = "nvim_lsp",       -- 标签上显示错误数量
        offsets = { { filetype = "snacks_layout_box", text = "Explorer" } },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { globalstatus = true, section_separators = "", component_separators = "│" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "diagnostics", { "filename", path = 1 } }, -- path = 1 显示相对路径
        lualine_x = { "lsp_status", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix", -- 显示在右下角，不挡代码
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunk" },
        { "<leader>q", group = "quit" },
      },
    },
  },
}
