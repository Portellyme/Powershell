Class Car {
	[String]$Make
	[String]$Model
	
	
	[Object]Clone()
	{
		Return $this.MemberwiseClone()
	}
	[void]Display()
	{
		Write-host "The car model is: $($this.Model) and make: $($this.Make)"
	}
}
$Citroen = $null
$Citroen = [Car]::New()
$Citroen.make = "Citroen"
$Citroen.Model = "DS3"
$Citroen
$Citroen.Display()


$SecondCar = $null
$SecondCar = $Citroen.Clone()

$Citroen.Make = "Prout"
$SecondCar
$SecondCar.Display()

$Citroen
$Citroen.Display()