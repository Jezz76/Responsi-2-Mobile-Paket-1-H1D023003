import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../models/inventaris_model.dart';
import '../services/auth_service.dart';
import '../services/inventaris_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _inventarisService = InventarisService();
  final _authService = AuthService();
  List<Inventaris> _inventarisList = [];
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadInventaris();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    print('DEBUG: User data loaded - ${user?.toJson()}');
    if (mounted && user != null) {
      setState(() => _userName = user.name);
      print('DEBUG: Username set to: $_userName');
    }
  }

  Future<void> _loadInventaris() async {
    try {
      final inventaris = await _inventarisService.getInventaris();
      if (mounted) {
        setState(() {
          _inventarisList = inventaris;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteInventaris(int id) async {
    try {
      await _inventarisService.deleteInventaris(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        _loadInventaris();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Komputer Jeskris'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryLightColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pengelola Inventaris',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.inventory_2, color: AppConstants.primaryColor),
                      title: const Text('Data Inventaris'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.errorColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppConstants.backgroundColor,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.primaryColor,
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(AppConstants.paddingMedium),
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Selamat datang, ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                              TextSpan(
                                text: _userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryDarkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppConstants.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Total Barang: ${_inventarisList.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _inventarisList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryLightColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(
                                    Icons.inbox,
                                    size: 48,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada barang',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tambahkan barang baru untuk memulai',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppConstants.paddingMedium),
                            itemCount: _inventarisList.length,
                            itemBuilder: (context, index) {
                              final item = _inventarisList[index];
                              return Card(
                                color: Colors.white,
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppConstants.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.laptop,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    item.namaBarang,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppConstants.primaryDarkColor,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp ${item.harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppConstants.accentColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.inventory_2, size: 14, color: Colors.grey[400]),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.jumlah} unit',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF9E9E9E),
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat('dd MMM yyyy').format(DateTime.parse(item.tanggalMasuk)),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF9E9E9E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppConstants.primaryColor,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              '/edit',
                                              arguments: item,
                                            ).then((_) => _loadInventaris());
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppConstants.errorColor,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                                ),
                                                title: const Text('Hapus Barang'),
                                                content: const Text(
                                                  'Apakah Anda yakin ingin menghapus barang ini?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _deleteInventaris(item.id);
                                                    },
                                                    child: const Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                        color: AppConstants.errorColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add').then((_) => _loadInventaris());
        },
        backgroundColor: AppConstants.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
