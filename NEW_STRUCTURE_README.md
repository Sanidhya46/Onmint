# 🏥 Onmint Healthcare - Multi-App Architecture with PostgreSQL

## 🎯 Project Overview

Complete healthcare platform with:
- **3 Separate Flutter Apps** (User, Vendor, Admin) running on different ports
- **PostgreSQL Database** for robust data management
- **Real-time Updates** using WebSocket (Socket.IO)
- **RESTful API** with Node.js + Express

---

## 📁 Project Structure

```
Onmint/
├── backend_onmint/              # Backend API (PostgreSQL + Socket.IO)
│   ├── config/
│   │   └── database.js          # PostgreSQL connection
│   ├── models/
│   │   ├── User.js              # User model (all roles)
│   │   ├── Booking.js           # Bookings/Appointments
│   │   ├── Prescription.js      # Doctor prescriptions
│   │   ├── Medicine.js          # Pharmacy medicines
│   │   ├── Notification.js      # Push notifications
│   │   └── index.js             # Model associations
│   ├── routes/
│   │   ├── auth.routes.js       # Authentication
│   │   ├── patient.routes.js    # Patient endpoints
│   │   ├── doctor.routes.js     # Doctor endpoints
│   │   ├── nurse.routes.js      # Nurse endpoints
│   │   ├── ambulance.routes.js  # Ambulance endpoints
│   │   ├── pharmacist.routes.js # Pharmacy endpoints
│   │   ├── pathology.routes.js  # Lab endpoints
│   │   └── admin.routes.js      # Admin endpoints
│   ├── middleware/
│   │   └── auth.js              # JWT authentication
│   ├── scripts/
│   │   └── init-db.js           # Database initialization
│   ├── .env                     # Environment variables
│   ├── server.js                # Main server file
│   └── package.json             # Dependencies
│
├── user_app/                    # Flutter User App (Port 8080)
│   └── (To be created)
│
├── vendor_app/                  # Flutter Vendor App (Port 8081)
│   └── (To be created)
│
├── admin_app/                   # Flutter Admin App (Port 8082)
│   └── (To be created)
│
├── POSTGRESQL_SETUP.md          # PostgreSQL installation guide
├── NEW_STRUCTURE_README.md      # This file
├── START_BACKEND_POSTGRESQL.bat # Start backend server
└── CREATE_FLUTTER_APPS.bat      # Create 3 Flutter apps
```

---

## 🚀 Quick Start Guide

### Step 1: Install PostgreSQL

1. Download PostgreSQL from: https://www.postgresql.org/download/windows/
2. Install with default settings
3. Remember the password you set for 'postgres' user
4. Default port: 5432

### Step 2: Create Database

Open Command Prompt and run:

```cmd
psql -U postgres
```

Then in PostgreSQL shell:

```sql
CREATE DATABASE onmint_healthcare;
\q
```

### Step 3: Configure Backend

Edit `backend_onmint/.env` file:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onmint_healthcare
DB_USER=postgres
DB_PASSWORD=your_postgres_password_here
```

### Step 4: Install Backend Dependencies & Start

```cmd
cd Onmint
START_BACKEND_POSTGRESQL.bat
```

The backend will:
- Install npm packages
- Connect to PostgreSQL
- Create all tables automatically
- Create default admin account
- Start on http://localhost:5000

### Step 5: Create Flutter Apps

```cmd
cd Onmint
CREATE_FLUTTER_APPS.bat
```

This creates 3 separate Flutter apps:
- `user_app` - For patients
- `vendor_app` - For doctors, nurses, ambulance, pharmacy, labs
- `admin_app` - For admin dashboard

### Step 6: Run Flutter Apps

Open 3 separate Command Prompt windows:

**Window 1 - User App:**
```cmd
cd Onmint\user_app
flutter run -d chrome --web-port=8080
```

**Window 2 - Vendor App:**
```cmd
cd Onmint\vendor_app
flutter run -d chrome --web-port=8081
```

**Window 3 - Admin App:**
```cmd
cd Onmint\admin_app
flutter run -d chrome --web-port=8082
```

---

## 🔌 Real-time Updates

### How It Works

When a user books a doctor appointment:

1. **User App** sends booking request to backend
2. **Backend** saves to PostgreSQL
3. **Backend** emits WebSocket event: `new_booking`
4. **Vendor App** (doctor) receives instant notification
5. Doctor clicks Accept/Reject
6. **User App** gets instant update

### Socket.IO Events

```javascript
// User books appointment
socket.emit('new_booking', { providerId, booking })

// Vendor accepts
socket.emit('booking_accepted', { patientId, bookingId })

