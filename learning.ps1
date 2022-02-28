$Locations = Get-CsOnlineLisLocation | 
    Select-Object LocationId, Location | 
    sort Location

$GridArguments = @{
    OutputMode = 'Single'
    Title      = 'Please select a location and click OK'
}

$Location = $Locations | Out-GridView @GridArguments | ForEach-Object {
    $_.LocationId
}

if ($Location) {
    $Arguments = @{
        Identity        = $Identity
        TelephoneNumber = $TN
        LocationID      = $Location
    }
    Set-CsOnlineVoiceUser @Arguments -WhatIf 
    # Remove -WhatIf if everything works as expected
}