import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  UserModel? _currentUser;
  String _selectedLocation = 'Current Location';
  
  final List<String> _adImages = [
    'https://via.placeholder.com/400x200/4CAF50/FFFFFF?text=Health+Checkup+Offer',
    'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Free+Consultation',
    'https://via.placeholder.com/400x200/FF9800/FFFFFF?text=Medicine+Discount',
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.medication,
      'label': 'Medicine',
      'color': AppColors.primary,
      'type': AppConstants.serviceMedicine,
    },
    {
      'icon': Icons.medical_services,
      'label': 'Doctor',
      'color': AppColors.secondary,
      'type': AppConstants.serviceDoctor,
    },
    {
      'icon': Icons.local_hospital,
      'label': 'Nurse',
      'color': AppColors.accent,
      'type': AppConstants.serviceNurse,
    },
    {
      'icon': Icons.science,
      'label': 'Lab Test',
      'color': Color(0xFF9C27B0),
      'type': AppConstants.serviceLabTest,
    },
    {
      'icon': Icons.airport_shuttle,
      'label': 'Ambulance',
      'color': AppColors.error,
      'type': AppConstants.serviceAmbulance,
    },
  ];

  final List<Map<String, dynamic>> _featuredMedicines = [
    {
      'name': 'Paracetamol 500mg',
      'price': 50,
      'image': 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=Para',
      'prescription': false,
    },
    {
      'name': 'Aspirin 75mg',
      'price': 30,
      'image': 'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=Aspirin',
      'prescription': false,
    },
    {
      'name': 'Cough Syrup',
      'price': 120,
      'image': 'https://via.placeholder.com/100x100/FF9800/FFFFFF?text=Cough',
      'prescription': false,
    },
  ];

  final List<Map<String, dynamic>> _topDoctors = [
    {
      'name': 'Dr. Sarah Smith',
      'specialization': 'Cardiologist',
      'rating': 4.8,
      'distance': 2.3,
      'image': 'https://via.placeholder.com/80x80/4CAF50/FFFFFF?text=SS',
    },
    {
      'name': 'Dr. John Doe',
      'specialization': 'Pediatrician',
      'rating': 4.9,
      'distance': 1.5,
      'image': 'https://via.placeholder.com/80x80/2196F3/FFFFFF?text=JD',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    setState(() => _currentUser = user);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_hospital_rounded, size: 28),
            const SizedBox(width: 8),
            const Text('Onmint'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Selector
            _buildLocationSelector(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Service Icons
            _buildServiceIcons(),
            
            // Advertisements Carousel
            _buildAdvertisements(),
            
            // Featured Medicines
            _buildFeaturedMedicines(),
            
            // Top Doctors
            _buildTopDoctors(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            accountName: Text(
              _currentUser?.fullName ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(_currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.white,
              child: Text(
                _currentUser?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
            onTap: () {
              // TODO: Navigate to orders
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('My Appointments'),
            onTap: () {
              // TODO: Navigate to appointments
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              // TODO: Navigate to favorites
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deliver to',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _selectedLocation,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search medicines, doctors, services...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.greyLight),
          ),
        ),
        onTap: () {
          // TODO: Navigate to search screen
        },
        readOnly: true,
      ),
    );
  }

  Widget _buildServiceIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _services.map((service) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${service['label']} feature coming soon!'),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: service['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    service['icon'],
                    size: 32,
                    color: service['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['label'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdvertisements() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: _adImages.map((url) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedMedicines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Medicines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all medicines
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _featuredMedicines.length,
            itemBuilder: (context, index) {
              final medicine = _featuredMedicines[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(medicine['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${medicine['price']}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopDoctors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Doctors Near You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all doctors
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _topDoctors.length,
          itemBuilder: (context, index) {
            final doctor = _topDoctors[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(doctor['image']),
                ),
                title: Text(
                  doctor['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor['specialization']),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppColors.accent),
                        Text(' ${doctor['rating']}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                        Text(' ${doctor['distance']} km'),
                      ],
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Book appointment
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Book'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
