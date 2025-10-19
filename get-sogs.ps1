# extraer-archivos-para-js.ps1
# Ejecuta desde la carpeta donde está la carpeta "files"
# Uso: .\extraer-archivos-para-js.ps1 > assets.txt

$folder = ".\files"
$extensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp")

# Obtener todos los archivos con esas extensiones
$files = foreach ($ext in $extensions) {
    Get-ChildItem -Path $folder -Filter $ext -File -Recurse
}

# Ordenar para que salga ordenado (opcional)
$files = $files | Sort-Object Name

# Formatear para JS array
foreach ($file in $files) {
    # Convertir ruta a ruta relativa con barra normal "/"
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart('\').Replace('\', '/')
    # Poner "./" delante para que sea relativa al HTML
    $jsPath = "./" + $relativePath
    Write-Output "    `"$jsPath`","
}
