# 📊 How to View Your PostgreSQL Database

## Method 1: Using pgAdmin (GUI - EASIEST)

### Step 1: Open pgAdmin
pgAdmin was installed with PostgreSQL. Find it in Start Menu:
```
Start Menu → PostgreSQL 18 → pgAdmin 4
```

### Step 2: Connect to Server
1. In pgAdmin, expand "Servers" in left panel
2. Click on "PostgreSQL 18"
3. Enter password: `sanidhya@461984`

### Step 3: View Database
1. Expand "Databases"
2. Find "onmint_healthcare"
3. Expand it → Schemas → public → Tables

### Step 4: View Table Data
Right-click on any table (e.g., "users") → View/Edit Data → All Rows

You'll see all your data in a nice table format!

---

## Method 2: Using Command Line (psql)

### Open Command Prompt and run:

```cmd
"C:\Program Files\PostgreSQL\18\bin\psql" -U postgres -d onmint_healthcare
```

Enter password: `sanidhya@461984`

### Useful Commands:

```sql
-- List all tables
\dt

-- View all users
SELECT * FROM users;

-- View all bookings
SELECT * FROM bookings;

-- View specific columns
SELECT id, email, role, "firstName", "lastName" FROM users;

-- Count users by role
SELECT role, COUNT(*) FROM users GROUP BY role;

-- View recent bookings
SELECT * FROM bookings ORDER BY "createdAt" DESC LIMIT 10;

-- Exit
\q
```

---

## Method 3: Using DBeaver (Free Database Tool)

### Step 1: Download DBeaver
https://dbeaver.io/download/

### Step 2: Create Connection
1. Open DBeaver
2. Click "New Database Connection"
3. Select "PostgreSQL"
4. Enter details:
   - Host: localhost
   - Port: 5432
   - Database: onmint_healthcare
   - Username: postgres
   - Password: sanidhya@461984
5. Click "Test Connection"
6. Click "Finish"

### Step 3: Browse Data
1. Expand connection → onmint_healthcare → Schemas → public → Tables
2. Double-click any table to view data
3. You can edit, filter, and export data

---

## Quick Database Queries

### View All Tables:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
```

### View Admin User:
```sql
SELECT * FROM users WHERE role = 'admin';
```

### View All Patients:
```sql
SELECT id, email, "firstName", "lastName", phone 
FROM users 
WHERE role = 'patient';
```

### View Bookings with Patient Names:
```sql
SELECT 
  b.id,
  b."serviceType",
  b.status,
  p."firstName" || ' ' || p."lastName" as patient_name,
  b."createdAt"
FROM bookings b
JOIN users p ON b."patientId" = p.id
ORDER BY b."createdAt" DESC;
```

---

## Create Test Data

### Add a Test Patient:
```sql
INSERT INTO users (
  id, email, password, role, "firstName", "lastName", 
  phone, city, state, status, "isActive", 
  rating, "totalRatings", "createdAt", "updatedAt"
) VALUES (
  gen_random_uuid(),
  'test@patient.com',
  '$2a$10$abcdefghijklmnopqrstuvwxyz',
  'patient',
  'Test',
  'Patient',
  '9999999999',
  'Mumbai',
  'Maharashtra',
  'approved',
  true,
  0,
  0,
  NOW(),
  NOW()
);
```

### Add a Test Doctor:
```sql
INSERT INTO users (
  id, email, password, role, "firstName", "lastName", 
  phone, city, state, status, "isActive",
  specialization, "consultationFee", latitude, longitude,
  rating, "totalRatings", "createdAt", "updatedAt"
) VALUES (
  gen_random_uuid(),
  'doctor@test.com',
  '$2a$10$abcdefghijklmnopqrstuvwxyz',
  'doctor',
  'Dr. John',
  'Smith',
  '9999999998',
  'Mumbai',
  'Maharashtra',
  'approved',
  true,
  'Cardiologist',
  500.00,
  19.0760,
  72.8777,
  4.5,
  10,
  NOW(),
  NOW()
);
```

---

## Monitor Real-time Changes

### Watch for new users:
```sql
SELECT id, email, role, "firstName", "createdAt" 
FROM users 
ORDER BY "createdAt" DESC 
LIMIT 5;
```

### Watch for new bookings:
```sql
SELECT id, "serviceType", status, "createdAt" 
FROM bookings 
ORDER BY "createdAt" DESC 
LIMIT 5;
```

---

## Database Structure

Your database has these tables:

1. **users** - All users (patients, doctors, nurses, etc.)
2. **bookings** - All appointments and orders
3. **prescriptions** - Doctor prescriptions
4. **medicines** - Pharmacy inventory
5. **notifications** - Push notifications

---

## Backup Database

```cmd
"C:\Program Files\PostgreSQL\18\bin\pg_dump" -U postgres -d onmint_healthcare > backup.sql
```

## Restore Database

```cmd
"C:\Program Files\PostgreSQL\18\bin\psql" -U postgres -d onmint_healthcare < backup.sql
```

---

## 🎯 Quick Test

After running your app, check if data is being saved:

```sql
-- Check total users
SELECT COUNT(*) FROM users;

-- Check admin exists
SELECT * FROM users WHERE email = 'admin@onmint.com';

-- Check if any bookings
SELECT COUNT(*) FROM bookings;
```

---

## 🔥 Pro Tips

1. **pgAdmin** is best for browsing and editing
2. **psql** is best for quick queries
3. **DBeaver** is best for complex queries and exports
4. Always backup before making changes!
5. Use `\d tablename` in psql to see table structure

---

## Need Help?

If you can't connect:
1. Make sure PostgreSQL service is running
2. Check password is correct
3. Verify database exists: `\l` in psql
4. Check if backend created tables successfully

**Your database is ready to use!** 🎉
