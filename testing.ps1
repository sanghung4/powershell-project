

# create if for loop to go to the next prompt
$continue = $false
While (!$continue) {
    $tests = Read-Host "Which tests would you like to run?"
    if ($tests -eq "1") {
        Write-Host "Script:" $PSCommandPath
        Write-Host "Path:" $PSScriptRoot 
        $continue = $true
        }
    #ElseIf ($tests -eq "2") {
        #Write-Host "Script:" $PSCommandPath
        #Write-Host "Path:" $PSScriptRoot }
    elseif ($tests -eq "Q") {
        Write-Host "Exiting"
        Exit
    }
    else {
        Write-Host "Please select a valid value"
    }
}

$continue = $false
While (!$continue) {
    $svc = Read-Host "Which services would you like to test?"
    if ($svc -eq "1") {
        Write-Host "Script:" $PSCommandPath
        Write-Host "Path:" $PSScriptRoot 
        $continue = $true
        }
    #ElseIf ($tests -eq "2") {
        #Write-Host "Script:" $PSCommandPath
        #Write-Host "Path:" $PSScriptRoot }
    elseif ($svc -eq "Q") {
        Write-Host "Exiting"
        Exit
    }
    else {
        Write-Host "Please select a valid value"
    }
}

$continue = $false
While (!$continue) {
    $env = Read-Host "Which environment would you like to test in"
    if ($env -eq "1") {
        Write-Host "Branch - Development"
        $env = "Development"
        $continue = $true
        }
    elseif ($env -eq "2") {
        Write-Host "Branch - QA"
        $env = "QA"
        $continue = $true
        }
    elseif ($env -eq "3") {
        Write-Host "Branch - azure-pipeline"
        $env = "azure-pipeline"
        $continue = $true
        }
    elseif ($env -eq "Q") {
        Write-Host "Exiting"
        Exit
    }
    else {
        Write-Host "Please select a valid value"
    }
}

Write-Output "Test selected: $tests, service selected $svc, environment selected $env"

# do {
#     Write-Host "`n============= Pick the Environment=============="
#     Write-Host "`ta. '1' for the Prod Environment"
#     Write-Host "`tb. '2' for the QA Environment"
#     Write-Host "`td. 'Q' to Quit'"
#     Write-Host "========================================================"
#     $choice = Read-Host "`nEnter Choice"
#     } until (($choice -eq '1') -or ($choice -eq '2') -or ($choice -eq 'Q') )
#     switch ($choice) {
#        '1'{
#            Write-Host "`nYou have selected a Prod Environment"
#        }
#        '2'{
#           Write-Host "`nYou have selected a Test Environment"
#        }
#        'Q'{
#            Write-Host "`nYou have selected to Quit",
#           Return
#        }
    #}



Write-Output "Beginning Tests..."

$config = ([xml](Get-Content config.xml)).root
$auth = $config.username + ':' + $config.password
$Encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
$authorizationInfo = [System.Convert]::ToBase64String($Encoded)
$headers = @{
    "Authorization"="Basic $($authorizationInfo)"
    "Content-Type"="application/json"
    }
$body = “{`n    `“resources`“: {`n        `“repositories`“: {`n            `“self`“: {`n                `“refName`“: `“refs/heads/$env`“`n            }`n        }`n    },    `n    `“templateParameters`“: {`n        `“pomFile`“: `“pom.xml`“`n    }`n}”

$response = Invoke-RestMethod ‘https://dev.azure.com/extHungSang/SonarCubeExample/_apis/pipelines/3/runs?api-version=6.0-preview.1’ -Method ‘POST’ -Headers $headers -Body $body
$response | ConvertTo-Json

Write-Output $response