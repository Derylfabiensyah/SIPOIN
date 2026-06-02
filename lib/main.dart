import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/viewmodel/crud_viewmodel.dart';
import 'package:crud/viewmodel/jenis_catatan_viewmodel.dart';
import 'package:crud/view/crud_page.dart';
import 'package:crud/repository/crud_repository.dart';
import 'package:crud/service/api_service.dart';
import 'package:crud/view/login_page.dart';
import 'package:crud/viewmodel/auth_viewmodel.dart';
import 'package:crud/viewmodel/catatan_viewmodel.dart';
import 'package:crud/viewmodel/poin_siswa_viewmodel.dart';
import 'package:crud/viewmodel/input_catatan_viewmodel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CrudViewModel(UserRepository(UserService())),
        ),
        ChangeNotifierProvider(create: (_) => JenisCatatanViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CatatanViewModel()),
        ChangeNotifierProvider(create: (_) => PoinSiswaViewModel()),
        ChangeNotifierProvider(create: (_) => InputCatatanViewModel()),
      ],
      child: MaterialApp(
        title: 'SIPOIN',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE09F8C)),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
