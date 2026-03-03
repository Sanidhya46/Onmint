@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     👑 Starting Admin App on Port 8082                ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
cd admin_app
flutter run -d chrome --web-port=8082
