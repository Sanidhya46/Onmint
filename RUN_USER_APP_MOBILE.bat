@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     📱 Starting User App on Android Emulator          ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Make sure Android emulator is running!
echo Or connect your physical Android device via USB
echo.
pause
echo.
cd user_app
flutter run
