$tests = Read-Host "Which tests would you like to run"
$svc = Read-Host "Which services would you like to test"
$env = Read-Host "Which environment would you like to test in"

Write-Output "Test selected: $tests, service selected $svc, environment selected $env"

Write-Output "Beginning Tests..."

$config = ([xml](Get-Content config.xml)).root
$auth = $config.username + ':' + $config.password
$Encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
$authorizationInfo = [System.Convert]::ToBase64String($Encoded)
$headers = @{
    "Authorization"="Basic $($authorizationInfo)"
    "Content-Type"="application/json"
    }
$body = “{`n    `“resources`“: {`n        `“repositories`“: {`n            `“self`“: {`n                `“refName`“: `“refs/heads/azure-pipeline`“`n            }`n        }`n    },    `n    `“templateParameters`“: {`n        `“pomFile`“: `“pom.xml`“`n    }`n}”

$response = Invoke-RestMethod ‘https://dev.azure.com/extHungSang/SonarCubeExample/_apis/pipelines/3/runs?api-version=6.0-preview.1’ -Method ‘POST’ -Headers $headers -Body $body
$response | ConvertTo-Json

Write-Output $headers