# Install vcredist
Start-Process .\vcredist_x86.exe -ArgumentList "/quiet", "/norestart" -Wait

# Set gamemodes location
Set-Location gamemodes

# Build gamemode
../pawno/pawncc.exe ior.pwn -Dgamemodes '-;+' '-(+' -d3