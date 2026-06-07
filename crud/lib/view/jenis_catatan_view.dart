import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/jenis_catatan_viewmodel.dart';

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
      Provider.of<JenisCatatanViewModel>(context, listen: false)
          .fetchData(widget.tipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<JenisCatatanViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Jenis ${widget.tipe}"),
      ),

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: vm.list.length,
              itemBuilder: (context, index) {
                final item = vm.list[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      item.nama,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.deskripsi),

                    // 🔥 Badge poin
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.tipe == "pelanggaran"
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "+${item.poin}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}