$tests = Read-Host "Which tests would you like to run"
$svc = Read-Host "Which services would you like to test"
$env = Read-Host "Which environment would you like to test in"

Write-Output "Test selected: $tests, service selected $svc, environment selected $env"