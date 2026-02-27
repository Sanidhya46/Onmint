@echo off
echo ========================================
echo   MONGODB CONNECTION TEST
echo ========================================
echo.

cd backend_onmint\OurDeals-healthCare

echo Testing MongoDB Atlas connection...
echo.

node test-connection.js

echo.
pause
