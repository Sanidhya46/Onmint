const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');
const bcrypt = require('bcryptjs');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  email: {
    type: DataTypes.STRING,
    unique: true,
    allowNull: false,
    validate: { isEmail: true }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  role: {
    type: DataTypes.ENUM('patient', 'doctor', 'nurse', 'ambulance', 'pharmacist', 'pathology', 'admin'),
    allowNull: false,
    defaultValue: 'patient'
  },
  firstName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  lastName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: false
  },
  city: DataTypes.STRING,
  state: DataTypes.STRING,
  pincode: DataTypes.STRING,
  latitude: DataTypes.DOUBLE,
  longitude: DataTypes.DOUBLE,
  status: {
    type: DataTypes.ENUM('pending', 'approved', 'rejected', 'blocked'),
    defaultValue: 'approved'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  deviceToken: DataTypes.STRING,
  
  // Doctor specific
  specialization: DataTypes.STRING,
  qualifications: DataTypes.ARRAY(DataTypes.STRING),
  experience: DataTypes.INTEGER,
  consultationFee: DataTypes.DECIMAL(10, 2),
  licenseNumber: DataTypes.STRING,
  languages: DataTypes.ARRAY(DataTypes.STRING),
  availability: DataTypes.JSONB,
  
  // Nurse specific
  nursingLicense: DataTypes.STRING,
  servicesOffered: DataTypes.ARRAY(DataTypes.STRING),
  
  // Ambulance specific
  driverName: DataTypes.STRING,
  driverLicense: DataTypes.STRING,
  vehicleNumber: DataTypes.STRING,
  vehicleType: DataTypes.ENUM('basic', 'advanced', 'icu'),
  equipmentAvailable: DataTypes.ARRAY(DataTypes.STRING),
  isAvailable: DataTypes.BOOLEAN,
  
  // Pharmacist specific
  pharmacyName: DataTypes.STRING,
  pharmacyLicense: DataTypes.STRING,
  
  // Pathology specific
  labName: DataTypes.STRING,
  labLicense: DataTypes.STRING,
  testsOffered: DataTypes.ARRAY(DataTypes.STRING),
  
  // Rating
  rating: {
    type: DataTypes.DECIMAL(2, 1),
    defaultValue: 0
  },
  totalRatings: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  }
}, {
  tableName: 'users',
  indexes: [
    { fields: ['email'] },
    { fields: ['role'] },
    { fields: ['status'] },
    { fields: ['latitude', 'longitude'] }
  ]
});

// Hash password before save
User.beforeCreate(async (user) => {
  if (user.password) {
    user.password = await bcrypt.hash(user.password, 10);
  }
});

User.beforeUpdate(async (user) => {
  if (user.changed('password')) {
    user.password = await bcrypt.hash(user.password, 10);
  }
});

// Instance method to check password
User.prototype.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

module.exports = User;
