-- leader 键要在加载插件前设置
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")

-- 没有 lazy.nvim 时自动下载
local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(path) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", path,
  })
end
vim.opt.rtp:prepend(path)

-- 自动加载 lua/plugins/ 下的所有文件
require("lazy").setup({
  spec = { { import = "plugins" } },
})

