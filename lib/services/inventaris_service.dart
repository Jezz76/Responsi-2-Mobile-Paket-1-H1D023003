import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/app_constants.dart';
import '../models/inventaris_model.dart';

class InventarisService {
  final http.Client httpClient = http.Client();
  late SharedPreferences _prefs;
  bool _initialized = false;

  InventarisService();

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      _initialized = false;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  /// Get token dari storage
  Future<String?> _getToken() async {
    await _ensureInitialized();
    return _prefs.getString(AppConstants.tokenKey);
  }

  /// Get semua inventaris user
  Future<List<Inventaris>> getInventaris() async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silahkan login kembali.');
      }

      final response = await httpClient.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.inventarisEndpoint}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          List<Inventaris> inventaris = [];
          for (var item in jsonResponse['data']) {
            inventaris.add(Inventaris.fromJson(item));
          }
          return inventaris;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Gagal mengambil data');
        }
      } else {
        throw Exception('Failed to load inventaris. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get detail inventaris berdasarkan ID
  Future<Inventaris> getInventarisById(int id) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silahkan login kembali.');
      }

      final response = await httpClient.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.inventarisEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Inventaris.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Gagal mengambil data');
        }
      } else {
        throw Exception('Failed to load inventaris detail. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Tambah inventaris baru
  Future<Inventaris> createInventaris({
    required String namaBarang,
    required int harga,
    required int jumlah,
    required String tanggalMasuk,
  }) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silahkan login kembali.');
      }

      final response = await httpClient.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.inventarisEndpoint}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama_barang': namaBarang,
          'harga': harga,
          'jumlah': jumlah,
          'tanggal_masuk': tanggalMasuk,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Inventaris.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Gagal membuat inventaris');
        }
      } else {
        throw Exception('Failed to create inventaris. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Update inventaris
  Future<Inventaris> updateInventaris(
    int id, {
    required String namaBarang,
    required int harga,
    required int jumlah,
    required String tanggalMasuk,
  }) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silahkan login kembali.');
      }

      final response = await httpClient.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.inventarisEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama_barang': namaBarang,
          'harga': harga,
          'jumlah': jumlah,
          'tanggal_masuk': tanggalMasuk,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Inventaris.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Gagal update inventaris');
        }
      } else {
        throw Exception('Failed to update inventaris. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Hapus inventaris
  Future<void> deleteInventaris(int id) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silahkan login kembali.');
      }

      final response = await httpClient.delete(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.inventarisEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete inventaris. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
