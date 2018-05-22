####################################################################################
#  Created by Joshua Brown
#  On 05/22/2018
#
#  Objective: List of users accounts with not using the correct naming convention
#
#
#  ScriptName: UsersNotInCorrectFormat.ps1
#
#################################################################################### 

Import-Module ActiveDirectory

$varFromAddress = ""
$varToAddress = ""
$varSMTPServer = ""
$varTargetDC = ""
$varSubjectLine = "ADOT Username Incorrect Format Report"
$varREGEX = ""

$output = Get-ADUser -Filter * -Properties *|? { $_.samaccountname -NotMatch $varREGEX}| Select-Object GivenName, Surname, Name, SamAccountName, @{n="Manager";e={(Get-ADUser -Identity $_.Manager -Properties DisplayName).DisplayName}}  |ConvertTo-HTML

send-mailmessage -from $varFromAddress -to $varToAddress -subject $varSubjectLine -BodyAsHtml ($output | Out-String -Width 200) -priority High -smtpServer $varSMTPServer 
