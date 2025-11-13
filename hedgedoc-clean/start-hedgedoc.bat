@echo off
echo ========================================
echo Starting HedgeDoc 1.x
echo ========================================
echo.

echo [1/4] Starting Docker daemon in WSL Debian...
wsl -d Debian bash -c "sudo dockerd > /dev/null 2>&1 &"
timeout /t 3 /nobreak > nul

echo [2/4] Checking Docker configuration...
wsl -d Debian bash -c "grep -q '\"userland-proxy\": true' /etc/docker/daemon.json || echo '{\"iptables\": false, \"dns\": [\"8.8.8.8\", \"8.8.4.4\"], \"userland-proxy\": true}' | sudo tee /etc/docker/daemon.json > /dev/null"

echo [3/4] Starting HedgeDoc containers...
wsl -d Debian bash -c "cd /mnt/f/GitHub/hedgedoc/hedgedoc-clean && sudo docker compose up -d"

echo [4/4] Waiting for services to start...
timeout /t 10 /nobreak > nul

echo.
echo ========================================
echo HedgeDoc is ready!
echo ========================================
echo.
echo Web Interface: http://localhost:3000
echo.
echo Press any key to check status...
pause > nul

wsl -d Debian bash -c "cd /mnt/f/GitHub/hedgedoc/hedgedoc-clean && sudo docker compose ps"

echo.
echo Press any key to exit...
pause > nul
