import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/poin_siswa_viewmodel.dart';
import 'data_siswa_page.dart';
import 'jenis_catatan_page.dart';
import 'login_page.dart';
import 'detail_poin_page.dart';
import 'input_catatan_page.dart';
import '../viewmodel/catatan_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      if (authVm.role == 'guru') {
        Provider.of<CatatanViewModel>(context, listen: false).fetchRecent(userId: authVm.userId);
      } else if (authVm.role == 'siswa' && authVm.userId != null) {
        Provider.of<PoinSiswaViewModel>(context, listen: false).fetchTotalPoin(authVm.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final catatanVm = Provider.of<CatatanViewModel>(context);
    final poinVm = Provider.of<PoinSiswaViewModel>(context);
    final userName = authVm.username ?? "User";
    final role = authVm.role ?? "Siswa";

    // Colors
    final primaryBlue = const Color(0xFF2563EB);
    final secondaryBlue = const Color(0xFFDBEAFE);
    final darkText = const Color(0xFF4A4A4A);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. HEADER SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 24,
                            color: darkText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.logout_rounded, color: primaryBlue),
                        onPressed: () {
                          authVm.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. SUMMARY CARDS (Dinamis berdasarkan Role)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: role == 'guru'
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                "Data Siswa",
                                "Kelola semua data siswa",
                                Icons.people_alt_rounded,
                                primaryBlue,
                                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DataSiswaPage())),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                "Input Catatan",
                                "Input poin pelanggaran atau prestasi siswa",
                                Icons.warning_amber_rounded,
                                const Color(0xFF16A34A),
                                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InputCatatanPage())),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildPointCard(
                              title: "Pelanggaran",
                              points: poinVm.isLoading ? "..." : "${poinVm.totalPelanggaran} POIN",
                              icon: Icons.warning_amber_rounded,
                              gradientColors: [const Color(0xFFDC2626), const Color(0xFFEF4444)],
                              iconBgColor: Colors.white.withOpacity(0.2),
                              onTap: () {
                                if (authVm.userId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPoinPage(
                                        tipe: 'pelanggaran',
                                        idSiswa: authVm.userId!,
                                        totalPoin: poinVm.totalPelanggaran,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPointCard(
                              title: "Prestasi",
                              points: poinVm.isLoading ? "..." : "${poinVm.totalPrestasi} POIN",
                              icon: Icons.emoji_events_rounded,
                              gradientColors: [const Color(0xFF16A34A), const Color(0xFF22C55E)],
                              iconBgColor: Colors.white.withOpacity(0.2),
                              onTap: () {
                                if (authVm.userId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPoinPage(
                                        tipe: 'prestasi',
                                        idSiswa: authVm.userId!,
                                        totalPoin: poinVm.totalPrestasi,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // 3. MENU SECTION TITLE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  "Menu Utama",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),
            ),

            // 4. GRID MENU (Hanya 2 Menu sesuai foto)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildMenuItem(
                    context,
                    "Prestasi",
                    Icons.emoji_events_rounded,
                    const Color(0xFF16A34A),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JenisCatatanPage(tipe: 'prestasi'))),
                  ),
                  _buildMenuItem(
                    context,
                    "Pelanggaran",
                    Icons.gavel_rounded,
                    const Color(0xFF2563EB),
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JenisCatatanPage(tipe: 'pelanggaran'))),
                  ),
                ]),
              ),
            ),


          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 18) return "Selamat Sore";
    return "Selamat Malam";
  }

  Widget _buildSummaryCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointCard({
    required String title,
    required String points,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    points,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
