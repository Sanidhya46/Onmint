import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  List<dynamic> _recentLogins = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      // Try to fetch real data from backend
      final response = await _apiService.get('/admin/dashboard');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        setState(() {
          _stats = {
            'totalUsers': data['totalUsers'] ?? 0,
            'totalProviders': data['totalProviders'] ?? 0,
            'activeBookings': data['activeBookings'] ?? 0,
            'completedBookings': data['completedBookings'] ?? 0,
            'emergencyToday': data['emergencyToday'] ?? 0,
            'revenueToday': data['revenueToday'] ?? 0,
            'revenueMonth': data['revenueMonth'] ?? 0,
            'topService': data['topService'] ?? 'Medicine',
          };
          _recentLogins = data['recentLogins'] ?? [];
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Failed to load dashboard data: $e');
      // Fall through to mock data
    }
    
    // Use mock data if API fails (for demo/testing)
    setState(() {
      _stats = {
        'totalUsers': 0,
        'totalProviders': 0,
        'activeBookings': 0,
        'completedBookings': 0,
        'emergencyToday': 0,
        'revenueToday': 0,
        'revenueMonth': 0,
        'topService': 'Medicine',
      };
      _recentLogins = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final menuItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'index': 0},
      {'icon': Icons.people, 'label': 'Users', 'index': 1},
      {'icon': Icons.store, 'label': 'Providers', 'index': 2},
      {'icon': Icons.calendar_today, 'label': 'Bookings', 'index': 3},
      {'icon': Icons.attach_money, 'label': 'Finance', 'index': 4},
      {'icon': Icons.medical_services, 'label': 'Services', 'index': 5},
      {'icon': Icons.location_on, 'label': 'Locations', 'index': 6},
      {'icon': Icons.campaign, 'label': 'Ads', 'index': 7},
      {'icon': Icons.notifications, 'label': 'Notifications', 'index': 8},
      {'icon': Icons.settings, 'label': 'Settings', 'index': 9},
    ];

    return Container(
      width: 250,
      color: AppColors.white,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Row(
              children: [
                const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Onmint Admin',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = _selectedIndex == item['index'];
                
                return ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? AppColors.primary : AppColors.grey,
                  ),
                  title: Text(
                    item['label'] as String,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () {
                    setState(() => _selectedIndex = item['index'] as int);
                  },
                );
              },
            ),
          ),
          
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return _buildUsersManagement();
      default:
        return Center(
          child: Text(
            'Module ${_selectedIndex + 1} - Coming Soon',
            style: const TextStyle(fontSize: 24, color: AppColors.textSecondary),
          ),
        );
    }
  }

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadDashboardData,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Stats Cards
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Users',
                '${_stats['totalUsers'] ?? 0}',
                Icons.people,
                AppColors.primary,
              ),
              _buildStatCard(
                'Total Providers',
                '${_stats['totalProviders'] ?? 0}',
                Icons.store,
                AppColors.secondary,
              ),
              _buildStatCard(
                'Active Bookings',
                '${_stats['activeBookings'] ?? 0}',
                Icons.calendar_today,
                AppColors.accent,
              ),
              _buildStatCard(
                'Emergency Today',
                '${_stats['emergencyToday'] ?? 0}',
                Icons.emergency,
                AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Revenue Cards
          Row(
            children: [
              Expanded(
                child: _buildRevenueCard(
                  'Today\'s Revenue',
                  '₹${_stats['revenueToday'] ?? 0}',
                  '+12%',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRevenueCard(
                  'Monthly Revenue',
                  '₹${_stats['revenueMonth'] ?? 0}',
                  '+25%',
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Logins (Last 10)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Logins (Last 10)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('Live'),
                        backgroundColor: AppColors.success.withOpacity(0.2),
                        avatar: const Icon(Icons.circle, color: AppColors.success, size: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecentLoginsTable(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Database Info
          _buildDatabaseInfo(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.trending_up, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(String title, String value, String change, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLoginsTable() {
    if (_recentLogins.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            const Text(
              'No recent logins yet',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Users will appear here after they register and login',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return Table(
      border: TableBorder.all(color: AppColors.greyLight),
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(color: AppColors.greyLight.withOpacity(0.3)),
          children: const [
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        // Data Rows
        ..._recentLogins.map((login) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(login['name'] ?? 'Unknown'),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(login['email'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Chip(
                  label: Text(login['role'] ?? 'user', style: const TextStyle(fontSize: 12)),
                  backgroundColor: _getRoleColor(login['role'] ?? 'user').withOpacity(0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(login['time'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.success, size: 12),
                    const SizedBox(width: 4),
                    Text(login['status'] ?? 'active'),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'patient':
        return AppColors.primary;
      case 'doctor':
        return AppColors.secondary;
      case 'nurse':
        return AppColors.accent;
      case 'ambulance':
        return AppColors.error;
      case 'pharmacist':
        return const Color(0xFF9C27B0);
      case 'pathology':
        return const Color(0xFF00BCD4);
      default:
        return AppColors.grey;
    }
  }

  Widget _buildDatabaseInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Database Connection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Database Type', 'MongoDB'),
            _buildInfoRow('Connection', 'mongodb://localhost:27017/ourdeals'),
            _buildInfoRow('Status', 'Connected', color: AppColors.success),
            _buildInfoRow('Backend API', 'http://localhost:5000/api/v1'),
            _buildInfoRow('Total Collections', '12'),
            _buildInfoRow('Last Backup', '2 hours ago'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'How to Access Database:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCommandBox('1. Open MongoDB Compass'),
            _buildCommandBox('2. Connect to: mongodb://localhost:27017'),
            _buildCommandBox('3. Select database: ourdeals'),
            _buildCommandBox('4. View collections: users, bookings, notifications, etc.'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandBox(String command) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.terminal, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              command,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersManagement() {
    return Center(
      child: const Text('Users Management - Coming Soon'),
    );
  }
}
