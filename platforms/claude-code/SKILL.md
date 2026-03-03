---
name: spaced-repetition
description: 智能间隔重复记忆系统。基于艾宾浩斯遗忘曲线，支持动态调整复习间隔。当用户说"帮我回忆"、"复习"、"添加记忆"、"记住"时触发。
version: 1.0.0
triggers:
  - "/daydayup"
  - "帮我回忆"
  - "复习"
  - "添加记忆"
  - "记住"
  - "记忆状态"
  - "今天学什么"
vaultPath: ${DAYDAYUP_VAULT_PATH}
allowOutsideVault: false
---

# DayDayUp - Claude Code Skill

> 🧠 基于 Obsidian 的智能记忆系统，使用艾宾浩斯遗忘曲线帮助你记住任何知识。

> **核心定义**: 本 skill 基于 [../../skill.md](../../skill.md)

## 快速开始

### 1. 配置 Vault 路径

```bash
# 运行配置脚本
cd /path/to/skill_daydayup
./setup.sh

# 或设置环境变量
export DAYDAYUP_VAULT_PATH="/path/to/your/obsidian/vault/daydayup"
```

### 2. 触发词

| 触发词 | 行为 |
|--------|------|
| `帮我回忆` | 展示今日待复习内容 |
| `记住 <内容>` | 创建新记忆卡片 |
| `记忆状态` | 显示学习统计 |

## 路径解析

Claude Code 版本使用以下优先级解析 vault 路径：

1. 环境变量 `DAYDAYUP_VAULT_PATH`
2. 配置文件 `~/.daydayup/config.json`
3. 自动检测 Obsidian vault 路径

## 文件操作

所有文件操作限制在以下目录：

- `{vaultPath}/cards/` - 记忆卡片
- `{vaultPath}/reviews/` - 复习记录
- `{vaultPath}/templates/` - 模板文件

## 完整文档

详见 [../../skill.md](../../skill.md) 和 [../../README.md](../../README.md)
