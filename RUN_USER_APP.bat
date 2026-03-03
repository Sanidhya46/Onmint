@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     📱 Starting User App on Port 8080                 ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
cd user_app
flutter run -d chrome --web-port=8080
