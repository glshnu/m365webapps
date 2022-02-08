function unInstallTeams($path) {

  $clientInstaller = "$($path)\Update.exe"
  
   try {
        $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction STOP

        if ($process.ExitCode -ne 0)
    {
      Write-Error "UnInstallation failed with exit code  $($process.ExitCode)."
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }

}

Write-Host "Stopping Teams Process" -ForegroundColor Yellow

try{
    Get-Process -ProcessName Teams | Stop-Process -Force
    Start-Sleep -Seconds 3
    Write-Host "Teams Process Sucessfully Stopped" -ForegroundColor Green
}catch{
    echo $_
}

# Remove Teams Machine-Wide Installer
Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow

$MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
$MachineWide.Uninstall()

# Remove Teams for Current Users
$localAppData = "$($env:LOCALAPPDATA)\Microsoft\Teams"
$programData = "$($env:ProgramData)\$($env:USERNAME)\Microsoft\Teams"


If (Test-Path "$($localAppData)\Current\Teams.exe") 
{
  unInstallTeams($localAppData)
    
}
elseif (Test-Path "$($programData)\Current\Teams.exe") {
  unInstallTeams($programData)
}
else {
  Write-Warning  "Teams installation not found"
}

# Cleaning TEAMS Files
#
Write-Host "Clearing Teams Files" -ForegroundColor Yellow

try{
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\" | Remove-Item -Confirm:$false
    Get-ChildItem -Path $env:LOCALAPPDATA\"Microsoft\teams\" | Remove-Item -Confirm:$false
    Get-ChildItem -Path $env:LOCALAPPDATA\"Microsoft\TeamsPresenceAddin\" | Remove-Item -Confirm:$false
    Write-Host "Teams Disk Cleaned" -ForegroundColor Green
}catch{
    echo $_
}

Write-Host "Stopping Chrome Process" -ForegroundColor Yellow

try{
    Get-Process -ProcessName Chrome| Stop-Process -Force
    Start-Sleep -Seconds 3
    Write-Host "Chrome Process Sucessfully Stopped" -ForegroundColor Green
}catch{
    echo $_
}

Write-Host "Clearing Chrome Cache" -ForegroundColor Yellow

try{
    Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Cache" | Remove-Item -Confirm:$false
    Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Web Data" -File | Remove-Item -Confirm:$false
    Write-Host "Chrome Cleaned" -ForegroundColor Green
}catch{
    echo $_
}

Write-Host "Stopping IE Process" -ForegroundColor Yellow

try{
    Get-Process -ProcessName MicrosoftEdge | Stop-Process -Force
    Get-Process -ProcessName IExplore | Stop-Process -Force
    Write-Host "Internet Explorer and Edge Processes Sucessfully Stopped" -ForegroundColor Green
}catch{
    echo $_
}

Write-Host "Clearing IE Cache" -ForegroundColor Yellow

try{
    RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
    Write-Host "IE and Edge Cleaned" -ForegroundColor Green
}catch{
    echo $_
}

Write-Host "Cleanup Complete... Launching Teams" -ForegroundColor Green


