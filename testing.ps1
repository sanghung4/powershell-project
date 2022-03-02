$tests = Read-Host "Which tests would you like to run"

# create if for loop to go to the next prompt
If ($tests -eq "1") {
    Write-Host "Script:" $PSCommandPath
    Write-Host "Path:" $PSScriptRoot }
#ElseIf ($tests -eq "2") {
    #Write-Host "Script:" $PSCommandPath
    #Write-Host "Path:" $PSScriptRoot }
ElseIf ($tests -eq "Q") {
    Write-Host "##vso[task.setvariable variable=agent.jobstatus;]canceled"
    Write-Host "##vso[task.complete result=Canceled;]DONE" }



$svc = Read-Host "Which services would you like to test"

If ($tests -eq "1") {
    Write-Host "Script:" $PSCommandPath
    Write-Host "Path:" $PSScriptRoot }
ElseIf ($tests -eq "Q") {
        Write-Host "##vso[task.setvariable variable=agent.jobstatus;]canceled"
        Write-Host "##vso[task.complete result=Canceled;]DONE" }

$env = Read-Host "Which environment would you like to test in"

If ($tests -eq "1") {
    Write-Host "Script:" $PSCommandPath
    Write-Host "Path:" $PSScriptRoot }
ElseIf ($tests -eq "Q") {
        Write-Host "##vso[task.setvariable variable=agent.jobstatus;]canceled"
        Write-Host "##vso[task.complete result=Canceled;]DONE" }

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
