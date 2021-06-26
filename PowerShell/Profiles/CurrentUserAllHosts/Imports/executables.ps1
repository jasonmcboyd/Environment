# Create 'npp' function to open files with Notepad++.
function npp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $Path
    )

    & 'C:\Program Files\Notepad++\notepad++.exe' $Path
}

function ssms {
    & 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe'
}
