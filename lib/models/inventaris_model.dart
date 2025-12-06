class Inventaris {
  final int id;
  final String namaBarang;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Inventaris({
    required this.id,
    required this.namaBarang,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    this.createdAt,
    this.updatedAt,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      harga: json['harga'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
    };
  }
}
