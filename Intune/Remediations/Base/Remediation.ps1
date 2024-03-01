
#region 32BitRestarter
# If we are running as a 32-bit process on an x64 system, re-launch as a 64-bit process
# Idea is stolen from Michael Niehaus - https://oofhours.com
if ($env:PROCESSOR_ARCHITEW6432 -ne 'ARM64')
{
   if (Test-Path -Path ('{0}\SysNative\WindowsPowerShell\v1.0\powershell.exe' -f $env:WINDIR) -ErrorAction SilentlyContinue)
   {
      & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy bypass -File $PSCommandPath
      Exit $lastexitcode
   }
}
#endregion 32BitRestarter


#region Function Declaration
Function Write-Log
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String]$Message,
		[Parameter(Mandatory = $true)]
		[ValidateSet('Detection', 'Remediation')]
		[String]$Component,
		[Parameter(Mandatory = $true)]
		[ValidateSet('Info', 'Warning', 'Error')]
		[Alias('LogLevel')]
		[String]$Type
	)
	
	Switch ($Type)
	{
		"Info" { [int]$Type = 1 }
		"Warning" { [int]$Type = 2 }
		"Error" { [int]$Type = 3 }
	}
	
	$TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
	$DateGenerated = Get-Date -Format MM-dd-yyyy
	$Thread = ""
	$File = ""
	
	$Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="{5}" file="{6}">'
	$LineFormat = $Message, $TimeGenerated, $DateGenerated, $Component, $Type, $Thread, $File
	
	$LogLine = $Line -f $LineFormat
	
	$LogLine | Out-File -FilePath $logFilePath -Append -Encoding utf8
	
}
#endregion


#region Global Declaration 
$logPath = 'C:\Users\Public\MDM\Remediations'
$logFileName = "TO_BE_DEFINED.log"
$logFilePath = [System.IO.Path]::Combine($logPath, $logFileName)


#endregion 


#region Main
Try
{
	#Check if logpath exists and create it if not present
	If (-not (Test-Path -Path $LogPath -PathType Container))
	{
		new-item -force -path $LogPath -ItemType Directory | Out-Null
	}
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	Write-Log "An error occurred while creating the logpath: $ErrorMessage"
	Exit 0
}

#REMEDIATION
Try
{











}
Catch
{
	$errMsg = $_.Exception.Message
	Write-Log -Message $errMsg -Component Detection -Type Error
	Exit 0
}
#endregion 
