Function Format-ToTitleCase
{
<#
	.SYNOPSIS
		Formats string or number of strings to Title Case
	
	.DESCRIPTION
		Formats string or number of strings to Title Case allowing for prettty display
	
	.PARAMETER Text
		Sentence or multiple sentences to format
	
	.PARAMETER RemoveWhiteSpace
		Removes spaces after formatting string to Title Case.
	
	.PARAMETER RemoveChar
		Array of characters to remove
	
	.EXAMPLE
		Format-ToTitleCase 'me'
		
		Output:
		Me
	
	.EXAMPLE
		'me i feel good' | Format-ToTitleCase
		
		Output:
		Me I Feel Good
	
	.EXAMPLE
		'me i feel', 'not feel' | Format-ToTitleCase
		
		Output:
		Me I Feel Good
		Not Feel
	
	.EXAMPLE
		Format-ToTitleCase -Text 'This is my thing' -RemoveWhiteSpace
		
		Output:
		ThisIsMyThing
	
	.EXAMPLE
		Format-ToTitleCase -Text "This is my thing: That - No I don't want all chars" -RemoveWhiteSpace -RemoveChar ',', '-', "'", '\(', '\)', ':'
	
	.NOTES
		General notes
#>
	
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		[string[]]$Text,
		[switch]$RemoveWhiteSpace,
		[string[]]$RemoveChar
	)
	
	Begin
	{
		
	}
	
	Process
	{
		$Conversion = ForEach ($T In $Text)
		{
			$Output = (Get-Culture).TextInfo.ToTitleCase($T)
			ForEach ($Char In $RemoveChar)
			{
				$Output = $Output -replace $Char
			}
			If ($RemoveWhiteSpace)
			{
				$Output = $Output -replace ' ', ''
			}
			$Output
		}
		$Conversion
	}
	End
	{
		
	}
}
