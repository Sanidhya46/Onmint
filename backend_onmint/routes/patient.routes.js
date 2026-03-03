const express = require('express');
const router = express.Router();
const { User, Booking, Notification } = require('../models');
const { protect, authorize } = require('../middleware/auth');
const { Op } = require('sequelize');
const { sequelize } = require('../config/database');

// Helper function to emit real-time updates
const emitUpdate = (req, event, data) => {
  const io = req.app.get('io');
  if (io) {
    io.emit(event, data);
  }
};

// @route   GET /api/v1/patient/services/nearby
// @desc    Get nearby service providers
// @access  Private (Patient)
router.get('/services/nearby', protect, authorize('patient'), async (req, res) => {
  try {
    const { serviceType, latitude, longitude, radius = 10 } = req.query;
    
    if (!latitude || !longitude) {
      return res.status(400).json({
        success: false,
        message: 'Latitude and longitude are required'
      });
    }

    const lat = parseFloat(latitude);
    const lon = parseFloat(longitude);
    const rad = parseFloat(radius);
    
    // Calculate distance using Haversine formula
    const providers = await User.findAll({
      where: {
        role: serviceType,
        status: 'approved',
        isActive: true,
        latitude: { [Op.ne]: null },
        longitude: { [Op.ne]: null }
      },
      attributes: {
        include: [
          [
            sequelize.literal(`
              6371 * acos(
                cos(radians(${lat})) * 
                cos(radians(latitude)) * 
                cos(radians(longitude) - radians(${lon})) + 
                sin(radians(${lat})) * 
                sin(radians(latitude))
              )
            `),
            'distance'
          ]
        ],
        exclude: ['password']
      },
      having: sequelize.where(
        sequelize.literal(`
          6371 * acos(
            cos(radians(${lat})) * 
            cos(radians(latitude)) * 
            cos(radians(longitude) - radians(${lon})) + 
            sin(radians(${lat})) * 
            sin(radians(latitude))
          )
        `),
        '<=',
        rad
      ),
      order: [[sequelize.literal('distance'), 'ASC']],
      limit: 20
    });
    
    res.json({
      success: true,
      count: providers.length,
      data: providers
    });
  } catch (error) {
    console.error('Nearby services error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch nearby services'
    });
  }
});

// @route   POST /api/v1/patient/bookings
// @desc    Create new booking
// @access  Private (Patient)
router.post('/bookings', protect, authorize('patient'), async (req, res) => {
  try {
    const { serviceType, providerId, scheduledTime, symptoms, notes, isEmergency } = req.body;
    
    // Verify provider exists
    const provider = await User.findByPk(providerId);
    if (!provider) {
      return res.status(404).json({
        success: false,
        message: 'Provider not found'
      });
    }
    
    // Create booking
    const booking = await Booking.create({
      patientId: req.user.id,
      providerId,
      serviceType,
      scheduledTime,
      symptoms,
      notes,
      isEmergency: isEmergency || false,
      status: 'pending'
    });
    
    // Create notification for provider
    await Notification.create({
      userId: providerId,
      title: 'New Booking Request',
      message: `New ${serviceType} booking from ${req.user.firstName} ${req.user.lastName}`,
      type: 'booking',
      data: { bookingId: booking.id }
    });
    
    // Emit real-time update to provider
    emitUpdate(req, 'new_booking', {
      providerId,
      booking: await Booking.findByPk(booking.id, {
        include: [
          { model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }
        ]
      })
    });
    
    res.status(201).json({
      success: true,
      message: 'Booking created successfully',
      data: booking
    });
  } catch (error) {
    console.error('Create booking error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create booking'
    });
  }
});

// @route   GET /api/v1/patient/bookings
// @desc    Get patient bookings
// @access  Private (Patient)
router.get('/bookings', protect, authorize('patient'), async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;
    
    const where = { patientId: req.user.id };
    if (status) where.status = status;
    
    const { count, rows } = await Booking.findAndCountAll({
      where,
      include: [
        { model: User, as: 'provider', attributes: ['id', 'firstName', 'lastName', 'phone', 'specialization'] }
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
    
    res.json({
      success: true,
      count,
      totalPages: Math.ceil(count / limit),
      currentPage: parseInt(page),
      data: rows
    });
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch bookings'
    });
  }
});

// @route   GET /api/v1/patient/bookings/:id
// @desc    Get booking details
// @access  Private (Patient)
router.get('/bookings/:id', protect, authorize('patient'), async (req, res) => {
  try {
    const booking = await Booking.findOne({
      where: {
        id: req.params.id,
        patientId: req.user.id
      },
      include: [
        { model: User, as: 'provider', attributes: { exclude: ['password'] } }
      ]
    });
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }
    
    res.json({
      success: true,
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch booking'
    });
  }
});

// @route   POST /api/v1/patient/bookings/:id/cancel
// @desc    Cancel booking
// @access  Private (Patient)
router.post('/bookings/:id/cancel', protect, authorize('patient'), async (req, res) => {
  try {
    const booking = await Booking.findOne({
      where: {
        id: req.params.id,
        patientId: req.user.id
      }
    });
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }
    
    if (booking.status === 'completed' || booking.status === 'cancelled') {
      return res.status(400).json({
        success: false,
        message: 'Cannot cancel this booking'
      });
    }
    
    await booking.update({ status: 'cancelled' });
    
    // Notify provider
    await Notification.create({
      userId: booking.providerId,
      title: 'Booking Cancelled',
      message: `Booking has been cancelled by patient`,
      type: 'booking',
      data: { bookingId: booking.id }
    });
    
    // Emit real-time update
    emitUpdate(req, 'booking_cancelled', {
      providerId: booking.providerId,
      bookingId: booking.id
    });
    
    res.json({
      success: true,
      message: 'Booking cancelled successfully',
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to cancel booking'
    });
  }
});

// @route   POST /api/v1/patient/bookings/:id/rate
// @desc    Rate booking
// @access  Private (Patient)
router.post('/bookings/:id/rate', protect, authorize('patient'), async (req, res) => {
  try {
    const { rating, review } = req.body;
    
    const booking = await Booking.findOne({
      where: {
        id: req.params.id,
        patientId: req.user.id,
        status: 'completed'
      }
    });
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found or not completed'
      });
    }
    
    await booking.update({ rating, review });
    
    // Update provider rating
    const provider = await User.findByPk(booking.providerId);
    const newTotalRatings = provider.totalRatings + 1;
    const newRating = ((provider.rating * provider.totalRatings) + rating) / newTotalRatings;
    
    await provider.update({
      rating: newRating.toFixed(1),
      totalRatings: newTotalRatings
    });
    
    res.json({
      success: true,
      message: 'Rating submitted successfully',
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to submit rating'
    });
  }
});

// @route   GET /api/v1/patient/notifications
// @desc    Get notifications
// @access  Private (Patient)
router.get('/notifications', protect, authorize('patient'), async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    
    const { count, rows } = await Notification.findAndCountAll({
      where: { userId: req.user.id },
      order: [['createdAt', 'DESC']],
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
      message: 'Failed to fetch notifications'
    });
  }
});

module.exports = router;
