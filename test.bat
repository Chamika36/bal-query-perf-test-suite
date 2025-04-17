@echo off
setlocal enabledelayedexpansion

rem Define paths (no quotes)
set CUSTOM_BAL=D:\fork\ballerina-lang\distribution\zip\jballerina-tools\build\extracted-distributions\jballerina-tools-2201.13.0-SNAPSHOT\bin\bal.bat
set DEFAULT_BAL=bal

rem Define the Ballerina files
set FILES=simple.bal complex.bal nested.bal

rem Define output files
set OUTPUT=results.txt
set SUMMARY=summary.md

rem Clear previous results
> %OUTPUT% (
    echo Running tests...
)
> %SUMMARY% (
    echo ^| File ^| Java Streams Avg Time ^| Ballerina Pipeline Avg Time ^| Improved by ^|
    echo ^|------^|-----------------------^|------------------------^|------------------------^|
)

rem Loop through files
for %%F in (%FILES%) do (
    rem -----------------------
    rem Run with CUSTOM BAL
    rem -----------------------
    echo Running with CUSTOM BAL on %%F >> %OUTPUT%
    for /f "tokens=4" %%A in ('%CUSTOM_BAL% run %%F 2^>^&1 ^| findstr "Average execution time"') do (
        set "customAvg=%%A"
    )
    echo. >> %OUTPUT%

    rem -----------------------
    rem Run with DEFAULT BAL
    rem -----------------------
    echo Running with DEFAULT BAL on %%F >> %OUTPUT%
    for /f "tokens=4" %%B in ('%DEFAULT_BAL% run %%F 2^>^&1 ^| findstr "Average execution time"') do (
        set "defaultAvg=%%B"
    )
    echo. >> %OUTPUT%

    rem -----------------------
    rem Save to summary table
    rem -----------------------
    for /f %%I in ('powershell -Command "[math]::Round(!defaultAvg! / !customAvg!, 2)"') do (
        set "improvement=%%I"
    )
    echo ^| %%F ^| !customAvg! seconds ^| !defaultAvg! seconds ^| !improvement!x ^|>> %SUMMARY%
)

echo.
echo Done! See results.txt and summary.txt
