const express = require('express');
const router = express.Router();
const { User, Booking, Prescription, Notification } = require('../models');
const { protect, authorize } = require('../middleware/auth');

const emitUpdate = (req, event, data) => {
  const io = req.app.get('io');
  if (io) io.emit(event, data);
};

// @route   GET /api/v1/doctor/appointments
// @desc    Get doctor appointments
// @access  Private (Doctor)
router.get('/appointments', protect, authorize('doctor'), async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;
    
    const where = { providerId: req.user.id, serviceType: 'doctor' };
    if (status) where.status = status;
    
    const { count, rows } = await Booking.findAndCountAll({
      where,
      include: [
        { model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }
      ],
      order: [['scheduledTime', 'ASC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
    
    res.json({
      success: true,
      count,
      data: rows
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch appointments'
    });
  }
});

// @route   POST /api/v1/doctor/appointments/:id/accept
// @desc    Accept appointment
// @access  Private (Doctor)
router.post('/appointments/:id/accept', protect, authorize('doctor'), async (req, res) => {
  try {
    const booking = await Booking.findOne({
      where: {
        id: req.params.id,
        providerId: req.user.id
      }
    });
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }
    
    await booking.update({ status: 'accepted' });
    
    // Notify patient
    await Notification.create({
      userId: booking.patientId,
      title: 'Appointment Accepted',
      message: `Dr. ${req.user.firstName} ${req.user.lastName} accepted your appointment`,
      type: 'booking',
      data: { bookingId: booking.id }
    });
    
    // Real-time update to patient
    emitUpdate(req, 'booking_accepted', {
      patientId: booking.patientId,
      bookingId: booking.id,
      booking
    });
    
    res.json({
      success: true,
      message: 'Appointment accepted',
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to accept appointment'
    });
  }
});

// @route   POST /api/v1/doctor/appointments/:id/reject
// @desc    Reject appointment
// @access  Private (Doctor)
router.post('/appointments/:id/reject', protect, authorize('doctor'), async (req, res) => {
  try {
    const booking = await Booking.findOne({
      where: {
        id: req.params.id,
        providerId: req.user.id
      }
    });
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Appointment not found'
      });
    }
    
    await booking.update({ status: 'rejected' });
    
    // Notify patient
    await Notification.create({
      userId: booking.patientId,
      title: 'Appointment Rejected',
      message: `Your appointment request was not accepted`,
      type: 'booking',
      data: { bookingId: booking.id }
    });
    
    // Real-time update
    emitUpdate(req, 'booking_rejected', {
      patientId: booking.patientId,
      bookingId: booking.id
    });
    
    res.json({
      success: true,
      message: 'Appointment rejected',
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to reject appointment'
    });
  }
});

// @route   POST /api/v1/doctor/prescriptions
// @desc    Create prescription
// @access  Private (Doctor)
router.post('/prescriptions', protect, authorize('doctor'), async (req, res) => {
  try {
    const { bookingId, patientId, medicines, tests, diagnosis, notes, followUpDate } = req.body;
    
    const prescription = await Prescription.create({
      bookingId,
      doctorId: req.user.id,
      patientId,
      medicines,
      tests,
      diagnosis,
      notes,
      followUpDate
    });
    
    // Update booking
    await Booking.update(
      { prescriptionId: prescription.id, status: 'completed' },
      { where: { id: bookingId } }
    );
    
    // Notify patient
    await Notification.create({
      userId: patientId,
      title: 'Prescription Ready',
      message: 'Your prescription is ready to view',
      type: 'booking',
      data: { prescriptionId: prescription.id }
    });
    
    // Real-time update
    emitUpdate(req, 'prescription_created', {
      patientId,
      prescriptionId: prescription.id
    });
    
    res.status(201).json({
      success: true,
      message: 'Prescription created successfully',
      data: prescription
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to create prescription'
    });
  }
});

// @route   GET /api/v1/doctor/dashboard
// @desc    Get doctor dashboard stats
// @access  Private (Doctor)
router.get('/dashboard', protect, authorize('doctor'), async (req, res) => {
  try {
    const { Op } = require('sequelize');
    
    const totalAppointments = await Booking.count({
      where: { providerId: req.user.id, serviceType: 'doctor' }
    });
    
    const pendingAppointments = await Booking.count({
      where: { providerId: req.user.id, serviceType: 'doctor', status: 'pending' }
    });
    
    const completedAppointments = await Booking.count({
      where: { providerId: req.user.id, serviceType: 'doctor', status: 'completed' }
    });
    
    const todayAppointments = await Booking.findAll({
      where: {
        providerId: req.user.id,
        serviceType: 'doctor',
        scheduledTime: {
          [Op.gte]: new Date().setHours(0, 0, 0, 0),
          [Op.lt]: new Date().setHours(23, 59, 59, 999)
        }
      },
      include: [
        { model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }
      ]
    });
    
    res.json({
      success: true,
      data: {
        totalAppointments,
        pendingAppointments,
        completedAppointments,
        todayAppointments,
        rating: req.user.rating,
        totalRatings: req.user.totalRatings
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch dashboard data'
    });
  }
});

module.exports = router;
