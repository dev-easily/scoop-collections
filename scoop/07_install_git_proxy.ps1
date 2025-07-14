# 配置SSH代理及HTTPS转SSH脚本
# 需以管理员权限运行PowerShell
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  # 首次运行需开启脚本执行权限
# .\configure_git_ssh.ps1
# ssh-keygen -t ed25519 -C "work@company.com" -f "$HOME\.ssh\id_ed25519_work"
# ssh-keygen -t ed25519 -C "personal@mail.com" -f "$HOME\.ssh\id_ed25519_personal"

# 1. 创建或修改SSH配置文件
$sshConfigPath = "$HOME\.ssh\config"
$proxyCommand = '"C:\Program Files\Git\mingw64\bin\connect.exe" -H 127.0.0.1:10808 %h %p'

@"
# 全局代理配置
Host github.com
    User git
    Hostname ssh.github.com
    Port 443
    ProxyCommand $proxyCommand
    IdentityFile ~/.ssh/id_ecdsa
"@ | Out-File -FilePath $sshConfigPath -Encoding utf8BOM -Force

# 设置控制台编码为UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 检查SSH主机密钥
ssh -T git@github.com 2>&1 | Out-Host

# 输出提示信息
Write-Host "SSH配置已完成。请按提示输入 'yes' 继续连接。" -ForegroundColor Green
Write-Host "如果需要重新配置，请删除 ~/.ssh/known_hosts 文件并重新运行脚本。" -ForegroundColor Yellow

# 2. 启动SSH代理服务并添加密钥
#Start-Service ssh-agent
#ssh-add "$HOME\.ssh\id_ed25519"

# 3. 强制HTTPS走SSH协议
git config --global url."git@github.com:".insteadOf "https://github.com/"

# 4. 验证配置
$testResult = ssh -T git@github.com 2>&1
if ($testResult -match "successfully authenticated") {
    Write-Host "✅ SSH代理配置成功！" -ForegroundColor Green
} else {
    Write-Host "❌ 配置失败，请检查代理设置" -ForegroundColor Red
    exit 1
}

# 代理切换函数
function Set-GitProxy {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("HTTP","SOCKS5")]
        $Protocol,
        $PHost = "127.0.0.1",
        $Port = 10808
    )

    $proxyFlag = if ($Protocol -eq "HTTP") { "-H" } else { "-S" }
    (Get-Content $sshConfigPath) -replace "ProxyCommand .+", "ProxyCommand `"C:\Program Files\Git\mingw64\bin\connect.exe`" $proxyFlag ${Host}:${Port} %h %p" | Set-Content $sshConfigPath
    Write-Host "已切换为${Protocol}代理：${PHost}:${Port}"
}