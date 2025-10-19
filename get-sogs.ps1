# extraer-archivos-para-js.ps1
# Ejecuta desde la carpeta donde está la carpeta "files"
# Uso: .\extraer-archivos-para-js.ps1

$folder = ".\files"
$extensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp")
$outputFile = "cats-index.txt"

# Verificar que la carpeta existe
if (-not (Test-Path $folder)) {
    Write-Error "La carpeta '$folder' no existe"
    exit 1
}

# Obtener todos los archivos con esas extensiones
$files = foreach ($ext in $extensions) {
    Get-ChildItem -Path $folder -Filter $ext -File -Recurse
}

# Ordenar para que salga ordenado
$files = $files | Sort-Object Name

Write-Host "Encontrados $($files.Count) archivos en $folder"

# Crear array para almacenar nombres
$fileNames = @()

# Recopilar nombres de archivo
foreach ($file in $files) {
    $fileName = $file.Name
    Write-Host "Procesando: $fileName"
    $fileNames += $fileName
}

# Escribir al archivo con codificación UTF-8 sin BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($outputFile, $fileNames, $utf8NoBom)

Write-Host "Archivo '$outputFile' generado correctamente con $($fileNames.Count) archivos"
Write-Host "Primeros 5 archivos:"
$fileNames[0..4] | ForEach-Object { Write-Host "  $_" }

# Verificar el archivo generado
Write-Host "`nVerificando codificación del archivo..."
$content = Get-Content $outputFile -Raw
$hasNullChars = $content -match '\x00'
$lineCount = ($content -split "`n").Count

Write-Host "Líneas en archivo: $lineCount"
Write-Host "¿Contiene caracteres nulos?: $hasNullChars"

if ($hasNullChars) {
    Write-Warning "El archivo contiene caracteres nulos. Regenerando..."
    # Limpiar y regenerar
    $cleanContent = $content -replace '\x00', ''
    [System.IO.File]::WriteAllText($outputFile, $cleanContent, $utf8NoBom)
    Write-Host "Archivo limpiado y regenerado"
}