Function Get-PipelineToLoopArray
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[ValidateNotNullOrEmpty()]
		[String[]]
		$Source
	)

	Begin
	{
		write-host "Begin Data"
	}
	Process
	{
        foreach ($Item in $Source)
        {
		    Try
		    {
			    If ($Item -eq "5")
			    {
				    Throw [system.exception]::new(("Non pas la source N°: $($Item)"))
			    }
			    Write-Host "Processing source N°: $($Item)"

		    }
		    Catch
		    {
			    $_.Exception.Message
		    }
	    }
    }
	End
	{
		write-host "End Data"
	}
}

$Array = 1..10
Get-PipelineToLoopArray -Source $Array
#Get-PipelineToLoopArray -Source 55,66,77,88,89,90

1 .. 10 | Get-PipelineToLoopArray
5 | Get-PipelineToLoopArray
#Results
<#
Begin Data
Processing source N°: 1
Processing source N°: 2
Processing source N°: 3
Processing source N°: 4
Non pas la source N°: 5
Processing source N°: 6
Processing source N°: 7
Processing source N°: 8
Processing source N°: 9
Processing source N°: 10
End Data
#>