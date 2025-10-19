# extraer-archivos-para-js.ps1
# Ejecuta desde la carpeta donde está la carpeta "files"
# Uso: .\extraer-archivos-para-js.ps1 > cats-index.txt

$folder = ".\files"
$extensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp")

# Obtener todos los archivos con esas extensiones
$files = foreach ($ext in $extensions) {
    Get-ChildItem -Path $folder -Filter $ext -File -Recurse
}

# Ordenar para que salga ordenado (opcional)
$files = $files | Sort-Object Name

# Formatear para cats-index.txt (solo nombres de archivo)
foreach ($file in $files) {
    # Solo el nombre del archivo, sin rutas
    $fileName = $file.Name
    Write-Output $fileName
}