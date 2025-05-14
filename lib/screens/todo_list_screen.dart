import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage/models/boxes.dart';
import 'package:local_storage/models/todo.dart';
import 'package:local_storage/screens/add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  // digunakan untuk menonaktifkan hive (tutup koneksi ke database) yang masih aktif saat widget udah nonaktif / pindah ke screen lain, untuk menghindari memory leak,dll
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List"),
       centerTitle: true,
       ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ValueListenableBuilder(
          // widget yang mendengarkan perubahan data "value listenable", dimana kasusnya adalah Hive/db Todo, fungsinya agar data di listview selalu up to date tanpa harus memanggil set state.
          valueListenable: Hive.box<Todo>(HiveBoxes.todo).listenable(),
          builder: (context, Box<Todo> box, _) {
            if (box.values.isEmpty) {
              return Center(child: Text("Todo listing is empty"));
            }
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Todo? result = box.getAt(index);  // mengambil data dari box berdasarkan index/urutannya
                return Dismissible(
                  key: UniqueKey(), // generate key yang unik dari bawaan funct flutter, Biar saat widget dihapus dari list, Flutter tahu persis widget mana yang dihapus
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      result.delete();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Deleted")));
                    }
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(result!.title),
                    subtitle: Text(result.description),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Todo",
        onPressed:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodoScreen()),
              ),
            },
      ),
    );
  }
}
