<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.195
	 Created on:   	19/11/2021 07:51
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-ADNestedGroups.ps1
	===========================================================================
	.DESCRIPTION
		Gets a list of nested groups inside an Active Directory group using LDAPFilter. 

	.NOTES
		To Do : Control of Presence to avoid infinite loop
#>

function Get-ADNestedGroup
{
    <#
    .SYNOPSIS
        Gets a list of nested groups inside an Active Directory group
    .DESCRIPTION
        Gets a list of nested groups inside an Active Directory group using LDAPFilter. 
		Include Group only one time to avoid ducplicate Entry
    .PARAMETER Group
        The name of an Active Directory group
    .PARAMETER Server
        The name of Domain controller to use for query. 
		Valid entries are a server name or servername:3268 for a Global Catalog query.
    .NOTES
        VERSION:     1.1
	
	.NOTES
	Object Class to Use with the Function 
	class AdNestedGroup   { 

			[string]$ParentGroup
			[string]$NestedGroup
			[string]$NestedGroupMemberCount
			[string]$ObjectClass
			[string]$ObjectCN
			[string]$DistinguishedName
			[GUID]$GUID
			
			AdNestedGroup () { }
			
			AdNestedGroup ([string]$ParentGroup, [object]$GetADGroupObj)
			{
			$this.ParentGroup = $ParentGroup
			$this.NestedGroup = $GetADGroupObj.Name
			$this.NestedGroupMemberCount = $GetADGroupObj.Members.count
			$this.ObjectClass = $GetADGroupObj.ObjectClass
			$this.ObjectCN  = $GetADGroupObj.CanonicalName
			$this.DistinguishedName = $GetADGroupObj.DistinguishedName
			$this.GUID = $GetADGroupObj.ObjectGUID
				
			}
    #>
	
	
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List`1])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[String[]]
		$Group,
		[String]
		$ADServerName = (Get-ADReplicationsite | Get-ADDomainController -SiteName $_.name -Discover -ErrorAction SilentlyContinue).name
	)
	
	BEGIN
	{
		$ADGroupList = [System.Collections.Generic.List`1[AdNestedGroup]]::new()
		
	}
	PROCESS
	{
		foreach ($ParentGrp in $Group)
		{
			#Get group information and put it in Object 
			#$ADGrpParent = Get-ADGroup -Identity $ParentGrp -Server $ADServerName
			$ADGrpParent = Get-ADGroup -Identity $ParentGrp -Properties Members, CanonicalName, ObjectGUID -Server $ADServerName
			$NestedGroupInfo = [AdNestedGroup]::new($ParentGrp, $ADGrpParent)
			
			if (($ADGroupList.Exists({ $args[0].GUID -eq $NestedGroupInfo.GUID })) -eq $false)
			{
				$ADGroupList.Add($NestedGroupInfo)
			}
			#Query AD to find Member of the group that are type 'group'
			$QueryResult = Get-ADGroup -LDAPFilter "(&(objectCategory=group)(memberof=$($ADGrpParent.DistinguishedName)))" -Properties canonicalname -Server $ADServerName
			if ($null -ne $QueryResult)
			{
				# For each group find in parent group
				#Get group information and put it in Object 
				#Call back this function with the group found
				foreach ($grp in $QueryResult)
				{
					
					$GrpLookup = Get-ADGroup -Identity "$($Grp.DistinguishedName)" -Properties Members, CanonicalName, ObjectGUID -Server $ADServerName
					$NestedGroupInfo = [AdNestedGroup]::new($ParentGrp, $GrpLookup)
					
					$ADGroupList.Add($NestedGroupInfo)
					
					$NestedAdGroupList = Get-ADNestedGroup -Group $GrpLookup.Name -ADServerName $ADServerName
					
					foreach ($NestedGroup in $NestedAdGroupList)
					{
						if (($ADGroupList.Exists({ $args[0].GUID -eq $NestedGroup.GUID })) -eq $false)
						{
							$ADGroupList.Add($NestedGroup)
						}
					}
				}
			}
		}
	}
	END
	{
		return $ADGroupList
	}
}



function Get-ADNestedUsers
{
	   <#
    .SYNOPSIS
        Gets a list of users inside an Active Directory group to work with the Previous function
    .DESCRIPTION
        Gets a list of user inside an Active Directory group using LDAPFilter. 
		User can be in multiple as the criteria is to use a List based on User.GUID & GroupName
    .PARAMETER Group
        The name of an Active Directory group
    .PARAMETER Server
        The name of Domain controller to use for query. 
		Valid entries are a server name or servername:3268 for a Global Catalog query.
    .NOTES
	Object Class to Use with the Function 
	Class AdNestedusers{
	
	# Properties
	[string]$Name #Name
	[string]$NestedGroupMember
	[string]$Enabled
	[string]$ObjectClass
	[string]$CanonicalName
	[string]$DistinguishedName
	[string]$SamAccountName
	[string]$UserPrincipalName
	[GUID]$GUID #ObjectGUID 
	
	# Constructors
	AdNestedusers () { }
	
	AdNestedusers ([string]$ParentGroup, [object]$GetADUserObj)
	{
		$this.NestedGroupMember = $ParentGroup
		$this.Enabled = $GetADUserObj.Enabled
		$this.ObjectClass = $GetADUserObj.ObjectClass
		$this.CanonicalName = $GetADUserObj.CanonicalName
		$this.DistinguishedName = $GetADUserObj.DistinguishedName
		$this.SamAccountName = $GetADUserObj.SamAccountName
		$this.Name = $GetADUserObj.Name
		$this.UserPrincipalName = $GetADUserObj.UserPrincipalName
		$this.GUID = $GetADUserObj.ObjectGUID
	}
}
	
	#>
	
	
	
	
	
	
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List`1])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[String[]]
		$Group,
		[String]
		$ADServerName = (Get-ADReplicationsite | Get-ADDomainController -SiteName $_.name -Discover -ErrorAction SilentlyContinue).name
	)
	
	BEGIN
	{
		$UserList = [System.Collections.Generic.List`1[AdNestedusers]]::new()
	}
	PROCESS
	{
		foreach ($ParentGrp in $Group)
		{
			#Get users information and put it in Object 
			$ADGrpParent = Get-ADGroup -Identity $ParentGrp -Properties Members, CanonicalName, ObjectGUID -Server $ADServerName
			#Query AD to find Member of the group that are type 'users'
			$QueryResult = Get-ADUser -LDAPFilter "(&(objectCategory=person)(memberof=$($ADGrpParent.DistinguishedName)))" -Properties canonicalname -Server $ADServerName
			# If users are present 
			if ($null -ne $QueryResult)
			{
				#For each user if it not exist in the list (GUID Base search) will add it
				foreach ($usr in $QueryResult)
				{
					#User can be in multiple groups
					#Criteria : Must not Present by GUID and By Group Name
					if ($null -eq ($UserList.where({ ($_.GUID -eq $usr.ObjectGUID) -and ($_.NestedGroupMember -eq $ParentGrp) })).GUID)
					{
						$UserList.Add([AdNestedusers]::new($ParentGrp, $usr))
					}
					
					
				}
			}
		}
	}
	END
	{
		return $UserList
	}
	
}

