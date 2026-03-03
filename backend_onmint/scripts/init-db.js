const { sequelize } = require('../config/database');
const { User, Booking, Prescription, Medicine, Notification } = require('../models');

async function initializeDatabase() {
  try {
    // Sync all models (create tables if they don't exist)
    await sequelize.sync({ alter: true });
    
    console.log('✅ All tables created/updated successfully');
    
    // Create default admin if doesn't exist
    const adminExists = await User.findOne({ where: { email: 'admin@onmint.com' } });
    
    if (!adminExists) {
      await User.create({
        email: 'admin@onmint.com',
        password: 'Admin@123',
        role: 'admin',
        firstName: 'Super',
        lastName: 'Admin',
        phone: '9999999999',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400001',
        status: 'approved'
      });
      console.log('✅ Default admin created: admin@onmint.com / Admin@123');
    }
    
    return true;
  } catch (error) {
    console.error('❌ Database initialization failed:', error);
    throw error;
  }
}

module.exports = { initializeDatabase };

// Run if called directly
if (require.main === module) {
  initializeDatabase()
    .then(() => {
      console.log('✅ Database initialized successfully');
      process.exit(0);
    })
    .catch((error) => {
      console.error('❌ Failed:', error);
      process.exit(1);
    });
}
