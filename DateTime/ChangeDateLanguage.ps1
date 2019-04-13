#Switch Date to another format and language


[System.Globalization.CultureInfo]::CurrentCulture
#LCID             Name             DisplayName                                                                                                                                                                                       
#----             ----             -----------                                                                                                                                                                                       
#1036             fr-FR            Français (France)      
#1033             en-US            Anglais (États-Unis)    
#1031             de-DE            Allemand (Allemagne)    

#[System.Globalization.CultureInfo]::new([string]"Name")
#[System.Globalization.CultureInfo]::new([String]"Name", [boolean]$useUserOverride)
#[System.Globalization.CultureInfo]::new([int32]$culture)
#[System.Globalization.CultureInfo]::new([int32]$culture, [boolean]$useUserOverride)


#Using Current Culture
$DateCulture = [Globalization.CultureInfo]::CurrentCulture
$DateValue = ([datetime]::Parse((Get-Date -Format u), $DateCulture)).ToString("f", $DateCulture)
#Result : samedi 13 avril 2019 22:22


#Using another culture (de-DE)
$DateCulture = [Globalization.CultureInfo]::new(1031, $false)
$DateValue = ([datetime]::Parse((Get-Date -Format u), $DateCulture)).ToString("f", $DateCulture)
#Result : Samstag, 13. April 2019 22:31


#Using another culture (En-US)
$DateCulture = [Globalization.CultureInfo]::new("en-US", $false)
$DateValue = ([datetime]::Parse((Get-Date -Format u), $DateCulture)).ToString("f", $DateCulture)
#Result : Saturday, April 13, 2019 10:31 PM