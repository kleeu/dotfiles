# dotfiles

---

本仓库管理个人的 dotfiles 配置。

以防忘记，使用方式：

克隆此仓库到本地：

```bash
cd ~/Documents
git clone git@github.com:Klee1453/dotfiles.git
```

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
