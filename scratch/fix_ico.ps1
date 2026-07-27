$csharpCode = @"
using System;
using System.IO;
using System.Drawing;

public class IcoEncoder {
    public static void ConvertPngToIco(string pngPath, string icoPath) {
        byte[] pngBytes = File.ReadAllBytes(pngPath);
        using (Bitmap bmp = new Bitmap(pngPath)) {
            using (FileStream fs = new FileStream(icoPath, FileMode.Create)) {
                using (BinaryWriter bw = new BinaryWriter(fs)) {
                    // ICONDIR header
                    bw.Write((ushort)0); // Reserved
                    bw.Write((ushort)1); // Type 1 = ICO
                    bw.Write((ushort)1); // Image count

                    // ICONDIRENTRY header
                    byte width = (byte)(bmp.Width >= 256 ? 0 : bmp.Width);
                    byte height = (byte)(bmp.Height >= 256 ? 0 : bmp.Height);
                    bw.Write(width);
                    bw.Write(height);
                    bw.Write((byte)0); // Colors
                    bw.Write((byte)0); // Reserved
                    bw.Write((ushort)1); // Planes
                    bw.Write((ushort)32); // BPP
                    bw.Write((uint)pngBytes.Length); // Bytes size
                    bw.Write((uint)22); // Offset (6 + 16)

                    // Write PNG image bytes directly
                    bw.Write(pngBytes);
                }
            }
        }
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing.dll"

$pngPath = "d:\PROJECT\kcschema\assets\icon\app_logo.png"
$icoPath = "d:\PROJECT\kcschema\assets\icon\app_icon.ico"
$resIcoPath = "d:\PROJECT\kcschema\windows\runner\resources\app_icon.ico"

[IcoEncoder]::ConvertPngToIco($pngPath, $icoPath)
Copy-Item $icoPath $resIcoPath -Force

Write-Host "Valid PNG-in-ICO file created successfully!"
