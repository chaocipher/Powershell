####################################################################################
#  Created by Joshua Brown
#  On 04/16/2018
#
#  Objective: Lists members in protected admin groups:
#             'Enterprise Admins', 
#             'Schema Admins', 
#             'Server Operators', 
#             'Domain Admins',
#             'Administrators',
#             'Backup Operators'
#
#
#  ScriptName: Admin Report
#
#################################################################################### 

Import-Module ActiveDirectory

$varFromAddress = ""
$varToAddress = ""
$varSMTPServer = ""
$varTargetDC = ""


$output = 'Enterprise Admins', 'Schema Admins', 'Server Operators', 'Backup Operators' | ForEach-Object {
    $groupName = $_
    get-adgroup -server $varTargetDC -filter "name -eq '$groupName'" -SearchBase "CN=Users,DC=state,DC=az" | Get-ADGroupMember | Get-ADUser | Select-Object GivenName, Surname, Name, SamAccountName, @{n='GroupName';e={ $groupName }}|ConvertTo-HTML
}


send-mailmessage -from $varFromAddress -to $varToAddress -subject "" -BodyAsHtml ($output | Out-String -Width 200) -priority High -smtpServer $varSMTPServer 
