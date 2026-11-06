local tools = {
  ["lua-language-server"] = "lua-language-server",
  pyright = "pyright-langserver",
  ruff = "ruff",
  ["rust-analyzer"] = "rust-analyzer",
  clangd = "clangd",
  -- tree-sitter目前统一用chezmoi装，避免有些平台glibc版本不够的问题
  -- ["tree-sitter-cli"] = "tree-sitter",
}
-- mason 没有 arm64 Linux 的 clangd，此时不用mason装，而让外部工具装
-- 目前是让chezmoi判断到arm64机器后，基于PyPI安装clangd
if jit.arch == "arm64" and vim.uv.os_uname().sysname == "Linux" then tools.clangd = nil end

-- 要启用的语言服务器
local servers = { "lua_ls", "pyright", "ruff", "clangd", "rust_analyzer" }

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = function()
      -- append：PATH 里自己装的程序优先于 mason 下载的
      require("mason").setup({ PATH = "append" })
      local registry = require("mason-registry")
      registry.refresh(function()
        for name, bin in pairs(tools) do
          if vim.fn.executable(bin) == 0 and registry.has_package(name) then
            local pkg = registry.get_package(name)
            if not pkg:is_installed() and not pkg:is_installing() then pcall(pkg.install, pkg) end
          end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, prefix = "●" }, -- 行尾显示诊断
      })
      -- 让 lua_ls 认识 vim 这个全局变量，改配置时不报错
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
          },
        },
      })
      vim.lsp.enable(servers)

      -- 语言服务器连上文件时才设置这些按键
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", function() Snacks.picker.lsp_definitions() end, "跳到定义")
          map("gr", function() Snacks.picker.lsp_references() end, "查引用")
          map("gI", function() Snacks.picker.lsp_implementations() end, "跳到实现")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "跳到类型")
          map("<leader>cr", vim.lsp.buf.rename, "重命名")
          map("<leader>ca", vim.lsp.buf.code_action, "代码操作", { "n", "x" })
          map("<leader>cs", function() Snacks.picker.lsp_symbols() end, "当前文件符号")
          map("<leader>cd", vim.diagnostic.open_float, "当前行诊断")
          map("<leader>cD", function() Snacks.picker.diagnostics() end, "项目诊断")
          map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "下一个诊断")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "上一个诊断")
        end,
      })
    end,
  },
}
