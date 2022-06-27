@echo Off
title ssh-copy-id For Windows

set TARGET=%1

if "%TARGET%" == "" (
    echo ERROR: Usage: "ssh-copy-id.bat <user>@<server>"
    exit /b 1
)

where ssh >nul 2>nul

if %ErrorLevel% == 0 (
    echo NOTE: SSH Found, sending key to server
) else (
    echo ERROR: SSH NOT Found, please install or put in the System PATH
    exit /b 1
)

type %SystemDrive%%HomePath%\.ssh\id_rsa.pub | ssh %TARGET% "cat >> .ssh/authorized_keys"
if %ErrorLevel% == 0 (
    echo NOTE: Key sent, you can now log in to %TARGET%
    exit /b 0
)

if %ErrorLevel% == 2 (
    echo NOTE: ~/.ssh directory not found, creating it
)
ssh %TARGET% mkdir -p .ssh
echo retrying...
type %SystemDrive%%HomePath%\.ssh\id_rsa.pub | ssh %TARGET% "cat >> .ssh/authorized_keys"
if %ErrorLevel% == 0 (
    echo NOTE: Key sent, you can now log in to %TARGET%
    exit /b 0
)

echo ERROR: Key not sent, please locate the issues on your machine and try again