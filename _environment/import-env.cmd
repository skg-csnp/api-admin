@echo off
setlocal EnableDelayedExpansion EnableExtensions

rem Read from credential.env and set environment variables (User scope - persistent)
set "ENV_FILE=credential.env"

if not exist "%ENV_FILE%" (
    echo File %ENV_FILE% not found.
    exit /b 1
)

for /f "usebackq delims=" %%A in ("%ENV_FILE%") do (
    set "line=%%A"

    rem Trim leading whitespace
    for /f "tokens=* delims= " %%B in ("!line!") do set "line=%%B"

    rem Skip comment and blank lines
    if not "!line!"=="" if not "!line:~0,1!"=="#" (
        for /f "tokens=1* delims==" %%K in ("!line!") do (
            set "key=%%K"
            set "value=%%L"

            rem Trim quotes around value if present
            set "value=!value:"=!"

            rem Persist to User environment
            setx !key! "!value!" >nul
            echo Set !key!=!value!
        )
    )
)

exit /b 0