// Real-time location (ambulance)
socket.emit('ambulance_location_update', { ambulanceId, location })
```

---

## 📊 Database Schema

### Users Table
- All roles: patient, doctor, nurse, ambulance, pharmacist, pathology, admin
- Location stored as PostGIS POINT for geospatial queries
- Role-specific fields (specialization, license, etc.)

### Bookings Table
- Links patient to provider
- Service type: doctor, nurse, ambulance, pharmacy, pathology
- Status: pending, accepted, rejected, in_progress, completed, cancelled
- Includes ratings and reviews

### Prescriptions Table
- Created by doctors
- Linked to bookings
- Contains medicines (JSONB), tests, diagnosis

### Medicines Table
- Managed by pharmacists
- Stock tracking
- Prescription required flag

### Notifications Table
- Push notifications for all users
- Types: booking, payment, reminder, system

---

## 🔐 API Endpoints

### Authentication
```
POST   /api/v1/auth/register      - Register new user
POST   /api/v1/auth/login         - Login
GET    /api/v1/auth/me            - Get current user
POST   /api/v1/auth/logout        - Logout
```

### Patient (User App)
```
GET    /api/v1/patient/services/nearby    - Find nearby providers
POST   /api/v1/patient/bookings           - Create booking
GET    /api/v1/patient/bookings           - Get my bookings
POST   /api/v1/patient/bookings/:id/cancel - Cancel booking
POST   /api/v1/patient/bookings/:id/rate  - Rate service
GET    /api/v1/patient/notifications      - Get notifications
```

### Doctor (Vendor App)
```
GET    /api/v1/doctor/appointments        - Get appointments
POST   /api/v1/doctor/appointments/:id/accept - Accept appointment
POST   /api/v1/doctor/appointments/:id/reject - Reject appointment
POST   /api/v1/doctor/prescriptions       - Create prescription
GET    /api/v1/doctor/dashboard           - Dashboard stats
```

### Nurse (Vendor App)
```
GET    /api/v1/nurse/requests             - Get service requests
POST   /api/v1/nurse/requests/:id/accept  - Accept request
```

### Ambulance (Vendor App)
```
GET    /api/v1/ambulance/requests         - Get ride requests
POST   /api/v1/ambulance/requests/:id/accept - Accept ride
PUT    /api/v1/ambulance/location         - Update real-time location
```

### Admin (Admin App)
```
GET    /api/v1/admin/dashboard            - Dashboard stats
GET    /api/v1/admin/users                - Get all users
GET    /api/v1/admin/approvals/pending    - Pending approvals
POST   /api/v1/admin/providers/:id/approve - Approve provider
POST   /api/v1/admin/providers/:id/reject  - Reject provider
POST   /api/v1/admin/users/:id/block      - Block user
POST   /api/v1/admin/users/:id/unblock    - Unblock user
GET    /api/v1/admin/bookings             - Get all bookings
```

---

## 🎨 App Configurations

### User App (Port 8080)
- Patient registration & login
- Browse services (Doctor, Nurse, Ambulance, Pharmacy, Lab)
- Book appointments
- Track bookings in real-time
- Rate & review services
- View prescriptions

### Vendor App (Port 8081)
- Provider registration (Doctor, Nurse, Ambulance, Pharmacy, Lab)
- Receive booking requests instantly
- Accept/Reject bookings
- Update availability
- Create prescriptions (doctors)
- Update location (ambulance)
- Manage inventory (pharmacy)

### Admin App (Port 8082)
- Dashboard with real-time stats
- Approve/Reject provider registrations
- Monitor all bookings
- Block/Unblock users
- View analytics
- System management

---

## 🔧 Environment Variables

```env
# Server
PORT=5000
NODE_ENV=development

# PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onmint_healthcare
DB_USER=postgres
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_secret_key
JWT_EXPIRE=7d

# CORS (for 3 apps)
CORS_ORIGIN=http://localhost:8080,http://localhost:8081,http://localhost:8082

# Socket.IO
SOCKET_IO_CORS=http://localhost:8080,http://localhost:8081,http://localhost:8082
```

---

## 📱 Default Accounts

After first run, these accounts are created:

**Admin:**
- Email: admin@onmint.com
- Password: Admin@123

You can create test accounts for:
- Patient
- Doctor
- Nurse
- Ambulance
- Pharmacist
- Lab

---

## 🧪 Testing Real-time Updates

1. Start backend
2. Run User App (port 8080)
3. Run Vendor App (port 8081)
4. Login as patient in User App
5. Book a doctor appointment
6. Switch to Vendor App (logged in as doctor)
7. See instant notification of new booking
8. Accept booking
9. Switch back to User App
10. See instant status update!

---

## 🛠️ Troubleshooting

### PostgreSQL Connection Failed
```
❌ Error: connect ECONNREFUSED 127.0.0.1:5432
```
**Solution:**
1. Check if PostgreSQL service is running (services.msc)
2. Verify credentials in .env file
3. Make sure database exists

### Port Already in Use
```
❌ Error: Port 5000 is already in use
```
**Solution:**
1. Change PORT in .env file
2. Or kill process using port: `netstat -ano | findstr :5000`

### Flutter App Can't Connect
```
❌ Connection timeout
```
**Solution:**
1. Make sure backend is running
2. Check CORS_ORIGIN in .env includes your app port
3. Verify API URL in Flutter app config

---

## 📖 Next Steps

1. ✅ PostgreSQL installed and configured
2. ✅ Backend running with real-time support
3. ✅ 3 Flutter apps created
4. ⏳ Configure Flutter apps to connect to backend
5. ⏳ Implement UI for each app
6. ⏳ Add Socket.IO client in Flutter
7. ⏳ Test real-time updates
8. ⏳ Deploy to production

---

## 🎉 Features Implemented

✅ PostgreSQL database with PostGIS for location
✅ Real-time updates with Socket.IO
✅ JWT authentication
✅ Role-based access control
✅ Geospatial queries for nearby services
✅ Booking management
✅ Prescription system
✅ Notification system
✅ Rating & review system
✅ Admin dashboard
✅ Multi-app architecture

---

## 📞 Support

For issues or questions:
1. Check POSTGRESQL_SETUP.md
2. Review error messages carefully
3. Verify all services are running
4. Check .env configuration

---

**Happy Coding! 🚀**
