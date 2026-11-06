local opt = vim.opt

-- 显示
opt.number = true          -- 显示行号
opt.relativenumber = true  -- 显示相对行号
opt.signcolumn = "yes"     -- 左侧固定留一列，之后 git、诊断标记出现时文字不跳动
opt.cursorline = true      -- 高亮当前行
opt.scrolloff = 6          -- 光标上下至少留 6 行
opt.wrap = false           -- 长行不折行
opt.laststatus = 3    -- 所有窗口共用一条状态栏
opt.showmode = false  -- 状态栏里已经有模式，不用在命令行重复显示
opt.splitright = true      -- 新窗口开在右边
opt.splitbelow = true      -- 新窗口开在下边
opt.fillchars = { diff = "╱", eob = " " }  -- diff 空行用斜线填充，文件尾不显示 ~
opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", "linematch:60" })


-- 缩进：和 ~/.vimrc 一样用 4 空格
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- 搜索：全小写时忽略大小写，含大写时区分
opt.ignorecase = true
opt.smartcase = true

-- 行为
opt.mouse = "a"            -- 支持鼠标
opt.undofile = true        -- 关掉文件后仍能撤销
opt.confirm = true         -- 退出时有未保存内容就询问，而不是报错
opt.timeoutlen = 400  -- 按下前缀后，等 400 毫秒就弹出提示

-- 剪贴板：yank 直接进系统剪贴板
opt.clipboard = "unnamedplus"
if vim.env.SSH_CONNECTION then
  -- ssh 时用 OSC52 把内容写回本机终端
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = { lines = { "" }, regtype = "v" }
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last = { lines = lines, regtype = regtype }
      send(lines, regtype)
    end
  end
  -- 终端一般不允许读剪贴板，所以 p 用 nvim 里最后一次 yank 的内容
  local function paste()
    return { last.lines, last.regtype }
  end
  vim.g.clipboard = {
    name = "osc52",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
