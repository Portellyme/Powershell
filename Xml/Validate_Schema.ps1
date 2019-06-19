
Function Test-ValidateXmlFile
{
<#
	.SYNOPSIS
		Use XSD schema to validate an XML file structure 
		Accept Schema URL or Schema Object and XML File
		In the Schema is not an object, the object is create using the fucntion 
	
	.DESCRIPTION
		XML Structure validator 
	
	.PARAMETER SchemaFIle
		Path of the schema (xsd) file use to validate the structure
	
	.PARAMETER XsdSchema
		Schema Object [System.Xml.Schema.XmlSchema] use to validate the structure
	
	.PARAMETER XmlFile
		XML File to test against the Schema
	
	.NOTES
		If both schema file and schema object are provided, 
		the script will all always used the [System.Xml.Schema.XmlSchema]
#>	
	Param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
				If (-Not ([System.IO.File]::Exists($_)))
				{
					Throw "File `"{0}`" does not exist" -f $_
				}
				Return $True
			})]
		[System.IO.FileInfo]
		$SchemaFIle,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
				If (-Not ([System.IO.File]::Exists($_)))
				{
					Throw "File `"{0}`" does not exist" -f $_
				}
				Return $True
			})]
		[System.IO.FileInfo]
		$XmlFile
	)
	$script:ErrorCount = 0
	#Create the ValidationEventHandler
	$handler = [System.Xml.Schema.ValidationEventHandler] {
		$args = $_ # entering new block so copy $_
		
		Switch ($args.Severity)
		{
			Error {
				# Exception is an XmlSchemaException
				Write-Host "ERROR: line $($args.Exception.LineNumber)" -nonewline
				Write-Host " position $($args.Exception.LinePosition)"
				Write-Host $args.Message
				$script:ErrorCount++
				Break
			}
			Warning {
				# So far, everything that has caused the handler to fire, has caused an Error...
				# So this /might/ be unreachable
				Write-Host "Warning:: " + $args.Message
				$script:ErrorCount++
				Break
			}
		}
	}
	
	
	Try
	{
		$XmlSchema = Get-XMLSchema -SchemaFIle $SchemaFIle

		$SchemaSettings = [System.Xml.XmlReaderSettings]::new()
		[void]$SchemaSettings.Schemas.Add($XmlSchema)
		$SchemaSettings.ValidationType = [System.Xml.ValidationType]::Schema
		$SchemaSettings.add_ValidationEventHandler($handler)
		
		$XmlReader = [System.Xml.XmlTextReader]::Create($XmlFile, $SchemaSettings)
		
		While ($XmlReader.Read())
		{
		}
		$XmlReader.Close()
		
		Return $script:ErrorCount
	}
	Catch
	{
		Write-Output $_.Exception
		Write-Output ("The process {0} failed." -f $_.Exception.Message)
		Return $false
	}
}


Function Get-XMLSchema
{
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({
				If (-Not ([System.IO.File]::Exists($_)))
				{
					Throw "File `"{0}`" does not exist" -f $_
				}
				Return $True
			})]
		[System.IO.FileInfo]
		$SchemaFIle
	)
	
	Try
	{
		$XsdReader = [System.Xml.XmlTextReader]::new($SchemaFIle)
		$XsdSchema = [System.Xml.Schema.XmlSchema]::Read($XsdReader, $null)
		
		Return $XsdSchema
	}
	Catch
	{
		Write-Output ("The process {0} failed." -f $_.Exception.Message)
		Return
	}
	Finally
	{
		If ($XsdReader)
		{
			$XsdReader.Close()
		}
	}
}





$XMLSchemaPath = "C:\Work\Cmdb_Repos\Initialize\Tools\Runtimes\Runtime_Node.xsd"


$XmlFile = "C:\Work\Cmdb_Repos\Initialize\Tools\Runtimes\Strawberry_Perl_Portable.xml"

Test-ValidateXmlFile -SchemaFIle $XMLSchemaPath -XmlFile $XmlFile





