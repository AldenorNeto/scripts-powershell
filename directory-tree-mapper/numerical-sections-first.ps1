$folder = Get-Location

Get-ChildItem -Path $folder -File | ForEach-Object {
    $base = $_.BaseName
    $ext = $_.Extension
    $parts = $base -split '-'

    $numericas = @()
    $texto = @()

    foreach ($part in $parts) {
        if ($part -match '^\d+$') {
            $numericas += $part
        } else {
            $texto += $part
        }
    }

    $novoBase = ($numericas + $texto) -join '-'
    $novoNome = "$novoBase$ext"

    Rename-Item -LiteralPath $_.FullName -NewName $novoNome
}
