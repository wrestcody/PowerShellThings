###########################################################
#  Run this first line interactively, to input your password,
#  encrypt it, and save it to a file
###########################################################

Read-Host "Enter Password" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "\\DomainName\netlogon\cred.txt"

###########################################################
#  Add these next lines to the beginning of any script
#  you wish to run with admin privilege
###########################################################

$pass = get-content "\\DomainName\netlogon\creds.txt" | ConvertTo-SecureString
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "DomainName\administrator",$pass

###########################################################
