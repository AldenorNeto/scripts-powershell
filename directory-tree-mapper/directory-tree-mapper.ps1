param (
    [int]$MaxDepth = 4
)

function Get-DirectoryTree {
    param (
        [string]$Path,
        [int]$Depth,
        [int]$CurrentDepth = 0,
        [array]$IgnoreFolders
    )

    if ($CurrentDepth -ge $Depth) {
        return
    }

    $items = Get-ChildItem -Path $Path

    foreach ($item in $items) {
        if ($item.PSIsContainer -and $IgnoreFolders -contains $item.Name) {
            continue
        }

        $indent = " " * ($CurrentDepth * 2)
        if ($item.PSIsContainer) {
            Write-Output "$indent|-- $($item.Name)/"
            Get-DirectoryTree -Path $item.FullName -Depth $Depth -CurrentDepth ($CurrentDepth + 1) -IgnoreFolders $IgnoreFolders
        } else {
            Write-Output "$indent|-- $($item.Name)"
        }
    }
}

# Get the current directory
$CurrentDirectory = Get-Location

# Ignore folders similar to .gitignore
$IgnoreFolders = @(
    'logs', 'pids', 'lib-cov', 'coverage', '.nyc_output', '.grunt',
    'bower_components', 'build', 'node_modules', 'jspm_packages', 'web_modules',
    '.npm', '.rpt2_cache', '.rts2_cache_cjs', '.rts2_cache_es', '.rts2_cache_umd',
    '.yarn-integrity', '.cache', '.parcel-cache', '.next', 'out', '.nuxt', 'dist',
    '.vuepress', '.temp', '.docusaurus', '.serverless', '.fusebox', '.dynamodb',
    '.tern-port', '.vscode-test', '.yarn', '.yarn/cache', '.yarn/unplugged'
)

# Start mapping from the current directory
Get-DirectoryTree -Path $CurrentDirectory.Path -Depth $MaxDepth -IgnoreFolders $IgnoreFolders
