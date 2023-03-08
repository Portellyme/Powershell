<#
	.SYNOPSIS
		Use XSD schema to validate an XML file structure
		Accept Schema URL or Schema Object and XML File
		If the Schema is not provided will try to look for in the embeded Schema URL in the XML.
		URL Schema must be in XML instance namespace xsi:schemaLocation or the XML Namespaces xmlns
		
		In the Schema is not an object, the object is create using the fucntion
		
		If the Schema is an URL it will be downloaded localy to use the same functions and methods
	
	.DESCRIPTION
		XML Structure validator
	
	.PARAMETER XMLFile
		Enter the full file path of the xml file
	
	.PARAMETER XSDFile
		Enter the full file path of the schema file
	
	.PARAMETER Namespace
		XML Namespace
	
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.218
		Created on:   	28/02/2023 14:52
		Created by:   	Portelly
		Organization:
		Filename:     	Test-XmlDocumentSchema.ps1
		===========================================================================
	
	.NOTES
		- Locate the Schema
		- Reference inside the XML File
		- Input as Filename
		- URL
		
		- Locate the XML
		- Local file
		- URL
		
		- Validate the XML against the Schema
		
		- Consolidate the error output
#>
param
(
	[Parameter(ParameterSetName = 'XMLFile',
			   Mandatory = $false,
			   HelpMessage = 'Enter the full file path of the xml file')]
	[Parameter(ParameterSetName = 'SchemaFile')]
	[ValidateNotNullOrEmpty()]
	[ValidateScript({ Test-Path $_ })]
	[Alias('InputFile')]
	[string]$XMLFile,
	[Parameter(ParameterSetName = 'SchemaFile',
			   Mandatory = $false,
			   HelpMessage = 'Enter the full file path of the schema file')]
	[ValidateNotNullOrEmpty()]
	[ValidateScript({ Test-Path $_ })]
	[Alias('SchemaFile')]
	[string]$XSDFile,
	[Parameter(HelpMessage = 'XML Namespace')]
	[string]$Namespace
)

######################
#region Function Declaration 
######################
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}


#endregion


#######################
#region Classes
#######################

#endregion





######################
#region Global Declaration 
######################
[system.string] $ScriptDirectory = Get-ScriptDirectory
[system.string] $ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]


#endregion 


##############################
# region Main
##############################






#endregion 





