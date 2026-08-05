# dotfiles

---

本仓库管理个人的 dotfiles 配置。

以防忘记，使用方式：

克隆此仓库到本地：

```bash
cd ~/Documents
git clone ...
```

## zsh

为了避免第三方程序安装脚本（例如 fnm、nvm、cargo 等）在修改环境变量时无法写入或破坏符号链接，不使用符号链接直接链接 `.zshrc`。

使用 `source` 引入配置。在默认的 `~/.zshrc` 的头部添加以下内容：

```bash
source ~/Documents/dotfiles/.zshrc # 具体路径根据实际情况修改
```

这样后续其他工具自动写入的环境变量也会安全地写入 `~/.zshrc` 底部，同时也不会污染受 Git 管理的 `dotfiles/.zshrc`。

在终端中激活配置：

```bash
source ~/.zshrc
```

在 Finder 中需要使用 Command + Shift + . 来显示隐藏文件。

## PowerShell

PowerShell 配置也采用相同的管理方式：真正受 Git 管理的是仓库中的 `Microsoft.PowerShell_profile.ps1`，本机的 `$PROFILE` 只负责加载它。这样 PowerShell 仍然可以在本机 profile 中保留机器专属设置，而通用配置只维护一份。

在 Powershell 中，使用 `$PROFILE` 确认配置文件路径，然后编辑此配置文件，在文件头部添加：

```powershell
$dotfilesProfile = "$HOME\Documents\dotfiles\Microsoft.PowerShell_profile.ps1"  # 具体路径根据实际情况修改

if (Test-Path $dotfilesProfile) {
    . $dotfilesProfile
}
```

在终端中激活配置：

```powershell
. $PROFILE
```

可能会提示由于权限限制无法加载配置，需要修改当前用户的执行策略，并且移除本脚本的来源标记：

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
Unblock-File -LiteralPath "$HOME\Documents\dotfiles\Microsoft.PowerShell_profile.ps1"  # 具体路径根据实际情况修改
``