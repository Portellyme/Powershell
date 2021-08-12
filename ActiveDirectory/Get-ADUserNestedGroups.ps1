<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
	 Created on:   	11/08/2021 10:22
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-ADUserNestedGroups.ps1
	===========================================================================
	.DESCRIPTION
		Get all nested groups for a user in Active Directory
#>


######################
#region Function Declaration 
######################
Function Get-ADUserNestedGroups
{
	Param
	(
		[string]
		$DistinguishedName,
		[array]
		$Groups = @()
	)
	
	#Get the AD object, and get group membership.
	$ADObject = Get-ADObject -Filter "DistinguishedName -eq '$DistinguishedName'" -Properties memberOf, DistinguishedName;
	
	#If object exists.
	If ($ADObject)
	{
		#Enummurate through each of the groups.
		Foreach ($GroupDistinguishedName in $ADObject.memberOf)
		{
			#Get member of groups from the enummerated group.
			$CurrentGroup = Get-ADObject -Filter "DistinguishedName -eq '$GroupDistinguishedName'" -Properties memberOf, DistinguishedName;
			
			#Check if the group is already in the array.
			If (($Groups | Where-Object { $_.DistinguishedName -eq $GroupDistinguishedName }).Count -eq 0)
			{
				#Add group to array.
				$Groups += $CurrentGroup;
				
				#Get recursive groups.      
				$Groups = Get-ADUserNestedGroups -DistinguishedName $GroupDistinguishedName -Groups $Groups;
			}
		}
	}
	
	#Return groups.
	Return $Groups;
}


#endregion


##############################
# region Main
##############################
#Get all recursive groups a user belongs.

#The user to check.
$User = "<User DN to check>";

#Get all groups.
$Groups = Get-ADUserNestedGroups -DistinguishedName (Get-ADUser -Identity $User).DistinguishedName;

#Output all groups.
#$Groups | Select-Object Name | Sort-Object -Property Name;
$Groups.count


#endregion 


