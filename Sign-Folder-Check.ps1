
####################################################################################
#  Created by TJ Swanson and updated by Joshua Brown
#  On 08/1/2017
#
#  Objective: To sign executables with an internal cert if the code is developed in-
#             house or an executable from a vendor that has not signed their code.
#
#
#  ScriptName: Sign-Folder-Check.ps1
#
#################################################################################### 


#Comment the next line for production use.
$DebugPreference = "Continue"

#Default path.
$path=""

#Inputbox to allow copy past of alternate paths.
Add-Type -AssemblyName Microsoft.VisualBasic
$path = [Microsoft.VisualBasic.Interaction]::InputBox('Enter a folder path', 'Path', "$path")

#Get certificate to use.
$cert=get-pfxcertificate -filepath ""



#$cert=@(Get-ChildItem cert:\CurrentUser\My -CodeSigning)[0]


#Find exe files that have not been signed before.
#$files=get-childitem -Path $path -Recurse -Include *.exe | foreach-object {Get-AuthenticodeSignature $_} | where-object {$_.status -eq "NotSigned"} 

#Loop through each unsigned exe file and sign them with the certificate we chose earlier.
#$files.Path | foreach-object {Set-AuthenticodeSignature -filepath $_ -certificate $cert}



#Find exe files that have not been signed before.
#$files=get-childitem -Path $path -Recurse -Include *.exe | foreach-object {Get-AuthenticodeSignature $_} | where-object {$_.status -eq "NotSigned"}|Set-AuthenticodeSignature -FilePath $_ -certificate $cert
#$files=get-childitem -Path $path -Recurse -Include *.exe | foreach-object {Get-AuthenticodeSignature $_} | where-object {$_.status -eq "NotSigned"}|Set-AuthenticodeSignature -certificate $cert

$files=get-childitem -Path $path -Recurse -Include *.exe 
for ($i=0; $i -lt $files.Count; $i++) {
    Write-Debug  $files[$i].FullName 
    $Signature = Get-AuthenticodeSignature $files[$i]
    # Write-Debug $Signature.status
    # Write-Debug $Signature.SignerCertificate
    # Write-Debug $Signature.SignerCertificate.Issuer 
    
    if ($Signature.status -eq "NotSigned")
        {
            Set-AuthenticodeSignature -FilePath $files[$i] -certificate $cert
            Write-Debug $Signature.status
        }
    else
        {
            if ($Signature.SignerCertificate.Issuer -eq "CN=, DC=, DC=, DC=")
                {
                     Set-AuthenticodeSignature -FilePath $files[$i] -certificate $cert

                }
            else
                {
                    Write-Debug $Signature.SignerCertificate        
                }

        }
    Write-Debug $Signature.status
    Write-Debug $Signature.SignerCertificate
    
}

