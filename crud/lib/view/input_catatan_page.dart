import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/input_catatan_viewmodel.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/catatan_viewmodel.dart';

class InputCatatanPage extends StatefulWidget {
  const InputCatatanPage({super.key});

  @override
  State<InputCatatanPage> createState() => _InputCatatanPageState();
}

class _InputCatatanPageState extends State<InputCatatanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InputCatatanViewModel>(context, listen: false).fetchSiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InputCatatanViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);

    // Theme Colors
    final primaryColor = const Color(0xFF2563EB);
    final backgroundColor = const Color(0xFFF0F4FF);
    final cardColor = Colors.white;
    final textColor = const Color(0xFF4A4A4A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: primaryColor),
          onPressed: () {
            vm.resetForm();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Input Catatan",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isLoading && vm.listSiswa.isEmpty
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Form Input Poin Siswa",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Pilih siswa dan jenis catatan yang akan diberikan.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 1. Dropdown Siswa
                    _buildLabel("Pilih Siswa"),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: vm.selectedSiswaId,
                      decoration: _inputDecoration(primaryColor),
                      hint: const Text("Pilih Nama Siswa"),
                      items: vm.listSiswa.map((siswa) {
                        return DropdownMenuItem<String>(
                          value: siswa['id'].toString(),
                          child: Text("${siswa['nis']} - ${siswa['nama']}"),
                        );
                      }).toList(),
                      onChanged: (value) => vm.setSelectedSiswa(value),
                    ),
                    const SizedBox(height: 24),

                    // 2. Tipe Catatan
                    _buildLabel("Tipe Catatan"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRadioTile(
                            title: "Pelanggaran",
                            value: "pelanggaran",
                            groupValue: vm.selectedTipe,
                            color: const Color(0xFFDC2626),
                            onChanged: (value) => vm.setSelectedTipe(value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRadioTile(
                            title: "Prestasi",
                            value: "prestasi",
                            groupValue: vm.selectedTipe,
                            color: const Color(0xFF16A34A),
                            onChanged: (value) => vm.setSelectedTipe(value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Dropdown Jenis Catatan
                    _buildLabel("Jenis Catatan"),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: vm.selectedJenisId,
                      decoration: _inputDecoration(primaryColor),
                      hint: Text(vm.selectedTipe == null 
                          ? "Pilih Tipe Catatan Dulu" 
                          : "Pilih Rincian Catatan"),
                      items: vm.listJenis.map((jenis) {
                        return DropdownMenuItem<String>(
                          value: jenis['id_jenis'].toString(),
                          child: Text("${jenis['nama']} (${jenis['poin']} Poin)"),
                        );
                      }).toList(),
                      onChanged: vm.selectedTipe == null ? null : (value) => vm.setSelectedJenis(value),
                    ),
                    const SizedBox(height: 40),

                    // 4. Button Submit
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: vm.isSubmitting ? null : () async {
                          if (vm.selectedSiswaId == null || vm.selectedJenisId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lengkapi form terlebih dahulu!')),
                            );
                            return;
                          }

                          if (authVm.userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal mendapatkan ID Guru')),
                            );
                            return;
                          }

                          final success = await vm.submit(authVm.userId!);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Catatan berhasil disimpan!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Refresh recent activity on dashboard
                            Provider.of<CatatanViewModel>(context, listen: false)
                                .fetchRecent(userId: authVm.userId);
                            Navigator.pop(context);
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menyimpan catatan!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: vm.isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Simpan Catatan",
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A4A4A),
      ),
    );
  }

  InputDecoration _inputDecoration(Color primaryColor) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String value,
    required String? groupValue,
    required Color color,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'pelanggaran' ? Icons.warning_amber_rounded : Icons.emoji_events_rounded,
              color: isSelected ? color : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
