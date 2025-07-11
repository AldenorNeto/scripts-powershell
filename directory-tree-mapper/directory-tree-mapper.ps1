param(
    [int]$MaxDepth = 4
)

function Get-DirectoryTree {
    param(
        [string]$Path,
        [int]$Depth,
        [int]$CurrentDepth = 0,
        [string[]]$IgnoreFolders,
        [ref]$FileList
    )

    if ($CurrentDepth -ge $Depth) { return }

    Get-ChildItem -LiteralPath $Path | ForEach-Object {
        if ($_.PSIsContainer -and $IgnoreFolders -contains $_.Name) { return }

        $indent = ' ' * ($CurrentDepth * 2)
        if ($_.PSIsContainer) {
            Write-Output "$indent|-- $($_.Name)/"
            Get-DirectoryTree `
                -Path $_.FullName `
                -Depth $Depth `
                -CurrentDepth ($CurrentDepth + 1) `
                -IgnoreFolders $IgnoreFolders `
                -FileList $FileList
        }
        else {
            Write-Output "$indent|-- $($_.Name)"
            $relative = $_.FullName.Substring((Get-Location).Path.Length+1)
            $FileList.Value += $relative
        }
    }
}

$IgnoreFolders = @(
    'logs','pids','lib-cov','coverage','.nyc_output','.grunt',
    'bower_components','build','node_modules','.npm','.yarn-integrity',
    '.yarn','.yarn/cache','.yarn/unplugged','jspm_packages','web_modules',
    '.rpt2_cache','.rts2_cache_cjs','.rts2_cache_es','.rts2_cache_umd',
    '.cache','.parcel-cache','.next','out','.nuxt','dist','.vuepress',
    '.temp','.docusaurus','.serverless','.fusebox','.dynamodb','.tern-port',
    '.vscode-test',
    '.venv','venv','env','.env','ENV','env.bak','venv.bak','.pyenv',
    '__pycache__','.mypy_cache','.pytest_cache','.hypothesis','.ipynb_checkpoints',
    '.python-version','.coverage','.tox','.eggs','dist','build','*.egg-info',
    '.pytype','.ruff_cache',
    'vendor','.phpunit.result.cache','.phpunit.cache','composer.lock',
    'storage/framework/cache','storage/framework/sessions','storage/framework/views',
    'bootstrap/cache','.php-cs-fixer.cache',
    'bin','obj','.vs','.vscode','packages','TestResults','artifacts',
    'Publish','.dotnet','.sonarqube','.local','.msbuild','.nuget',
    '.idea','.resharper','*.user','*.suo','*.cache','*.nupkg',
    '.git','.gitignore','.gitmodules','.gitattributes','.gitkeep',
    '.gitlab-ci.yml','.github','.gitreview','.gitconfig'
)

# lista para armazenar caminhos relativos dos arquivos
$filePaths = [System.Collections.Generic.List[string]]::new()

Get-DirectoryTree `
    -Path (Get-Location).Path `
    -Depth $MaxDepth `
    -IgnoreFolders $IgnoreFolders `
    -FileList ([ref]$filePaths)

"" | Write-Output
"Arquivos encontrados:" | Write-Output
$filePaths | ForEach-Object { Write-Output $_ }
