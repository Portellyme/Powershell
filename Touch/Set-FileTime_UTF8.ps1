<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
	 Created on:   	29/11/2019 09:07
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Set-File.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#TODO : 

Create Touch version for this 

#>

$NewFile = [System.IO.File]::Open($Target, 'CreateNew', 'Write', 'None')
$Encode = [System.Text.UTF8Encoding]::new($false)
$Text = ""
$Data = $Encode.GetBytes($Text)
$NewFile.Write($Data, 0, $Data.Length)
$NewFile.Close()












