#!/bin/bash

# 版本更新脚本
# 用法: ./update-version.sh [新版本号]
# 示例: ./update-version.sh 1.0.2

NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
    echo "错误: 请提供新版本号"
    echo "用法: $0 [版本号]"
    echo "示例: $0 1.0.2"
    exit 1
fi

echo "正在更新版本号到: $NEW_VERSION"

# 更新所有HTML文件中的CSS版本号
echo "更新CSS文件版本号..."
sed -i '' "s|style/landing\.css?v=[^\"]*|style/landing.css?v=$NEW_VERSION|g" *.html

# 更新游戏JS文件版本号
echo "更新游戏JS文件版本号..."
if [ -f "games/2048-Cupcakes/index.html" ]; then
    sed -i '' "s|js/[^?]*\.js?v=[^\"]*|js/&.js?v=$NEW_VERSION|g" games/2048-Cupcakes/index.html
fi

# 更新内联脚本版本注释
echo "更新内联脚本版本注释..."
if [ -f "index.html" ]; then
    sed -i '' "s|// Version [0-9.]* - Updated [0-9-]*|// Version $NEW_VERSION - Updated $(date +%Y-%m-%d)|g" index.html
fi

# 更新版本说明文件
echo "更新版本说明文件..."
cat > VERSION.md << EOF
# 版本控制说明

## 当前版本：v$NEW_VERSION ($(date +%Y-%m-%d))

### 更新内容
- [在此处添加更新内容]

### 文件版本号规则
- CSS文件：\`style/landing.css?v=$NEW_VERSION\`
- JS文件：\`js/*.js?v=$NEW_VERSION\`
- 内联脚本：注释中标注版本信息

### 版本更新方法
1. 更新CSS/JS时，递增版本号（如：$NEW_VERSION）
2. 使用批量更新命令：
   \`\`\`bash
   sed -i '' 's|\.css\?v=[^"]*|.css?v=X.X.X|g' *.html
   sed -i '' 's|\.js\?v=[^"]*|.js?v=X.X.X|g' *.html
   \`\`\`
3. 提交代码时在commit message中说明版本变更

### 注意事项
- 版本号格式：主版本.次版本.修订版本 (如：$NEW_VERSION)
- 重大更新时更新主版本号
- 功能更新时更新次版本号
- Bug修复时更新修订版本号
- 确保所有HTML文件中的版本号保持一致
EOF

echo "版本更新完成!"
echo "更新的文件:"
echo "- 所有HTML文件的CSS版本号"
echo "- 游戏文件的JS版本号"
echo "- 内联脚本版本注释"
echo "- 版本说明文件 (VERSION.md)"

# 验证更新结果
echo -e "\n=== 验证更新结果 ==="
echo "CSS版本号 (应该显示 $NEW_VERSION):"
grep -o "style/landing.css?v=[^\"]*" *.html | head -3

echo -e "\nJS版本号 (应该显示 $NEW_VERSION):"
if [ -f "games/2048-Cupcakes/index.html" ]; then
    grep -o "js/[^?]*\.js?v=[^\"]*" games/2048-Cupcakes/index.html | head -3
fi