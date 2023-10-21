
Function Clone-Object ($InputObject)
{
    <#
    .SYNOPSIS
    Use the serializer to create an independent copy of an object, useful when using an object as a template
    #>
	[System.Management.Automation.PSSerializer]::Deserialize(
		[System.Management.Automation.PSSerializer]::Serialize(
			$InputObject
		)
	)
}

Class Car {
	[String]$Make
	[String]$Model
}

$Citroen = $null
$Citroen = [Car]::New()
$Citroen.make = "Citroen"
$Citroen.Model = "DS3"
$Citroen

$SecondCar = Clone-Object -InputObject $Citroen
$SecondCar.Make = "papa"


$Citroen.Make = "Prout"

$SecondCar
$Citroen
