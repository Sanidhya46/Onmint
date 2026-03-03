const express = require('express');
const router = express.Router();
const { Booking, User } = require('../models');
const { protect, authorize } = require('../middleware/auth');

router.get('/bookings', protect, authorize('pathology'), async (req, res) => {
  try {
    const bookings = await Booking.findAll({
      where: { providerId: req.user.id, serviceType: 'pathology' },
      include: [{ model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }],
      order: [['createdAt', 'DESC']]
    });
    
    res.json({ success: true, data: bookings });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch bookings' });
  }
});

module.exports = router;
