import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final myFocusNode = FocusNode();

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
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: const Center(
          child: Text("To Do"),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Card(
                    color: Colors.cyan[100],
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                        child: Checkbox(
                          onChanged: (taskValue) => {
                            setState(() {
                              db.toDoList[index][1] = !db.toDoList[index][1]!;
                            }),
                            db.updateDataBase(),
                          },
                          value: db.toDoList[index][1],
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                db.toDoList[index][0],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: db.toDoList[index][1]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                db.toDoList.removeAt(index);
                              });
                              db.updateDataBase();
                            },
                          )
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 15),
                    Expanded(
                        child: TextField(
                      focusNode: myFocusNode,
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Digite a próxima tarefa',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_controller.text != '') {
                            setState(() {
                              db.toDoList.add([_controller.text, false]);
                              db.updateDataBase();
                              _controller.text = '';
                              myFocusNode.unfocus();
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
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
