param (
    [int]$MaxDepth = 1
)

function Get-DirectoryTree {
    param (
        [string]$Path,
        [int]$Depth,
        [int]$CurrentDepth = 0
    )

    if ($CurrentDepth -ge $Depth) {
        return
    }

    $items = Get-ChildItem -Path $Path

    foreach ($item in $items) {
        $indent = " " * ($CurrentDepth * 2)
        if ($item.PSIsContainer) {
            Write-Output "$indent|-- $($item.Name)/"
            Get-DirectoryTree -Path $item.FullName -Depth $Depth -CurrentDepth ($CurrentDepth + 1)
        } else {
            Write-Output "$indent|-- $($item.Name)"
        }
    }
}

# Get the current directory
$CurrentDirectory = Get-Location

# Start mapping from the current directory
Get-DirectoryTree -Path $CurrentDirectory.Path -Depth $MaxDepth
