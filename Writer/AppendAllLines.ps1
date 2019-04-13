
$Utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)


$FileUtf8 = "C:\temp\utf8.txt"
$FileUtf8NoBom  = "C:\temp\utf8NoBom.txt"
$Output = "Output"

#Create New file 
[System.IO.File]::WriteAllLines([string]$FileUtf8, [string[]]$Output)
[System.IO.File]::WriteAllLines([string]$FileUtf8NoBom, [string[]]$Output, $Utf8NoBomEncoding)


#Not Working
[System.IO.File]::AppendAllLines($FileUtf8, $Output)
[System.IO.File]::AppendAllLines($FileUtf8NoBom, $Output,$Utf8NoBomEncoding)


#Force type Work
[System.IO.File]::AppendAllLines([string]$FileUtf8, [string[]]$Output)
[System.IO.File]::AppendAllLines([string]$FileUtf8NoBom, [string[]]$Output, $Utf8NoBomEncoding)

