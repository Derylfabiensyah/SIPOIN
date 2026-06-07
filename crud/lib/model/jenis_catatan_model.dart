class JenisCatatan {
  final int? id;
  final String nama;
  final String deskripsi;
  final int poin;
  final String tipe; // "pelanggaran" atau "prestasi"

  JenisCatatan({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.poin,
    required this.tipe,
  });

  // JSON → Object
  factory JenisCatatan.fromJson(Map<String, dynamic> json) {
    return JenisCatatan(
      id: json['id_jenis'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      poin: json['poin'],
      tipe: json['tipe'],
    );
  }

  // Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'poin': poin,
      'tipe': tipe,
    };
  }

  @override
  String toString() =>
      'JenisCatatan(id: $id, nama: $nama, deskripsi: $deskripsi, poin: $poin, tipe: $tipe)';
}
