import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/pages/home.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbDirectory = await path_provider.getApplicationDocumentsDirectory();

  Hive.init('${dbDirectory.path}mybox');
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      home: Home(),
      //theme:
    );
  }
}
