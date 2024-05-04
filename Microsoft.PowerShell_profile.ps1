# aliases for long paths I use a lot
Set-Alias -Name sqp -Value 'C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe'
Set-Alias -Name instutil -Value 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe'
Set-Alias -Name nuget -Value "C:\Users\$ENV:UserName\AppData\Local\NuGet\nuget.exe"
Set-Alias -Name logp -Value 'C:\Program Files (x86)\Log Parser 2.2\LogParser.exe'

$ENV:DOTNET_ENVIRONMENT = 'Development'

function Prompt {
    $time = (Get-Date).ToString("HH:mm")

    $curdir = $ExecutionContext.SessionState.Path.CurrentLocation.Path.Split("\")[-1]

    if($curdir.Length -eq 0) {
        $curdir = $ExecutionContext.SessionState.Drive.Current.Name+":\"
    }

    Write-Host "$curdir" -BackgroundColor Blue -ForegroundColor White -NoNewline

    # I default to dev mode, but I could switch by removing the DOTNET_ENVIRONMENT variable
    # so flag the mode here
    if($ENV:DOTNET_ENVIRONMENT -eq 'Development') {
        Write-Host "DEV" -BackgroundColor Green -ForegroundColor Black -NoNewline
    } else {
        Write-Host "!DEV" -BackgroundColor Red -ForegroundColor White -NoNewline
    }

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) {
        Write-Host "|ADMIN" -BackgroundColor Red -ForegroundColor Black -NoNewline
    }

    Write-Host ""$time" " -BackgroundColor Yellow -ForegroundColor Black -NoNewline
}

function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }

    $input | select-string $regex
}

function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.directory)\$($_)"
    }
}

function pgrep($name) {
    Get-Process $name
}