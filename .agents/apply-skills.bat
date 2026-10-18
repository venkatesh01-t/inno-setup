@echo off
set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=%CD%"
echo Linking all 226+ Antigravity skills and REA Suite to %TARGET%\.agents ...
if exist "%TARGET%\.agents" rmdir "%TARGET%\.agents" >nul 2>&1
mklink /J "%TARGET%\.agents" "C:\Users\KING\.gemini\config"
if exist "%TARGET%\.agents" (
    echo [SUCCESS] All 226+ Antigravity skills and REA Suite are linked to %TARGET%\.agents!
) else (
    echo [ERROR] Failed to link. Try running as Administrator.
)
