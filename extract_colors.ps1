Add-Type -AssemblyName System.Drawing

function Get-DominantColors {
    param (
        [string]$imagePath,
        [int]$count = 5
    )

    if (-not (Test-Path $imagePath)) {
        Write-Host "Image not found: $imagePath"
        return
    }

    $bitmap = [System.Drawing.Bitmap]::FromFile($imagePath)
    $thumb = $bitmap.GetThumbnailImage(50, 50, $null, [IntPtr]::Zero)
    $bitmap.Dispose()

    $colors = @{}

    for ($x = 0; $x -lt $thumb.Width; $x++) {
        for ($y = 0; $y -lt $thumb.Height; $y++) {
            $pixel = $thumb.GetPixel($x, $y)
            # Ignore transparent pixels
            if ($pixel.A -lt 255) { continue }
            
            # Quantize colors slightly to group similar ones (round to nearest 10)
            $r = [Math]::Round($pixel.R / 10) * 10
            $g = [Math]::Round($pixel.G / 10) * 10
            $b = [Math]::Round($pixel.B / 10) * 10
            
            $hex = "#{0:X2}{1:X2}{2:X2}" -f $r, $g, $b
            
            if ($colors.ContainsKey($hex)) {
                $colors[$hex]++
            } else {
                $colors[$hex] = 1
            }
        }
    }

    $thumb.Dispose()

    Write-Host "Dominant colors for $(Split-Path $imagePath -Leaf):"
    $colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First $count | ForEach-Object {
        Write-Host "  $($_.Name) - Count: $($_.Value)"
    }
    Write-Host ""
}

$images = @("assets\images\1.png", "assets\images\2.png", "assets\images\3.png")

foreach ($img in $images) {
    Get-DominantColors -imagePath $img
}
