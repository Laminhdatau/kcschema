$csharpCode = @"
using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

public class ValidIcoGenerator {
    public static void GenerateValidIco(string pngPath, string icoPath) {
        using (Bitmap srcBmp = new Bitmap(pngPath)) {
            using (Bitmap iconBmp = new Bitmap(srcBmp, new Size(256, 256))) {
                using (FileStream fs = new FileStream(icoPath, FileMode.Create)) {
                    using (BinaryWriter bw = new BinaryWriter(fs)) {
                        // 1. ICONDIR (6 bytes)
                        bw.Write((ushort)0); // Reserved
                        bw.Write((ushort)1); // Type ICO
                        bw.Write((ushort)1); // 1 Image

                        // 2. ICONDIRENTRY (16 bytes)
                        bw.Write((byte)0); // Width 256 = 0
                        bw.Write((byte)0); // Height 256 = 0
                        bw.Write((byte)0); // Colors
                        bw.Write((byte)0); // Reserved
                        bw.Write((ushort)1); // Planes
                        bw.Write((ushort)32); // BPP
                        
                        int width = 256;
                        int height = 256;
                        int headerSize = 40;
                        int imageBytesSize = width * height * 4;
                        int maskBytesSize = (width * height) / 8;
                        int totalDataSize = headerSize + imageBytesSize + maskBytesSize;

                        bw.Write((uint)totalDataSize);
                        bw.Write((uint)22);

                        // 3. BITMAPINFOHEADER (40 bytes)
                        bw.Write((uint)headerSize);
                        bw.Write((int)width);
                        bw.Write((int)(height * 2)); // Double height for XOR + AND masks
                        bw.Write((ushort)1); // Planes
                        bw.Write((ushort)32); // BPP
                        bw.Write((uint)0); // BI_RGB
                        bw.Write((uint)(imageBytesSize + maskBytesSize));
                        bw.Write((int)0);
                        bw.Write((int)0);
                        bw.Write((uint)0);
                        bw.Write((uint)0);

                        // 4. XOR Image Bytes (BGRA 32-bit, Bottom-Up)
                        for (int y = height - 1; y >= 0; y--) {
                            for (int x = 0; x < width; x++) {
                                Color c = iconBmp.GetPixel(x, y);
                                bw.Write(c.B);
                                bw.Write(c.G);
                                bw.Write(c.R);
                                bw.Write(c.A);
                            }
                        }

                        // 5. AND Mask (0x00 for 32-bit alpha transparency)
                        byte[] mask = new byte[maskBytesSize];
                        bw.Write(mask);
                    }
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

[ValidIcoGenerator]::GenerateValidIco($pngPath, $icoPath)
Copy-Item $icoPath $resIcoPath -Force

Write-Host "Standard DIB ICO file created successfully!"
