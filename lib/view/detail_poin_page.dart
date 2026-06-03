import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/poin_siswa_viewmodel.dart';

class DetailPoinPage extends StatefulWidget {
  final String tipe; // 'pelanggaran' atau 'prestasi'
  final int idSiswa;
  final int totalPoin;

  const DetailPoinPage({
    super.key,
    required this.tipe,
    required this.idSiswa,
    required this.totalPoin,
  });

  @override
  State<DetailPoinPage> createState() => _DetailPoinPageState();
}

class _DetailPoinPageState extends State<DetailPoinPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PoinSiswaViewModel>(context, listen: false)
          .fetchDetailPoin(widget.idSiswa, widget.tipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PoinSiswaViewModel>(context);
    final isPelanggaran = widget.tipe == 'pelanggaran';

    // Theme colors
    final Color accentColor = isPelanggaran
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);
    final Color lightAccent = isPelanggaran
        ? const Color(0xFFFEE2E2)
        : const Color(0xFFDCFCE7);
    final String title = isPelanggaran ? 'Detail Pelanggaran' : 'Detail Prestasi';
    final IconData headerIcon = isPelanggaran
        ? Icons.warning_amber_rounded
        : Icons.emoji_events_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: accentColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header - Total Poin
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPelanggaran
                    ? [const Color(0xFFDC2626), const Color(0xFFEF4444)]
                    : [const Color(0xFF16A34A), const Color(0xFF22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(headerIcon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Poin",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.totalPoin} POIN",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.list_alt_rounded, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Rincian ${isPelanggaran ? 'Pelanggaran' : 'Prestasi'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const Spacer(),
                if (!vm.isLoadingDetail)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: lightAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${vm.detailList.length} catatan",
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Detail List
          Expanded(
            child: vm.isLoadingDetail
                ? Center(
                    child: CircularProgressIndicator(color: accentColor),
                  )
                : vm.detailList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isPelanggaran
                                  ? Icons.check_circle_outline
                                  : Icons.hourglass_empty_rounded,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isPelanggaran
                                  ? "Tidak ada pelanggaran 🎉"
                                  : "Belum ada prestasi tercatat",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: vm.detailList.length,
                        itemBuilder: (context, index) {
                          final item = vm.detailList[index];
                          final tanggalFormatted = _formatTanggal(item.tanggal);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: accentColor.withOpacity(0.08),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Poin Badge
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: lightAccent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${item.poin}",
                                        style: TextStyle(
                                          color: accentColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "poin",
                                        style: TextStyle(
                                          color: accentColor.withOpacity(0.7),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Detail Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaCatatan,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A4A4A),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline_rounded,
                                            size: 14,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "oleh ${item.namaGuru}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: 12,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            tanggalFormatted,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (e) {
      return tanggal.length >= 10 ? tanggal.substring(0, 10) : tanggal;
    }
  }
}
