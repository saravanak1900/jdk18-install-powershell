$JDK_VER="8u211"
$JDK_FULL_VER="8u151-b12"
$JDK_PATH="1.8.0_211"

$source64 = "https://javadl.oracle.com/webapps/download/GetFile/1.8.0_211-b12/478a62b7d4e34b78b671c754eaaf38ab/windows-i586/jdk-8u211-windows-x64.exe"
$destination64 = "C:\apps\$JDK_VER-x64.exe"
$client = new-object System.Net.WebClient
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)

Write-Host 'Checking if Java is already installed'
if ((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java")) {
    Write-Host 'No need to Install Java'
    Exit
}

Write-Host 'Downloading x86 to $destination86'

$client.downloadFile($source64, $destination64)
if (!(Test-Path $destination64)) {
    Write-Host "Downloading $destination64 failed"
    Exit
}


try {
    Write-Host 'Installing JDK-x64'
    $proc1 = Start-Process -FilePath "$destination64" -ArgumentList "/s REBOOT=ReallySuppress" -Wait -PassThru
    $proc1.waitForExit()
    Write-Host 'Installation Done.'

} catch [exception] {
    write-host '$_ is' $_
    write-host '$_.GetType().FullName is' $_.GetType().FullName
    write-host '$_.Exception is' $_.Exception
    write-host '$_.Exception.GetType().FullName is' $_.Exception.GetType().FullName
    write-host '$_.Exception.Message is' $_.Exception.Message
}

if ((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java")) {
    Write-Host 'Java installed successfully.'
}
Write-Host 'Setting up Path variables.'
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "c:\Program Files\Java\jdk$JDK_PATH", "Machine")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";c:\Program Files\Java\jdk$JDK_PATH\bin", "Machine")
Write-Host 'Done. Goodbye.'