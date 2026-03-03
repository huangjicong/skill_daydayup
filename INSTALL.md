# 安装指南

本文档详细说明如何在各个 AI 平台安装 DayDayUp Skill。

## 目录

- [前置要求](#前置要求)
- [Claude Code 安装](#claude-code-安装)
- [OpenCode 安装](#opencode-安装)
- [OpenClaude 安装](#openclaude-安装)
- [配置 Vault 路径](#配置-vault-路径)
- [验证安装](#验证安装)
- [常见问题](#常见问题)

## 前置要求

- Obsidian（用于存储记忆数据）
- Git
- 一个 AI 编程助手（Claude Code / OpenCode / OpenClaude）

## Claude Code 安装

### 方法 1: 克隆到全局 skills 目录（推荐）

```bash
# 创建 skills 目录（如果不存在）
mkdir -p ~/.claude/skills

# 克隆仓库
git clone https://github.com/huangjicong/skill_daydayup.git ~/.claude/skills/daydayup

# 进入目录并运行配置
cd ~/.claude/skills/daydayup
./setup.sh
```

### 方法 2: 项目级安装

```bash
# 在你的项目目录中
cd /path/to/your/project

# 克隆到项目的 .claude 目录
git clone https://github.com/huangjicong/skill_daydayup.git .claude/skills/daydayup

# 配置
cd .claude/skills/daydayup
./setup.sh
```

### 方法 3: 手动配置

1. 克隆仓库到任意位置
2. 运行 `./setup.sh` 配置 vault 路径
3. 在 Claude Code 设置中添加 skill 路径

## OpenCode 安装

### 步骤 1: 克隆仓库

```bash
# 克隆到本地
git clone https://github.com/huangjicong/skill_daydayup.git ~/skills/daydayup
cd ~/skills/daydayup
./setup.sh
```

### 步骤 2: 配置 OpenCode

编辑 `~/.config/opencode/opencode.json`：

```json
{
  "skills": {
    "paths": [
      "/Users/你的用户名/skills/daydayup"
    ]
  }
}
```

### 步骤 3: 重启 OpenCode

```bash
# 重启 OpenCode 使配置生效
```

## OpenClaude 安装

参考 Claude Code 的安装方法。

## 配置 Vault 路径

### 方法 1: 运行配置脚本（推荐）

```bash
cd /path/to/skill_daydayup
./setup.sh
```

脚本会：
1. 自动检测常见 Obsidian vault 路径
2. 提示你输入或确认路径
3. 创建必要的目录结构
4. 可选：添加环境变量到 shell 配置

### 方法 2: 设置环境变量

```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export DAYDAYUP_VAULT_PATH="/Users/你的用户名/Library/Mobile Documents/iCloud~md~obsidian/Documents/life/daydayup"

# 使其生效
source ~/.zshrc  # 或 source ~/.bashrc
```

### 方法 3: 创建配置文件

创建 `~/.daydayup/config.json`：

```json
{
  "vaultPath": "/Users/你的用户名/Library/Mobile Documents/iCloud~md~obsidian/Documents/life/daydayup",
  "configuredAt": "2025-03-03T10:00:00Z",
  "version": "1.0.0"
}
```

### 路径解析优先级

1. 环境变量 `DAYDAYUP_VAULT_PATH`
2. 配置文件 `~/.daydayup/config.json`
3. 自动检测常见路径
4. 提示用户输入

## 验证安装

### Claude Code

1. 重启 Claude Code
2. 输入 `记忆状态`
3. 应该看到统计信息

### OpenCode

1. 重启 OpenCode
2. 输入 `帮我回忆`
3. 应该看到复习列表（如果有待复习卡片）

## 常见问题

### Q: 找不到 vault 路径

**A:** 确保：
1. Obsidian vault 目录存在
2. 路径正确（macOS iCloud 路径包含空格，需要正确引用）
3. 运行 `./setup.sh` 重新配置

### Q: Skill 没有加载

**A:** 检查：
1. Skill 文件是否在正确位置
2. 平台配置是否正确
3. 重启 AI 工具

### Q: 权限问题

**A:** 确保：
```bash
chmod +x setup.sh
```

### Q: iCloud 同步延迟

**A:** 等待 iCloud 同步完成，或手动刷新 Obsidian。

## 下一步

安装完成后：

1. 说 `记住 <内容>` 添加第一条记忆
2. 说 `帮我回忆` 开始复习
3. 在 Obsidian 中打开 vault 查看 dashboard.md

---

有问题？[提交 Issue](https://github.com/huangjicong/skill_daydayup/issues)
