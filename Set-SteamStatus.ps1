# Scheduled task runs this on logon and at 5pm
# If a weekday between 12AM - 5PM then set Steam status to Invisible
# Else set Steam status to Online

# https://developer.valvesoftware.com/wiki/Steam_browser_protocol

function Set-SteamStatus {
    Param(
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [ValidateSet("Online","Away","Busy","Invisible", "Offline")]
        [String[]]$Status
    )

    Start-Process "steam://friends/status/$status"
}


function Update-SteamStatus {
    $day = (Get-Date).DayOfWeek

    switch($day) {
        {$_ -match 'Monday|Tuesday|Wednesday|Thursday|Friday'} { Set-WeekdayStatus }
        {$_ -match 'Saturday|Sunday'} { Set-SteamStatus Online }
    }
}

function Set-WeekdayStatus {
    $min = Get-Date '00:00'
    $max = Get-Date '17:00'

    $now = Get-Date
    if ($min.TimeOfDay -le $now.TimeOfDay -and $max.TimeOfDay -ge $now.TimeOfDay) {
        Set-SteamStatus Invisible
    } else {
        Set-SteamStatus Online
    }
}

Update-SteamStatus