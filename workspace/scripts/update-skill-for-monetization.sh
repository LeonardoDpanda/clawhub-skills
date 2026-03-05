#!/bin/bash
#
# 更新 Skill 并推送到 GitHub

WORKSPACE="/workspace/projects/workspace"
TEMP_DIR="/tmp/skill-update-$$"
REPO_DIR="$TEMP_DIR/clawhub-skills"

cd /tmp
rm -rf clawhub-skills

# 克隆仓库
git clone https://LeonardoDpanda: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@github.com/LeonardoDpanda/clawhub-skills.git $REPO_DIR

# 复制更新后的 Skill
cp $WORKSPACE/skills/config-format-converter-pro/SKILL.md $REPO_DIR/config-format-converter_SKILL.md

# 提交更新
cd $REPO_DIR
git add config-format-converter_SKILL.md
git commit -m "feat: add pricing and upgrade guide - monetization ready"
git push origin main

echo "✅ Skill 更新完成"
echo "GitHub: https://github.com/LeonardoDpanda/clawhub-skills/blob/main/config-format-converter_SKILL.md"
