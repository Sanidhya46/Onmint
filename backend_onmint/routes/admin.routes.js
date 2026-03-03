const express = require('express');
const router = express.Router();
const { User, Booking, Notification } = require('../models');
const { protect, authorize } = require('../middleware/auth');
const { Op } = require('sequelize');

const emitUpdate = (req, event, data) => {
  const io = req.app.get('io');
  if (io) io.emit(event, data);
};

// @route   GET /api/v1/admin/dashboard
// @desc    Get admin dashboard stats
// @access  Private (Admin)
router.get('/dashboard', protect, authorize('admin'), async (req, res) => {
  try {
    const totalUsers = await User.count();
    const totalPatients = await User.count({ where: { role: 'patient' } });
    const totalDoctors = await User.count({ where: { role: 'doctor' } });
    const totalBookings = await Booking.count();
    const pendingApprovals = await User.count({ where: { status: 'pending' } });
    
    const recentBookings = await Booking.findAll({
      limit: 10,
      order: [['createdAt', 'DESC']],
      include: [
        { model: User, as: 'patient', attributes: ['firstName', 'lastName'] },
        { model: User, as: 'provider', attributes: ['firstName', 'lastName', 'role'] }
      ]
    });
    
    res.json({
      success: true,
      data: {
        totalUsers,
        totalPatients,
        totalDoctors,
        totalBookings,
        pendingApprovals,
        recentBookings
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch dashboard data'
    });
  }
});

// @route   GET /api/v1/admin/users
// @desc    Get all users
// @access  Private (Admin)
router.get('/users', protect, authorize('admin'), async (req, res) => {
  try {
    const { role, status, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    
    const where = {};
    if (role) where.role = role;
    if (status) where.status = status;
    
    const { count, rows } = await User.findAndCountAll({
      where,
      attributes: { exclude: ['password'] },
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
    res.status(500).json({
      success: false,
      message: 'Failed to fetch users'
    });
  }
});

// @route   GET /api/v1/admin/approvals/pending
// @desc    Get pending provider approvals
// @access  Private (Admin)
router.get('/approvals/pending', protect, authorize('admin'), async (req, res) => {
  try {
    const pendingProviders = await User.findAll({
      where: {
        status: 'pending',
        role: { [Op.in]: ['doctor', 'nurse', 'ambulance', 'pharmacist', 'pathology'] }
      },
      attributes: { exclude: ['password'] },
      order: [['createdAt', 'ASC']]
    });
    
    res.json({
      success: true,
      count: pendingProviders.length,
      data: pendingProviders
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch pending approvals'
    });
  }
});

// @route   POST /api/v1/admin/providers/:id/approve
// @desc    Approve provider
// @access  Private (Admin)
router.post('/providers/:id/approve', protect, authorize('admin'), async (req, res) => {
  try {
    const provider = await User.findByPk(req.params.id);
    
    if (!provider) {
      return res.status(404).json({
        success: false,
        message: 'Provider not found'
      });
    }
    
    await provider.update({ status: 'approved' });
    
    // Notify provider
    await Notification.create({
      userId: provider.id,
      title: 'Account Approved',
      message: 'Your account has been approved by admin',
      type: 'system'
    });
    
    // Real-time update
    emitUpdate(req, 'provider_approved', {
      providerId: provider.id
    });
    
    res.json({
      success: true,
      message: 'Provider approved successfully',
      data: provider
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to approve provider'
    });
  }
});

// @route   POST /api/v1/admin/providers/:id/reject
// @desc    Reject provider
// @access  Private (Admin)
router.post('/providers/:id/reject', protect, authorize('admin'), async (req, res) => {
  try {
    const provider = await User.findByPk(req.params.id);
    
    if (!provider) {
      return res.status(404).json({
        success: false,
        message: 'Provider not found'
      });
    }
    
    await provider.update({ status: 'rejected' });
    
    // Notify provider
    await Notification.create({
      userId: provider.id,
      title: 'Account Rejected',
      message: 'Your account application was not approved',
      type: 'system'
    });
    
    res.json({
      success: true,
      message: 'Provider rejected',
      data: provider
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to reject provider'
    });
  }
});

// @route   POST /api/v1/admin/users/:id/block
// @desc    Block user
// @access  Private (Admin)
router.post('/users/:id/block', protect, authorize('admin'), async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    await user.update({ isActive: false, status: 'blocked' });
    
    res.json({
      success: true,
      message: 'User blocked successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to block user'
    });
  }
});

// @route   POST /api/v1/admin/users/:id/unblock
// @desc    Unblock user
// @access  Private (Admin)
router.post('/users/:id/unblock', protect, authorize('admin'), async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    await user.update({ isActive: true, status: 'approved' });
    
    res.json({
      success: true,
      message: 'User unblocked successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to unblock user'
    });
  }
});

// @route   GET /api/v1/admin/bookings
// @desc    Get all bookings
// @access  Private (Admin)
router.get('/bookings', protect, authorize('admin'), async (req, res) => {
  try {
    const { page = 1, limit = 20, status, serviceType } = req.query;
    const offset = (page - 1) * limit;
    
    const where = {};
    if (status) where.status = status;
    if (serviceType) where.serviceType = serviceType;
    
    const { count, rows } = await Booking.findAndCountAll({
      where,
      include: [
        { model: User, as: 'patient', attributes: ['firstName', 'lastName', 'phone'] },
        { model: User, as: 'provider', attributes: ['firstName', 'lastName', 'role'] }
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
    res.status(500).json({
      success: false,
      message: 'Failed to fetch bookings'
    });
  }
});

module.exports = router;
