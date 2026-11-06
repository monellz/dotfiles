# dotfiles

用 [chezmoi](https://www.chezmoi.io/) 管理的个人配置，适用于两类机器：

| 类型 | 装哪些 |
| --- | --- |
| `macos` | 终端配置 + ghostty，代理走本机 sing-box 的 7890 |
| `server` | 终端配置 + bash 配置 + 下载 fzf、zoxide、starship、yazi、fd、rg、dust，代理走 ssh 转发过来的 9870 |

终端配置指 zsh、vim、tmux、git、ssh 通用设置、yazi。

别名、代理、PATH 这些 zsh 和 bash 都用的设置在 `~/.config/shell/common.sh`，两边各自读取。
服务器上通常没有 zsh 又没有 root，所以也配了 bash，效果尽量和 zsh 一致（vim 模式、按前缀搜索历史等）：

- `~/.config/shell/bashrc.bash`：bash 的配置本身
- `~/.bashrc`：不接管，原有内容（conda、module 等）保持不变，只在末尾追加一行读取上面的文件
- `~/.bash_profile`：服务器上没有 `.bash_profile` / `.bash_login` / `.profile` 时才创建，
  让 ssh 登录（登录 shell）也会读 `~/.bashrc`

这个仓库是公开的，不放任何密钥或内部地址。ssh 主机清单在私有的 envkit 仓库里（git-crypt 加密），
由各机器自己放到 `~/.ssh/config.d/`，`~/.ssh/config` 会自动读取那里的文件。

## 安装

自己的机器（会询问机器类型，必须从 macos / server 里明确选一个）：

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply monellz
```

远程服务器：只装一次，装完删掉 chezmoi 程序和仓库副本，服务器上只留下配置文件，
以及下载到 `~/.local/bin` 的 fzf、zoxide、starship、yazi、fd、rg、dust（版本见 `.chezmoiexternal.toml.tmpl`）。
在带 `RemoteForward 9870` 的 ssh 会话里执行，下载经本机的 sing-box：

```bash
export https_proxy=http://127.0.0.1:9870
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot --promptChoice kind=server monellz
```

更新时重新执行同一条命令。服务器上有 zsh 的话可以 `chsh -s $(which zsh)` 改用 zsh，没有就用 bash。`--one-shot` 会直接覆盖服务器上已有的同名文件，不会询问；
服务器上原有的 ssh 主机配置先挪到 `~/.ssh/config.d/` 下，就不会丢。

## 日常使用

```bash
chezmoi update          # 拉取仓库最新内容并装到 home 目录
chezmoi diff            # 看看 apply 会改动哪些文件
chezmoi edit ~/.zshrc   # 改源码（模板文件改的是 .tmpl），再 chezmoi apply
chezmoi re-add          # 程序自己改了配置文件，把改动收回仓库
chezmoi cd              # 进入源码目录提交、推送
```

## 机器之间的差别写在哪

- `.chezmoi.toml.tmpl`：init 时确定机器类型，记在 `~/.config/chezmoi/chezmoi.toml`
- `.chezmoiignore`：按机器类型跳过不需要的文件
- `.chezmoiexternal.toml.tmpl`：从外部下载的内容（服务器上的 fzf、zoxide、starship、yazi、fd、rg、dust，固定版本）
- `modify_dot_bashrc`、`create_dot_bash_profile`：只修改、只在不存在时创建，不覆盖服务器上已有的文件
- `*.tmpl`：内容因机器而异的配置，目前是 `dot_config/shell/common.sh.tmpl`（代理端口）和 `dot_gitconfig.tmpl`（gh 的路径）

改动机器类型：编辑 `~/.config/chezmoi/chezmoi.toml` 里的 `kind`，或者 `chezmoi init --promptChoice kind=...`。
