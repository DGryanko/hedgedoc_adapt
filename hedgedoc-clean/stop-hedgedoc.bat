@echo off
echo ========================================
echo Stopping HedgeDoc
echo ========================================
echo.

wsl -d Debian bash -c "cd /mnt/f/GitHub/hedgedoc/hedgedoc-clean && sudo docker compose down"

echo.
echo ========================================
echo HedgeDoc stopped successfully!
echo ========================================
echo.
echo Press any key to exit...
pause > nul
