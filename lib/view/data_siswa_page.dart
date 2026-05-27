import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/crud_viewmodel.dart';
import '../model/crud_model.dart';
import '../viewmodel/auth_viewmodel.dart';

void showUserForm(BuildContext context, {User? user}) {
  final namaController = TextEditingController(text: user?.nama ?? '');
  final kelasController = TextEditingController(text: user?.kelas ?? '');
  final nisController = TextEditingController(text: user?.nis ?? '');

  final vm = Provider.of<CrudViewModel>(context, listen: false);

  showModalBottomSheet(
    context: context,
    backgroundColor: Color(0xffeeeeee),
    isScrollControlled: true, // ⬅️ penting biar ikut keyboard
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      bool isSaving = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Judul
                  Text(
                    user == null ? "Tambah Data" : "Edit Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  // 🔹 Input
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  TextField(
                    controller: kelasController,
                    decoration: InputDecoration(
                      labelText: "Kelas",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  TextField(
                    controller: nisController,
                    decoration: InputDecoration(
                      labelText: "NIS",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🔹 Tombol
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Batal"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (namaController.text.isEmpty ||
                                      kelasController.text.isEmpty ||
                                      nisController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          " Semua field harus diisi!",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => isSaving = true);

                                  final newUser = User(
                                    id: user?.id,
                                    nama: namaController.text,
                                    kelas: kelasController.text,
                                    nis: nisController.text,
                                  );

                                  try {
                                    if (user == null) {
                                      await vm.addUser(newUser);
                                    } else {
                                      await vm.editUser(newUser);
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(" Berhasil disimpan!"),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(" Error: $e")),
                                    );
                                  } finally {
                                    if (context.mounted) {
                                      setState(() => isSaving = false);
                                    }
                                  }
                                },
                          child: isSaving
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text("Simpan"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class DataSiswaPage extends StatelessWidget {
  const DataSiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final vm = Provider.of<CrudViewModel>(context);
    final _role = authVm.role ?? 'guru';

    if (_role != 'guru') {
      return Scaffold(
        body: Center(
          child: Text(
            'Anda tidak ada izin untuk buka halaman ini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFE09F8C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Data Siswa",
          style: TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: vm.users.length,
            itemBuilder: (context, index) {
              final user = vm.users[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE09F8C).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Color(0xFFE09F8C)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kelas: ${user.kelas} • NIS: ${user.nis}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_role == 'guru')
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blueGrey, size: 20),
                            onPressed: () => showUserForm(context, user: user),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Konfirmasi"),
                                  content: Text("Yakin ingin menghapus ${user.nama}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Batal", style: TextStyle(color: Colors.black)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        if (user.id != null) {
                                          await vm.removeUser(user.id!);
                                        }
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Data berhasil dihapus")),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                      child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE09F8C),
        onPressed: () {
          showUserForm(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
