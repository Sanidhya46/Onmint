@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🚀 Starting All 3 ONMINT Apps                     ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Starting User App on port 8080...
start "User App" cmd /k "cd user_app && flutter run -d chrome --web-port=8080"
timeout /t 2 >nul

echo Starting Vendor App on port 8081...
start "Vendor App" cmd /k "cd vendor_app && flutter run -d chrome --web-port=8081"
timeout /t 2 >nul

echo Starting Admin App on port 8082...
start "Admin App" cmd /k "cd admin_app && flutter run -d chrome --web-port=8082"

echo.
echo ✅ All 3 apps are starting!
echo.
echo User App: http://localhost:8080
echo Vendor App: http://localhost:8081
echo Admin App: http://localhost:8082
echo.
pause
