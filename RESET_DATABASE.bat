@echo off
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                                                        ║
echo ║     🔄 Resetting Database                             ║
echo ║                                                        ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo This will drop and recreate the database
echo.
pause
echo.

psql -U postgres -c "DROP DATABASE IF EXISTS onmint_healthcare;"
psql -U postgres -c "CREATE DATABASE onmint_healthcare;"

echo.
echo ✅ Database reset complete!
echo Now run: START_BACKEND_POSTGRESQL.bat
echo.
pause
