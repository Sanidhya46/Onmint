# Install MongoDB Locally (Fastest Solution)

Since your network is blocking MongoDB Atlas, the fastest solution is to install MongoDB locally on your computer.

## Quick Install (Windows)

### Step 1: Download MongoDB
Go to: https://www.mongodb.com/try/download/community

- Version: Latest (7.0 or higher)
- Platform: Windows
- Package: MSI

Click **Download**

### Step 2: Install MongoDB
1. Run the downloaded `.msi` file
2. Choose **Complete** installation
3. Check **"Install MongoDB as a Service"**
4. Check **"Install MongoDB Compass"** (optional GUI tool)
5. Click **Next** → **Install**
6. Wait for installation to complete

### Step 3: Verify Installation
Open Command Prompt and run:
```bash
mongod --version
```

You should see MongoDB version information.

### Step 4: Start MongoDB Service
MongoDB should start automatically. If not:

```bash
# Run Command Prompt as Administrator
net start MongoDB
```

### Step 5: Update .env File
Open: `backend_onmint/OurDeals-healthCare/.env`

Change the MONGODB_URI line to:
```env
MONGODB_URI=mongodb://localhost:27017/ourdeals
```

### Step 6: Test Connection
```bash
cd backend_onmint/OurDeals-healthCare
node test-connection.js
```

You should see:
```
✅ MongoDB connected successfully!
📊 Database: ourdeals
🌐 Host: localhost
```

### Step 7: Start Backend
```bash
npm run dev
```

You should see:
```
✅ Server is running on http://localhost:5000
✅ MongoDB connected successfully!
```

---

## Alternative: Use MongoDB Compass

If you installed MongoDB Compass (GUI tool):

1. Open MongoDB Compass
2. Connect to: `mongodb://localhost:27017`
3. Create database: `ourdeals`
4. You can view your data visually

---

## Troubleshooting

### MongoDB Service Not Starting?
```bash
# Run as Administrator
net start MongoDB
```

### Port 27017 Already in Use?
Another program is using the port. Restart your computer.

### mongod command not found?
Add MongoDB to PATH:
1. Search "Environment Variables" in Windows
2. Edit "Path" variable
3. Add: `C:\Program Files\MongoDB\Server\7.0\bin`
4. Restart Command Prompt

---

## Advantages of Local MongoDB

✅ No network issues
✅ Faster development (no internet latency)
✅ Works offline
✅ Full control over database
✅ Free and unlimited

## When to Use MongoDB Atlas

- Production deployment
- Team collaboration
- Need cloud backup
- Need global access

For development, local MongoDB is perfect!

---

## Quick Summary

1. Download MongoDB Community: https://www.mongodb.com/try/download/community
2. Install with default settings
3. Update .env: `MONGODB_URI=mongodb://localhost:27017/ourdeals`
4. Test: `node test-connection.js`
5. Start backend: `npm run dev`

**Done! Your backend will work perfectly with local MongoDB.**
