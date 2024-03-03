Function Copy-PSObject
{
    <#
      .SYNOPSIS
        This function makes a copy of any object by value, not reference.
      .DESCRIPTION
        This function makes a copy of any object by value, not reference. PowerShell by default copies
        any object by reference. Any changes made to the copy is also made to the original as they are
        the same object. This functions makes a copy of the original object by value, leaving the
        original object unchanged when you modify the copy.
 
        NB: The copy is made using serialization which may adversely affect some object types.
      .INPUTS
        [PSObject]
      .OUTPUTS
        [PSObject]
      .EXAMPLE
        $NewObject = Copy-PSObject $Object
        Creates a new object with the same value as $Object.
      .EXAMPLE
        $NewObject = Copy-PSObject -InputObject $Object
        Creates a new object with the same value as $Object.
      .EXAMPLE
        $Object | $NewObject = Copy-PSObject
        Creates a new object with the same value as $Object.
      .NOTES
      NAME: Copy-PSObject
      .LINK
      Source from Hugo Klemmestad
      Source https://github.com/ecitsolutions/Autotask
 
  #>
	[CmdLetBinding()]
	Param
	(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeLine = $true,
			Position = 0
		)]
		[PSObject]$InputObject
	)
	
	Begin
	{
		$Stream = New-Object System.IO.MemoryStream
		$Binary = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
	}
	Process
	{
		$Binary.Serialize($Stream, $InputObject)
		$Stream.Position = 0
	}
	
	End
	{
		$Binary.Deserialize($Stream)
		$Stream.Close()
	}
}
