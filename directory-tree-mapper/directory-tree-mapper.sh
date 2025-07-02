#!/bin/bash

set -euo pipefail
shopt -s dotglob nullglob

max_depth=4
if [[ $# -gt 0 ]]; then
    if [[ $1 =~ ^[0-9]+$ ]]; then
        max_depth=$1
    else
        echo "Error: MaxDepth deve ser um número inteiro." >&2
        exit 1
    fi
fi

declare -A ignore=()
ignore_folders=(
    'logs' 'pids' 'lib-cov' 'coverage' '.nyc_output' '.grunt'
    'bower_components' 'build' 'node_modules' '.npm' '.yarn-integrity'
    '.yarn' '.yarn/cache' '.yarn/unplugged' 'jspm_packages' 'web_modules'
    '.rpt2_cache' '.rts2_cache_cjs' '.rts2_cache_es' '.rts2_cache_umd'
    '.cache' '.parcel-cache' '.next' 'out' '.nuxt' 'dist' '.vuepress'
    '.temp' '.docusaurus' '.serverless' '.fusebox' '.dynamodb' '.tern-port'
    '.vscode-test'
    '.venv' 'venv' 'env' '.env' 'ENV' 'env.bak' 'venv.bak' '.pyenv'
    '__pycache__' '.mypy_cache' '.pytest_cache' '.hypothesis' '.ipynb_checkpoints'
    '.python-version' '.coverage' '.tox' '.eggs' 'dist' 'build' '*.egg-info'
    '.pytype' '.ruff_cache'
    'vendor' '.phpunit.result.cache' '.phpunit.cache' 'composer.lock'
    'storage/framework/cache' 'storage/framework/sessions' 'storage/framework/views'
    'bootstrap/cache' '.php-cs-fixer.cache'
    'bin' 'obj' '.vs' '.vscode' 'packages' 'TestResults' 'artifacts'
    'Publish' '.dotnet' '.sonarqube' '.local' '.msbuild' '.nuget'
    '.idea' '.resharper' '*.user' '*.suo' '*.cache' '*.nupkg'
    '.git' '.gitignore' '.gitmodules' '.gitattributes' '.gitkeep'
    '.gitlab-ci.yml' '.github' '.gitreview' '.gitconfig'
)

for folder in "${ignore_folders[@]}"; do
    ignore["$folder"]=1
done

file_paths=()

traverse() {
    local path="$1"
    local current_depth="$2"
    local max_depth="$3"

    if (( current_depth >= max_depth )); then
        return
    fi

    for item in "$path"/*; do
        local name=$(basename "$item")
        if [[ -d "$item" && -n "${ignore["$name"]:-}" ]]; then
            continue
        fi

        local indent=$(( current_depth * 2 ))
        if [[ -d "$item" ]]; then
            printf "%${indent}s|-- %s/\n" "" "$name"
            traverse "$item" $((current_depth + 1)) "$max_depth"
        else
            printf "%${indent}s|-- %s\n" "" "$name"
            # Salva caminho relativo sem "./" inicial
            rel_path="${item#./}"
            file_paths+=("$rel_path")
        fi
    done
}

traverse "." 0 "$max_depth"

echo
echo "Arquivos encontrados:"
for path in "${file_paths[@]}"; do
    echo "$path"
done
