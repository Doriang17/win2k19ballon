$url = "https://img.doriangaliana.fr/qemu-ga-x64.msi"
$output = "$PSScriptRoot\qemu-ga-x64.msi"
$start_time = Get-Date

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

$url1 = "https://img.doriangaliana.fr/2k19.zip"
$output1 = "$PSScriptRoot\2k19.zip"
$start_time1 = Get-Date

Invoke-WebRequest -Uri $url1 -OutFile $output1
Write-Output "Time taken: $((Get-Date).Subtract($start_time1).Seconds) second(s)"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip "C:\Users\Administrateur\Desktop\2k19.zip" "C:\Program Files\Balloon"
##############Install Ballon drivers################
Get-ChildItem "C:\Program Files\Balloon\2k19\amd64\" -Recurse -Filter "*.inf" | 
ForEach-Object { PNPUtil.exe /add-driver $_.FullName /install }

timeout 5 
######### start the Balloning services ############
cd "C:\Program Files\Balloon\2k19\amd64\"
.\blnsvr.exe -i
######### Install Qemu-Guest-Agent ###############
cd "C:\Users\Administrateur\Desktop"
.\qemu-ga-x64.msi

echo "Reboot in 15 seconds"

timeout 10

Remove-Item qemu-ga-x64.msi
Remove-Item 2k19.zip 

shutdown -r -t 5
