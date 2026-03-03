@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🐘 PostgreSQL Database Setup for Onmint          ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo This will create the database for Onmint Healthcare
echo.
echo Make sure PostgreSQL is installed first!
echo Download from: https://www.postgresql.org/download/windows/
echo.
pause
echo.
echo Creating database...
echo.

psql -U postgres -c "CREATE DATABASE onmint_healthcare;"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Database created successfully!
    echo.
    echo Next step: Update password in backend_onmint\.env file
    echo Then run: START_BACKEND_POSTGRESQL.bat
) else (
    echo.
    echo ❌ Failed to create database
    echo.
    echo Possible reasons:
    echo 1. PostgreSQL is not installed
    echo 2. Wrong password
    echo 3. Database already exists (which is OK!)
    echo.
    echo Try running backend anyway - it will work if database exists
)

echo.
pause
