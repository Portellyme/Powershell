

Function ButtonLoad_Click()
{
    [System.Windows.Forms.MessageBox]::Show("Hello World." , "My Dialog Box")
}


Function Show-ONRReverseForm {

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


$LvmFormTitle = "LVM - ONR - Reverse Properties"
$LvmFormWidth = "500"
$LvmFormHeight = "500"

$LvmForm = New-Object System.Windows.Forms.Form
$LvmForm.Text = $FormTitle 
$LvmForm.Size = New-Object System.Drawing.Size($LvmFormWidth,$LvmFormHeight)
$LvmForm.FormBorderStyle = "Fixed3D"
$LvmForm.MinimizeBox = $False
$LvmForm.MaximizeBox = $False
$LvmForm.WindowState = "Normal"
$LvmForm.ShowInTaskbar = $True
$LvmForm.StartPosition = "WindowsDefaultLocation"


#set icon for form using Base64
$base64IconString = "
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAuZJREF
UOI2Fk01slHUQxn/z/7/77nbFgywVarOlbLvdFtpUWAsKVIoBAyacvBgunriAxos3DyYeJB5MGg
/q2RgvQoh4oIiYkGDYsjVswW7JxoSvWpHWUOhu9919P8ZDy9qbz2kO88zMM8+MqE7x2uDxG1akX
4yIiPAMZl0MoAqqShRF2giC34s/TozI7h25ktFwOOY4+E0PUQUR3ESyRRQRojAg8JuoKjYWxw8C
IpHrjt/0+hNuHBFh99hhqk+XaUu2MV24irEOAKHv05nJkmpvx40nuDU1iV9dJvSDQXZlt3r7dmR
1dKhPi5MFVVW9NV3SAYv2gaZAXwL98P2TWl9Z0d+KRT12cFT39G/Tnb1ba0bEINYiYhjZ8yoLj/
5mw4bnmQ3hfHmGec+j+OA+tWqVuQf3yY+M8HjhIdaJISIYAAGMtQy3W86d+Z7uTIa3jxxicXERY
y2d6S72HhhjslBgeJNpkQEk35fxkgk3bq1FVblSKhP4Ptd+vcre0de5/NNF3jz6Fvfu3uGV7m1s
f3k7AEEY4nmNFYM8m2F12z3ApYsT7D8whjGG8U8/4fPPTjM7M0PK0OqMCIgg+VzGS8bjcWsNAH7
DI5F8jp+L0/xRqZDN5ajcnuXUu8ep16pYJ7bqTBhRbzRWzNqJtDyPopBNHZ0AbEyleOfYUZafLn
Nz8gbWifGwXEb/S8eguo4O87fvcuK9D1oFvv7mO05//BE9Axmul8qMnz1P7Z95FEUAR9cGUFX+L
JW5B7xx6DA/nDtLOt1FvV7nzIVLAHz5xTjWcajOLZF4YTMAjmqEasTjuQpfTVwgne5iaWmJji0d
LC4sYIzhyi+XcV2Xnt4sB7NbeHEoR7gmXHb2dtcTcTcRcyx/Tc/yCHgCbAba1kkLgDlg/1Afxli
CMKTZ9GuSH+idctC8G4thjOH/oKqoKn4Q4CvXRFXZlcsUXGsHrTFiHIMgrH9kRdFolRipEqFRsx
nc/LZyZ9+/kalCQSQPJDkAAAAASUVORK5CYII="
$iconimageBytes = [Convert]::FromBase64String($base64IconString)
$ims = New-Object IO.MemoryStream($iconimageBytes, 0, $iconimageBytes.Length)
$ims.Write($iconimageBytes, 0, $iconimageBytes.Length);
$alkIcon = [System.Drawing.Image]::FromStream($ims, $true)
$LvmForm.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())


# Add Load Folder Button
$ButtonLoad = New-Object System.Windows.Forms.Button
$ButtonLoad.Location = New-Object System.Drawing.Size(20,35) #Left, Top
$ButtonLoad.Size = New-Object System.Drawing.Size(150,30)
$ButtonLoad.Text = "Import Store Properties "$ButtonLoad.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 192);$ButtonLoad.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter;


$LvmForm.Controls.Add($ButtonLoad)

#Add Button event 
$ButtonLoad.Add_Click({ButtonLoad_Click})


#Show the Form 
[void] $LvmForm.ShowDialog()

}

Export-ModuleMember -Function 'Show-*'