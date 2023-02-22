#Honeypot Machine Notification v.02
#Lachlan Maclean 2023
#First step in creating the email send script through menu based installation
#Context of a technician installing this application


function Show-Menu {
    param (
        [string]$Title = 'Honeypot Logger'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    if (Test-Path -Path "C:\Scripts\send_email.ps1") #Checks to see if the script has already been installed and displays to User
    {
    Write-Host "Agent is Installed" -ForegroundColor green 
    Write-Host "1: Press '1' to install agent."
    Write-Host "2: Press '2' to edit customer details."
    Write-Host "3: Press '3' to edit vendor details"
    Write-Host "Q: Press 'Q' to quit."
    } 
    else 
    {
    Write-Host "Agent is not installed" -ForegroundColor red
    Write-Host "1: Press '1' to install agent."
    Write-Host "Q: Press 'Q' to quit."
    }
    

}

function Install-Agent {

$HOSTNAME = $env:computername
$CUSTOMER_NAME = Read-Host -Prompt 'Enter the customer''s name'
$CUSTOMER_EMAIL =Read-Host -Prompt 'Input the customer''s email address'
$ADMIN_EMAIL =Read-Host -Prompt 'Enter the Vendor email'
$PASSWORD =Read-Host -Prompt 'Enter the Vendor email generated app-password'

#Generate .ps1 based on the input provided
$CODE= '
$EmailFrom = "'+ $ADMIN_EMAIL + '"

$EmailTo = "'+ $CUSTOMER_EMAIL + '"

$Subject = "Alert for Customer: '+ $CUSTOMER_NAME + '"

$Body = "'+ $HOSTNAME + ' has been compromised"

$SMTPServer = "smtp.gmail.com"

$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)

$SMTPClient.EnableSsl = $true

$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("'+ $ADMIN_EMAIL + '", "'+ $PASSWORD + '"); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)' 

$CODE | Out-File "C:\Scripts\send_email.ps1"  #Create file in C:/Scripts folder. Folder needs to be generated first to work. Working on this

Clear-Host


######## 

# To Code:
# Create Task Scheduler task using PS. Attaching to event ID 4624
# Obfuscate all saved information

######

Write-Host "Agent installed and configured."

$result = Read-Host "Would you like to send a test email? 
[Y] Yes  [N] No"

switch ($result) {
    'Y' { 'Sending Test Email...' 
    Start-Job -FilePath "C:\Scripts\send_email.ps1" | Wait-Job #Runs the email send script
    }
    'N' { 'No Email Sent..' }
    Default{
        'No Email Sent..'
        }
    }

Write-Host "You can now exit safely."
}


function Update-Customer{
Clear-Host
Write-host "Updating Customer" #Update customer details when needed
}
function Update-Vendor{
Clear-Host
Write-host "Updating Vendor" #Update vendor details when needed

}


do
 {
    Show-Menu #Run Menu function and await user input
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    Install-Agent #run this function to install the agent
    } '2' {
    Update-Customer #run this function to update the customer details
    } '3' {
    Update-Vendor #run this function to install the vendor details
    }
    }
    pause
 }
 until ($selection -eq 'q')

