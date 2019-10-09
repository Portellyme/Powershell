# Profile created by SAPIEN Profile Editor

# -----------------------------
# Transcript 
# -----------------------------
$paramStartTranscript = @{
	OutputDirectory = "$env:USERPROFILE\Documents\WindowsPowerShell\Transcript"
	IncludeInvocationHeader = $true
}
Start-Transcript @paramStartTranscript | out-null

# -----------------------------
# Backspace Beep
# -----------------------------
Set-PSReadlineOption -BellStyle None

# -----------------------------
# Load modules 
# #'Microsoft.PowerShell.Host' ==> Only for transcript 
# -----------------------------
$ModuleToload = @(
'Microsoft.PowerShell.Management',
'Microsoft.PowerShell.Utility'
)
 $ModuleToload | % { Import-Module $_ }
 
# -----------------------------
# Reusable objects
# -----------------------------
[string]$me = [Environment]::UserDomainName + "\" + [Environment]::UserName
#[string]$myadmin = "Define Admin UserName "
[string]$computername = [Environment]::MachineName



function space ($param)
{
	$string = $param -replace (" ","_")  
	$string = (Get-Culture).TextInfo.ToTitleCase($string.ToLower())
	Return $string
}

# -----------------------------
# Other 
# -----------------------------
Set-location $env:SystemDrive


$PSDefaultParameterValues = @{
	#Whenever you invoke Get-Help, instead of just scrolling the help text in your current window, 
	#PowerShell will open a separate pop-up help window.
	'Get-Help:ShowWindow' = $true
	#Always encode using UTF8
	'Out-File:Encoding'    = "UTF8"
	'Set-Content:Encoding' = "UTF8"
	'Add-Content:Encoding' = "UTF8"
	'Export-CSV:Encoding'  = "UTF8"
	#Test-Connection always quiet & 1 test
	'Test-Connection:Quiet' = $True
	'Test-Connection:Count' = "1"
  }


