# Disable Armor Sound 资源包维护指南

## 资源包信息
- **名称**: Disable Armor Sound | 关闭盔甲穿戴音效
- **作者**: Jun_haoer
- **当前版本**: 26.1.2
- **支持版本**: Minecraft 1.15 - 26.2
- **资源包格式**: pack_format 87 (支持格式 5-87)

## 文件结构
```
DisableArmorSound/
├── pack.mcmeta              # 资源包元数据
├── pack.png                 # 资源包图标
└── assets/
    └── minecraft/
        ├── sounds.json      # 声音配置文件
        └── sounds/
            └── silent.ogg   # 静音文件
```

## 维护步骤

### 1. 检查新版本盔甲
当 Minecraft 发布新版本时，检查是否有新的盔甲类型需要添加到 `sounds.json`。

当前已包含的盔甲类型：
- `item.armor.equip_generic` - 通用盔甲
- `item.armor.equip_chain` - 锁甲
- `item.armor.equip_diamond` - 钻石甲
- `item.armor.equip_gold` - 金甲
- `item.armor.equip_iron` - 铁甲
- `item.armor.equip_leather` - 皮革甲
- `item.armor.equip_netherite` - 下界合金甲
- `item.armor.equip_turtle` - 海龟壳
- `item.armor.equip_elytra` - 鞘翅
- `item.armor.equip_copper` - 铜甲

### 2. 更新 pack_format
根据 Minecraft 版本更新 `pack.mcmeta` 中的 `pack_format`：

| Minecraft 版本 | pack_format |
|----------------|-------------|
| 1.15-1.16.1    | 5           |
| 1.16.2-1.16.5  | 6           |
| 1.17-1.17.1    | 7           |
| 1.18-1.18.1    | 8           |
| 1.18.2         | 9           |
| 1.19-1.19.1    | 10          |
| 1.19.2         | 11          |
| 1.19.3         | 12          |
| 1.19.4         | 13          |
| 1.20-1.20.1    | 14          |
| 1.20.2         | 15          |
| 1.20.3-1.20.4  | 16          |
| 1.20.5-1.20.6  | 17          |
| 1.21-1.21.1    | 18          |
| 1.21.2-1.21.3  | 19          |
| 1.21.4         | 20          |
| 1.21.5         | 21          |
| 26.1           | 22          |
| 26.2           | 23          |

### 3. 测试资源包
1. 在目标 Minecraft 版本中加载资源包
2. 穿戴各种盔甲类型，确认音效被正确禁用
3. 检查是否有游戏崩溃或错误

### 4. 发布更新
1. 更新 `pack.mcmeta` 中的版本信息（如果需要）
2. 更新 `sounds.json` 中的盔甲类型（如果需要）
3. 测试通过后，打包为 zip 文件
4. 在 Modrinth 上发布新版本

## 从 Modrinth 更新资源包
```bash
# 获取最新版本信息
curl -s "https://api.modrinth.com/v2/project/dis-armor-sound/version" | jq '.[0]'

# 下载最新版本
wget -O "DisableArmorSound_<版本号>.zip" "<下载链接>"

# 解压更新
unzip -o "DisableArmorSound_<版本号>.zip" -d "DisableArmorSound"
```

## 注意事项
1. 该资源包仅在本地端生效，服务器端的玩家需要各自安装
2. 坚守者 (Warden) 仍会听到盔甲穿戴音效
3. 不会影响其他游戏音效或性能
4. 建议在发布前进行充分测试

## 常见问题
**Q: 为什么资源包不生效？**
A: 请检查：
- 资源包是否已启用
- Minecraft 版本是否在支持范围内
- 是否与其他资源包冲突

**Q: 如何添加新的盔甲类型？**
A: 在 `sounds.json` 中添加新的条目，参考现有格式：
```json
"item.armor.equip_<类型>": {
  "replace": true,
  "sounds": [
    {
      "name": "minecraft:silent",
      "type": "event"
    }
  ]
}
```