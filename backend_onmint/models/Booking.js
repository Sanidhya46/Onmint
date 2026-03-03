const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Booking = sequelize.define('Booking', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  patientId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'users', key: 'id' }
  },
  providerId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'users', key: 'id' }
  },
  serviceType: {
    type: DataTypes.ENUM('doctor', 'nurse', 'ambulance', 'pharmacy', 'pathology'),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'rejected', 'in_progress', 'completed', 'cancelled'),
    defaultValue: 'pending'
  },
  scheduledTime: DataTypes.DATE,
  completedTime: DataTypes.DATE,
  
  // Booking details
  symptoms: DataTypes.TEXT,
  notes: DataTypes.TEXT,
  prescriptionId: {
    type: DataTypes.UUID,
    references: { model: 'prescriptions', key: 'id' }
  },
  
  // Location for ambulance/home visits
  pickupLatitude: DataTypes.DOUBLE,
  pickupLongitude: DataTypes.DOUBLE,
  dropLatitude: DataTypes.DOUBLE,
  dropLongitude: DataTypes.DOUBLE,
  
  // Payment
  amount: DataTypes.DECIMAL(10, 2),
  paymentStatus: {
    type: DataTypes.ENUM('pending', 'paid', 'refunded'),
    defaultValue: 'pending'
  },
  
  // Rating
  rating: DataTypes.INTEGER,
  review: DataTypes.TEXT,
  
  // Emergency flag
  isEmergency: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  tableName: 'bookings',
  indexes: [
    { fields: ['patientId'] },
    { fields: ['providerId'] },
    { fields: ['status'] },
    { fields: ['serviceType'] },
    { fields: ['scheduledTime'] }
  ]
});

module.exports = Booking;
