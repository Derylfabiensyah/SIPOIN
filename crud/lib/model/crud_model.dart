class User {
  final int? id;
  final String nama;
  final String kelas;
  final String nis;
  final String? password;

  User({this.id, required this.nama, required this.kelas, required this.nis, this.password});

  // JSON → Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      nis: json['nis'],
      password: json['password'],
    );
  }

  // Object → JSON (untuk CREATE)
  Map<String, dynamic> toJson() {
    return {'nama': nama, 'kelas': kelas, 'nis': nis, 'password': password};
  }

  // Object → JSON (untuk UPDATE - include ID)
  Map<String, dynamic> toJsonWithId() {
    return {'id': id, 'nama': nama, 'kelas': kelas, 'nis': nis, 'password': password};
  }

  // copyWith untuk update salah satu field
  User copyWith({int? id, String? nama, String? kelas, String? nis, String? password}) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      nis: nis ?? this.nis,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'User(id: $id, nama: $nama, kelas: $kelas, nis: $nis, password: $password)';
}
