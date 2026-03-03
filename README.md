# 🏥 Onmint Healthcare Platform

## 🎯 Multi-App Architecture with Real-time Updates

Complete healthcare platform with **3 separate Flutter apps** running on different ports, **PostgreSQL database**, and **real-time WebSocket updates**.

### 📱 Three Apps:
1. **User App** (Port 8080) - For patients to book services
2. **Vendor App** (Port 8081) - For doctors, nurses, ambulance, pharmacy, labs
3. **Admin App** (Port 8082) - For monitoring and management

### ⚡ Real-time Features:
- Instant booking notifications
- Live status updates
- Real-time location tracking (ambulance)
- Push notifications

---

## 🚀 Quick Start (3 Steps)

### Step 1: Setup PostgreSQL Database

```cmd
# Install PostgreSQL from: https://www.postgresql.org/download/windows/
# Then create database:
psql -U postgres
CREATE DATABASE onmint_healthcare;
\q
```

**Read detailed guide:** `POSTGRESQL_SETUP.md`

### Step 2: Configure & Start Backend

Edit `backend_onmint/.env` with your PostgreSQL password, then:

```cmd
START_BACKEND_POSTGRESQL.bat
```

Backend will auto-create all tables and start on http://localhost:5000

### Step 3: Create & Run Flutter Apps

```cmd
# Create 3 apps
CREATE_FLUTTER_APPS.bat

# Run each app in separate terminal:
cd user_app && flutter run -d chrome --web-port=8080
cd vendor_app && flutter run -d chrome --web-port=8081
cd admin_app && flutter run -d chrome --web-port=8082
```

---

## 📖 Documentation

- **NEW_STRUCTURE_README.md** - Complete architecture guide
- **POSTGRESQL_SETUP.md** - Database setup instructions
- **API Documentation** - See routes in `backend_onmint/routes/`

---

## 🔥 What's New

✅ **Migrated from MongoDB to PostgreSQL**
✅ **3 Separate Flutter Apps** (User, Vendor, Admin)
✅ **Real-time Updates** with Socket.IO
✅ **Geospatial Queries** for nearby services
✅ **Role-based Access Control**
✅ **Instant Notifications**

---



📋 ONMINT HEALTHCARE APP - COMPLETE DEVELOPMENT PLAN
🎯 PROJECT OVERVIEW
App Name: Onmint
Platform: Flutter (iOS, Android, Web)
Backend: Node.js + Express + MongoDB (Already built)
Core Services: Medicine, Doctor Consultation, Nurses, Lab Tests, Ambulance

🏗️ ARCHITECTURE
3 User Roles:

Patient/User - Access all services
Service Provider - Doctor, Nurse, Ambulance Owner, Pharmacist, Lab
Admin - Monitor and manage everything
Single App with Role-Based UI (for now, later split into 3 apps)

📱 FLUTTER APP STRUCTURE
onmint/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── config/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── login/
│   │   │   ├── register/
│   │   │   └── otp/
│   │   ├── home/
│   │   ├── medicine/
│   │   ├── doctor/
│   │   ├── nurse/
│   │   ├── lab_test/
│   │   ├── ambulance/
│   │   ├── booking/
│   │   ├── profile/
│   │   └── admin/
│   └── widgets/
🔐 PHASE 1: AUTHENTICATION (Week 1)
Features:

Splash screen with location permission
Role selection (Patient/Provider/Admin)
Mobile number login
OTP verification
Password setup
Profile completion
JWT token management
Screens:

Splash Screen
Role Selection
Login (Mobile + Password)
OTP Verification
Register (with role-specific fields)
Profile Setup
API Endpoints:

POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
GET /api/v1/auth/profile
🏠 PHASE 2: HOME SCREEN - PATIENT (Week 2)
Layout:

