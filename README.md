# 🧠 DayDayUp - AI 记忆助手

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

基于艾宾浩斯遗忘曲线的智能间隔重复记忆系统，与 Obsidian 深度集成，支持 Claude Code、OpenCode、OpenClaude 等多个 AI 平台。

## ✨ 特性

- 🎯 **艾宾浩斯遗忘曲线** - 科学的复习间隔
- 🤖 **AI 记忆技巧** - 自动生成类比、口诀、例子
- 📊 **动态调整** - 根据反馈调整复习频率
- 📝 **Obsidian 集成** - 所有数据在 Obsidian vault 中
- 🔄 **跨平台** - 支持多个 AI 编程助手
- ☁️ **iCloud 同步** - 多设备数据同步

## 🚀 快速开始

### 1. 安装 Skill

**Claude Code:**
```bash
# 方法 1: 克隆到 skills 目录
git clone https://github.com/huangjicong/skill_daydayup.git ~/.claude/skills/daydayup

# 方法 2: 手动安装
git clone https://github.com/huangjicong/skill_daydayup.git
cd skill_daydayup
./setup.sh
```

**OpenCode:**
```bash
# 在 opencode.json 中添加
{
  "skills": {
    "paths": ["/path/to/skill_daydayup"]
  }
}
```

**OpenClaude:**
```bash
# 参考 Claude Code 安装方法
```

### 2. 配置 Vault 路径

```bash
# 运行配置脚本
./setup.sh

# 或手动设置环境变量
export DAYDAYUP_VAULT_PATH="/path/to/your/obsidian/vault/daydayup"
```

### 3. 开始使用

在 AI 工具中说：

| 指令 | 功能 |
|------|------|
| `帮我回忆` | 开始今日复习 |
| `记住 <内容>` | 添加新记忆卡片 |
| `记忆状态` | 查看学习统计 |

## 📖 使用示例

### 添加记忆

```
你: 记住 深度学习里的多层神经网络，从数学本质上来看，就是通过一系列非线性的激活函数和线性的矩阵乘法，把一个极度扭曲复杂的高维数据流形，一层一层地拉平、展开，直到在最后一层可以用一个简单的超平面把不同类别的数据干脆利落地切分开来。

AI: 📝 创建新记忆卡片...
✅ 已保存！

💡 AI 记忆技巧:
- **类比**: 想象揉面团
- **口诀**: "激活函，矩阵乘，拉平流形超面分"
```

### 复习

```
你: 帮我回忆

AI: 📋 今日复习 (2张卡片)

## 1/2: 神经网络的数学本质
**问题**: 深度学习里的多层神经网络，从数学本质上是如何工作的？

你: 看答案

AI: ✅ 答案: ...
📊 你的记忆情况？简单/一般/困难/没记住

你: 一般

AI: ✅ 已记录！下次复习: 2天后
```

## 📅 复习间隔

| 阶段 | 基础间隔 | 简单 | 一般 | 困难 |
|------|----------|------|------|------|
| 1 | 1天 | 1.5天 | 1天 | 0.5天 |
| 2 | 2天 | 3天 | 2天 | 1天 |
| 3 | 4天 | 6天 | 4天 | 2天 |
| 4 | 7天 | 10天 | 7天 | 3天 |
| 5 | 15天 | 22天 | 15天 | 7天 |
| 6 | 30天 | 45天 | 30天 | 15天 |
| 7 | 60天 | 90天 | 60天 | 30天 |
| 8+ | 掌握 | - | - | - |

## 📁 项目结构

```
skill_daydayup/
├── skill.md              # 核心 skill 定义
├── config.example.json   # 配置模板
├── setup.sh              # 配置脚本
├── README.md             # 本文件
├── INSTALL.md            # 详细安装指南
├── templates/            # 卡片模板
│   ├── card-template.md
│   └── review-template.md
└── platforms/            # 平台适配
    ├── claude-code/
    ├── opencode/
    └── openclaude/
```

## 🔗 链接

- [安装指南](INSTALL.md)
- [配置说明](docs/advanced-config.md)

## 📄 许可证

MIT License
