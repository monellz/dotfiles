local parsers = {
  "bash", "c", "cpp", "diff", "git_config", "git_rebase", "gitcommit", "json", "lua",
  "markdown", "markdown_inline", "python", "query", "regex", "rust", "toml", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- tree-sitter 由 chezmoi 安装。这里真的运行一下，跑不起来就不编译，
      -- 继续用自带 parser 和正则高亮，不报错
      local ok, r = pcall(function() return vim.system({ "tree-sitter", "--version" }):wait() end)
      if ok and r.code == 0 then require("nvim-treesitter").install(parsers) end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          -- 没有 parser 的文件类型退回正则高亮
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
