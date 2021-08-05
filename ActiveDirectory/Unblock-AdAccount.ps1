<#
Unlock Active Directory account
Use a String Cipher to enclose User and Pass from a PSCred Object as an example 
You should never store a user account inside a script.
#>


#endregion


######################
#region Global Declaration 
######################
[system.string]$StringCipherLib = '<Cipher Library Path>'
[system.string]$NameKey = 'Ciphered Username'
[system.string]$NameSecret = 'Ciphered Password'

#Add assemblies  
Add-Type -Path $StringCipherLib

#endregion 

##############################
# region Main
##############################
$UserIdentity = "Please enter user account to unlock"

If ((Get-ADUser -Identity $UserIdentity -properties LockedOut).LockedOut)
{
	$CredUser = [Cipher.Library]::Decrypt($NameKey)
	$CredPass = ConvertTo-SecureString -AsPlainText ([Cipher.Library]::Decrypt($NameSecret)) -Force
	$PSCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $CredUser, $CredPass
	
	Unlock-ADAccount -Identity $UserIdentity -Credential $PSCreds
	
}

#endregion 