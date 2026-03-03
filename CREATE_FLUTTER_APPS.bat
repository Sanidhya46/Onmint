@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🏥 CREATING 3 FLUTTER APPS FOR ONMINT             ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.

echo 📱 Creating User App (Port 8080)...
call flutter create user_app
echo.

echo 🏪 Creating Vendor App (Port 8081)...
call flutter create vendor_app
echo.

echo 👑 Creating Admin App (Port 8082)...
call flutter create admin_app
echo.

echo ✅ All 3 Flutter apps created successfully!
echo.
echo Next steps:
echo 1. Configure each app to connect to backend
echo 2. Run user_app: flutter run -d chrome --web-port=8080
echo 3. Run vendor_app: flutter run -d chrome --web-port=8081
echo 4. Run admin_app: flutter run -d chrome --web-port=8082
echo.

pause
