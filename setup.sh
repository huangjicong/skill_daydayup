#!/bin/bash

# DayDayUp Skill Setup Script
# 自动配置 vault 路径

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧠 DayDayUp Skill 配置向导${NC}"
echo "================================"
echo ""

# 配置文件路径
CONFIG_DIR="$HOME/.daydayup"
CONFIG_FILE="$CONFIG_DIR/config.json"

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 检测函数
detect_vault_path() {
    local paths=(
        "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/life/daydayup"
        "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/daydayup"
        "$HOME/Obsidian/daydayup"
        "$HOME/Documents/Obsidian/daydayup"
        "$HOME/obsidian/daydayup"
    )

    for path in "${paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    return 1
}

# 验证 vault 路径
validate_vault_path() {
    local path="$1"

    if [ ! -d "$path" ]; then
        echo -e "${YELLOW}⚠️  目录不存在，将创建...${NC}"
        mkdir -p "$path"/{cards,reviews,templates}
        echo -e "${GREEN}✅ 已创建目录结构${NC}"
    fi

    # 检查必需的子目录
    local required_dirs=("cards" "reviews")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$path/$dir" ]; then
            mkdir -p "$path/$dir"
        fi
    done

    return 0
}

# 主逻辑
VAULT_PATH=""

# 1. 检查环境变量
if [ -n "$DAYDAYUP_VAULT_PATH" ]; then
    echo -e "${GREEN}✅ 检测到环境变量 DAYDAYUP_VAULT_PATH${NC}"
    echo -e "   路径: $DAYDAYUP_VAULT_PATH"
    read -p "使用此路径? (Y/n): " confirm
    if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
        VAULT_PATH="$DAYDAYUP_VAULT_PATH"
    fi
fi

# 2. 检查现有配置
if [ -z "$VAULT_PATH" ] && [ -f "$CONFIG_FILE" ]; then
    echo -e "${GREEN}✅ 检测到现有配置文件${NC}"
    existing_path=$(cat "$CONFIG_FILE" | grep -o '"vaultPath"[^,]*' | cut -d'"' -f4)
    echo -e "   路径: $existing_path"
    read -p "使用此路径? (Y/n): " confirm
    if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
        VAULT_PATH="$existing_path"
    fi
fi

# 3. 自动检测
if [ -z "$VAULT_PATH" ]; then
    echo -e "${BLUE}🔍 正在自动检测 Obsidian vault 路径...${NC}"
    detected_path=$(detect_vault_path)
    if [ -n "$detected_path" ]; then
        echo -e "${GREEN}✅ 检测到 vault: $detected_path${NC}"
        read -p "使用此路径? (Y/n): " confirm
        if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
            VAULT_PATH="$detected_path"
        fi
    fi
fi

# 4. 手动输入
if [ -z "$VAULT_PATH" ]; then
    echo -e "${YELLOW}📝 请输入你的 Obsidian vault 路径${NC}"
    echo "   示例: /Users/yourname/Library/Mobile Documents/iCloud~md~obsidian/Documents/life/daydayup"
    echo ""
    read -p "vault 路径: " VAULT_PATH

    if [ -z "$VAULT_PATH" ]; then
        echo -e "${RED}❌ 路径不能为空${NC}"
        exit 1
    fi
fi

# 验证路径
validate_vault_path "$VAULT_PATH"

# 保存配置
cat > "$CONFIG_FILE" << EOF
{
  "vaultPath": "$VAULT_PATH",
  "configuredAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "1.0.0"
}
EOF

echo ""
echo -e "${GREEN}✅ 配置完成！${NC}"
echo -e "   配置文件: $CONFIG_FILE"
echo -e "   Vault 路径: $VAULT_PATH"
echo ""

# 询问是否设置环境变量
read -p "是否添加环境变量到 shell 配置? (y/N): " add_env
if [[ "$add_env" =~ ^[Yy]$ ]]; then
    shell_config=""
    if [ -n "$ZSH_VERSION" ]; then
        shell_config="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        shell_config="$HOME/.bashrc"
    fi

    if [ -n "$shell_config" ]; then
        echo "" >> "$shell_config"
        echo "# DayDayUp Skill" >> "$shell_config"
        echo "export DAYDAYUP_VAULT_PATH=\"$VAULT_PATH\"" >> "$shell_config"
        echo -e "${GREEN}✅ 已添加到 $shell_config${NC}"
        echo -e "   运行 ${YELLOW}source $shell_config${NC} 使其生效"
    fi
fi

echo ""
echo -e "${BLUE}📚 开始使用:${NC}"
echo "   1. 重启你的 AI 工具 (Claude Code / OpenCode / OpenClaude)"
echo "   2. 说 '帮我回忆' 开始复习"
echo "   3. 说 '记住 <内容>' 添加新记忆"
echo ""
echo -e "${GREEN}🎉 配置成功！${NC}"
