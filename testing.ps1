# create if for loop to go to the next prompt
$continue = $false
While (!$continue) {
    $tests = Read-Host "Which tests would you like to run? `n 1 - Suite 1 `n 2 - Suite 2 `n Q - Quit `n"
    if ($tests -eq "1") {
        $continue = $true
    }
    elseif ($tests -eq "2") {
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
    $svc = Read-Host "Which services would you like to test? `n 1 - Teller `n 2 - Loan `n 3 - DO `n Q - Quit `n"
    if ($svc -eq "1") {
        $svc = 'pom.xml'
        $continue = $true
        }
    elseif ($tests -eq "2") {
        $svc = 'pomRegression.xml'
        $continue = $true
    }
    elseif ($tests -eq "2") {
        $svc = 'pomRegression.xml'
        $continue = $true
    }
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
    $env = Read-Host "Which environment would you like to test in? `n 1 - Development `n 2 - QA `n 3 - UAT `n"
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

#Write-Host "Test selected: $tests, Service selected: $svc, Environment selected: $env"

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



Write-Host "Starting Pipeline..."

$config = ([xml](Get-Content config.xml)).root
$auth = $config.username + ':' + $config.password
$Encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
$authorizationInfo = [System.Convert]::ToBase64String($Encoded)
$headers = @{
    "Authorization"="Basic $($authorizationInfo)"
    "Content-Type"="application/json"
    }
$body = “{`n    `“resources`“: {`n        `“repositories`“: {`n            `“self`“: {`n                `“refName`“: `“refs/heads/$env`“`n            }`n        }`n    },    `n    `“templateParameters`“: {`n        `“pomFile`“: `“pom.xml`“`n    }`n}”

$buildResponse = Invoke-RestMethod ‘https://dev.azure.com/extHungSang/SonarCubeExample/_apis/pipelines/6/runs?api-version=6.0-preview.1’ -Method ‘POST’ -Headers $headers -Body $body
$buildId = $buildResponse.id

$request = "https://dev.azure.com/extHungSang/SonarCubeExample/_apis/build/builds/"+$buildId+"?api-version=6.0-preview.1"
Write-Host $request
Write-Host "Triggered build ID:" $buildId "for pipeline -" $buildResponse.pipeline.name

Start-Sleep -s 5

$statusResponse = Invoke-RestMethod $request -Method ‘GET’ -Headers $headers

Write-Host "Build Status: " $statusResponse.status