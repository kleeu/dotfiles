
# =============================================================================
# PowerShell Profile
# file: PowerShell_profile.ps1
# encoding: utf-8
# date: 2026-02-28 14:45:54
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
# 3. 其他功能
# -----------------------------------------------------------------------------

