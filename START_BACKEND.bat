@echo off
echo ========================================
echo   ONMINT BACKEND STARTER
echo ========================================
echo.

cd backend_onmint\OurDeals-healthCare

echo Installing dependencies...
call npm install

echo.
echo Starting backend server...
echo Backend will run on: http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

call npm run dev

pause
