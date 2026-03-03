const User = require('./User');
const Booking = require('./Booking');
const Prescription = require('./Prescription');
const Medicine = require('./Medicine');
const Notification = require('./Notification');

// Define associations
User.hasMany(Booking, { as: 'patientBookings', foreignKey: 'patientId' });
User.hasMany(Booking, { as: 'providerBookings', foreignKey: 'providerId' });
Booking.belongsTo(User, { as: 'patient', foreignKey: 'patientId' });
Booking.belongsTo(User, { as: 'provider', foreignKey: 'providerId' });

User.hasMany(Prescription, { as: 'doctorPrescriptions', foreignKey: 'doctorId' });
User.hasMany(Prescription, { as: 'patientPrescriptions', foreignKey: 'patientId' });
Prescription.belongsTo(User, { as: 'doctor', foreignKey: 'doctorId' });
Prescription.belongsTo(User, { as: 'patient', foreignKey: 'patientId' });

Booking.hasOne(Prescription, { foreignKey: 'bookingId' });
Prescription.belongsTo(Booking, { foreignKey: 'bookingId' });

User.hasMany(Notification, { foreignKey: 'userId' });
Notification.belongsTo(User, { foreignKey: 'userId' });

module.exports = {
  User,
  Booking,
  Prescription,
  Medicine,
  Notification
};
