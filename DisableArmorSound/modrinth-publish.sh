#!/bin/bash

# Modrinth发布脚本
# 用法: ./modrinth-publish.sh <版本号> <changelog>

set -e

CONFIG_FILE=".modrinth-config.json"
ZIP_FILE="DisableArmorSound_${1}.zip"

# 检查配置文件
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 错误：找不到配置文件 $CONFIG_FILE"
    exit 1
fi

# 检查版本号参数
if [ -z "$1" ]; then
    echo "❌ 错误：请提供版本号"
    echo "用法: ./modrinth-publish.sh <版本号> <changelog>"
    exit 1
fi

# 读取配置
API_TOKEN=$(jq -r '.api_token' "$CONFIG_FILE")
PROJECT_ID=$(jq -r '.project_id' "$CONFIG_FILE")

echo "📦 打包资源包..."
rm -f "$ZIP_FILE"
zip -r "$ZIP_FILE" pack.mcmeta pack.png assets/

echo "🚀 上传到Modrinth..."

# 创建版本
RESPONSE=$(curl -s -X POST "https://api.modrinth.com/v2/project/$PROJECT_ID/version" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: multipart/form-data" \
  -F "data={\"game_versions\":[\"1.15\",\"1.15.1\",\"1.15.2\",\"1.16\",\"1.16.1\",\"1.16.2\",\"1.16.3\",\"1.16.4\",\"1.16.5\",\"1.17\",\"1.17.1\",\"1.18\",\"1.18.1\",\"1.18.2\",\"1.19\",\"1.19.1\",\"1.19.2\",\"1.19.3\",\"1.19.4\",\"1.20\",\"1.20.1\",\"1.20.2\",\"1.20.3\",\"1.20.4\",\"1.20.5\",\"1.20.6\",\"1.21\",\"1.21.1\",\"1.21.2\",\"1.21.3\",\"1.21.4\",\"1.21.5\",\"26.1\",\"26.1.1\",\"26.1.2\"],\"loaders\":[\"minecraft\"],\"name\":\"Disable Armor Sound | 关闭盔甲穿戴音效 $1\",\"version_number\":\"$1\",\"changelog\":\"$2\",\"version_type\":\"release\",\"status\":\"listed\"}" \
  -F "file=@$ZIP_FILE")

# 检查响应
if echo "$RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
    VERSION_ID=$(echo "$RESPONSE" | jq -r '.id')
    echo "✅ 发布成功！"
    echo "📋 版本ID: $VERSION_ID"
    echo "🔗 下载链接: https://cdn.modrinth.com/data/$PROJECT_ID/versions/$VERSION_ID/$ZIP_FILE"
    echo "🌐 Modrinth页面: https://modrinth.com/resourcepack/dis-armor-sound/version/$VERSION_ID"
else
    echo "❌ 发布失败："
    echo "$RESPONSE" | jq '.'
    exit 1
fi

# 清理临时文件
rm -f "$ZIP_FILE"

echo ""
echo "🎉 发布完成！"