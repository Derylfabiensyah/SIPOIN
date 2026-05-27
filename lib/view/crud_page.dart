import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'data_siswa_page.dart';
import 'jenis_catatan_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _role;

  @override
  void initState() {
    super.initState();
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    _role = authVm.role ?? 'guru';
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE09F8C),
        title: const Text(
          "APLIKASI SISWA",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          labelColor: const Color(0xFFE09F8C),
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: " Data Siswa"),
            Tab(text: " Pelanggaran"),
            Tab(text: " Prestasi"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // TAB 1: DATA SISWA
          DataSiswaPage(),
          // TAB 2: PELANGGARAN
          JenisCatatanPage(tipe: "pelanggaran"),
          // TAB 3: PRESTASI
          JenisCatatanPage(tipe: "prestasi"),
        ],
      ),
    );
  }
}
