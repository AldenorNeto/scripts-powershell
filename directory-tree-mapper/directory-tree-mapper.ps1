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
    # Pastas comuns de Node.js
    'logs', 'pids', 'lib-cov', 'coverage', '.nyc_output', '.grunt',
    'bower_components', 'build', 'node_modules', '.npm', '.yarn-integrity',
    '.yarn', '.yarn/cache', '.yarn/unplugged', 'jspm_packages', 'web_modules',
    '.rpt2_cache', '.rts2_cache_cjs', '.rts2_cache_es', '.rts2_cache_umd',
    '.cache', '.parcel-cache', '.next', 'out', '.nuxt', 'dist', '.vuepress',
    '.temp', '.docusaurus', '.serverless', '.fusebox', '.dynamodb', '.tern-port',
    '.vscode-test',

    # Pastas comuns de Python
    '.venv', 'venv', 'env', '.env', 'ENV', 'env.bak', 'venv.bak', '.pyenv',
    '__pycache__', '.mypy_cache', '.pytest_cache', '.hypothesis', '.ipynb_checkpoints',
    '.python-version', '.coverage', '.tox', '.eggs', 'dist', 'build', '*.egg-info',
    '.pytype', '.ruff_cache',

    # Pastas comuns de PHP
    'vendor', '.phpunit.result.cache', '.phpunit.cache', 'composer.lock',
    'storage/framework/cache', 'storage/framework/sessions', 'storage/framework/views',
    'bootstrap/cache', '.php-cs-fixer.cache',

    # Pastas comuns de C#
    'bin', 'obj', '.vs', '.vscode', 'packages', 'TestResults', 'artifacts',
    'Publish', '.dotnet', '.sonarqube', '.local', '.msbuild', '.nuget',
    '.idea', '.resharper', '*.user', '*.suo', '*.cache', '*.nupkg'
)

# Start mapping from the current directory
Get-DirectoryTree -Path $CurrentDirectory.Path -Depth $MaxDepth -IgnoreFolders $IgnoreFolders
