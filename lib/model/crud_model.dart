class User {
  final int? id;
  final String nama;
  final String kelas;
  final String nis;

  User({this.id, required this.nama, required this.kelas, required this.nis});

  // JSON → Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      nis: json['nis'],
    );
  }

  // Object → JSON (untuk CREATE)
  Map<String, dynamic> toJson() {
    return {'nama': nama, 'kelas': kelas, 'nis': nis};
  }

  // Object → JSON (untuk UPDATE - include ID)
  Map<String, dynamic> toJsonWithId() {
    return {'id': id, 'nama': nama, 'kelas': kelas, 'nis': nis};
  }

  // copyWith untuk update salah satu field
  User copyWith({int? id, String? nama, String? kelas, String? nis}) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      nis: nis ?? this.nis,
    );
  }

  @override
  String toString() => 'User(id: $id, nama: $nama, kelas: $kelas, nis: $nis)';
}
