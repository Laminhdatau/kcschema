Add-Type -AssemblyName System.Drawing
$pngPath = "d:\PROJECT\kcschema\assets\icon\app_logo.png"
$icoPath = "d:\PROJECT\kcschema\assets\icon\app_icon.ico"
$resIcoPath = "d:\PROJECT\kcschema\windows\runner\resources\app_icon.ico"

$bmp = [System.Drawing.Bitmap]::FromFile($pngPath)
$hIcon = $bmp.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($hIcon)

$stream = New-Object System.IO.FileStream($icoPath, [System.IO.FileMode]::Create)
$icon.Save($stream)
$stream.Close()

Copy-Item $icoPath $resIcoPath -Force
Write-Host "ICO file created successfully!"