┌─────────────────────────────┐
│ 📍 Location Selector        │
│ [Current Location ▼]        │
├─────────────────────────────┤
│ 🔍 Search medicines...      │
├─────────────────────────────┤
│ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌─┐│
│ │💊 │ │👨‍⚕│ │👩‍⚕│ │🧪│ │🚑││
│ │Med│ │Doc│ │Nur│ │Lab│ │Amb││
│ └───┘ └───┘ └───┘ └───┘ └─┘│
├─────────────────────────────┤
│ 📢 Advertisements Carousel  │
│ [Ad 1] → [Ad 2] → [Ad 3]    │
├─────────────────────────────┤
│ 💊 Featured Medicines       │
│ ┌──────┐ ┌──────┐ ┌──────┐ │
│ │Para  │ │Aspir │ │Cough │ │
│ │₹50   │ │₹30   │ │₹120  │ │
│ └──────┘ └──────┘ └──────┘ │
├─────────────────────────────┤
│ 👨‍⚕️ Top Doctors             │
│ ┌──────────────────────────┐│
│ │ Dr. Smith - Cardiologist ││
│ │ ⭐ 4.8 | 2.3 km away     ││
│ └──────────────────────────┘│
└─────────────────────────────┘
Features:

Location picker (GPS + Manual)
5 service icons (Medicine, Doctor, Nurse, Lab, Ambulance)
Advertisement carousel
Medicine categories
Nearby doctors/services
Search functionality
💊 PHASE 3: MEDICINE MODULE (Week 3-4)
Screens:

Medicine List (with categories)
Medicine Detail
Cart
Checkout
Order Tracking
Order History
Features:

Browse medicines by category
Search medicines
View medicine details (name, price, manufacturer, prescription required)
Add to cart
Place order
Track order status
Prescription upload (if required)
API Endpoints:

GET /api/v1/pharmacist/medicines
GET /api/v1/pharmacist/medicines/:id
POST /api/v1/patient/bookings (serviceType: pharmacy)
GET /api/v1/patient/bookings
👨‍⚕️ PHASE 4: DOCTOR CONSULTATION (Week 5-6)
Screens:

Doctor List (with filters)
Doctor Profile
Booking Form
Appointment Confirmation
Appointment Details
Video Consultation (optional)
Prescription View
Features:

Find nearby doctors
Filter by specialization
View doctor profile (rating, experience, availability)
Book appointment
Real-time booking status
Video consultation
View/download prescription
Rate & review
API Endpoints:

GET /api/v1/patient/services/nearby?serviceType=doctor
POST /api/v1/patient/bookings
GET /api/v1/patient/bookings/:id
POST /api/v1/patient/bookings/:id/rate
👩‍⚕️ PHASE 5: NURSE SERVICE (Week 7)
Screens:

Nurse List
Nurse Profile
Service Selection (home visit, injection, dressing, etc.)
Booking Form
Booking Tracking
Features:

Find nearby nurses
Select service type
Book home visit
Track nurse location
Rate & review
API Endpoints:

GET /api/v1/patient/services/nearby?serviceType=nurse
POST /api/v1/patient/bookings
🧪 PHASE 6: LAB TEST (Week 8)
Screens:

Lab List
Test Categories
Test Selection
Sample Collection Options (home/lab)
Booking Form
Report View/Download
Features:

Browse lab tests
Select tests
Choose sample collection (home/lab visit)
Book appointment
View/download reports
API Endpoints:

GET /api/v1/patient/services/nearby?serviceType=pathology
POST /api/v1/patient/bookings
GET /api/v1/pathology/bookings/:id/report
🚑 PHASE 7: AMBULANCE SERVICE (Week 9)
Screens:

Ambulance Request Form
Nearby Ambulances Map
Ambulance Tracking (Real-time)
Trip Details
Emergency Button
Features:

Request ambulance
View nearby ambulances on map
Real-time location tracking
ETA display
Emergency quick booking
Trip history
API Endpoints:

GET /api/v1/patient/services/nearby?serviceType=ambulance
POST /api/v1/patient/bookings
POST /api/v1/patient/emergency
GET /api/v1/ambulance/location/:id
🏥 PHASE 8: SERVICE PROVIDER DASHBOARD (Week 10-11)
Doctor Dashboard:

