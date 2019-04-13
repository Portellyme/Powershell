
Function Switch-DateLanguage
{
<#
	.SYNOPSIS
		Switch-DateLanguage returns the date formated.
	
	.DESCRIPTION
		A detailed description of the Switch-DateLanguage function.
	
	.PARAMETER Format
		Output format of the date. Default full date
	
	.PARAMETER CultureInt
		LCID of the culture to use as output
		LCID		Name		DisplayName
		----		----		-----------
		1036		fr-FR		Français (France)
		1033		en-US		Anglais (États-Unis)
		1031		de-DE		Allemand (Allemagne)
	
	.PARAMETER CultureName
		Name of the culture to use as output
		LCID		Name		DisplayName
		----		----		-----------
		1036		fr-FR		Français (France)
		1033		en-US		Anglais (États-Unis)
		1031		de-DE		Allemand (Allemagne)
	
	.OUTPUTS
		System.String
	
	.NOTES
		If both CultureInt and CultureName are set use CultureInt by default
#>
	
	[OutputType([string])]
	Param
	(
		[Parameter(Mandatory = $false)]
		[string]
		$Format = 'f',
		[int32]
		$CultureInt,
		[string]
		$CultureName
	)
	
	Begin
	{
		
		If (!($CultureInt -eq 0 ))
		{
			[int32]$FunctionCulture = $CultureInt
		}
		ElseIf (!([string]::IsNullOrWhiteSpace(($CultureName).tostring())))
		{
			[string]$FunctionCulture = $CultureName
		}
		Else
		{
			
			$ExceptionString = "Culture not defined $($FunctionCulture)"
			$ErrorId		    = "Switch-DateLanguage"
			$ErrorCategory   = [System.Management.Automation.errorCategory]::SyntaxError
			$TargetObject    = "Switch-DateLanguage"
			
			$Exception = [system.Exception]::new($ExceptionString)
			$ErrorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $ErrorCategory, $TargetObject)
			Write-Error -CategoryReason $ErrorCategory -CategoryTargetName $ErrorRecord.CategoryInfo.TargetName -CategoryTargetType $ErrorRecord.CategoryInfo.TargetType -ErrorRecord $ErrorRecord
			Return $LASTEXITCODE = [int]$ErrorCategory
		}
		Try
		{
			$DateCulture = [System.Globalization.CultureInfo]::new($FunctionCulture, $false)
		}
		Catch
		{
			Write-Output $_.Exception
			Return $LASTEXITCODE = [int]$_.CategoryInfo.Category
		}
	}
	Process
	{
		Try
		{
			([datetime]::Parse((Get-Date -Format u), $DateCulture)).ToString($Format, $DateCulture) 
		}
		Catch
		{
			Write-Output $_.Exception
			Return $LASTEXITCODE = [int]$_.CategoryInfo.Category
		}
	}
	End
	{
		
	}
}