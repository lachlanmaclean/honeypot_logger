#Honeypot Machine Notification v0.02
#Lachlan Maclean 2023
#First step in creating the email send script through menu based installation
#Context of a technician installing this application


function Show-Menu {
    param (
        [string]$Title = 'Honeypot Logger'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    if (Test-Path -Path "C:\Secure23\send_email.ps1") #Checks to see if the script has already been installed and displays to User
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
$Encrypted = "01000000d08c9ddf0115d1118c7a00c04fc297eb010000001aa1c202190c2f4ead49a78c48567d7d0000000002000000000010660000000100002000000033ab6d4a972552fbb7f29fe5515c360819af9bc4d803a0e4831100d3aeb502bb000000000e8000000002000020000000abcb51dac59c18892b9ae1528db3c647adbf5b55c604c5864dd7e99be7ab11bf30000000a640763ab2987685f50dc45a8fb96b7a12d9781df8bac180f2a778003bbdf4b594fe582935bde1c32dfcbee533f9df59400000003856255477e0c02c02f4fb4e3fdafb07e6c9b843d718a8573de201fc88523441277874358ad96708137ce7f06e915031205b8d3411a9b415815d25fa8e4ff579
" | Out-File "C:\Secure23\encryted.txt"


Write-Host $cred

$CUSTOMER_NAME = Read-Host -Prompt 'Enter the customer''s name'
$CUSTOMER_EMAIL =Read-Host -Prompt 'Input the customer''s email address'
#$ADMIN_EMAIL =Read-Host -Prompt 'Enter the Vendor email'
#$PASSWORD =Read-Host -Prompt 'Enter the Vendor email generated app-password'

#Generate .ps1 based on the input provided
$CODE= '
$EmailFrom = "lachlantestemail@gmail.com"

$EmailTo = "'+ $CUSTOMER_EMAIL + '"

$Subject = "Alert for Customer: '+ $CUSTOMER_NAME + '"

$Body = "'+ $HOSTNAME + ' has been compromised"

$SMTPServer = "smtp.gmail.com"

$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)

$SMTPClient.EnableSsl = $true


$password = Get-Content "c:\Secure23\encrypted.txt" | ConvertTo-SecureString 
$SMTPClient.Credentials = New-Object System.Management.Automation.PsCredential($EmailFrom,$password)




$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)' 
New-Item -Path "c:\" -Name "Secure23" -ItemType "directory"
$CODE | Out-File "C:\Secure23\send_email.ps1"  #Create file in C:/Scripts folder. Folder needs to be generated first to work. Working on this




Clear-Host

#Create new schedulued Task

$Sta = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\Secure23\send_email.ps1"
$Stt = New-ScheduledTaskTrigger -AtLogon
$Set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
Register-ScheduledTask LogAgent -Action $Sta -Trigger $Stt -Settings $Set

$taskObject = Get-ScheduledTask "LogAgent"
$taskObject.Author = "Lachlan"
$taskObject | Set-ScheduledTask
#Clear-Host


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
    Start-Job -FilePath "C:\Secure23\send_email.ps1" | Wait-Job #Runs the email send script
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