Appointment requests
Accept/Reject appointments
Update availability
Create prescriptions
View earnings
Profile management
Nurse Dashboard:

Service requests
Accept/Reject bookings
Update location
Mark service complete
View earnings
Ambulance Dashboard:

Ride requests
Accept/Reject rides
Update real-time location
Mark trip complete
View earnings
Pharmacist Dashboard:

Medicine inventory
Order management
Update stock
Process orders
Lab Dashboard:

Test bookings
Sample collection schedule
Upload reports
Manage tests
API Endpoints:

GET /api/v1/doctor/appointments
POST /api/v1/doctor/appointments/:id/accept
PUT /api/v1/doctor/availability
POST /api/v1/doctor/prescriptions
Similar for other providers
👑 PHASE 9: ADMIN DASHBOARD (Week 12)
Screens:

Dashboard (Stats & Analytics)
User Management
Provider Approval
Booking Management
Reports & Analytics
Settings
Features:

View all users
Approve/reject providers
Block/unblock users
View all bookings
Analytics dashboard
Revenue reports
API Endpoints:

GET /api/v1/admin/users
POST /api/v1/admin/providers/:id/approve
POST /api/v1/admin/users/:id/block
GET /api/v1/admin/dashboard
🔔 PHASE 10: NOTIFICATIONS & REAL-TIME (Week 13)
Features:

Push notifications (Firebase)
In-app notifications
Real-time booking updates
Real-time location tracking
WebSocket integration
🎨 UI/UX GUIDELINES
Colors:

Primary: #4CAF50 (Green - Healthcare)
Secondary: #2196F3 (Blue)
Accent: #FF9800 (Orange)
Error: #F44336 (Red)
Background: #FFFFFF
Text: #212121
Typography:

Headings: Poppins Bold
Body: Roboto Regular
Buttons: Roboto Medium
Components:

Material Design 3
Bottom Navigation
Floating Action Button
Cards with shadows
Smooth animations
📦 FLUTTER PACKAGES NEEDED
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  dio: ^5.4.0
  retrofit: ^4.0.3
  
  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  
  # Location
  geolocator: ^11.0.0
  google_maps_flutter: ^2.5.3
  
  # Authentication
  firebase_auth: ^4.16.0
  firebase_messaging: ^14.7.10
  
  # UI
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  carousel_slider: ^4.2.1
  flutter_rating_bar: ^4.0.1
  
  # Utils
  intl: ^0.19.0
  url_launcher: ^6.2.4
  image_picker: ^1.0.7
  file_picker: ^6.1.1
  
  # Real-time
  socket_io_client: ^2.0.3
🔧 BACKEND SETUP CHECKLIST
✅ Install MongoDB
✅ Install Redis
✅ Configure .env file
✅ Run npm install
✅ Start MongoDB: mongod
✅ Start Redis: redis-server
✅ Start backend: npm run dev
✅ Test API: http://localhost:5000/api/v1/health
🚀 DEVELOPMENT TIMELINE
Phase	Duration	Deliverable
1. Authentication	1 week	Login/Register working
2. Home Screen	1 week	UI complete
3. Medicine	2 weeks	Full medicine ordering
4. Doctor	2 weeks	Booking & consultation
5. Nurse	1 week	Nurse booking
6. Lab Test	1 week	Lab booking & reports
7. Ambulance	1 week	Real-time tracking
8. Provider Dashboard	2 weeks	All provider features
9. Admin Dashboard	1 week	Admin panel
10. Notifications	1 week	Push & real-time
Total	13 weeks	Complete App
✅ NEXT IMMEDIATE STEPS
Stop Flutter Chrome app (press q in terminal)
Start Backend Server
Create Flutter project structure
Implement Authentication screens
Connect to backend APIs
Test login flow
Want me to start building the Flutter app now? I'll create the complete authentication module first!