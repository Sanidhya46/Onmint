@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🏥 ONMINT HEALTHCARE BACKEND (PostgreSQL)         ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo 🔄 Starting backend server...
echo.

cd backend_onmint

REM Check if node_modules exists
if not exist "node_modules\" (
    echo 📦 Installing dependencies...
    call npm install
    echo.
)

echo ✅ Starting server...
echo.
call npm start

pause
