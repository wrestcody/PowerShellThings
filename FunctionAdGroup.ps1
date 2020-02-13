####
#### AD Audit Script (Domain Admins, Enterprise Admins, Schema Admins, Administrators)
#### retrieves domain privileged groups and send the output attached to an e-mail
####

function adgroup
{
Get-ADGroup -Filter * | Where-Object {
$_.Name -like 'Domain Admins' -or
$_.Name -like 'Enterprise Admins' -or
$_.Name -like 'Schema Admins'
} | ForEach-Object {
$groupname = $_.Name
Get-ADGroupMember -Identity $_ |
Select-Object @{n='GroupName';e={$groupname}}, Name,
@{n='Enabled';e={Get-ADUser $_ | Select-Object -Expand Enabled}}} | Export-Csv 'C:\temp\AD-Audit.csv' -NoType -Delimiter ","
}

# Variables
$Date = Get-Date -Format dd/MM/yyyy
$Table = "C:\temp\AD-Audit.csv"

function Send-Email
{
Param(
[string] $Path
)
$emailash=@{}
$emailash['SmtpServer'] = "your smtp server"
$emailash['to'] = @()
$emailash['to'] += "Email <email@email.com>"
$emailash['from'] = "Email <email@email.com>"
$emailash['Subject'] = "[$date] Privileged Accounts Audit"
$emailash['body'] += "Dear Administrators <br><br>"
$emailash['body'] += "Users in privileged groups are now logged.<br><br>"
#$emailash['body'] +=  ConvertTo-HTML
$emailash['body'] += "Greetings,<br>"
$emailash['body'] += "Bot user<br>"
$emailash['BodyAsHTML'] = $true
$emailash['Priority'] = 'Normal'
$emailash['Attachments'] = $Path
Send-MailMessage u/emailash
}

# Send Email
Send-Email -Path $table
