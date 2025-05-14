import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:local_storage/models/boxes.dart';
import 'package:local_storage/models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // key yang digunakan untuk mengidentifikasi dan mengelola status form di widget Form
  validated() { // ini bertujuan untuk memeriksa apakah form yang sudah diisi valid atau tidak, ini akan ngecek semua form, inilah keuntungan pake form key
    if (_formKey.currentState != null && _formKey.currentState!.validate()) { // Ini memeriksa apakah form sudah diisi dengan data yang valid (bukan kosong, sesuai aturan validator).
      _onFormSubmit();
      print("form validated");
    } else {
      print("form unvalidated");
      return;
    }
  }
   // variable late ini berfungsi untuk agar bisa mengisi data nanti setelah pengguna ngisi form, jadi sesuai namanya late/terlambat
  late String title;
  late String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add todo"), centerTitle: true,),
      body: Form( // Form adalah widget yang berfungsi untuk mengelompokkan beberapa TextFormField dan memungkinkan melakukan validasi terhadap keseluruhan form. Kalau nggak pakai Form,  perlu validasi dan kontrol tiap field secara manual, yang lebih ribet.
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(labelText: "Title"),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(labelText: "Description"),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                ),
                onPressed: () {
                  validated();
                },
                child: Text("Add Todo"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    Box<Todo> todoBox = Hive.box<Todo>(HiveBoxes.todo);
    todoBox.add(Todo(title: title, description: description));
    Navigator.of(context).pop(); 
    print(todoBox);
  }
}
