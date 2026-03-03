const express = require('express');
const router = express.Router();
const { Booking, User, Notification } = require('../models');
const { protect, authorize } = require('../middleware/auth');

const emitUpdate = (req, event, data) => {
  const io = req.app.get('io');
  if (io) io.emit(event, data);
};

router.get('/requests', protect, authorize('nurse'), async (req, res) => {
  try {
    const bookings = await Booking.findAll({
      where: { providerId: req.user.id, serviceType: 'nurse' },
      include: [{ model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }],
      order: [['createdAt', 'DESC']]
    });
    
    res.json({ success: true, data: bookings });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch requests' });
  }
});

router.post('/requests/:id/accept', protect, authorize('nurse'), async (req, res) => {
  try {
    const booking = await Booking.findOne({
      where: { id: req.params.id, providerId: req.user.id }
    });
    
    if (!booking) {
      return res.status(404).json({ success: false, message: 'Request not found' });
    }
    
    await booking.update({ status: 'accepted' });
    
    await Notification.create({
      userId: booking.patientId,
      title: 'Service Accepted',
      message: `Nurse ${req.user.firstName} accepted your request`,
      type: 'booking',
      data: { bookingId: booking.id }
    });
    
    emitUpdate(req, 'booking_accepted', { patientId: booking.patientId, bookingId: booking.id });
    
    res.json({ success: true, data: booking });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to accept request' });
  }
});

module.exports = router;
