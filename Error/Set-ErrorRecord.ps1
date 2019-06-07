Function Set-ErrorRecord
{
	[OutputType([string])]
	Param
	(
		
		[Parameter(Mandatory = $true)]
		[string]
		$ExceptionString,
		[Parameter(Mandatory = $true)]
		[string]
		$ErrorId,
		[Parameter(Mandatory = $true)]
		[System.Management.Automation.errorCategory]
		$ErrorCategory,
		$TargetObject
	)
	
	$Exception = [system.Exception]::new($ExceptionString)
	$ErrorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $ErrorCategory, $TargetObject)
	Write-Error -CategoryReason $ErrorCategory -CategoryTargetName $ErrorRecord.CategoryInfo.TargetName -CategoryTargetType $ErrorRecord.CategoryInfo.TargetType -ErrorRecord $ErrorRecord
	Exit $LASTEXITCODE = [int]$ErrorCategory

}