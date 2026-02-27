# 🚀 Onmint Quick Start Guide

## Step 1: Test MongoDB Connection (30 seconds)

Open Command Prompt in the `onmint` folder and run:

```bash
TEST_MONGODB.bat
```

### Expected Output:
```
✅ MongoDB Atlas Connected Successfully!
📊 Database: ourdeals
```

### If it fails:
- Check `MONGODB_TROUBLESHOOTING.md`
- Verify MongoDB Atlas Network Access has `0.0.0.0/0`
- Try using a VPN or mobile hotspot

---

## Step 2: Start Backend Server (1 minute)

```bash
START_BACKEND.bat
```

### Expected Output:
```
✅ Server is running on http://localhost:5000
📱 Flutter app should connect to: http://localhost:5000/api/v1
✅ MongoDB connected successfully!
📊 Database: ourdeals
```

### You might see (these are OK):
```
⚠️  Notification worker disabled (Redis not available)
Failed to init Firebase (optional)
Failed to init SMS (optional)
```

**Keep this window open!** The backend needs to stay running.

---

## Step 3: Run Flutter App (1 minute)

Open a NEW Command Prompt window:

```bash
cd onmint
flutter run -d chrome
```

The app will open in Chrome browser.

---

## 🎉 You're Ready!

### Test the App:

1. **Register Account:**
   - Click "Create Account"
   - Fill in details
   - Select role: User, Vendor, or Admin
   - Click Register

2. **Login:**
   - Enter email and password
   - Click Login

3. **Admin Dashboard:**
   - Login with Admin role
   - See last 10 logins
   - View database connection info
   - Access 10 admin modules

4. **User Home:**
   - Login with User role
   - Browse services (Medicine, Doctor, Nurse, Lab, Ambulance)
   - View featured medicines
   - See top doctors

---

## ⚠️ Troubleshooting

### Backend won't start?
- Read `BACKEND_STATUS.md`
- Check `MONGODB_TROUBLESHOOTING.md`

### Flutter app shows "Connection timeout"?
- Make sure backend is running (Step 2)
- Check backend shows: `✅ Server is running on http://localhost:5000`

### "Account not found" error?
- Create account first (Register)
- Then login with same credentials

---

## 📁 Important Files

- `START_BACKEND.bat` - Start backend server
- `TEST_MONGODB.bat` - Test MongoDB connection
- `BACKEND_STATUS.md` - Backend setup status
- `MONGODB_TROUBLESHOOTING.md` - Connection issues help
- `.env` - Backend configuration (in backend_onmint/OurDeals-healthCare/)

---

## 🆘 Need Help?

1. Check error messages carefully
2. Read the troubleshooting guides
3. Make sure MongoDB Atlas Network Access is configured
4. Try VPN if on restricted network
5. Use mobile hotspot if WiFi blocks MongoDB

---

## ✅ Success Checklist

- [ ] MongoDB connection test passes
- [ ] Backend starts without errors
- [ ] Backend shows "MongoDB connected successfully"
- [ ] Flutter app opens in browser
- [ ] Can register new account
- [ ] Can login successfully
- [ ] Admin dashboard shows data
- [ ] User home screen shows services

---

**That's it! You're all set to develop your healthcare app! 🎊**
