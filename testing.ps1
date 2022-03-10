# create if for loop to go to the next prompt
# Prompt for tests
$continue = $false
While (!$continue) {
    $tests = Read-Host "Which tests would you like to run? `n 1 - Regression `n 2 - Smoke `n Q - Quit `n"
    if ($tests -eq "1") {
        Write-Host "_______________________________________"
        Write-Host " "
        Write-Host "Test Selected - Regression"
        Write-Host "_______________________________________"
        Write-Host " "
        $tests = "Regression"
        $continue = $true
    }
    elseif ($tests -eq "2") {
        Write-Host "_______________________________________"
        Write-Host " "
        Write-Host "Test Selected - Smoke"
        Write-Host "_______________________________________"
        Write-Host " "
        $tests = "Smoke"
        $continue = $true
    }
    elseif ($tests -eq "Q") {
        Write-Host "Exiting"
        Exit
    }
    else {
        Write-Host "Please select a valid value"
    }
}

# Prompt for Services
$continue = $false
While (!$continue) {
    $svc = Read-Host "Which services would you like to test? `n 1 - Teller `n 2 - Loan `n 3 - DO `n Q - Quit `n"
    if ($svc -eq "1") {
        Write-Host "_____________________________________________"
        Write-Host " "
        Write-Host "Service Selected - Teller"
        Write-Host "_____________________________________________"
        Write-Host " "
        $svc = 'pom.xml'
        $continue = $true
        }
    elseif ($svc -eq "2") {
        Write-Host "_____________________________________________"
        Write-Host " "
        Write-Host "Service Selected - Loan"
        Write-Host "_____________________________________________"
        Write-Host " "
        $svc = 'pomRegression.xml'
        $continue = $true
    }
    elseif ($svc -eq "3") {
        Write-Host "_____________________________________________"
        Write-Host " "
        Write-Host "Service Selected - DO"
        Write-Host "_____________________________________________"
        Write-Host " "
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

# Prompt for Environment
$continue = $false
While (!$continue) {
    $env = Read-Host "Which environment would you like to test in? `n 1 - Development `n 2 - QA `n 3 - UAT `n Q - Quit `n"
    if ($env -eq "1") {
        Write-Host "_____________________________________________"
        Write-Host " "
        Write-Host "Branch Selected - Development"
        Write-Host "_____________________________________________"
        Write-Host " "
        $env = "Development"
        $continue = $true
        }
    elseif ($env -eq "2") {
        Write-Host "_____________________________________________"
        Write-Host " "
        Write-Host "Branch Selected - QA"
        Write-Host "_____________________________________________"
        Write-Host " "
        }
    }
# Start Pipeline
Write-Host ""
Write-Host ""
Write-Host "Starting Pipeline..."
Write-Host ""

$config = ([xml](Get-Content ~/Documents/TestingPOC/powershell-project/config.xml)).root
$auth = $config.username + ':' + $config.password
$Encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
$authorizationInfo = [System.Convert]::ToBase64String($Encoded)
$headers = @{
    "Authorization"="Basic $($authorizationInfo)"
    "Content-Type"="application/json"
    }
$body = “{`n    `“resources`“: {`n        `“repositories`“: {`n            `“self`“: {`n                `“refName`“: `“refs/heads/$env`“`n            }`n        }`n    },    `n    `“templateParameters`“: {`n        `“pomFile`“: `“$svc`“`n    }`n}”

$buildResponse = Invoke-RestMethod ‘https://dev.azure.com/extHungSang/SonarCubeExample/_apis/pipelines/6/runs?api-version=6.0-preview.1’ -Method ‘POST’ -Headers $headers -Body $body
$buildId = $buildResponse.id

$request = "https://dev.azure.com/extHungSang/SonarCubeExample/_apis/build/builds/"+$buildId+"?api-version=6.0-preview.1"
#Write-Host $request
Write-Host "Triggered build ID:" $buildId "|" $buildResponse.name "| pipeline -" $buildResponse.pipeline.name

Start-Sleep -s 5

$statusResponse = Invoke-RestMethod $request -Method ‘GET’ -Headers $headers

while (($statusResponse.status -eq "notStarted") -or ($statusResponse.status -eq "inProgress" )) {
    $statusResponse = Invoke-RestMethod $request -Method ‘GET’ -Headers $headers
    Write-Host "Build Status: " $statusResponse.status
    Start-Sleep -s 15
}

$timelineRequest = "https://dev.azure.com/extHungSang/9804aa88-9db3-4b6d-a30f-e754e58b3821/_apis/build/builds/"+$buildId+"/Timeline"
If (!($statusResponse.status -eq "succeeded")) {
    $timelineResponse = Invoke-RestMethod $timelineRequest -Method ‘GET’ -Headers $headers
    forEach($record in $timelineResponse.records) {
        if (!($record.result -eq "succeeded") -and $record.type -eq "Task") {
            Write-Host "Task" $record.name "|" $record.result "|" $record.log.url
        }
    }
} else {
    Write-Host "Build Completed"
}
