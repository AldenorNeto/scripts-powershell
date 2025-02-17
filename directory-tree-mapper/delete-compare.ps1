# Caminhos dos diretórios
$primeiroDestino = "C:\php"
$segundoDestino = "C:\"

# Obter lista de nomes de arquivos do primeiro destino
$arquivosPrimeiroDestino = Get-ChildItem -Path $primeiroDestino -File | Select-Object -ExpandProperty Name

# Verificar e deletar arquivos no segundo destino que estão no primeiro destino
foreach ($arquivo in $arquivosPrimeiroDestino) {
    $caminhoArquivoSegundoDestino = Join-Path -Path $segundoDestino -ChildPath $arquivo
    if (Test-Path $caminhoArquivoSegundoDestino) {
        Write-Host "Deletando arquivo: $caminhoArquivoSegundoDestino" -ForegroundColor Yellow
        Remove-Item -Path $caminhoArquivoSegundoDestino -Force
    }
}
