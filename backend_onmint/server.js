require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const { sequelize } = require('./config/database');
const { initializeDatabase } = require('./scripts/init-db');

const app = express();
const server = http.createServer(app);

// Socket.IO setup for real-time updates
const io = socketIo(server, {
  cors: {
    origin: process.env.SOCKET_IO_CORS.split(','),
    methods: ['GET', 'POST']
  }
});

// Make io accessible to routes
app.set('io', io);

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN.split(','),
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Onmint Healthcare API is running',
    database: sequelize.authenticate() ? 'Connected' : 'Disconnected',
    timestamp: new Date().toISOString()
  });
});

// API Routes
app.use('/api/v1/auth', require('./routes/auth.routes'));
app.use('/api/v1/patient', require('./routes/patient.routes'));
app.use('/api/v1/doctor', require('./routes/doctor.routes'));
app.use('/api/v1/nurse', require('./routes/nurse.routes'));
app.use('/api/v1/ambulance', require('./routes/ambulance.routes'));
app.use('/api/v1/pharmacist', require('./routes/pharmacist.routes'));
app.use('/api/v1/pathology', require('./routes/pathology.routes'));
app.use('/api/v1/admin', require('./routes/admin.routes'));

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log(`✅ Client connected: ${socket.id}`);

  // Join room based on user ID
  socket.on('join', (userId) => {
    socket.join(`user_${userId}`);
    console.log(`👤 User ${userId} joined their room`);
  });

  // Join room based on role
  socket.on('join_role', (role) => {
    socket.join(`role_${role}`);
    console.log(`👥 Joined ${role} room`);
  });

  socket.on('disconnect', () => {
    console.log(`❌ Client disconnected: ${socket.id}`);
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('❌ Error:', err);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Start server
const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    console.log('🔄 Connecting to PostgreSQL...');
    
    // Try to connect, if database doesn't exist, create it
    try {
      await sequelize.authenticate();
      console.log('✅ PostgreSQL connected successfully!');
    } catch (error) {
      if (error.message.includes('does not exist')) {
        console.log('📝 Database does not exist, creating it...');
        const { Client } = require('pg');
        const client = new Client({
          host: process.env.DB_HOST,
          port: process.env.DB_PORT,
          user: process.env.DB_USER,
          password: process.env.DB_PASSWORD,
          database: 'postgres' // Connect to default database
        });
        await client.connect();
        await client.query(`CREATE DATABASE ${process.env.DB_NAME}`);
        await client.end();
        console.log('✅ Database created!');
        await sequelize.authenticate();
      } else {
        throw error;
      }
    }
    
    console.log(`📊 Database: ${process.env.DB_NAME}`);

    // Initialize database (create tables)
    console.log('🔄 Initializing database schema...');
    await initializeDatabase();
    console.log('✅ Database schema ready!');

    server.listen(PORT, () => {
      console.log('\n╔════════════════════════════════════════════════════════╗');
      console.log('║                                                        ║');
      console.log('║        🏥 ONMINT HEALTHCARE API SERVER                ║');
      console.log('║                                                        ║');
      console.log('╚════════════════════════════════════════════════════════╝\n');
      console.log(`✅ Server running on: http://localhost:${PORT}`);
      console.log(`📱 User App connects to: http://localhost:${PORT}/api/v1`);
      console.log(`🏪 Vendor App connects to: http://localhost:${PORT}/api/v1`);
      console.log(`👑 Admin App connects to: http://localhost:${PORT}/api/v1`);
      console.log(`🔌 WebSocket ready for real-time updates`);
      console.log(`\n📖 API Documentation: http://localhost:${PORT}/health\n`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error.message);
    console.error('\n💡 Troubleshooting:');
    console.error('1. Make sure PostgreSQL is installed and running');
    console.error('2. Check your .env file has correct database credentials');
    console.error('3. Run: psql -U postgres -c "CREATE DATABASE onmint_healthcare;"');
    console.error('4. Read POSTGRESQL_SETUP.md for detailed instructions\n');
    process.exit(1);
  }
}

startServer();

module.exports = { app, io };
