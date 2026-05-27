class PoinDetail {
  final int idCatatan;
  final String namaCatatan;
  final int poin;
  final String namaGuru;
  final String tanggal;

  PoinDetail({
    required this.idCatatan,
    required this.namaCatatan,
    required this.poin,
    required this.namaGuru,
    required this.tanggal,
  });

  factory PoinDetail.fromJson(Map<String, dynamic> json) {
    return PoinDetail(
      idCatatan: json['id_catatan'] ?? 0,
      namaCatatan: json['nama_catatan'] ?? '',
      poin: json['poin'] ?? 0,
      namaGuru: json['nama_guru'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }
}
