Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

function New-BrandBitmap {
    param(
        [int]$Size
    )

    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gfx.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $gfx.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    try {
        $rect = New-Object System.Drawing.Rectangle 0, 0, $Size, $Size
        $blue1 = [System.Drawing.ColorTranslator]::FromHtml('#2563EB')
        $blue2 = [System.Drawing.ColorTranslator]::FromHtml('#1D4ED8')

        $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $blue1, $blue2, 45
        $gfx.FillRectangle($brush, $rect)

        $softGlow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(45, 255, 255, 255))
        $gfx.FillEllipse($softGlow, [int]($Size * 0.12), [int]($Size * 0.1), [int]($Size * 0.38), [int]($Size * 0.38))

        $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(55, 255, 255, 255))
        $gfx.FillEllipse($accent, [int]($Size * 0.62), [int]($Size * 0.1), [int]($Size * 0.26), [int]($Size * 0.26))

        $fontSize = [Math]::Max(14, [int]($Size * 0.42))
        $font = New-Object System.Drawing.Font 'Segoe UI Semibold', $fontSize, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
        $format = New-Object System.Drawing.StringFormat
        $format.Alignment = [System.Drawing.StringAlignment]::Center
        $format.LineAlignment = [System.Drawing.StringAlignment]::Center

        $textRect = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
        $textBrush = [System.Drawing.Brushes]::White
        $gfx.DrawString('DL', $font, $textBrush, $textRect, $format)

    }
    finally {
        $gfx.Dispose()
    }

    return $bmp
}

function New-RoundedRectPath {
    param(
        [System.Drawing.RectangleF]$Rect,
        [float]$Radius
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $Radius * 2

    $path.AddArc($Rect.X, $Rect.Y, $diameter, $diameter, 180, 90)
    $path.AddArc($Rect.Right - $diameter, $Rect.Y, $diameter, $diameter, 270, 90)
    $path.AddArc($Rect.Right - $diameter, $Rect.Bottom - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($Rect.X, $Rect.Bottom - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()

    return $path
}

function New-SplashBitmap {
    param(
        [int]$Width,
        [int]$Height
    )

    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gfx.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $gfx.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $gfx.Clear([System.Drawing.Color]::Transparent)

    try {
        $size = [Math]::Min($Width, $Height)
        $cardSize = [float]($size * 0.42)
        $cardX = [float](($Width - $cardSize) / 2)
        $cardY = [float](($Height - $cardSize) / 2)
        $cardRect = [System.Drawing.RectangleF]::new($cardX, $cardY, $cardSize, $cardSize)
        $cardPath = New-RoundedRectPath -Rect $cardRect -Radius ([float]($cardSize * 0.24))

        $cardBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $gfx.FillPath($cardBrush, $cardPath)

        $letterColor = [System.Drawing.ColorTranslator]::FromHtml('#2563EB')
        $fontSize = [Math]::Max(16, [int]($size * 0.16))
        $font = New-Object System.Drawing.Font 'Segoe UI Semibold', $fontSize, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
        $format = New-Object System.Drawing.StringFormat
        $format.Alignment = [System.Drawing.StringAlignment]::Center
        $format.LineAlignment = [System.Drawing.StringAlignment]::Center

        $textRect = [System.Drawing.RectangleF]::new($cardX, $cardY - ([float]($cardSize * 0.02)), $cardSize, $cardSize)
        $textBrush = New-Object System.Drawing.SolidBrush $letterColor
        $gfx.DrawString('DL', $font, $textBrush, $textRect, $format)

        $cardPath.Dispose()
    }
    finally {
        $gfx.Dispose()
    }

    return $bmp
}

function Save-Png {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [string]$Path
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
}

function Save-Icon {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [string]$Path
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $handle = $Bitmap.GetHicon()
    try {
        $icon = [System.Drawing.Icon]::FromHandle($handle)
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Create)
        try {
            $icon.Save($stream)
        }
        finally {
            $stream.Dispose()
        }
    }
    finally {
        # DestroyIcon is not required for a short-lived script on Windows PowerShell.
    }
}

$root = Split-Path -Parent $PSScriptRoot

$sizes = @(
    @{ Path = 'android/app/src/main/res/drawable/launch_splash.png'; Width = 512; Height = 512; Kind = 'splash' },
    @{ Path = 'android/app/src/main/res/mipmap-mdpi/ic_launcher.png'; Size = 48 },
    @{ Path = 'android/app/src/main/res/mipmap-hdpi/ic_launcher.png'; Size = 72 },
    @{ Path = 'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png'; Size = 96 },
    @{ Path = 'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png'; Size = 144 },
    @{ Path = 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'; Size = 192 },
    @{ Path = 'web/icons/Icon-192.png'; Size = 192 },
    @{ Path = 'web/icons/Icon-512.png'; Size = 512 },
    @{ Path = 'web/icons/Icon-maskable-192.png'; Size = 192 },
    @{ Path = 'web/icons/Icon-maskable-512.png'; Size = 512 },
    @{ Path = 'web/favicon.png'; Size = 48 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png'; Size = 16 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png'; Size = 32 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png'; Size = 64 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png'; Size = 128 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png'; Size = 256 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png'; Size = 512 },
    @{ Path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png'; Size = 1024 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png'; Size = 20 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png'; Size = 40 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png'; Size = 60 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png'; Size = 29 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png'; Size = 58 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png'; Size = 87 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png'; Size = 40 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png'; Size = 80 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png'; Size = 120 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png'; Size = 120 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png'; Size = 180 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png'; Size = 76 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png'; Size = 152 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png'; Size = 167 },
    @{ Path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png'; Size = 1024 },
    @{ Path = 'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png'; Width = 168; Height = 185; Kind = 'splash' },
    @{ Path = 'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png'; Width = 336; Height = 370; Kind = 'splash' },
    @{ Path = 'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png'; Width = 504; Height = 555; Kind = 'splash' },
    @{ Path = 'windows/runner/resources/app_icon.ico'; Size = 256 }
)

foreach ($item in $sizes) {
    $bitmap = if ($item.Kind -eq 'splash') {
        New-SplashBitmap -Width ([int]$item.Width) -Height ([int]$item.Height)
    } else {
        New-BrandBitmap -Size $item.Size
    }
    try {
        $path = Join-Path $root $item.Path
        if ($item.Path.EndsWith('.ico')) {
            Save-Icon -Bitmap $bitmap -Path $path
        }
        else {
            Save-Png -Bitmap $bitmap -Path $path
        }
    }
    finally {
        $bitmap.Dispose()
    }
}

Write-Host 'Brand assets generated.'
