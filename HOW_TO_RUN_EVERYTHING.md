# 🚀 How to Run Everything - ONMINT Healthcare

## ✅ Backend is Already Running!

The backend is now running successfully on **http://localhost:5000**

You should see:
```
✅ Server running on: http://localhost:5000
✅ Database schema ready!
✅ Default admin created: admin@onmint.com / Admin@123
```

---

## 🎯 Option 1: Run All 3 Apps at Once (EASIEST)

Double-click: **RUN_ALL_APPS.bat**

This will open 3 separate windows and start:
- User App on port 8080
- Vendor App on port 8081
- Admin App on port 8082

---

## 🎯 Option 2: Run Apps Individually

### Terminal 1 - User App
```cmd
cd Onmint\user_app
flutter run -d chrome --web-port=8080
```
Or double-click: `RUN_USER_APP.bat`

### Terminal 2 - Vendor App
```cmd
cd Onmint\vendor_app
flutter run -d chrome --web-port=8081
```
Or double-click: `RUN_VENDOR_APP.bat`

### Terminal 3 - Admin App
```cmd
cd Onmint\admin_app
flutter run -d chrome --web-port=8082
```
Or double-click: `RUN_ADMIN_APP.bat`

---

## 🌐 Access the Apps

Once running, open these URLs in Chrome:

- **User App:** http://localhost:8080
- **Vendor App:** http://localhost:8081
- **Admin App:** http://localhost:8082

---

## 🎨 What You'll See

### User App (Port 8080)
- Beautiful splash screen with animation
- Home screen with 5 service cards:
  - 💊 Medicine
  - 👨‍⚕️ Doctor
  - 👩‍⚕️ Nurse
  - 🧪 Lab Test
- 🚨 Emergency Ambulance button
- Bottom navigation (Home, Bookings, Profile)

### Vendor App (Port 8081)
- Vendor login screen
- Blue theme
- For doctors, nurses, ambulance, pharmacy, labs

### Admin App (Port 8082)
- Admin dashboard
- Orange theme
- Login: admin@onmint.com / Admin@123

---

## ✅ Everything Working Now!

### Backend ✅
- Running on port 5000
- PostgreSQL connected
- All tables created
- Real-time WebSocket ready

### Apps ✅
- All 3 apps created
- Configured to connect to backend
- Beautiful UI with medical theme
- Ready to build features

---

## 🔧 If Backend Stops

Restart it:
```cmd
cd Onmint
START_BACKEND_POSTGRESQL.bat
```

Or manually:
```cmd
cd Onmint\backend_onmint
npm start
```

---

## 📊 Test the Setup

1. Backend running: ✅ (Already done!)
2. Open User App: Click RUN_USER_APP.bat
3. See splash screen animation
4. Navigate through tabs
5. Click on service cards

---

## 🎉 You're All Set!

- ✅ Backend running with PostgreSQL
- ✅ Real-time WebSocket ready
- ✅ 3 Flutter apps ready to run
- ✅ All errors fixed
- ✅ Database created with admin account

**Now you can start building the full features!** 🚀
