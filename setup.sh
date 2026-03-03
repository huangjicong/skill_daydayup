#!/bin/bash

# DayDayUp Skill Setup Script
# 自动配置 vault 路径（支持多平台共享数据）

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置文件路径（全局共享）
CONFIG_DIR="$HOME/.daydayup"
CONFIG_FILE="$CONFIG_DIR/config.json"

# 显示帮助
show_help() {
    echo -e "${CYAN}DayDayUp Skill 配置工具${NC}"
    echo ""
    echo "用法: ./setup.sh [选项]"
    echo ""
    echo "选项:"
    echo "  无参数      运行配置向导"
    echo "  --status    查看当前配置状态"
    echo "  --check     静默检查配置状态（返回 0=已配置，1=未配置）"
    echo "  --reset     重置配置（保留数据）"
    echo "  --help      显示此帮助信息"
    echo ""
}

# 显示当前状态
show_status() {
    echo -e "${CYAN}📊 DayDayUp 配置状态${NC}"
    echo "================================"
    echo ""

    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${GREEN}✅ 已配置${NC}"
        echo ""
        cat "$CONFIG_FILE" | while read line; do
            echo "   $line"
        done
        echo ""

        # 检查 vault 路径是否存在
        vault_path=$(cat "$CONFIG_FILE" | grep -o '"vaultPath"[^,]*' | cut -d'"' -f4)
        if [ -d "$vault_path" ]; then
            echo -e "${GREEN}✅ Vault 目录存在${NC}"
            echo "   路径: $vault_path"

            # 统计卡片数量
            card_count=$(find "$vault_path/cards" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            review_count=$(find "$vault_path/reviews" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

            echo ""
            echo -e "${CYAN}📚 数据统计${NC}"
            echo "   记忆卡片: $card_count 张"
            echo "   复习记录: $review_count 份"
        else
            echo -e "${RED}❌ Vault 目录不存在${NC}"
            echo "   路径: $vault_path"
        fi
    else
        echo -e "${YELLOW}⚠️  尚未配置${NC}"
        echo ""
        echo "运行 ./setup.sh 开始配置"
    fi
}

# 检测是否已配置
check_existing_config() {
    if [ -f "$CONFIG_FILE" ]; then
        return 0
    fi
    return 1
}

# 检测 vault 路径
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

# 验证 vault 路径（不删除现有数据）
validate_vault_path() {
    local path="$1"

    if [ ! -d "$path" ]; then
        echo -e "${YELLOW}⚠️  目录不存在，将创建...${NC}"
        mkdir -p "$path"
        echo -e "${GREEN}✅ 已创建 vault 目录${NC}"
    fi

    # 检查并创建子目录（不覆盖现有数据）
    local subdirs=("cards" "reviews" "templates")
    for dir in "${subdirs[@]}"; do
        if [ ! -d "$path/$dir" ]; then
            mkdir -p "$path/$dir"
            echo -e "${GREEN}✅ 已创建子目录: $dir/${NC}"
        else
            # 检查是否有数据
            local count=$(find "$path/$dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$count" -gt 0 ]; then
                echo -e "${GREEN}✅ 检测到现有数据: $dir/ ($count 个文件)${NC}"
            fi
        fi
    done

    return 0
}

# 检查是否有现有数据
check_existing_data() {
    local path="$1"
    local card_count=$(find "$path/cards" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$card_count" -gt 0 ]; then
        return 0
    fi
    return 1
}

# 主配置流程
main() {
    echo -e "${BLUE}🧠 DayDayUp Skill 配置向导${NC}"
    echo "================================"
    echo ""

    # 创建配置目录
    mkdir -p "$CONFIG_DIR"

    VAULT_PATH=""

    # 1. 检查现有全局配置
    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${GREEN}✅ 检测到全局配置文件${NC}"
        existing_path=$(cat "$CONFIG_FILE" | grep -o '"vaultPath"[^,]*' | cut -d'"' -f4)
        echo -e "   已配置的 Vault: ${CYAN}$existing_path${NC}"

        # 检查是否有数据
        if check_existing_data "$existing_path"; then
            local card_count=$(find "$existing_path/cards" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo -e "   ${GREEN}已有 $card_count 张记忆卡片${NC}"
        fi

        echo ""
        echo -e "${YELLOW}⚠️  多平台安装检测${NC}"
        echo "   你之前已经配置过 DayDayUp，建议使用相同的 vault 路径"
        echo "   这样可以在不同 AI 工具间共享记忆数据"
        echo ""
        read -p "使用现有配置? (Y/n/r=重新配置): " confirm

        if [[ "$confirm" =~ ^[Rr]$ ]]; then
            echo -e "${YELLOW}重新配置模式...${NC}"
        elif [[ ! "$confirm" =~ ^[Nn]$ ]]; then
            VAULT_PATH="$existing_path"
            echo ""
            echo -e "${GREEN}✅ 使用现有配置，数据保持不变${NC}"
        fi
    fi

    # 2. 如果没有配置或选择重新配置
    if [ -z "$VAULT_PATH" ]; then
        # 检查环境变量
        if [ -n "$DAYDAYUP_VAULT_PATH" ]; then
            echo -e "${GREEN}✅ 检测到环境变量 DAYDAYUP_VAULT_PATH${NC}"
            echo -e "   路径: $DAYDAYUP_VAULT_PATH"
            read -p "使用此路径? (Y/n): " confirm
            if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
                VAULT_PATH="$DAYDAYUP_VAULT_PATH"
            fi
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

    # 验证路径（不删除现有数据）
    validate_vault_path "$VAULT_PATH"

    # 保存全局配置
    cat > "$CONFIG_FILE" << EOF
{
  "vaultPath": "$VAULT_PATH",
  "configuredAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "1.0.0",
  "note": "此配置为全局共享，多个 AI 工具共用同一 vault"
}
EOF

    echo ""
    echo -e "${GREEN}✅ 配置完成！${NC}"
    echo -e "   全局配置: $CONFIG_FILE"
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
            # 检查是否已经存在
            if grep -q "DAYDAYUP_VAULT_PATH" "$shell_config" 2>/dev/null; then
                echo -e "${YELLOW}⚠️  环境变量已存在于 $shell_config${NC}"
            else
                echo "" >> "$shell_config"
                echo "# DayDayUp Skill" >> "$shell_config"
                echo "export DAYDAYUP_VAULT_PATH=\"$VAULT_PATH\"" >> "$shell_config"
                echo -e "${GREEN}✅ 已添加到 $shell_config${NC}"
                echo -e "   运行 ${YELLOW}source $shell_config${NC} 使其生效"
            fi
        fi
    fi

    echo ""
    echo -e "${CYAN}📖 多平台安装提示${NC}"
    echo "   如果要在其他 AI 工具中使用此 skill："
    echo "   1. 安装 skill 到该工具"
    echo "   2. 无需再次运行 setup.sh（自动使用全局配置）"
    echo "   3. 或设置相同的环境变量 DAYDAYUP_VAULT_PATH"
    echo ""
    echo -e "${BLUE}📚 开始使用:${NC}"
    echo "   1. 重启你的 AI 工具 (Claude Code / OpenCode / OpenClaude)"
    echo "   2. 说 '帮我回忆' 开始复习"
    echo "   3. 说 '记住 <内容>' 添加新记忆"
    echo ""
    echo -e "${GREEN}🎉 配置成功！${NC}"
}

# 重置配置
reset_config() {
    echo -e "${YELLOW}⚠️  重置配置${NC}"
    echo ""

    if [ -f "$CONFIG_FILE" ]; then
        existing_path=$(cat "$CONFIG_FILE" | grep -o '"vaultPath"[^,]*' | cut -d'"' -f4)
        echo "当前配置:"
        echo "  Vault: $existing_path"
        echo ""

        # 检查是否有数据
        if check_existing_data "$existing_path"; then
            card_count=$(find "$existing_path/cards" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo -e "${RED}⚠️  警告: 你的 vault 中有 $card_count 张记忆卡片${NC}"
            echo "   重置配置不会删除数据，但需要重新配置路径"
        fi

        echo ""
        read -p "确认重置配置? (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -f "$CONFIG_FILE"
            echo -e "${GREEN}✅ 配置已重置${NC}"
            echo "   运行 ./setup.sh 重新配置"
        else
            echo "已取消"
        fi
    else
        echo -e "${YELLOW}没有找到配置文件${NC}"
    fi
}

# 处理参数
case "$1" in
    --status)
        show_status
        ;;
    --check)
        if [ -f "$CONFIG_FILE" ]; then
            exit 0  # 已配置
        else
            exit 1  # 未配置
        fi
        ;;
    --reset)
        reset_config
        ;;
    --help|-h)
        show_help
        ;;
    *)
        main
        ;;
esac
