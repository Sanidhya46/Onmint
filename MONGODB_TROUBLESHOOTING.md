# MongoDB Atlas Connection Troubleshooting Guide

## Current Status
Your MongoDB Atlas connection string is configured in:
```
onmint/backend_onmint/OurDeals-healthCare/.env
```

Connection String:
```
mongodb+srv://ourdealsofficial_db_user:Mnx6PcuYLvLW3MTc@cluster0.rfpvlcy.mongodb.net/ourdeals
```

## Quick Test

Run this command to test your connection:
```bash
cd onmint
TEST_MONGODB.bat
```

Or manually:
```bash
cd backend_onmint/OurDeals-healthCare
node test-connection.js
```

## Common Errors and Solutions

### Error: `querySrv ECONNREFUSED` or `ENOTFOUND`

This is a DNS resolution issue. Try these solutions:

#### Solution 1: Check Network Access in MongoDB Atlas
1. Go to https://cloud.mongodb.com/
2. Click on your cluster
3. Click "Network Access" in the left sidebar
4. Make sure you have added `0.0.0.0/0` (Allow access from anywhere)
5. Wait 2-3 minutes for changes to propagate

#### Solution 2: Check Your Internet Connection
- Make sure you have a stable internet connection
- Try opening https://cloud.mongodb.com/ in your browser
- If it doesn't load, check your network

#### Solution 3: Try a VPN
Some networks (corporate, school, public WiFi) block MongoDB Atlas connections:
- Try using a VPN
- Or use your mobile hotspot

#### Solution 4: Firewall/Antivirus
- Temporarily disable firewall/antivirus
- Check if Windows Defender is blocking Node.js

### Error: `Authentication failed`

Your username or password is incorrect:

1. Go to MongoDB Atlas → Database Access
2. Verify username: `ourdealsofficial_db_user`
3. Reset password if needed
4. Update `.env` file with new password

### Error: `connect ECONNREFUSED 127.0.0.1:27017`

This means it's trying to connect to LOCAL MongoDB instead of Atlas:

1. Check your `.env` file
2. Make sure `MONGODB_URI` starts with `mongodb+srv://`
3. NOT `mongodb://localhost` or `mongodb://127.0.0.1`

## Verify Your MongoDB Atlas Setup

### Step 1: Check Database User
1. Go to https://cloud.mongodb.com/
2. Click "Database Access"
3. Verify user exists: `ourdealsofficial_db_user`
4. Make sure it has "Read and write to any database" role

### Step 2: Check Network Access
1. Click "Network Access"
2. You should see: `0.0.0.0/0` (Allow access from anywhere)
3. If not, click "Add IP Address" → "Allow Access from Anywhere"

### Step 3: Get Connection String
1. Click "Database" (Clusters)
2. Click "Connect" on your cluster
3. Choose "Connect your application"
4. Copy the connection string
5. Replace `<password>` with your actual password
6. Add `/ourdeals` before the `?` to specify database name

Example:
```
mongodb+srv://username:password@cluster0.rfpvlcy.mongodb.net/ourdeals?retryWrites=true&w=majority
```

## Alternative: Use Local MongoDB

If Atlas continues to fail, you can install MongoDB locally:

### Install MongoDB Community Edition
1. Download from: https://www.mongodb.com/try/download/community
2. Install with default settings
3. MongoDB will run on `localhost:27017`

### Update .env file
```env
MONGODB_URI=mongodb://localhost:27017/ourdeals
```

### Start MongoDB Service
```bash
# Windows - Run as Administrator
net start MongoDB
```

## Still Having Issues?

### Check Backend Logs
When you run `npm run dev`, look for:
- ✅ "MongoDB connected successfully" = Working!
- ❌ "Failed to connect to MongoDB" = Not working

### Enable Debug Mode
Add this to your `.env`:
```env
DEBUG=mongoose:*
```

This will show detailed connection logs.

## Redis Errors (Optional)

You might see Redis errors like:
```
Redis connection error: connect ECONNREFUSED 127.0.0.1:6379
```

**This is OK!** Redis is optional. The backend will work without it.

To disable Redis errors, the code already handles them gracefully.

## Success Indicators

When backend starts successfully, you should see:
```
✅ Server is running on http://localhost:5000
📱 Flutter app should connect to: http://localhost:5000/api/v1
MongoDB connected successfully
```

## Contact Support

If none of these solutions work:
1. Share the exact error message
2. Share your MongoDB Atlas cluster region
3. Try creating a new cluster in a different region
