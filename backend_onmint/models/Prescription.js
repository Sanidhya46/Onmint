const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Prescription = sequelize.define('Prescription', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  bookingId: {
    type: DataTypes.UUID,
    references: { model: 'bookings', key: 'id' }
  },
  doctorId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'users', key: 'id' }
  },
  patientId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'users', key: 'id' }
  },
  medicines: {
    type: DataTypes.JSONB,
    defaultValue: []
  },
  tests: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  diagnosis: DataTypes.TEXT,
  notes: DataTypes.TEXT,
  followUpDate: DataTypes.DATE
}, {
  tableName: 'prescriptions'
});

module.exports = Prescription;
