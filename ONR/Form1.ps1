

# Form Declaration
$FormTxt = "Titre de la Fenêtre"
$FormLbl = "Texte Du label"
$FormWidth = "500"
$FormHeight = "500"


Add-Type -AssemblyName System.Windows.Forms 
$Form = New-Object system.Windows.Forms.Form
$Label = New-Object System.Windows.Forms.Label


$Form.Text = $FormTxt
$Form.AutoScroll = $False
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"

#$Form.SizeGripStyle = "Hide"
$Form.ShowInTaskbar = $True
$Form.StartPosition = "WindowsDefaultLocation"

$Label.Text = $FormLbl

$Label.AutoSize = $True

$Form.Controls.Add($Label)

$Form.ShowDialog()


