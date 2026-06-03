import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/jenis_catatan_viewmodel.dart';
import '../model/jenis_catatan_model.dart';
import '../viewmodel/auth_viewmodel.dart';

void showJenisCatatanForm(BuildContext context, String tipe, {JenisCatatan? item}) {
  final namaController = TextEditingController(text: item?.nama ?? "");
  final deskripsiController = TextEditingController(text: item?.deskripsi ?? "");
  final poinController = TextEditingController(text: item?.poin.toString() ?? "");

  final vm = Provider.of<JenisCatatanViewModel>(context, listen: false);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    item == null ? "Tambah $tipe" : "Edit $tipe",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama $tipe",
                      prefixIcon: const Icon(Icons.label_outline, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: deskripsiController,
                    decoration: InputDecoration(
                      labelText: "Deskripsi",
                      prefixIcon: const Icon(Icons.description_outlined, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: poinController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Poin",
                      prefixIcon: const Icon(Icons.star_outline, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text("Batal", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (namaController.text.isEmpty ||
                                      poinController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Nama dan Poin harus diisi!",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  int? poin = int.tryParse(poinController.text);
                                  if (poin == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Poin harus berupa angka!",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => isSaving = true);

                                  final newItem = JenisCatatan(
                                    id: item?.id,
                                    nama: namaController.text,
                                    deskripsi: deskripsiController.text,
                                    tipe: tipe,
                                    poin: poin,
                                  );

                                  try {
                                    final success = item == null
                                        ? await vm.addData(newItem)
                                        : await vm.updateData(newItem);
                                    if (context.mounted) {
                                      if (success) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Berhasil disimpan!"),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Gagal menyimpan data"),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }
                                  } finally {
                                    if (context.mounted) {
                                      setState(() => isSaving = false);
                                    }
                                  }
                                },
                          child: isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

class JenisCatatanPage extends StatefulWidget {
  final String tipe; // "pelanggaran" / "prestasi"

  const JenisCatatanPage({super.key, required this.tipe});

  @override
  State<JenisCatatanPage> createState() => _JenisCatatanPageState();
}

class _JenisCatatanPageState extends State<JenisCatatanPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<JenisCatatanViewModel>(
        context,
        listen: false,
      ).fetchData(widget.tipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<JenisCatatanViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Daftar ${widget.tipe == 'pelanggaran' ? 'Pelanggaran' : 'Prestasi'}",
          style: const TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        vm.fetchData(widget.tipe);
                      },
                      child: Text("Coba Lagi"),
                    ),
                  ],
                ),
              ),
            )
          : vm.list.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Tidak ada data ${widget.tipe}",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: vm.list.length,
              itemBuilder: (context, index) {
                final item = vm.list[index];

                final isPerlanggaran = widget.tipe == "pelanggaran";
                final badgeColor = isPerlanggaran
                    ? const Color(0xFFDC2626) // Merah
                    : const Color(0xFF16A34A); // Hijau

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () {
                      final role = Provider.of<AuthViewModel>(context, listen: false).role;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: const Color(0xFFDBEAFE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header: Icon + Title
                                  Row(
                                    children: [
                                      Icon(
                                        isPerlanggaran ? Icons.report_problem : Icons.stars,
                                        color: isPerlanggaran ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.nama,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Description Section
                                  const Text(
                                    "Deskripsi:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.deskripsi.isEmpty ? "-" : item.deskripsi,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Points Section
                                  const Text(
                                    "Poin:",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isPerlanggaran ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "+${item.poin}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Footer Actions
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Left: Edit & Hapus (Guru only)
                                      if (role == 'guru')
                                        Row(
                                          children: [
                                            // Edit Button
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                showJenisCatatanForm(context, widget.tipe, item: item);
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.edit, size: 20),
                                                  SizedBox(width: 4),
                                                  Text("Edit", style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Hapus Button
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                // Confirmation Dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text("Konfirmasi"),
                                                    content: Text("Yakin ingin menghapus ${item.nama}?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text("Batal"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          await vm.deleteData(item.id!, widget.tipe);
                                                        },
                                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                        child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.delete, size: 20),
                                                  SizedBox(width: 4),
                                                  Text("Hapus", style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        const SizedBox(),

                                      // Right: Tutup
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Tutup",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPerlanggaran ? Icons.warning_rounded : Icons.emoji_events_rounded,
                        color: badgeColor,
                      ),
                    ),
                    title: Text(
                      item.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    subtitle: Text(
                      item.deskripsi.isEmpty ? "Tidak ada deskripsi" : item.deskripsi,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "+${item.poin}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Provider.of<AuthViewModel>(context, listen: false).role == 'guru'
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2563EB),
              onPressed: () {
                showJenisCatatanForm(context, widget.tipe);
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
