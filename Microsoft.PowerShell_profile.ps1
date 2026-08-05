
# =============================================================================
# PowerShell Profile
# file: PowerShell_profile.ps1
# encoding: utf-8
# date: 2026-08-05 13:58:00
# =============================================================================

# 打印提示信息
function Show-CmdTip {
    param(
        [string]$UserCmd,
        [string]$RealCmd
    )
    Write-Host "-> Using alias: $UserCmd = $RealCmd" -ForegroundColor DarkGray
}

# -----------------------------------------------------------------------------
# 1. 哈希函数
# -----------------------------------------------------------------------------
# 支持算法: MD2, MD4, MD5, SHA1, SHA256, SHA384, SHA512
$hashAlgos = "MD2", "MD4", "MD5", "SHA1", "SHA256", "SHA384", "SHA512"

foreach ($algo in $hashAlgos) {
    $functionCode = @"
    function global:$algo {
        `$userCmd = "$algo `$args"
        `$realCmd = "certutil -hashfile `$args $algo"
        Show-CmdTip `$userCmd `$realCmd
        certutil -hashfile `$args $algo
    }
"@
    Invoke-Expression $functionCode
}

# -----------------------------------------------------------------------------
# 2. 命令名称映射
# -----------------------------------------------------------------------------

# [su] -> 以管理员身份在当前目录打开 Windows Terminal
function su {
    $currentPath = $PWD.ProviderPath
    $argList = "-d `"$currentPath`" powershell"
    Show-CmdTip "su" "Start-Process wt -ArgumentList '$argList' -Verb runAs"
    Start-Process wt -ArgumentList $argList -Verb runAs
}

# [grep] -> Select-String
function grep {
    $argsStr = $args -join ' '
    Show-CmdTip "grep $argsStr" "Select-String $argsStr"
    Select-String @args
}

# [ifconfig] -> ipconfig
function ifconfig {
    $argsStr = $args -join ' '
    Show-CmdTip "ifconfig $argsStr" "ipconfig $argsStr"
    ipconfig @args
}

# [which] -> Get-Command
function which {
    $argsStr = $args -join ' '
    Show-CmdTip "which $argsStr" "Get-Command $argsStr"
    Get-Command @args
}

# [touch] -> New-Item
function touch {
    $argsStr = $args -join ' '
    Show-CmdTip "touch $argsStr" "New-Item $argsStr"
    New-Item @args
}

# -----------------------------------------------------------------------------
# 3. 设置代理环境变量
# -----------------------------------------------------------------------------

$proxyHost = "127.0.0.1"
$proxyPort = 1082

function proxy {
    $httpProxy = "http://${proxyHost}:${proxyPort}"
    $socksProxy = "socks5://${proxyHost}:${proxyPort}"

    $env:http_proxy = $httpProxy
    $env:https_proxy = $httpProxy
    $env:all_proxy = $socksProxy
    $env:HTTP_PROXY = $httpProxy
    $env:HTTPS_PROXY = $httpProxy
    $env:ALL_PROXY = $socksProxy

    Write-Host "Proxy activated for this session ($proxyHost`:$proxyPort). Run 'unproxy' to deactivate." -ForegroundColor Green
}

function unproxy {
    "http_proxy", "https_proxy", "all_proxy", "HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY" |
        ForEach-Object { Remove-Item "Env:$_" -ErrorAction SilentlyContinue }

    Write-Host "Proxy deactivated for this session." -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# 4. 一些提示和错误拦截
# -----------------------------------------------------------------------------

function git {
    & git.exe @args
    $exitCode = $LASTEXITCODE

    $arguments = $args -join ' '
    if ($exitCode -ne 0 -and $args.Count -gt 0 -and $args[0] -eq 'clone' -and $arguments -match '@github\.com') {
        Write-Host ""
        Write-Host "=======================================================" -ForegroundColor Yellow
        Write-Host "Tip from PowerShell profile:" -ForegroundColor Yellow
        Write-Host "If SSH permission was denied, retry with a GitHub SSH alias:" 
        Write-Host "  Work account: git@github-work"
        Write-Host "  Personal account: git@github-personal"
        Write-Host "Example: git clone git@github-personal:torvalds/linux.git"
        Write-Host "Check your SSH aliases with: Get-Content `$HOME/.ssh/config"
        Write-Host "=======================================================" -ForegroundColor Yellow
        Write-Host ""
    }

    $global:LASTEXITCODE = $exitCode
}

function npm {
    if ($args.Count -gt 0 -and $args[0] -in @('install', 'i')) {
        Write-Host ""
        Write-Host "=======================================================" -ForegroundColor Yellow
        Write-Host "Tip from PowerShell profile:" -ForegroundColor Yellow
        Write-Host "Use 'pnpm install' instead of 'npm install' to install dependencies."
        Write-Host "=======================================================" -ForegroundColor Yellow
        Write-Host ""
        $global:LASTEXITCODE = 1
        return
    }

    & npm.cmd @args
    $global:LASTEXITCODE = $LASTEXITCODE
}

