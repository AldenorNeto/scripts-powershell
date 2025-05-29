$folder = Get-Location

Get-ChildItem -Path $folder -File | ForEach-Object {
    $base  = $_.BaseName
    $ext   = $_.Extension
    $parts = $base -split '-'
    if ($parts.Count -gt 1) {
        $novoBase = $parts[0..($parts.Count - 2)] -join '-'
        $novoNome = "$novoBase$ext"
        Rename-Item -LiteralPath $_.FullName -NewName $novoNome
    }
}
