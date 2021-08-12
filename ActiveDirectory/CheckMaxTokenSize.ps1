<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
	 Created on:   	11/08/2021 14:33
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	CheckMaxTokenSize.ps1
	===========================================================================
	.DESCRIPTION
		Basic assessment of Users SIDs and to Estimate their Token Size
		SIDHistory is not check thus Domain Local Groups are used to mock the value
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


#######################
#region Classes
#######################

#endregion


######################
#region Global Declaration 
######################
$userGroupsList = [System.Collections.Generic.List`1[object]]::new()

#endregion 


##############################
# region Main
##############################
#The user to check.
$user = '<Domain\Username>'
$domain = ($user.split("\"))[0]
$userName = ($user.split("\"))[1]


#Get Nested user groups
$Groups = Get-ADUserNestedGroups -DistinguishedName (Get-ADUser -Identity $userName).DistinguishedName;


#Get detailed groups informations
$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
foreach ($g in $Groups)
{
	$userGroupsList.Add((Get-ADGroup -Identity ($g.DistinguishedName) | Select-Object distinguishedname, groupcategory, groupscope, name))
}
$StopWatch.Stop()
$($StopWatch.Elapsed.ToString('mm\:ss\:fff'))

#Get detailled domain information
$rootdse = (Get-ADDomain $domain).distinguishedname

$domainLocalGroups = [int]@($userGroupsList | Where-Object { $_.groupscope -eq "DomainLocal" }).count
$globalGroups = [int]@($userGroupsList | Where-Object { $_.groupscope -eq "Global" }).count
$universalOutsideGroups = [int]@($userGroupsList | Where-Object { $_.distinguishedname -notlike "*$rootdse" -and $_.groupscope -eq "Universal" }).count
$universalInsideGroups = [int]@($userGroupsList | Where-Object { $_.distinguishedname -like "*$rootdse" -and $_.groupscope -eq "Universal" }).count
$tokensize = 1200 + (40 * ($domainLocalGroups + $universalOutsideGroups)) + (8 * ($domainLocalGroups + $globalGroups + $universalInsideGroups))


Write-Host "
Domain local groups: $domainLocalGroups
Global groups: $globalGroups
Universal groups outside the domain: $universalOutsideGroups
Universal groups inside the domain: $universalInsideGroups
Kerberos token size: $tokensize"


#endregion 





