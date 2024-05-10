import 'package:flutter/material.dart';
import 'dart:async';

import 'package:coa_progress_tracking_app/auth/main_page.dart';
import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for the DB to be initialized
  await SupabaseDB.instance.initDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COA Progress App',
      theme: ThemeData(
        primaryColor: Colors.amber[900],
        scaffoldBackgroundColor: const Color(0xFFEADDC8),
      ),
      home: const MainPage(),
    );
  }
}
