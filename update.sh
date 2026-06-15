#!/bin/bash

# Disable Armor Sound 资源包更新脚本
# 用法: ./update.sh [版本号]
# 如果不提供版本号，将自动获取最新版本

set -e

PROJECT_ID="NLGwoXjo"
PROJECT_SLUG="dis-armor-sound"
RESOURCE_DIR="DisableArmorSound"
BACKUP_DIR="backup"

echo "🔄 正在检查 Modrinth 上的最新版本..."

# 获取最新版本信息
VERSION_INFO=$(curl -s "https://api.modrinth.com/v2/project/$PROJECT_SLUG/version")
LATEST_VERSION=$(echo "$VERSION_INFO" | jq -r '.[0].version_number')
DOWNLOAD_URL=$(echo "$VERSION_INFO" | jq -r '.[0].files[0].url')
FILENAME=$(echo "$VERSION_INFO" | jq -r '.[0].files[0].filename')

echo "📦 最新版本: $LATEST_VERSION"
echo "📥 下载链接: $DOWNLOAD_URL"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份当前版本
if [ -d "$RESOURCE_DIR" ]; then
    echo "💾 备份当前版本..."
    BACKUP_NAME="$BACKUP_DIR/DisableArmorSound_$(date +%Y%m%d_%H%M%S)"
    cp -r "$RESOURCE_DIR" "$BACKUP_NAME"
    echo "✅ 备份完成: $BACKUP_NAME"
fi

# 下载新版本
echo "⬇️  下载新版本..."
TEMP_FILE="temp_resourcepack.zip"
curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"

# 清理旧文件
echo "🧹 清理旧文件..."
rm -rf "$RESOURCE_DIR"

# 解压新版本
echo "📦 解压新版本..."
mkdir -p "$RESOURCE_DIR"
unzip -o "$TEMP_FILE" -d "$RESOURCE_DIR"

# 清理临时文件
rm "$TEMP_FILE"

# 更新版本号
echo "📝 更新版本信息..."
if [ -f "$RESOURCE_DIR/pack.mcmeta" ]; then
    # 更新描述中的版本号
    sed -i "s/§bBy Jun_haoer/§bBy Jun_haoer | v$LATEST_VERSION/" "$RESOURCE_DIR/pack.mcmeta"
fi

# 提交更改
echo "📝 提交更改..."
git add .
git commit -m "更新到版本 $LATEST_VERSION"

echo ""
echo "✅ 更新完成!"
echo "📦 当前版本: $LATEST_VERSION"
echo "📁 资源包位置: $RESOURCE_DIR"
echo ""
echo "💡 提示:"
echo "1. 测试资源包是否正常工作"
echo "2. 如有需要，推送到远程仓库: git push origin master"
echo "3. 在 Modrinth 上发布新版本"
