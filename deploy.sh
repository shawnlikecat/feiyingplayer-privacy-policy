#!/bin/bash

# GitHub Pages 部署自动化脚本
# 使用方法: ./deploy.sh your-username your-repo-name

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
if [ "$#" -ne 2 ]; then
    print_error "使用方法: $0 <GitHub用户名> <仓库名>"
    echo "示例: $0 johnsmith my-website"
    exit 1
fi

USERNAME=$1
REPO_NAME=$2
GITHUB_URL="https://github.com/$USERNAME/$REPO_NAME.git"

print_message "开始设置GitHub Pages部署..."

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    print_message "初始化Git仓库..."
    git init
    
    # 设置初始分支为main
    if git show-ref --verify --quiet refs/heads/main; then
        print_warning "main分支已存在"
    else
        git branch -M main
    fi
else
    print_message "Git仓库已存在"
fi

# 检查是否有远程仓库
if git remote get-url origin > /dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin)
    if [ "$CURRENT_REMOTE" != "$GITHUB_URL" ]; then
        print_warning "检测到不同的远程仓库，当前: $CURRENT_REMOTE"
        read -p "是否要更新远程仓库为 $GITHUB_URL? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git remote set-url origin $GITHUB_URL
            print_message "远程仓库已更新"
        fi
    fi
else
    print_message "添加远程仓库: $GITHUB_URL"
    git remote add origin $GITHUB_URL
fi

# 创建GitHub仓库（如果不存在）
print_message "检查GitHub仓库是否存在..."
if curl -s -f "https://api.github.com/repos/$USERNAME/$REPO_NAME" > /dev/null; then
    print_message "仓库 $USERNAME/$REPO_NAME 已存在"
else
    print_error "仓库 $USERNAME/$REPO_NAME 不存在！请先在GitHub上创建仓库"
    print_message "访问 https://github.com/new 创建仓库"
    exit 1
fi

# 构建项目（如果存在构建脚本）
if [ -f "package.json" ]; then
    print_message "检测到package.json，安装依赖并构建..."
    npm install
    if npm run build; then
        print_message "项目构建成功"
    else
        print_warning "构建失败，但继续部署"
    fi
elif [ -f "vite.config.js" ] || [ -f "vite.config.ts" ]; then
    print_message "检测到Vite配置，构建项目..."
    if command -v npm &> /dev/null; then
        npm install
        npm run build
    elif command -v yarn &> /dev/null; then
        yarn install
        yarn build
    else
        print_warning "未找到包管理器，请手动安装依赖并构建"
    fi
else
    print_message "未检测到构建配置，创建简单的dist目录..."
    mkdir -p dist
    # 复制除.git、.github、node_modules外的所有文件
    rsync -av --exclude='.git' --exclude='.github' --exclude='node_modules' --exclude='dist' . dist/
fi

# 提交所有更改
print_message "提交代码到Git..."
git add .
git commit -m "Setup GitHub Pages deployment - $(date)" || print_warning "没有新更改需要提交"

# 推送到GitHub
print_message "推送代码到GitHub..."
if git push -u origin main; then
    print_message "代码推送成功！"
else
    print_error "推送失败，请检查网络连接和仓库权限"
    exit 1
fi

# 显示下一步说明
echo
print_message "🎉 GitHub Pages部署设置完成！"
echo
print_message "接下来的步骤："
echo "1. 访问 https://github.com/$USERNAME/$REPO_NAME/settings/pages"
echo "2. 在 'Source' 部分选择 'GitHub Actions'"
echo "3. 等待几分钟后访问你的网站："
echo "   https://$USERNAME.github.io/$REPO_NAME"
echo
print_message "如果遇到问题，请查看："
echo "- Actions标签页中的部署日志"
echo "- GITHUB_PAGES_DEPLOY.md 文件"
echo
print_message "自定义域名设置："
echo "1. 在仓库根目录创建 CNAME 文件"
echo "2. 在域名提供商处添加 CNAME 记录"
echo