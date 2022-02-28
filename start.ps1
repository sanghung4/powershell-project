
function main() {
    [CmdletBinding()]
    param (
        [int]$one, [int]$two
    )
    $sum = $one + $two

    return $sum
}
main -one 1 -two 2 #Passing in 2 numbers that will invoke the output of 3
main -one 4 -two 5
function main2() {
    [CmdletBinding()]
    param (
        [string]$one, [string]$two
    )
    $sum = $one + $two

    return $sum
}
main2 -one hello -two hi #Passing in two words to get an output of hellohi
function CheckSoftwareIsInstalled ($software) {
    #Check if application is installed, if not, then install it
    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -Match $software })
    $installed.DisplayName
    if ($installed.DisplayName -match $software) 
    {
        Write-Host $software + " is Installed"
    }
    else {
        Write-Host "Not Installed"
    }
}
function InstallJava($frameworkFolderName, $javaJDKFileName) {
    #Add automation framework packaged file name to txt file and parameterize to method
    #Add Java JDK file name to txt file and parameterize to method
    Start-Process -FilePath "C:\Users\" + $env:USER + "Desktop\" + $frameworkFolderName + "\" + $javaJDKFileName
}
function InstallDocker($frameworkFolderName, $dockerFileName) {
    #Add Docker file name to txt file and parameterize to method
    Start-Process -FilePath "C:\Users\" + $env:USER + "Desktop\" + $frameworkFolderName + "\" + $dockerFileName
}
function StartDocker() {
    param ([switch]$wait)
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -Verb RunAs
    if ($wait) {
        $attempts = 0
        "Checking Docker status..."
     
        do {
            docker ps -a #Check if docker images are initialized
            #The $? contains the last executed status of the last command
            #It contains as True if last command succeeded and False if failed
            if ($?) {
                break;
            }

            $attempts++
            "Docker not fully ready, waiting..."
            Start-Sleep 2

        } while ($attempts -le 10)
        "Pausing until initialized..."
        Start-Sleep 6
    }
    "Docker started"
}