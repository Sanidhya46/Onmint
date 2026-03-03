# 🐘 PostgreSQL Setup Guide for Onmint Healthcare

## 📋 Prerequisites

1. Install PostgreSQL (if not already installed)
2. Install Node.js (already have it)
3. Install Flutter (already have it)

## 🔧 Step 1: Install PostgreSQL on Windows

### Download & Install:
```
1. Download PostgreSQL from: https://www.postgresql.org/download/windows/
2. Run the installer
3. Set password for 'postgres' user (remember this!)
4. Default port: 5432 (keep it)
5. Install pgAdmin 4 (comes with installer)
```

### Verify Installation:
```cmd
psql --version
```

## 🗄️ Step 2: Create Database

Open Command Prompt and run:

```cmd
psql -U postgres
```

Enter your postgres password, then run these SQL commands:

```sql
-- Create database
CREATE DATABASE onmint_healthcare;

-- Connect to database
\c onmint_healthcare

-- Create user (optional, for security)
CREATE USER onmint_user WITH PASSWORD 'onmint_secure_pass_2026';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE onmint_healthcare TO onmint_user;

-- Exit
\q
```

## 📝 Step 3: Database Connection Details

Use these credentials in your backend `.env` file:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onmint_healthcare
DB_USER=postgres
DB_PASSWORD=your_postgres_password
```

Or if you created onmint_user:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onmint_healthcare
DB_USER=onmint_user
DB_PASSWORD=onmint_secure_pass_2026
```

## 🚀 Step 4: Initialize Database Schema

The backend will automatically create all tables when you first run it!

Tables that will be created:
- users (patients, doctors, nurses, ambulance, pharmacists, labs, admin)
- bookings (appointments, orders, rides)
- prescriptions
- medicines
- notifications
- ratings

## ✅ Quick Test Connection

```cmd
psql -U postgres -d onmint_healthcare -c "SELECT version();"
```

## 🔌 Connection String Format

```
postgresql://username:password@host:port/database
```

Example:
```
postgresql://postgres:yourpassword@localhost:5432/onmint_healthcare
```

## 📊 Useful PostgreSQL Commands

```sql
-- List all databases
\l

-- Connect to database
\c onmint_healthcare

-- List all tables
\dt

-- Describe table structure
\d users

-- View table data
SELECT * FROM users LIMIT 10;

-- Exit
\q
```

## 🛠️ Troubleshooting

### Can't connect to PostgreSQL?
1. Check if PostgreSQL service is running:
   - Open Services (services.msc)
   - Find "postgresql-x64-XX"
   - Make sure it's "Running"

2. Check firewall settings
3. Verify password is correct

### Port already in use?
Change port in postgresql.conf or use different port in connection string

## 🎯 Next Steps

1. Install PostgreSQL
2. Create database using commands above
3. Update backend .env file with connection details
4. Run backend - it will auto-create tables
5. Start using the app!
