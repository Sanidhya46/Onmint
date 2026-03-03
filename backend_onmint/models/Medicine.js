const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Medicine = sequelize.define('Medicine', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  manufacturer: DataTypes.STRING,
  category: DataTypes.STRING,
  price: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  stock: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  prescriptionRequired: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  description: DataTypes.TEXT,
  sideEffects: DataTypes.TEXT,
  dosage: DataTypes.STRING,
  pharmacistId: {
    type: DataTypes.UUID,
    references: { model: 'users', key: 'id' }
  }
}, {
  tableName: 'medicines'
});

module.exports = Medicine;
