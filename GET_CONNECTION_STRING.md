# Get Correct MongoDB Atlas Connection String

## The Problem
Your network is blocking the SRV DNS lookup for MongoDB Atlas.

## The Solution
Get the STANDARD (non-SRV) connection string from MongoDB Atlas.

## Steps:

### 1. Go to MongoDB Atlas
Open: https://cloud.mongodb.com/

### 2. Login
Use your MongoDB Atlas account credentials

### 3. Select Your Cluster
Click on your cluster (cluster0)

### 4. Click "Connect"
Big green "Connect" button on your cluster

### 5. Choose "Connect your application"
(Not "Connect with MongoDB Compass" or "Connect with MongoDB Shell")

### 6. Select Driver
- Driver: **Node.js**
- Version: **5.5 or later**

### 7. Copy Connection String
You'll see TWO options:

**Option A: SRV Connection String (Currently NOT working)**
```
mongodb+srv://username:password@cluster0.rfpvlcy.mongodb.net/
```

**Option B: Standard Connection String (This is what we need!)**
Click "Use a different connection method" or look for standard format:
```
mongodb://username:password@host1:27017,host2:27017,host3:27017/?options
```

### 8. Copy the FULL Standard Connection String
It should look like:
```
mongodb://ourdealsofficial_db_user:Mnx6PcuYLvLW3MTc@cluster0-shard-00-00.rfpvlcy.mongodb.net:27017,cluster0-shard-00-01.rfpvlcy.mongodb.net:27017,cluster0-shard-00-02.rfpvlcy.mongodb.net:27017/?ssl=true&replicaSet=atlas-XXXXX-shard-0&authSource=admin&retryWrites=true&w=majority
```

### 9. Add Database Name
Add `/ourdeals` before the `?`:
```
mongodb://ourdealsofficial_db_user:Mnx6PcuYLvLW3MTc@cluster0-shard-00-00.rfpvlcy.mongodb.net:27017,cluster0-shard-00-01.rfpvlcy.mongodb.net:27017,cluster0-shard-00-02.rfpvlcy.mongodb.net:27017/ourdeals?ssl=true&replicaSet=atlas-XXXXX-shard-0&authSource=admin&retryWrites=true&w=majority
```

### 10. Update .env File
Open: `backend_onmint/OurDeals-healthCare/.env`

Replace the MONGODB_URI line with your new connection string.

### 11. Test Again
```bash
node test-connection.js
```

---

## Alternative: Use Local MongoDB

If Atlas continues to fail, install MongoDB locally:

### Install MongoDB Community Edition
1. Download: https://www.mongodb.com/try/download/community
2. Install with default settings
3. MongoDB will run on localhost:27017

### Update .env
```env
MONGODB_URI=mongodb://localhost:27017/ourdeals
```

### Start MongoDB
```bash
# Windows - Run Command Prompt as Administrator
net start MongoDB
```

---

## Quick Network Test

Test if your network can reach MongoDB Atlas:

```bash
# Test DNS resolution
nslookup cluster0.rfpvlcy.mongodb.net

# Test connectivity
ping cluster0.rfpvlcy.mongodb.net
```

If these fail, your network is blocking MongoDB Atlas.

**Solutions:**
1. Use VPN
2. Use mobile hotspot
3. Use different network
4. Install MongoDB locally
