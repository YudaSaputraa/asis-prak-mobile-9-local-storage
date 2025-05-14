import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_storage/models/boxes.dart';
import 'package:local_storage/models/todo.dart';
import 'package:local_storage/screens/todo_list_screen.dart';

void main() async {
  // jadi hive itu menyimpan format data itu secara binary, naah adapter itu fungsinya mengubah objek2/data2 itu menjadi binary yang dapat disimpan di box.
  // inisialisasi hive dulu semenjak aplikasi dijalankan pertamakali
  await Hive.initFlutter();
  // mendaftarkan adapter yang diperlukan untuk model tertentu. Dalam hal ini, adapter untuk model todo
  Hive.registerAdapter(TodoAdapter()); 
  // membuka sebuah box yang dapat digunakan untuk menyimpan dan mengambil data. Dalam hal ini, kita membuka box yang berisi objek Todo.
  await Hive.openBox<Todo>(HiveBoxes.todo); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TodoListScreen(),
    );
  }
}
