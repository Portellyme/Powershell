#Requires -Version 5
<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.167
	 Created on:   	09/10/2019 20:42
	 Created by:   	Me
	 Organization: 	Me
	 Filename:     	MS_SQL_Query_Class
	===========================================================================
	.DESCRIPTION
		The class creates a SQL connection using the System.Data.SqlClient.SqlConnection class in .Net, 
		and gives you full access to this object for information or to manipulate parameters. 
		The class can also query the list of tables and views available in the database to help you prepare your SQL query.

	.EXAMPLE
		Instance Object
			$SQLQuery = [SQLQuery]::new()
			$SQLQuery.SQLServer = "SQL-01\Inst_SCCM"
			$SQLQuery.Database = "CM_ABC"
		
		Add a query:	
			$SQLQuery.Query = "Select top 5 * from v_R_System"
	
		Instance + Server + Database
			$SQLQuery = [SQLQuery]::new("SQL-01\Inst_SCCM","CM_ABC")
	
		Instance + Server + Database + Query 
			$SQLQuery = [SQLQuery]::new("SQL-01\Inst_SCCM","CM_ABC","Select top 5 * from v_R_System")

		Execute the Query 
			$SQLQuery.Execute()
			$SQLQuery.Execute() | Out-GridView

	.EXAMPLE
		LOAD A QUERY FROM A FILE
		You can load in a SQL query from a ".sql" file like so, passing the location of the file to the method:	
			$SQLQuery.LoadQueryFromFile("C:\Scripts\SQLScripts\OSD_info.sql")
	
	.EXAMPLE
		CHANGE THE CONNECTION STRING
		By default, the connection string will be created for you, but you can add your own custom connection string using the ConnectionString parameter:
			$SQLQuery.ConnectionString = "Server=SQL-01\inst_sccm;Database=CM_ABC;Integrated Security=SSPI;Connection Timeout=5"

	.EXAMPLE
		TIMEOUT VALUES
		There are two timeout parameters which can be set:	
			$SQLQuery.ConnectionTimeout
			$SQLQuery.CommandTimeout
		The ConnectionTimeout parameter is the maximum time in seconds PowerShell will try to open a connection to the SQL server.
		The CommandTimeout parameter is the maximum time in seconds PowerShell will wait for the SQL query to execute.

	.EXAMPLE
		GET A LIST OF VIEWS OR TABLES IN THE DATABASE
		The following two methods can be used to retrieve a list of views or tables in the database:
			$SQLQuery.ListViews()
			$SQLQuery.ListTables()
		
		The views or tables will be stored to the parameter of the same name in the object, so you can retrieve them again later.
		You can filter the list to search for a particular view or table, or group of. On the command line you could do:

			$SQLQuery.ListViews()
			$SQLQuery.Views.Rows | where {$_.Name -match "v_Client"}
		Or as a one-liner:	
			$SQLQuery.ListViews().Where({$_.Name -match "v_Client"})

	.EXAMPLE
		HIDE THE RESULTS
		By default, the Execute(), ListViews() and ListTables() methods will return the results to the console after execution. 
		You can turn this off by setting the DisplayResults parameter to $False. 
		This scenario may be useful for scripting where you may not wish to display the results right away but simply have them available in a variable.
			$SQLQuery.DisplayResults = $False


	.NOTES
		Source : https://smsagent.blog/2017/03/20/powershell-custom-class-for-querying-a-sql-server/
	
	.SYNOPSIS
		PowerShell Custom Class for Querying a SQL Server


#>


