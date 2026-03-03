const express = require('express');
const router = express.Router();
const { Medicine, Booking, User } = require('../models');
const { protect, authorize } = require('../middleware/auth');
const { Op } = require('sequelize');

router.get('/medicines', async (req, res) => {
  try {
    const medicines = await Medicine.findAll({
      where: { stock: { [Op.gt]: 0 } },
      order: [['name', 'ASC']]
    });
    
    res.json({ success: true, data: medicines });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch medicines' });
  }
});

router.get('/orders', protect, authorize('pharmacist'), async (req, res) => {
  try {
    const orders = await Booking.findAll({
      where: { providerId: req.user.id, serviceType: 'pharmacy' },
      include: [{ model: User, as: 'patient', attributes: ['id', 'firstName', 'lastName', 'phone'] }],
      order: [['createdAt', 'DESC']]
    });
    
    res.json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Failed to fetch orders' });
  }
});

module.exports = router;
