# 00_prepare.ps1
# 1. 使用清华镜像下载安装最新版 Git for Windows
# 2. 使用 winget 安装 VSCode

# 下载并安装 Git（64位）
$gitUrl = "https://mirrors.tuna.tsinghua.edu.cn/github-release/git-for-windows/git/LatestRelease/Git-2.50.0-64-bit.exe"
$gitInstaller = "$env:TEMP\Git-2.50.0-64-bit.exe"
Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller
Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT", "/NORESTART" -Wait
Remove-Item $gitInstaller

# 安装 VSCode（安装目录可自定义 location 参数）
winget install -e --id Microsoft.VisualStudioCode --location "D:\winget_apps\Microsoft.VisualStudioCode"
