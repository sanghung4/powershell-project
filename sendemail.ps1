Function SendGridMailWithAttachment {
    param (
        [cmdletbinding()]
        [parameter()]
        [string]$ToAddress,
        [parameter()]
        [string]$FromAddress,
        [parameter()]
        [string]$Subject,
        [parameter()]
        [string]$Body,
        [parameter()]
        [string]$APIKey,
        [parameter()]
        [string]$FileName,
        [parameter()]
        [string]$FileNameWithFilePath,
		[parameter()]
        [string]$AttachementType
    )

    #Convert File to Base64
    $FileContent = get-content $FileNameWithFilePath
    $ConvertToBytes = [System.Text.Encoding]::UTF8.GetBytes($FileContent)
    $EncodedFile = [System.Convert]::ToBase64String($ConvertToBytes)

    # Body with attachement for SendGrid
    $SendGridBody = @{
        "personalizations" = @(
            @{
                "to"= @(
                              @{
                                   "email" = $ToAddress
                               }
                 )

                "subject" = $Subject
            }
        )

                "content"= @(
                              @{
                                    "type" = "text/html"
                                    "value" = $Body
                               }
                 )

                "from"  = @{
                            "email" = $FromAddress
                           }

                "attachments" = @(
                                    @{
                                        "content"=$EncodedFile
                                        "filename"=$FileName
                                        "type"= $AttachementType
                                        "disposition"="attachment"
                                     }
               )
}

    $BodyJson = $SendGridBody | ConvertTo-Json -Depth 4


    #Header for SendGrid API
    $Header = @{
        "authorization" = "Bearer $APIKey"
    }

    #Send the email through SendGrid API
    $Parameters = @{
        Method      = "POST"
        Uri         = "https://api.sendgrid.com/v3/mail/send"
        Headers     = $Header
        ContentType = "application/json"
        Body        = $BodyJson
    }
    Invoke-RestMethod @Parameters
}

$Parameters = @{
    ToAddress   = "sangvhung@gmail.com"
    FromAddress = "exthung.sang@bcg.com"
    Subject     = "Powershell script test result report"
    Body        = "Build Completed"
    APIKey       = ""
    FileName ="emailable-report.html"
    FileNameWithFilePath = "/Users/hungsang/Documents/JavaProjectDemo/target/surefire-reports/emailable-report.html"
    AttachementType ="text/html"
}
SendGridMailWithAttachment @Parameters
