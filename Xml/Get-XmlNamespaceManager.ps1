<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.232
	 Created on:   	08/10/2023 12:37
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Function Get-XmlNamespaceManager([xml]$XmlDocument, [string]$NamespaceURI = "")
{
	# If a Namespace URI was not given, use the Xml document's default namespace.
	If ([string]::IsNullOrEmpty($NamespaceURI)) { $NamespaceURI = $XmlDocument.DocumentElement.NamespaceURI }
	
	# In order for SelectSingleNode() to actually work, we need to use the fully qualified node path along with an Xml Namespace Manager, so set them up.
	[System.Xml.XmlNamespaceManager]$xmlNsManager = New-Object System.Xml.XmlNamespaceManager($XmlDocument.NameTable)
	$xmlNsManager.AddNamespace("ns", $NamespaceURI)
	Return, $xmlNsManager # Need to put the comma before the variable name so that PowerShell doesn't convert it into an Object[].
}

#Method to use in Class 
[System.Xml.XmlNamespaceManager]Get_XmlNamespaceManager([xml]$XmlDocument, [string]$NamespacePrefix, [string]$NamespaceURI)
{
	# If a Namespace URI is not given, use the Xml default namespace.
	If ([string]::IsNullOrEmpty($NamespaceURI)) { $NamespaceURI = $XmlDocument.DocumentElement.NamespaceURI }
	
	# If a Namespace Prefix is not given, use the ns default namespace.
	If ([string]::IsNullOrEmpty($NamespacePrefix)) { $NamespacePrefix = "ns" }
	
	# In order for SelectSingleNode() to actually work, we need to use the fully qualified node path along with an Xml Namespace Manager.
	[System.Xml.XmlNamespaceManager]$xmlNsManager = [System.Xml.XmlNamespaceManager]::new($XmlDocument.NameTable)
	$xmlNsManager.AddNamespace($NamespacePrefix, $NamespaceURI)
	
	Return $xmlNsManager
}




