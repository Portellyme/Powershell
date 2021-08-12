<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
	 Created on:   	12/08/2021 14:47
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	StopwatchFormat.ps1
	===========================================================================

#>
$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()

Start-Sleep -Milliseconds 1246
$($StopWatch.Elapsed.ToString('mm\:ss\:fff'))

Start-Sleep -Milliseconds 2468
Write-Output "Is the Stopwatch running ? : $($StopWatch.IsRunning)"
$($StopWatch.Elapsed.ToString('mm\:ss\:fff'))

Start-Sleep -Milliseconds 76543

$StopWatch.Stop()

$($StopWatch.Elapsed.ToString('mm\:ss\:fff'))
Write-Output "Is the Stopwatch running ? : $($StopWatch.IsRunning)"