param(
    [Parameter(ValueFromPipeline=$true)]
    [string[]]$Files
)

process {
    foreach ($filepath in $Files) {
        $filepath = $filepath.Trim()
        
        if (Test-Path $filepath -PathType Leaf) {
            Write-Output "// $filepath"
            Get-Content $filepath
            Write-Output ""
        } else {
            Write-Output "// $filepath (arquivo não encontrado)"
            Write-Output ""
        }
    }
}
