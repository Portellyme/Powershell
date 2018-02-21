$PathToXlsx = "" 
$SheetName = ""

$objExcel = New-Object -ComObject Excel.Application
# eviter l'ouverture d'Excel
$objExcel.Visible = $false
# ouvrir le classeur