# dotfiles

---

本仓库管理个人的 dotfiles 配置。

以防忘记，使用方式：

克隆此仓库到本地：

```bash
cd ~/Documents
git clone git@github.com:Klee1453/dotfiles.git
```

## zsh

以 `.zshrc` 为例，在 home 目录下创建符号链接并验证：

```bash
ln -s ~/Documents/dotfiles/.zshrc ~/.zshrc
ls -l ~/.zshrc
```

在终端中激活配置：

```bash
source ~/.zshrc
```

在 finder 中需要使用 ⌘ + ⇧ + . 来显示隐藏文件。

## PowerShell

Powershell 的配置文件有比起通过 git 管理更优雅的方式：通过 OneDrive 同步。

通过 `echo $PROFILE` 获取 PowerShell 配置文件路径。

在 OneDrive 创建同名文件。此处以 `WindowsPowerShell\Microsoft.PowerShell_profile.ps1` 为例。

在配置文件中添加以下内容，并替换路径中的 `username` 为实际用户名：

```powershell
. "$env:C:\Users\username\OneDrive\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
```

这样就能够使用 OneDrive 自动同步 PowerShell 配置文件了。

由于采用 OneDrive 进行同步，本仓库中的 `Microsoft.PowerShell_profile.ps1` 为手动备份的配置文件。