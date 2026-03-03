@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🏪 Starting Vendor App on Port 8081               ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
cd vendor_app
flutter run -d chrome --web-port=8081