Class SQLQuery
{
	
	# Properties
	[string]$SQLServer
	[string]$Database
	[string]$Query
	[string]$QueryFile
	[string]$Path
	[int]$ConnectionTimeout = 5
	[int]$CommandTimeout = 600
	# Connection string keywords: https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectionstring(v=vs.110).aspx
	[string]$ConnectionString
	[object]$SQLConnection
	[object]$SQLCommand
	Hidden $SQLReader
	[System.Data.DataTable]$Result
	[System.Data.DataTable]$Tables
	[System.Data.DataTable]$Views
	[bool]$DisplayResults = $True
	
	# Constructor -empty object
	SQLQuery ()
	{
		Return
	}
	
	# Constructor - sql server and database
	SQLQuery ([String]$SQLServer, [String]$Database)
	{
		$This.SQLServer = $SQLServer
		$This.Database = $Database
	}
	
	# Constructor - sql server, database and query
	SQLQuery ([String]$SQLServer, [String]$Database, [string]$Query)
	{
		$This.SQLServer = $SQLServer
		$This.Database = $Database
		$This.Query = $Query
	}
	
	# Method
	LoadQueryFromFile([String]$Path)
	{
		If (Test-Path $Path)
		{
			If ([IO.Path]::GetExtension($Path) -ne ".sql")
			{
				Throw [System.IO.FileFormatException] "'$Path' does not have an '.sql' extension'"
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
	
	# Method
	[Object] Execute()
	{
		If ($This.SQLConnection)
		{
			$This.SQLConnection.Dispose()
		}
		
		If ($This.ConnectionString)
		{
			
		}
		Else
		{
			$This.ConnectionString = "Server=$($This.SQLServer);Database=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)"
		}
		
		$This.SQLConnection = [System.Data.SqlClient.SqlConnection]::new()
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
			$This.SQLCommand.CommandTimeout = $This.CommandTimeout
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
	
	
	# Method
	[Object] ListTables()
	{
		
		If ($This.ConnectionString)
		{
			$TableConnectionString = $This.ConnectionString
		}
		Else
		{
			$TableConnectionString = "Server=$($This.SQLServer);Database=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)"
		}
		
		$TableSQLConnection = [System.Data.SqlClient.SqlConnection]::new()
		$TableSQLConnection.ConnectionString = $TableConnectionString
		
		Try
		{
			$TableSQLConnection.Open()
		}
		Catch
		{
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		Try
		{
			$TableQuery = "Select Name from Sys.Tables Order by Name"
			
			$TableSQLCommand = $TableSQLConnection.CreateCommand()
			$TableSQLCommand.CommandText = $TableQuery
			$TableSQLCommand.CommandTimeout = $This.CommandTimeout
			$TableSQLReader = $TableSQLCommand.ExecuteReader()
		}
		Catch
		{
			$TableSQLConnection.Close()
			$TableSQLConnection.Dispose()
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		If ($TableSQLReader)
		{
			$This.Tables = [System.Data.DataTable]::new()
			$This.Tables.Load($TableSQLReader)
			$TableSQLConnection.Close()
			$TableSQLConnection.Dispose()
		}
		
		If ($This.DisplayResults)
		{
			Return $This.Tables
		}
		Else
		{
			Return $null
		}
		
	}
	
	# Method
	[Object] ListViews()
	{
		
		If ($This.ConnectionString)
		{
			$ViewConnectionString = $This.ConnectionString
		}
		Else
		{
			$ViewConnectionString = "Server=$($This.SQLServer);Database=$($This.Database);Integrated Security=SSPI;Connection Timeout=$($This.ConnectionTimeout)"
		}
		
		$ViewSQLConnection = [System.Data.SqlClient.SqlConnection]::new()
		$ViewSQLConnection.ConnectionString = $ViewConnectionString
		
		Try
		{
			$ViewSQLConnection.Open()
		}
		Catch
		{
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		Try
		{
			$ViewQuery = "Select Name from Sys.Views Order by Name"
			
			$ViewSQLCommand = $ViewSQLConnection.CreateCommand()
			$ViewSQLCommand.CommandText = $ViewQuery
			$ViewSQLCommand.CommandTimeout = $This.CommandTimeout
			$ViewSQLReader = $ViewSQLCommand.ExecuteReader()
		}
		Catch
		{
			$ViewSQLConnection.Close()
			$ViewSQLConnection.Dispose()
			Return $(Write-host $_ -ForegroundColor Red)
		}
		
		If ($ViewSQLReader)
		{
			$This.Views = [System.Data.DataTable]::new()
			$This.Views.Load($ViewSQLReader)
			$ViewSQLConnection.Close()
			$ViewSQLConnection.Dispose()
		}
		
		If ($This.DisplayResults)
		{
			Return $This.Views
		}
		Else
		{
			Return $null
		}
		
	}
	
}