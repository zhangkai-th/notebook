<#
    .Name
        DiskCheck
    .Parameter
        DiskCheck
    .Example
        ps hello.ps1 4
#>


param(
[int] $wait_second = 3,
[int] $cap_cap = 5,
[string] $emails = "837861802@qq.com;18729961833@139.com",
[string] $smtp_server = "smtp.139.com",
[int] $smtp_port = 25,
[string] $smtp_emial = "18729961833@139.com",
[string] $email_password = "17cb117eb8fc75d4b100"
)

$global_val = ""

function send_email
{
param (
    [string]$Body
)
    $ComputerName = ''
    $ips = [System.Net.Dns]::GetHostAddresses($ComputerName) |
    Where-Object {
      $_.AddressFamily -eq 'InterNetwork'
    } | Select-Object -ExpandProperty IPAddressToString
    foreach($ip in $ips)
    {
        $Subject=$Subject+$ip+":"
    }



    $EmailFrom = $smtp_emial
    $EmailTo = $emails.Split(";")
    $Subject = $Subject+"告警"
    #$Body = "This is mail body"
    $SMTPServer = $smtp_server
    $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $smtp_port)
    $SMTPClient.EnableSsl = $true
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($smtp_emial, $email_password);
    foreach ($Email in $EmailTo)
    {
        if($Body.Length -ne 0){
            Write-Host $Email -BackgroundColor yellow
            $SMTPClient.Send($EmailFrom, $Email, $Subject, $Body)
        }
    }
}
function Read-MessageBoxDialog
{
param (
[string]$Message,
[string]$WindowTitle,
[System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
[System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::None)

Add-Type -AssemblyName System.Windows.Forms
return [System.Windows.Forms.MessageBox]::Show($Message, $WindowTitle, $Buttons, $Icon)
}
<#
   调用方法
#>
#Read-MessageBoxDialog -Message "Hello World" -WindowTitle "CustomTitleHere" -Buttons OK -Icon Information

function Read-MessageBoxDialogNew
{
param (
[string]$Message,
[int]$WaitSecond,
[string]$Title,
[int]$ButtonType=48
)
 $PopUpWin = New-Object -ComObject wscript.shell
 $PopUpWin.popup($Message,$WaitSecond,$Title,$ButtonType)
}


function get_memory
{
    $ops = Get-WmiObject -Class Win32_OperatingSystem
    "机器名      : {0}" -f $ops.csname
    "可用内存(MB): {0}" -f ([math]::round($ops.FreePhysicalMemory / 1kb, 2))
    "可用内存(GB): {0}" -f ([math]::round(($ops.FreePhysicalMemory / (1mb)), 2))
    "可用内存(GB): {0}" -f ([math]::round(($ops.TotalVisibleMemorySize / (1mb)), 2))
    "可用内存(GB): {0}" -f ([math]::round((1-$ops.FreePhysicalMemory / $ops.TotalVisibleMemorySize)*100, 2))
    $memory_percent = [math]::round((1-$ops.FreePhysicalMemory / $ops.TotalVisibleMemorySize)*100, 2)
    $total_memory = [math]::round($ops.TotalVisibleMemorySize / (1mb), 2)
    $aviable_memory = [math]::round($ops.FreePhysicalMemory / (1mb), 2)
    $global_val="内存使用量:"+$global_val+$memory_percent+"%`n"
    $global_val=$global_val+"内存总量  :"+$total_memory+"g`n"
    $global_val=$global_val+"可用内存  :"+$aviable_memory+"g`n"
    Write-Host $global_val -BackgroundColor Red
}


function DiskCheck
{
param(
[int] $WaitS = 3,
[int] $Cap = 5
)

        $ops = Get-WmiObject -Class Win32_OperatingSystem
        "机器名      : {0}" -f $ops.csname
        "可用内存(MB): {0}" -f ([math]::round($ops.FreePhysicalMemory / 1kb, 2))
        "可用内存(GB): {0}" -f ([math]::round(($ops.FreePhysicalMemory / (1mb)), 2))
        "可用内存(GB): {0}" -f ([math]::round(($ops.TotalVisibleMemorySize / (1mb)), 2))
        "可用内存(GB): {0}" -f ([math]::round((1-$ops.FreePhysicalMemory / $ops.TotalVisibleMemorySize)*100, 2))
        $memory_percent = [math]::round((1-$ops.FreePhysicalMemory / $ops.TotalVisibleMemorySize)*100, 2)
        $total_memory = [math]::round($ops.TotalVisibleMemorySize / (1mb), 2)
        $aviable_memory = [math]::round($ops.FreePhysicalMemory / (1mb), 2)
        if($memory_percent -ge 90)   #使用率大于90则发送邮件
        {
            $global_val="内存使用量:"+$global_val+$memory_percent+"%`n"
            $global_val=$global_val+"内存总量  :"+$total_memory+"GB`n"
            $global_val=$global_val+"可用内存  :"+$aviable_memory+"GB`n"
            Write-Host $global_val -BackgroundColor Red
        }
        
        


$diskinfo = Get-WmiObject -Class win32_logicaldisk | Select-Object -Property *,
@{name="device_id";e={$_.deviceid}},
@{name="free_space";e={$_.freespace/1024mb -as [float]}},
@{name="total_size";e={$_.size/1024mb -as [float]}}| Select-Object  -Property "device_id","free_space","total_size"

foreach($item in $diskinfo){
Write-Host $item.free_space
if($item.free_space  -lt $cap_cap){
$message = -join ($item.device_id," 磁盘空间不足",$cap_cap,"GB,请及时清理，剩余磁盘空间 ",("{0:N2}" -f $item.free_space),"GB")
$global_val=$global_val+$message+"`n"
#Read-MessageBoxDialogNew -Message $message  -WaitSecond $WaitS -Title "告警弹窗"
}
}
send_email $global_val
}



DiskCheck -WaitS $wait_second $cap_cap

