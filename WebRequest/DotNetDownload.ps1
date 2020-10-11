<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.181
	 Created on:   	2020-10-11 7:04 PM
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	DotNetDownload.ps1
	===========================================================================
	.SYNOPSIS
	    Downloads a file
	.DESCRIPTION
	    Downloads a file
	.PARAMETER Url
	    URL to file/resource to download
	.PARAMETER Filename
	    file to save it as locally
	.EXAMPLE
#>

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



function Get-DotNetDownload
{
<#
	.SYNOPSIS
		Download a file
	
	.DESCRIPTION
		Download a file
	
	.PARAMETER url
		A description of the az parameter.
	
	.PARAMETER filaname
		A description of the filaname parameter.
	
	.EXAMPLE
		PS C:\> Get--DotNetDownload
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[string]
		$Url,
		[string]
		$Filename
	)
	
	# Get filename
	if (!$Filename)
	{
		$Filename = [System.IO.Path]::GetFileName($Url)
		Write-Verbose "Filename not set. Using URI filename $filename"
	}
	
	# Make absolute local path
	if (![System.IO.Path]::IsPathRooted($Filename))
	{
		$FilePath = [System.IO.Path]::Combine((Get-ScriptDirectory), $Filename )
		Write-Verbose "File path not set. Using ScriptDirectory => $FilePath"
	}
	
	
	if (($Url -as [System.URI]).AbsoluteURI -ne $null)
	{
		Add-Type -AssemblyName System.Net.Http
		$HttpHandler = [System.Net.Http.HttpClientHandler]::new()
		$HttpClient = [System.Net.Http.HttpClient]::new($HttpHandler)
		[void]$HttpClient.Timeout::new(0, 2, 0)
		$CancelTokenSource = [System.Threading.CancellationTokenSource]::new()
		$ResponseMsg = $HttpClient.GetAsync([System.Uri]::new($Url), $cancelTokenSource.Token)
		$ResponseMsg.Wait()
		
		if (!$ResponseMsg.IsCanceled)
		{
			
			$Response = $ResponseMsg.Result
			if ($Response.IsSuccessStatusCode)
			{
				$DownloadedFileStream = [System.IO.FileStream]::new($FilePath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
				$CopyStreamOperation = $Response.Content.CopyToAsync($DownloadedFileStream)
				
				Write-Output "Downloading $($Filename)"
				$CopyStreamOperation.Wait()
				$DownloadedFileStream.Close()
				if ($CopyStreamOperation.Exception -ne $null)
				{
					throw $CopyStreamOperation.Exception
				}
			}
			else
			{
				Write-Verbose "Response Msg : $($ResponseMsg.Result)"
				throw "Response Message : StatusCode: $($Response.StatusCode.value__), ReasonPhrase: '$($Response.ReasonPhrase)'"
			}
			
			
		}
		
		
	}
	else
	{
		throw "Cannot download from $Url"
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
$ScriptDirectory = Get-ScriptDirectory
$ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]


#endregion 


##############################
# region Main
##############################

$FileToD = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"


Get-DotNetDownload -url $FileToD 



#endregion 









