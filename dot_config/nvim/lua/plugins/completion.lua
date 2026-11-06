return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- 带版本号的 tag 才有预编译的模糊匹配库
    event = { "InsertEnter", "CmdlineEnter" }, -- 进入插入模式或命令行时才加载
    opts = {
      keymap = { preset = "enter" }, -- 回车确认
      completion = {
        documentation = { auto_show = true }, -- 选中候选项时显示文档
      },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
}
