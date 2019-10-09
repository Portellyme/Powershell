#Requires -Version 5
<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.167
	 Created on:   	09/10/2019 18:06
	 Created by:   	Me
	 Organization: 	Me
	 Filename:     	Oracle_SQL_Query_Class.ps1
	===========================================================================
	.DESCRIPTION
		The class creates an Oracle SQL connection using Oracle.ManagedDataAccess.dll

		You can access the SQLConnection object.
		You can re-use the same SQLQuery object to run other queries.
		Only the results for the most recent query will be stored.
#>


Class OracleQuery
{
	
	# Properties
	[string]$OracleUser
	[string]$OraclePass
	[string]$OracleProtocol
	[string]$OracleServer
	[string]$OraclePort
	[string]$OraclServiceName
	[string]$Datasource
	
	[string]$Query
	[string]$QueryFile
	[object]$SQLConnection
	[string]$ConnectionString
	
	[object]$SQLCommand
	Hidden $SQLReader
	[System.Data.DataTable]$Result
	[bool]$DisplayResults = $True
	
	# Constructor -Instanciation 
	OracleQuery ()
	{
		Return
	}
	
	# Constructor - Preparation 
	OracleQuery ([String]$OraUser, [String]$OraPass, [string]$OraProtocol, [string]$OraHost, [string]$OraPort, [string]$OraServiceName)
	{
		$This.OracleUser = $OraUser
		$this.OraclePass = $OraPass
		$this.OracleProtocol = $OraProtocol
		$this.OracleServer = $OraHost
		$this.OraclePort = $OraPort
		$this.OraclServiceName = $OraServiceName
	}
	
	#Methods
	LoadQueryFromFile([String]$Path)
	{
		If (Test-Path $Path)
		{
			If ([IO.Path]::GetExtension($Path) -ne ".sql")
			{
				Throw [System.IO.FileNotFoundException] "'$Path' does not have an '.sql' extension'"
			}
			Else
			{
				Try
				{
					[String]$This.Query = Get-Content -Path $Path -Raw -ErrorAction Stop
					[String]$This.QueryFile = $Path
				}
				Catch
				{
					$_
				}
			}
			
		}
		Else
		{
			Throw [System.IO.FileNotFoundException] "'$Path' not found"
		}
	}
	
	#Method
	[Object] Execute()
	{
		If ($This.SQLConnection)
		{
			$This.SQLConnection.Dispose()
		}
		
		If (!($this.Datasource))
		{
			$this.Datasource = "(DESCRIPTION=(ADDRESS = (PROTOCOL = $($this.OracleProtocol))(HOST = $($this.OracleServer))(PORT = $($this.OraclePort)))(CONNECT_DATA=(SERVICE_NAME = $($this.OraclServiceName))))"
			
		}
		
		If (!($This.ConnectionString))
		{
			$This.ConnectionString = "User Id=$($This.OracleUser);Password=$($this.OraclePass);Data Source=$($this.Datasource)"
		}
		
		$This.SQLConnection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection
		$This.SQLConnection.ConnectionString = $This.ConnectionString
		
		Try
		{
			$This.SQLConnection.Open()
		}
		Catch
		{
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		Try
		{
			$This.SQLCommand = $This.SQLConnection.CreateCommand()
			$This.SQLCommand.CommandText = $This.Query
			$This.SQLReader = $This.SQLCommand.ExecuteReader()
		}
		Catch
		{
			$This.SQLConnection.Close()
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		If ($This.SQLReader)
		{
			$This.Result = [System.Data.DataTable]::new()
			$This.Result.Load($This.SQLReader)
			$This.SQLConnection.Close()
		}
		
		If ($This.DisplayResults)
		{
			Return $This.Result
		}
		Else
		{
			Return $null
		}
	}
}

#Mandatory components
#Odpnet Oracle.ManagedDataAccess.dll


######################
#region Oracle Declaration
######################
$ORAUser = "Oracle_UserName"
$ORAPass = "Oracle_Password"
$ORAProtocol = "TCP"
$ORAHost = "oracle_server.Fully.Qualified.Domain.Name"
$ORAPort = "1234"
$ORAServiceName = "oracle_app_prod"
$OracleQueryObject = [OracleQuery]::new($ORAUser, $ORAPass, $ORAProtocol, $ORAHost, $ORAPort, $ORAServiceName)
#endregion 

######################
#region Query Oracle Server
######################
#Load SQL Query from File 
$SQLFile = "C:\temp\Querysql"
$OracleQueryObject.LoadQueryFromFile($SQLFile)
#Or Load SQL Query from String
$SQLQuery.Query = "Select * from tblSystem"

$OracleQueryData = $OracleQueryObject.Execute()
#endregion 



