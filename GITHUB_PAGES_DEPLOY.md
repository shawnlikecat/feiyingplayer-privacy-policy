# GitHub Pages 静态站点部署指南

## 🚀 快速开始

### 1. 准备工作
确保你的项目包含以下内容：
- 静态文件（HTML, CSS, JavaScript）
- 可选：构建脚本（package.json）

### 2. 创建GitHub仓库

#### 方法一：直接在GitHub创建仓库
1. 访问 [GitHub](https://github.com) 并登录
2. 点击右上角的 "+" 按钮，选择 "New repository"
3. 输入仓库名称（例如：`my-static-site`）
4. 选择 "Public"（GitHub Pages需要公开仓库，除非你是Pro用户）
5. 点击 "Create repository"

#### 方法二：命令行创建仓库
```bash
# 在本地项目目录中执行
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/你的用户名/你的仓库名.git
git push -u origin main
```

### 3. 启用GitHub Pages

#### 方法一：通过GitHub网页界面
1. 进入你的GitHub仓库页面
2. 点击 "Settings" 标签
3. 滚动到左侧菜单的 "Pages" 选项
4. 在 "Source" 部分，选择 "GitHub Actions"
5. 仓库将自动触发第一次部署

#### 方法二：通过Action工作流
- 我们已经为你创建了 `.github/workflows/deploy.yml` 文件
- 当你推送代码到main/master分支时，GitHub Actions将自动运行部署

### 4. 自定义域名（可选）

如果你有自己的域名：

1. 在仓库根目录创建 `CNAME` 文件：
   ```
   yourdomain.com
   ```

2. 在GitHub仓库设置中的Pages部分配置你的域名

3. 在域名提供商处添加CNAME记录：
   ```
   类型: CNAME
   名称: www (或@)
   值: yourusername.github.io
   ```

## 🔧 项目配置

### Vue.js项目
如果你的项目是Vue.js：
```yaml
# 在deploy.yml的Build步骤中替换为：
- name: Build Vue project
  run: |
    npm install
    npm run build
    # 部署dist目录
```

### React项目
如果你的项目是React：
```yaml
# 在deploy.yml的Build步骤中替换为：
- name: Build React project
  run: |
    npm install
    npm run build
    # 部署build目录
```

### 纯HTML项目
对于纯HTML项目：
```yaml
# 使用我们已经配置的模板，它会自动创建dist目录
```

## 📁 目录结构示例

```
your-repository/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── .nojekyll
├── index.html
├── css/
│   └── style.css
├── js/
│   └── script.js
└── images/
    └── logo.png
```

## 🌐 访问你的网站

部署完成后，你的网站将可以通过以下地址访问：

- `https://你的用户名.github.io/仓库名`
- 或你的自定义域名（如果你配置了）

## 🔍 故障排除

### 常见问题

1. **404错误**
   - 检查构建路径是否正确
   - 确保index.html在正确位置

2. **样式丢失**
   - 检查CSS文件路径
   - 确保资源文件在构建后仍存在

3. **JavaScript不工作**
   - 检查控制台错误
   - 确保JavaScript文件路径正确

### 调试技巧

1. 查看Actions日志：
   - 进入仓库的"Actions"标签
   - 点击最新的工作流运行
   - 查看详细的执行日志

2. 手动触发部署：
   - 在Actions页面点击 "Re-run jobs"

## 📝 下一步

部署成功后，你可以：
- 添加自定义域名
- 设置HTTPS（GitHub Pages自动提供）
- 配置重定向规则
- 添加Google Analytics
- 优化SEO设置

## 🆘 需要帮助？

如果遇到问题：
1. 检查GitHub Actions日志
2. 确保所有文件都正确提交
3. 验证构建脚本是否正常工作
4. 查看GitHub Pages官方文档