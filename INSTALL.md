# 安装指南

本文档详细说明如何在各个 AI 平台安装 DayDayUp Skill。

## 目录

- [前置要求](#前置要求)
- [重要：多平台安装说明](#重要多平台安装说明)
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

## 重要：多平台安装说明

### 核心设计原则

DayDayUp 采用**数据与 Skill 分离**的设计：

```
┌─────────────────────────────────────────────────────────┐
│                    全局配置                              │
│            ~/.daydayup/config.json                      │
│            （所有平台共享）                               │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  Vault 数据目录                          │
│    ~/Library/.../obsidian/Documents/life/daydayup/      │
│    ├── cards/     (记忆卡片)                             │
│    ├── reviews/   (复习记录)                             │
│    └── templates/ (模板)                                 │
└─────────────────────────────────────────────────────────┘
          ▲              ▲              ▲
          │              │              │
    ┌─────┴─────┐  ┌─────┴─────┐  ┌─────┴─────┐
    │Claude Code│  │  OpenCode │  │ OpenClaude│
    │  (Skill)  │  │  (Skill)  │  │  (Skill)  │
    └───────────┘  └───────────┘  └───────────┘
```

### 安装流程

1. **首次安装**：在任意平台安装并运行 `./setup.sh`
2. **后续安装**：在其他平台安装时，**无需再次运行 setup.sh**
3. **数据共享**：所有平台自动使用相同的 vault 数据

### 配置工具命令

```bash
# 查看当前配置状态
./setup.sh --status

# 重置配置（不会删除数据）
./setup.sh --reset

# 运行配置向导
./setup.sh
```

## Claude Code 安装

### 方法 1: 克隆到全局 skills 目录（推荐）

```bash
# 创建 skills 目录（如果不存在）
mkdir -p ~/.claude/skills

# 克隆仓库
git clone https://github.com/huangjicong/skill_daydayup.git ~/.claude/skills/daydayup

# 首次安装：运行配置
cd ~/.claude/skills/daydayup
./setup.sh

# 后续在其他机器安装：检查状态
./setup.sh --status
```

### 方法 2: 项目级安装

```bash
# 在你的项目目录中
cd /path/to/your/project

# 克隆到项目的 .claude 目录
git clone https://github.com/huangjicong/skill_daydayup.git .claude/skills/daydayup

# 如果是首次安装，运行配置
cd .claude/skills/daydayup
./setup.sh
```

## OpenCode 安装

### 步骤 1: 克隆仓库

```bash
# 克隆到本地
git clone https://github.com/huangjicong/skill_daydayup.git ~/skills/daydayup
cd ~/skills/daydayup

# 如果之前在 Claude Code 配置过，直接检查状态
./setup.sh --status

# 如果是首次安装，运行配置
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

重启 OpenCode 使配置生效。

## OpenClaude 安装

参考 Claude Code 的安装方法。

## 配置 Vault 路径

### 方法 1: 运行配置脚本（推荐）

```bash
cd /path/to/skill_daydayup
./setup.sh
```

脚本会：
1. 检查是否已有全局配置
2. 如果有，显示现有数据统计
3. 自动检测常见 Obsidian vault 路径
4. 提示你输入或确认路径
5. 创建必要的目录结构（**不会删除现有数据**）
6. 可选：添加环境变量到 shell 配置

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
  "version": "1.0.0",
  "note": "此配置为全局共享，多个 AI 工具共用同一 vault"
}
```

### 路径解析优先级

1. 环境变量 `DAYDAYUP_VAULT_PATH`
2. 全局配置文件 `~/.daydayup/config.json`
3. 自动检测常见路径
4. 提示用户输入

## 验证安装

### 检查配置状态

```bash
./setup.sh --status
```

输出示例：
```
📊 DayDayUp 配置状态
================================

✅ 已配置
   {
     "vaultPath": "/Users/xxx/.../daydayup",
     "configuredAt": "2025-03-03T10:00:00Z",
     "version": "1.0.0"
   }

✅ Vault 目录存在
   路径: /Users/xxx/.../daydayup

📚 数据统计
   记忆卡片: 5 张
   复习记录: 3 份
```

### Claude Code 验证

1. 重启 Claude Code
2. 输入 `记忆状态`
3. 应该看到统计信息

### OpenCode 验证

1. 重启 OpenCode
2. 输入 `帮我回忆`
3. 应该看到复习列表（如果有待复习卡片）

## 常见问题

### Q: 多平台安装时数据会丢失吗？

**A:** 不会。DayDayUp 设计了全局配置和数据分离：
- 全局配置 `~/.daydayup/config.json` 只保存 vault 路径
- 所有记忆数据保存在 vault 目录中
- 多个平台安装时，会自动检测并复用现有配置和数据

### Q: 找不到 vault 路径

**A:** 确保：
1. Obsidian vault 目录存在
2. 路径正确（macOS iCloud 路径包含空格，需要正确引用）
3. 运行 `./setup.sh --status` 检查配置

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

### Q: 如何在新机器上使用？

**A:**
1. 确保 iCloud 同步了 vault 数据
2. 安装 skill 到新机器
3. 运行 `./setup.sh`，选择相同的 vault 路径
4. 数据自动可用

## 下一步

安装完成后：

1. 说 `记住 <内容>` 添加第一条记忆
2. 说 `帮我回忆` 开始复习
3. 在 Obsidian 中打开 vault 查看 dashboard.md

---

有问题？[提交 Issue](https://github.com/huangjicong/skill_daydayup/issues)
