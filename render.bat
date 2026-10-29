@echo off
rem Standard site render: records -> data/ -> docs/, validated before and after.
rem Double-click it or run "render.bat" from the repository root.
setlocal
cd /d "%~dp0"
chcp 65001 >nul
set LANG=en_US.UTF-8
set LC_ALL=en_US.UTF-8

echo [1/4] Validating records...
Rscript scripts/04-validate.R || goto :fail
echo [2/4] Building site data...
Rscript scripts/05-build-site-data.R || goto :fail
echo [3/4] Rendering site...
call quarto render || goto :fail
echo [4/4] Validating site...
Rscript scripts/04-validate.R || goto :fail

echo.
echo Done: docs\index.html is up to date.
endlocal
exit /b 0

:fail
echo.
echo Render FAILED: see the messages above.
endlocal
exit /b 1
