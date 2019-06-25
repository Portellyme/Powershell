Function PipelineTo-Loop
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Source
	)
	
	Begin
	{
		write-host "Begin Data"
	}
	Process
	{
		Try
		{
			If ($Source -eq "5")
			{
				Throw [system.exception]::new(("Non pas la source N°: $($Source)"))
			}
			Write-Host "Processing source N°: $($Source)"
			
		}
		Catch
		{
			$_.Exception.Message
		}
	}
	End
	{
		write-host "End Data"
	}
}


1..10 | PipelineTo-Loop 

# 1..10 | ForEach-Object { PipelineTo-Loop -Source $_}
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