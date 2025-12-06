import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../models/inventaris_model.dart';
import '../services/inventaris_service.dart';

class EditInventarisScreen extends StatefulWidget {
  final Inventaris inventaris;

  const EditInventarisScreen({
    Key? key,
    required this.inventaris,
  }) : super(key: key);

  @override
  State<EditInventarisScreen> createState() => _EditInventarisScreenState();
}

class _EditInventarisScreenState extends State<EditInventarisScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaBarangController;
  late TextEditingController _hargaController;
  late TextEditingController _jumlahController;
  late TextEditingController _tanggalMasukController;
  final _inventarisService = InventarisService();
  bool _isLoading = false;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _namaBarangController = TextEditingController(text: widget.inventaris.namaBarang);
    _hargaController = TextEditingController(text: widget.inventaris.harga.toString());
    _jumlahController = TextEditingController(text: widget.inventaris.jumlah.toString());
    _selectedDate = DateTime.parse(widget.inventaris.tanggalMasuk);
    _tanggalMasukController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _namaBarangController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _tanggalMasukController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalMasukController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  Future<void> _updateInventaris() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _inventarisService.updateInventaris(
        widget.inventaris.id,
        namaBarang: _namaBarangController.text,
        harga: int.parse(_hargaController.text),
        jumlah: int.parse(_jumlahController.text),
        tanggalMasuk: _tanggalMasukController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barang berhasil diperbarui'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        Navigator.of(context).pop(true);
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Inventaris Jeskris'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: Container(
        color: AppConstants.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaBarangController,
                    decoration: InputDecoration(
                      labelText: 'Nama Barang',
                      hintText: 'Contoh: Laptop Dell',
                      prefixIcon: const Icon(
                        Icons.laptop,
                        color: AppConstants.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: const BorderSide(
                          color: AppConstants.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Nama barang tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga (Rp)',
                      hintText: 'Contoh: 5000000',
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: AppConstants.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: const BorderSide(
                          color: AppConstants.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (int.tryParse(value!) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah (Unit)',
                      hintText: 'Contoh: 10',
                      prefixIcon: const Icon(
                        Icons.inventory_2,
                        color: AppConstants.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: const BorderSide(
                          color: AppConstants.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value!) == null) {
                        return 'Jumlah harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tanggalMasukController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Masuk',
                      hintText: 'Pilih tanggal',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppConstants.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        borderSide: const BorderSide(
                          color: AppConstants.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Tanggal masuk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateInventaris,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Perbarui Barang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
