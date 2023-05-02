import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/util/task_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = TextEditingController();
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  /*List<MyTasks> myTaskList = [
    MyTasks('primeira tarefa', false),
  ];*/

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("To Do"),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    leading: Checkbox(
                      onChanged: (value) => {
                        setState(() {
                          db.toDoList[index][1] = !db.toDoList[index][1]!;
                        }),
                      },
                      value: db.toDoList[index][1],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(db.toDoList[index][0]),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                db.toDoList.removeAt(index);
                              });
                              db.updateDataBase();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 8, 8),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Digite a próxima tarefa',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_controller.text != '') {
                          setState(() {
                            db.toDoList.add([_controller.text, false]);
                            db.updateDataBase();
                            _controller.text = '';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.cyan,
                      ),
                      child: const Center(child: Icon(Icons.add)),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
