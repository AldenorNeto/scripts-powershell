$ErrorActionPreference = "Stop"

# Lê cada linha da entrada padrão
while ($line = [Console]::In.ReadLine()) {
    # Ignora linhas vazias
    if ([string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    $filepath = $line.Trim()

    if (Test-Path $filepath -PathType Leaf) {
        Write-Output "// $filepath"
        Get-Content $filepath
        Write-Output ""
    } else {
        Write-Output "// $filepath (arquivo não encontrado)"
        Write-Output ""
    }
}
